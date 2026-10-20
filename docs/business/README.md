# 业务知识文档索引

本文档集按当前工作区的 18 个模块拆分，服务于代码阅读、交接和业务梳理。每篇均以 Controller、Service、实体、枚举、Mapper 与模块 API 的静态分析为依据；没有启动服务、执行 SQL 或调用外部平台，因此文中的流程是“代码可见实现”，不是生产运行结论。

|模块|后端服务|业务知识|ER 图|DDL|
|---|---|---|---|
|AI 应用|`yudao-module-ai-server`|[ai.md](ai.md)|[AI ER 图](../er/ai-er.drawio)|[ai.sql](../../sql/mysql/ai.sql)|
|工作流程|`yudao-module-bpm-server`|[bpm.md](bpm.md)|[BPM ER 图](../er/bpm-er.drawio)|[bpm.sql](../../sql/mysql/bpm.sql)|
|客户关系管理|`yudao-module-crm-server`|[crm.md](crm.md)|[CRM ER 图](../er/crm-er.drawio)|[crm.sql](../../sql/mysql/crm.sql)|
|进销存管理|`yudao-module-erp-server`|[erp.md](erp.md)|[ERP ER 图](../er/erp-er.drawio)|[erp.sql](../../sql/mysql/erp.sql)|
|财务核算管理|`yudao-module-fms-server`|[fms.md](fms.md)|[FMS ER 图](../er/fms-er.drawio)|[fms.sql](../../sql/mysql/fms.sql)|
|人力资源管理|`yudao-module-hrm-server`|[hrm.md](hrm.md)|[HRM ER 图](../er/hrm-er.drawio)|[hrm.sql](../../sql/mysql/hrm.sql)|
|即时通讯|`yudao-module-im-server`|[im.md](im.md)|[IM ER 图](../er/im-er.drawio)|[im.sql](../../sql/mysql/im.sql)|
|基础设施|`yudao-module-infra-server`|[infra.md](infra.md)|[Infra ER 图](../er/infra-er.drawio)|[infra.sql](../../sql/mysql/infra.sql)|
|物联网|`yudao-module-iot-server / iot-gateway`|[iot.md](iot.md)|[IoT ER 图](../er/iot-er.drawio)|[iot.sql](../../sql/mysql/iot.sql)|
|商城交易|`product / promotion / trade / statistics server`|[mall.md](mall.md)|[Mall ER 图](../er/mall-er.drawio)|[mall.sql](../../sql/mysql/mall.sql)|
|会员中心|`yudao-module-member-server`|[member.md](member.md)|[Member ER 图](../er/member-er.drawio)|[member.sql](../../sql/mysql/member.sql)|
|制造执行|`yudao-module-mes-server`|[mes.md](mes.md)|[MES ER 图](../er/mes-er.drawio)|[mes.sql](../../sql/mysql/mes.sql)|
|微信公众号|`yudao-module-mp-server`|[mp.md](mp.md)|[MP ER 图](../er/mp-er.drawio)|[mp.sql](../../sql/mysql/mp.sql)|
|支付平台|`yudao-module-pay-server`|[pay.md](pay.md)|[Pay ER 图](../er/pay-er.drawio)|[pay.sql](../../sql/mysql/pay.sql)|
|项目与知识管理|`yudao-module-pms-server`|[pms.md](pms.md)|[PMS ER 图](../er/pms-er.drawio)|[pms.sql](../../sql/mysql/pms.sql)|
|报表大屏|`yudao-module-report-server`|[report.md](report.md)|[Report ER 图](../er/report-er.drawio)|[report.sql](../../sql/mysql/report.sql)|
|系统管理|`yudao-module-system-server`|[system.md](system.md)|[System ER 图](../er/system-er.drawio)|[system.sql](../../sql/mysql/system.sql)|
|仓储管理|`yudao-module-wms-server`|[wms.md](wms.md)|[WMS ER 图](../er/wms-er.drawio)|[wms.sql](../../sql/mysql/wms.sql)|

## 阅读约定

- 先阅读模块文档的定位、边界和主要流程，再打开对应 ER 图的领域详情页核对数据对象。
- 文档中的表名是帮助定位代码的业务对象，不代表数据库已经声明物理外键；关系仍以 [ER 图索引](../er/modules-index.md) 中的源码证据为准。
- `sql/mysql/*.sql` 是此前依据实体反推的 MySQL 8 结构草案。长度、精度、默认值、索引和部分物理类型并非官方初始化脚本，详见 [DDL 推断说明](../../sql/mysql/README-inferred-ddl.md)。
- 遇到“未实现”“TODO”“外部平台”或“未验证”章节时，应回到链接的源码确认，不应把接口或枚举名称当成已完成的产品承诺。
