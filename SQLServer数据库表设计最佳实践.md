# SQL Server 数据库表设计最佳实践

> 适用范围：SQL Server 2016 及以上版本（含 Azure SQL Database）
> 目标：保证数据结构的可维护性、性能、一致性与可扩展性

---

## 一、命名规范

### 1.1 表名

- 使用**单数名词**，如 `Employee`、`OrderDetail`，避免 `Employees` 这类复数形式（团队统一一种风格即可，关键是全库一致）。
- 禁止使用 SQL Server 保留关键字（如 `Order`、`User`、`Key`），如必须使用请改名或用架构名限定。
- 业务模块前缀分组：`sys_`（系统）、`crm_`（客户）、`fin_`（财务）等；禁止用 `tbl`、`tb` 前缀。
- 中间表（多对多关系）用两端表名组合：`StudentCourse`、`OrderProduct`。
- 命名风格统一：推荐 `PascalCase` 或 `snake_case` 二选一，全库一致。

### 1.2 列名

- 语义清晰、可搜索：`CreatedAt` 优于 `CDate`；避免缩写歧义。
- 布尔语义列建议 `Is` / `Has` 前缀：`IsDeleted`、`HasChildren`。
- 外键列名 = 被引用表名 + `Id`：`CustomerId` 引用 `Customer.Id`。
- 避免使用空格、中文列名，避免过长的列名（建议 ≤ 30 字符）。

### 1.3 约束与索引命名（必须显式命名，不要依赖系统生成的随机名）

| 对象 | 规则 | 示例 |
| --- | --- | --- |
| 主键 | `PK_表名` | `PK_Employee` |
| 外键 | `FK_子表_父表` | `FK_Order_Customer` |
| 唯一约束 | `UQ_表名_列名` | `UQ_Employee_Email` |
| 默认约束 | `DF_表名_列名` | `DF_Order_Status` |
| 检查约束 | `CK_表名_列名` | `CK_Employee_Age` |
| 非聚集索引 | `IX_表名_列名` | `IX_Order_CreateTime` |

---

## 二、数据类型选择

### 2.1 数值类型

- 整型按需选择，不要一律 `bigint`：
  - `tinyint`（0–255，1 字节）适合状态、枚举类字段；
  - `int`（4 字节，约 21 亿）是默认首选；
  - `bigint` 仅在确实可能超过 `int` 范围（如全局流水号、分库分表 ID）时使用。
- 金额、精度敏感计算用 `decimal(p, s)`（如 `decimal(18, 2)`），**禁止用 `float` / `real` / `money`**（精度陷阱与可移植性问题）。
- 百分比等比值也推荐 `decimal(5, 4)` 之类精确类型。

### 2.2 字符串类型

- 需要存储中文等多语言字符时用 `nvarchar(n)`；纯 ASCII/编号用 `varchar(n)`。
- 预估合理长度，不要一律 `nvarchar(max)`：`varchar(max)` / `nvarchar(max)` 无法建立常规索引，且有行外存储开销。
- 定长编码（如手机 IMEI、固定位编码）用 `char` / `nchar`；变长用 `varchar`。
- **淘汰类型**：`text` / `ntext` / `image` 已废弃，改用 `varchar(max)` / `nvarchar(max)` / `varbinary(max)`。

### 2.3 日期时间类型

- 默认使用 `datetime2(0~7)`（精度高、范围大、存储更省），**不要用 `datetime`**（已过时，精度只到 3.33ms，下限 1753 年）。
- 只存日期用 `date`，只存时间用 `time`。
- 需要记录时区偏移用 `datetimeoffset`。
- 时间统一存 UTC 或统一存本地时区，全系统一种口径，写入与展示规则写入团队规范。

### 2.4 其他类型

- 布尔用 `bit`（0/1），不要用 `int` 或字符串。
- 二进制（文件、图片）优先存对象存储/文件系统，数据库只存路径；必须入库时用 `varbinary(max)`，并考虑 FILESTREAM。
- JSON 数据：SQL Server 2016+ 支持 `nvarchar(max)` + 原生 JSON 函数，必要时配合计算列 + 索引；SQL Server 2025 起有原生 `json` 类型。
- 层级数据考虑 `hierarchyid`；地理数据用 `geography` / `geometry`。

---

## 三、主键设计

1. **每张表必须有主键**，无例外。没有主键的表无法被复制、CDC、多数 ORM 正常支持。
2. 推荐方案（按优先级）：
   - `bigint IDENTITY(1,1)`：单调递增、索引碎片小、占用空间小，单机/常规业务首选。
   - `uniqueidentifier` + `NEWSEQUENTIALID()`：需要分布式生成、批量合并、避免爬虫暴露业务量级时使用；**禁止用 `NEWID()` 做聚集索引键**（完全随机导致严重页分裂）。
   - 业务自然键：仅当天然唯一且永不变更（如身份证号仍需谨慎）时考虑。
3. 主键应满足：**唯一、非空、不变、无业务含义、尽量窄**。
4. 主键与聚集索引分离考虑：主键默认创建聚集索引，但如果有更合适的聚集键（如时间范围查询为主的流水表），可让主键使用非聚集索引。

