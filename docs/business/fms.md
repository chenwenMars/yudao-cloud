# FMS 财务管理业务知识

> 本文依据当前 FMS 后端 Controller、Service、Mapper、DO、枚举及推断 DDL 的静态分析编写，未导入真实账套、未跑结账或报表，也未核对会计准则与生产数据。它描述代码中的账务对象和校验路径，不构成会计处理意见。

## 1. 定位、角色与边界

FMS 是独立账套下的总账、凭证、期初、账簿、三大报表和期末结转模块。账套所有者建立账套并配置用户；会计维护科目、币别、辅助核算、摘要、凭证字和模板，录入或导入凭证；审核人员处理凭证审核；月结人员生成结转凭证并关账；管理人员查看账簿、首页指标和资产负债表、利润表、现金流量表。

账套是权限和数据隔离的根：绝大部分写服务先校验 `accountSetId` 的读/写/所有者权限，科目、凭证、余额、报表和关账都挂在账套下。`fms_account_user` 保存成员和默认账套，`fms_account_set` 保存账套基本信息、启用时间和锁定状态；这比单个后台用户菜单权限更细。[账套权限校验](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/config/FmsAccountSetServiceImpl.java:178)。

FMS 当前不从 ERP、CRM、PAY 自动取数生成凭证：本次读取核心写服务未发现这些模块的 API 调用。ERP 的收付款、PAY 的渠道交易、CRM 的回款登记都不能自然等价为 FMS 凭证；需要显式业务接口或人工/导入凭证才能形成总账。金额均以 `BigDecimal` 参与借贷、余额、报表和结转计算，本文不将其解释为支付渠道分值。

## 2. 业务域与实际对象

### 2.1 账套初始化、科目与辅助核算

创建账套后，初始化流程会建立账套用户、默认科目、币别、财务参数、凭证字、结转模板和财务指标等基础资料；账套初始化不是只插入一条账套记录。科目支持父子层级、借贷方向、启停、数量核算、外币核算和辅助核算类别；删除/禁用前会检查凭证、余额、模板等引用。辅助类别、辅助项目及其组合为客户/供应商/部门等明细核算提供维度，科目可声明其使用的辅助类别。

期初余额仅可写入允许编辑的账套，且要求末级科目、辅助项目组合与科目设置匹配。读取时父级余额由末级科目逐级聚合，试算平衡分别比较期初和本年借贷合计。[账套初始化](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/config/FmsAccountSetServiceImpl.java:134) [期初余额保存与试算](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/config/FmsInitialBalanceServiceImpl.java:118)。

### 2.2 凭证与分录

凭证主表保存账套、凭证字、日期、编号、摘要、附件、状态及结账相关标识，`fms_voucher_entry` 保存借贷方向、科目、金额、数量、币种和辅助组合。创建与编辑会验证账套写权限、会计期间开放、凭证字、分录平衡、科目及辅助核算；删除、作废、审核、整理号码、移动日期均是独立动作。凭证编号整理有“补断号”和“按日期重排”两种模式，不能理解为业务日期自动排序。

凭证状态枚举包括待审核、已审核、已驳回、审核中、已撤回、未提交、已创建、已删除和已作废。状态名称展示的是可用枚举集合，具体每种转移限制必须以 `FmsVoucherServiceImpl` 的校验为准，不能由数字排序推断。审核凭证是账簿、报表、结账读取的重要来源；但本次没有运行不同状态的完整报表口径验证。[凭证写入、审核与整理入口](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/voucher/FmsVoucherServiceImpl.java:123) [凭证状态枚举](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/enums/voucher/FmsVoucherStatusEnum.java:14)。

### 2.3 账簿、报表与首页

账簿服务提供明细账、总账、科目余额表、多栏账、辅助明细账/余额表、数量明细账/总账；这些是按账套、会计期间、科目及辅助维度读期初与凭证分录后计算出的查询结果，不是另存一套账簿交易表。首页读取已启用财务指标和报表公式，输出账户视角的指标及明细。

资产负债表、利润表、现金流量表分别有配置表和结果/调整表。报表公式可以引用科目、行次或现金流参数；更新公式先做可编辑、账号套和解析校验。报表“检查”接口表达勾稽/校验结果，不能替代人工确认报表合规。现金流量表还保留扩展配置和调整数据，说明现金流口径不只是凭证金额直接相加。[账簿计算入口](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/ledger/FmsLedgerServiceImpl.java:158) [资产负债表](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsBalanceSheetServiceImpl.java:117) [现金流量表](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsCashFlowStatementServiceImpl.java:124)。

### 2.4 期末结转与关账

