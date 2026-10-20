# Infra 基础设施业务知识

> 本文由当前源码静态分析整理，未连接任何真实文件存储、数据库、Redis、WebSocket、消息队列或代码生成目标库。

关联资料：[DDL](../../sql/mysql/infra.sql)｜[ER 图](../er/infra-er.drawio)｜[关系依据](../er/module-data/infra.json)

## 技术栈、服务模块与主要作用

| 项目 | 当前代码依据 |
| --- | --- |
| 后端服务 | `yudao-module-infra-server`（[pom.xml](../../yudao-module-infra/yudao-module-infra-server/pom.xml)） |
| 基础技术栈 | Java 17、Spring Boot 3.5.15、Maven、MyBatis、Redis、租户/安全、模块 RPC、Nacos 服务发现与配置。 |
| 模块专项依赖 | WebSocket、任务调度、消息队列、MyBatis-Plus Generator、Velocity、S3、Tika、JSch 与 Commons Net。 |
| 主要作用 | 提供文件、配置、数据源、代码生成、Redis 监控和 WebSocket 等平台基础设施能力。 |

## 定位

Infra 是其他业务模块共用的运行支撑域：参数配置、文件存储、代码生成元数据、多数据源、访问/错误日志与 Redis 观测。它不是业务订单模块；其若干 `demo*` 表及接口是代码生成示例，不能当作真实的客户、分类或学生业务。

## 业务域

### 文件配置与文件登记

`infra_file_config` 定义本地、OSS、S3 等具体存储客户端，只有一项可标为 master；主配置通过缓存键 `0` 获取，切换 master 会先清空其他 master 标记与相关缓存，[FileConfigServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/service/file/FileConfigServiceImpl.java:102)。`infra_file` 记录文件元数据（配置、路径、URL、类型、大小），不是二进制内容本身。

文件上传会校验路径/文件名，推断 MIME 和后缀，按日期与可选目录构造路径，上传至 master 客户端后写登记。[FileServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/service/file/FileServiceImpl.java:65)。预签名上传只生成路径、上传 URL 和访问 URL，调用方仍须在上传成功后创建登记；删除则先删除底层对象再删除记录。[同文件](/Users/chenwen/workspace2/yudao-cloud/yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/service/file/FileServiceImpl.java:153)。

### 参数配置与数据源

`infra_config` 按 key 存储系统参数，并在新增/修改时检查键唯一。`infra_data_source_config` 是为代码生成器等场景维护的外部数据源，保存前会尝试连接；其中编号 `0` 是运行时虚拟的 master 数据源，不是数据库中一行配置，[DataSourceConfigServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/service/db/DataSourceConfigServiceImpl.java:76)。

### 从表结构到代码生成

`infra_codegen_table` 与 `infra_codegen_column` 是生成器的可编辑元数据。导入时读取指定数据源的表结构，要求表/字段均有注释；没有物理主键时，生成器会把第一列作为生成元数据的主键。[CodegenServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/service/codegen/CodegenServiceImpl.java:75)

模板类型包含单表、树表、普通/ERP/内嵌主子表，生成场景有后台和 App。[CodegenTemplateTypeEnum](/Users/chenwen/workspace2/yudao-cloud/yudao-module-infra/yudao-module-infra-api/src/main/java/cn/iocoder/yudao/module/infra/enums/codegen/CodegenTemplateTypeEnum.java:14) 同步数据库结构会比较 JDBC 类型、可空性、主键、注释与排序并更新差异；预览/下载是从已保存元数据渲染模板，不会修改业务库。

### 可观测性与实时支撑

`infra_api_access_log` 记录访问，`infra_api_error_log` 记录异常并有未处理/已处理等处理状态。错误日志创建遇到没有租户上下文时会忽略租户上下文插入，插入本身异常会记录日志而不再抛出，[ApiErrorLogServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/service/logger/ApiErrorLogServiceImpl.java:37)。这是日志设施的特意降级，不能据此推断业务写入也会吞错。

Infra 还暴露 WebSocket 发送 API：可按 session、用户类型+用户或用户类型广播；没有符合条件的目标时仍返回 success，不报告实际在线人数。[WebSocketSenderApiImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/api/websocket/WebSocketSenderApiImpl.java:20)。Redis 控制器仅提供监控信息，非通用缓存管理台。

## 核心对象与流程

|对象|表/资源|含义|
|---|---|---|
|文件|`infra_file_config`、`infra_file`、外部存储|配置决定客户端，文件表登记对象位置。|
|生成元数据|`infra_data_source_config`、`infra_codegen_table`、`infra_codegen_column`|从数据库表导入并允许人工调整，再渲染代码。|
|运行日志|`infra_api_access_log`、`infra_api_error_log`|框架观测数据，错误日志可被人工标记处理。|

### 文件直传流程

1. 调用预签名接口，服务按 master 存储配置生成路径和临时 URL。
2. 客户端直接上传到存储服务；随后调用创建文件登记接口保存 configId/path/url 等元数据。
3. 下载或删除时按登记记录的 configId 找回客户端；删除先操作存储再删元数据。

### 代码生成流程

1. 选择 master（0）或已保存数据源，读取表结构。
2. 导入表及列注释成为生成元数据，设置场景、模板和字段 UI/查询配置。
3. 预览或下载生成代码；后续可从库同步，库字段变动会按元数据比较规则处理。

## 控制器覆盖与限制

|控制器域|能力|
|---|---|
|`admin/file`、`app/file`|文件配置、上传、预签名、登记、下载和删除。|
|`admin/config`、`admin/db`|参数配置、外部数据源维护与连接校验。|
|`admin/codegen`|表导入、同步、元数据编辑、预览和下载。|
|`admin/logger`、`admin/redis`|访问/错误日志及 Redis 观测。|
|`admin/demo/*`|代码生成示例 CRUD，不是产品业务。|

当前限制：文件表不保证外部对象一定存在，预签名上传和登记之间也没有跨服务事务；数据源密码及连接安全依赖现有配置/权限；代码生成器没有被本次实际执行；WebSocket 发送成功仅表示调用分支完成，不能证明消息抵达客户端。
