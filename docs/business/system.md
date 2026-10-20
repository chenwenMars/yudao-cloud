# System 系统管理业务知识

> 本文依据当前 System 模块后端代码静态阅读整理，未启动认证、消息、邮件、短信、OAuth2 或多租户环境。

关联资料：[DDL](../../sql/mysql/system.sql)｜[ER 图](../er/system-er.drawio)｜[关系依据](../er/module-data/system.json)

## 模块定位

System 是后台身份、组织权限、多租户和通用沟通能力的基础域。它维护管理员用户、部门/岗位、角色/菜单/授权关系、租户套餐、OAuth2 客户端与 token、字典、地区、短信、邮件、站内信、公告、社交账号、登录和操作日志。会员用户不在这里建主体表，Member 模块通过 System 的公共 API 使用验证码、令牌、社交绑定与日志。

## 身份、组织与权限

### 管理员账号和组织结构

`system_users` 关联部门、岗位集合和角色集合；`system_dept` 是树形组织，`system_post` 是岗位。创建/更新用户时会检查用户名、手机、邮箱、部门、岗位等条件，导入用户也走同一服务逻辑，[AdminUserServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/user/AdminUserServiceImpl.java:99)。部门删除及调整会校验父子关系和关联用户，避免把组织树直接删坏，[DeptServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/dept/DeptServiceImpl.java:43)。

角色 `system_role` 通过 `system_user_role` 赋给用户，通过 `system_role_menu` 拥有菜单权限；`system_menu` 同时表达目录、菜单、按钮等前端/权限资源。分配角色菜单或用户角色不是全删全插，而是计算新增和删除集合，同时清相关缓存，[PermissionServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/permission/PermissionServiceImpl.java:126)。数据范围有全部、自定义部门、本部门、本部门及下级、仅本人五类，[DataScopeEnum](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-api/src/main/java/cn/iocoder/yudao/module/system/enums/permission/DataScopeEnum.java:14)，但具体 SQL 如何把范围注入查询由框架/业务模块共同决定。

### 后台认证与令牌

后台支持账号密码、短信验证码和社交授权登录；账号密码和注册会按配置校验图形验证码，登录成功创建 OAuth2 access token 与登录日志，禁用用户会被拒绝。[AdminAuthServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/auth/AdminAuthServiceImpl.java:81)。短信验证码按手机号、场景生成，限制同日频率/次数，使用时检查场景、过期与未使用状态并标记已使用，[SmsCodeServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/sms/SmsCodeServiceImpl.java:42)。

OAuth2 包含客户端、授权码、access token、refresh token 和审批记录。授权服务支持 implicit、authorization_code、password、refresh_token、client_credentials 等 grant 分支；刷新令牌时校验 clientId 并轮换 token。[OAuth2GrantServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/oauth2/OAuth2GrantServiceImpl.java:35) 与 [OAuth2TokenServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/oauth2/OAuth2TokenServiceImpl.java:63)。管理端可以查询或撤销令牌；这是权限管理动作，不等于已让所有第三方客户端安全接入。

### 社交账号

`system_social_client` 保存 OAuth 社交平台客户端配置，`system_social_user` 和绑定表保存用户类型、用户、开放平台身份之间的关系。社交登录用 code/state 调客户端解析身份，已有绑定返回用户，绑定/解绑均校验用户类型和身份归属，[SocialUserServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/social/SocialUserServiceImpl.java:62)。Member 与 Admin 共用机制，但其业务用户主体在不同模块。

## 多租户、字典与地区

租户由 `system_tenant` 和 `system_tenant_package` 描述。创建租户会检查名称/域名/套餐，插入租户后切到该租户上下文创建“租户管理员”角色、用户并分配套餐菜单。[TenantServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/tenant/TenantServiceImpl.java:75)。更新套餐会重算租户管理员权限，并从普通角色中剔除套餐外菜单。[同文件](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/tenant/TenantServiceImpl.java:145)。租户校验还检查禁用和过期。

`system_dict_type`/`system_dict_data` 是业务字典；`system_area` 是地区树和 IP 归属查询数据。它们常被其他模块引用为 code/areaId，但不是业务外键万能替代品。

## 消息、公告和审计

短信由渠道、模板、验证码、日志构成。发送时校验模板、渠道和参数，先落发送日志，再经消息队列异步调用渠道；模板或渠道停用时只记日志、不发送。[SmsSendServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/sms/SmsSendServiceImpl.java:65)。渠道回调再更新接收结果。

邮件同样由账号、模板、日志构成：服务合并用户邮箱及显式收件人，验证模板参数，落日志，再通过 MQ 异步发送。[MailSendServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/mail/MailSendServiceImpl.java:54)。站内信模板渲染后创建 `system_notify_message`，用户可查询和标记已读；公告 `system_notice` 是内容 CRUD，推送时只通过 Infra WebSocket 向在线后台用户广播，不会自动生成每人的站内信。[NoticeController](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/controller/admin/notice/NoticeController.java:96)。

登录日志与操作日志属于审计；它们记录结果、IP、浏览器/方法等框架上下文，不能作为业务交易流水。

## 主要流程

### 后台账号密码登录

1. 校验图形验证码（启用时），按用户名取管理员并验证密码和账号状态。
2. 写成功或失败登录日志；成功时创建 access/refresh token 并更新最近登录信息。
3. 客户端携带 token 访问，登出时撤销 access token 并写登出日志。

### 创建租户

1. 校验名称、域名与套餐状态，插入租户。
2. 进入新租户上下文，创建系统类型的租户管理员角色，赋套餐菜单。
3. 创建管理员并分配角色，再回写租户联系人用户编号。

### 短信/邮件通知

1. 调用方给模板 code 和参数；服务校验模板、渠道/账号、收件地址与全部参数。
2. 创建发送日志；禁用模板或渠道时保留日志但跳过投递。
3. 启用时发布 MQ 消息异步投递；回执或异常更新日志结果。发送 API 返回的是日志编号，不能保证实际送达。

## 控制器覆盖

|控制器域|能力|
|---|---|
|`admin/auth`、`admin/captcha`、`admin/oauth2`、`admin/social`|后台认证、验证码、OAuth2 客户端/令牌/授权、社交绑定。|
|`admin/user`、`admin/dept`、`admin/permission`|用户、组织、岗位、菜单、角色、数据权限。|
|`admin/tenant`|租户、套餐、域名查找。|
|`admin/dict`、`admin/ip`|字典及地区/IP 查询。|
|`admin/sms`、`admin/mail`、`admin/notify`、`admin/notice`|短信、邮件、站内信和公告。|
|`admin/logger`、`app/dict`、`app/ip`、`app/tenant`|审计查询和 App 侧基础查询。|

## 已知边界

- System 表与原始 `ruoyi-vue-pro.sql` 存在同名表/字段差异，结构阅读应以本次模块 DDL 与实体范围为准。
- 多租户、权限、缓存和数据范围依赖框架切面，本文只描述服务内可见规则；未验证实际拦截链。
- 公告 WebSocket 推送只面向在线后台用户；短信/邮件/社交授权都依赖外部配置与 MQ，静态代码不能证明投递成功。
- 短信验证码代码中仍标注按 IP 限流的 TODO，[SmsCodeServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-system/yudao-module-system-server/src/main/java/cn/iocoder/yudao/module/system/service/sms/SmsCodeServiceImpl.java:57)。
