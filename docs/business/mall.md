# Mall 商城业务模块知识

> 本文依据商城四个 server（product、promotion、trade、statistics）的 Controller、ServiceImpl、DO、枚举和静态调用关系整理；未启动前端、未真实下单、支付、发货或调用第三方物流。配套材料：[推导 DDL](../../sql/mysql/mall.sql) · [ER 图](../er/mall-er.drawio)。金额、库存、优惠和支付回调的实际并发/幂等效果需在真实数据库与支付环境中验证。

## 技术栈、服务模块与主要作用

| 项目 | 当前代码依据 |
| --- | --- |
| 后端服务 | `yudao-module-product-server、yudao-module-promotion-server、yudao-module-trade-server、yudao-module-statistics-server`（[pom.xml](../../yudao-module-mall/pom.xml)） |
| 基础技术栈 | Java 17、Spring Boot 3.5.15、Maven、MyBatis、租户/安全、模块 RPC、Nacos 服务发现与配置。 |
| 模块专项依赖 | Trade 使用 Redis 与任务调度；Promotion 使用任务调度与消息队列；各服务通过 Product、Promotion、Trade、Member、Pay API 协作。 |
| 主要作用 | 以商品、营销、交易履约和经营统计四个服务组成商城业务域。 |

## 1. 模块定位、四个 server 的边界

商城不是一个单一表域，而由四个服务协作完成“商品可售 → 营销定价 → 交易履约 → 经营统计”：

| Server | 主要职责 | 不应混淆为 |
| --- | --- | --- |
| `yudao-module-product-server` | 品牌、类目、属性、SPU/SKU、评价、收藏、浏览记录 | 不负责支付、订单履约或独立仓库库存。 |
| `yudao-module-promotion-server` | 内容/装修、优惠券、折扣、秒杀、拼团、砍价、积分、满送、客服会话 | 不直接成为订单主表，也不自己扣支付款。 |
| `yudao-module-trade-server` | 购物车、订单/订单项/日志、配送、售后、分销和提现 | 订单会调用 product/promotion/member/pay API，不自己维护会员、支付渠道或商品主数据。 |
| `yudao-module-statistics-server` | 从其他模块数据形成商品、交易、会员、钱包等经营统计 | 统计查询/任务不是独立销售流水。 |

后台 `admin` 接口用于运营维护或审核，`app` 接口面向会员侧浏览和交易。控制器命名为 App 并不自动说明已存在公开匿名商城；实际身份、菜单和网关策略仍须运行验证。

## 2. 业务域及关键对象

### 2.1 商品目录和可售 SKU

`product_category` 组织层级类目，`product_brand`、`product_property`/`product_property_value` 为商品展示及规格提供基础资料。`product_spu` 表示商品主体，`product_sku` 是实际售价、库存、规格和下单引用对象。创建/修改 SPU 时会保存并差异维护 SKU；SKU 的库存更新通过产品服务 API 供交易/营销调用。

浏览、收藏和评价分别落在 `product_browse_history`、`product_favorite`、`product_comment`。评价来自订单项评论流程，不应将管理员评论列表理解为可绕过交易直接生成的买家评价。[SPU 与 SKU 保存](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/service/spu/ProductSpuServiceImpl.java:58) · [SKU 规格/库存接口](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/service/sku/ProductSkuServiceImpl.java:88)

### 2.2 内容装修、营销和客户服务

`promotion_banner`、文章/文章分类、DIY 页面/模板负责店铺内容与页面配置。促销中，优惠券模板发放为会员券；折扣、秒杀、拼团、砍价、积分、满送活动都通过活动主表及产品明细表达可参加的 SKU/SPU 和规则。活动配置不是订单优惠结果，实际成交时由交易价格服务组合计算。

拼团的 `promotion_combination_record` 记录团头/参团关系和团状态；砍价记录和助力记录分别保存用户发起与助力过程；秒杀活动拥有配置时段和商品库存；客服会话/消息保存在 `promotion_kefu_*`，与 IM 模块的私聊表不是同一数据域。[拼团创建与到期处理](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/service/combination/CombinationRecordServiceImpl.java:167) · [客服会话取得或创建](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/service/kefu/KeFuConversationServiceImpl.java:96)

### 2.3 交易、配送、售后与分销

`trade_cart` 是会员购物车；`trade_order → trade_order_item` 是成交快照和履约主链；`trade_order_log` 记录订单动作。交易配置、快递公司、运费模板及阶梯/包邮规则、自提点位于 `trade_config` 和 `trade_delivery_*`。订单创建后仅在应付金额大于零时创建支付单；积分兑换等零元订单不走该支付单创建分支。

售后 `trade_after_sale → trade_after_sale_log` 关联订单项、退款和退货处理。分销有分销用户、佣金记录和提现申请三层；提现审核成功会向支付模块创建转账，而不是直接把佣金余额当作银行已到账。[订单创建和支付单创建](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/service/order/TradeOrderUpdateServiceImpl.java:186) · [售后退款](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/service/aftersale/AfterSaleServiceImpl.java:346) · [分销提现转账](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/service/brokerage/BrokerageWithdrawServiceImpl.java:82)

