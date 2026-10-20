# BPM 工作流与审批模块业务知识

> 本文根据当前工作区的 Controller、ServiceImpl、DO、枚举、Mapper 及其静态调用关系整理；未启动服务、未部署 BPMN 模型、未连接 Flowable 或真实业务系统。文中“会”“完成”等描述的是源码已存在的调用路径，不代表线上流程、定时器、消息或 HTTP 回调已经运行验证。配套材料：[推导 DDL](../../sql/mysql/bpm.sql) · [ER 图](../er/bpm-er.drawio)。

## 1. 定位与责任边界

BPM 模块提供流程定义配置、流程实例发起、人工任务处理、意见/附件、抄送以及一个请假示例。它把“某个业务单据是否走到批准、拒绝、撤销”等通用编排交给 Flowable，把与平台自身有关的表单、分类、候选人员组、定义扩展信息和请假业务记录保存在本模块。

`bpm_*` 表不是完整的流程运行时数据库：**Flowable 的流程定义、运行实例、历史实例、任务、变量、附件等引擎表不在本模块推导 DDL 中**。例如发起时直接通过 `runtimeService.createProcessInstanceBuilder()` 启动引擎实例，任务完成直接调用 Flowable 的 `taskService.complete`；不能把 `bpm_process_definition_info` 或 `bpm_process_instance_copy` 当成引擎主表。[流程实例创建](/Users/chenwen/workspace2/yudao-cloud/yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/service/task/BpmProcessInstanceServiceImpl.java:762) · [任务完成入口](/Users/chenwen/workspace2/yudao-cloud/yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/service/task/BpmTaskServiceImpl.java:575)

模块面向后台登录用户和管理员。它可被 CRM 等业务模块通过 `BpmProcessInstanceApi` 发起并接收流程结果事件；流程本身不拥有合同、回款、请假之外的任意业务实体，也不是通用的组织权限或消息中心。

## 2. 业务域与可见能力

| 业务域 | 核心对象 | 已在代码中看到的能力与边界 |
| --- | --- | --- |
| 流程建模与发布 | Flowable model/definition + `bpm_process_definition_info` | 模型创建、导入导出、BPMN 或简易模型编辑、启停、部署、查询定义；扩展信息补充表单、可见范围、发起范围、撤销/撤回、标题、打印及前后置 HTTP 配置。 |
| 表单与流程基础资料 | `bpm_form`、`bpm_category`、`bpm_user_group`、`bpm_process_expression`、`bpm_process_listener` | 维护分类、表单 JSON、候选用户组、表达式及监听器元数据；监听器的 class/delegateExpression 是否可用仍取决于运行环境中的类或 Spring Bean。 |
| 实例与审批任务 | Flowable runtime/history/task/variable/attachment | 发起、我的/管理实例查询、审批详情/下一节点预览、发起人撤销、管理员取消；待办/已办/管理任务，支持通过、拒绝、退回、委派、转交、加签、抄送、撤回。 |
| 审批协作 | Flowable 评论/附件 + `bpm_process_instance_copy` | 审批意见与附件按任务/实例保存到引擎；抄送记录是本模块额外的接收人视图，不是审批候选人的替代。 |
| 请假示例 | `bpm_oa_leave` | 创建请假单并发起指定流程，按流程结果更新请假单状态；它展示业务单据如何挂接 `process_instance_id`，不是完整 OA 人事假期额度系统。 |

流程定义信息中的 `formType/formId/formConf/formFields` 表明一个定义既可关联已保存表单，也可携带自定义表单配置；是否由前端正确渲染、字段权限如何在实际页面执行，需要结合前端验证。[定义扩展字段](/Users/chenwen/workspace2/yudao-cloud/yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/definition/BpmProcessDefinitionInfoDO.java:84)

## 3. 核心对象和关系

`bpm_category` 给模型/定义提供业务分类；`bpm_form` 保存可复用表单配置与字段列表；`bpm_user_group.user_ids` 是 JSON/集合字段，用于候选人策略，不是单独成员关联表。`bpm_process_expression` 和 `bpm_process_listener` 是设计期的可选配置，实际解析发生在流程模型/引擎执行阶段。

`bpm_process_definition_info.process_definition_id`、`model_id` 指向 Flowable 中的字符串身份；它保存平台扩展配置而不是复制 BPMN 定义。实例、任务、活动、评论和附件主要由 Flowable 表持久化；`bpm_process_instance_copy` 则保存“谁收到某流程某活动的抄送”及实例/任务标识，便于独立分页查询。[抄送对象](/Users/chenwen/workspace2/yudao-cloud/yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/task/BpmProcessInstanceCopyDO.java:39)

