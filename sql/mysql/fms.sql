-- FMS 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/closing/FmsClosingPeriodDO.java
-- Entity: FmsClosingPeriodDO extends BaseDO
-- 推断字段类型：id bigint, closing_time datetime, account_set_id bigint
CREATE TABLE `fms_closing_period` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `closing_time` datetime NULL COMMENT '结账时间',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 结账期间 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/closing/FmsClosingSchemeDO.java
-- Entity: FmsClosingSchemeDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), period_end bit(1), subject_id bigint, formula_rule int, time_type int, voucher_word_id bigint, digest varchar(500), voucher_type int, prior_year_adjustment_subject_id bigint, adjustment_closing_subject_id bigint, other_closing_subject_id bigint, reverse_balance bit(1), type int, account_set_id bigint, closing_day int, subject_rules json
-- 特殊类型依据：fms_closing.digest yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/closing/vo/FmsProfitLossSettingsSaveReqVO.java:28 @Size(max=500)；按入口上限选择容量，原始物理长度仍为推断
CREATE TABLE `fms_closing` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '结账名称',
  `period_end` bit(1) NULL COMMENT '是否期末结转',
  `subject_id` bigint NULL COMMENT '科目编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsSubjectDO#getId()',
  `formula_rule` int NULL COMMENT '取数规则 枚举 cn.iocoder.yudao.module.fms.enums.report.FmsFormulaRuleEnum',
  `time_type` int NULL COMMENT '取数时间类型 枚举 cn.iocoder.yudao.module.fms.enums.closing.FmsClosingTimeTypeEnum',
  `voucher_word_id` bigint NULL COMMENT '凭证字编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsVoucherWordDO#getId()',
  `digest` varchar(500) NULL COMMENT '凭证摘要',
  `voucher_type` int NULL COMMENT '结转凭证类型 枚举 cn.iocoder.yudao.module.fms.enums.closing.FmsClosingVoucherTypeEnum',
  `prior_year_adjustment_subject_id` bigint NULL COMMENT '“以前年度损益调整”科目 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsSubjectDO#getId()',
  `adjustment_closing_subject_id` bigint NULL COMMENT '“以前年度损益调整”科目的结转科目 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsSubjectDO#getId()',
  `other_closing_subject_id` bigint NULL COMMENT '其他损益科目的结转科目 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsSubjectDO#getId()',
  `reverse_balance` bit(1) NULL COMMENT '是否按余额反向结转',
  `type` int NULL COMMENT '类型 枚举 cn.iocoder.yudao.module.fms.enums.closing.FmsClosingTypeEnum',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `closing_day` int NULL COMMENT '结转损益日期，最大31，超过31默认最后一天',
  `subject_rules` json NULL COMMENT '结转科目规则数组',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 结账方案 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/closing/FmsClosingTemplateDO.java
