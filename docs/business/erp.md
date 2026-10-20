# ERP 进销存业务知识

> 本文基于当前分支的 Controller、Service、Mapper、DO、枚举和已推断 DDL 做静态分析，未启动服务、未执行审批并发或真实数据库联调。文中“会”仅指已读代码的写入路径，不代表接口、权限、索引和跨模块部署已经在运行环境验证。

## 1. 定位、角色与边界

ERP 是一套以商品、客户、供应商、仓库、结算账户为主数据的轻量进销存域。采购人员维护采购订单、采购入库和采购退货；销售人员维护销售订单、销售出库和销售退货；库管用其它出入库、移库、盘点调整库存；财务人员登记收付款。可审核单据初始为 `PROCESS`；库存类单据切换到 `APPROVE` 时才写库存，而收付款明细的已收已付累计按其保存、编辑和删除路径重算。

它的库存余额粒度是“商品 + 仓库”，`erp_stock_record` 是发生明细，`erp_stock` 是当前余额；主单和行项目分开，以便一张单处理多商品、多仓库。采购和销售订单保留累计入/出库和退货数量。收付款单以明细连接业务单，创建、编辑或删除未审批收付款单时会重算并回写来源单据的已收/已付金额；该累计不以收付款单审批为生效点。金额字段使用 `BigDecimal`，代码中以元处理，而不是 PAY 模块常见的“分”。

本模块的“审核”是自身 `ErpAuditStatus` 的状态切换，不是 BPM 流程实例：静态扫描未见 ERP 向 BPM 创建流程，也未见自动写 FMS 凭证。ERP 自己管理的库存与 MES/WMS 分开：ERP 只有商品和仓库库存，没有批次、SN、库区、库位、质量状态或生产线在制品；MES/WMS 也不会因名称相同自动和 `erp_stock` 同步。实际边界见 [库存增减入口](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/stock/ErpStockServiceImpl.java:64)。

## 2. 已实现的业务域

### 2.1 主数据与基础设置

商品分类是父子树；商品引用分类和计量单位，商品、客户、供应商、仓库和结算账户均有启停状态。分类、单位被删除前会检查引用数量；仓库和账户另有默认标识更新入口。商品创建/更新处仍明确留有“校验分类”的 TODO，不能把分类关联说成已完整强校验。[商品服务](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/product/ErpProductServiceImpl.java:43) [仓库有效性校验](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/stock/ErpWarehouseServiceImpl.java:92)。

### 2.2 采购：订单、入库、退货与付款

采购订单记录供应商、商品行、税额、折扣、其他费用和累计入库/退货数量。采购入库必须先校验订单已审核、结算账户和商品行，创建后汇总商品金额、税额、折扣和其他费用；审批入库时按行增加库存并写库存流水，撤回到 `PROCESS` 时按反方向冲回，且已经付款的入库不能撤回。采购退货同样关联采购订单、账户和商品行，审核会以负数影响库存，并回写订单退货累计。付款单由账户和付款明细组成，明细关联采购入库或采购退货；创建、编辑或删除未审批付款单时即按明细重算来源单的 `paymentPrice`，付款单的状态切换本身不做该回写，因此“订单金额”和“已付款金额”不是同一口径。[采购入库创建、累计和库存变化](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/purchase/ErpPurchaseInServiceImpl.java:74) [付款单服务](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/finance/ErpFinancePaymentServiceImpl.java:71)。

### 2.3 销售：订单、出库、退货与收款

销售订单使用客户、商品行和累计出库/退货数量；销售出库创建时校验订单已审核，审核后减少 `erp_stock`，撤回时增加库存，收款金额大于零时不能撤回。销售退货审核则把退回商品加回库存，并维护来源销售订单的退货数量。收款单与付款单是对称结构：收款明细引用销售出库或销售退货，创建、编辑或删除未审批收款单时回算来源单的 `receiptPrice`；其状态切换本身不做该回写。这是一套业务应收应付累计，不是银行对账、支付渠道回调或总账入账。[销售订单数量累计](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/sale/ErpSaleOrderServiceImpl.java:203) [销售出库状态变化](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/sale/ErpSaleOutServiceImpl.java:166)。

### 2.4 仓储、库存流水与统计

其它入库、其它出库、移库和盘点是脱离采购/销售单据的库存动作。入库审批产生正库存，出库审批产生负库存，移库为源仓负数、目标仓正数，盘点根据盘点前后的明细差额调整；每一个变化调用库存流水服务写业务类型、主单、行项目和单号。余额更新是读当前余额后增量写回，不是物理预占或批次锁库存；库存不足时由 `updateStockCountIncrement` 拒绝形成负余额。[库存流水创建](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/stock/ErpStockRecordServiceImpl.java:43) [其它入库审核与反审核](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/stock/ErpStockInServiceImpl.java:111)。

采购、销售统计服务返回的只是时间范围金额聚合，分别以采购入库和销售出库为来源；它们不改库存、付款状态或会计台账。[采购统计](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/statistics/ErpPurchaseStatisticsServiceImpl.java:22) [销售统计](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/statistics/ErpSaleStatisticsServiceImpl.java:22)。

