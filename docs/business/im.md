# IM 即时通信模块业务知识

> 本文仅依据当前 Controller、ServiceImpl、DO、枚举和静态调用关系整理，未连接 WebSocket、LiveKit、Redis、数据库或客户端。通信“推送”“已读”“通话”均指后端已有代码路径，不能据此声称消息必达、离线送达或音视频已在线验证。配套材料：[推导 DDL](../../sql/mysql/im.sql) · [ER 图](../er/im-er.drawio)。

## 1. 模块定位与通信边界

IM 模块面向后台登录用户提供好友、群组、频道、私聊/群聊/频道消息、表情、敏感词、阅读位置和 RTC 通话会话管理。它既保存可回溯的消息和关系，也在事务提交后经 WebSocket 通知在线用户；前端使用拉取接口补齐未实时收到的持久消息。

这里的“即时通信”不等于一个完整的自建长连接或媒体系统：本模块把用户通知发给平台的 WebSocket 会话服务，RTC 房间和媒体由 LiveKit 处理并通过 webhook 回调；代码生成的 token 是进入 LiveKit 的凭证，不保存音视频流。消息内容可为文本、图片、语音、视频、文件、引用、合并、名片、表情等 JSON/字符串载荷，文件本身不在 `im_*` 表内。[通知在提交后发送](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/websocket/ImWebSocketServiceImpl.java:94) · [通话 token 与 webhook 处理](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/rtc/ImRtcCallServiceImpl.java:486)

用户身份来自 system 用户体系；IM 的 `user_id`、`sender_id` 等是逻辑引用。本模块并未实现匿名访客、跨租户公共聊天室、端到端加密、消息全文检索集群或媒体存储服务。

## 2. 业务域与实现能力

| 业务域 | 核心表 | 代码中的业务含义 |
| --- | --- | --- |
| 好友 | `im_friend`、`im_friend_request` | 发起/同意/拒绝好友请求，维护双向好友、备注、置顶、免打扰、拉黑等关系；好友是私聊和建群邀请的前置约束。 |
| 群组 | `im_group`、`im_group_member`、`im_group_request` | 群主、管理员、成员和申请记录；建群、邀请、退群、踢人、转让群主、公告、置顶消息、全员/成员禁言与后台封禁。 |
| 私聊和群聊 | `im_private_message`、`im_group_message`、`im_conversation_read` | 持久消息、撤回、引用、拉取、阅读位置和回执。私聊按发送者+客户端消息 ID 去重；群聊有成员/禁言/接收范围校验。 |
| 频道 | `im_channel`、`im_channel_material`、`im_channel_message` | 管理员维护频道与图文素材，发送时指定接收用户，或在接收用户为空时广播；当前代码未见频道订阅关系表。素材可携带跳转 URL 或由客户端再取正文。 |
| 表情和内容治理 | `im_face_pack`、`im_face_pack_item`、`im_face_user_item`、`im_sensitive_word` | 系统/用户表情包及用户收藏项；文本消息走敏感词校验。 |
| RTC | `im_rtc_call`、`im_rtc_participant` | 持久化一次呼叫及参与者状态，邀请/接听/拒绝/取消/离开、超时清理和 LiveKit webhook 对账；不保存媒体流。 |
| 运营管理 | 管理端分页与统计接口 | 对好友、群、频道、消息、表情、敏感词、RTC 记录进行后台查询或维护；它不替代用户侧通信逻辑。 |

私聊和群聊采用不同回执模型：私聊可把待回执消息更新为 DONE；群聊通过每个用户的会话阅读位置推导“某消息是否已收到/已读”。阅读位置是单调推进的独立记录，不把消息自身 `status` 改写成“已读”。[私聊读位置和回执](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/message/ImPrivateMessageServiceImpl.java:242) · [群聊阅读处理](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/message/ImGroupMessageServiceImpl.java:259)

## 3. 核心对象和关系

好友申请是从申请人到目标用户的一次状态记录；同意后服务创建/恢复双方 `im_friend` 关系。群的 `owner_user_id` 指向群主，成员表记录角色、来源、邀请者和禁言等成员状态；群被解散时先发通知，再停用群并移除成员。[好友申请处理](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/friend/ImFriendRequestServiceImpl.java:172) · [解散群](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/group/ImGroupServiceImpl.java:182)

私聊消息由 `sender_id` 与 `receiver_id` 定位两人会话；群消息由 `group_id` 和发送成员定位；频道消息由频道和素材/内容关联。消息的 `content` 是按内容类型约定的 JSON 或字符串，引用信息会在服务端重新读取原消息后规范化，避免客户端伪造跨会话引用。[私聊引用规范化](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/message/ImPrivateMessageServiceImpl.java:196)

`im_conversation_read` 按“用户 + 会话类型 + 会话对象”保存最大已读消息位置。`im_rtc_call` 以 room 为外部房间标识，`im_rtc_participant` 保存每位受邀者的邀请、接听、拒绝、未接或离开轨迹；这两张表用于会话状态，不是 LiveKit 内部房间表。

