# MES 制造执行业务知识

> 本文根据当前 MES 管理端 Controller、Service、DO、枚举、Mapper 和推断 DDL 的静态分析编写，未接入产线设备、扫码枪、称重/检测仪或真实数据库。本模块有大量单据和状态服务；文中只把已经在代码中看到的状态动作写为已实现，对仅有 CRUD、空白关联或前端未调用的入口明确保留边界。

## 1. 定位、角色与库存边界

MES 面向制造现场，覆盖主数据、工艺路线与 BOM、工单与任务、报工、质量检验、设备、工具、排班，以及带批次/SN/库区库位的物料仓储。计划员配置产品、BOM、工艺、路线和工单；班组/操作员按工位处理任务、报工和现场打卡；质检员处理来料、过程、首件/巡检、完工/出货检验；设备员维护设备、点检、保养和维修；仓管执行来料、领料、生产入出库、委外、销售、退货、移库及盘点。

MES 的库存事实是 `mes_wm_material_stock` 与 `mes_wm_transaction`：余额的唯一业务维度包含物料、仓库、库位、库区、批次/批号、供应商和收货时间。所有已接入事务服务的入库数量必须为正、出库必须为负，服务会校验批次、混放规则、冻结状态、关联事务并增量更新余额后写事务流水。[事务创建](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/wm/transaction/MesWmTransactionServiceImpl.java:48)。

这与 ERP、独立 WMS 的库存是不同边界：ERP 是“商品 + 仓库”的轻量余额，WMS 模块是自身 SKU+仓库余额，MES 是生产仓储的批次/库位余额。未发现三者间自动同步服务调用，所以不能把任一模块的入出库或库存报表解释成另一个模块已经同步的库存。

## 2. 业务域全景

### 2.1 日历排班、人员与现场资源

日历/节假日、班组、成员、班次以及排班计划组织人员能力。排班计划创建时可按班制生成默认班次；确认前校验班组数量与轮班方式，确认后生成班组排班记录，确认后不能再编辑。工位绑定车间、设备、工具和员工，生产现场打卡记录操作员进入/离开工位，不应混同 HRM 的考勤打卡。[排班确认](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/cal/plan/MesCalPlanServiceImpl.java:71) [工位打卡](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/pro/workrecord/MesProWorkRecordServiceImpl.java:52)。

### 2.2 主数据、产品结构与工艺

物料、物料分类、单位、客户、供应商、车间/工位、自动编码、批次配置、产品 BOM、SIP/SOP 是所有制造单据的基础。产品 BOM 保存父物料—子物料用量关系，新增时拒绝自引用和全图环；工艺定义工序及内容，路线将工序排序并可绑定产品和 BOM。SIP/SOP 当前可保存与查询，但 Controller 明确留有工序名称/编码联表 TODO，不能把其响应中完整工序展示当成已经实现。[BOM 环检测](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/md/item/MesMdProductBomServiceImpl.java:91) [SIP TODO](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/controller/admin/md/item/MesMdProductSipController.java:71)。

### 2.3 工单、任务、报工和安灯

工单保存产品、数量、客户/委外供应商、计划及工艺路线引用；创建时校验产品和客户批次要求，并可生成工单 BOM。工单可确认、完成或取消，完成/取消会批量结束/取消未终态任务。任务绑定工单、工位、路线、工序和物料，创建时自动生成编码与名称，并继承工单客户；任务的产出、合格、不合格数量可以由报工累计。报工单可提交、驳回，并在 IPQC 完成后更新其质量结果；安灯配置/记录表达异常呼叫和处理记录。代码存在任务问题 Controller，但注释说明前端尚无调用，因此只能称为后端入口，不能称为已可用闭环。[工单状态动作](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/pro/workorder/MesProWorkOrderServiceImpl.java:155) [任务创建和产量累计](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/pro/task/MesProTaskServiceImpl.java:48) [任务问题 TODO](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/controller/admin/pro/task/MesProTaskIssueController.java:34)。

### 2.4 质量：模板、缺陷与 IQC/IPQC/OQC/RQC

质量模板由模板项和指标组成，指标、缺陷和缺陷记录提供规则及实测不良数据。IQC 校验来料和委外收货来源；IPQC 可关联生产报工；OQC 面向成品出货；RQC 面向返工/返修检验。创建检验单可从模板生成检验行，完成时汇总合格/不合格、缺陷及行数据，并可将结果回写关联报工。`mes_qc_pending_inspect` 作为待检索引/队列对象存在，但是否由所有业务单据自动生成，必须以各来源服务调用为准，不能由表名断言全覆盖。[IQC 来源校验](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/qc/iqc/MesQcIqcServiceImpl.java:221) [OQC 完成](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/qc/oqc/MesQcOqcServiceImpl.java:129)。

