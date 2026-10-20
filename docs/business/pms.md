# PMS 项目协作与知识库模块业务知识

> 本文依据当前工作区的 Controller、ServiceImpl、DO、枚举和静态调用关系整理；未启动服务、未导入 Excel、未发送通知、未验证数据权限或页面交互。配套材料：[推导 DDL](../../sql/mysql/pms.sql) · [ER 图](../er/pms-er.drawio)。PMS 在当前实现中包含项目管理（PM）和知识库（KB）两个相邻但独立的业务域。

## 技术栈、服务模块与主要作用

| 项目 | 当前代码依据 |
| --- | --- |
| 后端服务 | `yudao-module-pms-server`（[pom.xml](../../yudao-module-pms/yudao-module-pms-server/pom.xml)） |
| 基础技术栈 | Java 17、Spring Boot 3.5.15、Maven、MyBatis、租户/安全、模块 RPC、Nacos 服务发现与配置。 |
| 模块专项依赖 | System/Infra/PMS API、任务调度、Excel 与监控 starter。 |
| 主要作用 | 提供项目、成员、工作项、迭代与知识库、文档、权限、互动和回收站能力。 |

## 1. 定位与责任边界

PMS 是面向系统用户的协作工作台：项目域管理项目、成员、迭代、事项、看板、工时和公告；知识库域管理知识库、目录、文档、内容权限、互动和回收站。二者共用用户、通知和租户等基础能力，但项目事项不会自动变成知识库文档，知识库文档也不是项目需求的附件替代。

项目当前的核心粒度是“项目—成员—迭代—工作项”。工作项可表示需求、任务、缺陷等类型，状态配置驱动看板列和生命周期分类。知识库的核心粒度是“知识库—目录/文档—内容权限”，并提供点赞、评论、收藏、分享、最近访问和回收站。代码中没有看到 Git 仓库、代码评审、CI、文件二进制存储或全文搜索引擎由 PMS 自己实现。

## 2. 项目管理业务域

| 业务域 | 核心表 | 作用 |
| --- | --- | --- |
| 项目与模板 | `pms_project`、`pms_project_template` | 创建不同类型/场景项目，维护负责人、级别、状态与模板配置。 |
| 项目成员与分组 | `pms_project_member`、`pms_project_group`、`pms_project_group_relation`、`pms_project_favorite`、`pms_project_announcement` | 成员级别、项目分组/排序、收藏和公告；组关系记录项目被放入哪个组。 |
| 迭代 | `pms_iteration` | 保存周期、负责人和状态，提供开始、完成、概览、进度、趋势和燃尽数据。 |
| 工作项与看板 | `pms_work_item`、`pms_work_item_member`、`pms_work_item_status`、`pms_work_item_board`、`pms_work_item_user_sort` | 需求/任务/缺陷等工作项、参与人、可配置状态、看板列及个人排序。 |
| 协作记录 | `pms_work_item_comment`、`pms_work_item_activity`、`pms_work_item_label`、`pms_work_item_work_log` | 评论、操作动态、标签和工时，工作台可汇总用户待办。 |

项目创建后会初始化相应工作项状态和看板配置；工作项创建/更新时校验项目仍可编辑、工作项类型与项目匹配、父级/关联需求/成员等关系合法。状态不只是一个自由文本：状态配置还带状态类型，并会影响看板列和事项的生命周期表达。[项目创建](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/pm/project/PmsProjectServiceImpl.java:87) · [状态初始化](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/pm/workitem/PmsWorkItemStatusServiceImpl.java:261) · [事项关系校验](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/pm/workitem/PmsWorkItemServiceImpl.java:823)

## 3. 知识库业务域

| 业务域 | 核心表 | 作用 |
| --- | --- | --- |
| 知识库与成员 | `pms_knowledge_library`、`pms_knowledge_library_member`、`pms_knowledge_library_template`、`pms_knowledge_group`、`pms_knowledge_group_relation` | 创建知识库、维护成员级别、模板和个人分组/排序。 |
| 内容与权限 | `pms_knowledge_folder`、`pms_knowledge_document`、`pms_knowledge_document_label`、`pms_knowledge_content_permission`、`pms_knowledge_content_permission_member` | 目录树、文档、标签与可读/可写/可删/可管理的内容级权限。 |
| 互动与外部分享 | `pms_knowledge_document_comment`、`like`、`favorite`、`share`、`view_record` | 评论、点赞、收藏、分享 token 和最近访问。 |
| 回收站 | `pms_knowledge_recycle_record` | 记录库/目录/文档被回收及恢复/永久删除所需的快照和关联。 |

知识库成员权限与内容权限是两层：先需要可访问知识库，再按文档/目录引用的内容权限判断读写删管。内容权限可以继承默认权限，也可带成员/部门范围；不能仅凭“是知识库成员”假定可编辑所有文档。[权限校验层级](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/kb/content/PmsKnowledgeContentPermissionServiceImpl.java:127)

