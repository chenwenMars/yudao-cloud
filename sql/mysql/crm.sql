-- CRM 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/business/CrmBusinessDO.java
-- Entity: CrmBusinessDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), customer_id bigint, follow_up_status bit(1), contact_last_time datetime, contact_next_time datetime, owner_user_id bigint, status_type_id bigint, status_id bigint, end_status int, end_remark text, deal_time datetime, total_product_price decimal(24,6), discount_percent decimal(24,6), total_price decimal(24,6), remark text
-- 特殊类型依据：crm_business.end_remark yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/business/CrmBusinessDO.java:86 结束时的备注；按自由填写的意见/原因/备注选择 TEXT，容量为业务推断
CREATE TABLE `crm_business` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '商机名称',
  `customer_id` bigint NULL COMMENT '客户编号 关联 CrmCustomerDO#getId()',
  `follow_up_status` bit(1) NULL COMMENT '跟进状态',
  `contact_last_time` datetime NULL COMMENT '最后跟进时间',
  `contact_next_time` datetime NULL COMMENT '下次联系时间',
  `owner_user_id` bigint NULL COMMENT '负责人的用户编号 关联 AdminUserDO 的 id 字段',
  `status_type_id` bigint NULL COMMENT '商机状态组编号 关联 CrmBusinessStatusTypeDO#getId()',
  `status_id` bigint NULL COMMENT '商机状态编号 关联 CrmBusinessStatusDO#getId()',
  `end_status` int NULL COMMENT '结束状态 枚举 CrmBusinessEndStatusEnum',
  `end_remark` text NULL COMMENT '结束时的备注',
  `deal_time` datetime NULL COMMENT '预计成交日期',
  `total_product_price` decimal(24,6) NULL COMMENT '产品总金额，单位：元 productPrice = ∑(CrmBusinessProductDO#getTotalPrice())',
  `discount_percent` decimal(24,6) NULL COMMENT '整单折扣，百分比',
  `total_price` decimal(24,6) NULL COMMENT '商机总金额，单位：元',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 商机 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/business/CrmBusinessProductDO.java
-- Entity: CrmBusinessProductDO extends BaseDO
-- 推断字段类型：id bigint, business_id bigint, product_id bigint, product_price decimal(24,6), business_price decimal(24,6), count decimal(24,6), total_price decimal(24,6)
CREATE TABLE `crm_business_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `business_id` bigint NULL COMMENT '商机编号 关联 CrmBusinessDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 CrmProductDO#getId()',
  `product_price` decimal(24,6) NULL COMMENT '产品单价，单位：元 冗余 CrmProductDO#getPrice()',
  `business_price` decimal(24,6) NULL COMMENT '商机价格, 单位：元',
  `count` decimal(24,6) NULL COMMENT '数量',
  `total_price` decimal(24,6) NULL COMMENT '总计价格，单位：元 totalPrice = businessPrice * count',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 商机产品关联表 DO CrmBusinessDO : CrmBusinessProductDO = 1 : N';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/business/CrmBusinessStatusDO.java
-- Entity: CrmBusinessStatusDO extends BaseDO
-- 推断字段类型：id bigint, type_id bigint, name varchar(255), percent int, sort int
CREATE TABLE `crm_business_status` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type_id` bigint NULL COMMENT '状态类型编号 关联 CrmBusinessStatusTypeDO#getId()',
  `name` varchar(255) NULL COMMENT '状态名',
  `percent` int NULL COMMENT '赢单率，百分比',
  `sort` int NULL COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 商机状态 DO 注意，它是个配置表';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/business/CrmBusinessStatusTypeDO.java
-- Entity: CrmBusinessStatusTypeDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), dept_ids text
CREATE TABLE `crm_business_status_type` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) NULL COMMENT '状态类型名',
  `dept_ids` text NULL COMMENT '使用的部门编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 商机状态组 DO 注意，它是个配置表';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/clue/CrmClueDO.java
