# 分模块 ER 图

基于本次 `sql/mysql` 下的 18 个模块 DDL 和当前后端代码生成：**499 张表、7561 个字段、1254 条逻辑关系、125 页**。
样式参考 [ruoyi-vue-pro-er.drawio](ruoyi-vue-pro-er.drawio)：彩色业务分区、深色表头、交替字段行、字段/类型/注释三列、PK 标记及灰色跨域引用卡片。所有结构均为可编辑的 draw.io 原生形状。

## 文件清单

| 模块 | draw.io 文件 | 表 | 字段 | 关系 | 页 | 全量预览 |
|---|---|---:|---:|---:|---:|---|
| AI应用 | [ai-er.drawio](ai-er.drawio) | 14 | 219 | 25 | 5 | [PNG](previews/ai-er.png) |
| 工作流程 | [bpm-er.drawio](bpm-er.drawio) | 8 | 118 | 9 | 4 | [PNG](previews/bpm-er.png) |
| CRM 客户关系管理 | [crm-er.drawio](crm-er.drawio) | 21 | 313 | 56 | 7 | [PNG](previews/crm-er.png) |
| ERP 进销存管理 | [erp-er.drawio](erp-er.drawio) | 33 | 541 | 99 | 8 | [PNG](previews/erp-er.png) |
| FMS 财务核算管理 | [fms-er.drawio](fms-er.drawio) | 30 | 456 | 62 | 8 | [PNG](previews/fms-er.png) |
| HRM 人力资源管理 | [hrm-er.drawio](hrm-er.drawio) | 50 | 795 | 85 | 9 | [PNG](previews/hrm-er.png) |
| 即时通讯 | [im-er.drawio](im-er.drawio) | 17 | 231 | 37 | 5 | [PNG](previews/im-er.png) |
| Infra 基础设施 | [infra-er.drawio](infra-er.drawio) | 14 | 200 | 19 | 6 | [PNG](previews/infra-er.png) |
| 物联网 | [iot-er.drawio](iot-er.drawio) | 15 | 221 | 26 | 5 | [PNG](previews/iot-er.png) |
| 商城交易 | [mall-er.drawio](mall-er.drawio) | 49 | 812 | 115 | 9 | [PNG](previews/mall-er.png) |
| Member 会员中心 | [member-er.drawio](member-er.drawio) | 11 | 138 | 17 | 6 | [PNG](previews/member-er.png) |
| MES 制造执行 | [mes-er.drawio](mes-er.drawio) | 133 | 2044 | 484 | 20 | [PNG](previews/mes-er.png) |
| MP 微信公众号 | [mp-er.drawio](mp-er.drawio) | 8 | 159 | 11 | 4 | [PNG](previews/mp-er.png) |
| Pay 支付平台 | [pay-er.drawio](pay-er.drawio) | 14 | 242 | 40 | 7 | [PNG](previews/pay-er.png) |
| 项目与知识管理 | [pms-er.drawio](pms-er.drawio) | 33 | 385 | 80 | 6 | [PNG](previews/pms-er.png) |
| 报表大屏 | [report-er.drawio](report-er.drawio) | 1 | 11 | 0 | 1 | [PNG](previews/report-er.png) |
| System 系统管理 | [system-er.drawio](system-er.drawio) | 32 | 462 | 56 | 10 | [PNG](previews/system-er.png) |
| WMS 仓储管理 | [wms-er.drawio](wms-er.drawio) | 16 | 214 | 33 | 5 | [PNG](previews/wms-er.png) |

## 阅读方式

