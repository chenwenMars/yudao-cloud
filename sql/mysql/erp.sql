-- ERP 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/finance/ErpAccountDO.java
-- Entity: ErpAccountDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), no varchar(255), remark text, status int, sort int, default_status bit(1)
CREATE TABLE `erp_account` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '结算账户编号',
  `name` varchar(255) NULL COMMENT '账户名称',
  `no` varchar(255) NULL COMMENT '账户编码',
  `remark` text NULL COMMENT '备注',
  `status` int NULL COMMENT '开启状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `sort` int NULL COMMENT '排序',
  `default_status` bit(1) NULL COMMENT '是否默认',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 结算账户 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/finance/ErpFinancePaymentDO.java
-- Entity: ErpFinancePaymentDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), status int, payment_time datetime, finance_user_id bigint, supplier_id bigint, account_id bigint, total_price decimal(24,6), discount_price decimal(24,6), payment_price decimal(24,6), remark text
CREATE TABLE `erp_finance_payment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `no` varchar(255) NULL COMMENT '付款单号',
  `status` int NULL COMMENT '付款状态 枚举 cn.iocoder.yudao.module.erp.enums.ErpAuditStatus',
  `payment_time` datetime NULL COMMENT '付款时间',
  `finance_user_id` bigint NULL COMMENT '财务人员编号 关联 AdminUserDO 的 id 字段',
  `supplier_id` bigint NULL COMMENT '供应商编号 关联 ErpSupplierDO#getId()',
  `account_id` bigint NULL COMMENT '付款账户编号 关联 ErpAccountDO#getId()',
  `total_price` decimal(24,6) NULL COMMENT '合计价格，单位：元',
  `discount_price` decimal(24,6) NULL COMMENT '优惠金额，单位：元',
  `payment_price` decimal(24,6) NULL COMMENT '实付金额，单位：分 paymentPrice = totalPrice - discountPrice',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 付款单 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/finance/ErpFinancePaymentItemDO.java
-- Entity: ErpFinancePaymentItemDO extends BaseDO
-- 推断字段类型：id bigint, payment_id bigint, biz_type int, biz_id bigint, biz_no varchar(255), total_price decimal(24,6), paid_price decimal(24,6), payment_price decimal(24,6), remark text
CREATE TABLE `erp_finance_payment_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '入库项编号',
  `payment_id` bigint NULL COMMENT '付款单编号 关联 ErpFinancePaymentDO#getId()',
  `biz_type` int NULL COMMENT '业务类型 枚举 cn.iocoder.yudao.module.erp.enums.common.ErpBizTypeEnum 的采购入库、退货',
  `biz_id` bigint NULL COMMENT '业务编号 例如说：ErpPurchaseInDO#getId()',
  `biz_no` varchar(255) NULL COMMENT '业务单号 例如说：ErpPurchaseInDO#getNo()',
  `total_price` decimal(24,6) NULL COMMENT '应付金额，单位：分',
  `paid_price` decimal(24,6) NULL COMMENT '已付金额，单位：分',
  `payment_price` decimal(24,6) NULL COMMENT '本次付款，单位：分',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 付款项 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/finance/ErpFinanceReceiptDO.java
-- Entity: ErpFinanceReceiptDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), status int, receipt_time datetime, finance_user_id bigint, customer_id bigint, account_id bigint, total_price decimal(24,6), discount_price decimal(24,6), receipt_price decimal(24,6), remark text
CREATE TABLE `erp_finance_receipt` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `no` varchar(255) NULL COMMENT '收款单号',
  `status` int NULL COMMENT '收款状态 枚举 cn.iocoder.yudao.module.erp.enums.ErpAuditStatus',
  `receipt_time` datetime NULL COMMENT '收款时间',
  `finance_user_id` bigint NULL COMMENT '财务人员编号 关联 AdminUserDO 的 id 字段',
  `customer_id` bigint NULL COMMENT '客户编号 关联 ErpCustomerDO#getId()',
  `account_id` bigint NULL COMMENT '收款账户编号 关联 ErpAccountDO#getId()',
  `total_price` decimal(24,6) NULL COMMENT '合计价格，单位：元',
  `discount_price` decimal(24,6) NULL COMMENT '优惠金额，单位：元',
  `receipt_price` decimal(24,6) NULL COMMENT '实付金额，单位：分 receiptPrice = totalPrice - discountPrice',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 收款单 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/finance/ErpFinanceReceiptItemDO.java
