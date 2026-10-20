# Report 报表大屏模块业务知识

> 本文依据当前源码静态分析，未启动GoView前端、未执行SQL、未验证已发布大屏的访问行为。结构见 [report.sql](../../sql/mysql/report.sql)，关系见 [Report ER图](../er/report-er.drawio)。

## 技术栈、服务模块与主要作用

| 项目 | 当前代码依据 |
| --- | --- |
| 后端服务 | `yudao-module-report-server`（[pom.xml](../../yudao-module-report/yudao-module-report-server/pom.xml)） |
| 基础技术栈 | Java 17、Spring Boot 3.5.15、Maven、MyBatis、Redis、租户/安全、模块 RPC、Nacos 服务发现与配置。 |
| 模块专项依赖 | Jimureport 与 Jimubi、System/Infra/Report API、监控 starter。 |
| 主要作用 | 保存 GoView 大屏项目配置，并为大屏提供 SQL 或示例 HTTP 数据接口；报表引擎能力来自 Jimureport/Jimubi 依赖。 |

## 1. 模块定位与范围

本模块为GoView大屏提供两类后端能力：保存大屏项目配置，以及向图表返回统一格式的数据。它不是商城统计模块，也不是一个已经实现指标口径治理、ETL、数据仓库建模和报表调度的完整BI平台。大屏编辑、图表交互和页面渲染不在这两个Java Controller中完成。

使用者是有相应 `report:go-view-project:*` 或数据查询权限的后台用户。项目表只有 `report_go_view_project`，主要保存名称、预览图URL、JSON内容、发布状态和备注。`content` 是字符串存储的设计配置，不是服务器已经解析并执行的仪表盘任务。[GoViewProjectDO](/Users/chenwen/workspace2/yudao-cloud/yudao-module-report/yudao-module-report-server/src/main/java/cn/iocoder/yudao/module/report/dal/dataobject/goview/GoViewProjectDO.java:38)

## 2. 功能与核心对象

项目功能包括创建、更新、删除、详情和“我的项目”分页。“我的”查询向Mapper传入当前登录用户，按创建者过滤；创建、修改等仍要分别看接口权限和Service检查，不能把“我的分页”自动解释为全部操作都存在同样的项目归属校验。当前修改/删除Service显式检查的是项目存在。[项目Controller](/Users/chenwen/workspace2/yudao-cloud/yudao-module-report/yudao-module-report-server/src/main/java/cn/iocoder/yudao/module/report/controller/admin/goview/GoViewProjectController.java:39)、[项目Service](/Users/chenwen/workspace2/yudao-cloud/yudao-module-report/yudao-module-report-server/src/main/java/cn/iocoder/yudao/module/report/service/goview/GoViewProjectServiceImpl.java:33)

数据功能包括SQL查询和HTTP示例。SQL查询实际调用默认 `JdbcTemplate.queryForRowSet(sql)`，把列名映射到 `dimensions`，把每行数据转换成Map放入 `source`。数据来自当前默认数据源，查询结果本身不写入大屏项目表。[数据查询实现](/Users/chenwen/workspace2/yudao-cloud/yudao-module-report/yudao-module-report-server/src/main/java/cn/iocoder/yudao/module/report/service/goview/GoViewDataServiceImpl.java:34)

## 3. 端到端流程

### 3.1 创建并保存大屏

设计端提交项目名称、配置等信息；Controller验证请求与创建权限后交给Service，转换成DO并强制设置为未发布状态，插入项目表并返回主键。后续保存走update：先检查ID对应项目存在，再按请求更新内容。项目详情读取配置供设计端还原画布。后端保存的是设计结果，不能据此声称服务器负责图表布局。

### 3.2 发布状态变更与列表

发布状态在DO注释中约定 `0=已发布、1=未发布`，复用 `CommonStatusEnum`。创建默认未发布；现有Controller没有单独的发布审批接口，状态可随更新请求保存。我的项目列表由登录用户ID约束创建者。状态值表达配置标记；本模块没有由这个状态就自动创建网站、部署静态资源或生成可匿名访问分享地址的实现。[默认状态与更新](/Users/chenwen/workspace2/yudao-cloud/yudao-module-report/yudao-module-report-server/src/main/java/cn/iocoder/yudao/module/report/service/goview/GoViewProjectServiceImpl.java:34)

### 3.3 大屏通过SQL获取数据

有SQL查询权限的调用者提交SQL；Service向默认数据源执行查询，从返回元数据取得列名，逐行读取数据，组装为 `{dimensions, source}`。空结果仍有基于查询元数据的维度信息。具体图表如何选择字段由前端配置决定。源码注释明确：其他数据源需要自行创建对应JdbcTemplate，大数据场景可再考虑分析型数据库，这些是扩展方向而非现成接入能力。[SQL结果转换](/Users/chenwen/workspace2/yudao-cloud/yudao-module-report/yudao-module-report-server/src/main/java/cn/iocoder/yudao/module/report/service/goview/GoViewDataServiceImpl.java:33)

### 3.4 HTTP数据接口的真实边界

`get-by-http` 接收可选params和body，但当前仅返回固定月份标签及随机PV/UV。代码和接口说明均称其为示例，需要按具体查询编写真正业务接口。因此它不能被描述为任意HTTP数据源代理，也不是已经打通生产网站访问统计。[HTTP示例](/Users/chenwen/workspace2/yudao-cloud/yudao-module-report/yudao-module-report-server/src/main/java/cn/iocoder/yudao/module/report/controller/admin/goview/GoViewDataController.java:41)

## 4. 协作、典型场景和局限

当前业务Service没有直接调用其他模块的业务API。项目的 `creator/updater` 来自通用审计基础设施，不应虚构为独立用户外键；SQL可以读取默认库中调用者指定的表，但这属于SQL执行，不等于通过会员、支付或订单API完成授权后的领域协作。

可确认的典型场景是：后台人员维护一个大屏JSON项目，再通过自己编写的SQL或专用数据接口提供图表数据。大屏显示销售额时，指标定义应由真实查询及业务统计口径负责，本模块不会自动从字段名称推导“销售额”。

当前查询路径未见SQL解析白名单、查询行数上限、超时配置或按业务领域自动附加数据权限条件；入口权限也不能代替这些机制。这里是在描述现有源码边界，没有运行数据库验证。SQL是否具备只读限制还取决于数据源账号等部署配置，不能仅凭 `queryForRowSet` 断言已经保证只读。Controller也没有独立发布审批、版本回滚、定时刷新调度或数据源管理接口。

## 5. 源码阅读与Controller覆盖

| 包 | 控制器 | 操作与结果 |
|---|---|---|
| `admin/goview` | GoViewProjectController | 创建/更新/删除项目、获取详情、按创建者分页 |
| `admin/goview` | GoViewDataController | SQL结果转图表数据；HTTP随机PV/UV示例 |

建议依次阅读项目Controller、ProjectService、ProjectMapper，再阅读DataController和DataService。该模块只有一张项目表、没有代码证实的业务表间关系，ER图零关系是符合当前实现的结果；HTTP示例数据也不能反推存在访问统计明细表。
