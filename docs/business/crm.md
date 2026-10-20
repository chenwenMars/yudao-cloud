# CRM 客户关系管理业务知识

> 本文依据当前仓库 Controller、Service、Mapper、DO 与枚举的静态分析编写，未进行运行时业务验证。说明的是本分支已经表达的业务行为，不代表其他版本或完整商业产品的能力。

## 技术栈、服务模块与主要作用

| 项目 | 当前代码依据 |
| --- | --- |
| 后端服务 | `yudao-module-crm-server`（[pom.xml](../../yudao-module-crm/yudao-module-crm-server/pom.xml)） |
| 基础技术栈 | Java 17、Spring Boot 3.5.15、Maven、MyBatis、租户/IP/安全、模块 RPC、Nacos 服务发现与配置。 |
| 模块专项依赖 | System、Infra、CRM API 与 BPM API；任务调度和 Excel 导入导出 starter。 |
| 主要作用 | 管理线索、客户/公海、联系人、商机、合同、回款、跟进、协作权限和销售统计。 |

## 1. 定位、参与角色与边界

CRM 管理销售人员从获取线索、经营客户和联系人、推进商机，到签订合同、安排回款、登记回款的工作过程。核心产物是客户关系、销售机会、合同和回款记录，以及这些对象的负责人、协作权限、跟进历史和统计结果。销售负责人负责自己的业务对象，协作成员可获得只读或读写权限，管理人员配置公海、客户数量上限、商机阶段和业绩目标，并通过统计接口观察团队工作。

这里的“负责人”不是普通备注字段：创建线索、商机、合同和回款时会同步创建 `crm_permission` 的 OWNER 权限，转移负责人也要修改权限。接口的功能权限与业务对象的数据权限是两个层次；不能理解为只要能访问某个菜单，就能查看全部客户。阅读时应同时跟踪 Controller 的权限注解、Service 的 `@CrmPermission` 和 Mapper 中按当前用户筛选的条件。[权限创建与转移][permission]

CRM 产品用于报价与合同明细，本模块没有产品库存增减过程。合同审批通过也不等于银行到账，回款登记审批也不是支付渠道回调；本次核对没有发现 CRM 调用 PAY 或 FMS 自动生成支付单、会计凭证的链路。不要把“销售业务金额”扩写成已经实现的财务总账闭环。

## 2. 各业务域实际做什么

### 2.1 线索、客户与公海

线索保存尚待转化的潜在客户信息，支持创建、修改、删除、转移、查询、导出、待跟进数量和转化。转化不是仅设置一个标记，而是调用客户创建逻辑生成新客户，把客户编号写回线索，并复制线索跟进记录到客户业务类型下。因此线索与客户保留不同身份，原始来源仍可追踪。[线索服务][clue]

客户支持独立创建、修改、成交状态调整、导入导出、锁定、转移、投入公海、领取和分配。公海的主要表达是客户没有负责人；进入公海会清除客户负责人，写负责人变更历史，并调整相关权限。客户锁定及客户数量限制分别用于避免不适合流转的对象进入公海、约束负责人占有和锁定的客户数。规则可以关联人员、部门；具体是否适用由限制配置与校验流程决定。[客户服务][customer]

公海配置包括自动流入和提醒相关开关。`CrmCustomerAutoPutPoolJob` 会调用按规则筛选并逐个投入公海的 Service；源码有这一任务类和单条失败后继续处理的逻辑，但未核对调度配置是否在运行环境启用。手动领取和后台分配共用领取逻辑；方法通过参数区分操作语义，都会校验目标负责人、客户现有负责人、锁定和成交状态以及数量上限。

### 2.2 联系人和商机

联系人属于客户，可有直属上级和自己的负责人。联系人与商机通过关联表连接，一个客户的不同联系人可以参与不同机会；关联、批量关联、取消关联是具体操作，不应把联系人关系简化成商机上的单个联系人字段。

商机记录客户、阶段组、当前阶段、预计成交日期、产品明细和预估金额。新建时校验产品与关联字段，从阶段组的阶段列表取首项作为默认阶段；在联系人详情中新建时还会建立联系人和商机关系。修改商机不允许借普通编辑接口改负责人或阶段组，阶段变更走单独入口。阶段可继续推进，也可以结束为赢单、输单或无效；结束后现有更新状态逻辑拒绝再变更。[商机创建和状态处理][business]

商机产品明细按业务单价乘数量计算小计，汇总后计算整单折扣金额并从产品总金额扣减，结果用于销售预测。这个过程不创建 ERP 销售订单，也不产生出入库。

### 2.3 产品、合同与回款

产品域管理分类树、产品资料、启停和供下拉框使用的有效产品列表。商机和合同分别持有自己的产品关联明细，因此报价过程中的单价、数量、折扣和金额属于对应单据，而不是直接读取产品最新价格当作历史成交金额。