-- Entity: CrmClueDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), follow_up_status bit(1), contact_last_time datetime, contact_last_content text, contact_next_time datetime, owner_user_id bigint, transform_status bit(1), customer_id bigint, mobile varchar(255), telephone varchar(255), qq varchar(255), wechat varchar(255), email varchar(255), area_id int, detail_address varchar(255), industry_id int, level int, source int, remark text
CREATE TABLE `crm_clue` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，主键自增',
  `name` varchar(255) NULL COMMENT '线索名称',
  `follow_up_status` bit(1) NULL COMMENT '跟进状态',
  `contact_last_time` datetime NULL COMMENT '最后跟进时间',
  `contact_last_content` text NULL COMMENT '最后跟进内容',
  `contact_next_time` datetime NULL COMMENT '下次联系时间',
  `owner_user_id` bigint NULL COMMENT '负责人的用户编号 关联 AdminUserDO 的 id 字段',
  `transform_status` bit(1) NULL COMMENT '转化状态 true 表示已转换，会更新 #customerId 字段',
  `customer_id` bigint NULL COMMENT '客户编号 关联 CrmCustomerDO#getId()',
  `mobile` varchar(255) NULL COMMENT '手机号',
  `telephone` varchar(255) NULL COMMENT '电话',
  `qq` varchar(255) NULL COMMENT 'QQ',
  `wechat` varchar(255) NULL COMMENT 'wechat',
  `email` varchar(255) NULL COMMENT 'email',
  `area_id` int NULL COMMENT '所在地 关联 cn.iocoder.yudao.framework.ip.core.Area#getId() 字段',
  `detail_address` varchar(255) NULL COMMENT '详细地址',
  `industry_id` int NULL COMMENT '所属行业 对应字典 DictTypeConstants#CRM_CUSTOMER_INDUSTRY',
  `level` int NULL COMMENT '客户等级 对应字典 DictTypeConstants#CRM_CUSTOMER_LEVEL',
  `source` int NULL COMMENT '客户来源 对应字典 DictTypeConstants#CRM_CUSTOMER_SOURCE',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 线索 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/contact/CrmContactBusinessDO.java
-- Entity: CrmContactBusinessDO extends BaseDO
-- 推断字段类型：id bigint, contact_id bigint, business_id bigint
CREATE TABLE `crm_contact_business` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `contact_id` bigint NULL COMMENT '联系人编号 关联 CrmContactDO#getId() 字段',
  `business_id` bigint NULL COMMENT '商机编号 关联 CrmBusinessDO#getId() 字段',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 联系人与商机的关联 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/contact/CrmContactDO.java
-- Entity: CrmContactDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), customer_id bigint, contact_last_time datetime, contact_last_content text, contact_next_time datetime, owner_user_id bigint, mobile varchar(255), telephone varchar(255), email varchar(255), qq bigint, wechat varchar(255), area_id int, detail_address varchar(255), sex int, master bit(1), post varchar(255), parent_id bigint, remark text
CREATE TABLE `crm_contact` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) NULL COMMENT '联系人姓名',
  `customer_id` bigint NULL COMMENT '客户编号 关联 CrmCustomerDO#getId()',
  `contact_last_time` datetime NULL COMMENT '最后跟进时间',
  `contact_last_content` text NULL COMMENT '最后跟进内容',
  `contact_next_time` datetime NULL COMMENT '下次联系时间',
  `owner_user_id` bigint NULL COMMENT '负责人用户编号 关联 AdminUserDO 的 id 字段',
  `mobile` varchar(255) NULL COMMENT '手机号',
  `telephone` varchar(255) NULL COMMENT '电话',
  `email` varchar(255) NULL COMMENT '电子邮箱',
  `qq` bigint NULL COMMENT 'QQ',
  `wechat` varchar(255) NULL COMMENT '微信',
  `area_id` int NULL COMMENT '所在地 关联 cn.iocoder.yudao.framework.ip.core.Area#getId() 字段',
  `detail_address` varchar(255) NULL COMMENT '详细地址',
  `sex` int NULL COMMENT '性别 枚举 cn.iocoder.yudao.module.system.enums.common.SexEnum',
  `master` bit(1) NULL COMMENT '是否关键决策人',
  `post` varchar(255) NULL COMMENT '职位',
  `parent_id` bigint NULL COMMENT '直属上级 关联 CrmContactDO#id',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 联系人 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/contract/CrmContractConfigDO.java