-- Entity: ErpFinanceReceiptItemDO extends BaseDO
-- 推断字段类型：id bigint, receipt_id bigint, biz_type int, biz_id bigint, biz_no varchar(255), total_price decimal(24,6), receipted_price decimal(24,6), receipt_price decimal(24,6), remark text
CREATE TABLE `erp_finance_receipt_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '入库项编号',
  `receipt_id` bigint NULL COMMENT '收款单编号 关联 ErpFinanceReceiptDO#getId()',
  `biz_type` int NULL COMMENT '业务类型 枚举 cn.iocoder.yudao.module.erp.enums.common.ErpBizTypeEnum 的销售出库、退货',
  `biz_id` bigint NULL COMMENT '业务编号 例如说：ErpSaleOutDO#getId()',
  `biz_no` varchar(255) NULL COMMENT '业务单号 例如说：ErpSaleOutDO#getNo()',
  `total_price` decimal(24,6) NULL COMMENT '应收金额，单位：分',
  `receipted_price` decimal(24,6) NULL COMMENT '已收金额，单位：分',
  `receipt_price` decimal(24,6) NULL COMMENT '本次收款，单位：分',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 收款项 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/product/ErpProductCategoryDO.java
-- Entity: ErpProductCategoryDO extends BaseDO
-- 推断字段类型：id bigint, parent_id bigint, name varchar(255), code varchar(255), sort int, status int
CREATE TABLE `erp_product_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类编号',
  `parent_id` bigint NULL COMMENT '父分类编号',
  `name` varchar(255) NULL COMMENT '分类名称',
  `code` varchar(255) NULL COMMENT '分类编码',
  `sort` int NULL COMMENT '分类排序',
  `status` int NULL COMMENT '开启状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 产品分类 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/product/ErpProductDO.java
-- Entity: ErpProductDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), bar_code varchar(255), category_id bigint, unit_id bigint, status int, standard varchar(255), remark text, expiry_day int, weight decimal(24,6), purchase_price decimal(24,6), sale_price decimal(24,6), min_price decimal(24,6)
CREATE TABLE `erp_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '产品编号',
  `name` varchar(255) NULL COMMENT '产品名称',
  `bar_code` varchar(255) NULL COMMENT '产品条码',
  `category_id` bigint NULL COMMENT '产品分类编号 关联 ErpProductCategoryDO#getId()',
  `unit_id` bigint NULL COMMENT '单位编号 关联 ErpProductUnitDO#getId()',
  `status` int NULL COMMENT '产品状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `standard` varchar(255) NULL COMMENT '产品规格',
  `remark` text NULL COMMENT '产品备注',
  `expiry_day` int NULL COMMENT '保质期天数',
  `weight` decimal(24,6) NULL COMMENT '基础重量（kg）',
  `purchase_price` decimal(24,6) NULL COMMENT '采购价格，单位：元',
  `sale_price` decimal(24,6) NULL COMMENT '销售价格，单位：元',
  `min_price` decimal(24,6) NULL COMMENT '最低价格，单位：元',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 产品 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/product/ErpProductUnitDO.java
-- Entity: ErpProductUnitDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), status int
CREATE TABLE `erp_product_unit` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '单位编号',
  `name` varchar(255) NULL COMMENT '单位名字',
  `status` int NULL COMMENT '单位状态',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 产品单位 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpPurchaseInDO.java
-- Entity: ErpPurchaseInDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), status int, supplier_id bigint, account_id bigint, in_time datetime, order_id bigint, order_no varchar(255), total_count decimal(24,6), total_price decimal(24,6), payment_price decimal(24,6), total_product_price decimal(24,6), total_tax_price decimal(24,6), discount_percent decimal(24,6), discount_price decimal(24,6), other_price decimal(24,6), file_url varchar(1024), remark text
CREATE TABLE `erp_purchase_in` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `no` varchar(255) NULL COMMENT '采购入库单号',
  `status` int NULL COMMENT '入库状态 枚举 cn.iocoder.yudao.module.erp.enums.ErpAuditStatus',
  `supplier_id` bigint NULL COMMENT '供应商编号 关联 ErpSupplierDO#getId()',
  `account_id` bigint NULL COMMENT '结算账户编号 关联 ErpAccountDO#getId()',
  `in_time` datetime NULL COMMENT '入库时间',
  `order_id` bigint NULL COMMENT '采购订单编号 关联 ErpPurchaseOrderDO#getId()',
  `order_no` varchar(255) NULL COMMENT '采购订单号 冗余 ErpPurchaseOrderDO#getNo()',
  `total_count` decimal(24,6) NULL COMMENT '合计数量',
  `total_price` decimal(24,6) NULL COMMENT '最终合计价格，单位：元 totalPrice = totalProductPrice + totalTaxPrice - discountPrice + otherPrice',
  `payment_price` decimal(24,6) NULL COMMENT '已支付金额，单位：元 目的：和 cn.iocoder.yudao.module.erp.dal.dataobject.finance.ErpFinancePaymentDO 结合，记录已支付金额',
  `total_product_price` decimal(24,6) NULL COMMENT '合计产品价格，单位：元',
  `total_tax_price` decimal(24,6) NULL COMMENT '合计税额，单位：元',
  `discount_percent` decimal(24,6) NULL COMMENT '优惠率，百分比',
  `discount_price` decimal(24,6) NULL COMMENT '优惠金额，单位：元 discountPrice = (totalProductPrice + totalTaxPrice) * discountPercent',
  `other_price` decimal(24,6) NULL COMMENT '其它金额，单位：元',
  `file_url` varchar(1024) NULL COMMENT '附件地址',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 采购入库 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpPurchaseInItemDO.java
-- Entity: ErpPurchaseInItemDO extends BaseDO
-- 推断字段类型：id bigint, in_id bigint, order_item_id bigint, warehouse_id bigint, product_id bigint, product_unit_id bigint, product_price decimal(24,6), count decimal(24,6), total_price decimal(24,6), tax_percent decimal(24,6), tax_price decimal(24,6), remark text
CREATE TABLE `erp_purchase_in_items` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `in_id` bigint NULL COMMENT '采购入库编号 关联 ErpPurchaseInDO##getId()',
  `order_item_id` bigint NULL COMMENT '采购订单项编号 关联 ErpPurchaseOrderItemDO#getId() 目的：方便更新关联的采购订单项的入库数量',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 ErpWarehouseDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 ErpProductDO#getId()',
  `product_unit_id` bigint NULL COMMENT '产品单位单位 冗余 ErpProductDO#getUnitId()',
  `product_price` decimal(24,6) NULL COMMENT '产品单位单价，单位：元',
  `count` decimal(24,6) NULL COMMENT '数量',
  `total_price` decimal(24,6) NULL COMMENT '总价，单位：元 totalPrice = productPrice * count',
  `tax_percent` decimal(24,6) NULL COMMENT '税率，百分比',
  `tax_price` decimal(24,6) NULL COMMENT '税额，单位：元 taxPrice = totalPrice * taxPercent',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 采购入库项 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpPurchaseOrderDO.java
-- Entity: ErpPurchaseOrderDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), status int, supplier_id bigint, account_id bigint, order_time datetime, total_count decimal(24,6), total_price decimal(24,6), total_product_price decimal(24,6), total_tax_price decimal(24,6), discount_percent decimal(24,6), discount_price decimal(24,6), deposit_price decimal(24,6), file_url varchar(1024), remark text, in_count decimal(24,6), return_count decimal(24,6)
CREATE TABLE `erp_purchase_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `no` varchar(255) NULL COMMENT '采购订单号',
  `status` int NULL COMMENT '采购状态 枚举 cn.iocoder.yudao.module.erp.enums.ErpAuditStatus',
  `supplier_id` bigint NULL COMMENT '供应商编号 关联 ErpSupplierDO#getId()',
  `account_id` bigint NULL COMMENT '结算账户编号 关联 ErpAccountDO#getId()',
  `order_time` datetime NULL COMMENT '下单时间',
  `total_count` decimal(24,6) NULL COMMENT '合计数量',
  `total_price` decimal(24,6) NULL COMMENT '最终合计价格，单位：元 totalPrice = totalProductPrice + totalTaxPrice - discountPrice',
  `total_product_price` decimal(24,6) NULL COMMENT '合计产品价格，单位：元',
  `total_tax_price` decimal(24,6) NULL COMMENT '合计税额，单位：元',
  `discount_percent` decimal(24,6) NULL COMMENT '优惠率，百分比',
  `discount_price` decimal(24,6) NULL COMMENT '优惠金额，单位：元 discountPrice = (totalProductPrice + totalTaxPrice) * discountPercent',
  `deposit_price` decimal(24,6) NULL COMMENT '定金金额，单位：元',
  `file_url` varchar(1024) NULL COMMENT '附件地址',
  `remark` text NULL COMMENT '备注',
  `in_count` decimal(24,6) NULL COMMENT '采购入库数量',
  `return_count` decimal(24,6) NULL COMMENT '采购退货数量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 采购订单 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpPurchaseOrderItemDO.java
-- Entity: ErpPurchaseOrderItemDO extends BaseDO
-- 推断字段类型：id bigint, order_id bigint, product_id bigint, product_unit_id bigint, product_price decimal(24,6), count decimal(24,6), total_price decimal(24,6), tax_percent decimal(24,6), tax_price decimal(24,6), remark text, in_count decimal(24,6), return_count decimal(24,6)
CREATE TABLE `erp_purchase_order_items` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `order_id` bigint NULL COMMENT '采购订单编号 关联 ErpPurchaseOrderDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 ErpProductDO#getId()',
  `product_unit_id` bigint NULL COMMENT '产品单位单位 冗余 ErpProductDO#getUnitId()',
  `product_price` decimal(24,6) NULL COMMENT '产品单位单价，单位：元',
  `count` decimal(24,6) NULL COMMENT '数量',
  `total_price` decimal(24,6) NULL COMMENT '总价，单位：元 totalPrice = productPrice * count',
  `tax_percent` decimal(24,6) NULL COMMENT '税率，百分比',
  `tax_price` decimal(24,6) NULL COMMENT '税额，单位：元 taxPrice = totalPrice * taxPercent',
  `remark` text NULL COMMENT '备注',
  `in_count` decimal(24,6) NULL COMMENT '采购入库数量',
  `return_count` decimal(24,6) NULL COMMENT '采购退货数量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 采购订单项 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpPurchaseReturnDO.java
