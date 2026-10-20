# MP 微信公众号业务知识

> 本文基于当前后端源码静态分析，未接入真实微信公众号、未验证回调签名、媒体同步或统计结果。

关联资料：[DDL](../../sql/mysql/mp.sql)｜[ER 图](../er/mp-er.drawio)｜[关系依据](../er/module-data/mp.json)

## 模块定位

MP 是公众号运营后台的适配层。它把租户下的公众号配置、粉丝、标签、菜单、自动回复、客服消息、模板消息元数据和素材元数据保存在本地，同时通过微信 Java SDK 调用公众号开放能力。草稿和已发布图文主要由微信端保存；本地并没有一张“文章正文发布表”，不要把 `mp_material` 当成所有公众号内容的本地镜像。

每个账号以 `mp_account` 为根，保存 appId 和接口配置；`app_id` 是回调选择租户与 SDK 实例的关键，而 `account_id` 是后台管理主键。账号服务维护 appId 到账号的本地缓存并据此初始化 SDK，[MpAccountServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/service/account/MpAccountServiceImpl.java:68)。

## 业务域

### 账号与租户路由

管理员维护公众号账号、生成二维码、清空 API 配额。外部微信回调并不携带当前登录租户：`/mp/open/{appId}` 先从 appId 缓存找到账号，再以其 `tenant_id` 执行处理，结束时清除上下文，[MpOpenController](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/controller/admin/open/MpOpenController.java:42)。这使一个部署可服务多公众号/多租户，但前提是账号缓存和配置正确。

### 粉丝、标签与菜单

`mp_user` 是公众号粉丝快照，按 appId/openId 获取或同步；关注、取关等事件会更新本地粉丝状态。`mp_tag` 是微信公众号标签的本地记录，管理端创建、修改、删除和同步时都与微信侧接口协作；粉丝的标签编号是集合值，更新会同步微信标签关系，[MpUserServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/service/user/MpUserServiceImpl.java:79)。

`mp_menu` 保存菜单层次。保存前会校验菜单结构和消息配置，随后将整套菜单提交到微信；点击事件由菜单处理器把配置转换为一条外发消息，[MpMenuServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/service/menu/MpMenuServiceImpl.java:61)。

### 消息接入、自动回复与人工客服消息

微信回调先验证签名，再按明文/AES 解析 XML，交给对应账号的 `WxMpMessageRouter`，最后按原加密模式返回 XML。[MpOpenController](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/controller/admin/open/MpOpenController.java:86)。路由包含订阅、取消订阅、位置、扫码、菜单与普通消息等处理器；接收的消息会写入 `mp_message`，必要时下载媒体。

自动回复 `mp_auto_reply` 支持关注回复、按消息类型回复和关键字回复。文本先尝试完全关键字再尝试模糊关键字，未命中才按消息类型；关注没有配置时会构造“感谢关注”的默认文本，但该默认值并不落库。[MpAutoReplyServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/service/message/MpAutoReplyServiceImpl.java:143)。同一账号对关注、某消息类型、某关键词分别有冲突校验，避免多条规则竞争。[同文件](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/service/message/MpAutoReplyServiceImpl.java:91)

管理员可发送客服消息和模板消息，但两条路径的记录方式不同：`MpMessageService` 校验客服消息、调用微信客服接口，成功后写入 `mp_message`；模板消息由 `MpMessageTemplateService` 调用微信模板消息接口，源码明确不写 `MpMessageDO` 记录。[MpMessageServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/service/message/MpMessageServiceImpl.java:131) 与 [MpMessageTemplateServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/service/message/MpMessageTemplateServiceImpl.java:125)。

### 素材、草稿、发布和统计

`mp_material` 管理临时/永久素材与图文正文中图片的上传记录。草稿和发布接口直接调用微信草稿箱、发布服务；查询草稿时会依据本地素材 `media_id` 回填图片 URL，以解决微信素材地址不能直接在后台展示的问题，[MpDraftController](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/controller/admin/news/MpDraftController.java:47)。

`MpStatisticsController` 提供粉丝增减、累计和消息发送概况。这些是读取公众号统计接口的管理查询，不应视为本地事实仓或实时事件流。[MpStatisticsController](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/controller/admin/statistics/MpStatisticsController.java:25)。

## 核心对象

|对象|表/外部资源|关系|
|---|---|---|
|公众号账号|`mp_account`|菜单、粉丝、标签、素材、自动回复、消息均按账号归属；appId 连接微信回调。|
|粉丝与标签|`mp_user`、`mp_tag`|粉丝的标签集合依微信侧与本地同步；不是关系表外键。|
|消息规则与记录|`mp_auto_reply`、`mp_message`、`mp_message_template`、微信 XML|自动回复和客服消息可写 `mp_message`；模板消息元数据独立同步，本次发送不写 `mp_message`。|
|媒体与图文|`mp_material`、微信草稿/发布服务|本地记录素材，草稿/已发布图文的权威状态在微信侧。|

## 主要流程

### 微信回调与自动回复

1. 微信请求按 appId 到达开放接口，服务读取账号和租户上下文并验证签名。
2. 按明文或 AES 解析 XML，路由至订阅、菜单、普通消息等 handler；接收消息写本地记录并更新粉丝状态。
3. 若命中自动回复或菜单动作，构造出站消息并直接以 XML/AES XML 返回；无回复则返回空字符串。

### 粉丝同步与运营标记

1. 管理员按账号触发粉丝或标签同步。
2. 服务从微信侧分页读取粉丝/标签并插入或更新本地快照。
3. 管理员给粉丝更新标签时，服务校验粉丝和标签，再调用微信侧更新后保存本地数据。粉丝资料可能因微信侧变化而滞后，需再次同步。

### 图文发布

1. 管理员在微信草稿箱创建/更新图文，封面图片媒体编号可关联本地素材记录。
2. 发布草稿由微信 API 处理，管理端查询的是微信侧发布列表。
3. 删除草稿/已发布素材也会调用微信 API；本地素材删除与微信图文生命周期不是一回事。

## 控制器覆盖

|控制器域|能力|
|---|---|
|`admin/account`、`admin/open`|账号配置、二维码/API 配额、微信签名和消息回调。|
|`admin/user`、`admin/tag`、`admin/menu`|粉丝与标签同步、粉丝运营、公众号菜单。|
|`admin/message`|自动回复、消息记录、客服消息及模板消息同步/发送。|
|`admin/material`、`admin/news`|临时/永久素材、草稿和发布图文。|
|`admin/statistics`|粉丝与消息发送统计查询。|

## 边界与限制

- 回调处理依赖正确的 appId、微信签名、加密配置和账号缓存；本次没有外部平台联调。
- 草稿、发布、统计与粉丝完整资料的权威来源是微信，模块中部分表是运营缓存或审计记录。
- `mp_tag` 主键策略和标签编号需以 DDL/微信返回值核对，集合字段没有数据库外键保护。
- 默认路由中客服会话、扫码、门店审核通知和空事件处理器会抛出“未实现该处理，请自行重写”，例如 [ScanHandler](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/service/handler/other/ScanHandler.java:22)。这些事件不能写成已可用的自动化运营能力。
- 该模块没有会员账号绑定或订单营销闭环；若需要将粉丝映射为 Member 用户，需要由其他业务显式定义映射和授权流程。
