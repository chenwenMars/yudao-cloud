# WMS 仓储管理业务知识

> 本文依据当前工作区的 Controller、ServiceImpl、DO、枚举、Mapper 与实际调用路径作静态源码分析。未启动服务、未调用接口、未连接数据库；事务、锁、权限、SQL 兼容性及页面交互尚未作运行时验证。文中的“执行”指代码路径具有对应实现，不代表线上已验证。

配套材料：[完整 ER 图](../er/wms-er.drawio) · [MySQL DDL 推导稿](../../sql/mysql/wms.sql) · [关联证据与分区](../er/module-data/wms.json)。DDL 中的物理类型有推断成分，不能据此反推真实生产库约束。

## 技术栈、服务模块与主要作用

| 项目 | 当前代码依据 |
| --- | --- |
| 后端服务 | `yudao-module-wms-server`（[pom.xml](../../yudao-module-wms/yudao-module-wms-server/pom.xml)） |
| 基础技术栈 | Java 17、Spring Boot 3.5.15、Maven、MyBatis、Redis、租户/安全、模块 RPC、Nacos 服务发现与配置。 |
| 模块专项依赖 | System/WMS API、Excel 与监控 starter。 |
| 主要作用 | 维护仓储主数据，处理收货、发货、移库、盘点、库存余额和库存流水。 |

## 1. 模块解决什么问题

WMS 提供一套以“商品 SKU + 仓库”为库存维度的独立仓储单据系统：维护商品、分类、品牌、往来企业与仓库，通过入库、出库、移库、盘库四种单据改变余额，并保留每次变化前后的库存流水。

它适合学习“基础资料 → 业务单据 → 统一库存写入 → 库存及流水查询”的完整责任链。仓管人员建立草稿，核对明细后调用完成接口；完成动作才真正影响库存。业务主管可以从首页查看四类单据状态、按业务日期的数量趋势及库存分布。

代码没有引入单独的收货员、复核员审批流。操作权限使用 Controller 上的权限表达式控制；不能把具有完成权限的操作者理解为系统实现了多级审批角色。

### 与其他库存实现的边界

| 对比对象 | WMS 当前实现 | 交接时应避免的混淆 |
| --- | --- | --- |
| MES 内置仓储 `mes_wm_*` | WMS 只使用 `wms_item*`、`wms_warehouse`、`wms_inventory*` | MES 的物料、批次、库区库位、质量状态、生产报工消耗没有自动映射到 WMS |
| ERP 库存 | 本模块单据直接调用自己的 `WmsInventoryService` | 未发现四类单据自动向 ERP 库存、采购或销售 API 过账的调用 |
| 商城商品 | 商品和 SKU 来自 WMS 自己的主数据 | 同名 SKU 不是商城 SKU 的外键；没有据此共享库存 |
| system 用户 | 列表和详情可查用户 API 补充创建人、更新人昵称 | 用户名称展示依赖不代表库存由 system 模块管理 |

当前 `yudao-module-wms-api` 中是常量与枚举，本次扫描未发现面向其他业务模块的库存 RPC API 实现。模块之间是否存在外围同步，需要另查调用方或集成工程，不能从字段名推出。

## 2. 按业务域理解能力

### 2.1 商品、SKU、分类和品牌

商品是业务描述主体，SKU 是库存和单据真正引用的对象。创建商品时在同一事务内保存商品及 SKU 列表，更新商品时对 SKU 做差异更新；SKU Controller 主要提供分页选品，SKU 的维护入口在商品保存请求中。

- 商品保存校验编码、名称唯一性，并校验分类及可选品牌存在。
- 每个商品至少要有一个 SKU，同一批 SKU 名称不能重复。
- 删除或差异更新移除 SKU 时，先检查四类单据是否引用，再检查是否有库存记录。
- 品牌被商品使用时不能删除；分类有子分类或商品时不能删除。
- 分类是父子结构，服务校验父节点存在、不能以自己为父节点、不能形成祖先循环；同父节点下名称查重。

这些约束保护已经发生业务的 SKU 身份，不能把“库存数量归零”理解为 SKU 就可以删除。删除校验检查的是库存记录数量。

源码：[商品与 SKU 同事务保存](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/md/item/WmsItemServiceImpl.java:47)，[SKU 至少一条及已使用校验](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/md/item/WmsItemSkuServiceImpl.java:149)。

### 2.2 往来企业和仓库

往来企业统一容纳客户、供应商、客户兼供应商三种类型，枚举值分别为 1、2、3。入库单的可选往来企业必须可作供应商，出库单的可选往来企业必须可作客户；它不是 CRM 客户档案，也没有本模块内的合同、应收应付或结算流程。

