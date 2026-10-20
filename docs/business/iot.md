# IoT 设备接入与规则模块业务知识

> 本文根据当前工作区的 Controller、ServiceImpl、DO、枚举、网关代码和静态调用关系整理；未启动 MQTT/网关、未连接 MySQL、Redis 或 TDengine，未向真实设备下发指令。配套材料：[推导 DDL](../../sql/mysql/iot.sql) · [ER 图](../er/iot-er.drawio)。本文中的“上报、下发、告警、执行”表示源码存在对应路径，不表示设备协议、网络连接或数据一致性已经实际验证。

## 技术栈、服务模块与主要作用

| 项目 | 当前代码依据 |
| --- | --- |
| 后端服务 | `yudao-module-iot-server；辅助接入单元：yudao-module-iot-gateway`（[pom.xml](../../yudao-module-iot/yudao-module-iot-server/pom.xml)）；Gateway 配置见 [pom.xml](../../yudao-module-iot/yudao-module-iot-gateway/pom.xml) |
| 基础技术栈 | Java 17、Spring Boot 3.5.15、Maven、MyBatis、Redis、租户/安全、模块 RPC、Nacos 服务发现与配置。 |
| 模块专项依赖 | TDengine JDBC、Quartz、MQTT Paho、RocketMQ、Kafka、AMQP、OkHttp；另含 IoT Core 与 Gateway 模块。 |
| 主要作用 | 管理物联网产品、物模型、设备、属性、规则、告警、OTA 和外部数据流转；设备协议接入由 Gateway 协作。 |

## 1. 定位与数据边界

IoT 模块把产品、物模型、设备、网关拓扑、Modbus 点位、设备消息、属性时序、OTA 和规则引擎放在同一业务域：管理端定义什么设备和属性，设备侧经网关认证与收发消息，服务端把属性写入时序库并据消息匹配数据流转、场景和告警规则。

本模块 SQL 仅覆盖 MySQL 中的配置/主数据/任务表。**设备属性历史并不存入 `iot_*` MySQL 表**：代码使用 TDengine mapper 维护产品超级表、设备子表与属性记录，Redis 保存最新属性及部分设备缓存。因此 ER 图不能把 TDengine 时序表画作当前 DDL 的关系表，也不能以 `iot_device` 一张表解释全部遥测数据。[属性建表与写入](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/device/property/IotDevicePropertyServiceImpl.java:89) · [属性历史查询](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/device/property/IotDevicePropertyServiceImpl.java:215)

设备协议接入、消息 Broker、TDengine、Redis、第三方数据目的地均属于外部或基础设施边界。本模块包含 `iot-gateway` 的认证/编解码/发送调用，但这不等于源码实现了一个完整 MQTT Broker 或能保证离线命令投递。

## 2. 业务域和核心能力

| 业务域 | 核心对象 | 业务职责 |
| --- | --- | --- |
| 产品和分类 | `iot_product_category`、`iot_product` | 定义产品分类、产品 Key/Secret、设备类型、发布/启停等基础信息；产品是设备和物模型的归属。 |
| 物模型 | `iot_thing_model` | 为产品定义属性、事件、服务及标识符、数据规格；属性用于属性表结构和上报值转换，服务用于设备调用描述。 |
| 设备与分组 | `iot_device`、`iot_device_group` | 维护设备名称、序列号、密钥、状态、位置、产品和分组；支持直连设备、网关和子设备拓扑。 |
| Modbus | `iot_device_modbus_config`、`iot_device_modbus_point` | 为设备保留 Modbus 通信参数、点位和物模型映射；点位配置不是实时采集数据本身。 |
| 消息与属性 | 网关消息 DTO、TDengine、Redis | 网关对设备消息序列化/反序列化/发送；上报属性按物模型转换后写时序库，最新值进入 Redis。 |
| 数据/场景规则 | `iot_data_rule`、`iot_data_sink`、`iot_scene_rule` | 数据规则将命中消息交给启用的数据目的地；场景规则按设备消息或定时触发评估条件、执行动作。 |
| 告警 | `iot_alert_config`、`iot_alert_record` | 告警配置和处理记录；场景规则可按触发配置创建告警记录，人工可标记处理和备注。 |
| OTA | `iot_ota_firmware`、`iot_ota_task`、`iot_ota_task_record` | 管理固件、选定设备创建升级任务、记录每台设备升级结果，取消任务或汇总结束状态。 |
| 统计 | 管理端统计接口 | 汇总产品、设备、状态和消息等指标；统计结果不是额外业务主数据。 |

## 3. 核心对象及关系

