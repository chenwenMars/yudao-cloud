from pathlib import Path
import json
from datetime import datetime
root=Path('/Users/chenwen/workspace2/yudao-cloud')
g=json.loads((root/'.ua/knowledge-graph.json').read_text())
by_path={n['filePath']:n for n in g['nodes'] if n.get('filePath') and n['type'] in {'file','config','document','service','pipeline','table','schema','resource','endpoint'}}
paths={
'readme':'README.md','rootpom':'pom.xml','bom':'yudao-dependencies/pom.xml',
'serverpom':'yudao-server/pom.xml','serverapp':'yudao-server/src/main/java/cn/iocoder/yudao/server/YudaoServerApplication.java',
'gatewayapp':'yudao-gateway/src/main/java/cn/iocoder/yudao/gateway/GatewayServerApplication.java',
'systemapp':'yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/SystemServerApplication.java',
'hrmapp':'yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/HrmServerApplication.java',
'commonresult':'yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/pojo/CommonResult.java',
'page':'yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/pojo/PageResult.java',
'bean':'yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/util/object/BeanUtils.java',
'base':'yudao-framework/yudao-spring-boot-starter-mybatis/src/main/java/cn/iocoder/yudao/framework/mybatis/core/dataobject/BaseDO.java',
'mapper':'yudao-framework/yudao-spring-boot-starter-mybatis/src/main/java/cn/iocoder/yudao/framework/mybatis/core/mapper/BaseMapperX.java',
'userapi':'yudao-module-system/yudao-module-system-api/src/main/java/cn/iocoder/yudao/module/system/api/user/AdminUserApi.java',
'controller':'yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/employee/HrmEmployeeController.java',
'employee':'yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/employee/info/HrmEmployeeServiceImpl.java',
'employeedo':'yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/info/HrmEmployeeDO.java',
'employeemapper':'yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/mysql/employee/info/HrmEmployeeMapper.java',
'employeetest':'yudao-module-hrm/yudao-module-hrm-server/src/test/java/cn/iocoder/yudao/module/hrm/service/employee/info/HrmEmployeeServiceImplTest.java',
'dbtest':'yudao-framework/yudao-spring-boot-starter-test/src/main/java/cn/iocoder/yudao/framework/test/core/ut/BaseDbUnitTest.java',
'appconfig':'yudao-server/src/main/resources/application.yaml',
'gatewayconfig':'yudao-gateway/src/main/resources/application.yaml',
'bpmconfig':'yudao-module-bpm/yudao-module-bpm-server/src/main/resources/application.yaml',
'gatewaydocker':'yudao-gateway/Dockerfile','compose':'script/docker/docker-compose.yml','ci':'.github/workflows/maven.yml',
'vue':'yudao-ui/yudao-ui-admin-vue3/README.md','business':'docs/business/README.md','erd':'docs/er/README.md',
'ddl':'sql/mysql/README-inferred-ddl.md','hrmsql':'sql/mysql/hrm.sql','bpmapi':'yudao-module-bpm/yudao-module-bpm-api/src/main/java/cn/iocoder/yudao/module/bpm/api/task/BpmProcessInstanceApi.java',
'contract':'yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/service/contract/CrmContractServiceImpl.java',
'bridge':'yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/api/event/CrmContractStatusListener.java',
'bpmrpc':'yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/framework/rpc/config/RpcConfiguration.java',
'callback':'yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/service/contract/listener/CrmContractStatusListener.java',
'leave':'yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/attendance/record/HrmAttendanceLeaveServiceImpl.java',
'instance':'yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/service/task/BpmProcessInstanceServiceImpl.java',
'bpmtask':'yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/service/task/BpmTaskServiceImpl.java',
'model':'yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/framework/ai/core/model/AiModelFactoryImpl.java',
'voucher':'yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/voucher/FmsVoucherServiceImpl.java',
'codegen':'yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/service/codegen/inner/CodegenEngine.java',
'security':'yudao-framework/yudao-spring-boot-starter-security/src/main/java/cn/iocoder/yudao/framework/security/config/YudaoWebSecurityConfigurerAdapter.java',
'exception':'yudao-framework/yudao-spring-boot-starter-web/src/main/java/cn/iocoder/yudao/framework/web/core/handler/GlobalExceptionHandler.java',
'crmrpc':'yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/framework/rpc/config/RpcConfiguration.java',
}
for k,p in paths.items():
 if not (root/p).is_file():raise FileNotFoundError(f'{k}: {p}')