## 4. 端到端流程

### 4.1 好友申请到私聊可用

1. 用户通过 `/im/friend-request/apply` 提交目标用户和验证信息；服务检查自身、目标、重复/既有关系等条件，创建或重置一条申请记录。
2. 申请在事务提交后向接收用户推送 WebSocket 通知，同时保留拉取列表接口，在线通知失败不能靠本文推断为自动补偿成功。
3. 接收者调用 `/agree` 或 `/refuse`。同意路径创建/恢复双向好友关系并写处理结果，拒绝只更新申请处理结果。
4. 之后私聊发送服务校验双方好友关系；拉黑、删除或关系失效会使正常用户消息无法以“好友私聊”路径发送。
5. 关系变化和消息变化分别使用通知类型，客户端仍应以接口查询/拉取作为数据校验来源。

实现入口：[申请、提交后通知](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/friend/ImFriendRequestServiceImpl.java:68) · [请求处理](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/friend/ImFriendRequestServiceImpl.java:172)。

### 4.2 创建群、管理成员与群设置

1. 创建者传入群资料和初始成员。服务去重并排除创建者，要求初始成员均为创建者好友且不超过配置的群人数上限。
2. 服务创建启用的群、将创建者加入为 OWNER，再写入受邀成员；随后向全员发送 `GROUP_CREATE` 通知。
3. 群主可编辑资料和加入审批设置；群成员邀请他人时要先校验操作人身份、候选人好友关系、当前成员和容量。
4. 群主/管理员可设置管理员、踢人、置顶/取消置顶消息、全员禁言或成员禁言；权限和角色层级由服务校验。
5. 群主解散时通知仍在成员存在时发出，再将群置为禁用并移除成员；被解散群不可按正常成员路径继续通信。

[建群、人数与好友约束](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/group/ImGroupServiceImpl.java:92) · [邀请校验](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/group/ImGroupServiceImpl.java:208)。

### 4.3 私聊发送、撤回、补拉和已读

1. 发送方提交 `clientMessageId`、接收者、内容类型和内容。服务先按“发送者 + 客户端消息 ID”做幂等查重，再校验好友、内容结构；文本还经过敏感词校验。
2. 服务规范化引用消息，保存 NORMAL 消息和回执初始状态。并发唯一键冲突会回查已插入消息，避免重复生成同一客户端请求的消息。
3. 保存后异步通知接收者和发送者的其他端。持久私聊默认需要回执，是否开启由 IM 配置控制。
4. 用户可在配置的撤回时间内撤回自己发送且尚未撤回的消息。原消息状态置为 RECALL，并向双方发送一条撤回信令消息。
5. 离线/补偿场景由 `/pull` 按最小 ID、时间窗口和最大条数拉取。读取时把对方发来的 PENDING 回执置 DONE，单调更新自己的阅读位置，仅在位置前进时发送已读/回执事件。

[发送幂等、校验与推送](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/message/ImPrivateMessageServiceImpl.java:71) · [撤回约束](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/message/ImPrivateMessageServiceImpl.java:160)。

### 4.4 群消息与频道内容分发

1. 群成员调用 `/im/group-message/send`，服务核验群和发送成员，检查群/成员禁言、消息内容、敏感词和引用原消息是否属于同一群。
2. 消息保存后以群活跃成员为受众发送 WebSocket 通知；定向系统消息可指定接收范围。
3. 成员通过 `/pull`、`/read`、`/read-user-list` 拉取和查看阅读情况，阅读位置仍由 `im_conversation_read` 维护。
4. 频道管理员维护 `im_channel` 与 `im_channel_material`，以频道消息把图文素材推给请求中的指定用户；接收用户列表为空时走 WebSocket 广播。当素材 URL 为空，客户端需要再调用素材内容接口渲染正文；静态代码没有频道订阅关系供服务按订阅者筛选。
5. 频道、群聊的“消息管理”接口是后台审阅/分页入口，不能从管理 Controller 推断其拥有绕过成员规则的用户发送权限。

内容类型定义明确列出持久消息与非持久信令的差异；例如 RTC 信令不入消息表，通话开始/结束可为会话展示另存提示消息。[内容类型与持久性](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/enums/ImContentTypeEnum.java:20)

### 4.5 RTC 邀请到结束

1. 用户请求 `/im/rtc/call/create`，服务分别处理私聊或群聊目标，校验功能开关、好友/成员关系、当前是否已有活跃通话，并生成 room 与参与者记录。
2. 受邀者可以 `/accept`、`/reject`，主叫可 `/cancel`，参与者可 `/leave`；服务据此更新参与者和会话。
3. 第一个非发起人接通时，会话从 CREATED 进入 RUNNING；全部满足结束条件或收到 LiveKit 房间结束事件后，结束会话并发送参与方通知。
4. 客户端向 `/sign-token` 获取进入外部媒体房间的凭证；LiveKit webhook 的加入、离开、房间结束回调用于修正参与者和会话状态。
5. 定时清理僵尸会话、邀请超时和未接听检查存在代码入口；具体调度是否启用、webhook 外部可达性及签名密钥配置须运行环境确认。