-- Entity: CrmContractConfigDO extends BaseDO
-- 表注释依据：CrmContractConfigDO 的 notifyEnabled、notifyDays 字段及 CrmContractConfigController 功能表明是合同提前提醒配置；实体无类Javadoc，表注释为业务推断
-- 推断字段类型：id bigint, notify_enabled bit(1), notify_days int
CREATE TABLE `crm_contract_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `notify_enabled` bit(1) NULL COMMENT '是否开启提前提醒',
  `notify_days` int NULL COMMENT '提前提醒天数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 合同提前提醒配置（注释推断，实体未声明）';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/contract/CrmContractDO.java
-- Entity: CrmContractDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), no varchar(255), customer_id bigint, business_id bigint, contact_last_time datetime, owner_user_id bigint, process_instance_id varchar(255), audit_status int, order_date datetime, start_time datetime, end_time datetime, total_product_price decimal(24,6), discount_percent decimal(24,6), total_price decimal(24,6), sign_contact_id bigint, sign_user_id bigint, remark text
CREATE TABLE `crm_contract` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '合同编号',
  `name` varchar(255) NULL COMMENT '合同名称',
  `no` varchar(255) NULL COMMENT '合同编号',
  `customer_id` bigint NULL COMMENT '客户编号 关联 CrmCustomerDO#getId()',
  `business_id` bigint NULL COMMENT '商机编号，非必须 关联 CrmBusinessDO#getId()',
  `contact_last_time` datetime NULL COMMENT '最后跟进时间',
  `owner_user_id` bigint NULL COMMENT '负责人的用户编号 关联 AdminUserDO 的 id 字段',
  `process_instance_id` varchar(255) NULL COMMENT '工作流编号 关联 ProcessInstance 的 id 属性',
  `audit_status` int NULL COMMENT '审批状态 枚举 CrmAuditStatusEnum',
  `order_date` datetime NULL COMMENT '下单日期',
  `start_time` datetime NULL COMMENT '开始时间',
  `end_time` datetime NULL COMMENT '结束时间',
  `total_product_price` decimal(24,6) NULL COMMENT '产品总金额，单位：元',
  `discount_percent` decimal(24,6) NULL COMMENT '整单折扣',
  `total_price` decimal(24,6) NULL COMMENT '合同总金额，单位：分',
  `sign_contact_id` bigint NULL COMMENT '客户签约人，非必须 关联 CrmContactDO#getId()',
  `sign_user_id` bigint NULL COMMENT '公司签约人，非必须 关联 AdminUserDO 的 id 字段',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 合同 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/contract/CrmContractProductDO.java
-- Entity: CrmContractProductDO extends BaseDO
-- 推断字段类型：id bigint, contract_id bigint, product_id bigint, product_price decimal(24,6), contract_price decimal(24,6), count decimal(24,6), total_price decimal(24,6)
CREATE TABLE `crm_contract_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `contract_id` bigint NULL COMMENT '合同编号 关联 CrmContractDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 CrmProductDO#getId()',
  `product_price` decimal(24,6) NULL COMMENT '产品单价，单位：元',
  `contract_price` decimal(24,6) NULL COMMENT '合同价格, 单位：元',
  `count` decimal(24,6) NULL COMMENT '数量',
  `total_price` decimal(24,6) NULL COMMENT '总计价格，单位：元 totalPrice = businessPrice * count',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 合同产品关联表 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/customer/CrmCustomerDO.java