### 2.5 设备、点检、保养、维修与工装

设备分类与设备资料是设备域主数据；点检计划关联设备和点检项目，点检记录及行保存执行结果；保养记录及行保存维护工作；维修工单和行记录故障与维修明细。维修不是纯 CRUD：草稿提交后进入维修中，确认维修后进入待验收，验收完成后才成为已确认并记录结果、验收人和时间。工具/工装分类与工具资料可维护，未在本次代码中看到完整领用、校准或寿命扣减闭环。[维修状态流程](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/dv/repair/MesDvRepairServiceImpl.java:112)。

### 2.6 MES 仓储、批次、条码与盘点

仓库、库位、库区可冻结；物料可配置批次管理。批次、条码、SN、包装和库存事务提供物料可追溯基础。到货通知、物料收货、其它收/发、生产领料/退料、完工入库、产成品出库/退货、委外发料/收货/退料、移库、盘点、销售通知分别由主单—明细—行构成。多种单据有提交/完成动作时，会调用 `MesWmTransactionService`，但并非仅出现同名表就能推断完成动作已经实现；需要逐个 Service 验证。

例如销售退货完成会将明细转换为入库事务，生产领料完成则应产生负数事务；库存服务统一负责批次、混放、冻结与数量约束。事务服务写的是生产仓物料台账，不直接写 ERP `erp_stock` 或独立 WMS `wms_inventory`。[销售退货事务调用](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/wm/returnsales/MesWmReturnSalesServiceImpl.java:188)。

## 3. 核心对象及关系

| 领域 | 核心表群 | 关系与台账意义 |
| --- | --- | --- |
| 日历排班 | `mes_cal_*` | 计划—班次/班组，班组—成员/班次；确认计划生成班组排班记录 |
| 主数据 | `mes_md_*` | 物料、单位、客户/供应商、车间/工位及其设备/工装/人员关系 |
| 工艺制造 | `mes_md_product_bom`、`mes_pro_process*`、`route*`、`work_order*`、`task*`、`feedback` | BOM/路线配置被工单和任务引用，工单/任务产量由报工累计 |
| 质量 | `mes_qc_template*`、`indicator*`、`defect*`、`iqc/ipqc/oqc/rqc*` | 模板生成检验行；缺陷记录回汇总到检验单/行，检验可关联来源单据 |
| 设备工装 | `mes_dv_*`、`mes_tm_*` | 设备类型/设备，点检、保养、维修及行；工具类型/工具 |
| 仓储余额 | `mes_wm_warehouse*`、`batch`、`material_stock`、`transaction` | 仓库—库位—库区，库存按批次/供应商/时间等维度，事务是唯一变化轨迹 |
| 仓储单据 | 到货、收货、领退料、生产入出库、委外、销售、移库、盘点等 `mes_wm_*` | 通常主单—明细—行；完成服务把合法行转成正/负库存事务 |

对应 [MES ER 图](/Users/chenwen/workspace2/yudao-cloud/docs/er/mes-er.drawio) 与 [MES 推断 DDL](/Users/chenwen/workspace2/yudao-cloud/sql/mysql/mes.sql)。MES 有 133 张持久表，图按领域拆页；ER 连线是代码逻辑，不代表数据库已配外键。

## 4. 主要端到端流程

### 流程 A：BOM/路线到工单、任务和报工

1. 维护产品物料、单位、BOM、工序和工艺路线；BOM 保存时拒绝自引用和环形结构。
2. 创建工单时校验产品存在、客户批次配置等，写入工单并生成或维护工单 BOM。
3. 确认工单后创建/安排生产任务；任务校验工单、工位、路线、启用工序和物料，并由自动编码规则生成任务编码。
4. 操作员在工位打卡、执行报工；任务和工单的总产出、合格/不合格数量由相应更新方法累计。
5. 工单完成时结束未终态任务，取消时取消未终态任务；这不等于自动完成所有仓储/质量单据，需各域动作分别完成。

代码入口：[工单](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/pro/workorder/MesProWorkOrderServiceImpl.java:57)、[任务](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/pro/task/MesProTaskServiceImpl.java:48)、[报工](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/pro/feedback/MesProFeedbackServiceImpl.java:68)。

### 流程 B：来料收货到 IQC

1. 建立到货通知及行，再创建物料收货单、明细和行；行数据承载物料、数量、批次和库位等信息。
2. 完成收货单的具体路径在服务中将合法行转为入库事务；批次管理物料缺批次会被事务服务拒绝，仓库/库位/库区/库存被冻结也会拒绝。
3. IQC 创建时可指定到货通知或委外收货的来源单和来源行，服务验证两者匹配并保存来源单号。
4. 检验行可按模板生成，缺陷记录汇总到检验行和检验单；完成 IQC 后形成结果，但是否驱动所有物料质量状态转换需要逐一联调验证。