## 4. 核心对象关系

项目 `pms_project` 与成员、公告、收藏、分组关系相连；迭代和工作项均归属项目。工作项可以有父项、关联需求、迭代、状态、多个成员、标签、评论、动态和工时。事项状态 ID 关联项目/类型下的状态配置，删除状态时需处理/迁移仍引用该状态的工作项，不能任意物理删除状态配置。

知识库 `pms_knowledge_library` 是目录和文档的根边界；目录可构成树，文档可有父文档/目录位置并带内容权限 ID。文档标签、评论、点赞、收藏、浏览记录和分享均以文档为目标。分享 token 是外部读取入口的凭据，而不是把文档复制成一份公开文档。[文档放置与层级规范化](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/kb/content/PmsKnowledgeDocumentServiceImpl.java:360) · [分享 token 查询](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/kb/interaction/PmsKnowledgeDocumentShareServiceImpl.java:155)

## 5. 端到端流程

### 5.1 从项目模板到成员协作空间

1. 用户通过 `/pms/pm/project/create` 创建项目，可选择项目类型、场景、模板和负责人等信息。
2. 项目服务保存项目，并为项目建立相应成员/默认状态等初始化数据；模板提供起始配置，不代表模板与已创建项目持续双向同步。
3. 项目负责人通过项目成员接口维护成员列表和级别，成员可收藏项目，项目可按个人分组组织。
4. 管理者发布项目公告；项目概览汇总成员、事项、迭代及状态分布供工作台展示。
5. 项目可归档、回收、恢复或删除，每一步都会检查相应负责人/管理员权限及当前项目状态。

[项目概览](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/pm/project/PmsProjectServiceImpl.java:181) · [归档/回收/恢复](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/pm/project/PmsProjectServiceImpl.java:251)。

### 5.2 创建工作项、分派成员并在看板推进

1. 项目成员创建需求、任务或缺陷等工作项，填写项目、类型、名称、优先级、状态、可选父项/关联需求/迭代和成员。
2. 服务检查项目未归档/回收、事项类型允许、状态属于该项目该类型，父项及关联需求在相同项目中，受理人属于项目成员。
3. 保存主工作项后，保存成员关联、标签和活动记录；当受理人变化时会发送分配通知。
4. 用户通过更新状态、迭代、排序或规划排序推进工作；看板按状态配置/board 配置聚合，个人排序存入单独表。
5. 事项可归档、回收、恢复或删除；进入非活动状态的项目/事项会限制继续编辑。评论、工时和动态提供协作痕迹。

[事项创建](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/pm/workitem/PmsWorkItemServiceImpl.java:127) · [状态变更](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/pm/workitem/PmsWorkItemServiceImpl.java:269) · [看板数据](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/pm/workitem/PmsWorkItemServiceImpl.java:728)。

### 5.3 计划、启动和完成迭代

1. 有项目写权限的用户创建迭代，设置周期、负责人和目标。
2. 通过工作项接口把需求/任务/缺陷关联到迭代；一个工作项的迭代归属变化会被记录并影响看板/概览。
3. 负责人调用启动接口，服务确认项目可写及负责人条件后将迭代推进至进行中。
4. 工作项持续变更状态，迭代概览按事项状态构建最近动态、趋势、燃尽等响应数据。
5. 完成迭代后该迭代不再是未完成迭代；删除迭代或删除项目时，服务会清理/解除有关工作项迭代关联。

[迭代状态动作](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/pm/iteration/PmsIterationServiceImpl.java:82) · [迭代概览](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/pm/iteration/PmsIterationServiceImpl.java:172)。

### 5.4 创建知识库、组织内容并设置细粒度权限

1. 用户创建知识库并维护成员列表；服务为新库创建默认内容权限，成员级别决定其库级能力。
2. 成员创建目录或文档时，服务校验目标库、父目录/文档位置和当前用户的内容写权限；文档可带标签和内容权限。
3. 文档/目录移动到新位置或新知识库时，服务规范化位置并校验目标可写；复制/迁移权限时会克隆权限对象而不是共用错误的库内成员范围。
4. 查询或搜索文档前，通过库成员和内容权限筛掉不可读项；文档读取会记录访问，用于最近列表。
5. 有权限用户可更新内容权限成员清单，分别控制读、写、删、管理；权限变更影响后续访问，已导出的内容不在此模块追踪。

[创建/更新/移动文档](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/kb/content/PmsKnowledgeDocumentServiceImpl.java:76) · [内容权限更新](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/kb/content/PmsKnowledgeContentPermissionServiceImpl.java:303)。

### 5.5 文档互动、外链分享和回收恢复