结转期间按账套和月份组织。结转模板定义科目/规则，结转方案定义可执行组合；系统可生成损益结转凭证、方案结转凭证或批量结转凭证，并用 `fms_closing_voucher` 记录结转与凭证的对应关系。关账会校验结账条件并标记期间、结转凭证的关闭状态；反关账会按代码允许的前置条件恢复。它不是简单给账套加“已关账”标记，也不是自动生成所有会计凭证。[生成结转凭证](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/closing/FmsClosingVoucherServiceImpl.java:142) [关账/反关账](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/closing/FmsClosingPeriodServiceImpl.java:205)。

## 3. 核心对象与表关系

| 业务对象 | 主要表 | 关系及作用 |
| --- | --- | --- |
| 账套和授权 | `fms_account_set`、`fms_account_user`、`fms_finance_parameter` | 账套限定全部账务数据，成员关联用户并定义默认账套，参数记录账套会计设置 |
| 科目与辅助核算 | `fms_subject`、`fms_subject_template`、`fms_auxiliary_type`、`fms_auxiliary_item`、`fms_assist_combination`、`fms_currency` | 科目树定义核算口径；辅助项目组合和币别被余额、凭证分录引用 |
| 基础凭证资料 | `fms_digest`、`fms_voucher_word`、`fms_voucher_template_category`、`fms_voucher_template` | 摘要、凭证字和模板用于录入/导入，不是会计事实本身 |
| 期初和凭证 | `fms_initial_balance`、`fms_voucher`、`fms_voucher_entry` | 期初余额给出起点；一张凭证有多条借贷分录 |
| 报表 | `fms_report_template`、各 `*_config`、各 `*_report`、现金流 `*_extend_*` | 配置/公式与结果、调整分离，分别服务三类报表 |
| 结转关账 | `fms_closing_period`、`fms_closing`、`fms_closing_template`、`fms_closing_voucher` | 期间、结转规则/方案和所生成凭证的映射分开保存 |

参见 [FMS ER 图](/Users/chenwen/workspace2/yudao-cloud/docs/er/fms-er.drawio) 与 [FMS 推断 DDL](/Users/chenwen/workspace2/yudao-cloud/sql/mysql/fms.sql)。ER 关系来自实体和代码字段，不宣称 MySQL 中已建物理外键。

## 4. 主要端到端流程

### 流程 A：新账套到试算平衡

1. 所有者创建账套，系统创建其成员关系；账套用户表可维护成员和默认账套。
2. 执行初始化时，服务写入标准科目、基础币别、财务参数、凭证字、结转模板和指标等预置数据。
3. 会计补充科目、辅助类别/项目、摘要和模板，并在期初余额中录入末级科目及必要辅助组合。
4. 保存期初余额前校验账套写权限、可编辑状态、科目层级和辅助核算；父级余额不要求单独作为独立业务事实。
5. 通过试算平衡比较期初与本年借贷差额，差额为零只是该服务的平衡判断，不自动代表所有账务配置正确。

入口见 [账套初始化](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/config/FmsAccountSetServiceImpl.java:134) 和 [试算平衡](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/config/FmsInitialBalanceServiceImpl.java:178)。

### 流程 B：录入、审核与查询凭证

1. 会计选择开放期间、凭证字和分录；分录引用科目，可携带数量、币种和辅助组合。
2. 创建/更新服务校验权限、期间和分录规则，保存凭证头和分录；附件更新是独立入口。
3. 审核人员通过审核状态入口处理凭证；作废、删除、撤回等也不是普通编辑操作。
4. 账簿服务按条件查询分录、期初、科目和辅助维度，形成明细账、总账、余额表及数量/辅助账。
5. 报表服务再用科目公式、行次公式或现金流规则输出表项；并不会反写凭证。

参考 [凭证服务](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/voucher/FmsVoucherServiceImpl.java:123) 与 [报表公式解析](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsReportCommonServiceImpl.java:288)。

### 流程 C：月末结转与关账

1. 用户查询当月概览，系统读取该期间的凭证、结转与状态信息。
2. 先按损益结转设置或结转方案生成一张或多张凭证，并写结转凭证关联记录。
3. 关账服务根据期间条件、结转情况及已实现校验决定是否可关闭；关闭后，期间开放校验会阻止相关业务时间继续写入。
4. 如需反关账，走单独取消入口并恢复关联状态；它不是删除期间历史。
5. 下月凭证、账簿和报表读取需以实际开放期间和账套权限为前提。

期间开放校验见 [FmsClosingPeriodServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/closing/FmsClosingPeriodServiceImpl.java:90)。

### 流程 D：报表公式维护与核对

