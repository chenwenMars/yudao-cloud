-- REPORT 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
-- 这是结构推导稿，不是官方数据库脚本；不包含初始化 DML。
-- 来源：各 *-server/src/main/java/**/dal/dataobject 的 @TableName 顶层实体。
-- 确定信息：表名、持久化字段、继承字段、映射注解、注释；类型容量与约束不能完整还原。
-- 已存在于 ruoyi-vue-pro.sql 的同表同列定义直接复用，公共审计列参照 system_notice。
-- 推断规则：Long→BIGINT，Integer→INT，Boolean→BIT(1)，时间→DATETIME/DATE/TIME；
-- BigDecimal→DECIMAL(24,6)；普通 String→VARCHAR(255)，URL→VARCHAR(1024)，长文本→TEXT；
-- JSON处理器→JSON，CSV列表处理器→TEXT；逐表特殊推断见下面说明。
-- 新推导业务字段暂允许 NULL，未设置业务默认值；NOT NULL/默认值需结合实际要求确认。
-- 主键优先遵守显式 @TableId 策略，未指定时按 MySQL AUTO 自增；仅生成主键索引。
-- 仅生成 CREATE TABLE；同名表已存在时直接报错。请明确选择目标数据库后审核执行。
-- 所有标识符均使用反引号；存储引擎/字符集参照仓库现有 MySQL SQL。

-- Source: yudao-module-report/yudao-module-report-server/src/main/java/cn/iocoder/yudao/module/report/dal/dataobject/goview/GoViewProjectDO.java
-- Entity: GoViewProjectDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), pic_url varchar(1024), content longtext, status int, remark text
-- 特殊类型依据：report_go_view_project.content 源实体明确报表 JSON 配置使用字符串存储；保持 Java String 文本语义，LONGTEXT 容量为推断
CREATE TABLE `report_go_view_project` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，数据库自增',
  `name` varchar(255) NULL COMMENT '项目名称',
  `pic_url` varchar(1024) NULL COMMENT '预览图片 URL',
  `content` longtext NULL COMMENT '报表内容 JSON 配置，使用字符串存储',
  `status` int NULL COMMENT '发布状态 0 - 已发布 1 - 未发布 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '项目备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='GoView 项目表 每个大屏图标，对应一个项目';