来源验证见 [MesQcIqcServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/qc/iqc/MesQcIqcServiceImpl.java:221)，库存规则见 [事务服务](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/wm/transaction/MesWmTransactionServiceImpl.java:57)。

### 流程 C：生产领料、报工、IPQC与完工入库

1. 基于工单/BOM创建生产领料单及行，完成时对原材料产生出库事务；原材料数量必须以负数通过事务服务。
2. 操作员执行工序报工，报工单在提交/驳回之间变化；生产任务和工单可累计产出、合格和不合格数量。
3. IPQC 可关联报工来源并依据模板检查，完成检验后服务可回写关联报工的质量结果。
4. 完工入库单及其明细/行在完成路径中把合格产出转为入库事务；它与报工完成、工单完成是相互关联但不应在无调用证据下合并为一个原子动作。
5. 返工检验 RQC、缺陷记录和不合格品处置仍应单独按具体单据状态处理。

报工质量回写入口见 [MesProFeedbackServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/pro/feedback/MesProFeedbackServiceImpl.java:313)。

### 流程 D：委外发料、收货和退料

1. 建立供应商、委外工单/产品及委外发料单，发料单主单、明细、行记录发给供应商的物料。
2. 完成发料会对自有仓生成负向事务；供应商、批次和来源单保持在单据/库存维度。
3. 委外收货关联委外业务，完成后形成正向入库事务；IQC 可以将委外收货行作为检验来源。
4. 委外退料用于从供应商或委外过程回转物料，仍需要以已实现的单据完成动作和事务方向为准。

相关服务：[委外发料](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/wm/outsourceissue/MesWmOutsourceIssueServiceImpl.java:49)、[委外收货](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/wm/outsourcereceipt/MesWmOutsourceReceiptServiceImpl.java:47)。

### 流程 E：销售通知、成品出库和销售退货

1. 销售通知及行作为成品销售出库的上游业务表达，出库单的明细和行保存发运物料、批次与库位。
2. 生产销售出库完成后调用库存事务服务并产生负向库存变化；不因名称带“sale”而自动与 CRM 合同、ERP 销售单或 PAY 收款绑定。
3. 销售退货单完成时，把退回明细转换为正向入库事务，并保留来源业务信息。
4. OQC 面向出货质量，检验结果与库存/发运的最终放行关系应以运行联调确认。

销售退货已见 [createTransactionList 调用](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/wm/returnsales/MesWmReturnSalesServiceImpl.java:188)。

### 流程 F：移库、盘点与库存冻结

1. 仓库、库位、库区均可冻结；移库单保存来源与目标位置，完成时应由对应行形成出库/入库配对事务。
2. 盘点计划定义范围和参数，生成盘点任务、盘点行和结果；任务有开始、完成、取消等入口。
3. 库存变化统一先检查仓库、库位、库区和库存记录的冻结标记，再更新余额并写事务。
4. 盘点期间的并发出入库、批次和混放规则需要真实数据库测试；不能只凭控制器存在就宣称库存已严格锁定。

冻结校验见 [MesWmTransactionServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/wm/transaction/MesWmTransactionServiceImpl.java:141)。

### 流程 G：设备故障到维修验收

1. 设备员维护设备类型、设备、点检项目/计划、保养/维修项目及工装。
2. 创建维修工单时校验设备、编码并写为草稿；草稿可编辑或删除。
3. 提交维修时变为维修中并写接受人；确认维修写完成日期并变为待验收。
4. 验收完成后写结果、验收人和验收时间，状态变为已完成。点检/保养和维修之间没有被本次扫描证明为自动联动。

实现见 [MesDvRepairServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/service/dv/repair/MesDvRepairServiceImpl.java:112)。

## 5. 状态、数量和库存台账规则

| 维度 | 已核对规则 |
| --- | --- |
| 排班 | 草稿计划确认后生成班组班次记录，已确认计划不可普通更新或删除 |
| 工单/任务 | 工单确认、完成、取消为专用动作；任务完成/取消依赖工单终态动作，任务自身拒绝对终态任务删除 |
| 报工/质量 | 报工存在提交、驳回和 IPQC 完成回写；IQC/IPQC/OQC/RQC 从模板生成行并汇总缺陷，但放行策略要以各服务校验为准 |
| 设备 | 维修状态是草稿 → 维修中 → 待验收 → 已完成；不能用普通更新伪造终态 |
| 仓储数量 | 事务方向强制：入库正数、出库负数；库存余额由事务更新，批次管理物料入库要求批次 |
| 库存安全 | 仓库、库位、库区和库存记录被冻结时拒绝事务；入库还要校验库区混放规则和关联事务存在性 |