## 3. 关键关系和价格责任

订单保存 SPU/SKU 名称、规格、价格等交易快照，而不依赖商品后来修改仍能复原当时展示；订单项可关联优惠、售后和评价。价格服务先校验 SKU/SPU，再由各营销适配器返回价格影响，最终供结算和建单使用。它因此是“计算口径”层，不能把某个活动表的活动价直接认作所有订单的实付价。[价格计算入口](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/service/price/TradePriceServiceImpl.java:61)

优惠券模板与会员券是“一模板多实例”；下单使用某张会员券时会关联订单，退款/取消时可按规则退回。秒杀/拼团/砍价等记录与订单是条件关联，只有参加对应活动并成功建单才会写订单 ID。商品库存、秒杀库存、订单状态、支付状态分别由不同服务维护，不能只观察任一个字段推导全链路成功。

## 4. 端到端业务流程

### 流程 A：运营上架商品并形成可售目录

1. 运营维护品牌、类目、属性和值，再创建 SPU 和至少一组 SKU。
2. SPU 服务校验类目存在，依据 SKU 初始化商品最低/最高价、库存等汇总信息；SKU 服务校验规格组合，创建或差异更新 SKU。
3. 后台更新商品状态后，App 商品、类目和活动页面按各自查询条件展示可售对象。
4. 会员浏览会写浏览记录，可收藏；实际下单仍以交易价格服务实时校验 SKU 为准。
5. 运营删除商品/规格时，服务需要考虑 SKU、订单和库存类引用，不能用“前端已下架”替代历史业务约束。

[SPU 初始化](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/service/spu/ProductSpuServiceImpl.java:104) · [SKU 差异更新](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/service/sku/ProductSkuServiceImpl.java:220)。

### 流程 B：领券、核销、取消或退款回退

1. 运营设置券模板，包括适用范围、领取时间/数量、门槛和有效期；会员主动领取、注册赠送或管理员发放都会创建具体 `promotion_coupon`。
2. 领取服务校验模板状态、时间、限领和用户条件，写券并维护限领计数。
3. 结算时价格服务筛选可用券，创建订单后选择的券被标记使用并关联订单。
4. 若支付超时取消或售后退款按规则回退，交易服务调用券服务返还已使用券；券过期任务会把到期未使用券置为失效。
5. 管理员可按权限人工发券或作废，但这不是支付退款的替代流程。

[券使用/返还](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/service/coupon/CouponServiceImpl.java:59) · [领取限制与过期](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/service/coupon/CouponServiceImpl.java:224)。

### 流程 C：参与秒杀、拼团或砍价后建单

1. 运营配置活动及活动商品，秒杀还关联时段配置和活动库存；创建时校验同一商品/时段等冲突。
2. 会员在商品/活动页选择 SKU 和数量；参与校验会确认活动状态、SKU、数量、用户和库存等条件。
3. 秒杀下单时扣活动库存，订单建立时同时保留营销活动关联；拼团则创建或加入团记录，砍价则创建砍价记录并由其他用户助力降低价格。
4. 订单支付、取消或超时会驱动活动记录及库存的相应处理；拼团服务另有到期处理，成功/失败通知从记录状态派生。
5. 团长、参团者和订单项不是同一关系：一个拼团记录有团头和多个记录，订单使用的是对应成员记录。

[秒杀库存变更](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/service/seckill/SeckillActivityServiceImpl.java:160) · [砍价建记录/校验](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/service/bargain/BargainRecordServiceImpl.java:45) · [拼团到期](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/service/combination/CombinationRecordServiceImpl.java:301)。

### 流程 D：购物车结算、支付、发货和收货

1. 会员把 SKU 加入 `trade_cart`，结算接口取得会员地址、SKU/SPU 与促销信息，价格服务计算商品、运费、优惠和应付金额。
2. 创建订单时生成订单及订单项快照，扣减相关库存/营销资源；应付金额大于零时创建支付模块的支付订单，零元订单不走该创建分支。创建订单并不表示已支付。
3. 支付模块回调或主动同步确认已支付后，订单更新为待发货等相应状态；重复或不匹配支付单会被校验。
4. 商家填写快递/物流或处理自提；用户可确认收货，系统也有超时自动收货路径。
5. 未支付订单可由会员取消或系统超时取消，取消逻辑恢复相应资源；订单删除是会员视角删除，不应误读成物理抹除全部履约痕迹。

[结算与建单](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/service/order/TradeOrderUpdateServiceImpl.java:136) · [支付确认](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/service/order/TradeOrderUpdateServiceImpl.java:285) · [自动取消](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/service/order/TradeOrderUpdateServiceImpl.java:579)。

### 流程 E：售后退款和订单项闭环