-- Entity: FmsClosingTemplateDO extends BaseDO
-- 推断字段类型：id bigint, account_set_id bigint, preset_code varchar(255), name varchar(255), category int, period_end bit(1), subject_id bigint, formula_rule int, time_type int, subject_rules json, sort int
CREATE TABLE `fms_closing_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `preset_code` varchar(255) NULL COMMENT '系统预置编码',
  `name` varchar(255) NULL COMMENT '模板名称',
  `category` int NULL COMMENT '模板分类 枚举 cn.iocoder.yudao.module.fms.enums.closing.FmsClosingTemplateCategoryEnum',
  `period_end` bit(1) NULL COMMENT '是否期末结转',
  `subject_id` bigint NULL COMMENT '来源科目编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsSubjectDO#getId()',
  `formula_rule` int NULL COMMENT '取数规则 枚举 cn.iocoder.yudao.module.fms.enums.report.FmsFormulaRuleEnum',
  `time_type` int NULL COMMENT '取数时间类型 枚举 FmsClosingTimeTypeEnum',
  `subject_rules` json NULL COMMENT '结转科目规则数组',
  `sort` int NULL COMMENT '显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 结账模板 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/closing/FmsClosingVoucherDO.java
-- Entity: FmsClosingVoucherDO extends BaseDO
-- 推断字段类型：id bigint, closing_id bigint, voucher_id bigint, voucher_time datetime, amount decimal(24,6), closed bit(1), account_set_id bigint
CREATE TABLE `fms_closing_voucher` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `closing_id` bigint NULL COMMENT '结账方案编号 关联 FmsClosingSchemeDO#getId()',
  `voucher_id` bigint NULL COMMENT '凭证编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.voucher.FmsVoucherDO#getId()',
  `voucher_time` datetime NULL COMMENT '凭证日期',
  `amount` decimal(24,6) NULL COMMENT '结转金额',
  `closed` bit(1) NULL COMMENT '是否已结账',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 结账凭证 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsAccountSetDO.java
-- Entity: FmsAccountSetDO extends BaseDO
-- 推断字段类型：id bigint, company_code varchar(255), company_name varchar(255), company_profile varchar(500), industry varchar(255), location varchar(255), legal_representative varchar(255), legal_representative_id_number varchar(255), business_license_number varchar(255), organization_code varchar(255), remark text, contact_name varchar(255), office_telephone varchar(255), mobile varchar(255), fax_number varchar(255), qq_number varchar(255), email varchar(255), other_contact varchar(255), address varchar(255), currency_id bigint, start_time datetime, standard int, initialized bit(1)
-- 特殊类型依据：fms_account_set.company_profile yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/config/vo/accountset/FmsAccountSetSaveReqVO.java:32 @Size(max=500)；按入口上限选择容量，原始物理长度仍为推断
CREATE TABLE `fms_account_set` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `company_code` varchar(255) NULL COMMENT '公司编码',
  `company_name` varchar(255) NULL COMMENT '公司名称',
  `company_profile` varchar(500) NULL COMMENT '公司简介',
  `industry` varchar(255) NULL COMMENT '所在行业',
  `location` varchar(255) NULL COMMENT '所在地',
  `legal_representative` varchar(255) NULL COMMENT '法人代表',
  `legal_representative_id_number` varchar(255) NULL COMMENT '身份证号',
  `business_license_number` varchar(255) NULL COMMENT '营业执照号',
  `organization_code` varchar(255) NULL COMMENT '组织机构代码',
  `remark` text NULL COMMENT '备注',
  `contact_name` varchar(255) NULL COMMENT '联系人',
  `office_telephone` varchar(255) NULL COMMENT '办公电话',
  `mobile` varchar(255) NULL COMMENT '手机号码',
  `fax_number` varchar(255) NULL COMMENT '传真号码',
  `qq_number` varchar(255) NULL COMMENT 'QQ 号码',
  `email` varchar(255) NULL COMMENT '邮箱',
  `other_contact` varchar(255) NULL COMMENT '其他',
  `address` varchar(255) NULL COMMENT '详细地址',
  `currency_id` bigint NULL COMMENT '币种编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsCurrencyDO#getId()',
  `start_time` datetime NULL COMMENT '启用期间',
  `standard` int NULL COMMENT '会计制度 枚举 cn.iocoder.yudao.module.fms.enums.config.FmsAccountingStandardEnum',
  `initialized` bit(1) NULL COMMENT '是否已初始化',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 账套 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsAccountUserDO.java
-- Entity: FmsAccountUserDO extends BaseDO
-- 推断字段类型：id bigint, account_set_id bigint, user_id bigint, default_status bit(1), founder bit(1), level int
CREATE TABLE `fms_account_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `user_id` bigint NULL COMMENT '后台用户编号 关联 cn.iocoder.yudao.module.system.dal.dataobject.user.AdminUserDO#getId()',
  `default_status` bit(1) NULL COMMENT '是否默认账套',
  `founder` bit(1) NULL COMMENT '是否账套创建人',
  `level` int NULL COMMENT '成员权限级别 枚举 cn.iocoder.yudao.module.fms.enums.config.FmsAccountUserLevelEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 账套用户 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsAuxiliaryCombinationDO.java
-- Entity: FmsAuxiliaryCombinationDO extends BaseDO
-- 推断字段类型：id bigint, subject_id bigint, account_set_id bigint, items json
CREATE TABLE `fms_assist_combination` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `subject_id` bigint NULL COMMENT '科目编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsSubjectDO#getId()',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `items` json NULL COMMENT '辅助核算项目数组',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 辅助核算组合 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsAuxiliaryItemDO.java
-- Entity: FmsAuxiliaryItemDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), auxiliary_type_id bigint, status int, account_set_id bigint, remark text, specification varchar(255), unit varchar(255)
CREATE TABLE `fms_auxiliary_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '编码',
  `name` varchar(255) NULL COMMENT '名称',
  `auxiliary_type_id` bigint NULL COMMENT '辅助核算类别编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAuxiliaryTypeDO#getId()',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `remark` text NULL COMMENT '备注',
  `specification` varchar(255) NULL COMMENT '规格（存货）',
  `unit` varchar(255) NULL COMMENT '单位（存货）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 辅助核算项目 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsAuxiliaryTypeDO.java
-- Entity: FmsAuxiliaryTypeDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), system_preset bit(1), account_set_id bigint, type int
CREATE TABLE `fms_auxiliary_type` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '辅助核算名称',
  `system_preset` bit(1) NULL COMMENT '是否系统预置',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `type` int NULL COMMENT '类型 枚举 cn.iocoder.yudao.module.fms.enums.config.FmsAuxiliaryTypeEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 辅助核算类别 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsCurrencyDO.java
-- Entity: FmsCurrencyDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), exchange_rate decimal(18,6), standard bit(1), account_set_id bigint
-- 特殊类型依据：fms_currency.exchange_rate yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/config/vo/currency/FmsCurrencySaveReqVO.java:45 @Digits(integer=12, fraction=6)；按入口上限选择容量，原始物理精度仍为推断
CREATE TABLE `fms_currency` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '编码',
  `name` varchar(255) NULL COMMENT '币种名称',
  `exchange_rate` decimal(18,6) NULL COMMENT '汇率',
  `standard` bit(1) NULL COMMENT '是否本位币',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 币别 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsDigestDO.java
-- Entity: FmsDigestDO extends BaseDO
-- 推断字段类型：id bigint, content text, account_set_id bigint
CREATE TABLE `fms_digest` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `content` text NULL COMMENT '摘要内容',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 常用摘要 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsFinanceIndicatorDO.java
-- Entity: FmsFinanceIndicatorDO extends BaseDO
-- 推断字段类型：id bigint, account_set_id bigint, name varchar(255), code varchar(255), type int, formula text, sort int, status int
-- 特殊类型依据：fms_finance_indicator.formula yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsReportCommonServiceImpl.java:269-302 绑定/解析科目公式字符串；公式及历史快照可含多条表达式，TEXT 容量为业务推断，保留 String 存储语义
CREATE TABLE `fms_finance_indicator` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `name` varchar(255) NULL COMMENT '指标名称',
  `code` varchar(255) NULL COMMENT '指标编码',
  `type` int NULL COMMENT '取数报表类型 枚举 cn.iocoder.yudao.module.fms.enums.config.FmsFinanceIndicatorTypeEnum',
  `formula` text NULL COMMENT '指标公式，支持报表行次公式或科目公式 JSON',
  `sort` int NULL COMMENT '展示顺序',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 首页财务指标 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsFinanceParameterDO.java
-- Entity: FmsFinanceParameterDO extends BaseDO
-- 推断字段类型：id bigint, account_set_id bigint, level int, subject_code_rule varchar(255), ledger_balance_mode int, deficit_check bit(1), voucher_review_required bit(1), asset_period_locked bit(1), taxpayer_name varchar(255), taxpayer_number varchar(255)
CREATE TABLE `fms_finance_parameter` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `level` int NULL COMMENT '科目层级',
  `subject_code_rule` varchar(255) NULL COMMENT '科目编码规则',
  `ledger_balance_mode` int NULL COMMENT '账簿余额方向模式',
  `deficit_check` bit(1) NULL COMMENT '是否检查现金及银行存款科目赤字',
  `voucher_review_required` bit(1) NULL COMMENT '结账前是否要求凭证审核',
  `asset_period_locked` bit(1) NULL COMMENT '生成折旧凭证后是否锁定以前期间资产卡片',
  `taxpayer_name` varchar(255) NULL COMMENT '纳税人名称',
  `taxpayer_number` varchar(255) NULL COMMENT '纳税人识别号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 财务参数 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsInitialBalanceDO.java
-- Entity: FmsInitialBalanceDO extends BaseDO
-- 推断字段类型：id bigint, subject_id bigint, auxiliary_accounting bit(1), opening_amount decimal(24,6), opening_quantity decimal(24,6), year_debit_amount decimal(24,6), year_debit_quantity decimal(24,6), year_credit_amount decimal(24,6), year_credit_quantity decimal(24,6), year_opening_amount decimal(24,6), year_opening_quantity decimal(24,6), profit_loss_amount decimal(24,6), profit_loss_quantity decimal(24,6), account_set_id bigint, assist_balances json
CREATE TABLE `fms_initial_balance` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `subject_id` bigint NULL COMMENT '科目编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsSubjectDO#getId()',
  `auxiliary_accounting` bit(1) NULL COMMENT '是否启用辅助核算',
  `opening_amount` decimal(24,6) NULL COMMENT '期初金额',
  `opening_quantity` decimal(24,6) NULL COMMENT '期初数量',
  `year_debit_amount` decimal(24,6) NULL COMMENT '本年累计借方金额',
  `year_debit_quantity` decimal(24,6) NULL COMMENT '本年累计借方数量',
  `year_credit_amount` decimal(24,6) NULL COMMENT '本年累计贷方金额',
  `year_credit_quantity` decimal(24,6) NULL COMMENT '本年累计贷方数量',
  `year_opening_amount` decimal(24,6) NULL COMMENT '年初金额',
  `year_opening_quantity` decimal(24,6) NULL COMMENT '年初数量',
  `profit_loss_amount` decimal(24,6) NULL COMMENT '实际损益发生额',
  `profit_loss_quantity` decimal(24,6) NULL COMMENT '实际损益发生数量',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `assist_balances` json NULL COMMENT '辅助核算余额数组',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 科目期初余额 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsSubjectDO.java
-- Entity: FmsSubjectDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), parent_id bigint, type int, category int, balance_direction int, quantity_unit varchar(255), cash bit(1), status int, level int, quantity_accounting bit(1), account_set_id bigint, auxiliary_type_ids json, currency_ids json
CREATE TABLE `fms_subject` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '科目编码',
  `name` varchar(255) NULL COMMENT '科目名称',
  `parent_id` bigint NULL COMMENT '上级科目编号 关联 FmsSubjectDO#getId()',
  `type` int NULL COMMENT '科目类型 枚举 cn.iocoder.yudao.module.fms.enums.config.FmsSubjectTypeEnum',
  `category` int NULL COMMENT '科目类别',
  `balance_direction` int NULL COMMENT '余额方向 枚举 FmsDebitCreditDirectionEnum',
  `quantity_unit` varchar(255) NULL COMMENT '数量核算 计量单位',
  `cash` bit(1) NULL COMMENT '是否现金科目',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `level` int NULL COMMENT '科目层级',
  `quantity_accounting` bit(1) NULL COMMENT '是否启用数量核算',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `auxiliary_type_ids` json NULL COMMENT '辅助核算类别编号数组 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAuxiliaryTypeDO#getId()',
  `currency_ids` json NULL COMMENT '核算币种编号数组 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsCurrencyDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 会计科目 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsSubjectTemplateDO.java
-- Entity: FmsSubjectTemplateDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), parent_id bigint, type int, category int, balance_direction int, quantity_unit varchar(255), cash bit(1), status int, level int, quantity_accounting bit(1)
CREATE TABLE `fms_subject_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '科目编码',
  `name` varchar(255) NULL COMMENT '科目名称',
  `parent_id` bigint NULL COMMENT '上级科目编号 关联 FmsSubjectTemplateDO#getId()',
  `type` int NULL COMMENT '科目类型 枚举 cn.iocoder.yudao.module.fms.enums.config.FmsSubjectTypeEnum',
  `category` int NULL COMMENT '科目类别',
  `balance_direction` int NULL COMMENT '余额方向 枚举 FmsDebitCreditDirectionEnum',
  `quantity_unit` varchar(255) NULL COMMENT '数量核算 计量单位',
  `cash` bit(1) NULL COMMENT '是否现金科目',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `level` int NULL COMMENT '科目层级',
  `quantity_accounting` bit(1) NULL COMMENT '是否启用数量核算',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 科目模板 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsVoucherTemplateCategoryDO.java
-- Entity: FmsVoucherTemplateCategoryDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), account_set_id bigint
CREATE TABLE `fms_voucher_template_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '凭证模板分类名称',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 凭证模板分类 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsVoucherTemplateDO.java
-- Entity: FmsVoucherTemplateDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), category_id bigint, entries json, account_set_id bigint
CREATE TABLE `fms_voucher_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '凭证模板名称',
  `category_id` bigint NULL COMMENT '凭证模板分类编号 关联 FmsVoucherTemplateCategoryDO#getId()',
  `entries` json NULL COMMENT '凭证模板分录数组',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 凭证模板 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsVoucherWordDO.java
-- Entity: FmsVoucherWordDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), print_title varchar(255), default_status bit(1), sort int, account_set_id bigint
CREATE TABLE `fms_voucher_word` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '凭证字',
  `print_title` varchar(255) NULL COMMENT '打印标题',
  `default_status` bit(1) NULL COMMENT '是否默认凭证字',
  `sort` int NULL COMMENT '显示顺序',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 凭证字 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/FmsReportTemplateDO.java
-- Entity: FmsReportTemplateDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), row_no int, formula text, remark text, editable bit(1), sort int, row_id int, type int, category int, level int
-- 特殊类型依据：fms_report_template.formula yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsReportCommonServiceImpl.java:269-302 绑定/解析科目公式字符串；公式及历史快照可含多条表达式，TEXT 容量为业务推断，保留 String 存储语义
CREATE TABLE `fms_report_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '配置名称',
  `row_no` int NULL COMMENT '行次',
  `formula` text NULL COMMENT '公式',
  `remark` text NULL COMMENT '备注',
  `editable` bit(1) NULL COMMENT '是否可编辑',
  `sort` int NULL COMMENT '显示顺序',
  `row_id` int NULL COMMENT '行编号',
  `type` int NULL COMMENT '类型 枚举 cn.iocoder.yudao.module.fms.enums.report.FmsReportTypeEnum',
  `category` int NULL COMMENT '现金流量表分类',
  `level` int NULL COMMENT '层级',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 报表模板 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/balance/FmsBalanceSheetConfigDO.java
-- Entity: FmsBalanceSheetConfigDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), row_no int, formula text, remark text, editable bit(1), sort int, account_set_id bigint, level int, row_id int
-- 特殊类型依据：fms_balance_sheet_config.formula yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsReportCommonServiceImpl.java:269-302 绑定/解析科目公式字符串；公式及历史快照可含多条表达式，TEXT 容量为业务推断，保留 String 存储语义
CREATE TABLE `fms_balance_sheet_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '配置名称',
  `row_no` int NULL COMMENT '行次',
  `formula` text NULL COMMENT '公式',
  `remark` text NULL COMMENT '备注',
  `editable` bit(1) NULL COMMENT '是否可编辑',
  `sort` int NULL COMMENT '显示顺序',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `level` int NULL COMMENT '层级',
  `row_id` int NULL COMMENT '行编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 资产负债表配置 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/balance/FmsBalanceSheetReportDO.java