1. 会计选择账套、期间和报表类型，读取预置或已保存的报表行与公式。
2. 更新资产负债表、利润表或现金流量表公式时，服务验证该行是否允许编辑、账套归属和公式引用是否合法。
3. 报表查询按公式解析科目/行次/参数，生成行项目；现金流还可维护调整数据和调整公式。
4. 调用检查接口取得勾稽或数据完整性结果，并可导出 Excel；检查结果仍需要结合会计制度与原始凭证复核。

参考 [利润表服务](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsIncomeStatementServiceImpl.java:88)。

## 5. 关键状态、金额与台账规则

| 维度 | 已核对的规则 |
| --- | --- |
| 权限 | 读、写、所有者校验均以账套和用户为输入；同一系统用户可加入不同账套 |
| 期间 | 写凭证/余额前需要期间开放；关账后由期间服务阻断相关写路径 |
| 凭证 | 凭证头—分录是一对多；审核、整理编号、移动和附件更新是独立业务动作 |
| 平衡 | 期初试算分别计算期初借贷和本年借贷差额，两个差额都为零时返回平衡 |
| 报表 | 报表是公式/配置加账簿数据的查询结果；配置修改不等于修改原始凭证或余额 |
| 结转 | 结转生成凭证并记录映射，关账与反关账围绕期间执行，不应删除历史凭证替代反关账 |

## 6. 跨模块协作

- **SYSTEM**：账套成员使用系统用户 id，Controller 通过当前登录用户取得身份；未发现将 SYSTEM 部门、用户自动映射为 FMS 辅助项目的普遍写入逻辑。
- **INFRA**：Excel 导入导出、附件 URL 等使用通用基础设施；附件字段存在并不表示 FMS 自建文件存储。
- **ERP/CRM/PAY**：静态扫描未发现 FMS 自动消费其交易并生成凭证。跨模块对账、自动凭证、银行流水或税务申报不应被文档虚构为已交付能力。

## 7. 典型使用场景

1. 新公司建账：先建立账套和权限，初始化预置资料，再按科目和辅助核算录期初并做试算平衡。
2. 日常记账：会计录入或导入凭证，审核后从总账/明细账按科目、期间和辅助维度查看发生额与余额。
3. 月结：生成损益或方案结转凭证，确认期间条件后关账；若调整需按反关账流程处理而不是直接删已关闭期间的数据。
4. 管理报表：维护报表公式，读取三大报表并执行检查；现金流调整用于处理不能仅靠科目直接归集的口径。

## 8. 当前限制与待验证事项

- 报表、账簿和结账是高业务风险路径，本文没有以真实多币种、数量核算、辅助组合、跨年期间或并发审核数据运行验证。
- 各种 `return null/false` 需按方法语义看待，不能一概归类为未实现；例如 [FmsCashFlowParamTypeEnum.of](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/enums/report/FmsCashFlowParamTypeEnum.java:35) 对无法识别的现金流参数前缀返回 `null`。正式启用应针对公式前缀、解析错误和导入回滚做异常输入测试。
- 推断 DDL 不等同生产迁移；辅助组合 JSON/集合字段、唯一约束、物理外键、金额精度和索引要与真实数据库复核。
- 未发现自动凭证、外部银行对账、税务申报、合并报表或 ERP/PAY 实时同步的代码证据；如存在这些能力，需要另行确认集成模块或任务配置。

## 9. Controller 接口域覆盖与源码阅读入口

建议阅读顺序：账套初始化 → 科目/辅助/期初 → 凭证状态与分录校验 → 账簿 Mapper → 报表公式 → 结转关账。下面覆盖全部 23 个管理端 Controller，Portal/前端是否展示不影响后端域划分。

| Controller 包（相对 `controller/admin`） | 控制器数 | 覆盖入口 |
| --- | ---: | --- |
| [config](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/config) | 13 | 账套、成员、科目、币别、摘要、凭证字、模板、辅助核算、参数、期初余额与指标 |
| [voucher](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/voucher) | 1 | 凭证创建、编辑、审核、作废/删除、附件、编号整理、移动、导入导出和统计 |
| [ledger](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/ledger) | 1 | 明细账、总账、余额表、多栏账、辅助账、数量账及导出 |
| [report](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/report) | 3 | 资产负债表、利润表、现金流量表、公式/调整、校验和导出 |
| [closing](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/closing) | 4 | 期间概览、关账/反关账、结转模板/方案、损益/方案/批量结转凭证 |
| [home](/Users/chenwen/workspace2/yudao-cloud/yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/home) | 1 | 账套首页指标与指标明细 |

覆盖合计：23 个 Controller、30 张持久表。Controller 接口的实际授权、数据初始化和报表展示需要在可运行环境进一步核验。
