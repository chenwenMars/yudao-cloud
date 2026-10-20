# 按实体反推的 MySQL 8 DDL

覆盖截图中的 18 个模块：499 张 MyBatis Plus 实体表、7561 个持久化字段（含继承字段）。
这些脚本由当前代码反推，类型不确定处按业务语义推断并在 SQL 注释中列出依据。它们是结构草案，不是官方初始化脚本，也不包含初始化 DML。

## 文件清单

| 模块 | 文件 | 表数 | 字段数 |
|---|---|---:|---:|
| ai | [ai.sql](ai.sql) | 14 | 219 |
| bpm | [bpm.sql](bpm.sql) | 8 | 118 |
| crm | [crm.sql](crm.sql) | 21 | 313 |
| erp | [erp.sql](erp.sql) | 33 | 541 |
| fms | [fms.sql](fms.sql) | 30 | 456 |
| hrm | [hrm.sql](hrm.sql) | 50 | 795 |
| im | [im.sql](im.sql) | 17 | 231 |
| infra | [infra.sql](infra.sql) | 14 | 200 |
| iot | [iot.sql](iot.sql) | 15 | 221 |
| mall | [mall.sql](mall.sql) | 49 | 812 |
| member | [member.sql](member.sql) | 11 | 138 |
| mes | [mes.sql](mes.sql) | 133 | 2044 |
| mp | [mp.sql](mp.sql) | 8 | 159 |
| pay | [pay.sql](pay.sql) | 14 | 242 |
| pms | [pms.sql](pms.sql) | 33 | 385 |
| report | [report.sql](report.sql) | 1 | 11 |
| system | [system.sql](system.sql) | 32 | 462 |
| wms | [wms.sql](wms.sql) | 16 | 214 |

合计：**18 个 SQL 文件、499 张表、7561 个字段**。

## 提取范围

- 枚举各 `*-server/src/main/java/**/dal/dataobject` 目录中的顶层 `@TableName` 实体；表名保留注解中的原名。
- 商城 `mall.sql` 合并 product、promotion、statistics、trade 四个 server 的实体表。
- 包含 `BaseDO` 的五个审计字段；只有继承 `TenantBaseDO` 的实体才增加 `tenant_id`。
- 排除 static/transient、`@TableField(exist=false)`、内嵌对象成员和没有 `@TableName` 的 DTO。嵌套对象按实际处理器映射到一列。
- BPM 仅含应用扩展表，不包含 Flowable 的 `ACT_*` 引擎表。IoT 的 TDengine 消息及 Redis 属性对象不生成 MySQL 表。
- 保留源码 Javadoc，缺失注释会注明推断；未修正源码中尚未确认的单位描述。

## 类型与约束的选择

| 来源 / Java 类型 | 生成规则 |
|---|---|
| 现有 `ruoyi-vue-pro.sql` 的同表同列 | 复用该列的类型、容量、默认值、非空和注释；不声称其他模块的原始DDL已还原 |
| Long / Integer / Boolean | BIGINT / INT / BIT(1)，状态字段没有擅自统一缩成 TINYINT |
| LocalDateTime / LocalDate / LocalTime | DATETIME / DATE / TIME |
| BigDecimal | 通常 DECIMAL(24,6)，少量结合明确 `@Digits` 的字段单独选择，依据写在脚本中 |
| 普通字符串 / URL / 长文本 | 通常 VARCHAR(255) / VARCHAR(1024) / TEXT，正文或文档等按业务扩为 LONGTEXT |
| Jackson 和自定义 JSON 类型处理器 | JSON；物理存储选择为推断 |
| LongList / IntegerList / StringList / LongSet 逗号处理器 | TEXT 或有业务依据的 VARCHAR，保留 CSV 存储语义 |