仓库保存时校验名称和编码唯一。仓库被库存记录或四类单据引用时不能删除。往来企业被入库、出库单引用时不能删除。这里的“仓库”是一层维度，没有 WMS 自己的库区、库位、批次表。

源码：[供应商/客户类型校验](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/md/merchant/WmsMerchantServiceImpl.java:124)，[仓库使用检查](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/md/warehouse/WmsWarehouseServiceImpl.java:116)。

### 2.3 入库与出库

入库和出库都是“主单 + 明细列表”。主单保存业务日期、仓库、单号、类型及可选往来企业；明细保存 SKU、数量、单价和行金额。明细的仓库来自主单，服务会覆盖请求中可能携带的仓库值。

草稿可以一次保存和修改整张单据；明细接口提供按主单查询，不单独暴露逐行写接口。更新时对比新旧明细 ID，形成新增、更新和删除三组；请求不能用陌生明细 ID 伪装新增行。

主单汇总数量及金额。行金额有输入时使用输入值，没有输入时按单价乘数量计算；因此不能把单价与数量乘积视为任何场景都强制覆盖行金额。

入库完成把正数数量传入库存服务，出库完成把数量及对应金额取负后传入。两者共用库存写入过程，不各自维护余额。

源码：[入库完成与状态条件更新](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/order/receipt/WmsReceiptOrderServiceImpl.java:106)，[出库转换为负数变动](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/order/shipment/WmsShipmentOrderServiceImpl.java:229)。

### 2.4 移库

移库单保存来源仓库、目标仓库和 SKU 明细。完成时为每条明细构造两次变动：来源仓负数、目标仓正数，两个变动都挂同一张移库单，`order_type=3`。

所以在流水中，移库应按同一业务单据查出成对记录；不能只看某一个仓库的负数就认定是出库单。这里没有“先出库、在途、再收货”的分阶段移库状态，当前实现是在同一完成事务内调整两端库存。

源码：[成对构造移库库存变化](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/order/movement/WmsMovementOrderServiceImpl.java:222)。

### 2.5 盘库

盘库明细同时带账面数量和实盘数量，可携带原库存记录 ID。完成时库存服务重新锁定余额行，检查 SKU、仓库和当前账面数量与明细快照一致；期间发生了其他库存变动时，报“库存已变化”，不会盲目覆盖最新余额。

对于原先不存在库存记录的维度，盘库可建立余额。不存在变动时，不更新余额，也不生成流水；有盈亏时，余额变为实盘数量，流水变动量为“实盘 - 当前账面”。

盘库主单的总数量是差异数量汇总；总金额与实际金额分别按账面数量、实盘数量和单价汇总，不是普通出入库单的同一金额含义。

源码：[盘库库存复核及差异流水](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/inventory/WmsInventoryServiceImpl.java:81)，[锁定余额并比对快照](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/inventory/WmsInventoryServiceImpl.java:240)。

### 2.6 库存查询、流水和首页

库存查询可以按商品/SKU 编码名称、仓库、最低数量及仅正库存等条件过滤；统计维度影响排序。库存列表供业务选择或盘库使用。流水分页用于查单据来源、变动量、变化前后量、单价和金额，Controller 没有开放手工增删流水接口。

首页有三组只读指标：四类单据按状态汇总、最近若干天单据趋势、库存总量及商品/仓库分布。趋势 SQL 按 `order_time` 业务日期聚合，并没有仅筛“已完成”，不能把它解释为每天实际完成量；库存总量把各 SKU 数量相加，是否具有统一计量业务含义需结合业务口径判断。

源码：[库存过滤和维度排序](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/mysql/inventory/WmsInventoryMapper.java:29)，[首页趋势的业务日期口径](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/resources/mapper/home/WmsHomeStatisticsMapper.xml:54)。

## 3. 核心对象及关系的业务意义

| 对象链 | 关系 | 为什么需要这层 |
| --- | --- | --- |
| 分类 → 商品 → SKU | 分类可自引用；商品引用分类/品牌；SKU 引用商品 | 将商品描述与可出入库的规格分开 |
| SKU + 仓库 → 库存余额 | 每条余额保存该维度的当前数量 | 写库存时统一定位余额，避免主单各算各的 |
| 入库/出库主单 → 明细 | `order_id` 指向各自主单，明细再引用 SKU 和仓库 | 保存一次业务操作的多个货品 |
| 移库主单 → 明细 → 两端仓库 | 来源、目标仓库分别落到库存变动项 | 一个业务动作产生两边余额变化 |
| 盘库主单 → 明细 → 可选库存 ID | 明细带原账面量及实盘量 | 完成时复核快照后再调整余额 |
| 库存流水 → 来源主单 | `order_type + order_id` 决定来源类型 | 单独的 `order_id` 不能唯一判断主表 |