---

## 四、聚集索引选择

聚集索引决定数据的物理排序，每表只能有一个，是最影响查询性能的决策之一：

- 好的聚集索引键特征：**窄、唯一、单调递增、不常更新**。
- 常见反模式：
  - 用随机 GUID 做聚集键 → 页分裂、碎片严重；
  - 用宽字符串（如邮箱）做聚集键 → 所有非聚集索引都携带该宽键，膨胀严重；
  - 用频繁更新的列做聚集键 → 行移动、碎片化。
- 时间维度为主的日志/流水表，聚集索引可考虑 `(CreateTime, Id)` 组合，利于按时间范围扫描与归档。

---

## 五、非聚集索引设计

1. 索引是"用写放大换读性能"，**每个索引都会拖慢 INSERT/UPDATE/DELETE**，不是越多越好。
2. 依据真实查询创建：覆盖 `WHERE` / `JOIN` / `ORDER BY` 高频条件。
3. 复合索引遵循**最左前缀原则**：`(A, B, C)` 可服务 `A`、`A,B`、`A,B,C` 的查询；列顺序按**等值列在前、范围列在后**，等值列中选择性高者在前。
4. 用 `INCLUDE` 覆盖查询，避免键查找（Key Lookup）：
   ```sql
   CREATE NONCLUSTERED INDEX IX_Order_CustomerId
   ON dbo.[Order] (CustomerId)
   INCLUDE (OrderNo, Amount, Status);
   ```
5. 过滤索引（Filtered Index）适合稀疏场景，如只索引未删除数据：
   ```sql
   CREATE NONCLUSTERED INDEX IX_Order_Active
   ON dbo.[Order] (CustomerId)
   WHERE IsDeleted = 0;
   ```
6. 大表批量写入场景设置合理 `FILLFACTOR`（如 90）减少页分裂；读多写少可保持默认 0/100。
7. 定期通过 `sys.dm_db_index_usage_stats` 清理**从未被读取却频繁被写入**的索引。

---

## 六、约束设计

1. **主键、唯一约束**：保证实体完整性，必须显式定义并命名。
2. **外键约束**：
   - 核心交易、账务等强一致数据：建议建外键 + `ON DELETE NO ACTION`（默认），由应用控制删除顺序；
   - 高并发、分库分表、日志类系统：可在应用层保证一致性，省略物理外键，但必须在文档中标注逻辑外键。
   - 谨慎使用 `ON DELETE CASCADE`，多层级联删除易误删且不利于审计。
3. **CHECK 约束**：把领域规则下沉到数据库兜底，如 `CK_Employee_Age CHECK (Age BETWEEN 16 AND 70)`。
4. **DEFAULT 约束**：常用默认值显式定义，如 `DF_Order_CreateTime DEFAULT (sysdatetime())`，不要依赖应用层每次显式赋值。
5. 不要用触发器实现本可用约束表达的规则（约束更廉价、更可优化、更可靠）。

---

## 七、NULL 设计原则

- 列默认设计为 `NOT NULL`，**只有确实需要表达"未知/不适用"时才允许 NULL**。
- NULL 不参与等值比较（`NULL = NULL` 为 UNKNOWN），会让索引使用、唯一约束、JOIN 语义变复杂。
- 对允许 NULL 的列，注意唯一约束下 SQL Server 只允许一个 NULL（多 NULL 唯一需用过滤索引实现）。
- 数值列允许 NULL 时警惕聚合语义：`SUM`/`AVG` 自动忽略 NULL，可能与预期不符。

---

## 八、规范化与反规范化

1. OLTP 系统默认遵守**第三范式（3NF）**：消除部分依赖、传递依赖，避免更新异常。
2. 合理反规范化的场景（需评审并文档化）：
   - 高频 JOIN 的大宽表查询 → 冗余少量维度列；
   - 高频聚合（如订单总额、评论数）→ 冗余汇总列，由应用或触发器/作业维护一致性；
   - 报表/数仓侧 → 星型模型（事实表 + 维度表）。
3. 反规范化必须回答两个问题：**谁负责维护冗余数据的一致性？不一致时如何对账修复？**
4. 大字段（富文本、附件、JSON 详情）拆到从表（垂直拆分），主表保持窄，提升缓存命中率与扫描速度。

---

## 九、通用字段（审计与多租户）

业务表建议统一携带以下列（可由中间件/ORM 自动填充）：

| 列名 | 类型 | 说明 |
| --- | --- | --- |
| `Id` | `bigint IDENTITY` | 主键 |
| `TenantId` | `bigint NOT NULL DEFAULT 0` | 租户编号（SaaS 系统） |
| `Creator` / `CreateBy` | `nvarchar(64)` | 创建人 |
| `CreateTime` | `datetime2 NOT NULL DEFAULT sysdatetime()` | 创建时间 |
| `Updater` / `UpdateBy` | `nvarchar(64)` | 最后更新人 |
| `UpdateTime` | `datetime2` | 最后更新时间 |
| `Deleted` / `IsDeleted` | `bit NOT NULL DEFAULT 0` | 逻辑删除标记 |
| `RowVersion` | `rowversion` | 乐观锁 / 变更检测 |