1. 会员针对自己的订单项申请退款/退货，服务校验订单项归属、订单状态、是否已有售后和可申请时间。
2. 创建售后单及日志后，运营审核同意或拒绝；退货型售后由会员填写寄回信息，商家再收货或拒收。
3. 审核通过且达到退款条件时，服务向支付模块创建退款单；支付平台实际退款成功后回调/同步更新售后和订单项。
4. 订单项售后状态变化影响订单的售后汇总，所有订单项售后成功时可进入相应结束处理；取消售后会恢复订单项可售后状态。
5. 支付退款 ID 是跨模块身份，售后服务只保存和校验它，不能把 `trade_after_sale` 当作支付退款流水。

[创建售后校验](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/service/aftersale/AfterSaleServiceImpl.java:110) · [退款成功回写](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/service/aftersale/AfterSaleServiceImpl.java:386)。

### 流程 F：分销佣金与提现

1. 会员建立/关联分销用户关系，完成符合规则的订单后生成佣金记录。
2. 会员查询可提现金额并提交提现申请，服务按交易配置校验最小/最大金额与手续费，创建 `trade_brokerage_withdraw`。
3. 管理员审核拒绝或通过；通过时先处理佣金余额和记录，再调用支付模块建立转账。
4. 支付转账成功或失败信息回写提现申请状态；申请审核通过不等于外部转账一定已到账。
5. 统计端可汇总佣金和提现，但统计报表不替代逐笔记录核对。

[提现创建与费用计算](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/service/brokerage/BrokerageWithdrawServiceImpl.java:185) · [转账状态回写](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/service/brokerage/BrokerageWithdrawServiceImpl.java:236)。

## 5. 状态、跨模块协作与典型场景

订单至少经历未支付、已支付待履约、已发货/待收货、完成、取消等状态，售后和订单项另有状态；营销活动、会员券、支付单、物流单也有自己的状态机。价格、库存、支付成功和售后成功都是不同事件，不能将“订单已创建”或“活动已参加”解释为交易闭环。

- **member**：会员身份、地址、积分、经验值及分销相关资料由会员 API 提供。
- **pay**：应付金额大于零的订单建支付单，支付完成更新订单；售后建退款单；分销提现建转账。商城不直接接触支付渠道。
- **product**：交易根据 product API 校验 SKU/SPU 并增减库存；促销记录的是活动规则，不复制商品主数据。
- **promotion**：交易价格计算、券核销/返还、秒杀/拼团/砍价等通过 promotion API 协作。
- **infra/system**：文件、消息、用户和权限等基础能力来自平台模块；客服数据仍在 promotion 自己的表中。

典型场景：运营配置商品和秒杀，会员领券后限时购买；拼团人员在活动结束前凑团；商家处理快递或自提，会员确认收货后评价；会员对订单项申请退货退款；分销员在佣金形成后申请提现。

## 6. 已实现局限与验证边界

- 未从静态代码证明支付、退款、转账、快递查询、短信、客服 WebSocket 的第三方接口已连通；每类外部 ID 的回调、重试和幂等需要集成测试。
- 商品库存、营销库存与订单库存补偿跨服务协作，真实分布式事务/消息一致性不能由 Service 调用顺序保证，需压测并检查事务/事件配置。
- 商品、营销、订单金额的字段一般以分为单位，具体精度、税费、汇率、发票、成本核算和会计凭证不在此业务模块中完整实现。
- 当前 SQL 是由实体推导，物理外键/唯一键与生产迁移脚本可能不同；不要据此替代数据库约束审计。
- statistics server 的统计口径、更新频率和任务调度需独立验证；它不应作为实时订单状态的唯一事实来源。

## 7. Controller 包接口覆盖和源码入口

下面按四个 server 覆盖扫描到的 Controller 包，`admin` 和 `app` 同包分别对应运营与会员侧入口：

| Server | Controller 包 | 已覆盖接口域 |
| --- | --- | --- |
| product | `brand`、`category`、`property`、`spu`、`comment`、`favorite`、`history` | 后台品牌/类目/属性/SPU/评论管理；App 类目、商品、评论、收藏、浏览历史 |
| promotion | `activity`、`article`、`banner`、`diy` | 活动聚合、文章/分类、轮播和店铺装修的后台/App 查询 |
| promotion | `coupon`、`discount`、`seckill`、`combination`、`bargain`、`point`、`reward` | 券、折扣、秒杀、拼团、砍价、积分、满送活动维护及会员参与/记录 |
| promotion | `kefu` | 客服会话和消息的后台管理、App 消息入口 |
| trade | `cart`、`config`、`delivery`、`order` | 购物车、交易配置、快递/运费模板/自提点、会员下单/支付后查询和后台订单履约 |
| trade | `aftersale`、`brokerage` | 会员售后/售后日志与后台审核；分销用户/佣金/提现的 App 和后台入口 |
| statistics | `member`、`pay`、`product`、`trade` | 会员、钱包、商品、订单/售后/分销的经营统计查询 |

推荐以 [AppTradeOrderController](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/controller/app/order/AppTradeOrderController.java:44) → `TradeOrderUpdateServiceImpl` → `TradePriceServiceImpl` → promotion/product API → pay 回调路径为主线阅读；再分别进入售后、分销和统计。