-- Entity: CrmCustomerDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), follow_up_status bit(1), contact_last_time datetime, contact_last_content text, contact_next_time datetime, owner_user_id bigint, owner_time datetime, lock_status bit(1), deal_status bit(1), mobile varchar(255), telephone varchar(255), qq varchar(255), wechat varchar(255), email varchar(255), area_id int, detail_address varchar(255), industry_id int, level int, source int, remark text
CREATE TABLE `crm_customer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '客户名称',
  `follow_up_status` bit(1) NULL COMMENT '跟进状态',
  `contact_last_time` datetime NULL COMMENT '最后跟进时间',
  `contact_last_content` text NULL COMMENT '最后跟进内容',
  `contact_next_time` datetime NULL COMMENT '下次联系时间',
  `owner_user_id` bigint NULL COMMENT '负责人的用户编号 关联 AdminUserDO 的 id 字段',
  `owner_time` datetime NULL COMMENT '成为负责人的时间',
  `lock_status` bit(1) NULL COMMENT '锁定状态',
  `deal_status` bit(1) NULL COMMENT '成交状态',
  `mobile` varchar(255) NULL COMMENT '手机',
  `telephone` varchar(255) NULL COMMENT '电话',
  `qq` varchar(255) NULL COMMENT 'QQ',
  `wechat` varchar(255) NULL COMMENT 'wechat',
  `email` varchar(255) NULL COMMENT 'email',
  `area_id` int NULL COMMENT '所在地 关联 cn.iocoder.yudao.framework.ip.core.Area#getId() 字段',
  `detail_address` varchar(255) NULL COMMENT '详细地址',
  `industry_id` int NULL COMMENT '所属行业 对应字典 DictTypeConstants#CRM_CUSTOMER_INDUSTRY',
  `level` int NULL COMMENT '客户等级 对应字典 DictTypeConstants#CRM_CUSTOMER_LEVEL',
  `source` int NULL COMMENT '客户来源 对应字典 DictTypeConstants#CRM_CUSTOMER_SOURCE',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 客户 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/customer/CrmCustomerLimitConfigDO.java
-- Entity: CrmCustomerLimitConfigDO extends BaseDO
-- 推断字段类型：id bigint, type int, user_ids text, dept_ids text, max_count int, deal_count_enabled bit(1)
CREATE TABLE `crm_customer_limit_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `type` int NULL COMMENT '规则类型 枚举 CrmCustomerLimitConfigTypeEnum',
  `user_ids` text NULL COMMENT '规则适用人群',
  `dept_ids` text NULL COMMENT '规则适用部门',
  `max_count` int NULL COMMENT '数量上限',
  `deal_count_enabled` bit(1) NULL COMMENT '成交客户是否占有拥有客户数 当且仅当 #type 为 1 时，进行使用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户限制配置 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/customer/CrmCustomerPoolConfigDO.java
-- Entity: CrmCustomerPoolConfigDO extends BaseDO
-- 推断字段类型：id bigint, enabled bit(1), contact_expire_days int, deal_expire_days int, notify_enabled bit(1), notify_days int
CREATE TABLE `crm_customer_pool_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `enabled` bit(1) NULL COMMENT '是否启用客户公海',
  `contact_expire_days` int NULL COMMENT '未跟进放入公海天数',
  `deal_expire_days` int NULL COMMENT '未成交放入公海天数',
  `notify_enabled` bit(1) NULL COMMENT '是否开启提前提醒',
  `notify_days` int NULL COMMENT '提前提醒天数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户公海配置 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/followup/CrmFollowUpRecordDO.java
-- Entity: CrmFollowUpRecordDO extends BaseDO
-- 推断字段类型：id bigint, biz_type int, biz_id bigint, type int, content text, next_time datetime, pic_urls text, file_urls text, business_ids text, contact_ids text
CREATE TABLE `crm_follow_up_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `biz_type` int NULL COMMENT '数据类型 枚举 CrmBizTypeEnum',
  `biz_id` bigint NULL COMMENT '数据编号 关联 CrmBizTypeEnum 对应模块 DO 的 id 字段',
  `type` int NULL COMMENT '跟进类型 关联 DictTypeConstants#CRM_FOLLOW_UP_TYPE 字典',
  `content` text NULL COMMENT '跟进内容',
  `next_time` datetime NULL COMMENT '下次联系时间',
  `pic_urls` text NULL COMMENT '图片',
  `file_urls` text NULL COMMENT '附件',
  `business_ids` text NULL COMMENT '关联的商机编号数组 关联 CrmBusinessDO#getId()',
  `contact_ids` text NULL COMMENT '关联的联系人编号数组 关联 CrmContactDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='跟进记录 DO 用于记录客户、联系人的每一次跟进';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/performance/CrmPerformanceConfigDO.java