`iot_product_category → iot_product → iot_device` 是产品主数据链。`iot_thing_model.product_id` 定义同产品下可识别的属性/事件/服务；物模型变更会清理缓存，并驱动 Modbus 点位映射或属性时序表字段同步。物模型的复杂结构、数组值在 TDengine 中会按 JSON/VARCHAR 等方式转换，不能把其 JSON 规格当成关系型子表。[物模型值转换](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/thingmodel/IotThingModelServiceImpl.java:189)

设备可属于 `iot_device_group`，并可通过 `gateway_id` 构成网关—子设备拓扑。设备的序列号和产品 Key/设备名用于认证与缓存定位；网关离线时服务会处理其子设备状态，绑定/解绑和拓扑上报不是简单更新一列。[设备创建、认证与拓扑入口](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/device/IotDeviceServiceImpl.java:90) · [拓扑添加](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/device/IotDeviceServiceImpl.java:645)

数据规则可以关联多个来源配置、物模型标识符和数据目的地；场景规则以产品/设备、触发和条件/动作 JSON 描述匹配逻辑；告警记录再关联告警配置、场景规则和设备。OTA 任务关联固件、产品和选中的设备范围，每条任务记录对应一个目标设备。

## 4. 端到端流程

### 4.1 定义产品、物模型并准备属性时序结构

1. 管理员创建产品分类和产品，系统生成产品 secret；产品状态会参与设备注册/使用校验。
2. 在 `/iot/thing-model` 为产品维护属性、事件和服务。属性标识符与数据类型决定后续上报字段的映射。
3. 发布产品或执行同步时，产品服务调用属性服务，以该产品的“属性型”物模型生成 TDengine 超级表字段定义。
4. 数据类型按映射转换为 TDengine `INT/FLOAT/DOUBLE/TINYINT/VARCHAR/TIMESTAMP` 等；STRUCT、ARRAY 以 JSON 文本保存。
5. 物模型更新/删除会校验关联关系、更新 Modbus 点位映射并清理产品物模型缓存。TDengine DDL 是否成功、已有表迁移策略和数据库权限需要在部署环境验证。

[产品创建/发布](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/product/IotProductServiceImpl.java:53) · [字段映射](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/device/property/IotDevicePropertyServiceImpl.java:55)。

### 4.2 设备注册、认证与网关子设备拓扑

1. 管理员可手工创建或导入设备；服务校验产品、设备类型、序列号唯一性等，初始化设备 secret 和状态。
2. 设备/网关以产品 Key、设备名/序列号和密钥等认证信息请求网关服务，认证通过后可更新在线状态和服务节点信息。
3. 网关绑定子设备前，服务检查网关设备存在、目标为可绑定子设备且没有冲突父网关。
4. 网关收到拓扑添加、删除、查询或子设备注册消息时，服务更新设备拓扑并向网关侧发送拓扑变更通知。
5. 网关离线处理会影响其下设备状态；具体在线判定依赖心跳/上报与调度实现，不能从状态字段推断真实网络连通性。

[设备参数及唯一性校验](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/device/IotDeviceServiceImpl.java:94) · [网关消息编解码/发送](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-gateway/src/main/java/cn/iocoder/yudao/module/iot/gateway/service/device/message/IotDeviceMessageServiceImpl.java:41)。

### 4.3 设备属性上报、最新值和历史查询

1. 设备消息到达服务端后，设备属性服务只处理符合约定 data 结构的上报；空数据、未知标识符或错误类型会记录错误并跳过该属性。
2. 服务从缓存读取产品物模型，按标识符找到属性型物模型，再根据数据规格转换上报值。
3. 合法属性写入设备对应的 TDengine 子表；同批最新属性也写 Redis，设备上报时间/服务节点异步更新到设备记录。
4. 若属性中含符合约定的地理坐标，服务可解析并更新设备位置。
5. 管理端通过最新属性接口读取 Redis，通过历史接口读取 TDengine；它们不是 MySQL `iot_device` 上的完整历史快照。

[属性保存和过滤](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/device/property/IotDevicePropertyServiceImpl.java:136) · [位置提取](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/device/property/IotDevicePropertyServiceImpl.java:260)。

### 4.4 数据流转、场景动作与告警

1. 管理员创建数据目的地并启停，再创建数据规则，规则保存来源产品/设备/消息方法/标识符和多个目的地；创建时校验目的地与物模型标识符存在。
2. 一条设备消息到来后，数据规则服务按设备、方法和标识符从缓存匹配规则，避免同一目的地对同条消息重复执行。
3. 对命中的启用目的地，服务执行对应 sink action；单个规则/目的地异常写日志并继续处理其他项目，因此“规则匹配”不等于所有下游已成功送达。
4. 场景规则可由设备消息或定时器触发，校验触发条件组，执行场景动作并更新最后触发时间。
5. 符合告警配置的场景动作创建 `iot_alert_record`；管理员可批量标记已处理并留下处理备注。