- 每个文件第一页为模块全量图，同业务领域的表集中摆放；后续页面按领域展开，单页最多 12 张完整表。Report 单表模块仅一页。
- 表名、字段名、类型保持单行；只有注释换行，所有字段、完整注释和类型均与相应 DDL 一致。
- 全量图的跨领域/跨模块关系与租户关系放在默认隐藏图层，避免全图线网遮挡；在 draw.io 图层面板可开启。隐藏层启用后连线路径可以编辑，详情页已对可见连线做避障。
- 详情页灰色表卡片仅呈现关联目标键，不代表该目标表只有这些字段；完整定义见对应领域或模块文件。
- 蓝色实线为有源码依据的逻辑引用；紫色虚线为编号集合、JSON 内引用、按业务类型分流的条件关系；橙色点线为已有代码线索支持但尚未完全证明的推断关系。
- 乌鸦脚表达应用层最大基数，不表示 DDL 已建立物理外键、非空、唯一性或记录存在性约束。
- `module-data/<模块>.json` 保存领域分组、逐条关系的字段端点、业务条件以及源码路径/行号/原文。关系的主证据和补充证据均已核对存在。
- PNG 只是全量缩略预览；499 张表的细节请打开对应 draw.io 后放大或切换领域页面。

## 范围和验证

- 图的字段结构严格以对应模块 DDL 为准；DDL 中原本由实体推断的长度、精度及物理类型仍然属于推断，见 [DDL 推断说明](../../sql/mysql/README-inferred-ddl.md)。
- 所有 499 张表和 7561 个字段已独立从 SQL 解析后与图逐项比对名称、顺序、类型和完整注释；每张表在全量页和所属领域详情页完整出现（单表模块例外）。
- 已检查 XML 唯一标识、父子层级、字段级关系端点、表格不重叠以及可见连线不穿表。
- 使用浏览器实际字体测量 23293 项文本，横向溢出为 0。
- 使用 draw.io Desktop 实际导出 18 张全量预览，以及 ERP/CRM/MES/HRM/Mall/AI/Pay 共 7 张领域详情样本；对样本进行视觉检查。
- 未执行数据库建表、查询数据库或验证运行时数据，源码关系不等于实际生产库约束。

详细统计和 SHA-256 见 [modules-verification.json](modules-verification.json)。

## 各模块的关联边界

### AI应用

领域：模型与工具、对话与角色、知识库检索、创作与工作流。

[图文件](ai-er.drawio) · [DDL](../../sql/mysql/ai.sql) · [逐条关系依据](module-data/ai.json)

- 表结构以 sql/mysql/ai.sql 为准；图中关系来自当前业务代码，均为逻辑关联，不表示数据库已建立物理外键。
- 灰色锚点引用其他模块已有表；集合字段连线表示集合元素与目标键关联。
- mcp_client_names 引用 spring.ai.mcp.client 配置，vector_id 引用外部向量存储，生成任务 task_id 引用模型服务任务；这些目标不是本次SQL中的表，不建立虚构外键。

### 工作流程

领域：流程定义与表单、设计器与用户组、流程业务与抄送。

[图文件](bpm-er.drawio) · [DDL](../../sql/mysql/bpm.sql) · [逐条关系依据](module-data/bpm.json)

- 表结构以 sql/mysql/bpm.sql 为准；图中关系来自当前业务代码，均为逻辑关联，不表示数据库已建立物理外键。
- 灰色锚点引用其他模块已有表；集合字段连线表示集合元素与目标键关联。
- Flowable 的流程定义、模型、实例、历史任务及ACT_*引擎表未包含在本模块SQL中；process_definition_id、model_id、process_instance_id、task_id保持原字段，不伪造目标表。
- 流程分类以 category → bpm_category.code 建立业务关联，而非默认关联 id。

### CRM 客户关系管理

领域：线索与客户、联系人、商机与阶段、产品目录、合同与回款、协作权限与业绩。

[图文件](crm-er.drawio) · [DDL](../../sql/mysql/crm.sql) · [逐条关系依据](module-data/crm.json)

- 结构以 sql/mysql/crm.sql 为准；图中连线表示源码支持的逻辑引用，DDL 未声明物理外键。
- biz_id 多态引用按 CrmBizTypeEnum 展示；跟进记录仅绘制 Service 明确处理的线索、客户、联系人、商机、合同；负责人变更仅绘制目前写入的客户分支。
- process_instance_id 指向 Flowable 运行时流程实例，499 张模块 DDL 中没有对应引擎表，本图不误连 BPM 扩展表。
- area_id 为内存地区库 Area 标识；行业与跟进类型为字典值；不当作模块物理表外键。
- crm_business_status_type.dept_ids 仅有使用部门编号注释，未查到当前业务读取或验证，不建立确定引用。