- 逻辑删除表的**所有唯一索引/查询都必须带 `IsDeleted` 条件**，或使用过滤索引 `WHERE IsDeleted = 0`。
- 多租户表建议将 `TenantId` 置于复合索引首位，并考虑行级安全（Row-Level Security）兜底。

---

## 十、大表与分区策略

- 单表行数预估超千万级、或按月归档的数据（日志、流水、审计）：优先考虑**分区表**（按 `datetime2` 范围分区），配合分区切换（SWITCH）实现秒级归档与删除。
- 冷热分离：历史数据迁移到历史库/归档表，在线表只保留近期数据。
- 超宽只读查询场景（报表）：评估列存储索引（Clustered Columnstore），分析型查询可获得 10x+ 压缩与性能提升。
- 开启数据压缩：OLTP 用 `ROW` 压缩起步，读多写多用 `PAGE` 压缩。

---

## 十一、其他重要实践

1. **显式指定架构**：所有对象加 `dbo.`（或业务架构名）前缀，避免解析歧义与缓存计划不共享。
2. **排序规则（Collation）**：全库统一，常用 `Chinese_PRC_CI_AS`；如需区分大小写/支持补充字符（emoji），使用 `*_CS_AS` / `*_SC` 或 `Latin1_General_100_CI_AS_KS_WS_SC` 系列，建库时确定，后期变更代价极高。
3. **临时表与表变量**：
   - 数据量大（> 几百行）、需要索引与统计信息 → 用 `#temp` 临时表；
   - 小数据集、函数内 → 用 `@table` 表变量。
4. **触发器**：仅用于审计、复杂级联等约束无法表达的场景；严禁在触发器中做远程调用、发邮件等耗时操作。
5. **变更管理**：所有 DDL 通过版本化迁移脚本（Flyway/Liquibase/自研脚本目录）执行，禁止手工在生产库直接改表。
6. **权限最小化**：应用账号只授予 `SELECT/INSERT/UPDATE/DELETE` 与必要的 `EXECUTE`，DDL 权限单独管理。
7. **文档化**：表与重要列使用扩展属性写注释，便于生成数据字典：
   ```sql
   EXEC sp_addextendedproperty
       @name = N'MS_Description', @value = N'订单主表',
       @level0type = N'SCHEMA', @level0name = N'dbo',
       @level1type = N'TABLE',  @level1name = N'Order';
   ```

---

## 十二、参考建表示例

```sql
CREATE TABLE dbo.[Order]
(
    Id           bigint IDENTITY(1,1)  NOT NULL,
    TenantId     bigint                NOT NULL CONSTRAINT DF_Order_TenantId DEFAULT (0),
    OrderNo      varchar(32)           NOT NULL,
    CustomerId   bigint                NOT NULL,
    Amount       decimal(18, 2)        NOT NULL CONSTRAINT CK_Order_Amount CHECK (Amount >= 0),
    Status       tinyint               NOT NULL CONSTRAINT DF_Order_Status DEFAULT (0),  -- 0:待支付 1:已支付 2:已取消
    Creator      nvarchar(64)          NULL,
    CreateTime   datetime2(0)          NOT NULL CONSTRAINT DF_Order_CreateTime DEFAULT (sysdatetime()),
    Updater      nvarchar(64)          NULL,
    UpdateTime   datetime2(0)          NULL,
    Deleted      bit                   NOT NULL CONSTRAINT DF_Order_Deleted DEFAULT (0),

    CONSTRAINT PK_Order PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerId) REFERENCES dbo.Customer (Id)
);
GO

-- 订单号唯一（未删除数据范围内）
CREATE UNIQUE NONCLUSTERED INDEX UQ_Order_OrderNo
    ON dbo.[Order] (OrderNo)
    WHERE Deleted = 0;
GO

-- 按客户查询订单列表的覆盖索引
CREATE NONCLUSTERED INDEX IX_Order_CustomerId
    ON dbo.[Order] (CustomerId, CreateTime DESC)
    INCLUDE (OrderNo, Amount, Status)
    WHERE Deleted = 0;
GO
```

---

## 十三、设计评审检查清单

- [ ] 每张表都有主键，且键窄、稳定、单调（或 NEWSEQUENTIALID）
- [ ] 聚集索引键选择经过论证，不是默认拍脑袋
- [ ] 所有约束、索引显式命名，符合命名规范
- [ ] 数据类型按需选择：无滥用 `nvarchar(max)` / `float` / `datetime` / `text`
- [ ] 金额用 `decimal`，时间用 `datetime2`，布尔用 `bit`
- [ ] 列默认 `NOT NULL`，NULL 是有意为之
- [ ] 外键策略明确（物理外键 or 逻辑外键），团队统一
- [ ] 索引依据真实查询建立，无重复/冗余索引
- [ ] 逻辑删除、多租户字段已纳入索引设计
- [ ] 大表有分区/归档/压缩方案
- [ ] 审计字段（创建人/时间、更新人/时间）齐全
- [ ] DDL 纳入版本化迁移脚本，表/列注释完整