[数据规则匹配/异常隔离](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/rule/data/IotDataRuleServiceImpl.java:214) · [场景规则执行](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/rule/scene/IotSceneRuleServiceImpl.java:200) · [告警创建](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/alert/IotAlertRecordServiceImpl.java:56)。

### 4.5 固件发布与 OTA 任务

1. 管理员上传并维护固件版本，选择产品、固件和设备范围创建 OTA 任务。
2. 服务校验固件/产品和设备选取范围，写 `iot_ota_task` 及各设备的 `iot_ota_task_record`。
3. 设备侧收到升级相关消息并反馈后，任务记录更新设备级状态、进度或结果；任务服务可据记录决定任务是否结束。
4. 管理员可以取消未完成任务；取消不表示设备已经回滚固件，也不能从任务主状态推断每台设备状态相同。
5. 控制器可分别分页查看任务和任务记录，用于定位失败设备。

[任务创建与范围校验](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/ota/IotOtaTaskServiceImpl.java:55) · [设备范围校验](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/ota/IotOtaTaskServiceImpl.java:114)。

## 5. 状态规则、跨模块协作与典型场景

产品、规则、目的地和场景规则均有启停控制；设备另有在线/离线等连接状态，不能将“产品启用”理解为设备一定在线。数据规则执行会跳过禁用 sink；场景规则按条件组匹配；告警记录有未处理/处理状态；OTA 主任务与设备记录分别表达汇总和逐设备结果。

- 模块内部通过缓存读取产品、物模型、设备和规则，设备消息会穿过网关、设备、属性、规则与告警服务。
- 与 **system** 的用户、租户、操作审计继承通用基础设施；没有证据显示 system 用户是设备拥有者模型的唯一来源。
- 与 **TDengine** 的协作是属性历史、产品超级表和设备子表；与 **Redis** 的协作是最新属性/缓存；两者都不在推导 MySQL DDL。
- 数据目的地、HTTP/MQ 等外部动作具体由 sink 实现决定，不能把 `iot_data_sink` 当成已经传输成功的日志。

典型场景：维护温湿度产品的物模型后注册多台设备；网关批量绑定子设备并上报拓扑；设备上报属性后查看最新值和历史曲线；规则将异常指标送给外部目的地并触发告警；对某产品设备发起固件升级并按任务记录跟踪失败设备。

## 6. 已实现局限和验证边界

- 当前 MySQL DDL 中没有设备属性历史表；TDengine 表结构、保留策略、性能、迁移和数据一致性必须独立验证。
- 未从静态代码证明任一种真实协议 Broker、设备证书、网络重连、消息 QoS 或离线指令缓存已经部署可用。
- 数据规则/场景规则的 JSON 配置和 sink/action 的外部依赖可能失败；代码会记录部分异常，业务上仍需监控、重试与幂等策略验证。
- 固件文件存储、下载鉴权、设备端校验、分批节流、断点续传和回滚并不能仅由 OTA 表存在推出。
- Modbus 点位维护了配置映射，具体轮询周期、串口/TCP 连接和现场协议兼容性需要真实设备验证。

## 7. Controller 包接口覆盖与源码入口

所有入口位于 `controller/admin`，按包覆盖本次扫描到的全部 Controller：

| 包 | 控制器 | 路由能力 |
| --- | --- | --- |
| `product` | IotProductCategory、IotProduct | 分类树、产品增改删查、启停、同步/发布相关管理 |
| `thingmodel` | IotThingModel | 属性/事件/服务物模型的增改删查、分页和列表 |
| `device` | IotDevice、IotDeviceGroup、IotDeviceMessage、IotDeviceProperty、IotDeviceModbusConfig、IotDeviceModbusPoint | 设备/分组、设备消息、最新/历史属性、Modbus 通信及点位配置 |
| `alert` | IotAlertConfig、IotAlertRecord | 告警配置、告警记录分页和处理 |
| `rule` | IotDataRule、IotDataSink、IotSceneRule | 数据流转规则、目的地、场景规则的维护与启停 |
| `ota` | IotOtaFirmware、IotOtaTask、IotOtaTaskRecord | 固件、升级任务及逐设备记录 |
| `statistics` | IotStatistics | 产品/设备/消息等统计查询 |

推荐从 [IotProductServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/service/product/IotProductServiceImpl.java:53) → `IotThingModelServiceImpl` → `IotDeviceServiceImpl` → `IotDevicePropertyServiceImpl` → 数据/场景规则 → OTA 依次阅读；网关代码和 TDengine mapper 需要作为外部边界单独验证。