## 3. 核心对象与表关系

| 对象链 | 主要表 | 关系与业务含义 |
| --- | --- | --- |
| 商品主数据 | `erp_product_category`、`erp_product_unit`、`erp_product` | 分类树和计量单位服务商品；单据行保留商品、单位及当时的价格/数量 |
| 往来与结算 | `erp_supplier`、`erp_customer`、`erp_account` | 采购链引用供应商，销售链引用客户，出入库/收付款可引用结算账户 |
| 采购链 | `erp_purchase_order(_items)` → `erp_purchase_in(_items)` / `erp_purchase_return(_items)` | 订单行的已入库、已退货数量由关联单汇总更新 |
| 销售链 | `erp_sale_order(_items)` → `erp_sale_out(_items)` / `erp_sale_return(_items)` | 订单行的已出库、已退货数量由关联单汇总更新 |
| 收付 | `erp_finance_payment(_item)`、`erp_finance_receipt(_item)` | 明细用业务类型和业务单 id 指向采购/销售入退库；保存、编辑或删除未审批单据时按现有明细重算并回写来源累计金额 |
| 库存 | `erp_warehouse`、`erp_stock`、`erp_stock_record` | 余额与流水分离；流水可追溯至采购、销售或其它库存单 |
| 独立库存单 | `erp_stock_in/out/move/check` 及各自 `*_item` | 四类主单—行项目结构，审批后经库存流水统一影响余额 |

可结合 [ERP ER 图](/Users/chenwen/workspace2/yudao-cloud/docs/er/erp-er.drawio) 和 [ERP 推断 DDL](/Users/chenwen/workspace2/yudao-cloud/sql/mysql/erp.sql) 阅读。图中的业务连接来自代码字段和调用，不等同于已部署的物理外键。

## 4. 主要端到端流程

### 流程 A：采购订单到采购入库

1. 采购维护供应商、商品和仓库，建立采购订单及其商品行；审核订单后，才能作为采购入库来源。
2. 创建采购入库时读取订单，校验商品、账户并生成编号；金额由行商品金额、税额、折扣和其他费用汇总。
3. 系统将入库明细与订单行对应，重算订单各行累计入库数量；此时仍是 `PROCESS`。
4. 审核采购入库时，以每行数量创建 `PURCHASE_IN` 库存流水并增加对应商品仓库余额。
5. 撤回审核时写 `PURCHASE_IN_CANCEL` 反向流水，但已有付款金额的单据被拒绝撤回。
6. 创建或编辑付款单时即重算来源采购入库的已付款累计，超过单据总额会被拦截；付款单审批不额外触发累计回写，它不会自动生成 FMS 凭证。

核心实现在 [采购入库](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/purchase/ErpPurchaseInServiceImpl.java:74)。

### 流程 B：销售订单到出库和收款

1. 建立客户和商品后录入销售订单；订单审核后才可创建销售出库。
2. 出库保存商品、仓库和价格数量，系统回算来源订单已出库数量。
3. 审核出库时对每行创建负库存变动；库存服务若计算出负余额则抛出库存不足异常，单据状态切换和库存写入处于事务方法中。
4. 撤回审核写相反的库存流水；已有收款金额时不能撤回。
5. 收款单按明细关联销售出库或销售退货，创建或编辑时重算来源单的已收款累计；销售退货审核把库存加回并累计订单退货数量。

参考 [销售出库](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/sale/ErpSaleOutServiceImpl.java:74) 和 [收款单](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/finance/ErpFinanceReceiptServiceImpl.java:71)。

### 流程 C：不通过采购/销售单的库存调整

1. 库管创建其它入库、其它出库、移库或盘点单，主单中保存原因/仓库等业务信息，行项目保存商品、仓库、数量和价格。
2. 草稿阶段可编辑，已审核单不允许编辑或删除；审核状态切换使用“id + 原状态”条件更新，避免旧状态被重复审批。
3. 其它入库/出库分别生成正/负库存流水；移库对同一行生成源仓负数、目的仓正数；盘点按差异生成调整。
4. 库存余额按商品仓库维度增量更新，流水携带来源主单与来源行，作为追溯依据。

移库实现见 [ErpStockMoveServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/stock/ErpStockMoveServiceImpl.java:106)，库存余额更新见 [ErpStockServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/stock/ErpStockServiceImpl.java:64)。

### 流程 D：采购退货和退款

1. 采购退货关联已审核采购订单、结算账户和商品行，创建或编辑会回算订单退货累计。
2. 审核退货时以负数生成库存流水，减少退回商品所在仓库余额。
3. 退款金额由采购退货承载；付款单/退款业务的明细与状态共同约束来源单据的支付累计。
4. 退货审核后不可按普通单据修改；若回到处理状态，须受已付款金额约束并按反向库存流水处理。

参考 [采购退货](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/purchase/ErpPurchaseReturnServiceImpl.java:70)。

## 5. 状态、金额与库存规则