-- Entity: ErpPurchaseReturnDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), status int, supplier_id bigint, account_id bigint, return_time datetime, order_id bigint, order_no varchar(255), total_count decimal(24,6), total_price decimal(24,6), refund_price decimal(24,6), total_product_price decimal(24,6), total_tax_price decimal(24,6), discount_percent decimal(24,6), discount_price decimal(24,6), other_price decimal(24,6), file_url varchar(1024), remark text
CREATE TABLE `erp_purchase_return` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `no` varchar(255) NULL COMMENT '采购退货单号',
  `status` int NULL COMMENT '退货状态 枚举 cn.iocoder.yudao.module.erp.enums.ErpAuditStatus',
  `supplier_id` bigint NULL COMMENT '供应商编号 关联 ErpSupplierDO#getId()',
  `account_id` bigint NULL COMMENT '结算账户编号 关联 ErpAccountDO#getId()',
  `return_time` datetime NULL COMMENT '退货时间',
  `order_id` bigint NULL COMMENT '采购订单编号 关联 ErpPurchaseOrderDO#getId()',
  `order_no` varchar(255) NULL COMMENT '采购订单号 冗余 ErpPurchaseOrderDO#getNo()',
  `total_count` decimal(24,6) NULL COMMENT '合计数量',
  `total_price` decimal(24,6) NULL COMMENT '最终合计价格，单位：元 totalPrice = totalProductPrice + totalTaxPrice - discountPrice + otherPrice',
  `refund_price` decimal(24,6) NULL COMMENT '已退款金额，单位：元 目的：和 cn.iocoder.yudao.module.erp.dal.dataobject.finance.ErpFinancePaymentDO 结合，记录已支付金额',
  `total_product_price` decimal(24,6) NULL COMMENT '合计产品价格，单位：元',
  `total_tax_price` decimal(24,6) NULL COMMENT '合计税额，单位：元',
  `discount_percent` decimal(24,6) NULL COMMENT '优惠率，百分比',
  `discount_price` decimal(24,6) NULL COMMENT '优惠金额，单位：元 discountPrice = (totalProductPrice + totalTaxPrice) * discountPercent',
  `other_price` decimal(24,6) NULL COMMENT '其它金额，单位：元',
  `file_url` varchar(1024) NULL COMMENT '附件地址',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 采购退货 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpPurchaseReturnItemDO.java
-- Entity: ErpPurchaseReturnItemDO extends BaseDO
-- 推断字段类型：id bigint, return_id bigint, order_item_id bigint, warehouse_id bigint, product_id bigint, product_unit_id bigint, product_price decimal(24,6), count decimal(24,6), total_price decimal(24,6), tax_percent decimal(24,6), tax_price decimal(24,6), remark text
CREATE TABLE `erp_purchase_return_items` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `return_id` bigint NULL COMMENT '采购退货编号 关联 ErpPurchaseReturnDO##getId()',
  `order_item_id` bigint NULL COMMENT '采购订单项编号 关联 ErpPurchaseOrderItemDO#getId() 目的：方便更新关联的采购订单项的退货数量',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 ErpWarehouseDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 ErpProductDO#getId()',
  `product_unit_id` bigint NULL COMMENT '产品单位单位 冗余 ErpProductDO#getUnitId()',
  `product_price` decimal(24,6) NULL COMMENT '产品单位单价，单位：元',
  `count` decimal(24,6) NULL COMMENT '数量',
  `total_price` decimal(24,6) NULL COMMENT '总价，单位：元 totalPrice = productPrice * count',
  `tax_percent` decimal(24,6) NULL COMMENT '税率，百分比',
  `tax_price` decimal(24,6) NULL COMMENT '税额，单位：元 taxPrice = totalPrice * taxPercent',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 采购退货项 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpSupplierDO.java
-- Entity: ErpSupplierDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), contact varchar(255), mobile varchar(255), telephone varchar(255), email varchar(255), fax varchar(255), remark text, status int, sort int, tax_no varchar(255), tax_percent decimal(24,6), bank_name varchar(255), bank_account varchar(255), bank_address varchar(255)
CREATE TABLE `erp_supplier` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '供应商编号',
  `name` varchar(255) NULL COMMENT '供应商名称',
  `contact` varchar(255) NULL COMMENT '联系人',
  `mobile` varchar(255) NULL COMMENT '手机号码',
  `telephone` varchar(255) NULL COMMENT '联系电话',
  `email` varchar(255) NULL COMMENT '电子邮箱',
  `fax` varchar(255) NULL COMMENT '传真',
  `remark` text NULL COMMENT '备注',
  `status` int NULL COMMENT '开启状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `sort` int NULL COMMENT '排序',
  `tax_no` varchar(255) NULL COMMENT '纳税人识别号',
  `tax_percent` decimal(24,6) NULL COMMENT '税率',
  `bank_name` varchar(255) NULL COMMENT '开户行',
  `bank_account` varchar(255) NULL COMMENT '开户账号',
  `bank_address` varchar(255) NULL COMMENT '开户地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 供应商 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpCustomerDO.java