注意事务服务使用 `Assert` 校验数量符号；错误会直接抛出。单据层的完成方法是否全都在同一事务边界、是否幂等，需要按单据服务和真实数据库进一步验证，不能将统一事务服务误读为全模块统一幂等框架。

## 6. 与其他模块的协作

- **SYSTEM**：生产现场打卡、工位人员等会使用后台用户身份；具体用户/部门同步范围需跟 API 调用确认。
- **INFRA**：自动编码记录、附件/导出等依赖框架基础能力；二维码/条码实体存在不证明已集成硬件扫描设备。
- **ERP/WMS/CRM/PAY/FMS**：静态扫描未发现 MES 库存事务自动同步到这些模块，也未发现销售出库自动生成 CRM 交易、PAY 收款或 FMS 凭证。跨系统物料编码、库存主数据和业务单据需由明确集成契约处理。
- **质量与仓储**：IQC 能校验到货通知、委外收货来源；IPQC 与报工有回写路径。其余质量单与所有仓储单的自动待检、放行、冻结关系不能由名称推断。

## 7. 典型场景

1. 离散制造：配置物料 BOM 和路线，创建工单及工序任务，操作员在工位报工，质检通过 IPQC 记录过程质量，再进行完工入库。
2. 批次追溯：收货时对批次管理物料建立批次/条码与库位库存，所有已接入的收发动作通过库存事务留下来源单号、行号和关联事务。
3. 委外加工：向供应商发料、接收委外收货并可发起 IQC，必要时发起退料；库存方向需以事务流水而非页面单据状态核对。
4. 设备保障：设备故障进入维修单，维修人员接受并完成维修，管理人员验收结果；设备保养和点检另有独立记录。
5. 月度盘点：按计划生成盘点任务和结果，通过仓库/库位/库区冻结和库存事务控制调整过程。

## 8. 当前限制与待验证事项

- MES 有 127 个 Controller、133 张持久表，覆盖面大于已做的运行验证；本文不把 CRUD 服务、未调用的后端入口或未验证的前端页面写成生产可用闭环。
- 产品 SIP/SOP 的工序名称/编码响应补全仍有明确 TODO；任务问题 Controller 注明“前端没地方调用”。这些都需要补齐 UI/联表后再称为完整业务体验。
- 质量单的合格放行、待检生成、库存质量状态切换、报工与完工入库原子性、委外退料和盘点并发处理需要集成测试。事务服务可验证方向、批次、冻结和混放，但不能替代全部来源单状态校验。
- 推断 DDL 不替代生产迁移；库存并发锁、唯一索引、批次/条码/SN 唯一性、软删除及事务隔离级别都要用真实 MySQL 验证。
- 未见 ERP/WMS 库存、CRM 销售、FMS 成本/凭证、PAY 收款的自动协同证据。上线时必须先确定库存主系统与跨系统补偿/对账机制。

## 9. Controller 接口域覆盖与阅读入口

建议阅读顺序：主数据/BOM → 工单任务报工 → IQC/IPQC → MES 事务库存 → 设备维修。下表按全部 Controller 包覆盖，明细 Controller 有些仅提供行查询/维护，不能据此推断主单完成逻辑。

| Controller 包（相对 `controller/admin`） | 控制器数 | 覆盖业务 |
| --- | ---: | --- |
| [cal](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/controller/admin/cal) | 8 | 日历、节假日、班组/成员/班次、排班计划及其班组/班次 |
| [md](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/controller/admin/md) | 17 | 自动编码、客户/供应商、物料/分类/单位/批次配置/BOM/SIP/SOP、车间/工位及资源绑定 |
| [pro](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/controller/admin/pro) | 17 | 安灯、工位打卡、报工、工序/路线、任务/问题、工单/BOM、工时记录 |
| [qc](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/controller/admin/qc) | 20 | 缺陷、指标、模板、待检、IQC/IPQC/OQC/RQC 及行/结果明细 |
| [dv](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/controller/admin/dv) | 17 | 设备类型/设备、点检计划/记录、保养记录、维修单及其行/项目 |
| [tm](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/controller/admin/tm) | 2 | 工具类型和工具资料 |
| [wm](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/controller/admin/wm) | 45 | 仓库/库位/库区、批次/条码/SN/包装、各类收发/委外/生产/销售/退料、库存、移库、盘点 |
| [home](/Users/chenwen/workspace2/yudao-cloud/yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/controller/admin/home) | 1 | MES 首页统计 |

按源码实际计数合计 127 个 Controller；分类计数与仓储主单/明细/行 Controller 一致。完成接口、权限注解、前端入口和设备/扫码集成需要在实际环境逐条验证。