-- Entity: CrmPerformanceConfigDO extends BaseDO
-- 推断字段类型：id bigint, biz_type int, object_id bigint, object_type int, year int, year_target_price decimal(24,6), january_target_price decimal(24,6), february_target_price decimal(24,6), march_target_price decimal(24,6), april_target_price decimal(24,6), may_target_price decimal(24,6), june_target_price decimal(24,6), july_target_price decimal(24,6), august_target_price decimal(24,6), september_target_price decimal(24,6), october_target_price decimal(24,6), november_target_price decimal(24,6), december_target_price decimal(24,6)
CREATE TABLE `crm_performance_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `biz_type` int NULL COMMENT '目标类型 枚举 CrmPerformanceConfigBizTypeEnum',
  `object_id` bigint NULL COMMENT '目标对象编号',
  `object_type` int NULL COMMENT '目标对象类型 枚举 CrmPerformanceConfigObjectTypeEnum',
  `year` int NULL COMMENT '年份',
  `year_target_price` decimal(24,6) NULL COMMENT '年度目标金额',
  `january_target_price` decimal(24,6) NULL COMMENT '一月目标金额',
  `february_target_price` decimal(24,6) NULL COMMENT '二月目标金额',
  `march_target_price` decimal(24,6) NULL COMMENT '三月目标金额',
  `april_target_price` decimal(24,6) NULL COMMENT '四月目标金额',
  `may_target_price` decimal(24,6) NULL COMMENT '五月目标金额',
  `june_target_price` decimal(24,6) NULL COMMENT '六月目标金额',
  `july_target_price` decimal(24,6) NULL COMMENT '七月目标金额',
  `august_target_price` decimal(24,6) NULL COMMENT '八月目标金额',
  `september_target_price` decimal(24,6) NULL COMMENT '九月目标金额',
  `october_target_price` decimal(24,6) NULL COMMENT '十月目标金额',
  `november_target_price` decimal(24,6) NULL COMMENT '十一月目标金额',
  `december_target_price` decimal(24,6) NULL COMMENT '十二月目标金额',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 业绩目标 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/permission/CrmOwnerRecordDO.java
-- Entity: CrmOwnerRecordDO extends BaseDO
-- 推断字段类型：id bigint, biz_type int, biz_id bigint, pre_owner_user_id bigint, post_owner_user_id bigint
CREATE TABLE `crm_owner_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `biz_type` int NULL COMMENT 'CRM 业务类型 枚举 CrmBizTypeEnum',
  `biz_id` bigint NULL COMMENT 'CRM 业务编号',
  `pre_owner_user_id` bigint NULL COMMENT '变更前负责人',
  `post_owner_user_id` bigint NULL COMMENT '变更后负责人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 负责人变更记录 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/permission/CrmPermissionDO.java
-- Entity: CrmPermissionDO extends BaseDO
-- 推断字段类型：id bigint, biz_type int, biz_id bigint, user_id bigint, level int
CREATE TABLE `crm_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，主键自增',
  `biz_type` int NULL COMMENT '数据类型 枚举 CrmBizTypeEnum',
  `biz_id` bigint NULL COMMENT '数据编号 关联 CrmBizTypeEnum 对应模块 DO 的 id 字段',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUser 的 id 字段',
  `level` int NULL COMMENT '权限级别 关联 CrmPermissionLevelEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 数据权限 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/product/CrmProductCategoryDO.java
-- Entity: CrmProductCategoryDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), parent_id bigint
CREATE TABLE `crm_product_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类编号',
  `name` varchar(255) NULL COMMENT '分类名称',
  `parent_id` bigint NULL COMMENT '父级编号 关联 CrmProductCategoryDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品分类 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/product/CrmProductDO.java