-- Entity: FmsBalanceSheetReportDO extends BaseDO
-- 推断字段类型：id bigint, from_period int, to_period int, type int, level int, name varchar(255), row_no int, formula text, remark text, editable bit(1), sort int, opening_amount decimal(24,6), closing_amount decimal(24,6), account_set_id bigint, settled bit(1), row_id int
-- 特殊类型依据：fms_balance_sheet_report.formula yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsReportCommonServiceImpl.java:269-302 绑定/解析科目公式字符串；公式及历史快照可含多条表达式，TEXT 容量为业务推断，保留 String 存储语义
CREATE TABLE `fms_balance_sheet_report` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `from_period` int NULL COMMENT '开始会计期间，格式为 yyyyMM',
  `to_period` int NULL COMMENT '结束会计期间，格式为 yyyyMM',
  `type` int NULL COMMENT '报表期间类型 枚举 cn.iocoder.yudao.module.fms.enums.report.FmsReportPeriodTypeEnum',
  `level` int NULL COMMENT '层级快照 冗余 FmsBalanceSheetConfigDO#getLevel()，用于保留历史期间的展示层级',
  `name` varchar(255) NULL COMMENT '配置名称快照 冗余 FmsBalanceSheetConfigDO#getName()，用于保留历史期间的项目名称',
  `row_no` int NULL COMMENT '行次快照 冗余 FmsBalanceSheetConfigDO#getRowNo()，用于保留历史期间的报表行次',
  `formula` text NULL COMMENT '公式快照 冗余 FmsBalanceSheetConfigDO#getFormula()，保证历史期间报表不受后续公式调整影响',
  `remark` text NULL COMMENT '备注快照 冗余 FmsBalanceSheetConfigDO#getRemark()，用于保留历史期间的备注',
  `editable` bit(1) NULL COMMENT '是否可编辑快照 冗余 FmsBalanceSheetConfigDO#getEditable()，用于保留历史期间的可编辑标识',
  `sort` int NULL COMMENT '显示顺序快照 冗余 FmsBalanceSheetConfigDO#getSort()，用于保留历史期间的显示顺序',
  `opening_amount` decimal(24,6) NULL COMMENT '期初金额',
  `closing_amount` decimal(24,6) NULL COMMENT '期末金额',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `settled` bit(1) NULL COMMENT '是否已结账',
  `row_id` int NULL COMMENT '行编号快照 冗余 FmsBalanceSheetConfigDO#getRowId()，用于保留历史期间资产与负债项目的行配对关系',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 资产负债表数据 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/cashflow/FmsCashFlowExtendConfigDO.java
-- Entity: FmsCashFlowExtendConfigDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), row_no int, formula text, remark text, category int, type int, current_amount decimal(24,6), year_amount decimal(24,6), editable bit(1), account_set_id bigint, sort int, level int
-- 特殊类型依据：fms_cash_flow_extend_config.formula yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsReportCommonServiceImpl.java:269-302 绑定/解析科目公式字符串；公式及历史快照可含多条表达式，TEXT 容量为业务推断，保留 String 存储语义
CREATE TABLE `fms_cash_flow_extend_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '配置名称',
  `row_no` int NULL COMMENT '行次',
  `formula` text NULL COMMENT '公式',
  `remark` text NULL COMMENT '备注',
  `category` int NULL COMMENT '表格标识',
  `type` int NULL COMMENT '公式类型 枚举 cn.iocoder.yudao.module.fms.enums.report.FmsCashFlowExtendTypeEnum',
  `current_amount` decimal(24,6) NULL COMMENT '本期金额',
  `year_amount` decimal(24,6) NULL COMMENT '本年累计金额',
  `editable` bit(1) NULL COMMENT '是否可编辑',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `sort` int NULL COMMENT '显示顺序',
  `level` int NULL COMMENT '层级',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 现金流量表扩展配置 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/cashflow/FmsCashFlowExtendDataDO.java
-- Entity: FmsCashFlowExtendDataDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), row_no int, formula text, remark text, category int, current_amount decimal(24,6), year_amount decimal(24,6), from_period int, editable bit(1), account_set_id bigint, sort int, to_period int, type int, level int
-- 特殊类型依据：fms_cash_flow_extend_data.formula yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsReportCommonServiceImpl.java:269-302 绑定/解析科目公式字符串；公式及历史快照可含多条表达式，TEXT 容量为业务推断，保留 String 存储语义
CREATE TABLE `fms_cash_flow_extend_data` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '配置名称',
  `row_no` int NULL COMMENT '行次',
  `formula` text NULL COMMENT '公式',
  `remark` text NULL COMMENT '备注',
  `category` int NULL COMMENT '现金流量表分类',
  `current_amount` decimal(24,6) NULL COMMENT '本期金额',
  `year_amount` decimal(24,6) NULL COMMENT '本年累计金额',
  `from_period` int NULL COMMENT '开始会计期间，格式为 yyyyMM',
  `editable` bit(1) NULL COMMENT '是否可编辑',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `sort` int NULL COMMENT '显示顺序',
  `to_period` int NULL COMMENT '结束会计期间，格式为 yyyyMM',
  `type` int NULL COMMENT '报表期间类型 枚举 cn.iocoder.yudao.module.fms.enums.report.FmsReportPeriodTypeEnum',
  `level` int NULL COMMENT '层级',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 现金流量表扩展数据 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/cashflow/FmsCashFlowStatementConfigDO.java
-- Entity: FmsCashFlowStatementConfigDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), row_no int, formula text, remark text, editable bit(1), sort int, category int, account_set_id bigint, level int
-- 特殊类型依据：fms_cash_flow_statement_config.formula yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsReportCommonServiceImpl.java:269-302 绑定/解析科目公式字符串；公式及历史快照可含多条表达式，TEXT 容量为业务推断，保留 String 存储语义
CREATE TABLE `fms_cash_flow_statement_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '配置名称',
  `row_no` int NULL COMMENT '行次',
  `formula` text NULL COMMENT '公式',
  `remark` text NULL COMMENT '备注',
  `editable` bit(1) NULL COMMENT '是否可编辑',
  `sort` int NULL COMMENT '显示顺序',
  `category` int NULL COMMENT '现金流量表分类',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `level` int NULL COMMENT '层级',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 现金流量表配置 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/cashflow/FmsCashFlowStatementReportDO.java