库存流水的来源类型：1 入库、2 出库、3 移库、4 盘库；它们是代码维护的条件关联，生成 DDL 没有把同一字段声明为四个物理外键。

## 4. 四条端到端流程

### 流程 A：供应商来货，建入库草稿并完成

1. 先准备 WMS 商品/SKU、仓库及可选供应商；录入入库类型、业务日期、单号和正数明细数量。
2. 请求 VO 校验必填、数量大于 0、金额非负；Service 校验单号唯一、仓库存在、供应商类型及每个 SKU 存在。
3. 保存主单 `PREPARE=0` 和明细，汇总数量金额；此时没有写库存。
4. 调用完成接口，重新验证草稿和至少一条明细；Mapper 以“ID + 草稿状态”为条件改为 `FINISHED=4`，更新 0 行就抛错。
5. 将每条明细转为正数库存变动。统一库存服务补齐缺失余额、加锁、计算新余额、写余额及流水；事务失败则不能把主单独立视为完成。
6. 流水记录 `order_type=1`、主单 ID/单号以及变动前后数量，供从单据追查库存。

阅读：[请求数量规则](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/controller/admin/order/receipt/vo/detail/WmsReceiptOrderDetailSaveReqVO.java:21)，[入库保存与完成](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/order/receipt/WmsReceiptOrderServiceImpl.java:54)。

### 流程 B：客户领货/销售发出，出库不足时失败

1. 建立出库草稿，关联自己的 WMS 仓库、SKU 和可选客户；保存过程还不减少库存。
2. 完成时确认主单仍是草稿、明细存在，用条件更新切换状态。
3. 将业务正数数量转换为库存负数数量，统一库存服务锁定涉及的余额行。
4. 对同一 SKU/仓库的多条变动按内存中的最新累计余额依次计算；任何一步使余额小于 0 都抛业务异常，包含商品、SKU、仓库、可用量和变动量。
5. 全部校验通过后批量更新余额，随后批量写流水；出库流水 `order_type=2`，数量和金额方向为负。

核心不是“保存出库单即出库”，而是完成动作与库存变更处于同一事务路径。源码：[统一余额计算和不足异常](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/inventory/WmsInventoryServiceImpl.java:137)。

### 流程 C：A 仓转到 B 仓

1. 录入来源、目标仓和 SKU 数量，生成移库草稿。
2. 完成动作检验草稿、明细和保存时的仓库约束。
3. 每一行生成 A 仓 `-Q`、B 仓 `+Q` 两个库存变动项。
4. 统一库存服务为相关维度补齐余额、批量锁行、逐项计算；来源不足时整条完成路径失败。
5. 通过后形成两侧余额及 `order_type=3` 的两条流水；单据进入已完成。

定位源码：[移库完成入口](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/order/movement/WmsMovementOrderServiceImpl.java:103)。

### 流程 D：仓库实盘后调整差异

1. 读取仓库库存，将库存 ID、SKU、仓库、账面数量形成盘库明细，填写实盘数量。
2. 草稿可编辑；完成时要求明细存在并进行状态条件更新。
3. 对已有库存 ID，库存服务 `FOR UPDATE` 后校验维度和账面快照；不匹配则报库存变化，要求重新处理盘库数据。
4. 对没有库存 ID 的维度尝试建立实盘余额；若并发已创建相同维度则报库存变化，不继续覆盖。
5. 无差异跳过余额和流水；有差异写“原量 → 实盘量”，流水量为两者差值，`order_type=4`。

源码：[盘库完成](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/order/check/WmsCheckOrderServiceImpl.java:102)，[新盘库维度创建及冲突处理](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/inventory/WmsInventoryServiceImpl.java:253)。

## 5. 状态、事务和库存关键规则

| 当前状态 | 可执行的写动作 | 状态/库存结果 |
| --- | --- | --- |
| 草稿 `0` | 修改、删除、完成、作废 | 修改保留草稿；完成到 `4` 且写库存；作废到 `5` 且不写库存 |
| 已完成 `4` | 本次扫描未见反完成或已完成作废入口 | 不能把作废当成冲销；没有自动反向流水 |
| 已作废 `5` | 删除 | 删除主单及明细；不产生库存变动 |

四类单据共用 [WmsOrderStatusEnum](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-api/src/main/java/cn/iocoder/yudao/module/wms/enums/order/WmsOrderStatusEnum.java:17)。状态读校验之外，更新/完成/作废还使用 Mapper 的状态条件更新，避免同一草稿重复完成后再次过库存。

统一库存过程先查或建立余额，再按余额 ID `FOR UPDATE`。多条明细引用同一维度时共用一个内存余额对象，后一条看到前一条计算结果；流水仍逐条保留变动前后量。`IdentityHashMap` 保存每个请求明细的结果，不把属性相同的请求项合并掉。