合同支持创建、编辑、转移、删除、提交审批、关联客户或商机查询以及到期提醒。创建时生成合同编号并检查重复，校验商品明细和客户、商机、签约联系人、签约员工等关联信息，再写合同、明细和负责人权限。合同配置负责提前提醒规则。[合同服务][contract]

回款计划是合同下的分期安排：创建时读取合同现有最大期数加一，计划日期与提醒天数决定提醒日期；计划可以尚无实际回款。回款是一次实际登记，校验合同必须审核通过、计划存在且尚未绑定回款，生成回款编号，创建负责人权限，并把回款编号写回计划。已有回款的计划不允许按普通编辑流程再修改。[回款计划][plan] [回款登记与额度][receivable]

### 2.4 跟进、团队权限、业绩与统计

跟进记录按 `biz_type + biz_id` 归属于线索、客户、联系人、商机或合同，保存内容、下次联系时间、附件和相关联系人/商机。创建跟进会更新对应对象的跟进摘要；额外关联的联系人、商机仅更新下次联系时间，并不等于新增独立跟进记录。[跟进服务][followup]

权限域支持添加协作成员、修改其权限、删除或退出团队。负责人转移会赋予新负责人 OWNER，旧负责人按请求保留指定权限或删除权限。OWNER、READ、WRITE 的数字不是大小顺序；判断必须使用业务方法，不能把数值越大理解为权限越高。[权限级别][permission-enum]

业绩目标按年份、部门或员工保存年度及各月目标，目标对象会调用部门或用户 API 校验。统计接口覆盖客户总量与跟进、公海流转、成交周期、销售漏斗、合同数与金额、回款金额、目标完成情况、客户地区/行业/来源/级别画像、产品销售和排行榜。它们是查询聚合，不直接改变商机、合同或回款状态。统计服务还会按部门展开用户集合，因此页面统计口径必须结合时间条件与归属人员理解。[统计漏斗][stats-funnel] [业绩目标][performance]

## 3. 核心对象、单据与表

| 对象组 | 主要表 | 业务关系 |
|---|---|---|
| 线索、客户 | `crm_clue`、`crm_customer` | 线索转化后指向新客户，原线索继续保存 |
| 客户规则 | `crm_customer_limit_config`、`crm_customer_pool_config` | 数量限制与公海规则，不是客户交易单 |
| 联系人 | `crm_contact`、`crm_contact_business` | 联系人归客户，通过关联表参与商机 |
| 商机 | `crm_business`、`crm_business_product`、`crm_business_status_type`、`crm_business_status` | 阶段组包含阶段；商机有自己的产品明细 |
| 产品目录 | `crm_product`、`crm_product_category` | 分类树组织可报价产品 |
| 合同 | `crm_contract`、`crm_contract_product`、`crm_contract_config` | 合同归客户，可关联商机，产品明细独立 |
| 回款 | `crm_receivable_plan`、`crm_receivable` | 合同下计划与回款分离，计划可绑定一笔回款 |
| 协作与经营记录 | `crm_permission`、`crm_owner_record`、`crm_follow_up_record`、`crm_performance_config` | 业务类型决定目标对象；负责人历史与当前权限分开 |

结构定位可结合 [CRM ER 图](../er/crm-er.drawio) 和 [CRM DDL](../../sql/mysql/crm.sql)。ER 连线表达源码支持的逻辑关系，不代表数据库已经建立物理外键。地区编号来自 Area 内存地区库，行业等值来自字典，不应寻找不存在的 CRM 地区实体表。

## 4. 主要端到端流程

### 4.1 从线索到客户，再到持续跟进

1. 销售创建线索，系统校验负责人存在，插入线索并创建 OWNER 权限。
2. 销售记录跟进，跟进表写入后更新线索最近联系时间、摘要、下次联系时间与已跟进标记。
3. 负责人执行转化，系统校验线索存在且没有转化过，调用客户创建逻辑。
4. 生成客户后，在线索中保存客户编号和已转化标记；读取原线索跟进，批量复制为客户跟进。
5. 后续继续经营客户及其联系人。该流程改变业务归属和历史记录，没有库存、资金账户或会计台账影响。重复转化会被拒绝，而不是再创建一个客户。[转化实现][clue]

### 4.2 客户投入公海与重新领取

1. 原负责人主动投入公海时，校验客户存在、已有负责人且未被锁定。
2. 系统将负责人更新为空，记录前后负责人变化，清除客户联系人负责人，并删除客户 OWNER 权限。源码明确要求先处理联系人再删客户权限，否则后续联系人操作可能失去授权。
3. 销售领取或管理员分配时，校验全部客户存在、目标后台用户有效、当前无负责人，且锁定/成交条件满足。
4. 按新增客户数量校验目标负责人上限，然后批量写新负责人和领取时间、负责人权限和负责人变更记录。
5. 公海自动流转逐条处理失败会记录错误日志并继续处理后续客户；这与批量领取的事务边界不同。不能把批次返回的成功数量理解为全部候选都成功。[公海实现][customer]

