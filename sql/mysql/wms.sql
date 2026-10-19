-- WMS 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/inventory/WmsInventoryDO.java
-- Entity: WmsInventoryDO extends BaseDO
-- 推断字段类型：id bigint, sku_id bigint, warehouse_id bigint, quantity decimal(24,6), remark text
CREATE TABLE `wms_inventory` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号 关联 WmsItemSkuDO#getId()',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 WmsWarehouseDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '库存数量',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 库存 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/inventory/WmsInventoryHistoryDO.java
-- Entity: WmsInventoryHistoryDO extends BaseDO
-- 推断字段类型：id bigint, warehouse_id bigint, sku_id bigint, quantity decimal(24,6), before_quantity decimal(24,6), after_quantity decimal(24,6), price decimal(24,6), total_price decimal(24,6), remark text, order_id bigint, order_no varchar(255), order_type int
CREATE TABLE `wms_inventory_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 WmsWarehouseDO#getId()',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号 关联 WmsItemSkuDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '库存变化数量',
  `before_quantity` decimal(24,6) NULL COMMENT '变化前库存数量',
  `after_quantity` decimal(24,6) NULL COMMENT '变化后库存数量',
  `price` decimal(24,6) NULL COMMENT '单价',
  `total_price` decimal(24,6) NULL COMMENT '库存变化金额',
  `remark` text NULL COMMENT '备注',
  `order_id` bigint NULL COMMENT '单据编号',
  `order_no` varchar(255) NULL COMMENT '单据号',
  `order_type` int NULL COMMENT '单据类型 枚举 WmsOrderTypeEnum#getType()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 库存流水 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/md/item/WmsItemBrandDO.java
-- Entity: WmsItemBrandDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255)
CREATE TABLE `wms_item_brand` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `code` varchar(255) NULL COMMENT '品牌编号',
  `name` varchar(255) NULL COMMENT '品牌名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 商品品牌 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/md/item/WmsItemCategoryDO.java
-- Entity: WmsItemCategoryDO extends BaseDO
-- 推断字段类型：id bigint, parent_id bigint, code varchar(255), name varchar(255), sort int, status int
CREATE TABLE `wms_item_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `parent_id` bigint NULL COMMENT '父级编号 关联 #id',
  `code` varchar(255) NULL COMMENT '分类编号',
  `name` varchar(255) NULL COMMENT '分类名称',
  `sort` int NULL COMMENT '排序',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 商品分类 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/md/item/WmsItemDO.java
-- Entity: WmsItemDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), unit varchar(255), category_id bigint, brand_id bigint, remark text
CREATE TABLE `wms_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `code` varchar(255) NULL COMMENT '商品编号',
  `name` varchar(255) NULL COMMENT '商品名称',
  `unit` varchar(255) NULL COMMENT '单位',
  `category_id` bigint NULL COMMENT '商品分类编号 关联 WmsItemCategoryDO#getId()',
  `brand_id` bigint NULL COMMENT '商品品牌编号 关联 WmsItemBrandDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 商品 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/md/item/WmsItemSkuDO.java
-- Entity: WmsItemSkuDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), item_id bigint, bar_code varchar(255), code varchar(255), length decimal(24,6), width decimal(24,6), height decimal(24,6), gross_weight decimal(24,6), net_weight decimal(24,6), cost_price decimal(24,6), selling_price decimal(24,6)
CREATE TABLE `wms_item_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `name` varchar(255) NULL COMMENT '规格名称',
  `item_id` bigint NULL COMMENT '商品编号 关联 WmsItemDO#getId()',
  `bar_code` varchar(255) NULL COMMENT '条码',
  `code` varchar(255) NULL COMMENT '规格编号',
  `length` decimal(24,6) NULL COMMENT '长，单位 cm',
  `width` decimal(24,6) NULL COMMENT '宽，单位 cm',
  `height` decimal(24,6) NULL COMMENT '高，单位 cm',
  `gross_weight` decimal(24,6) NULL COMMENT '毛重，单位 kg',
  `net_weight` decimal(24,6) NULL COMMENT '净重，单位 kg',
  `cost_price` decimal(24,6) NULL COMMENT '成本价，单位元',
  `selling_price` decimal(24,6) NULL COMMENT '销售价，单位元',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 商品 SKU DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/md/merchant/WmsMerchantDO.java