`bpm_oa_leave` 是业务数据，包含请假人、时段、天数、原因、状态与流程实例 ID。它通过 API 创建流程后写回实例 ID，流程结果监听器再更新单据状态；请假单自身并不保存每个审批节点、候选人或历史意见。[请假保存与流程发起](/Users/chenwen/workspace2/yudao-cloud/yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/service/oa/BpmOALeaveServiceImpl.java:47)

## 4. 端到端流程

### 4.1 从模型到可发起的流程定义

1. 管理员通过 `/bpm/model` 创建或导入模型，可更新 BPMN、简易模型和排序，随后调用部署。
2. 部署后的 Flowable definition 由流程定义接口查询；本模块为其维护 `bpm_process_definition_info`，配置分类、表单、发起人/部门范围、标题、流程号、撤销/撤回规则和监听/HTTP 触发设置。
3. 用户发起前，服务取启用的定义，拒绝暂停定义，检查扩展信息存在以及当前用户是否有发起资格。
4. 若模型存在“发起人自选审批人”节点，先预测流程走向，逐节点检查所选审批人是否齐全且为有效系统用户。
5. 服务过滤保留流程变量，写入发起人、审批中状态及跳过表达式标志，随后以业务键（若调用方提供）启动 Flowable 实例。

流程不会因为定义存在就允许所有人随意发起，权限判断在启动前完成。[启动校验及变量写入](/Users/chenwen/workspace2/yudao-cloud/yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/service/task/BpmProcessInstanceServiceImpl.java:785)

### 4.2 用户发起请假并进入审批

1. 用户调用 `/bpm/oa/leave/create` 写入请假类型、原因、开始/结束时间与天数。
2. 请假服务插入 `bpm_oa_leave`，并使用当前用户和请假单 ID 构造业务键请求 BPM API；流程实例 ID 回填到请假单。
3. Flowable 创建实例并生成首个任务，任务创建/分配等事件在 BPM 服务中用于消息、候选人与状态协作。
4. 审批人从 `/bpm/task/todo-page` 取得待办，读取审批详情、流程图或下一节点预览后提交通过、拒绝、退回等动作。
5. 引擎结束时，仍为 RUNNING 的实例会被判定为 APPROVE；拒绝或取消则写入原因。模块发布实例结果事件，请假等业务监听者据此更新自己的业务状态。

实例完成状态与业务单据状态不是同一字段，二者靠事件/API 集成而非物理外键同步。[结束事件处理](/Users/chenwen/workspace2/yudao-cloud/yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/service/task/BpmProcessInstanceServiceImpl.java:972)

### 4.3 审批、签字、意见和下一节点

1. `/bpm/task/approve` 先验证任务属于当前用户、所属实例仍存在；若模型要求签字或审批原因，缺失时直接拒绝。
2. 委派任务走“解决委派”路径，后加签任务要先处理父任务；普通任务则写 APPROVE 状态/原因与本地签字变量。
3. 服务创建审批评论，可将附件作为 Flowable task attachment 保存；请求变量为空时会从历史实例补取，用于避免下一网关因表单权限导致变量丢失。
4. 服务验证发起人所选的下一节点审批人，完成当前 Flowable task；加签完成后进一步判断父任务。
5. 拒绝会更新流程变量为 REJECT 并结束流程；退回需验证 BPMN 图中的可退回目标；转交、委派、加签、撤回均有各自的当前任务、父子任务或定义配置约束。

“评论已保存”不代表实例已通过；通过、拒绝和取消由实例/任务状态共同决定。[审批处理](/Users/chenwen/workspace2/yudao-cloud/yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/service/task/BpmTaskServiceImpl.java:575)

### 4.4 撤销、管理员取消与抄送

1. 发起人调用 `/bpm/process-instance/cancel-by-start-user` 时，只能取消自己的运行中实例，且定义允许取消、实例不是子流程。
2. 管理员取消不受发起人身份限制，但会记录管理员昵称与原因。
3. 取消服务写实例状态与原因，递归取消子流程，再将活动任务移动到结束；不会把业务单据自动删除或回滚。
4. 审批/任务可将流程复制给指定用户，`bpm_process_instance_copy` 保存接收人、实例、定义、活动和任务标识；接收人从 `/bpm/process-instance/copy/page` 查询。
5. 流程结束后由结果事件、消息服务和可选流程后置 HTTP 继续协作；HTTP 成败、重试与对端幂等需实际部署验证。