### 4.3 商机报价、合同审批与分期回款

1. 创建商机时校验产品，按“单价×数量”计算明细，汇总并扣除折扣，设置阶段组首个阶段。业务人员通过独立状态接口推进阶段或结束商机。
2. 创建合同，生成编号、计算合同产品及折扣金额，保存对应客户、可选商机和签约人信息；合同是独立单据，不从赢单自动生成。
3. 用户提交合同，Service 只接受 DRAFT，通过 BPM API 创建流程实例，以合同 id 为 businessKey，回写流程实例编号和 PROCESS。
4. 合同审批结果更新入口只允许对 PROCESS 状态操作，将 BPM 结果转换成 CRM 审核状态。实际模型、监听/回调部署是否就绪需要联调验证。
5. 为合同建立分期回款计划，再创建回款。系统按合同总金额减“审核通过＋审批中”的其他回款计算剩余额度，拒绝超额；有计划则绑定计划。回款提交同样创建 BPM 流程并进入 PROCESS。
6. 这些步骤形成销售合同、计划与登记回款的业务台账；没有发现此路径自动修改 ERP 库存、结算账户余额或 FMS 凭证。[合同审批][contract] [额度和回款审批][receivable]

## 5. 状态和关键规则

| 维度 | 已核对规则 |
|---|---|
| 审批 | DRAFT=0、PROCESS=10、APPROVE=20、REJECT=30、CANCEL=40；提交入口要求 DRAFT，结果更新要求 PROCESS |
| 合同/回款编辑 | 现有 Service 允许 DRAFT、PROCESS 编辑；不能按“审批中必然不可改”自行解释 |
| 商机结束 | WIN=1、LOSE=2、INVALID=3；`endStatus != null` 后禁止再次更新状态 |
| 客户限制 | 分拥有客户数和锁定客户数两类；领取前按批次数量校验拥有上限 |
| 回款可用额度 | 合同总额减已通过和审批中的其他回款；修改自身时先排除自身 |
| 计划期次 | 当前合同最大期次+1；已有实际回款的计划不允许普通编辑 |
| 金额 | 商机、产品明细、合同及回款金额采用 BigDecimal，DO 注释明确单位为元；不套用 PAY 的整数分约定 |

状态定义见 [CRM 审批枚举][audit-enum]、[商机结束枚举][end-enum]；金额单位见 [回款 DO][receivable-do]。这里的客户成交标记、商机结束状态、合同审核状态和回款审核状态是不同维度，不应靠一个统一“成功”状态替代。

## 6. 与其他模块如何协作

- **SYSTEM 是实际 API 调用**：负责人、签约人和协作成员校验通过 `AdminUserApi`；部门目标校验和统计人员展开通过 `DeptApi`；操作日志展示通过日志相关 API。用户编号是后台账号，不是会员账号。
- **BPM 是实际 API 调用**：合同与回款提交通过 `BpmProcessInstanceApi.createProcessInstance` 创建流程实例。`process_instance_id` 是引擎实例标识，不能仅因名称相似就连接某张 BPM 业务扩展表。
- **基础设施与框架**：Redis 编号 DAO 生成合同、回款序号；Excel 导入导出处理客户及业务列表；注解与日志上下文记录业务操作。存在附件 URL 字段并不证明 CRM 自己实现对象存储上传流程。
- **ERP/PAY/FMS**：本次已读核心 Service 没有发现自动衔接调用；名称类似的“产品、客户、回款”不表示跨模块共用实体。接口注册边界可读 [CRM RPC 配置][rpc]。

## 7. 典型使用场景

新销售接手一批展会线索，可以先登记和跟进，确认有效需求后转为客户，保留前期沟通记录。大客户销售则在客户下维护采购、技术等多个联系人，再把相关联系人关联到同一商机，使机会推进与日常联系人档案分开。

团队主管可以把长期未经营客户投入公海，由其他销售领取；客户数量和锁定规则用于约束资源占有。签订分期合同后，销售建立回款计划，根据实际收款创建回款登记并送审；管理者分别查看合同业绩和回款业绩，避免将签约额误当回款额。

## 8. 当前实现限制与未证实事项