### ERP 进销存管理

领域：基础资料、采购流程、销售流程、其他出入库、盘点与调拨、库存台账、收付款。

[图文件](erp-er.drawio) · [DDL](../../sql/mysql/erp.sql) · [逐条关系依据](module-data/erp.json)

- 结构以 sql/mysql/erp.sql 为准；图中连线表示源码支持的逻辑引用，DDL 未声明物理外键。
- 收付款项 biz_id 仅按 Service 接受的采购入库/退货、销售出库/退货分支连接；库存流水 biz_id 与 biz_item_id 按库存事件枚举分开连接。
- erp_sale_out_items.out_id 的 DO 注释误写 ErpStockOutDO；以 ErpSaleOutServiceImpl 的 setOutId(saleOut.getId()) 为准指向 erp_sale_out。
- product_unit_id 是从产品复制的单位编号；按来源 unit_id 连至单位表并标注冗余，不误连产品主键。
- 订单号、业务单号、名称、价格等快照/冗余值不作为外键关系；库存表的产品+仓库维度不伪装成单列外键。

### FMS 财务核算管理

领域：账套与基础设置、会计科目与期初、辅助核算、凭证模板、凭证记账、期末结账、财务报表。

[图文件](fms-er.drawio) · [DDL](../../sql/mysql/fms.sql) · [逐条关系依据](module-data/fms.json)

- 结构以 sql/mysql/fms.sql 为准；图中连线表示源码支持的逻辑引用，DDL 未声明物理外键。
- subject_rules、items、assist_balances、entries、auxiliaries 为 JSON 嵌套结构；集合连线锚定物理 JSON 列，在注释说明内部 ID 路径。
- 财务报表按账套和会计期间保存配置快照，不把 row_id、公式、科目名称/编码快照自动连接为主键外键。
- 科目辅助类别与币种数组使用集合引用；账套是财务边界，不因同名 account_set_id 以外字段建立推测关系。

### HRM 人力资源管理

领域：员工档案、考勤管理、社会保险、绩效配置、绩效考核、招聘管理、薪酬管理、工资条发放。

[图文件](hrm-er.drawio) · [DDL](../../sql/mysql/hrm.sql) · [逐条关系依据](module-data/hrm.json)

- 结构以 sql/mysql/hrm.sql 为准；图中连线表示源码支持的逻辑引用，DDL 未声明物理外键。
- 员工档案 employee_id 与后台账号 user_id 属于不同身份，员工可无登录账号；部门/用户跨模块引用以灰色外部卡片展示。
- 部门、员工、面试官数组及绩效计划 JSON 中的员工/部门配置为集合引用，按物理列锚定并说明内部路径。
- 薪资项 parent_code 与 JSON code 引用薪资项业务编码；历史薪资与工资条保存快照，不假定数据库强制约束或快照随目录更新。
- 考勤请假的 process_instance_id 为 Flowable 运行时标识，地区编号为内存 Area 标识；本模块 DDL 没有对应目标表，不建立虚假外键。

### 即时通讯

领域：频道运营、私聊与好友、群组与群聊、通话与素材。

[图文件](im-er.drawio) · [DDL](../../sql/mysql/im.sql) · [逐条关系依据](module-data/im.json)

- 表结构以 sql/mysql/im.sql 为准；图中关系来自当前业务代码，均为逻辑关联，不表示数据库已建立物理外键。
- 灰色锚点引用其他模块已有表；集合字段连线表示集合元素与目标键关联。

### Infra 基础设施

领域：数据源与代码生成、文件存储、API 日志、参数配置、开发示例。

[图文件](infra-er.drawio) · [DDL](../../sql/mysql/infra.sql) · [逐条关系依据](module-data/infra.json)

- 表结构以 sql/mysql/infra.sql 为准，字段类型包含源码推断；所有连线均为代码支持的逻辑关联。
- 仅按本次 infra.sql 的14张实体表绘制；旧总SQL中的 infra_job / infra_job_log 无当前实体，未纳入。
- 数据库文件内容通过(config_id,path)寻址且可重复，DBFileClient读取最新内容，不宣称固定1:1。
- creator/updater、trace_id与原始请求参数等不由名称推测为外键。
- 代码生成的数据源编号0表示运行时 master 数据源；仅非0编号指向 infra_data_source_config 的实体行。