-- Entity: WmsMerchantDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), type int, level varchar(255), bank_name varchar(255), bank_account varchar(255), address varchar(255), mobile varchar(255), telephone varchar(255), contact varchar(255), email varchar(255), remark text
CREATE TABLE `wms_merchant` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `code` varchar(255) NULL COMMENT '往来企业编号',
  `name` varchar(255) NULL COMMENT '往来企业名称',
  `type` int NULL COMMENT '往来企业类型 枚举 WmsMerchantTypeEnum',
  `level` varchar(255) NULL COMMENT '级别',
  `bank_name` varchar(255) NULL COMMENT '开户行',
  `bank_account` varchar(255) NULL COMMENT '银行账户',
  `address` varchar(255) NULL COMMENT '地址',
  `mobile` varchar(255) NULL COMMENT '手机号',
  `telephone` varchar(255) NULL COMMENT '座机号',
  `contact` varchar(255) NULL COMMENT '联系人',
  `email` varchar(255) NULL COMMENT 'Email',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 往来企业 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/md/warehouse/WmsWarehouseDO.java
-- Entity: WmsWarehouseDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), remark text, sort int
CREATE TABLE `wms_warehouse` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `code` varchar(255) NULL COMMENT '仓库编号',
  `name` varchar(255) NULL COMMENT '名称',
  `remark` text NULL COMMENT '备注',
  `sort` int NULL COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 仓库 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/check/WmsCheckOrderDO.java
-- Entity: WmsCheckOrderDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), order_time datetime, status int, remark text, warehouse_id bigint, total_quantity decimal(24,6), total_price decimal(24,6), actual_price decimal(24,6)
CREATE TABLE `wms_check_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `no` varchar(255) NULL COMMENT '盘库单号',
  `order_time` datetime NULL COMMENT '单据日期',
  `status` int NULL COMMENT '盘库状态 字典 DictTypeConstants#ORDER_STATUS',
  `remark` text NULL COMMENT '备注',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 WmsWarehouseDO#getId()',
  `total_quantity` decimal(24,6) NULL COMMENT '盈亏数量（实盘数量 - 账面数量）',
  `total_price` decimal(24,6) NULL COMMENT '总金额（账面数量 * 单价）',
  `actual_price` decimal(24,6) NULL COMMENT '实际金额（实盘数量 * 单价）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 盘库单 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/check/WmsCheckOrderDetailDO.java
-- Entity: WmsCheckOrderDetailDO extends BaseDO
-- 推断字段类型：id bigint, order_id bigint, sku_id bigint, warehouse_id bigint, inventory_id bigint, receipt_time datetime, quantity decimal(24,6), check_quantity decimal(24,6), price decimal(24,6)
CREATE TABLE `wms_check_order_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `order_id` bigint NULL COMMENT '盘库单编号 关联 WmsCheckOrderDO#getId()',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号 关联 WmsItemSkuDO#getId()',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 WmsWarehouseDO#getId()',
  `inventory_id` bigint NULL COMMENT '库存编号 关联 WmsInventoryDO#getId()',
  `receipt_time` datetime NULL COMMENT '入库时间',
  `quantity` decimal(24,6) NULL COMMENT '账面数量',
  `check_quantity` decimal(24,6) NULL COMMENT '实盘数量',
  `price` decimal(24,6) NULL COMMENT '单价',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 盘库单明细 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/movement/WmsMovementOrderDO.java
-- Entity: WmsMovementOrderDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), order_time datetime, status int, remark text, source_warehouse_id bigint, target_warehouse_id bigint, total_quantity decimal(24,6), total_price decimal(24,6)
CREATE TABLE `wms_movement_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `no` varchar(255) NULL COMMENT '移库单号',
  `order_time` datetime NULL COMMENT '单据日期',
  `status` int NULL COMMENT '移库状态 字典 DictTypeConstants#ORDER_STATUS',
  `remark` text NULL COMMENT '备注',
  `source_warehouse_id` bigint NULL COMMENT '来源仓库编号 关联 WmsWarehouseDO#getId()',
  `target_warehouse_id` bigint NULL COMMENT '目标仓库编号 关联 WmsWarehouseDO#getId()',
  `total_quantity` decimal(24,6) NULL COMMENT '总数量',
  `total_price` decimal(24,6) NULL COMMENT '总金额',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 移库单 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/movement/WmsMovementOrderDetailDO.java
-- Entity: WmsMovementOrderDetailDO extends BaseDO
-- 推断字段类型：id bigint, order_id bigint, sku_id bigint, source_warehouse_id bigint, target_warehouse_id bigint, quantity decimal(24,6), price decimal(24,6), total_price decimal(24,6)
CREATE TABLE `wms_movement_order_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `order_id` bigint NULL COMMENT '移库单编号 关联 WmsMovementOrderDO#getId()',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号 关联 WmsItemSkuDO#getId()',
  `source_warehouse_id` bigint NULL COMMENT '来源仓库编号 关联 WmsWarehouseDO#getId()',
  `target_warehouse_id` bigint NULL COMMENT '目标仓库编号 关联 WmsWarehouseDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '移库数量',
  `price` decimal(24,6) NULL COMMENT '单价',
  `total_price` decimal(24,6) NULL COMMENT '行金额（数量 * 单价）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 移库单明细 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/receipt/WmsReceiptOrderDO.java