| 规则 | 代码表达 |
| --- | --- |
| 通用审核状态 | 单据在 `PROCESS` 与 `APPROVE` 间切换；已审批单拒绝普通编辑和删除 |
| 生效点 | 采购/销售入退库、其它出入库、移库、盘点均在审批状态变化时写库存，不是保存时写库存；收付款来源累计是保存/编辑/删除未审批收付款单时重算，不能套用这一库存规则 |
| 反向动作 | 从审批回处理会按相反数量写库存流水；付款/收款累计大于零时，相关入库/出库不能撤回 |
| 数量累计 | 入库、出库、退货的行项目数量汇总后写回来源订单行，订单自身不是库存余额 |
| 金额计算 | 行金额由 `MoneyUtils.priceMultiply` 等计算，主单将商品、税、折扣、其他费用汇总；收付款累计不得超过来源单总金额 |
| 库存不足 | 库存服务用商品仓库余额加增量，结果小于零时拒绝；未读到批次、序列号、保质期或库位粒度 |

状态常量见 [ErpAuditStatus](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-api/src/main/java/cn/iocoder/yudao/module/erp/enums/ErpAuditStatus.java:11)，库存业务类型见 [ErpStockRecordBizTypeEnum](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-api/src/main/java/cn/iocoder/yudao/module/erp/enums/stock/ErpStockRecordBizTypeEnum.java:10)。

## 6. 跨模块协作与边界

- **SYSTEM**：Controller 读取后台用户名称用于创建/更新人展示；这不是 HRM 员工主数据，也不代表商品、客户、仓库和系统组织自动同步。
- **Redis 编号**：`ErpNoRedisDAO` 为采购、销售、库存和收付业务生成单号；仍会查询同号记录作重复校验。[编号使用示例](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/stock/ErpStockInServiceImpl.java:68)
- **FMS/PAY/BPM**：本次静态读取核心写服务未发现 ERP 自动建凭证、支付渠道订单或 BPM 实例。收付款是 ERP 内部业务状态，不能等同支付成功或会计过账。
- **MES/WMS**：ERP 的 `erp_stock` 不含生产批次、SN、库区库位，MES 的 `mes_wm_material_stock`/事务流水不应在没有显式集成代码时被当作同一余额。需要以实际集成契约决定主库存系统。

## 7. 典型场景

1. 常规采购：采购订单审核后分批建立入库，订单行累计反映已到货数量，入库审核后才进仓；结算可晚于到货。
2. 现货销售：销售订单审核、创建出库、库存足够后审核出库；收款登记与出库分离，所以“已发货”与“已收款”可并存不同状态。
3. 仓内调拨：一个移库单把同商品数量从源仓扣减并加到目标仓，库存流水可以从单号反查两端变化。
4. 盘点修正：盘点明细与当前余额比较后在审核时写差异；它是业务单据调整，不应直接改 `erp_stock` 余额绕过流水。

## 8. 当前限制与待验证事项

- 商品服务创建/更新未完成分类存在校验；库存服务还有“后续做成 DB 配置”的 TODO，当前负库存策略和默认设置需结合真实部署确认。[商品 TODO](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/product/ErpProductServiceImpl.java:44) [库存 TODO](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/service/stock/ErpStockServiceImpl.java:30)。
- 多个采购、销售、库存与收付服务顶部保留“记录操作日志” TODO，不能据此宣称所有单据有完整的 ERP 业务审计链。
- 生成的 DDL 是从实体反推，不等于生产迁移文件；物理外键、唯一索引和并发更新效果须对真实库复核。库存余额更新、并发审批和反审核的锁/隔离级别没有运行验证。
- 未看到采购订单自动生成入库、销售订单自动生成出库、订单自动关闭、成本计价、预占库存、分批发货、反冲销或财务凭证联动；不要将表名或前端菜单推断为已实现自动化。

## 9. Controller 接口域覆盖与阅读入口

建议按“采购入库/销售出库 → 库存流水 → 库存余额 → 收付款累计”阅读：先读状态切换服务，再读行项目汇总和 Mapper；查询、导出接口不会改变这些状态。

| Controller 包（相对 `controller/admin`） | 控制器数 | 路由域与已核对能力 |
| --- | ---: | --- |
| [finance](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/controller/admin/finance) | 3 | `/erp/account`、`finance-payment`、`finance-receipt`：账户、付款、收款及明细查询 |
| [product](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/controller/admin/product) | 3 | `/erp/product-category`、`product`、`product-unit`：分类、商品、单位维护 |
| [purchase](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/controller/admin/purchase) | 4 | 供应商、采购订单、采购入库、采购退货的 CRUD、状态变更、明细与导出 |
| [sale](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/controller/admin/sale) | 4 | 客户、销售订单、销售出库、销售退货的 CRUD、状态变更、明细与导出 |
| [stock](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/controller/admin/stock) | 7 | 仓库、库存、库存流水、其它入库/出库/移库/盘点的单据与明细入口 |
| [statistics](/Users/chenwen/workspace2/yudao-cloud/yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/controller/admin/statistics) | 2 | 采购与销售金额汇总统计 |

覆盖合计 23 个 Controller。ER 图中的 33 张表均属于以上主数据、进销存、收付和库存流水域；接口能否由当前用户调用仍取决于 Controller 权限注解和运行时数据权限配置。