- 新推导的业务列暂允许 NULL，没有添加业务默认值；它们的 NOT NULL、长度、精度及完整业务约束仍需结合实际数据库设计确认。
- 审计列的默认时间、逻辑删除初值沿用现有 SQL；未显式指定主键策略时按项目 MySQL AUTO 策略自增，显式策略优先。
- 每张表仅生成主键索引；普通查询索引、业务唯一约束、外键需要另行设计。当前脚本不用于衡量查询性能或并发一致性。
- 部分服务依赖原库中的计数、状态等默认值；本次没有足够证据还原这些定义，因此尚未验证应用在这些结构上的完整业务运行。

## 与现有 SQL 的关系

这些文件用 `CREATE TABLE` 创建表，不包含 DROP、IF NOT EXISTS、关闭约束、USE 或自动执行。选定目标数据库后，按需审核和执行对应模块文件；同名表已存在会直接报错。
原 `ruoyi-vue-pro.sql` 与 `system.sql` / `infra.sql` 有重复表，不能在已导入原脚本的库中把所有文件直接批量重复导入。
本次严格按当前实体及公共基类提取列集合。现有 SQL 中存在、实体却没有映射的列如下，没有自动补入：

| 表 | 原SQL存在但当前实体未映射的字段 |
|---|---|
| `infra_api_access_log` | `tenant_id` |
| `infra_api_error_log` | `tenant_id` |
| `system_login_log` | `tenant_id` |
| `system_notice` | `tenant_id` |
| `system_notify_message` | `tenant_id` |
| `system_oauth2_approve` | `tenant_id` |
| `system_oauth2_code` | `tenant_id` |
| `system_operate_log` | `success`, `tenant_id` |
| `system_post` | `tenant_id` |
| `system_sms_code` | `tenant_id` |
| `system_social_user` | `tenant_id` |
| `system_social_user_bind` | `tenant_id` |
| `system_user_post` | `tenant_id` |
| `system_user_role` | `tenant_id` |
| `yudao_demo01_contact` | `tenant_id` |
| `yudao_demo02_category` | `tenant_id` |
| `yudao_demo03_course` | `tenant_id` |
| `yudao_demo03_grade` | `tenant_id` |
| `yudao_demo03_student` | `tenant_id` |

原 SQL 的 `infra_job`、`infra_job_log` 在当前后端没有对应实体，因此仍仅保留在原 SQL，没有加入本次实体反推文件。

## 明确发现的映射差异

- `mp_tag.id` 的实体明确指定 `@TableId(type = IdType.INPUT)`，因此 `mp.sql` 保留非自增主键，由应用提供编号。当前 `MpTagConvert.convert(WxUserTag,MpAccountDO)` 又忽略 id，`MpTagServiceImpl` 随后直接插入；这个代码侧策略矛盾需要另行核对，本次没有用自增列替代显式 INPUT 注解。
- `infra_file.size` 和 `infra_api_error_log.process_user_id` 的 Java 类型均为 Long，原 SQL 却是 INT。本次保留原 SQL 的物理类型，同时明确它们只能存有符号32位整数；`process_user_id` 所引用的 `system_users.id` 是 BIGINT，后续应结合实际库决定是否扩为 BIGINT。

## 已执行的核验

- 使用标准 Java 编译器语法树独立枚举实体，逐表比对表名、直接字段、Java 类型及公共继承字段，499 张表全部一致。
- 使用 SQLGlot 的 MySQL 方言严格解析全部 18 个脚本，校验了 499 条 CREATE TABLE、7561 个字段；没有多余 SQL 语句、重复表或重复列。
- 检查持久化排除、JSON/CSV 处理器、主键、表/列注释、标识符长度及保守行宽估算。
- 子代理分组独立复核 MES/WMS、CRM/ERP/FMS/HRM、AI/BPM/IM/IoT/Mall/PMS/Report 的字段覆盖与特殊类型。
- 没有连接数据库、执行 DDL、导入数据或启动业务服务；MySQL 引擎兼容性与业务运行尚未实测。


