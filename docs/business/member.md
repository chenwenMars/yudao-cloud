# Member 会员中心业务知识

> 本文依据当前后端 Controller、Service、实体、枚举和模块 API 的静态阅读整理；未启动服务、未调用外部短信或社交平台，也未验证现有库中的运行时数据。

关联资料：[DDL](../../sql/mysql/member.sql)｜[ER 图](../er/member-er.drawio)｜[关系源码依据](../er/module-data/member.json)

## 技术栈、服务模块与主要作用

| 项目 | 当前代码依据 |
| --- | --- |
| 后端服务 | `yudao-module-member-server`（[pom.xml](../../yudao-module-member/yudao-module-member-server/pom.xml)） |
| 基础技术栈 | Java 17、Spring Boot 3.5.15、Maven、MyBatis、Redis、租户/IP/安全、模块 RPC、Nacos 服务发现与配置。 |
| 模块专项依赖 | 消息队列、System/Infra/Member API、Excel 与监控 starter。 |
| 主要作用 | 维护会员身份和档案、地址、分组标签、积分经验等级、签到及会员侧认证协作。 |

## 定位与边界

Member 是面向终端会员的身份与档案域。它维护会员账号、收货地址、分组、标签、积分、经验/等级和签到；同时提供 App 登录、注册式的验证码登录、社交账号绑定、手机号与密码变更等入口。管理员用户、统一令牌、短信验证码、第三方社交账号和登录日志并不存放在 Member 自己的表中，分别通过 System 模块 API 使用。

因此，`member_user` 是会员主体，但不是后台 `system_users` 的副本；等级、积分与经验各有自己的流水语义。商品交易、抽奖等上游业务可以调用 Member API 发放或扣回积分/经验，但这些订单并不属于 Member 的 DDL。

## 业务域

### 会员档案、分组与标签

`member_user` 保存昵称、手机、邮箱、状态、等级、经验、积分、分组及标签编号集合。管理端可维护用户档案、直接调整积分或等级；App 端只允许用户维护自己的资料、手机号和密码。创建/更新时会做手机号、邮箱等唯一性校验，会员被禁用后不能登录，见 [MemberUserServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/service/user/MemberUserServiceImpl.java:81)。

`member_group` 用于运营分群；`member_tag` 用于多标签标记，会员表中的 `tag_ids` 是集合字段而非中间表。删除分组或标签前会检查是否仍有会员引用，这是为了避免把存量会员变成无效归属。管理端入口覆盖见 [MemberGroupController](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/controller/admin/group/MemberGroupController.java:27) 和 [MemberTagController](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/controller/admin/tag/MemberTagController.java:28)。

### 登录、注册与身份绑定

App 登录有四条路径：手机密码、手机验证码、社交授权码、微信小程序手机号授权。验证码登录会先消费 System 提供的验证码，再按手机号查询或创建会员；社交登录已绑定则取得会员，未绑定则创建会员再绑定；每一条成功路径都会委托 System 创建 OAuth2 access token 并记登录日志，[MemberAuthServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/service/auth/MemberAuthServiceImpl.java:72)。

手机号变更、密码更新、找回密码均通过 App 控制器进入，并复用不同场景的短信验证码；社会化账号实体位于 System 的 `system_social_user`，Member 只持有用户类型为 MEMBER 的绑定关系，不另建“微信会员表”。相关入口见 [AppAuthController](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/controller/app/auth/AppAuthController.java:37)。

### 地址簿

`member_address` 是用户自己的收货地址簿。创建或更新为默认地址时，服务会在同一事务中先撤销该用户其他默认地址；读、改、删都以 `id + user_id` 查询，防止用户操作他人地址，[AddressServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/service/address/AddressServiceImpl.java:30)。它为商城交易提供地址选择能力，但该模块不负责生成订单。

### 签到、积分、经验与等级

签到规则 `member_sign_in_config` 按连续天数配置积分和经验；`member_sign_in_record` 记录每次签到当时的天数与奖励。服务先拒绝当天重复签到，再根据最近一次记录判断是否连续，超过最大规则天数后回到第 1 天；落签到记录后分别写积分和经验流水，[MemberSignInRecordServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/service/signin/MemberSignInRecordServiceImpl.java:105) 与 [MemberSignInRecordConvert](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/convert/signin/MemberSignInRecordConvert.java:41)。

`member_point_record` 是积分变更流水。创建流水时先读取 `member_user.point` 计算变更后积分；结果小于零时记录错误日志并直接返回。随后才更新会员积分，成功后写流水。[MemberPointRecordServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/service/point/MemberPointRecordServiceImpl.java:59) 说明积分余额以 `member_user.point` 为当前值、流水为审计记录。扣减 SQL 仅按会员编号更新、未见余额条件或版本条件，[MemberUserMapper](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/mysql/user/MemberUserMapper.java:90)；因此静态代码只能证明单次调用的预读检查，不能据此断言并发扣减一定不会出现负数。