-- Entity: CrmProductDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), no varchar(255), unit int, price decimal(24,6), status int, category_id bigint, description text, owner_user_id bigint
CREATE TABLE `crm_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '产品名称',
  `no` varchar(255) NULL COMMENT '产品编码',
  `unit` int NULL COMMENT '单位 字典 DictTypeConstants#CRM_PRODUCT_UNIT',
  `price` decimal(24,6) NULL COMMENT '价格，单位：元',
  `status` int NULL COMMENT '状态 关联 CrmProductStatusEnum',
  `category_id` bigint NULL COMMENT '产品分类 ID 关联 CrmProductCategoryDO#getId() 字段',
  `description` text NULL COMMENT '产品描述',
  `owner_user_id` bigint NULL COMMENT '负责人的用户编号 关联 AdminUserDO 的 id 字段',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 产品 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/receivable/CrmReceivableDO.java
-- Entity: CrmReceivableDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), plan_id bigint, customer_id bigint, contract_id bigint, owner_user_id bigint, return_time datetime, return_type int, price decimal(24,6), remark text, process_instance_id varchar(255), audit_status int
CREATE TABLE `crm_receivable` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `no` varchar(255) NULL COMMENT '回款编号',
  `plan_id` bigint NULL COMMENT '回款计划编号 关联 CrmReceivablePlanDO#getId()，非必须',
  `customer_id` bigint NULL COMMENT '客户编号 关联 CrmCustomerDO#getId()',
  `contract_id` bigint NULL COMMENT '合同编号 关联 CrmContractDO#getId()',
  `owner_user_id` bigint NULL COMMENT '负责人编号，关联 AdminUserRespDTO#getId()',
  `return_time` datetime NULL COMMENT '回款日期',
  `return_type` int NULL COMMENT '回款方式 枚举 CrmReceivableReturnTypeEnum',
  `price` decimal(24,6) NULL COMMENT '计划回款金额，单位：元',
  `remark` text NULL COMMENT '备注',
  `process_instance_id` varchar(255) NULL COMMENT '工作流编号 关联 ProcessInstance 的 id 属性',
  `audit_status` int NULL COMMENT '审批状态 枚举 CrmAuditStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='回款 DO';

-- Source: yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/receivable/CrmReceivablePlanDO.java
-- Entity: CrmReceivablePlanDO extends BaseDO
-- 推断字段类型：id bigint, period int, customer_id bigint, contract_id bigint, owner_user_id bigint, return_time datetime, return_type int, price decimal(24,6), receivable_id bigint, remind_days int, remind_time datetime, remark text
CREATE TABLE `crm_receivable_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `period` int NULL COMMENT '期数',
  `customer_id` bigint NULL COMMENT '客户编号 关联 CrmCustomerDO#getId()',
  `contract_id` bigint NULL COMMENT '合同编号 关联 CrmContractDO#getId()',
  `owner_user_id` bigint NULL COMMENT '负责人编号 关联 AdminUserDO 的 id 字段',
  `return_time` datetime NULL COMMENT '计划回款日期',
  `return_type` int NULL COMMENT '计划回款类型 枚举 CrmReceivableReturnTypeEnum',
  `price` decimal(24,6) NULL COMMENT '计划回款金额，单位：元',
  `receivable_id` bigint NULL COMMENT '回款编号，关联 CrmReceivableDO#getId()',
  `remind_days` int NULL COMMENT '提前几天提醒',
  `remind_time` datetime NULL COMMENT '提醒日期',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CRM 回款计划 DO';