取消规则见 [发起人取消](/Users/chenwen/workspace2/yudao-cloud/yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/service/task/BpmProcessInstanceServiceImpl.java:890) 与 [取消实现](/Users/chenwen/workspace2/yudao-cloud/yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/service/task/BpmProcessInstanceServiceImpl.java:933)。

## 5. 状态规则、跨模块协作和典型场景

实例起始状态为 RUNNING，正常到达结束事件时转 APPROVE；任务拒绝路径标记 REJECT；取消标记 CANCEL。任务还拥有待办、已通过、已拒绝等任务层状态，并受委派、加签父子任务和候选人策略影响，不能用一个“审批状态”概括所有权限。

- 与 **system** 的实际协作包括 `AdminUserApi`：校验自选审批人、获取标题中的用户昵称、展示候选人等。用户 ID 只是引用，组织部门、岗位/角色策略的最终解析仍取决于模型配置和系统用户数据。
- 与 **infra/file** 的协作是 Flowable 附件 URL；BPM 不承担文件二进制存储。
- 与 **CRM** 已存在合同/回款状态监听器；调用方通过 BPM API 提交业务键和变量，再依赖实例状态事件回写业务数据。
- 与外部 HTTP 的协作来自定义中的前/后置与任务前/后置设置；它是可配置调用能力，不表示本模块提供可靠消息总线或对端事务。

典型场景包括：费用、合同或请假申请共用定义和任务能力；管理员设计一个只能特定部门发起的流程；审批人附带意见与文件后通过；发起人按定义约束撤回进行中的申请；管理人员通过实例/任务查询定位流程停在哪个节点。

## 6. 已实现局限与阅读注意事项

- 推导 SQL 只涵盖 8 张本模块表，Flowable 引擎库、运行/历史任务和附件不是遗漏的 BPM 业务表，而是依赖组件的表。
- 表单 JSON、简易模型 JSON、监听器值与 HTTP 设置是配置数据；没有静态证据证明任意配置在所有运行环境均可解析、可访问或可安全重试。
- 取消以结束流程实现，没有看到一个通用“自动业务反冲/补偿”框架；每个业务模块应自行消费结果事件处理自身单据。
- `bpm_oa_leave` 是示例业务，未发现假期余额、排班、法定节假日计算、销假或多级人事审批专用表。
- 流程权限、候选人表达式、定时边界事件、事务提交后消息、HTTP 调用和并发下的任务操作均未运行验证。

## 7. Controller 包接口覆盖与源码入口

所有入口目前位于 `controller/admin`，以下按路由域覆盖本次扫描到的 Controller；各类 `get/page/list` 为查询，其余 CRUD/动作以 Controller 上的权限注解为准。

| 包 | 控制器与路由域 | 覆盖动作 |
| --- | --- | --- |
| `definition` | BpmCategory `/bpm/category`、BpmForm `/bpm/form`、BpmUserGroup `/bpm/user-group`、BpmProcessExpression `/bpm/process-expression`、BpmProcessListener `/bpm/process-listener` | 基础资料增改删查、排序、精简列表、表达式和监听器维护 |
| `definition` | BpmModel `/bpm/model`、BpmProcessDefinition `/bpm/process-definition` | 模型导入导出/编辑/部署/启停/清理、定义分页/列表/详情 |
| `task` | BpmProcessInstance `/bpm/process-instance`、BpmTask `/bpm/task`、BpmProcessInstanceCopy `/bpm/process-instance/copy` | 发起、我的/管理实例、取消、审批详情/流程图/打印；待办/已办、通过拒绝退回、委派转交加签抄送撤回；抄送分页 |
| `comment` | BpmComment `/bpm/comment` | 按实例读取评论、创建评论 |
| `oa` | BpmOALeave `/bpm/oa/leave` | 请假创建、详情、分页 |

推荐从 [BpmProcessInstanceController](/Users/chenwen/workspace2/yudao-cloud/yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/controller/admin/task/BpmProcessInstanceController.java:47) → `BpmProcessInstanceServiceImpl` → [BpmTaskController](/Users/chenwen/workspace2/yudao-cloud/yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/controller/admin/task/BpmTaskController.java:48) → `BpmTaskServiceImpl` 阅读，再按具体业务跟踪 API 发起与结果监听器。