缺失余额的插入捕获重复键冲突后，记录 Warn 并查询已有余额；回查仍不存在则重新抛出异常。该并发分支依赖真实数据库存在相应唯一约束，不能仅凭本次初始化 DDL 证明它会触发。源码：[缺失余额的补行与冲突回查](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/service/inventory/WmsInventoryServiceImpl.java:197)。

## 6. 模块实际协作

- 单据主服务调用 WMS 内部明细、仓库、往来企业及库存服务，库存服务再调用流水服务；这是本模块内的 Java 服务协作。
- 单据 Controller 从主单及明细收集 SKU、商品、仓库、往来企业，批量补全响应中的名称。
- 四类主单 Controller 调用 `AdminUserApi.getUserMap`，将 creator/updater 字符串解析为用户 ID 后填昵称；这是已确认的 system API 使用。
- 未发现本模块向 MES、ERP、Mall 库存 API 自动发起变更；不能将业务编码相同当作数据同步契约。

源码：[入库响应补充用户名称](/Users/chenwen/workspace2/yudao-cloud/yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/controller/admin/order/receipt/WmsReceiptOrderController.java:169)。

## 7. 典型使用场景

1. 独立仓库管理：先维护商品及规格，再用入出库完成动作形成余额和追溯流水。
2. 多仓调配：用一张移库单表达同一 SKU 在两仓之间数量移动，按来源主单核对双向流水。
3. 周期性盘库：记录账面快照与实盘量，完成时识别盘点期间的并发业务变化。
4. 业务交接：按库存流水回看来源单据，而不是直接修改余额“修账”。
5. 管理看板：比较四类单据的状态和按业务日期的趋势；解释报表时保留未完成单据也计入趋势的口径。

## 8. 实现局限和需要继续验证的边界

- 库存粒度只有 SKU + 仓库，未实现 MES 式批次、SN、库区库位、质量库存或生产线边库。
- 单据流只有草稿、已完成、已作废，未实现审批中、部分执行、在途、反完成和已完成单据冲销。
- 入出库金额支持直接提供行金额，代码不是完整成本核算、加权平均成本或财务凭证系统；流水金额不能自动解释为会计成本。
- 当前生成 DDL 没有唯一索引或物理外键；源码中的查重和“重复键后回查”意图需要与真实部署库索引一并核验。
- 首页趋势按业务日期与所有未删除单据计数，不是完成事件流水；库存总数量跨 SKU 相加的业务可比性没有在代码中统一换算。
- 库存查询服务本身不开放手工余额写接口；`changeInventory/checkInventory` 的空请求会直接返回，这是现存行为，不能当成请求正确或过账成功的校验证明。
- 库存服务锁和事务的实际效果、重复完成并发、缺失余额并发补行、盘库期间库存变化，需要使用真实数据库集成测试确认，本文没有运行这些测试。

## 9. 源码阅读顺序与接口域覆盖

建议先读入库完整链，再看库存通用过程，随后比较出库/移库/盘库如何转换库存参数，最后阅读主数据删除约束和首页 SQL。先跟一张单据的动作与结果，比按表顺序阅读更容易理解。

| Controller 包（相对 `controller/admin`） | 控制器数 | 路由域 | 已核对能力 |
| --- | ---: | --- | --- |
| `md/item` | 4 | `/wms/item`、`item-sku`、`item-category`、`item-brand` | 商品及 SKU 保存、分类树、品牌、分页选品、精简列表及对应导出 |
| `md/merchant` | 1 | `/wms/merchant` | 往来企业增改删查、类型筛选与导出 |
| `md/warehouse` | 1 | `/wms/warehouse` | 仓库增改删查、精简列表与导出 |
| `inventory` | 2 | `/wms/inventory`、`inventory-history` | 库存分页/列表和流水分页，只读入口 |
| `order/receipt` | 2 | `/wms/receipt-order`、`receipt-order-detail` | 主单增改删查、完成/作废、导出；明细按单据列表 |
| `order/shipment` | 2 | `/wms/shipment-order`、`shipment-order-detail` | 主单增改删查、完成/作废、导出；明细按单据列表 |
| `order/movement` | 2 | `/wms/movement-order`、`movement-order-detail` | 主单增改删查、完成/作废、导出；明细按单据列表 |
| `order/check` | 2 | `/wms/check-order`、`check-order-detail` | 主单增改删查、完成/作废、导出；明细按单据列表 |
| `home` | 1 | `/wms/home-statistics` | 单据汇总、趋势、库存分布三组统计 |

覆盖合计：9 个 Controller 包、17 个 Controller、16 张持久表；没有把首页统计虚构为额外业务表，也没有把只读明细 Controller 写成独立逐行维护功能。