-- Entity: ErpCustomerDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), contact varchar(255), mobile varchar(255), telephone varchar(255), email varchar(255), fax varchar(255), remark text, status int, sort int, tax_no varchar(255), tax_percent decimal(24,6), bank_name varchar(255), bank_account varchar(255), bank_address varchar(255)
CREATE TABLE `erp_customer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '客户编号',
  `name` varchar(255) NULL COMMENT '客户名称',
  `contact` varchar(255) NULL COMMENT '联系人',
  `mobile` varchar(255) NULL COMMENT '手机号码',
  `telephone` varchar(255) NULL COMMENT '联系电话',
  `email` varchar(255) NULL COMMENT '电子邮箱',
  `fax` varchar(255) NULL COMMENT '传真',
  `remark` text NULL COMMENT '备注',
  `status` int NULL COMMENT '开启状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `sort` int NULL COMMENT '排序',
  `tax_no` varchar(255) NULL COMMENT '纳税人识别号',
  `tax_percent` decimal(24,6) NULL COMMENT '税率',
  `bank_name` varchar(255) NULL COMMENT '开户行',
  `bank_account` varchar(255) NULL COMMENT '开户账号',
  `bank_address` varchar(255) NULL COMMENT '开户地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 客户 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpSaleOrderDO.java
-- Entity: ErpSaleOrderDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), status int, customer_id bigint, account_id bigint, sale_user_id bigint, order_time datetime, total_count decimal(24,6), total_price decimal(24,6), total_product_price decimal(24,6), total_tax_price decimal(24,6), discount_percent decimal(24,6), discount_price decimal(24,6), deposit_price decimal(24,6), file_url varchar(1024), remark text, out_count decimal(24,6), return_count decimal(24,6)
CREATE TABLE `erp_sale_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `no` varchar(255) NULL COMMENT '销售订单号',
  `status` int NULL COMMENT '销售状态 枚举 cn.iocoder.yudao.module.erp.enums.ErpAuditStatus',
  `customer_id` bigint NULL COMMENT '客户编号 关联 ErpCustomerDO#getId()',
  `account_id` bigint NULL COMMENT '结算账户编号 关联 ErpAccountDO#getId()',
  `sale_user_id` bigint NULL COMMENT '销售员编号 关联 AdminUserDO 的 id 字段',
  `order_time` datetime NULL COMMENT '下单时间',
  `total_count` decimal(24,6) NULL COMMENT '合计数量',
  `total_price` decimal(24,6) NULL COMMENT '最终合计价格，单位：元 totalPrice = totalProductPrice + totalTaxPrice - discountPrice',
  `total_product_price` decimal(24,6) NULL COMMENT '合计产品价格，单位：元',
  `total_tax_price` decimal(24,6) NULL COMMENT '合计税额，单位：元',
  `discount_percent` decimal(24,6) NULL COMMENT '优惠率，百分比',
  `discount_price` decimal(24,6) NULL COMMENT '优惠金额，单位：元 discountPrice = (totalProductPrice + totalTaxPrice) * discountPercent',
  `deposit_price` decimal(24,6) NULL COMMENT '定金金额，单位：元',
  `file_url` varchar(1024) NULL COMMENT '附件地址',
  `remark` text NULL COMMENT '备注',
  `out_count` decimal(24,6) NULL COMMENT '销售出库数量',
  `return_count` decimal(24,6) NULL COMMENT '销售退货数量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 销售订单 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpSaleOrderItemDO.java
-- Entity: ErpSaleOrderItemDO extends BaseDO
-- 推断字段类型：id bigint, order_id bigint, product_id bigint, product_unit_id bigint, product_price decimal(24,6), count decimal(24,6), total_price decimal(24,6), tax_percent decimal(24,6), tax_price decimal(24,6), remark text, out_count decimal(24,6), return_count decimal(24,6)
CREATE TABLE `erp_sale_order_items` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `order_id` bigint NULL COMMENT '销售订单编号 关联 ErpSaleOrderDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 ErpProductDO#getId()',
  `product_unit_id` bigint NULL COMMENT '产品单位单位 冗余 ErpProductDO#getUnitId()',
  `product_price` decimal(24,6) NULL COMMENT '产品单位单价，单位：元',
  `count` decimal(24,6) NULL COMMENT '数量',
  `total_price` decimal(24,6) NULL COMMENT '总价，单位：元 totalPrice = productPrice * count',
  `tax_percent` decimal(24,6) NULL COMMENT '税率，百分比',
  `tax_price` decimal(24,6) NULL COMMENT '税额，单位：元 taxPrice = totalPrice * taxPercent',
  `remark` text NULL COMMENT '备注',
  `out_count` decimal(24,6) NULL COMMENT '销售出库数量',
  `return_count` decimal(24,6) NULL COMMENT '销售退货数量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 销售订单项 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpSaleOutDO.java
-- Entity: ErpSaleOutDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), status int, customer_id bigint, account_id bigint, sale_user_id bigint, out_time datetime, order_id bigint, order_no varchar(255), total_count decimal(24,6), total_price decimal(24,6), receipt_price decimal(24,6), total_product_price decimal(24,6), total_tax_price decimal(24,6), discount_percent decimal(24,6), discount_price decimal(24,6), other_price decimal(24,6), file_url varchar(1024), remark text
CREATE TABLE `erp_sale_out` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `no` varchar(255) NULL COMMENT '销售出库单号',
  `status` int NULL COMMENT '出库状态 枚举 cn.iocoder.yudao.module.erp.enums.ErpAuditStatus',
  `customer_id` bigint NULL COMMENT '客户编号 关联 ErpCustomerDO#getId()',
  `account_id` bigint NULL COMMENT '结算账户编号 关联 ErpAccountDO#getId()',
  `sale_user_id` bigint NULL COMMENT '销售员编号 关联 AdminUserDO 的 id 字段',
  `out_time` datetime NULL COMMENT '出库时间',
  `order_id` bigint NULL COMMENT '销售订单编号 关联 ErpSaleOrderDO#getId()',
  `order_no` varchar(255) NULL COMMENT '销售订单号 冗余 ErpSaleOrderDO#getNo()',
  `total_count` decimal(24,6) NULL COMMENT '合计数量',
  `total_price` decimal(24,6) NULL COMMENT '最终合计价格，单位：元 totalPrice = totalProductPrice + totalTaxPrice - discountPrice + otherPrice',
  `receipt_price` decimal(24,6) NULL COMMENT '已收款金额，单位：元 目的：和 cn.iocoder.yudao.module.erp.dal.dataobject.finance.ErpFinanceReceiptDO 结合，记录已收款金额',
  `total_product_price` decimal(24,6) NULL COMMENT '合计产品价格，单位：元',
  `total_tax_price` decimal(24,6) NULL COMMENT '合计税额，单位：元',
  `discount_percent` decimal(24,6) NULL COMMENT '优惠率，百分比',
  `discount_price` decimal(24,6) NULL COMMENT '优惠金额，单位：元 discountPrice = (totalProductPrice + totalTaxPrice) * discountPercent',
  `other_price` decimal(24,6) NULL COMMENT '其它金额，单位：元',
  `file_url` varchar(1024) NULL COMMENT '附件地址',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 销售出库 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpSaleOutItemDO.java