1. 可读用户可以点赞、收藏、评论，评论服务先验证文档仍可评论，删除评论要求评论所有者；这些互动不授予文档编辑权。
2. 有分享权限的用户为文档开启分享，生成 token 并可更新指定分享成员或关闭分享；外部读取根据 token 再获取活动分享和文档。
3. 删除知识库、目录或文档时，不直接视为永久删除：回收服务保存 `pms_knowledge_recycle_record`，并处理下级目录/文档及相关权限、互动数据的状态。
4. 用户可查看回收列表/预览并恢复。恢复时会排除受保护的目标、恢复文档和权限关系；与当前内容冲突的细节需要按服务规则处理。
5. 用户可以执行永久删除，过期回收记录也有清理入口；永久删除会进一步清理文档、互动、分享等关联数据。

[评论权限](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/kb/interaction/PmsKnowledgeDocumentCommentServiceImpl.java:44) · [开启/关闭分享](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/kb/interaction/PmsKnowledgeDocumentShareServiceImpl.java:62) · [回收/恢复/永久删除](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/service/kb/recycle/PmsKnowledgeRecycleServiceImpl.java:306)。

## 6. 状态规则、协作与典型场景

项目状态决定能否编辑，项目归档/回收后相关写操作会受限；工作项有活动、归档、回收等生命周期，且业务状态由项目内状态配置与状态类型表达。迭代有创建、进行中、完成等状态，开始/完成由项目权限与负责人校验。状态迁移和生命周期归档并不是同一维度。

知识库侧，库/目录/文档的存在状态与内容权限分离；回收站记录提供延迟永久删除路径。文档分享为单独活动分享状态，点赞、评论、收藏是互动状态，不等同于读写权限。

- 与 **system** 协作：用户、部门、通知和通用权限为项目成员、内容权限成员和分派通知提供身份基础。
- 与 **infra** 协作：文档正文里的附件/链接若使用文件服务，其二进制存储不在 PMS 表；本文未确认编辑器上传链路。
- 与 **AI**：未在本次 PMS 主流程中发现已实现的知识库自动向 AI 向量库同步；两个“知识库”不能因名称相同视为同一份数据。

典型场景：产品负责人从模板创建项目，配置状态列并邀请成员；开发人员把需求拆为任务/缺陷、安排迭代、登记工时并由工作台查看待办；团队建设私有知识库，按文档给协作者只读或可编辑权限，向外部生成 token 分享一篇文档，误删后从回收站恢复。

## 7. 已实现局限和需要验证的点

- 未发现 Git、代码提交、CI/CD、工时审批、容量规划、跨项目依赖图或自动排期引擎；工作项的父级/关联需求不是完整项目组合管理。
- 看板、燃尽和趋势由查询时数据构造，统计口径、时区、历史状态快照与大数据量性能需要运行验证。
- 知识库文档的富文本编辑、附件上传、全文检索、病毒扫描、分享 token 访问审计/过期策略不应仅从文档表和分享表推出。
- 内容权限包含用户/部门及多级权限计算，真实数据权限拦截应以所有 Controller、Mapper 和前端入口的运行测试确认。
- 回收恢复/永久删除涉及树结构与关联内容，尤其在并发移动、重名、权限变更时需做数据库集成测试。

## 8. Controller 包接口覆盖与源码入口

全部控制器位于 `controller/admin`，下表覆盖扫描到的 Controller 包和接口域：

| 一级域 | Controller 包 | 覆盖能力 |
| --- | --- | --- |
| PM 项目 | `pm/project` | 项目、成员、分组、收藏、公告、模板的创建/更新/列表/归档/回收/恢复等 |
| PM 迭代与工作台 | `pm/iteration`、`pm/workbench` | 迭代创建/启动/完成/概览、我的事项/迭代/统计工作台 |
| PM 工作项 | `pm/workitem` | 事项、状态、看板、标签、评论、活动、工时；排序、规划、导入导出和回收操作 |
| KB 库 | `kb/library` | 知识库、成员、分组、模板的维护与成员退出 |
| KB 内容 | `kb/content` | 目录树、文档创建/移动/搜索、标签和内容权限 |
| KB 互动 | `kb/interaction` | 评论、点赞、收藏、分享、浏览/最近访问 |
| KB 回收 | `kb/recycle` | 回收列表、详情/预览、恢复和永久删除 |

建议先阅读 [PmsProjectController](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/controller/admin/pm/project/PmsProjectController.java:51) → `PmsProjectServiceImpl` → `PmsWorkItemServiceImpl` → `PmsIterationServiceImpl`，再阅读知识库 `PmsKnowledgeLibraryController` → `PmsKnowledgeDocumentServiceImpl` → `PmsKnowledgeContentPermissionServiceImpl` → 回收/分享/互动服务。