### 物联网

领域：产品与物模型、设备与Modbus、OTA固件升级、场景告警与流转。

[图文件](iot-er.drawio) · [DDL](../../sql/mysql/iot.sql) · [逐条关系依据](module-data/iot.json)

- 表结构以 sql/mysql/iot.sql 为准；图中关系来自当前业务代码，均为逻辑关联，不表示数据库已建立物理外键。
- 灰色锚点引用其他模块已有表；集合字段连线表示集合元素与目标键关联。
- 设备消息、属性时序数据等TDengine存储未包含在本次SQL中；不构造时序表实体或外键。
- group_ids、sink_ids、scene_rule_ids、receive_user_ids为集合逻辑关联。

### 商城交易

领域：商品目录与规格、商品互动与统计、优惠券与折扣、拼团与砍价、秒杀与积分商城、内容装修与客服、交易与售后、配送与分销。

[图文件](mall-er.drawio) · [DDL](../../sql/mysql/mall.sql) · [逐条关系依据](module-data/mall.json)

- 表结构以 sql/mysql/mall.sql 为准；图中关系来自当前业务代码，均为逻辑关联，不表示数据库已建立物理外键。
- 灰色锚点引用其他模块已有表；集合字段连线表示集合元素与目标键关联。

### Member 会员中心

领域：会员档案与分组、会员等级、积分与规则、签到、收货地址。

[图文件](member-er.drawio) · [DDL](../../sql/mysql/member.sql) · [逐条关系依据](module-data/member.json)

- 表结构以 sql/mysql/member.sql 为准，字段类型包含源码推断；所有连线均为代码支持的逻辑关联。
- area_id指向内存地区库Area，不存在本次DDL的地区表，不伪造关系。
- 积分/经验流水 biz_id 按已确认业务分支引用签到记录、管理员、交易订单或订单项；字符串值不代表数据库物理外键。经验 ADMIN(0) 分支写常量0，不连接管理员；邀请/抽奖未确认写入目标，不推断关系。

### MES 制造执行

领域：编码规则、物料与往来单位、车间与工作站、工序与工艺路线、生产工单与报工、安灯与上下工、排班管理、设备与维保、工装夹具、质检方案与结果、检验执行、仓库库存与追溯、采购入库与退供、外协物流、生产领退料与消耗、生产产出与收货、销售出退库与装箱、杂项收发与调拨、库存盘点。

[图文件](mes-er.drawio) · [DDL](../../sql/mysql/mes.sql) · [逐条关系依据](module-data/mes.json)

- 所有关系均为源码逻辑关联；本模块 DDL 没有物理外键。普通 ID、条件 ID、多态 ID 已分别标注，集合字段 mes_qc_template.types 是检测类型 CSV，不属于实体 ID 集合。
- 未确认的来源引用不连线：mes_dv_repair.source_doc_id；mes_pro_task_issue.source_doc_id/source_line_id；mes_wm_misc_issue.source_doc_id 及 line.source_doc_line_id；mes_wm_misc_receipt.source_doc_id。代码未提供可确认的 discriminator→目标表业务分支。
- 未确认或尚未实现的引用不连线：mes_wm_batch.mold_id 没有对应模具表；mes_pro_card_process.ipqc_id Javadoc 标注后续对接；mes_wm_return_sales_line.rqc_id 在完成回写分支没有赋值确认。
- 未由直接注释或有效查询/写入路径确认的遗留库存/批次字段不按同名猜测：mes_wm_package_line.material_stock_id、mes_wm_misc_issue_line.material_stock_id、mes_wm_outsource_issue_line.material_stock_id、mes_wm_stock_taking_task_result.material_stock_id/batch_id、mes_wm_misc_issue_detail.batch_id、mes_wm_transfer_detail.batch_id、mes_wm_product_issue_line.batch_id。
- 条码多态仅纳入实际 autoGenerateBarcode 调用确认的 15 类对象；枚举中的 STOCK/TRANSORDER/USER 未发现对应调用，未构造目标。盘点 type=900 为质量状态值，不是外键。
- MES 与 WMS 独立建模，未按物料/仓库同名字段跨模块连线；本组实体均继承 BaseDO，DDL 无 tenant_id，未添加租户字段。