-- Entity: ErpSaleOutItemDO extends BaseDO
-- 推断字段类型：id bigint, out_id bigint, order_item_id bigint, warehouse_id bigint, product_id bigint, product_unit_id bigint, product_price decimal(24,6), count decimal(24,6), total_price decimal(24,6), tax_percent decimal(24,6), tax_price decimal(24,6), remark text
CREATE TABLE `erp_sale_out_items` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `out_id` bigint NULL COMMENT '销售出库编号 关联 ErpStockOutDO##getId()',
  `order_item_id` bigint NULL COMMENT '销售订单项编号 关联 ErpSaleOrderItemDO#getId() 目的：方便更新关联的销售订单项的出库数量',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 ErpWarehouseDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 ErpProductDO#getId()',
  `product_unit_id` bigint NULL COMMENT '产品单位单位 冗余 ErpProductDO#getUnitId()',
  `product_price` decimal(24,6) NULL COMMENT '产品单位单价，单位：元',
  `count` decimal(24,6) NULL COMMENT '数量',
  `total_price` decimal(24,6) NULL COMMENT '总价，单位：元 totalPrice = productPrice * count',
  `tax_percent` decimal(24,6) NULL COMMENT '税率，百分比',
  `tax_price` decimal(24,6) NULL COMMENT '税额，单位：元 taxPrice = totalPrice * taxPercent',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 销售出库项 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpSaleReturnDO.java
-- Entity: ErpSaleReturnDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), status int, customer_id bigint, account_id bigint, sale_user_id bigint, return_time datetime, order_id bigint, order_no varchar(255), total_count decimal(24,6), total_price decimal(24,6), refund_price decimal(24,6), total_product_price decimal(24,6), total_tax_price decimal(24,6), discount_percent decimal(24,6), discount_price decimal(24,6), other_price decimal(24,6), file_url varchar(1024), remark text
CREATE TABLE `erp_sale_return` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `no` varchar(255) NULL COMMENT '销售退货单号',
  `status` int NULL COMMENT '退货状态 枚举 cn.iocoder.yudao.module.erp.enums.ErpAuditStatus',
  `customer_id` bigint NULL COMMENT '客户编号 关联 ErpCustomerDO#getId()',
  `account_id` bigint NULL COMMENT '结算账户编号 关联 ErpAccountDO#getId()',
  `sale_user_id` bigint NULL COMMENT '销售员编号 关联 AdminUserDO 的 id 字段',
  `return_time` datetime NULL COMMENT '退货时间',
  `order_id` bigint NULL COMMENT '销售订单编号 关联 ErpSaleOrderDO#getId()',
  `order_no` varchar(255) NULL COMMENT '销售订单号 冗余 ErpSaleOrderDO#getNo()',
  `total_count` decimal(24,6) NULL COMMENT '合计数量',
  `total_price` decimal(24,6) NULL COMMENT '最终合计价格，单位：元 totalPrice = totalProductPrice + totalTaxPrice - discountPrice + otherPrice',
  `refund_price` decimal(24,6) NULL COMMENT '已退款金额，单位：元 目的：和 cn.iocoder.yudao.module.erp.dal.dataobject.finance.ErpFinanceReceiptDO 结合，记录已退款金额',
  `total_product_price` decimal(24,6) NULL COMMENT '合计产品价格，单位：元',
  `total_tax_price` decimal(24,6) NULL COMMENT '合计税额，单位：元',
  `discount_percent` decimal(24,6) NULL COMMENT '优惠率，百分比',
  `discount_price` decimal(24,6) NULL COMMENT '优惠金额，单位：元 discountPrice = (totalProductPrice + totalTaxPrice) * discountPercent',
  `other_price` decimal(24,6) NULL COMMENT '其它金额，单位：元',
  `file_url` varchar(1024) NULL COMMENT '附件地址',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 销售退货 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpSaleReturnItemDO.java