-- Entity: WmsReceiptOrderDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), type int, order_time datetime, status int, biz_order_no varchar(255), merchant_id bigint, remark text, warehouse_id bigint, total_quantity decimal(24,6), total_price decimal(24,6)
CREATE TABLE `wms_receipt_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `no` varchar(255) NULL COMMENT '入库单号',
  `type` int NULL COMMENT '入库类型 枚举 WmsReceiptOrderTypeEnum 字典 DictTypeConstants#RECEIPT_ORDER_TYPE',
  `order_time` datetime NULL COMMENT '单据日期',
  `status` int NULL COMMENT '入库状态 字典 DictTypeConstants#ORDER_STATUS',
  `biz_order_no` varchar(255) NULL COMMENT '业务订单号',
  `merchant_id` bigint NULL COMMENT '供应商编号 关联 WmsMerchantDO#getId()',
  `remark` text NULL COMMENT '备注',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 WmsWarehouseDO#getId()',
  `total_quantity` decimal(24,6) NULL COMMENT '总数量',
  `total_price` decimal(24,6) NULL COMMENT '总金额',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 入库单 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/receipt/WmsReceiptOrderDetailDO.java
-- Entity: WmsReceiptOrderDetailDO extends BaseDO
-- 推断字段类型：id bigint, order_id bigint, sku_id bigint, warehouse_id bigint, quantity decimal(24,6), price decimal(24,6), total_price decimal(24,6)
CREATE TABLE `wms_receipt_order_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `order_id` bigint NULL COMMENT '入库单编号 关联 WmsReceiptOrderDO#getId()',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号 关联 WmsItemSkuDO#getId()',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 WmsWarehouseDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '入库数量',
  `price` decimal(24,6) NULL COMMENT '单价',
  `total_price` decimal(24,6) NULL COMMENT '行金额（数量 * 单价）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 入库单明细 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/shipment/WmsShipmentOrderDO.java
-- Entity: WmsShipmentOrderDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), type int, order_time datetime, status int, biz_order_no varchar(255), merchant_id bigint, remark text, warehouse_id bigint, total_quantity decimal(24,6), total_price decimal(24,6)
CREATE TABLE `wms_shipment_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `no` varchar(255) NULL COMMENT '出库单号',
  `type` int NULL COMMENT '出库类型 枚举 WmsShipmentOrderTypeEnum 字典 DictTypeConstants#SHIPMENT_ORDER_TYPE',
  `order_time` datetime NULL COMMENT '单据日期',
  `status` int NULL COMMENT '出库状态 字典 DictTypeConstants#ORDER_STATUS',
  `biz_order_no` varchar(255) NULL COMMENT '业务订单号',
  `merchant_id` bigint NULL COMMENT '客户编号 关联 WmsMerchantDO#getId()',
  `remark` text NULL COMMENT '备注',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 WmsWarehouseDO#getId()',
  `total_quantity` decimal(24,6) NULL COMMENT '总数量',
  `total_price` decimal(24,6) NULL COMMENT '总金额',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 出库单 DO';

-- Source: yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/shipment/WmsShipmentOrderDetailDO.java
-- Entity: WmsShipmentOrderDetailDO extends BaseDO
-- 推断字段类型：id bigint, order_id bigint, sku_id bigint, warehouse_id bigint, quantity decimal(24,6), price decimal(24,6), total_price decimal(24,6)
CREATE TABLE `wms_shipment_order_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号',
  `order_id` bigint NULL COMMENT '出库单编号 关联 WmsShipmentOrderDO#getId()',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号 关联 WmsItemSkuDO#getId()',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 WmsWarehouseDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '出库数量',
  `price` decimal(24,6) NULL COMMENT '单价',
  `total_price` decimal(24,6) NULL COMMENT '行金额（数量 * 单价）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WMS 出库单明细 DO';
