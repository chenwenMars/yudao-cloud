# ER 图说明与关联依据

- 输入：`sql/mysql/ruoyi-vue-pro.sql`；48 张表、711 个字段。
- 扫描：当前工作区 `6479` 个后端生产 Java 文件中的 `@TableName` 映射；匹配 46 张 SQL 表。随后阅读相关 DO、Service、Mapper、文件客户端与租户框架实现。
- SQL 未包含的生产实体映射：453 项，详见 [缺失表清单](missing-sql-tables.md)。此统计不包含无 `@TableName` 的引擎托管表、动态表及外部服务库表。
- 没有执行 SQL、连接数据库或读取线上数据；未验证运行时约束或数据完整性。
- 本文件不包含 DML 数据、密码、密钥等种子记录。表结构保持 SQL 原文，未根据 Java 类型猜测 SQL 类型。

## 打开与阅读

打开 `ruoyi-vue-pro-er.drawio`。第一页是全量图，后续 13 页是业务领域详情。
表名、字段名、类型均单行；只有注释允许换行。所有 711 个字段（包括审计字段）完整保留。
图形是可编辑的 draw.io 原生表卡片和字段单元格，并非整图图片。
全量图的“跨域关系”和“租户关系”图层默认隐藏，避免跨域线网遮挡表内容；在 draw.io 的图层面板中可开启。域内关系始终显示；详情页用灰色小卡片呈现外部表关联锚点。

## 关系含义与边界

- SQL 没有声明 `FOREIGN KEY`；蓝色实线是代码支持的逻辑关联，不能理解成数据库强制约束。
- 乌鸦脚表示多端，单竖线表示单端；表达应用关系的最大基数，不承诺数据库非空、存在性或唯一性。
- 紫色虚线是 JSON/数组编号集合、条件匹配或多态用户关联；user_type=2 才指向 system_users，user_type=1 指向未包含的 member_user。
- 橙色点线为仅凭 DDL 语义推断的任务日志关联。当前后端未找到 infra_job、infra_job_log 实体/实现，不能宣称已经代码验证。
- `system_users.post_ids` 与 `system_user_post` 均存在，用户服务创建和更新时同步岗位关系，两者都保留。
- OAuth2 `client_id` 指向 `system_oauth2_client.client_id`，而非 `id`；部分 DO 旧注释与 Mapper/Service 不一致，以实现为准。
- `yudao_demo03_grade.student_id` 在应用中按单条记录处理，但 DDL 没有唯一索引，因此图中的单条关系不等同于数据库唯一约束。
- 文件内容在 DB 存储条件下按 `(config_id,path)` 查询；允许同路径多条记录并取最新，不画成固定 1:1 外键。
- `creator` / `updater` 是审计字符串，`biz_id` 随业务类型变化，`trace_id` 是追踪标识；这些字段没有足够统一目标，不凭名称画外键。
- 短信/邮件/站内信日志中的 template_code、内容等是冗余快照；通过 template_id 体现模板关系，避免重复连线。
- tenant_id 保留 SQL 字段；租户字段关联并不表示每张表当前都启用了框架租户过滤，需结合继承、@TenantIgnore 和配置。

## 逐条关联依据