-- Entity: ErpSaleReturnItemDO extends BaseDO
-- 推断字段类型：id bigint, return_id bigint, order_item_id bigint, warehouse_id bigint, product_id bigint, product_unit_id bigint, product_price decimal(24,6), count decimal(24,6), total_price decimal(24,6), tax_percent decimal(24,6), tax_price decimal(24,6), remark text
CREATE TABLE `erp_sale_return_items` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `return_id` bigint NULL COMMENT '销售退货编号 关联 ErpSaleReturnDO##getId()',
  `order_item_id` bigint NULL COMMENT '销售订单项编号 关联 ErpSaleOrderItemDO#getId() 目的：方便更新关联的销售订单项的退货数量',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 ErpWarehouseDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 ErpProductDO#getId()',
  `product_unit_id` bigint NULL COMMENT '产品单位单位 冗余 ErpProductDO#getUnitId()',
  `product_price` decimal(24,6) NULL COMMENT '产品单位单价，单位：元',
  `count` decimal(24,6) NULL COMMENT '数量',
  `total_price` decimal(24,6) NULL COMMENT '总价，单位：元 totalPrice = productPrice * count',
  `tax_percent` decimal(24,6) NULL COMMENT '税率，百分比',
  `tax_price` decimal(24,6) NULL COMMENT '税额，单位：元 taxPrice = totalPrice * taxPercent',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 销售退货项 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockCheckDO.java
-- Entity: ErpStockCheckDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), check_time datetime, total_count decimal(24,6), total_price decimal(24,6), status int, remark text, file_url varchar(1024)
CREATE TABLE `erp_stock_check` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '盘点编号',
  `no` varchar(255) NULL COMMENT '盘点单号',
  `check_time` datetime NULL COMMENT '盘点时间',
  `total_count` decimal(24,6) NULL COMMENT '合计数量',
  `total_price` decimal(24,6) NULL COMMENT '合计金额，单位：元',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.module.erp.enums.ErpAuditStatus',
  `remark` text NULL COMMENT '备注',
  `file_url` varchar(1024) NULL COMMENT '附件 URL',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 库存盘点单 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockCheckItemDO.java
-- Entity: ErpStockCheckItemDO extends BaseDO
-- 推断字段类型：id bigint, check_id bigint, warehouse_id bigint, product_id bigint, product_unit_id bigint, product_price decimal(24,6), stock_count decimal(24,6), actual_count decimal(24,6), count decimal(24,6), total_price decimal(24,6), remark text
CREATE TABLE `erp_stock_check_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '盘点项编号',
  `check_id` bigint NULL COMMENT '盘点编号 关联 ErpStockCheckDO#getId()',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 ErpWarehouseDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 ErpProductDO#getId()',
  `product_unit_id` bigint NULL COMMENT '产品单位编号 冗余 ErpProductDO#getUnitId()',
  `product_price` decimal(24,6) NULL COMMENT '产品单价',
  `stock_count` decimal(24,6) NULL COMMENT '账面数量（当前库存）',
  `actual_count` decimal(24,6) NULL COMMENT '实际数量（实际库存）',
  `count` decimal(24,6) NULL COMMENT '盈亏数量 count = stockCount - actualCount',
  `total_price` decimal(24,6) NULL COMMENT '合计金额，单位：元',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 库存盘点单项 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockDO.java
-- Entity: ErpStockDO extends BaseDO
-- 推断字段类型：id bigint, product_id bigint, warehouse_id bigint, count decimal(24,6)
CREATE TABLE `erp_stock` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `product_id` bigint NULL COMMENT '产品编号 关联 ErpProductDO#getId()',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 ErpWarehouseDO#getId()',
  `count` decimal(24,6) NULL COMMENT '库存数量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 产品库存 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockInDO.java
-- Entity: ErpStockInDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), supplier_id bigint, in_time datetime, total_count decimal(24,6), total_price decimal(24,6), status int, remark text, file_url varchar(1024)
CREATE TABLE `erp_stock_in` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '入库编号',
  `no` varchar(255) NULL COMMENT '入库单号',
  `supplier_id` bigint NULL COMMENT '供应商编号 关联 ErpSupplierDO#getId()',
  `in_time` datetime NULL COMMENT '入库时间',
  `total_count` decimal(24,6) NULL COMMENT '合计数量',
  `total_price` decimal(24,6) NULL COMMENT '合计金额，单位：元',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.module.erp.enums.ErpAuditStatus',
  `remark` text NULL COMMENT '备注',
  `file_url` varchar(1024) NULL COMMENT '附件 URL',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 其它入库单 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockInItemDO.java
-- Entity: ErpStockInItemDO extends BaseDO
-- 推断字段类型：id bigint, in_id bigint, warehouse_id bigint, product_id bigint, product_unit_id bigint, product_price decimal(24,6), count decimal(24,6), total_price decimal(24,6), remark text
CREATE TABLE `erp_stock_in_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '入库项编号',
  `in_id` bigint NULL COMMENT '入库编号 关联 ErpStockInDO#getId()',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 ErpWarehouseDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 ErpProductDO#getId()',
  `product_unit_id` bigint NULL COMMENT '产品单位编号 冗余 ErpProductDO#getUnitId()',
  `product_price` decimal(24,6) NULL COMMENT '产品单价',
  `count` decimal(24,6) NULL COMMENT '产品数量',
  `total_price` decimal(24,6) NULL COMMENT '合计金额，单位：元',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 其它入库单项 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockMoveDO.java
-- Entity: ErpStockMoveDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), move_time datetime, total_count decimal(24,6), total_price decimal(24,6), status int, remark text, file_url varchar(1024)
CREATE TABLE `erp_stock_move` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '调拨编号',
  `no` varchar(255) NULL COMMENT '调拨单号',
  `move_time` datetime NULL COMMENT '调拨时间',
  `total_count` decimal(24,6) NULL COMMENT '合计数量',
  `total_price` decimal(24,6) NULL COMMENT '合计金额，单位：元',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.module.erp.enums.ErpAuditStatus',
  `remark` text NULL COMMENT '备注',
  `file_url` varchar(1024) NULL COMMENT '附件 URL',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 库存调拨单 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockMoveItemDO.java