### MP 微信公众号

领域：公众号与菜单、粉丝与标签、消息与素材。

[图文件](mp-er.drawio) · [DDL](../../sql/mysql/mp.sql) · [逐条关系依据](module-data/mp.json)

- 表结构以 sql/mysql/mp.sql 为准，字段类型包含源码推断；所有连线均为代码支持的逻辑关联。
- 粉丝tag_ids元素关联mp_tag.tag_id且受account_id范围约束；不是mp_tag.id。
- media_id/template_id等微信平台编号不自动关联本地数据库主键。
- mp_tag.id保留DDL非自增INPUT策略，其应用赋值矛盾见DDL推断说明。

### Pay 支付平台

领域：应用与渠道、支付与退款、转账、异步通知、钱包与充值、支付示例。

[图文件](pay-er.drawio) · [DDL](../../sql/mysql/pay.sql) · [逐条关系依据](module-data/pay.json)

- 表结构以 sql/mysql/pay.sql 为准，字段类型包含源码推断；所有连线均为代码支持的逻辑关联。
- merchant_*为业务调用方订单号，不存在统一商户订单表；不按相似名称误连。
- 示例spu_id来自演示内置商品数据，不据名称连接商城product_spu。
- 支付通知 data_id 和钱包流水 biz_id 按业务类型分支绘制；充值退款(2)指充值记录，调整余额(5)指会员，转账(6)按实际写入指转账业务单号 no。
- 钱包转账流水存在源码读写矛盾：写入 biz_id 使用 transfer.no，WalletPayClient 成功查询却按 transfer.id 查；ER 图保留此边界，未修改支付业务代码。

### 项目与知识管理

领域：知识库与成员、知识内容与权限、知识互动与回收、项目协作、工作项与看板。

[图文件](pms-er.drawio) · [DDL](../../sql/mysql/pms.sql) · [逐条关系依据](module-data/pms.json)

- 表结构以 sql/mysql/pms.sql 为准；图中关系来自当前业务代码，均为逻辑关联，不表示数据库已建立物理外键。
- 灰色锚点引用其他模块已有表；集合字段连线表示集合元素与目标键关联。

### 报表大屏

领域：大屏项目。

[图文件](report-er.drawio) · [DDL](../../sql/mysql/report.sql) · [逐条关系依据](module-data/report.json)

- 本模块SQL只有 report_go_view_project 一张表。当前DO未声明关联其他表的业务键，关系数为0；不由creator/updater审计字段推测用户外键。

### System 系统管理

领域：组织与权限、租户与套餐、OAuth2 授权、第三方登录、短信服务、邮件服务、站内信与公告、字典管理、登录与操作日志。

[图文件](system-er.drawio) · [DDL](../../sql/mysql/system.sql) · [逐条关系依据](module-data/system.json)

- 表结构以 sql/mysql/system.sql 为准，字段类型包含源码推断；所有连线均为代码支持的逻辑关联。
- OAuth2 client_id关联客户端业务编号client_id，不关联数值主键id。
- user_type=1/2分别指向会员/管理员；根部门/菜单、系统租户套餐使用特殊哨兵值。
- 按新的system.sql列集合绘制；原总SQL多出的tenant_id、操作日志success不自动补回。

### WMS 仓储管理

领域：商品与往来单位、仓库与库存、入库与出库、移库与盘点。

[图文件](wms-er.drawio) · [DDL](../../sql/mysql/wms.sql) · [逐条关系依据](module-data/wms.json)

- WMS 实体明确 @link 的普通 ID 关系与 inventory_history.order_id 的四类 order_type 条件来源已核对；DDL 无物理外键。
- 本模块实体均继承 BaseDO，DDL 无 tenant_id；商品、SKU、仓库均使用 WMS 模块自身模型，未凭同名与 MES/Mall 交叉关联。