| 引用字段 | 目标字段 | 类型 | 代码 / DDL 依据 | 说明 |
|---|---|---|---|---|
| `system_users.dept_id` | `system_dept.id` | logic | [AdminUserDO.java:57](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/user/AdminUserDO.java#L57) |  |
| `system_dept.parent_id` | `system_dept.id` | logic | [DeptDO.java:24](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/dept/DeptDO.java#L24) | 根节点 parent_id=0 不对应真实记录 |
| `system_dept.leader_user_id` | `system_users.id` | logic | [DeptDO.java:48](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/dept/DeptDO.java#L48) |  |
| `system_menu.parent_id` | `system_menu.id` | logic | [MenuDO.java:63](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/permission/MenuDO.java#L63) | 根节点 parent_id=0 |
| `system_user_post.user_id` | `system_users.id` | logic | [UserPostDO.java:32](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/dept/UserPostDO.java#L32) |  |
| `system_user_post.post_id` | `system_post.id` | logic | [UserPostDO.java:38](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/dept/UserPostDO.java#L38) |  |
| `system_user_role.user_id` | `system_users.id` | logic | [UserRoleDO.java:29](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/permission/UserRoleDO.java#L29) |  |
| `system_user_role.role_id` | `system_role.id` | logic | [UserRoleDO.java:33](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/permission/UserRoleDO.java#L33) |  |
| `system_role_menu.role_id` | `system_role.id` | logic | [RoleMenuDO.java:29](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/permission/RoleMenuDO.java#L29) |  |
| `system_role_menu.menu_id` | `system_menu.id` | logic | [RoleMenuDO.java:33](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/permission/RoleMenuDO.java#L33) |  |
| `system_users.post_ids` | `system_post.id` | collection | [AdminUserServiceImpl.java:117](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/user/AdminUserServiceImpl.java#L117) | 岗位编号集合；与用户岗位关联表同时维护 |
| `system_role.data_scope_dept_ids` | `system_dept.id` | collection | [PermissionServiceImpl.java:303](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/permission/PermissionServiceImpl.java#L303) | 自定义数据范围部门集合 |
| `system_tenant.package_id` | `system_tenant_package.id` | logic | [TenantDO.java:35](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/tenant/TenantDO.java#L35) | 系统内置租户 package_id=0 为特殊值 |
| `system_tenant.contact_user_id` | `system_users.id` | logic | [TenantServiceImpl.java:118](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/tenant/TenantServiceImpl.java#L118) |  |
| `system_tenant_package.menu_ids` | `system_menu.id` | collection | [TenantServiceImpl.java:138](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/tenant/TenantServiceImpl.java#L138) | 套餐菜单编号集合 |
| `system_oauth2_access_token.client_id` | `system_oauth2_client.client_id` | logic | [OAuth2ClientMapper.java:27](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/mysql/oauth2/OAuth2ClientMapper.java#L27) | 关联客户端业务编号，非主键 id |
| `system_oauth2_refresh_token.client_id` | `system_oauth2_client.client_id` | logic | [OAuth2ClientMapper.java:27](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/mysql/oauth2/OAuth2ClientMapper.java#L27) | 关联客户端业务编号，非主键 id |
| `system_oauth2_code.client_id` | `system_oauth2_client.client_id` | logic | [OAuth2ClientMapper.java:27](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/mysql/oauth2/OAuth2ClientMapper.java#L27) | 关联客户端业务编号，非主键 id |
| `system_oauth2_approve.client_id` | `system_oauth2_client.client_id` | logic | [OAuth2ClientMapper.java:27](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/mysql/oauth2/OAuth2ClientMapper.java#L27) | 关联客户端业务编号，非主键 id |
| `system_oauth2_access_token.refresh_token` | `system_oauth2_refresh_token.refresh_token` | logic | [OAuth2TokenServiceImpl.java:184](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/oauth2/OAuth2TokenServiceImpl.java#L184) |  |
| `system_social_user_bind.social_user_id` | `system_social_user.id` | logic | [SocialUserBindDO.java:46](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/social/SocialUserBindDO.java#L46) |  |
| `system_mail_template.account_id` | `system_mail_account.id` | logic | [MailTemplateDO.java:45](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/mail/MailTemplateDO.java#L45) |  |
| `system_mail_log.account_id` | `system_mail_account.id` | logic | [MailLogDO.java:74](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/mail/MailLogDO.java#L74) |  |
| `system_mail_log.template_id` | `system_mail_template.id` | logic | [MailLogDO.java:88](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/mail/MailLogDO.java#L88) |  |
| `system_sms_template.channel_id` | `system_sms_channel.id` | logic | [SmsTemplateDO.java:85](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/sms/SmsTemplateDO.java#L85) |  |
| `system_sms_log.channel_id` | `system_sms_channel.id` | logic | [SmsLogDO.java:46](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/sms/SmsLogDO.java#L46) |  |
| `system_sms_log.template_id` | `system_sms_template.id` | logic | [SmsLogDO.java:61](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/sms/SmsLogDO.java#L61) |  |
| `system_notify_message.template_id` | `system_notify_template.id` | logic | [NotifyMessageDO.java:55](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/dal/dataobject/notify/NotifyMessageDO.java#L55) |  |
| `system_dict_data.dict_type` | `system_dict_type.type` | logic | [DictDataServiceImpl.java:68](../../yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/dict/DictDataServiceImpl.java#L68) |  |
| `infra_file.config_id` | `infra_file_config.id` | logic | [FileDO.java:33](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/dal/dataobject/file/FileDO.java#L33) |  |
| `infra_file_content.config_id` | `infra_file_config.id` | logic | [FileContentDO.java:37](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/dal/dataobject/file/FileContentDO.java#L37) |  |
| `infra_file.path` | `infra_file_content.path` | conditional | [DBFileClient.java:46](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/framework/file/core/client/db/DBFileClient.java#L46) | DB存储时按(config_id,path)匹配；可重复，取最新记录；非1:1 |
| `infra_codegen_column.table_id` | `infra_codegen_table.id` | logic | [CodegenColumnDO.java:32](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/dal/dataobject/codegen/CodegenColumnDO.java#L32) |  |
| `infra_codegen_column.dict_type` | `system_dict_type.type` | logic | [CodegenColumnDO.java:92](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/dal/dataobject/codegen/CodegenColumnDO.java#L92) |  |
| `infra_codegen_table.data_source_config_id` | `infra_data_source_config.id` | logic | [CodegenTableDO.java:37](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/dal/dataobject/codegen/CodegenTableDO.java#L37) |  |
| `infra_codegen_table.parent_menu_id` | `system_menu.id` | logic | [CodegenTableDO.java:115](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/dal/dataobject/codegen/CodegenTableDO.java#L115) |  |
| `infra_codegen_table.master_table_id` | `infra_codegen_table.id` | logic | [CodegenTableDO.java:124](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/dal/dataobject/codegen/CodegenTableDO.java#L124) |  |
| `infra_codegen_table.sub_join_column_id` | `infra_codegen_column.id` | logic | [CodegenTableDO.java:130](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/dal/dataobject/codegen/CodegenTableDO.java#L130) |  |
| `infra_codegen_table.tree_parent_column_id` | `infra_codegen_column.id` | logic | [CodegenTableDO.java:146](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/dal/dataobject/codegen/CodegenTableDO.java#L146) |  |
| `infra_codegen_table.tree_name_column_id` | `infra_codegen_column.id` | logic | [CodegenTableDO.java:154](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/dal/dataobject/codegen/CodegenTableDO.java#L154) |  |
| `infra_job_log.job_id` | `infra_job.id` | inferred | [ruoyi-vue-pro.sql:384](../../sql/mysql/ruoyi-vue-pro.sql#L384) | 仅根据DDL字段及注释推断；当前后端无对应实体/实现 |
| `yudao_demo03_course.student_id` | `yudao_demo03_student.id` | logic | [Demo03CourseInnerMapper.java:18](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/dal/mysql/demo/demo03/inner/Demo03CourseInnerMapper.java#L18) |  |
| `yudao_demo03_grade.student_id` | `yudao_demo03_student.id` | logic | [Demo03GradeInnerMapper.java:18](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/dal/mysql/demo/demo03/inner/Demo03GradeInnerMapper.java#L18) | 应用按学生取单条班级记录；DDL未设唯一约束 |
| `yudao_demo02_category.parent_id` | `yudao_demo02_category.id` | logic | [Demo02CategoryDO.java:38](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/dal/dataobject/demo/demo02/Demo02CategoryDO.java#L38) |  |
| `infra_api_error_log.process_user_id` | `system_users.id` | logic | [ApiErrorLogServiceImpl.java:77](../../yudao-module-infra/yudao-module-infra-server/src/main/java/cn/iocoder/yudao/module/infra/service/logger/ApiErrorLogServiceImpl.java#L77) |  |
| `infra_api_access_log.user_id` | `system_users.id` | polymorphic | [UserTypeEnum.java:18](../../yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/enums/UserTypeEnum.java#L18) | 仅 user_type=2；user_type=1 → member_user（SQL未包含） |
| `infra_api_access_log.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `infra_api_error_log.user_id` | `system_users.id` | polymorphic | [UserTypeEnum.java:18](../../yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/enums/UserTypeEnum.java#L18) | 仅 user_type=2；user_type=1 → member_user（SQL未包含） |
| `infra_api_error_log.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_dept.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_login_log.user_id` | `system_users.id` | polymorphic | [UserTypeEnum.java:18](../../yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/enums/UserTypeEnum.java#L18) | 仅 user_type=2；user_type=1 → member_user（SQL未包含） |
| `system_login_log.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_mail_log.user_id` | `system_users.id` | polymorphic | [UserTypeEnum.java:18](../../yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/enums/UserTypeEnum.java#L18) | 仅 user_type=2；user_type=1 → member_user（SQL未包含） |
| `system_notice.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_notify_message.user_id` | `system_users.id` | polymorphic | [UserTypeEnum.java:18](../../yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/enums/UserTypeEnum.java#L18) | 仅 user_type=2；user_type=1 → member_user（SQL未包含） |
| `system_notify_message.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_oauth2_access_token.user_id` | `system_users.id` | polymorphic | [UserTypeEnum.java:18](../../yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/enums/UserTypeEnum.java#L18) | 仅 user_type=2；user_type=1 → member_user（SQL未包含） |
| `system_oauth2_access_token.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_oauth2_approve.user_id` | `system_users.id` | polymorphic | [UserTypeEnum.java:18](../../yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/enums/UserTypeEnum.java#L18) | 仅 user_type=2；user_type=1 → member_user（SQL未包含） |
| `system_oauth2_approve.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_oauth2_code.user_id` | `system_users.id` | polymorphic | [UserTypeEnum.java:18](../../yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/enums/UserTypeEnum.java#L18) | 仅 user_type=2；user_type=1 → member_user（SQL未包含） |
| `system_oauth2_code.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_oauth2_refresh_token.user_id` | `system_users.id` | polymorphic | [UserTypeEnum.java:18](../../yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/enums/UserTypeEnum.java#L18) | 仅 user_type=2；user_type=1 → member_user（SQL未包含） |
| `system_oauth2_refresh_token.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_operate_log.user_id` | `system_users.id` | polymorphic | [UserTypeEnum.java:18](../../yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/enums/UserTypeEnum.java#L18) | 仅 user_type=2；user_type=1 → member_user（SQL未包含） |
| `system_operate_log.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_post.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_role.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_role_menu.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_sms_code.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_sms_log.user_id` | `system_users.id` | polymorphic | [UserTypeEnum.java:18](../../yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/enums/UserTypeEnum.java#L18) | 仅 user_type=2；user_type=1 → member_user（SQL未包含） |
| `system_social_client.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_social_user.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_social_user_bind.user_id` | `system_users.id` | polymorphic | [UserTypeEnum.java:18](../../yudao-framework/yudao-common/src/main/java/cn/iocoder/yudao/framework/common/enums/UserTypeEnum.java#L18) | 仅 user_type=2；user_type=1 → member_user（SQL未包含） |
| `system_social_user_bind.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_user_post.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_user_role.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `system_users.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `yudao_demo01_contact.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `yudao_demo02_category.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `yudao_demo03_course.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `yudao_demo03_grade.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |
| `yudao_demo03_student.tenant_id` | `system_tenant.id` | tenant | [TenantBaseDO.java:19](../../yudao-framework/yudao-spring-boot-starter-biz-tenant/src/main/java/cn/iocoder/yudao/framework/tenant/core/db/TenantBaseDO.java#L19) | 租户编号逻辑关联；是否启用租户隔离需结合实体/配置 |

## 交付核验

- 独立统计 SQL：48 条 CREATE TABLE、711 条字段定义、0 条 FOREIGN KEY。
- XML 全量页逐字段比对名称、类型、注释，48/48 张表、711/711 个字段一致。
- 全部 14 页的单元格 ID、父子层级及关系端点检查通过；表格不重叠。
- 140 条分页连线使用直角路径，并检查路径不穿过表格内部。
- 浏览器字体测量检查 2181 项表名、字段名、类型与注释文本，横向溢出为 0。
- 使用 draw.io Desktop 实际导出全量图、组织权限、日志、代码生成页面，抽查长字段、长注释与连线布局。
- [全量预览](ruoyi-vue-pro-er-overview.png) 是缩略预览；完整细节请打开 draw.io 文件放大查看。
- 机器可读核验记录见 [verification.json](verification.json)。