-- Entity: ErpStockMoveItemDO extends BaseDO
-- 推断字段类型：id bigint, move_id bigint, from_warehouse_id bigint, to_warehouse_id bigint, product_id bigint, product_unit_id bigint, product_price decimal(24,6), count decimal(24,6), total_price decimal(24,6), remark text
CREATE TABLE `erp_stock_move_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '调拨项编号',
  `move_id` bigint NULL COMMENT '调拨编号 关联 ErpStockMoveDO#getId()',
  `from_warehouse_id` bigint NULL COMMENT '调出仓库编号 关联 ErpWarehouseDO#getId()',
  `to_warehouse_id` bigint NULL COMMENT '调入仓库编号 关联 ErpWarehouseDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 ErpProductDO#getId()',
  `product_unit_id` bigint NULL COMMENT '产品单位编号 冗余 ErpProductDO#getUnitId()',
  `product_price` decimal(24,6) NULL COMMENT '产品单价',
  `count` decimal(24,6) NULL COMMENT '产品数量',
  `total_price` decimal(24,6) NULL COMMENT '合计金额，单位：元',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 库存调拨单项 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockOutDO.java
-- Entity: ErpStockOutDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), customer_id bigint, out_time datetime, total_count decimal(24,6), total_price decimal(24,6), status int, remark text, file_url varchar(1024)
CREATE TABLE `erp_stock_out` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '出库编号',
  `no` varchar(255) NULL COMMENT '出库单号',
  `customer_id` bigint NULL COMMENT '客户编号 TODO 芋艿：待关联',
  `out_time` datetime NULL COMMENT '出库时间',
  `total_count` decimal(24,6) NULL COMMENT '合计数量',
  `total_price` decimal(24,6) NULL COMMENT '合计金额，单位：元',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.module.erp.enums.ErpAuditStatus',
  `remark` text NULL COMMENT '备注',
  `file_url` varchar(1024) NULL COMMENT '附件 URL',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 其它出库单 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockOutItemDO.java
-- Entity: ErpStockOutItemDO extends BaseDO
-- 推断字段类型：id bigint, out_id bigint, warehouse_id bigint, product_id bigint, product_unit_id bigint, product_price decimal(24,6), count decimal(24,6), total_price decimal(24,6), remark text
CREATE TABLE `erp_stock_out_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '出库项编号',
  `out_id` bigint NULL COMMENT '出库编号 关联 ErpStockOutDO#getId()',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 ErpWarehouseDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 ErpProductDO#getId()',
  `product_unit_id` bigint NULL COMMENT '产品单位编号 冗余 ErpProductDO#getUnitId()',
  `product_price` decimal(24,6) NULL COMMENT '产品单价',
  `count` decimal(24,6) NULL COMMENT '产品数量',
  `total_price` decimal(24,6) NULL COMMENT '合计金额，单位：元',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 其它出库单项 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockRecordDO.java
-- Entity: ErpStockRecordDO extends BaseDO
-- 推断字段类型：id bigint, product_id bigint, warehouse_id bigint, count decimal(24,6), total_count decimal(24,6), biz_type int, biz_id bigint, biz_item_id bigint, biz_no varchar(255)
CREATE TABLE `erp_stock_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `product_id` bigint NULL COMMENT '产品编号 关联 ErpProductDO#getId()',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 ErpWarehouseDO#getId()',
  `count` decimal(24,6) NULL COMMENT '出入库数量 正数，表示入库；负数，表示出库',
  `total_count` decimal(24,6) NULL COMMENT '总库存量 出入库之后，目前的库存量',
  `biz_type` int NULL COMMENT '业务类型 枚举 ErpStockRecordBizTypeEnum',
  `biz_id` bigint NULL COMMENT '业务编号 例如说：ErpStockInDO#getId()',
  `biz_item_id` bigint NULL COMMENT '业务项编号 例如说：ErpStockInItemDO#getId()',
  `biz_no` varchar(255) NULL COMMENT '业务单号 例如说：ErpStockInDO#getNo()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 产品库存明细 DO';

-- Source: yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpWarehouseDO.java
-- Entity: ErpWarehouseDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), address varchar(255), sort bigint, remark text, principal varchar(255), warehouse_price decimal(24,6), truckage_price decimal(24,6), status int, default_status bit(1)
CREATE TABLE `erp_warehouse` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '仓库编号',
  `name` varchar(255) NULL COMMENT '仓库名称',
  `address` varchar(255) NULL COMMENT '仓库地址',
  `sort` bigint NULL COMMENT '排序',
  `remark` text NULL COMMENT '备注',
  `principal` varchar(255) NULL COMMENT '负责人',
  `warehouse_price` decimal(24,6) NULL COMMENT '仓储费，单位：元',
  `truckage_price` decimal(24,6) NULL COMMENT '搬运费，单位：元',
  `status` int NULL COMMENT '开启状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `default_status` bit(1) NULL COMMENT '是否默认',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ERP 仓库 DO';