经验变化写入 `member_experience_record`，等级变化写入 `member_level_record`。等级配置要求名称、等级值唯一，且经验阈值必须落在相邻等级阈值之间；加减经验后会从启用等级里选择“满足经验且等级值最高”的一档，必要时写等级变更记录并更新会员当前等级，[MemberLevelServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/service/level/MemberLevelServiceImpl.java:55)。

## 核心对象与关系

|对象|主要表|业务关系|
|---|---|---|
|会员主体|`member_user`|被地址、签到、积分/经验/等级流水引用；`level_id` 指向等级，`group_id` 指向分组，标签为 `tag_ids` 集合。|
|权益规则|`member_level`、`member_sign_in_config`|等级按经验阈值匹配；签到规则决定某连续天数的积分和经验。|
|权益流水|`member_point_record`、`member_experience_record`、`member_level_record`|分别记录积分、经验和等级变化；订单相关业务编号由 `biz_type + biz_id` 解释。|
|地址与运营归类|`member_address`、`member_group`、`member_tag`|地址归属单一会员；分组单值、标签多值。|

## 主要流程

### 手机验证码登录

1. App 调用发送验证码；System 按 MEMBER_LOGIN 场景生成并发送验证码。
2. 登录时 Member 消费验证码，按手机号取得或新建会员，并检查账号状态。
3. 如果请求携带社交参数，再绑定社交身份；最后由 System 的 OAuth2 令牌服务发令牌，并写 System 登录日志。

这是一条“可注册”的登录链路；手机密码登录只认证现有账号，不会自动建号。[smsLogin](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/service/auth/MemberAuthServiceImpl.java:94) 是两者边界。

### 一次签到奖励

1. 读取该会员最近签到，若记录为当天则拒绝。
2. 读取启用的规则，按昨天是否签到计算连续天数；到规则最大日后重新开始一轮。
3. 插入签到记录；规则中的积分非零时写积分流水，经验非零时写经验流水并可能升级。

签到记录和两类权益流水在同一事务方法中执行，但是否能最终提交仍取决于底层数据库和外部调用不参与该事务的事实。[createSignRecord](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/service/signin/MemberSignInRecordServiceImpl.java:105)。

### 订单权益的发放与撤销

上游商城订单通过 Member API 传入业务类型和订单/订单项编号。积分枚举区分订单抵扣、整单取消、单项退款、订单奖励及其撤销；经验枚举同样区分下单奖励及撤销，因此流水可追溯到业务单号。[MemberPointBizTypeEnum](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-api/src/main/java/cn/iocoder/yudao/module/member/enums/point/MemberPointBizTypeEnum.java:17) 与 [MemberExperienceBizTypeEnum](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-api/src/main/java/cn/iocoder/yudao/module/member/enums/MemberExperienceBizTypeEnum.java:16) 是此协议的来源。本文未假设所有枚举分支都已被某个上游业务调用。

## 状态、规则与协作

- 会员状态沿用通用启用/禁用语义；认证入口对禁用账号记失败登录日志并拒绝发 token。
- 经验扣减被下限截为 0。积分服务在更新前以当前读到的余额做非负检查，但扣减 SQL 未附余额或版本条件；并发场景的最终余额需要结合实际数据库执行验证，不能将其写成已由代码保证的“绝不为负”。
- 会员等级“变更通知”目前是 `TODO` 空实现，[MemberLevelServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/service/level/MemberLevelServiceImpl.java:292)，不能写成已有站内信推送能力。
- System：短信验证码、社交账号绑定、OAuth2 令牌、登录日志均通过 API 协作；Mall：订单积分/经验、收货地址是业务协作点；Pay 钱包以会员编号为用户主体，但钱包表在 Pay 模块。

## 接口域覆盖

|控制器域|能力|
|---|---|
|`admin/user`、`admin/group`、`admin/tag`|会员档案、分组标签、管理员积分/等级调整。|
|`admin/level`、`admin/point`、`admin/signin`|等级/经验/积分流水查询与签到规则管理。|
|`admin/address`、`app/address`|后台查看及会员自己的地址簿维护。|
|`app/auth`、`app/social`、`app/user`|多方式登录、社交绑定、资料、手机和密码维护。|
|`app/level`、`app/point`、`app/signin`|等级、积分、签到规则、统计和历史查询。|

## 使用场景与限制

典型场景是电商会员用短信登录后签到，得到积分和经验；订单使用积分时上游写扣减流水，订单取消或退款再按相应业务类型返还；运营人员用分组/标签筛选会员并调整等级。

当前代码的明确限制包括：等级变更通知未实现；标签采用编号集合而没有关系表，数据库不提供外键完整性；积分余额不足的 `totalPoint < 0` 分支记录错误后返回而不是抛异常，且扣减 SQL 未带余额或版本条件；实际登录、短信、社交平台和订单事件均未在本次静态阅读中运行验证。
