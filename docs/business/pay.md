# Pay 支付平台业务知识

> 本文来自当前支付模块的静态源码阅读；未向支付宝、微信或其他渠道发起交易，未验证异步回调、定时重试和资金数据。

关联资料：[DDL](../../sql/mysql/pay.sql)｜[ER 图](../er/pay-er.drawio)｜[关系依据](../er/module-data/pay.json)

## 技术栈、服务模块与主要作用

| 项目 | 当前代码依据 |
| --- | --- |
| 后端服务 | `yudao-module-pay-server`（[pom.xml](../../yudao-module-pay/yudao-module-pay-server/pom.xml)） |
| 基础技术栈 | Java 17、Spring Boot 3.5.15、Maven、MyBatis、Redis、租户/安全、模块 RPC、Nacos 服务发现与配置。 |
| 模块专项依赖 | 支付宝 SDK、微信支付 SDK、任务调度、System/Pay API、Excel 与监控 starter。 |
| 主要作用 | 为接入方提供应用渠道配置、支付、退款、转账、商户通知、钱包及充值能力。 |

## 定位与边界

Pay 提供给其他业务模块的支付基础能力：应用/渠道配置、支付单和尝试单、退款、转账、商户通知、会员钱包和充值。它不拥有商城订单本身；接入方用 `app_key + merchant_order_id` 创建支付单，再接收支付/退款/转账结果通知。金额字段在 Service 中按 `Integer price` 传递，本文不自行断言为元或分，具体应以调用方和渠道协议确认。

## 核心对象

|对象|主要表|职责|
|---|---|---|
|应用与渠道|`pay_app`、`pay_channel`|应用保存接入方 key 与回调地址，渠道绑定具体支付客户端和开关。|
|支付交易|`pay_order`、`pay_order_extension`|主单对应商户交易；每次提交渠道时生成尝试单，渠道交易号和状态落在 extension。|
|退款/转账|`pay_refund`、`pay_transfer`|退款针对成功支付单；转账是独立的收款人转账单。|
|结果通知|`pay_notify_task`、`pay_notify_log`|向接入方 HTTP 回调并记录重试尝试。|
|钱包|`pay_wallet`、`pay_wallet_transaction`、`pay_wallet_recharge*`|用户余额、流水、充值套餐和充值/退款生命周期。|

## 应用、渠道与支付单

创建支付单先用 appKey 验证应用，并以 `app_id + merchant_order_id` 幂等查找；已有单直接返回其编号，新的主单初始为 `WAITING`、已退款金额为 0，[PayOrderServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/service/order/PayOrderServiceImpl.java:105)。

提交支付不是直接修改主单，而是校验主单仍为待支付且未过期、渠道已启用，再新建一条 `pay_order_extension`。尝试单的 `no` 才是传给渠道的 outTradeNo；这样同一业务主单可以有多次渠道尝试。[submitOrder](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/service/order/PayOrderServiceImpl.java:131)。提交前还会检查历史 extension 和渠道查询结果，避免“已付款但回调延迟”时重复支付。[validateOrderActuallyPaid](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/service/order/PayOrderServiceImpl.java:197)。

主单状态为未支付、支付成功、已退款、关闭；“部分退款”不会产生独立主单状态，只有全额退款后主单才会转到 REFUND，需要结合 `refund_price` 判断累计退款。[PayOrderStatusEnum](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-api/src/main/java/cn/iocoder/yudao/module/pay/enums/order/PayOrderStatusEnum.java:15)。

## 退款、转账与通知

退款创建时校验应用、支付单及可退余额，累计退款不得超过原支付金额；退款单初始为 WAITING，并向渠道发起退款。退款状态由渠道通知更新为成功或失败。[PayRefundServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/service/refund/PayRefundServiceImpl.java:93) 与 [PayRefundStatusEnum](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-api/src/main/java/cn/iocoder/yudao/module/pay/enums/refund/PayRefundStatusEnum.java:14) 定义了这一边界。

转账按 appId 和商户转账号幂等，创建后调渠道，状态可从 WAITING 到 PROCESSING，再到 SUCCESS 或 CLOSED；成功/关闭都会创建商户通知任务。[PayTransferServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/service/transfer/PayTransferServiceImpl.java:66) 与 [PayTransferStatusEnum](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-api/src/main/java/cn/iocoder/yudao/module/pay/enums/transfer/PayTransferStatusEnum.java:15)。该服务文件明确有“彻底实现后补测试”的 TODO，不能把转账视作已完整验收的能力。