RTC 状态机是 `CREATED → RUNNING → ENDED`，私聊可在 CREATED 直接结束表示取消/未接听。[状态枚举](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/enums/rtc/ImRtcCallStatusEnum.java:14) · [呼叫创建](/Users/chenwen/workspace2/yudao-cloud/yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/service/rtc/ImRtcCallServiceImpl.java:105)。

## 5. 状态规则、协作与典型场景

- 消息状态至少区分 NORMAL 与 RECALL；已读不是把每条消息状态改写，而是回执状态和会话读位置共同表达。
- 群成员角色有 OWNER、ADMIN、MEMBER，群状态可被解散/后台封禁；操作权限不能只用“是否群成员”判断。
- 群/私聊消息均支持撤回时间窗和引用有效性校验；引用被撤回或不在同一会话会失败。
- RTC 呼叫的参与者状态与主会话状态分离，LiveKit webhook 是外部事实来源之一，但本文未验证其签名、重放保护或网络可达性。

典型场景：员工先加好友后私聊并多端同步；项目群创建后邀请好友、禁言和置顶重要通知；运营在频道维护图文素材并发布；用户用历史拉取恢复消息序列；用户从私聊或群聊发起 RTC，业务库记录呼叫而媒体由 LiveKit 传输。

## 6. 已实现局限与后续验证点

- 未在本模块找到媒体文件上传/转码、语音识别、端到端加密、搜索索引、跨地域消息复制或消息投递确认队列；附件 URL 的存储和可访问性由外部文件服务决定。
- `sendNotificationAsync` 说明通知异步且在事务提交后发送，并不构成“Exactly once”或离线可靠投递证明；补拉的时间窗也受配置限制。
- 私聊以好友关系为前提，群邀请同样要求好友；是否满足产品侧全部隐私策略和管理员绕行策略需查前端/权限配置。
- LiveKit 的房间、媒体、token 密钥、webhook 回调和定时任务均是外部/运行时边界，本文未运行验证；但 webhook Controller 已调用 `verifyWebhookSignature` 做请求签名校验，不能写成“代码没有 webhook 鉴权”。
- 当前推导 DDL 未证实全部唯一索引；发送幂等和并发插入处理的最终效果需在真实数据库中验证。

## 7. Controller 包接口覆盖与源码入口

所有入口处于 `controller/admin`。以下按用户域与 `manager` 后台域覆盖全部扫描到的 Controller；同名管理 Controller 主要提供全局分页/维护，不能替代普通用户接口的身份校验。

| 包 | 控制器 | 路由/功能覆盖 |
| --- | --- | --- |
| `friend` | ImFriend、ImFriendRequest | 好友列表、备注/置顶/免打扰/拉黑/删除；申请、同意、拒绝、列表和拉取 |
| `group` | ImGroup、ImGroupMember、ImGroupRequest | 建群、资料、解散、邀请、退出、踢人、管理员、转让、置顶/禁言；成员/申请查询与处理 |
| `message` | ImPrivateMessage、ImGroupMessage、ImChannelMessage | 三类消息发送、撤回、拉取、读取、列表/详情 |
| `conversation` | ImConversationRead | 会话阅读位置拉取 |
| `channel`、`face`、`rtc` | ImChannelMaterial、ImFacePack、ImFaceUserItem、ImRtcCall、ImRtcLiveKit | 素材、表情包及用户项；呼叫/邀请/接听/拒绝/取消/离开/token 和 LiveKit 回调 |
| `manager/channel` | ImChannelManager、ImChannelMaterialManager | 频道和素材后台维护/分页 |
| `manager/friend`、`manager/group` | ImFriendManager、ImFriendRequestManager、ImGroupManager、ImGroupMemberManager、ImGroupRequestManager | 好友/申请、群/成员/申请全局查询及群封禁、后台解散等管理动作 |
| `manager/message`、`manager/rtc` | ImPrivateMessageManager、ImGroupMessageManager、ImChannelMessageManager、ImRtcCallManager | 消息和通话记录全局分页、详情/参与者查询 |
| `manager/face`、`manager/sensitiveword`、`manager/statistics` | ImFacePackManager、ImFacePackItemManager、ImFaceUserItemManager、ImSensitiveWordManager、ImStatisticsManager | 表情包/条目、敏感词、统计管理 |

建议阅读顺序：`ImFriendRequestServiceImpl` → `ImPrivateMessageServiceImpl` → `ImGroupServiceImpl`/`ImGroupMessageServiceImpl` → `ImConversationReadServiceImpl` → `ImWebSocketServiceImpl` → `ImRtcCallServiceImpl`，最后再看频道与后台管理接口。