- 线索转化明确复制跟进记录，但批量复制入口仅执行插入，不等于逐条重新触发创建跟进的摘要更新过程。
- 领取客户后的联系人联动仍留有 TODO；投入公海明确清除联系人负责人，不能反推领取时已完整恢复所有联系人归属。[客户 TODO][customer]
- 商机默认阶段直接取阶段列表首项，配置阶段组时需要保证有阶段；本次没有运行空阶段组用例验证错误表现。
- 合同、回款的工作流创建代码和结果更新入口已确认，但没有部署流程模型、执行审批或验证跨服务事务和回调时序。
- 回款计划与回款反向绑定、删除后的联动、审批过程中编辑对流程变量的影响，应作为交接联调重点；不能因为字段双向存在就宣称完整一致性已验证。
- 自动公海任务已有 [CrmCustomerAutoPutPoolJob](/Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/job/customer/CrmCustomerAutoPutPoolJob.java:19) 入口，但其调度配置、统计时间和人员口径、前端提醒实际展示、Excel 文件兼容性均未运行验证。

## 9. 阅读入口与接口域覆盖

建议按“线索转化→客户公海→商机金额→合同审批→回款额度→权限实现→统计 Mapper”阅读。先理解 Service 的写入顺序，再回到 Controller 看入口权限和响应聚合；遇到统计数字问题直接跟进 Mapper，而不是从图中推算。下面按全部 Controller 业务包汇总接口域，避免把仅有 CRUD 的对象遗漏为不存在的功能。

| Controller 业务包 | 控制器数量 | 覆盖的业务入口 |
|---|---:|---|
| [admin/business](/Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/controller/admin/business) | 2 | /crm/business、/crm/business-status；创建商机、更新商机、创建商机状态、更新商机状态 |
| [admin/clue](/Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/controller/admin/clue) | 1 | /crm/clue；创建线索、更新线索 |
| [admin/contact](/Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/controller/admin/contact) | 1 | /crm/contact；创建联系人、更新联系人 |
| [admin/contract](/Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/controller/admin/contract) | 2 | /crm/contract-config、/crm/contract；获取合同配置、更新合同配置、创建合同、更新合同 |
| [admin/customer](/Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/controller/admin/customer) | 3 | /crm/customer、/crm/customer-limit-config、/crm/customer-pool-config；创建客户、更新客户、创建客户限制配置、更新客户限制配置、获取客户公海规则设置、更新客户公海规则设置 |
| [admin/followup](/Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/controller/admin/followup) | 1 | /crm/follow-up-record；创建跟进记录、删除跟进记录 |
| [admin/operatelog](/Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/controller/admin/operatelog) | 1 | /crm/operate-log；获得操作日志 |
| [admin/performance](/Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/controller/admin/performance) | 1 | /crm/performance-config；创建业绩目标、更新业绩目标 |
| [admin/permission](/Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/controller/admin/permission) | 1 | /crm/permission；创建数据权限、编辑数据权限 |
| [admin/product](/Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/controller/admin/product) | 2 | /crm/product-category、/crm/product；创建产品分类、更新产品分类、创建产品、更新产品 |
| [admin/receivable](/Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/controller/admin/receivable) | 2 | /crm/receivable、/crm/receivable-plan；创建回款、更新回款、创建回款计划、更新回款计划 |
| [admin/statistics](/Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/controller/admin/statistics) | 7 | /crm/statistics-customer、/crm/statistics-funnel、/crm/statistics-performance、/crm/statistics-performance-target、/crm/statistics-portrait、/crm/statistics-product、/crm/statistics-rank；统计分析、漏斗、画像、业绩目标与排行榜 |

本次按包覆盖 12 个 Controller 业务包、24 个 Controller；核心写入流程已对照实现，查询/导出接口按域核对入口，未执行每个接口。

[permission]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/service/permission/CrmPermissionServiceImpl.java:153
[clue]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/service/clue/CrmClueServiceImpl.java:182
[customer]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/service/customer/CrmCustomerServiceImpl.java:371
[business]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/service/business/CrmBusinessServiceImpl.java:92
[contract]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/service/contract/CrmContractServiceImpl.java:292
[plan]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/service/receivable/CrmReceivablePlanServiceImpl.java:60
[receivable]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/service/receivable/CrmReceivableServiceImpl.java:85
[followup]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/service/followup/CrmFollowUpRecordServiceImpl.java:66
[stats-funnel]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/service/statistics/CrmStatisticsFunnelServiceImpl.java:46
[performance]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/service/performance/CrmPerformanceConfigServiceImpl.java:108
[receivable-do]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/receivable/CrmReceivableDO.java:75
[rpc]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/framework/rpc/config/RpcConfiguration.java:12
[permission-enum]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-api/src/main/java/cn/iocoder/yudao/module/crm/enums/permission/CrmPermissionLevelEnum.java:16
[audit-enum]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-api/src/main/java/cn/iocoder/yudao/module/crm/enums/common/CrmAuditStatusEnum.java:16
[end-enum]: /Users/chenwen/workspace2/yudao-cloud/yudao-module-crm/yudao-module-crm-api/src/main/java/cn/iocoder/yudao/module/crm/enums/business/CrmBusinessEndStatusEnum.java:16