支付成功会创建 `pay_notify_task`；退款的成功或失败、转账的成功或关闭也会创建任务。支付渠道关闭仅更新尝试单，不在该分支创建商户通知。[PayOrderServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/service/order/PayOrderServiceImpl.java:292) 与 [PayRefundServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/service/refund/PayRefundServiceImpl.java:221) 体现了这一区别。执行器读取接入方通知地址，写每次 `pay_notify_log`，按状态控制重试；通知状态区分等待、成功、最终失败，以及“请求成功但业务结果失败”。[PayNotifyServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/service/notify/PayNotifyServiceImpl.java:97) 和 [PayNotifyStatusEnum](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-api/src/main/java/cn/iocoder/yudao/module/pay/enums/notify/PayNotifyStatusEnum.java:12) 是代码事实；接入方的幂等消费仍是接入方责任。

## 钱包与充值

钱包按 `user_id + user_type` 获取或创建。消费付款会校验对应支付尝试单；消费退款根据退款单回补。余额写入封装为增加、扣减、冻结、解冻，并同步写 `pay_wallet_transaction`。钱包业务类型包括充值、充值退款、支付、支付退款、管理员更新余额、转账，[PayWalletBizTypeEnum](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-api/src/main/java/cn/iocoder/yudao/module/pay/enums/wallet/PayWalletBizTypeEnum.java:14)。

实现目前仅对部分类型给出明确余额更新分支，扣减路径有“其他类型待实现” TODO；不能仅凭枚举就认定所有钱包业务已可执行。[PayWalletServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/service/wallet/PayWalletServiceImpl.java:145)。

充值由用户选套餐或自定义金额生成 `pay_wallet_recharge`，关联一笔支付单；支付成功后增加余额（含套餐赠送），退款前冻结总额，退款渠道成功后扣冻结额或在失败时解冻。[PayWalletRechargeServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/service/wallet/PayWalletRechargeServiceImpl.java:80)。赠送金额与提现边界在退款校验处仍有 TODO，[同文件](/Users/chenwen/workspace2/yudao-cloud/yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/service/wallet/PayWalletRechargeServiceImpl.java:285)。

## 主要流程

### 商户收款

1. 业务系统以应用密钥和商户单号创建主支付单；重复请求复用主单。
2. 用户选择渠道提交，平台新建支付尝试单并调用渠道统一下单。
3. 渠道同步结果或异步回调驱动状态更新；成功后平台创建对业务系统的通知任务，业务系统以商户单号幂等处理。

### 原路退款

1. 业务系统请求退款，平台确认原支付单成功且累计退款未超额。
2. 新建待退款单，按原渠道向第三方申请退款。
3. 回调或同步查询将退款置成功/失败，更新原订单累计退款及通知任务；全额退款才对应主订单 REFUND。

### 会员充值并退款

1. App 创建充值记录和关联支付单，用户完成渠道付款。
2. 成功回调校验支付单和金额后增加钱包余额，写 RECHARGE 流水。
3. 申请退款时校验余额足以覆盖总充值额，先冻结；渠道退款成功后写 RECHARGE_REFUND 流水，失败则解冻。

## 控制器覆盖、协作与限制

|控制器域|能力|
|---|---|
|`admin/app`、`admin/channel`|接入应用、支付渠道与启停。|
|`admin/order`、`app/order`|支付单创建、提交、查询。|
|`admin/refund`、`admin/transfer`、`app/transfer`|退款、转账、转账同步查询。|
|`admin/notify`|渠道三类回调及商户通知审计。|
|`admin/wallet`、`app/wallet`|钱包、套餐、充值、流水和管理调整。|
|`admin/demo`|演示订单/提现，不应混同生产接入方。|

与 Member 的协作是以用户编号和用户类型建立钱包归属；与 Mall 等业务的协作是接入方创建支付/退款并消费通知，不存在直接持有商城订单表的外键。本次未验证渠道签名、回调重放、定时重试、分布式锁和金额单位，转账/部分钱包分支中的 TODO 是应优先补齐的真实边界。