def L(k,label=None):
 p=paths[k];return f'[{label or Path(p).name}]({root/p})'
s=[]
s.append(f'''# yudao-cloud 中文入门指南

生成日期：2026-10-25（Asia/Shanghai）  
代码基线：`{g['project']['gitCommitHash']}`  
依据：现有知识图谱的项目元数据、10 个架构层、12 步导览、文件级节点，以及本轮针对构建和审批接入的源码核对。

## 1. 项目概览

这是采用 Java、Spring Boot、Spring Cloud 和 MyBatis-Plus 的多模块业务平台。仓库既包含系统管理、基础设施，也包含工作流、会员、商城、支付、CRM、ERP、IoT、MES、WMS、IM、HRM、FMS、PMS 等业务模块。前端通过独立 Vue / UniApp 项目配套接入。

当前根 POM 的 Java 编译目标为 **17**，Spring Boot 属性为 **3.5.15**；BOM 中 Flowable 属性为 **8.0.0**。这些是当前源码声明，依赖最终解析结果仍以实际构建为准。Java 是主要业务实现语言；XML、YAML 承载构建与配置，SQL 承载数据库脚本，Velocity 模板承载代码生成。图谱中的 `unknown`、`bkp`、`xdb` 等是扫描格式标识，不应当作项目编程语言。

入口文件：{L('readme')}、{L('rootpom')}、{L('bom')}。

### 先认识两个装配方式

| 方式 | 入口 | 阅读时要确认的内容 |
|---|---|---|
| 聚合应用 | {L('serverapp')} | {L('serverpom')} 当前实际引入哪些业务 server；默认仅 system、infra，其余业务依赖多为注释状态 |
| 独立服务 | {L('gatewayapp')}、{L('systemapp')}、{L('hrmapp')} 等 | 模块服务名、注册发现、配置中心、Feign Client 和对应业务数据库 |

根 POM 将模块纳入 Maven reactor，不等于 `yudao-server` 已装配全部业务。排查“类存在但接口没有加载”时，先看实际启动应用和依赖，再看组件扫描。

## 2. 架构层与职责

以下分层来自知识图谱。它是阅读视图，同一 Maven 模块的文件可能分布在不同层；计数包含 SQL 表等子文件节点，不等于实际文件数。

| 架构层 | 节点数 | 职责 | 起点 |
|---|---:|---|---|
| API 接入层 | 2,530 | REST 请求、网关入口、参数和权限边界 | {L('controller')} |
| 业务服务层 | 1,892 | 业务规则、状态变更、事务及跨模块协作 | {L('employee')} |
| 数据与持久化层 | 1,900 | DO、Mapper、SQL 和表结构 | {L('employeedo')}、{L('employeemapper')} |
| 接口契约与类型层 | 559 | 模块 API、DTO、共享枚举 | {L('userapi')} |
| 共享框架层 | 335 | 统一响应、分页、数据访问、安全、租户等基础能力 | {L('commonresult')}、{L('mapper')} |
| 前端项目层 | 5 | 独立管理端、商城端的 README 入口 | {L('vue')} |
| 配置与构建层 | 216 | Maven 依赖、应用环境、框架装配 | {L('rootpom')}、{L('appconfig')} |
| 运行与部署层 | 35 | 服务入口、Docker、运行包装 | {L('gatewaydocker')} |
| 测试与生成夹具层 | 1,363 | 单元测试、测试数据库、生成器模板及预期输出 | {L('employeetest')}、{L('dbtest')} |
| 文档层 | 104 | 业务知识、ER 图与开发说明 | {L('business')}、{L('erd')} |

典型业务代码依次沿 `Controller → Service → Mapper → 数据库` 阅读。跨服务调用则从 `xxx-api` 契约进入对端 API 实现，再进入对端业务 Service。以上是阅读顺序，具体请求涉及的安全、租户、日志等处理还需核对对应框架配置。

## 3. 必须先理解的约定

### 模块契约与实现

多数业务模块拆成 `xxx-api` 与 `xxx-server`。API 放对外契约和传输对象，server 放启动类、HTTP 接口、业务、持久化及 API 实现。跨模块需要能力时，先查已有 API 和所在服务的 `framework/rpc/config/RpcConfiguration.java`；不要直接依赖对端 Mapper 或 server 内部业务实现。

以 {L('userapi')} 为例，接口使用 `@FeignClient`，返回 `CommonResult`。调用方应按现有约定使用 `getCheckedData()` / `checkError()` 检查远程业务结果，不能把收到 HTTP 响应当作业务成功。

### 请求对象、业务对象与数据对象

`controller/**/vo` 主要承担接口输入输出；`api/**/dto` 承担模块间传输；`dal/dataobject/**` 的 DO 对应持久化数据。先比较三者字段再判断转换和写入流程，尤其关注身份字段、租户字段、金额和状态由谁提供。

{L('bean')} 是已有转换工具入口；部分模块也使用 MapStruct 转换类。应复用所在模块的实际方式。

### 共享响应与持久化基础类

{L('commonresult')}、{L('page')}、{L('base')}、{L('mapper')} 在图谱中被大量文件依赖。先掌握公共响应、分页、审计字段和基础查询方法，再读业务 CRUD，会减少重复理解。

### 权限、租户和错误处理

业务异常码通常位于模块的 `ErrorCodeConstants`。HTTP 错误到统一响应的处理入口见 {L('exception')}；安全过滤链见 {L('security')}。新增接口时检查所在模块的权限、数据权限和租户约定，在入口完成必要校验，在业务中保持清晰的状态转换。

遵循本会话开发约束：复用存量实现、集中校验、明确抛出异常；不要新增空 catch、伪成功返回或未经授权的隐式降级。已有代码中若出现静默返回，也应先确认其业务含义后再决定是否复用。

### Spring 事件的进程边界

Spring `ApplicationEvent` 是本应用进程内通知。独立部署的业务服务不会自动收到 BPM 进程发布的事件；跨服务审批结果需要 RPC/HTTP 等显式交付。聚合模式与独立服务模式的装配差异会影响这一点。

## 4. 推荐阅读导览

以下沿用知识图谱的 12 步顺序，补充本轮源码核对得到的边界。

| 步骤 | 阅读对象 | 应能回答的问题 |
|---|---|---|
| 1. 平台整体概览 | {L('readme')} | 平台有哪些业务模块，前后端项目如何关联？ |
| 2. Maven 模块骨架 | {L('rootpom')}、{L('bom')}、{L('serverpom')} | reactor、版本管理与运行装配分别在哪里？ |
| 3. 服务启动入口 | {L('serverapp')}、{L('gatewayapp')}、{L('systemapp')} | 当前启动的是聚合应用还是独立服务？ |
| 4. 共享框架基座 | {L('commonresult')}、{L('page')}、{L('mapper')} | 返回、分页和基础数据访问有哪些统一约定？ |
| 5. 模块接口契约 | {L('userapi')} | 哪些能力通过 API 暴露，谁负责调用和实现？ |
| 6. 管理端 API | {L('controller')} | HTTP 参数、权限、返回值与 Service 如何衔接？ |
| 7. 员工业务服务 | {L('employee')} | 业务规则、状态和依赖如何组织？先选一个公开方法向下追踪 |
| 8. 员工持久化链路 | {L('employeedo')}、{L('employeemapper')}、{L('hrmsql')} | Java 字段与数据库列如何对应？SQL 草案还缺哪些真实库约束？ |
| 9. 应用运行配置 | {L('appconfig')}、目标模块的 `application*.yaml` | 当前 profile、外部依赖和覆盖来源是什么？ |
| 10. 容器与持续集成 | {L('gatewaydocker')}、{L('compose')}、{L('ci')} | 运行产物如何打包？哪些配置仍是示例或存在版本差异？ |
| 11. 自动化测试支撑 | {L('employeetest')}、{L('dbtest')} | 测试覆盖了哪些状态，数据库如何准备和清理？ |
| 12. 业务与数据文档 | {L('business')}、{L('erd')}、{L('ddl')} | 如何从业务流程回到代码和数据结构，哪些结论是推断？ |

第一次通读后，选择一个实际需求，沿“接口输入 → 权限 → 业务状态 → 写库 → 远程调用/事件 → 响应”走完一条具体链路。不要仅凭类名推断整个模块已经具备某项业务能力。

## 5. 关键文件地图

| 文件或目录 | 作用与定位方法 |
|---|---|
| {L('rootpom')} | Maven 聚合模块、Java 编译目标、编译与测试插件管理 |
| {L('bom')} | 统一第三方和内部依赖版本 |
| {L('serverpom')} | 聚合应用实际引入的业务 server，以及独立启动差异 |
| {L('gatewayconfig')} | 网关服务名、profile、Nacos 导入与路由配置入口 |
| {L('crmrpc')} | 观察一个业务服务如何注册对端 Feign API |
| {L('controller')} | 管理端业务 HTTP 边界示例 |
| {L('employee')} | 员工业务编排示例；按方法阅读，不要求首日通读 |
| {L('employeemapper')} | 员工数据库查询与写入入口 |
| {L('bpmapi')} | 发起和取消流程的模块间契约 |
| {L('instance')} | 流程创建、状态、结束通知等实例生命周期处理 |
| {L('bpmtask')} | 审批任务处理及任务生命周期逻辑 |
| {L('codegen')} | 数据表元信息、模板配置与代码输出的生成引擎 |
| {L('dbtest')} | `unit-test` profile 和测试结束后数据库清理机制 |
| {L('business')} | 18 个业务模块的知识文档入口 |
| {L('ddl')} | 按实体反推 DDL 的范围、缺失项和推断说明 |
| {L('vue')} | Vue3 管理端的独立仓库说明 |

## 6. 第一次本地启动前的检查顺序

本轮没有构建或启动 Java 服务。下面是基于当前配置的准备顺序，不代表已经在这台机器完成环境验证。

1. 明确要读/运行哪个服务，以及采用聚合还是独立服务方式。以实际依赖为准，不能以根 POM 有模块就认定已启用。
2. 检查本机 JDK 和 Maven。根 POM 编译目标为 17，不能沿用旧文档中任意 JDK 版本。
3. 查看目标模块 `application.yaml`、`application-local.yaml`、`application-dev.yaml`，以及声明的 Nacos 导入。网关、BPM、HRM 的基础配置均声明 `local` profile；运行参数和配置中心仍可能覆盖它。
4. 核对目标 profile 的数据库、Redis、注册与配置中心，以及该业务实际启用的外部服务。不要默认所有可选消息组件都要同时启动。
5. 确认数据库来源。`sql/mysql/*.sql` 的部分业务脚本来自实体反推，缺少初始化数据和完整索引/约束；必须先读 DDL 推断说明，再确定实际初始化方案。
6. 构建目标模块及其 reactor 依赖，随后通过 IDE 启动对应 `*Application`。独立服务模式还需确认其依赖服务及服务发现配置。
7. 从服务日志、注册状态、实际接口响应判断启动结果；进程存在不等于业务链路已经联通。

可先执行以下只读环境检查，再按任务选择构建。以下命令本轮未执行：

```bash
java -version
mvn -version

# 示例：编译工作流服务及其依赖，不运行测试
mvn -pl yudao-module-bpm/yudao-module-bpm-server -am compile

# 示例：运行 HRM 及依赖的测试，需先准备对应测试环境
mvn -pl yudao-module-hrm/yudao-module-hrm-server -am test
```

当前基础配置中 gateway、BPM、HRM 分别声明端口 48080、48083、48094；实际运行端口须结合 profile 与外部配置确认。不要把知识图谱仪表板的 5173 端口当作后端业务端口。

## 7. 专项路径：新增模块接入审批

以 CRM 合同审批为接入参考，按顺序阅读：

1. {L('contract')} 的 `submitContract`：检查草稿状态，调用 BPM API，保存流程实例 ID 并改为审批中。
2. {L('bpmapi')} 与创建 DTO：确认 `processDefinitionKey`、`businessKey`、`variables`、`startUserSelectAssignees` 的意义。
3. {L('instance')}：核对可用流程定义、发起权限、自选审批人和实例创建。
4. {L('bridge')} 与 {L('bpmrpc')}：BPM 内按流程 Key 监听事件，通过 HTTP 向 CRM 交付结果。
5. {L('callback')}：业务服务接收回调并调用业务 Service 更新状态。
6. {L('leave')}：对照“当前流程实例 + 审批中状态”的条件更新方式，识别重复、旧流程通知与终态处理。

新增模块应分别负责：业务单据与状态、流程 Key 与模型配置、流程发起、当前实例关联、结果接收、审批通过后的业务动作。需要审批的分支条件由服务端业务数据构造为流程变量；业务表单选择 CUSTOM 时，单据由业务模块持久化。

独立部署时必须提供跨服务结果桥接。HRM 请假当前的监听器是本地事件监听，在已核对的 BPM RPC 配置中未发现 HRM 对应桥接，不能仅复制它就宣称远程回调已打通。BPM 的流程后置通知仅在 APPROVE 分支执行，也不能替代拒绝、取消的完整终态同步。

实施前明确重复提交、远程超时、创建成功但业务保存失败、旧实例通知和重复终态通知的处理规则。本地事务无法自动回滚另一个服务已经创建的流程。回调入口还要验证权限、租户、流程 Key 和参数，错误应清楚暴露并可追踪。

## 8. 复杂度热点

下面均是图谱标记为 `complex` 的生产 Java 文件；行数来自本轮文件读取，仅用于说明阅读体量，不等于缺陷数量或完整复杂度排名。

| 热点 | 当前行数 | 阅读方式 |
|---|---:|---|
| {L('bpmtask')} | 1,717 | 按一次审批动作追踪任务状态变化、监听和后续动作，避免同时改动多个状态分支 |
| {L('employee')} | 1,606 | 先确定具体员工操作，再核对相关实体、校验、事务和测试 |
| {L('voucher')} | 1,110 | 这是财务凭证服务；结合账套、期间和凭证处理方法理解，不采信图谱里误写的 MES 仓储摘要 |
| {L('instance')} | 1,070 | 重点区分创建、通过、拒绝、取消、事件发布及 HTTP 通知边界 |
| {L('codegen')} | 832 | 对照输入元信息、Velocity 模板和测试快照，确认生成内容及路径 |
| {L('model')} | 761 | 从一次模型创建请求追踪供应商选择、配置和实例复用 |
| {L('security')} | 221 | 体量较小但影响面大，先核对匹配规则和现有访问行为再改动 |

共享基础类即使行数少，也可能有较大的影响范围。例如分页结果、统一响应、基础 Mapper 被大量模块导入；修改前应搜索调用者并核对其行为约定。

## 9. 图谱、文档与验证边界

- 图谱与当前 HEAD 一致；本轮检查未发现 `.ua` 之外的已提交差异、暂存改动、未暂存改动或未跟踪项目文件。
- 结构图覆盖此前扫描的 8,368 个文件，包含 30,807 个节点、73,083 条边、10 层和 12 步导览。这是静态分析覆盖，不等于所有模块均已启动或业务验收完成。
- 本次主要读取文件级节点、层和导览；少量关键事实以源码重新核对。图谱存在模板化和错位摘要，例如 FMS 凭证服务曾被描述成 MES 仓储，指南已纠正涉及部分；其余摘要仍应当作导航线索。
- 图谱中的前端仅有 5 个 README。前端路由、页面组件及启动命令，需要进入对应独立前端仓库再确认。
- 12 步导览中 HRM 表结构引用的是反推 DDL；ER 图也不能证明数据库实际存在物理外键。
- 当前 CI 工作流仍列出 Java 8、11、17，但根 POM 编译目标已为 17；其打包命令设置 `-Dmaven.test.skip=true`。不能据此声称当前代码支持 Java 8/11，或 CI 已验证单元测试。
- Docker Compose 包含需要替换的外部地址和旧镜像命名，应先与当前构建产物对照。部分 Dockerfile 注释端口与指令存在差异，排查时以实际配置和指令为准。
- 此前图谱合并省略了显著性门槛以下的部分辅助方法，调用边不构成完整运行时调用追踪。
- 本轮未执行 Maven 构建、测试、数据库初始化或服务间联调。

## 10. 新同事的首个交付目标

完成入门后，应能说明一个具体业务请求从哪里进入、用到哪个 Service 与 Mapper、如何进行权限/租户控制，以及状态在哪一步发生变化。接着选择一个小需求，列出涉及的接口、业务规则、数据和跨服务边界，复用现有代码完成最小变更，并运行与改动直接相关的验证。

本指南当前位于 `.ua/UA_ONBOARDING.md`，供你先审阅。若团队需要将其纳入仓库，可保存为 `docs/UA_ONBOARDING.md` 并通过正常代码评审提交；后续修改关键模块或启动方式时同步维护。
''')
text='\n'.join(s)
out=root/'.ua/UA_ONBOARDING.md';out.write_text(text)
print(json.dumps({'path':str(out),'lines':len(text.splitlines()),'characters':len(text),'sourceLinks':len(paths),'graphCommit':g['project']['gitCommitHash']},ensure_ascii=False))