-- Entity: FmsCashFlowStatementReportDO extends BaseDO
-- 推断字段类型：id bigint, from_period int, name varchar(255), row_no int, formula text, remark text, editable bit(1), current_amount decimal(24,6), year_amount decimal(24,6), sort int, category int, account_set_id bigint, to_period int, type int, level int
-- 特殊类型依据：fms_cash_flow_statement_report.formula yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsReportCommonServiceImpl.java:269-302 绑定/解析科目公式字符串；公式及历史快照可含多条表达式，TEXT 容量为业务推断，保留 String 存储语义
CREATE TABLE `fms_cash_flow_statement_report` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `from_period` int NULL COMMENT '开始会计期间，格式为 yyyyMM',
  `name` varchar(255) NULL COMMENT '配置名称 冗余 FmsCashFlowStatementConfigDO#getName()',
  `row_no` int NULL COMMENT '行次 冗余 FmsCashFlowStatementConfigDO#getRowNo()',
  `formula` text NULL COMMENT '公式 冗余 FmsCashFlowStatementConfigDO#getFormula()',
  `remark` text NULL COMMENT '备注',
  `editable` bit(1) NULL COMMENT '是否可编辑 冗余 FmsCashFlowStatementConfigDO#getEditable()',
  `current_amount` decimal(24,6) NULL COMMENT '本期金额',
  `year_amount` decimal(24,6) NULL COMMENT '本年累计金额',
  `sort` int NULL COMMENT '显示顺序 冗余 FmsCashFlowStatementConfigDO#getSort()',
  `category` int NULL COMMENT '现金流量表分类',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `to_period` int NULL COMMENT '结束会计期间，格式为 yyyyMM',
  `type` int NULL COMMENT '报表期间类型 枚举 cn.iocoder.yudao.module.fms.enums.report.FmsReportPeriodTypeEnum',
  `level` int NULL COMMENT '层级 冗余 FmsCashFlowStatementConfigDO#getLevel()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 现金流量表数据 DO 按会计期间保存报表配置的快照：名称、行次、公式、是否可编辑、显示顺序和层级冗余自 FmsCashFlowStatementConfigDO，保证历史期间报表保留当时的公式，不受后续公式调整影响';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/income/FmsIncomeStatementConfigDO.java
-- Entity: FmsIncomeStatementConfigDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), row_no int, formula text, sort int, editable bit(1), account_set_id bigint, level int
-- 特殊类型依据：fms_income_statement_config.formula yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsReportCommonServiceImpl.java:269-302 绑定/解析科目公式字符串；公式及历史快照可含多条表达式，TEXT 容量为业务推断，保留 String 存储语义
CREATE TABLE `fms_income_statement_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '配置名称',
  `row_no` int NULL COMMENT '行次',
  `formula` text NULL COMMENT '公式',
  `sort` int NULL COMMENT '显示顺序',
  `editable` bit(1) NULL COMMENT '是否可编辑',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `level` int NULL COMMENT '层级',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 利润表配置 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/income/FmsIncomeStatementReportDO.java
-- Entity: FmsIncomeStatementReportDO extends BaseDO
-- 推断字段类型：id bigint, type int, from_period int, to_period int, name varchar(255), row_no int, formula text, sort int, editable bit(1), current_amount decimal(24,6), year_amount decimal(24,6), account_set_id bigint, level int, settled bit(1)
-- 特殊类型依据：fms_income_statement_report.formula yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/service/report/FmsReportCommonServiceImpl.java:269-302 绑定/解析科目公式字符串；公式及历史快照可含多条表达式，TEXT 容量为业务推断，保留 String 存储语义
CREATE TABLE `fms_income_statement_report` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `type` int NULL COMMENT '报表期间类型 枚举 cn.iocoder.yudao.module.fms.enums.report.FmsReportPeriodTypeEnum',
  `from_period` int NULL COMMENT '开始会计期间，格式为 yyyyMM',
  `to_period` int NULL COMMENT '结束会计期间，格式为 yyyyMM',
  `name` varchar(255) NULL COMMENT '配置名称 冗余 FmsIncomeStatementConfigDO#getName()',
  `row_no` int NULL COMMENT '行次 冗余 FmsIncomeStatementConfigDO#getRowNo()',
  `formula` text NULL COMMENT '公式 冗余 FmsIncomeStatementConfigDO#getFormula()',
  `sort` int NULL COMMENT '显示顺序 冗余 FmsIncomeStatementConfigDO#getSort()',
  `editable` bit(1) NULL COMMENT '是否可编辑 冗余 FmsIncomeStatementConfigDO#getEditable()',
  `current_amount` decimal(24,6) NULL COMMENT '本期金额',
  `year_amount` decimal(24,6) NULL COMMENT '本年累计金额',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `level` int NULL COMMENT '层级 冗余 FmsIncomeStatementConfigDO#getLevel()',
  `settled` bit(1) NULL COMMENT '是否已结账',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 利润表数据 DO 按会计期间保存报表配置的快照：名称、行次、公式、显示顺序、是否可编辑和层级冗余自 FmsIncomeStatementConfigDO，保证历史期间报表保留当时的公式，不受后续公式调整影响';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/voucher/FmsVoucherDO.java
-- Entity: FmsVoucherDO extends BaseDO
-- 推断字段类型：id bigint, voucher_word_id bigint, voucher_number int, voucher_time datetime, attachment_urls json, attachment_count int, debit_amount decimal(24,6), credit_amount decimal(24,6), total decimal(24,6), status int, reviewer_user_id bigint, account_set_id bigint
CREATE TABLE `fms_voucher` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `voucher_word_id` bigint NULL COMMENT '凭证字编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsVoucherWordDO#getId()',
  `voucher_number` int NULL COMMENT '凭证号',
  `voucher_time` datetime NULL COMMENT '凭证日期',
  `attachment_urls` json NULL COMMENT '附件地址',
  `attachment_count` int NULL COMMENT '附单据张数',
  `debit_amount` decimal(24,6) NULL COMMENT '借方金额',
  `credit_amount` decimal(24,6) NULL COMMENT '贷方金额',
  `total` decimal(24,6) NULL COMMENT '合计金额',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.module.fms.enums.voucher.FmsVoucherStatusEnum',
  `reviewer_user_id` bigint NULL COMMENT '审核人后台用户编号 关联 cn.iocoder.yudao.module.system.dal.dataobject.user.AdminUserDO#getId()',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 凭证 DO';

-- Source: yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/voucher/FmsVoucherEntryDO.java
-- Entity: FmsVoucherEntryDO extends BaseDO
-- 推断字段类型：id bigint, digest varchar(500), subject_name varchar(255), quantity decimal(18,4), debit_amount decimal(18,2), credit_amount decimal(18,2), voucher_id bigint, subject_code varchar(255), sort int, subject_id bigint, account_set_id bigint, unit_price decimal(18,6), assist_combination_id bigint, auxiliaries json
-- 特殊类型依据：fms_voucher_entry.digest yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/voucher/vo/FmsVoucherEntrySaveReqVO.java:25 @Size(max=500)；按入口上限选择容量，原始物理长度仍为推断
-- 特殊类型依据：fms_voucher_entry.quantity yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/voucher/vo/FmsVoucherEntrySaveReqVO.java:34 @Digits(integer=14, fraction=4)；按入口上限选择容量，原始物理精度仍为推断
-- 特殊类型依据：fms_voucher_entry.debit_amount yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/voucher/vo/FmsVoucherEntrySaveReqVO.java:43 @Digits(integer=16, fraction=2)；按入口上限选择容量，原始物理精度仍为推断
-- 特殊类型依据：fms_voucher_entry.credit_amount yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/voucher/vo/FmsVoucherEntrySaveReqVO.java:47 @Digits(integer=16, fraction=2)；按入口上限选择容量，原始物理精度仍为推断
-- 特殊类型依据：fms_voucher_entry.unit_price yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/controller/admin/voucher/vo/FmsVoucherEntrySaveReqVO.java:39 @Digits(integer=12, fraction=6)；按入口上限选择容量，原始物理精度仍为推断
CREATE TABLE `fms_voucher_entry` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `digest` varchar(500) NULL COMMENT '摘要内容',
  `subject_name` varchar(255) NULL COMMENT '科目名称快照 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsSubjectDO#getName()',
  `quantity` decimal(18,4) NULL COMMENT '数量',
  `debit_amount` decimal(18,2) NULL COMMENT '借方金额',
  `credit_amount` decimal(18,2) NULL COMMENT '贷方金额',
  `voucher_id` bigint NULL COMMENT '凭证编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.voucher.FmsVoucherDO#getId()',
  `subject_code` varchar(255) NULL COMMENT '科目编码快照 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsSubjectDO#getCode()',
  `sort` int NULL COMMENT '显示顺序',
  `subject_id` bigint NULL COMMENT '科目编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsSubjectDO#getId()',
  `account_set_id` bigint NULL COMMENT '账套编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAccountSetDO#getId()',
  `unit_price` decimal(18,6) NULL COMMENT '单价',
  `assist_combination_id` bigint NULL COMMENT '辅助核算组合编号 关联 cn.iocoder.yudao.module.fms.dal.dataobject.config.FmsAuxiliaryCombinationDO#getId()',
  `auxiliaries` json NULL COMMENT '辅助核算项目数组',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FMS 凭证分录 DO';
