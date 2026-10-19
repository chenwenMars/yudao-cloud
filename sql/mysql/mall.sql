-- MALL 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/brand/ProductBrandDO.java
-- Entity: ProductBrandDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), pic_url varchar(1024), sort int, description text, status int
CREATE TABLE `product_brand` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '品牌编号',
  `name` varchar(255) NULL COMMENT '品牌名称',
  `pic_url` varchar(1024) NULL COMMENT '品牌图片',
  `sort` int NULL COMMENT '品牌排序',
  `description` text NULL COMMENT '品牌描述',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品品牌 DO';

-- Source: yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/category/ProductCategoryDO.java
-- Entity: ProductCategoryDO extends BaseDO
-- 推断字段类型：id bigint, parent_id bigint, name varchar(255), pic_url varchar(1024), sort int, status int
CREATE TABLE `product_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类编号',
  `parent_id` bigint NULL COMMENT '父分类编号',
  `name` varchar(255) NULL COMMENT '分类名称',
  `pic_url` varchar(1024) NULL COMMENT '移动端分类图 建议 180*180 分辨率',
  `sort` int NULL COMMENT '分类排序',
  `status` int NULL COMMENT '开启状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品分类 DO';

-- Source: yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/comment/ProductCommentDO.java
-- Entity: ProductCommentDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, user_nickname varchar(255), user_avatar varchar(255), anonymous bit(1), order_id bigint, order_item_id bigint, spu_id bigint, spu_name varchar(255), sku_id bigint, sku_pic_url varchar(1024), sku_properties json, visible bit(1), scores int, description_scores int, benefit_scores int, content text, pic_urls json, reply_status bit(1), reply_user_id bigint, reply_content text, reply_time datetime
CREATE TABLE `product_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论编号，主键自增',
  `user_id` bigint NULL COMMENT '评价人的用户编号 关联 MemberUserDO 的 id 编号',
  `user_nickname` varchar(255) NULL COMMENT '评价人名称',
  `user_avatar` varchar(255) NULL COMMENT '评价人头像',
  `anonymous` bit(1) NULL COMMENT '是否匿名',
  `order_id` bigint NULL COMMENT '交易订单编号 关联 TradeOrderDO 的 id 编号',
  `order_item_id` bigint NULL COMMENT '交易订单项编号 关联 TradeOrderItemDO 的 id 编号',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号 关联 ProductSpuDO#getId()',
  `spu_name` varchar(255) NULL COMMENT '商品 SPU 名称 关联 ProductSpuDO#getName()',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号 关联 ProductSkuDO#getId()',
  `sku_pic_url` varchar(1024) NULL COMMENT '商品 SKU 图片地址 关联 ProductSkuDO#getPicUrl()',
  `sku_properties` json NULL COMMENT '属性数组，JSON 格式 关联 ProductSkuDO#getProperties()',
  `visible` bit(1) NULL COMMENT '是否可见 true:显示 false:隐藏',
  `scores` int NULL COMMENT '评分星级 1-5 分',
  `description_scores` int NULL COMMENT '描述星级 1-5 星',
  `benefit_scores` int NULL COMMENT '服务星级 1-5 星',
  `content` text NULL COMMENT '评论内容',
  `pic_urls` json NULL COMMENT '评论图片地址数组',
  `reply_status` bit(1) NULL COMMENT '商家是否回复',
  `reply_user_id` bigint NULL COMMENT '回复管理员编号 关联 AdminUserDO 的 id 编号',
  `reply_content` text NULL COMMENT '商家回复内容',
  `reply_time` datetime NULL COMMENT '商家回复时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品评论 DO';

-- Source: yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/favorite/ProductFavoriteDO.java
-- Entity: ProductFavoriteDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, spu_id bigint
CREATE TABLE `product_favorite` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，主键自增',
  `user_id` bigint NULL COMMENT '用户编号 关联 MemberUserDO 的 id 编号',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号 关联 ProductSpuDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品收藏 DO';

-- Source: yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/history/ProductBrowseHistoryDO.java
-- Entity: ProductBrowseHistoryDO extends BaseDO
-- 推断字段类型：id bigint, spu_id bigint, user_id bigint, user_deleted bit(1)
CREATE TABLE `product_browse_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录编号',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号',
  `user_id` bigint NULL COMMENT '用户编号',
  `user_deleted` bit(1) NULL COMMENT '用户是否删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品浏览记录 DO';

-- Source: yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/property/ProductPropertyDO.java
-- Entity: ProductPropertyDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), remark text
CREATE TABLE `product_property` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) NULL COMMENT '名称',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品属性项 DO';

-- Source: yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/property/ProductPropertyValueDO.java
-- Entity: ProductPropertyValueDO extends BaseDO
-- 推断字段类型：id bigint, property_id bigint, name varchar(255), remark text
CREATE TABLE `product_property_value` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `property_id` bigint NULL COMMENT '属性项的编号 关联 ProductPropertyDO#getId()',
  `name` varchar(255) NULL COMMENT '名称',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品属性值 DO';

-- Source: yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/sku/ProductSkuDO.java
-- Entity: ProductSkuDO extends BaseDO
-- 推断字段类型：id bigint, spu_id bigint, properties json, price int, market_price int, cost_price int, bar_code varchar(255), pic_url varchar(1024), stock int, weight double, volume double, first_brokerage_price int, second_brokerage_price int, sales_count int
CREATE TABLE `product_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品 SKU 编号，自增',
  `spu_id` bigint NULL COMMENT 'SPU 编号 关联 ProductSpuDO#getId()',
  `properties` json NULL COMMENT '属性数组，JSON 格式',
  `price` int NULL COMMENT '商品价格，单位：分',
  `market_price` int NULL COMMENT '市场价，单位：分',
  `cost_price` int NULL COMMENT '成本价，单位：分',
  `bar_code` varchar(255) NULL COMMENT '商品条码',
  `pic_url` varchar(1024) NULL COMMENT '图片地址',
  `stock` int NULL COMMENT '库存',
  `weight` double NULL COMMENT '商品重量，单位：kg 千克',
  `volume` double NULL COMMENT '商品体积，单位：m^3 平米',
  `first_brokerage_price` int NULL COMMENT '一级分销的佣金，单位：分',
  `second_brokerage_price` int NULL COMMENT '二级分销的佣金，单位：分',
  `sales_count` int NULL COMMENT '商品销量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品 SKU DO';

-- Source: yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/spu/ProductSpuDO.java
-- Entity: ProductSpuDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), keyword varchar(255), introduction varchar(255), description longtext, category_id bigint, brand_id bigint, pic_url varchar(1024), slider_pic_urls json, sort int, status int, spec_type bit(1), price int, market_price int, cost_price int, stock int, delivery_types text, delivery_template_id bigint, give_integral int, sub_commission_type bit(1), sales_count int, virtual_sales_count int, browse_count int
-- 特殊类型依据：product_spu.description 源实体为商品详情或文章正文富文本；LONGTEXT 容量为推断
CREATE TABLE `product_spu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品 SPU 编号，自增',
  `name` varchar(255) NULL COMMENT '商品名称',
  `keyword` varchar(255) NULL COMMENT '关键字',
  `introduction` varchar(255) NULL COMMENT '商品简介',
  `description` longtext NULL COMMENT '商品详情',
  `category_id` bigint NULL COMMENT '商品分类编号 关联 ProductCategoryDO#getId()',
  `brand_id` bigint NULL COMMENT '商品品牌编号 关联 ProductBrandDO#getId()',
  `pic_url` varchar(1024) NULL COMMENT '商品封面图',
  `slider_pic_urls` json NULL COMMENT '商品轮播图',
  `sort` int NULL COMMENT '排序字段',
  `status` int NULL COMMENT '商品状态 枚举 ProductSpuStatusEnum',
  `spec_type` bit(1) NULL COMMENT '规格类型 false - 单规格 true - 多规格',
  `price` int NULL COMMENT '商品价格，单位使用：分 基于其对应的 ProductSkuDO#getPrice() sku单价最低的商品的',
  `market_price` int NULL COMMENT '市场价，单位使用：分 基于其对应的 ProductSkuDO#getMarketPrice() sku单价最低的商品的',
  `cost_price` int NULL COMMENT '成本价，单位使用：分 基于其对应的 ProductSkuDO#getCostPrice() sku单价最低的商品的',
  `stock` int NULL COMMENT '库存 基于其对应的 ProductSkuDO#getStock() 求和',
  `delivery_types` text NULL COMMENT '配送方式数组 对应 DeliveryTypeEnum 枚举',
  `delivery_template_id` bigint NULL COMMENT '物流配置模板编号 对应 TradeDeliveryExpressTemplateDO 的 id 编号',
  `give_integral` int NULL COMMENT '赠送积分',
  `sub_commission_type` bit(1) NULL COMMENT '分销类型 false - 默认 true - 自行设置',
  `sales_count` int NULL COMMENT '商品销量',
  `virtual_sales_count` int NULL COMMENT '虚拟销量',
  `browse_count` int NULL COMMENT '浏览量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品 SPU DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/article/ArticleCategoryDO.java
-- Entity: ArticleCategoryDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), pic_url varchar(1024), status int, sort int
CREATE TABLE `promotion_article_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文章分类编号',
  `name` varchar(255) NULL COMMENT '文章分类名称',
  `pic_url` varchar(1024) NULL COMMENT '图标地址',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `sort` int NULL COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章分类 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/article/ArticleDO.java
-- Entity: ArticleDO extends BaseDO
-- 推断字段类型：id bigint, category_id bigint, spu_id bigint, title varchar(255), author varchar(255), pic_url varchar(1024), introduction varchar(255), browse_count int, sort int, status int, recommend_hot bit(1), recommend_banner bit(1), content longtext
-- 特殊类型依据：promotion_article.content 源实体为商品详情或文章正文富文本；LONGTEXT 容量为推断
CREATE TABLE `promotion_article` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文章管理编号',
  `category_id` bigint NULL COMMENT '分类编号 ArticleCategoryDO#id',
  `spu_id` bigint NULL COMMENT '关联商品编号 ProductSpuDO#id',
  `title` varchar(255) NULL COMMENT '文章标题',
  `author` varchar(255) NULL COMMENT '文章作者',
  `pic_url` varchar(1024) NULL COMMENT '文章封面图片地址',
  `introduction` varchar(255) NULL COMMENT '文章简介',
  `browse_count` int NULL COMMENT '浏览次数',
  `sort` int NULL COMMENT '排序',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `recommend_hot` bit(1) NULL COMMENT '是否热门(小程序)',
  `recommend_banner` bit(1) NULL COMMENT '是否轮播图(小程序)',
  `content` longtext NULL COMMENT '文章内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章管理 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/banner/BannerDO.java
-- Entity: BannerDO extends BaseDO
-- 推断字段类型：id bigint, title varchar(255), url varchar(1024), pic_url varchar(1024), sort int, status int, position int, memo varchar(255), browse_count int
CREATE TABLE `promotion_banner` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `title` varchar(255) NULL COMMENT '标题',
  `url` varchar(1024) NULL COMMENT '跳转链接',
  `pic_url` varchar(1024) NULL COMMENT '图片链接',
  `sort` int NULL COMMENT '排序',
  `status` int NULL COMMENT '状态 CommonStatusEnum',
  `position` int NULL COMMENT '定位 BannerPositionEnum',
  `memo` varchar(255) NULL COMMENT '备注',
  `browse_count` int NULL COMMENT '点击次数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='banner DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/bargain/BargainActivityDO.java
-- Entity: BargainActivityDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), start_time datetime, end_time datetime, status int, spu_id bigint, sku_id bigint, bargain_first_price int, bargain_min_price int, stock int, total_stock int, help_max_count int, bargain_count int, total_limit_count int, random_min_price int, random_max_price int
CREATE TABLE `promotion_bargain_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '砍价活动编号',
  `name` varchar(255) NULL COMMENT '砍价活动名称',
  `start_time` datetime NULL COMMENT '活动开始时间',
  `end_time` datetime NULL COMMENT '活动结束时间',
  `status` int NULL COMMENT '活动状态 枚举 CommonStatusEnum',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号',
  `bargain_first_price` int NULL COMMENT '砍价起始价格，单位：分',
  `bargain_min_price` int NULL COMMENT '砍价底价，单位：分',
  `stock` int NULL COMMENT '砍价库存(剩余库存砍价时扣减)',
  `total_stock` int NULL COMMENT '砍价总库存',
  `help_max_count` int NULL COMMENT '砍价人数 需要多少人，砍价才能成功，即 BargainRecordDO#getStatus() 更新为 BargainRecordDO#getStatus() 成功状态',
  `bargain_count` int NULL COMMENT '帮砍次数 单个活动，用户可以帮砍的次数。 例如说：帮砍次数为 1 时，A 和 B 同时将该活动链接发给 C，C 只能帮其中一个人砍价。',
  `total_limit_count` int NULL COMMENT '总限购数量',
  `random_min_price` int NULL COMMENT '用户每次砍价的最小金额，单位：分',
  `random_max_price` int NULL COMMENT '用户每次砍价的最大金额，单位：分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='砍价活动 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/bargain/BargainHelpDO.java
-- Entity: BargainHelpDO extends BaseDO
-- 推断字段类型：id bigint, activity_id bigint, record_id bigint, user_id bigint, reduce_price int
CREATE TABLE `promotion_bargain_help` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `activity_id` bigint NULL COMMENT '砍价活动编号 关联 BargainActivityDO#getId() 字段',
  `record_id` bigint NULL COMMENT '砍价记录编号 关联 BargainRecordDO#getId() 字段',
  `user_id` bigint NULL COMMENT '用户编号',
  `reduce_price` int NULL COMMENT '减少价格，单位：分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='砍价助力 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/bargain/BargainRecordDO.java
-- Entity: BargainRecordDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, activity_id bigint, spu_id bigint, sku_id bigint, bargain_first_price int, bargain_price int, status int, end_time datetime, order_id bigint
CREATE TABLE `promotion_bargain_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号',
  `activity_id` bigint NULL COMMENT '砍价活动编号 关联 BargainActivityDO#getId() 字段',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号',
  `bargain_first_price` int NULL COMMENT '砍价起始价格，单位：分',
  `bargain_price` int NULL COMMENT '当前砍价，单位：分',
  `status` int NULL COMMENT '砍价状态 砍价成功的条件是：（2 选 1） 1. 砍价到 BargainActivityDO#getBargainMinPrice() 底价 2. 助力人数到达 BargainActivityDO#getHelpMaxCount() 人 枚举 BargainRecordStatusEnum',
  `end_time` datetime NULL COMMENT '结束时间',
  `order_id` bigint NULL COMMENT '订单编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='砍价记录 DO TODO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/combination/CombinationActivityDO.java
-- Entity: CombinationActivityDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), spu_id bigint, total_limit_count int, single_limit_count int, start_time datetime, end_time datetime, user_size int, virtual_group bit(1), status int, limit_duration int
CREATE TABLE `promotion_combination_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动编号',
  `name` varchar(255) NULL COMMENT '拼团名称',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号 关联 ProductSpuDO 的 id',
  `total_limit_count` int NULL COMMENT '总限购数量',
  `single_limit_count` int NULL COMMENT '单次限购数量',
  `start_time` datetime NULL COMMENT '开始时间',
  `end_time` datetime NULL COMMENT '结束时间',
  `user_size` int NULL COMMENT '几人团',
  `virtual_group` bit(1) NULL COMMENT '虚拟成团',
  `status` int NULL COMMENT '活动状态 枚举 CommonStatusEnum',
  `limit_duration` int NULL COMMENT '限制时长（小时）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='拼团活动 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/combination/CombinationProductDO.java
-- Entity: CombinationProductDO extends BaseDO
-- 推断字段类型：id bigint, activity_id bigint, spu_id bigint, sku_id bigint, combination_price int, activity_status int, activity_start_time datetime, activity_end_time datetime
CREATE TABLE `promotion_combination_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `activity_id` bigint NULL COMMENT '拼团活动编号',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号',
  `combination_price` int NULL COMMENT '拼团价格，单位分',
  `activity_status` int NULL COMMENT '拼团商品状态 关联 CombinationActivityDO#getStatus()',
  `activity_start_time` datetime NULL COMMENT '活动开始时间点 冗余 CombinationActivityDO#getStartTime()',
  `activity_end_time` datetime NULL COMMENT '活动结束时间点 冗余 CombinationActivityDO#getEndTime()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='拼团商品 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/combination/CombinationRecordDO.java
-- Entity: CombinationRecordDO extends BaseDO
-- 推断字段类型：id bigint, activity_id bigint, combination_price int, spu_id bigint, spu_name varchar(255), pic_url varchar(1024), sku_id bigint, count int, user_id bigint, nickname varchar(255), avatar varchar(1024), head_id bigint, status int, order_id bigint, user_size int, user_count int, virtual_group bit(1), expire_time datetime, start_time datetime, end_time datetime
CREATE TABLE `promotion_combination_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，主键自增',
  `activity_id` bigint NULL COMMENT '拼团活动编号 关联 CombinationActivityDO#getId()',
  `combination_price` int NULL COMMENT '拼团商品单价 冗余 CombinationProductDO#getCombinationPrice()',
  `spu_id` bigint NULL COMMENT 'SPU 编号',
  `spu_name` varchar(255) NULL COMMENT '商品名字',
  `pic_url` varchar(1024) NULL COMMENT '商品图片',
  `sku_id` bigint NULL COMMENT 'SKU 编号',
  `count` int NULL COMMENT '购买的商品数量',
  `user_id` bigint NULL COMMENT '用户编号',
  `nickname` varchar(255) NULL COMMENT '用户昵称',
  `avatar` varchar(1024) NULL COMMENT '用户头像',
  `head_id` bigint NULL COMMENT '团长编号 关联 CombinationRecordDO#getId() 如果是团长，则它的值是 #HEAD_ID_GROUP',
  `status` int NULL COMMENT '开团状态 关联 CombinationRecordStatusEnum',
  `order_id` bigint NULL COMMENT '订单编号',
  `user_size` int NULL COMMENT '开团需要人数 关联 CombinationActivityDO#getUserSize()',
  `user_count` int NULL COMMENT '已加入拼团人数',
  `virtual_group` bit(1) NULL COMMENT '是否虚拟成团 默认为 false。 拼团过期都还没有成功，如果 CombinationActivityDO#getVirtualGroup() 为 true，则执行虚拟成团的逻辑，才会更新该字段为 true',
  `expire_time` datetime NULL COMMENT '过期时间 基于 CombinationRecordDO#getStartTime() + CombinationActivityDO#getLimitDuration() 计算',
  `start_time` datetime NULL COMMENT '开始时间 (订单付款后开始的时间)',
  `end_time` datetime NULL COMMENT '结束时间（成团时间/失败时间）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='拼团记录 DO 1. 用户参与拼团时，会创建一条记录 2. 团长的拼团记录，和参团人的拼团记录，通过 #headId 关联';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/coupon/CouponDO.java
-- Entity: CouponDO extends BaseDO
-- 推断字段类型：id bigint, template_id bigint, name varchar(255), status int, user_id bigint, take_type int, use_price int, valid_start_time datetime, valid_end_time datetime, product_scope int, product_scope_values text, discount_type int, discount_percent int, discount_price int, discount_limit_price int, use_order_id bigint, use_time datetime
CREATE TABLE `promotion_coupon` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '优惠劵编号',
  `template_id` bigint NULL COMMENT '优惠劵模板编号 关联 CouponTemplateDO#getId()',
  `name` varchar(255) NULL COMMENT '优惠劵名 冗余 CouponTemplateDO#getName()',
  `status` int NULL COMMENT '优惠码状态 枚举 CouponStatusEnum',
  `user_id` bigint NULL COMMENT '用户编号 关联 MemberUserDO 的 id 字段',
  `take_type` int NULL COMMENT '领取类型 枚举 CouponTakeTypeEnum',
  `use_price` int NULL COMMENT '是否设置满多少金额可用，单位：分 冗余 CouponTemplateDO#getUsePrice()',
  `valid_start_time` datetime NULL COMMENT '生效开始时间',
  `valid_end_time` datetime NULL COMMENT '生效结束时间',
  `product_scope` int NULL COMMENT '商品范围 枚举 PromotionProductScopeEnum',
  `product_scope_values` text NULL COMMENT '商品范围编号的数组 冗余 CouponTemplateDO#getProductScopeValues()',
  `discount_type` int NULL COMMENT '折扣类型 冗余 CouponTemplateDO#getDiscountType()',
  `discount_percent` int NULL COMMENT '折扣百分比 冗余 CouponTemplateDO#getDiscountPercent()',
  `discount_price` int NULL COMMENT '优惠金额，单位：分 冗余 CouponTemplateDO#getDiscountPrice()',
  `discount_limit_price` int NULL COMMENT '折扣上限，仅在 #discountType 等于 PromotionDiscountTypeEnum#PERCENT 时生效 冗余 CouponTemplateDO#getDiscountLimitPrice()',
  `use_order_id` bigint NULL COMMENT '使用订单号',
  `use_time` datetime NULL COMMENT '使用时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='优惠劵 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/coupon/CouponTemplateDO.java
-- Entity: CouponTemplateDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), description text, status int, total_count int, take_limit_count int, take_type int, use_price int, product_scope int, product_scope_values text, validity_type int, valid_start_time datetime, valid_end_time datetime, fixed_start_term int, fixed_end_term int, discount_type int, discount_percent int, discount_price int, discount_limit_price int, take_count int, use_count int
CREATE TABLE `promotion_coupon_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '模板编号，自增唯一',
  `name` varchar(255) NULL COMMENT '优惠劵名',
  `description` text NULL COMMENT '优惠券说明',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `total_count` int NULL COMMENT '发放数量 -1 - 则表示不限制发放数量',
  `take_limit_count` int NULL COMMENT '每人限领个数 -1 - 则表示不限制',
  `take_type` int NULL COMMENT '领取方式 枚举 CouponTakeTypeEnum',
  `use_price` int NULL COMMENT '是否设置满多少金额可用，单位：分 0 - 不限制 大于 0 - 多少金额可用',
  `product_scope` int NULL COMMENT '商品范围 枚举 PromotionProductScopeEnum',
  `product_scope_values` text NULL COMMENT '商品范围编号的数组',
  `validity_type` int NULL COMMENT '生效日期类型 枚举 CouponTemplateValidityTypeEnum',
  `valid_start_time` datetime NULL COMMENT '固定日期 - 生效开始时间 当 #validityType 为 CouponTemplateValidityTypeEnum#DATE',
  `valid_end_time` datetime NULL COMMENT '固定日期 - 生效结束时间 当 #validityType 为 CouponTemplateValidityTypeEnum#DATE',
  `fixed_start_term` int NULL COMMENT '领取日期 - 开始天数 当 #validityType 为 CouponTemplateValidityTypeEnum#TERM',
  `fixed_end_term` int NULL COMMENT '领取日期 - 结束天数 当 #validityType 为 CouponTemplateValidityTypeEnum#TERM',
  `discount_type` int NULL COMMENT '折扣类型 枚举 PromotionDiscountTypeEnum',
  `discount_percent` int NULL COMMENT '折扣百分比 例如，80% 为 80',
  `discount_price` int NULL COMMENT '优惠金额，单位：分 当 #discountType 为 PromotionDiscountTypeEnum#PRICE 生效',
  `discount_limit_price` int NULL COMMENT '折扣上限，仅在 #discountType 等于 PromotionDiscountTypeEnum#PERCENT 时生效 例如，折扣上限为 20 元，当使用 8 折优惠券，订单金额为 1000 元时，最高只可折扣 20 元，而非 80 元。',
  `take_count` int NULL COMMENT '领取优惠券的数量',
  `use_count` int NULL COMMENT '使用优惠券的次数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='优惠劵模板 DO 当用户领取时，会生成 CouponDO 优惠劵';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/discount/DiscountActivityDO.java
-- Entity: DiscountActivityDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), status int, start_time datetime, end_time datetime, remark text
CREATE TABLE `promotion_discount_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动编号，主键自增',
  `name` varchar(255) NULL COMMENT '活动标题',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum 活动被关闭后，不允许再次开启。',
  `start_time` datetime NULL COMMENT '开始时间',
  `end_time` datetime NULL COMMENT '结束时间',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='限时折扣活动 DO 一个活动下，可以有 DiscountProductDO 商品； 一个商品，在指定时间段内，只能属于一个活动；';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/discount/DiscountProductDO.java
-- Entity: DiscountProductDO extends BaseDO
-- 推断字段类型：id bigint, activity_id bigint, spu_id bigint, sku_id bigint, discount_type int, discount_percent int, discount_price int, activity_name varchar(255), activity_status int, activity_start_time datetime, activity_end_time datetime
CREATE TABLE `promotion_discount_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，主键自增',
  `activity_id` bigint NULL COMMENT '限时折扣活动的编号 关联 DiscountActivityDO#getId()',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号 关联 ProductSpuDO 的 id 编号',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号 关联 ProductSkuDO 的 id 编号',
  `discount_type` int NULL COMMENT '折扣类型 枚举 PromotionDiscountTypeEnum',
  `discount_percent` int NULL COMMENT '折扣百分比 例如，80% 为 80',
  `discount_price` int NULL COMMENT '优惠金额，单位：分 当 #discountType 为 PromotionDiscountTypeEnum#PRICE 生效',
  `activity_name` varchar(255) NULL COMMENT '活动标题 冗余 DiscountActivityDO#getName()',
  `activity_status` int NULL COMMENT '活动状态 冗余 DiscountActivityDO#getStatus()',
  `activity_start_time` datetime NULL COMMENT '活动开始时间点 冗余 DiscountActivityDO#getStartTime()',
  `activity_end_time` datetime NULL COMMENT '活动结束时间点 冗余 DiscountActivityDO#getEndTime()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='限时折扣商品 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/diy/DiyPageDO.java
-- Entity: DiyPageDO extends BaseDO
-- 推断字段类型：id bigint, template_id bigint, name varchar(255), remark text, preview_pic_urls text, property longtext
-- 特殊类型依据：promotion_diy_page.property 源实体明确页面或底部导航属性 JSON 格式，Java String 无类型处理器；保持 JSON 文本语义，LONGTEXT 容量为推断
CREATE TABLE `promotion_diy_page` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '装修页面编号',
  `template_id` bigint NULL COMMENT '装修模板编号 关联 DiyTemplateDO#getId()',
  `name` varchar(255) NULL COMMENT '页面名称',
  `remark` text NULL COMMENT '备注',
  `preview_pic_urls` text NULL COMMENT '预览图，多个逗号分隔',
  `property` longtext NULL COMMENT '页面属性，JSON 格式',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='装修页面 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/diy/DiyTemplateDO.java
-- Entity: DiyTemplateDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), used bit(1), used_time datetime, remark text, preview_pic_urls text, property longtext
-- 特殊类型依据：promotion_diy_template.property 源实体明确页面或底部导航属性 JSON 格式，Java String 无类型处理器；保持 JSON 文本语义，LONGTEXT 容量为推断
CREATE TABLE `promotion_diy_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '装修模板编号',
  `name` varchar(255) NULL COMMENT '模板名称',
  `used` bit(1) NULL COMMENT '是否使用',
  `used_time` datetime NULL COMMENT '使用时间',
  `remark` text NULL COMMENT '备注',
  `preview_pic_urls` text NULL COMMENT '预览图',
  `property` longtext NULL COMMENT 'uni-app 底部导航属性，JSON 格式',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='装修模板 DO 1. 新建一个模版，下面可以包含多个 DiyPageDO 页面，例如说首页、我的 2. 如果需要使用某个模版，则将 #used 设置为 true，表示已使用，有且仅有一个';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/kefu/KeFuConversationDO.java
-- Entity: KeFuConversationDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, last_message_time datetime, last_message_content text, last_message_content_type int, admin_pinned bit(1), user_deleted bit(1), admin_deleted bit(1), admin_unread_message_count int
CREATE TABLE `promotion_kefu_conversation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '会话所属用户 关联 MemberUserRespDTO#getId()',
  `last_message_time` datetime NULL COMMENT '最后聊天时间',
  `last_message_content` text NULL COMMENT '最后聊天内容',
  `last_message_content_type` int NULL COMMENT '最后发送的消息类型 枚举 KeFuMessageContentTypeEnum',
  `admin_pinned` bit(1) NULL COMMENT '管理端置顶',
  `user_deleted` bit(1) NULL COMMENT '用户是否可见 false - 可见，默认值 true - 不可见，用户删除时设置为 true',
  `admin_deleted` bit(1) NULL COMMENT '管理员是否可见 false - 可见，默认值 true - 不可见，管理员删除时设置为 true',
  `admin_unread_message_count` int NULL COMMENT '管理员未读消息数 用户发送消息时增加，管理员查看后扣减',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客服会话 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/kefu/KeFuMessageDO.java
-- Entity: KeFuMessageDO extends BaseDO
-- 推断字段类型：id bigint, conversation_id bigint, sender_id bigint, sender_type int, receiver_id bigint, receiver_type int, content_type int, content text, read_status bit(1)
CREATE TABLE `promotion_kefu_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `conversation_id` bigint NULL COMMENT '会话编号 关联 KeFuConversationDO#getId()',
  `sender_id` bigint NULL COMMENT '发送人编号 存储的是用户编号',
  `sender_type` int NULL COMMENT '发送人类型 枚举，UserTypeEnum',
  `receiver_id` bigint NULL COMMENT '接收人编号 存储的是用户编号',
  `receiver_type` int NULL COMMENT '接收人类型 枚举，UserTypeEnum',
  `content_type` int NULL COMMENT '消息类型 枚举 KeFuMessageContentTypeEnum',
  `content` text NULL COMMENT '消息',
  `read_status` bit(1) NULL COMMENT '是/否已读',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客服消息 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/point/PointActivityDO.java
-- Entity: PointActivityDO extends BaseDO
-- 推断字段类型：id bigint, spu_id bigint, status int, remark text, sort int, stock int, total_stock int
CREATE TABLE `promotion_point_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '积分商城活动编号',
  `spu_id` bigint NULL COMMENT '积分商城活动商品',
  `status` int NULL COMMENT '活动状态 枚举 CommonStatusEnum 对应的类',
  `remark` text NULL COMMENT '备注',
  `sort` int NULL COMMENT '排序',
  `stock` int NULL COMMENT '积分商城活动库存(剩余库存积分兑换时扣减)',
  `total_stock` int NULL COMMENT '积分商城活动总库存',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='积分商城活动 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/point/PointProductDO.java
-- Entity: PointProductDO extends BaseDO
-- 推断字段类型：id bigint, activity_id bigint, spu_id bigint, sku_id bigint, count int, point int, price int, stock int, activity_status int
CREATE TABLE `promotion_point_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '积分商城商品编号',
  `activity_id` bigint NULL COMMENT '积分商城活动 id 关联 PointActivityDO#getId()',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号',
  `count` int NULL COMMENT '可兑换次数',
  `point` int NULL COMMENT '所需兑换积分',
  `price` int NULL COMMENT '所需兑换金额，单位：分',
  `stock` int NULL COMMENT '积分商城商品库存',
  `activity_status` int NULL COMMENT '积分商城商品状态 枚举 CommonStatusEnum 对应的类',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='积分商城商品 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/reward/RewardActivityDO.java
-- Entity: RewardActivityDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), status int, start_time datetime, end_time datetime, remark text, condition_type int, product_scope int, product_scope_values text, rules json
CREATE TABLE `promotion_reward_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动编号，主键自增',
  `name` varchar(255) NULL COMMENT '活动标题',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `start_time` datetime NULL COMMENT '开始时间',
  `end_time` datetime NULL COMMENT '结束时间',
  `remark` text NULL COMMENT '备注',
  `condition_type` int NULL COMMENT '条件类型 枚举 PromotionConditionTypeEnum',
  `product_scope` int NULL COMMENT '商品范围 枚举 PromotionProductScopeEnum',
  `product_scope_values` text NULL COMMENT '商品 SPU 编号的数组',
  `rules` json NULL COMMENT '优惠规则的数组',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='满减送活动 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/seckill/SeckillActivityDO.java
-- Entity: SeckillActivityDO extends BaseDO
-- 推断字段类型：id bigint, spu_id bigint, name varchar(255), status int, remark text, start_time datetime, end_time datetime, sort int, config_ids text, total_limit_count int, single_limit_count int, stock int, total_stock int
CREATE TABLE `promotion_seckill_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '秒杀活动编号',
  `spu_id` bigint NULL COMMENT '秒杀活动商品',
  `name` varchar(255) NULL COMMENT '秒杀活动名称',
  `status` int NULL COMMENT '活动状态 枚举 CommonStatusEnum 对应的类',
  `remark` text NULL COMMENT '备注',
  `start_time` datetime NULL COMMENT '活动开始时间',
  `end_time` datetime NULL COMMENT '活动结束时间',
  `sort` int NULL COMMENT '排序',
  `config_ids` text NULL COMMENT '秒杀时段 id',
  `total_limit_count` int NULL COMMENT '总限购数量',
  `single_limit_count` int NULL COMMENT '单次限够数量',
  `stock` int NULL COMMENT '秒杀库存(剩余库存秒杀时扣减)',
  `total_stock` int NULL COMMENT '秒杀总库存',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='秒杀活动 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/seckill/SeckillConfigDO.java
-- Entity: SeckillConfigDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), start_time varchar(255), end_time varchar(255), slider_pic_urls json, status int
CREATE TABLE `promotion_seckill_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '秒杀时段名称',
  `start_time` varchar(255) NULL COMMENT '开始时间点',
  `end_time` varchar(255) NULL COMMENT '结束时间点',
  `slider_pic_urls` json NULL COMMENT '秒杀轮播图',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum 对应的类',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='秒杀时段 DO';

-- Source: yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/seckill/SeckillProductDO.java
-- Entity: SeckillProductDO extends BaseDO
-- 推断字段类型：id bigint, activity_id bigint, config_ids text, spu_id bigint, sku_id bigint, seckill_price int, stock int, activity_status int, activity_start_time datetime, activity_end_time datetime
CREATE TABLE `promotion_seckill_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '秒杀参与商品编号',
  `activity_id` bigint NULL COMMENT '秒杀活动 id 关联 SeckillActivityDO#getId()',
  `config_ids` text NULL COMMENT '秒杀时段 id 关联 SeckillConfigDO#getId()',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号',
  `seckill_price` int NULL COMMENT '秒杀金额，单位：分',
  `stock` int NULL COMMENT '秒杀库存',
  `activity_status` int NULL COMMENT '秒杀商品状态 枚举 CommonStatusEnum 对应的类',
  `activity_start_time` datetime NULL COMMENT '活动开始时间点',
  `activity_end_time` datetime NULL COMMENT '活动结束时间点',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='秒杀参与商品 DO';

-- Source: yudao-module-mall/yudao-module-statistics-server/src/main/java/cn/iocoder/yudao/module/statistics/dal/dataobject/product/ProductStatisticsDO.java
-- Entity: ProductStatisticsDO extends BaseDO
-- 推断字段类型：id bigint, time date, spu_id bigint, browse_count int, browse_user_count int, favorite_count int, cart_count int, order_count int, order_pay_count int, order_pay_price int, after_sale_count int, after_sale_refund_price int, browse_convert_percent int
CREATE TABLE `product_statistics` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，主键自增',
  `time` date NULL COMMENT '统计日期',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号',
  `browse_count` int NULL COMMENT '浏览量',
  `browse_user_count` int NULL COMMENT '访客量',
  `favorite_count` int NULL COMMENT '收藏数量',
  `cart_count` int NULL COMMENT '加购数量',
  `order_count` int NULL COMMENT '下单件数',
  `order_pay_count` int NULL COMMENT '支付件数',
  `order_pay_price` int NULL COMMENT '支付金额，单位：分',
  `after_sale_count` int NULL COMMENT '退款件数',
  `after_sale_refund_price` int NULL COMMENT '退款金额，单位：分',
  `browse_convert_percent` int NULL COMMENT '访客支付转化率（百分比）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品统计 DO';

-- Source: yudao-module-mall/yudao-module-statistics-server/src/main/java/cn/iocoder/yudao/module/statistics/dal/dataobject/trade/TradeStatisticsDO.java
-- Entity: TradeStatisticsDO extends BaseDO
-- 推断字段类型：id bigint, time datetime, order_create_count int, order_pay_count int, order_pay_price int, after_sale_count int, after_sale_refund_price int, brokerage_settlement_price int, wallet_pay_price int, recharge_pay_count int, recharge_pay_price int, recharge_refund_count int, recharge_refund_price int
CREATE TABLE `trade_statistics` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，主键自增',
  `time` datetime NULL COMMENT '统计日期',
  `order_create_count` int NULL COMMENT '创建订单数',
  `order_pay_count` int NULL COMMENT '支付订单商品数',
  `order_pay_price` int NULL COMMENT '总支付金额，单位：分',
  `after_sale_count` int NULL COMMENT '退款订单数',
  `after_sale_refund_price` int NULL COMMENT '总退款金额，单位：分',
  `brokerage_settlement_price` int NULL COMMENT '佣金金额（已结算），单位：分',
  `wallet_pay_price` int NULL COMMENT '总支付金额（余额），单位：分',
  `recharge_pay_count` int NULL COMMENT '充值订单数 从 PayWalletRechargeDO 计算',
  `recharge_pay_price` int NULL COMMENT '充值金额，单位：分',
  `recharge_refund_count` int NULL COMMENT '充值退款订单数',
  `recharge_refund_price` int NULL COMMENT '充值退款金额，单位：分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易统计 DO 以天为维度，统计全部的数据';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/aftersale/AfterSaleDO.java
-- Entity: AfterSaleDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), status int, way int, type int, user_id bigint, apply_reason varchar(255), apply_description varchar(255), apply_pic_urls json, order_id bigint, order_no varchar(255), order_item_id bigint, spu_id bigint, spu_name varchar(255), sku_id bigint, properties json, pic_url varchar(1024), count int, audit_time datetime, audit_user_id bigint, audit_reason varchar(255), refund_price int, pay_refund_id bigint, refund_time datetime, logistics_id bigint, logistics_no varchar(255), delivery_time datetime, receive_time datetime, receive_reason varchar(255)
CREATE TABLE `trade_after_sale` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '售后编号，主键自增',
  `no` varchar(255) NULL COMMENT '售后单号 例如说，1146347329394184195',
  `status` int NULL COMMENT '退款状态 枚举 AfterSaleStatusEnum',
  `way` int NULL COMMENT '售后方式 枚举 AfterSaleWayEnum',
  `type` int NULL COMMENT '售后类型 枚举 AfterSaleTypeEnum',
  `user_id` bigint NULL COMMENT '用户编号 关联 MemberUserDO 的 id 编号',
  `apply_reason` varchar(255) NULL COMMENT '申请原因 type = 退款，对应 trade_after_sale_refund_reason 类型 type = 退货退款，对应 trade_after_sale_refund_and_return_reason 类型',
  `apply_description` varchar(255) NULL COMMENT '补充描述',
  `apply_pic_urls` json NULL COMMENT '补充凭证图片 数组，以逗号分隔',
  `order_id` bigint NULL COMMENT '交易订单编号 关联 TradeOrderDO#getId()',
  `order_no` varchar(255) NULL COMMENT '订单流水号 冗余 TradeOrderDO#getNo()',
  `order_item_id` bigint NULL COMMENT '交易订单项编号 关联 TradeOrderItemDO#getId()',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号 关联 ProductSpuDO 的 id 字段 冗余 TradeOrderItemDO#getSpuId()',
  `spu_name` varchar(255) NULL COMMENT '商品 SPU 名称 关联 ProductSkuDO 的 name 字段 冗余 TradeOrderItemDO#getSpuName()',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号 关联 ProductSkuDO 的编号',
  `properties` json NULL COMMENT '属性数组，JSON 格式 冗余 TradeOrderItemDO#getProperties()',
  `pic_url` varchar(1024) NULL COMMENT '商品图片 冗余 TradeOrderItemDO#getPicUrl()',
  `count` int NULL COMMENT '退货商品数量',
  `audit_time` datetime NULL COMMENT '审批时间',
  `audit_user_id` bigint NULL COMMENT '审批人 关联 AdminUserDO 的 id 编号',
  `audit_reason` varchar(255) NULL COMMENT '审批备注 注意，只有审批不通过才会填写',
  `refund_price` int NULL COMMENT '退款金额，单位：分。',
  `pay_refund_id` bigint NULL COMMENT '支付退款编号 对接 pay-module-biz 支付服务的退款订单编号，即 PayRefundDO 的 id 编号',
  `refund_time` datetime NULL COMMENT '退款时间',
  `logistics_id` bigint NULL COMMENT '退货物流公司编号 关联 LogisticsDO 的 id 编号',
  `logistics_no` varchar(255) NULL COMMENT '退货物流单号',
  `delivery_time` datetime NULL COMMENT '退货时间',
  `receive_time` datetime NULL COMMENT '收货时间',
  `receive_reason` varchar(255) NULL COMMENT '收货备注 注意，只有拒绝收货才会填写',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='售后订单，用于处理 TradeOrderDO 交易订单的退款退货流程';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/aftersale/AfterSaleLogDO.java
-- Entity: AfterSaleLogDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, user_type int, after_sale_id bigint, before_status int, after_status int, operate_type int, content text
CREATE TABLE `trade_after_sale_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 1：AdminUserDO 的 id 字段 关联 2：MemberUserDO 的 id 字段',
  `user_type` int NULL COMMENT '用户类型 枚举 UserTypeEnum',
  `after_sale_id` bigint NULL COMMENT '售后编号 关联 AfterSaleDO#getId()',
  `before_status` int NULL COMMENT '操作前状态',
  `after_status` int NULL COMMENT '操作后状态',
  `operate_type` int NULL COMMENT '操作类型 枚举 AfterSaleOperateTypeEnum',
  `content` text NULL COMMENT '操作明细',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易售后日志 DO';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/brokerage/BrokerageRecordDO.java
-- Entity: BrokerageRecordDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, biz_id varchar(255), biz_type int, title varchar(255), description text, price int, total_price int, status int, frozen_days int, unfreeze_time datetime, source_user_level int, source_user_id bigint
CREATE TABLE `trade_brokerage_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 MemberUserDO.id',
  `biz_id` varchar(255) NULL COMMENT '业务编号',
  `biz_type` int NULL COMMENT '业务类型 枚举 BrokerageRecordBizTypeEnum',
  `title` varchar(255) NULL COMMENT '标题',
  `description` text NULL COMMENT '说明',
  `price` int NULL COMMENT '金额',
  `total_price` int NULL COMMENT '当前总佣金',
  `status` int NULL COMMENT '状态 枚举 BrokerageRecordStatusEnum',
  `frozen_days` int NULL COMMENT '冻结时间（天）',
  `unfreeze_time` datetime NULL COMMENT '解冻时间',
  `source_user_level` int NULL COMMENT '来源用户等级 被推广用户和 #userId 的推广层级关系',
  `source_user_id` bigint NULL COMMENT '来源用户编号 关联 MemberUserDO.id 字段，被推广用户的编号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='佣金记录 DO';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/brokerage/BrokerageUserDO.java
-- Entity: BrokerageUserDO extends BaseDO
-- 推断字段类型：id bigint, bind_user_id bigint, bind_user_time datetime, brokerage_enabled bit(1), brokerage_time datetime, brokerage_price int, frozen_price int
CREATE TABLE `trade_brokerage_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户编号 对应 MemberUserDO 的 id 字段',
  `bind_user_id` bigint NULL COMMENT '推广员编号 关联 MemberUserDO 的 id 字段',
  `bind_user_time` datetime NULL COMMENT '推广员绑定时间',
  `brokerage_enabled` bit(1) NULL COMMENT '是否有分销资格',
  `brokerage_time` datetime NULL COMMENT '成为分销员时间',
  `brokerage_price` int NULL COMMENT '可用佣金',
  `frozen_price` int NULL COMMENT '冻结佣金',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分销用户 DO';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/brokerage/BrokerageWithdrawDO.java
-- Entity: BrokerageWithdrawDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, price int, fee_price int, total_price int, type int, user_name varchar(255), user_account varchar(255), qr_code_url varchar(1024), bank_name varchar(255), bank_address varchar(255), status int, audit_reason varchar(255), audit_time datetime, remark text, pay_transfer_id bigint, transfer_channel_code varchar(255), transfer_time datetime, transfer_error_msg text
-- 特殊类型依据：trade_brokerage_withdraw.transfer_error_msg 源实体保存外部服务错误消息；TEXT 容量为推断
CREATE TABLE `trade_brokerage_withdraw` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 MemberUserDO 的 id 字段',
  `price` int NULL COMMENT '提现金额，单位：分',
  `fee_price` int NULL COMMENT '提现手续费，单位：分',
  `total_price` int NULL COMMENT '当前总佣金，单位：分',
  `type` int NULL COMMENT '提现类型 枚举 BrokerageWithdrawTypeEnum',
  `user_name` varchar(255) NULL COMMENT '提现姓名 1. BrokerageWithdrawTypeEnum#BANK：银行开户人 2. BrokerageWithdrawTypeEnum#WECHAT_API：微信真名 3. BrokerageWithdrawTypeEnum#ALIPAY_API：支付宝真名',
  `user_account` varchar(255) NULL COMMENT '提现账号 1. BrokerageWithdrawTypeEnum#BANK：银行账号 2. BrokerageWithdrawTypeEnum#WECHAT_API：微信 openid 3. BrokerageWithdrawTypeEnum#ALIPAY_API：支付宝账号',
  `qr_code_url` varchar(1024) NULL COMMENT '收款码',
  `bank_name` varchar(255) NULL COMMENT '银行名称',
  `bank_address` varchar(255) NULL COMMENT '开户地址',
  `status` int NULL COMMENT '状态 枚举 BrokerageWithdrawStatusEnum',
  `audit_reason` varchar(255) NULL COMMENT '审核驳回原因',
  `audit_time` datetime NULL COMMENT '审核时间',
  `remark` text NULL COMMENT '备注',
  `pay_transfer_id` bigint NULL COMMENT '转账单编号 关联 cn.iocoder.yudao.module.pay.api.transfer.dto.PayTransferRespDTO#getId()',
  `transfer_channel_code` varchar(255) NULL COMMENT '转账渠道 枚举 cn.iocoder.yudao.module.pay.enums.PayChannelEnum',
  `transfer_time` datetime NULL COMMENT '转账成功时间',
  `transfer_error_msg` text NULL COMMENT '转账错误提示',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='佣金提现 DO';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/cart/CartDO.java
-- Entity: CartDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, spu_id bigint, sku_id bigint, count int, selected bit(1)
CREATE TABLE `trade_cart` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，唯一自增',
  `user_id` bigint NULL COMMENT '用户编号 关联 MemberUserDO 的 id 编号',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号 关联 ProductSpuDO 的 id 编号',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号 关联 ProductSkuDO 的 id 编号',
  `count` int NULL COMMENT '商品购买数量',
  `selected` bit(1) NULL COMMENT '是否选中',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='购物车的商品信息 DO 每个商品，对应一条记录，通过 #spuId 和 #skuId 关联';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/config/TradeConfigDO.java
-- Entity: TradeConfigDO extends BaseDO
-- 推断字段类型：id bigint, after_sale_refund_reasons json, after_sale_return_reasons json, delivery_express_free_enabled bit(1), delivery_express_free_price int, delivery_pick_up_enabled bit(1), brokerage_enabled bit(1), brokerage_enabled_condition int, brokerage_bind_mode int, brokerage_poster_urls json, brokerage_first_percent int, brokerage_second_percent int, brokerage_withdraw_min_price int, brokerage_withdraw_fee_percent int, brokerage_frozen_days int, brokerage_withdraw_types text
CREATE TABLE `trade_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `after_sale_refund_reasons` json NULL COMMENT '售后的退款理由',
  `after_sale_return_reasons` json NULL COMMENT '售后的退货理由',
  `delivery_express_free_enabled` bit(1) NULL COMMENT '是否启用全场包邮',
  `delivery_express_free_price` int NULL COMMENT '全场包邮的最小金额，单位：分',
  `delivery_pick_up_enabled` bit(1) NULL COMMENT '是否开启自提',
  `brokerage_enabled` bit(1) NULL COMMENT '是否启用分佣',
  `brokerage_enabled_condition` int NULL COMMENT '分佣模式 枚举 BrokerageEnabledConditionEnum 对应的类',
  `brokerage_bind_mode` int NULL COMMENT '分销关系绑定模式 枚举 BrokerageBindModeEnum 对应的类',
  `brokerage_poster_urls` json NULL COMMENT '分销海报图地址数组',
  `brokerage_first_percent` int NULL COMMENT '一级返佣比例',
  `brokerage_second_percent` int NULL COMMENT '二级返佣比例',
  `brokerage_withdraw_min_price` int NULL COMMENT '用户提现最低金额',
  `brokerage_withdraw_fee_percent` int NULL COMMENT '用户提现手续费百分比',
  `brokerage_frozen_days` int NULL COMMENT '佣金冻结时间(天)',
  `brokerage_withdraw_types` text NULL COMMENT '提现方式 枚举 BrokerageWithdrawTypeEnum 对应的类',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易中心配置 DO';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/delivery/DeliveryExpressDO.java
-- Entity: DeliveryExpressDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), logo varchar(1024), sort int, status int
-- 特殊类型依据：trade_delivery_express.logo 源实体 logo 保存图片资源地址；VARCHAR(1024) 容量为推断
CREATE TABLE `trade_delivery_express` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，自增',
  `code` varchar(255) NULL COMMENT '快递公司 code',
  `name` varchar(255) NULL COMMENT '快递公司名称',
  `logo` varchar(1024) NULL COMMENT '快递公司 logo',
  `sort` int NULL COMMENT '排序',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='快递公司 DO';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/delivery/DeliveryExpressTemplateChargeDO.java
-- Entity: DeliveryExpressTemplateChargeDO extends BaseDO
-- 推断字段类型：id bigint, template_id bigint, area_ids text, charge_mode int, start_count double, start_price int, extra_count double, extra_price int
CREATE TABLE `trade_delivery_express_template_charge` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，自增',
  `template_id` bigint NULL COMMENT '配送模板编号 关联 DeliveryExpressTemplateDO#getId()',
  `area_ids` text NULL COMMENT '配送区域编号列表',
  `charge_mode` int NULL COMMENT '配送计费方式 冗余 DeliveryExpressTemplateDO#getChargeMode()',
  `start_count` double NULL COMMENT '首件数量(件数,重量，或体积)',
  `start_price` int NULL COMMENT '起步价，单位：分',
  `extra_count` double NULL COMMENT '续件数量(件, 重量，或体积)',
  `extra_price` int NULL COMMENT '额外价，单位：分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='快递运费模板计费配置 DO';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/delivery/DeliveryExpressTemplateDO.java
-- Entity: DeliveryExpressTemplateDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), charge_mode int, sort int
CREATE TABLE `trade_delivery_express_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，自增',
  `name` varchar(255) NULL COMMENT '模板名称',
  `charge_mode` int NULL COMMENT '配送计费方式 枚举 DeliveryExpressChargeModeEnum',
  `sort` int NULL COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='快递运费模板 DO';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/delivery/DeliveryExpressTemplateFreeDO.java
-- Entity: DeliveryExpressTemplateFreeDO extends BaseDO
-- 推断字段类型：id bigint, template_id bigint, area_ids text, free_price int, free_count int
CREATE TABLE `trade_delivery_express_template_free` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `template_id` bigint NULL COMMENT '配送模板编号 关联 DeliveryExpressTemplateDO#getId()',
  `area_ids` text NULL COMMENT '配送区域编号列表',
  `free_price` int NULL COMMENT '包邮金额，单位：分 订单总金额 >= 包邮金额时，才免运费',
  `free_count` int NULL COMMENT '包邮件数 订单总件数 >= 包邮件数时，才免运费',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='快递运费模板包邮配置 DO';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/delivery/DeliveryPickUpStoreDO.java
-- Entity: DeliveryPickUpStoreDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), introduction varchar(255), phone varchar(255), area_id int, detail_address varchar(255), logo varchar(1024), opening_time time, closing_time time, latitude double, longitude double, verify_user_ids text, status int
-- 特殊类型依据：trade_delivery_pick_up_store.logo 源实体 logo 保存图片资源地址；VARCHAR(1024) 容量为推断
CREATE TABLE `trade_delivery_pick_up_store` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '门店名称',
  `introduction` varchar(255) NULL COMMENT '门店简介',
  `phone` varchar(255) NULL COMMENT '门店手机',
  `area_id` int NULL COMMENT '区域编号',
  `detail_address` varchar(255) NULL COMMENT '门店详细地址',
  `logo` varchar(1024) NULL COMMENT '门店 logo',
  `opening_time` time NULL COMMENT '营业开始时间',
  `closing_time` time NULL COMMENT '营业结束时间',
  `latitude` double NULL COMMENT '纬度',
  `longitude` double NULL COMMENT '经度',
  `verify_user_ids` text NULL COMMENT '核销员工用户编号数组 订单自提核销时，只有对应门店的店员才能核销 关联 AdminUserRespDTO#getId() 管理员编号',
  `status` int NULL COMMENT '门店状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='自提门店 DO';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/order/TradeOrderDO.java
-- Entity: TradeOrderDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), type int, terminal int, user_id bigint, user_ip varchar(255), user_remark varchar(255), status int, product_count int, finish_time datetime, cancel_time datetime, cancel_type int, remark text, comment_status bit(1), brokerage_user_id bigint, pay_order_id bigint, pay_status bit(1), pay_time datetime, pay_channel_code varchar(255), total_price int, discount_price int, delivery_price int, adjust_price int, pay_price int, delivery_type int, logistics_id bigint, logistics_no varchar(255), delivery_time datetime, receive_time datetime, receiver_name varchar(255), receiver_mobile varchar(255), receiver_area_id int, receiver_detail_address varchar(255), pick_up_store_id bigint, pick_up_verify_code varchar(255), refund_status int, refund_price int, coupon_id bigint, coupon_price int, use_point int, point_price int, give_point int, refund_point int, vip_price int, give_coupon_template_counts json, give_coupon_ids text, seckill_activity_id bigint, bargain_activity_id bigint, bargain_record_id bigint, combination_activity_id bigint, combination_head_id bigint, combination_record_id bigint, point_activity_id bigint
CREATE TABLE `trade_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单编号，主键自增',
  `no` varchar(255) NULL COMMENT '订单流水号 例如说，1146347329394184195',
  `type` int NULL COMMENT '订单类型 枚举 TradeOrderTypeEnum',
  `terminal` int NULL COMMENT '订单来源 枚举 TerminalEnum',
  `user_id` bigint NULL COMMENT '用户编号 关联 MemberUserDO 的 id 编号',
  `user_ip` varchar(255) NULL COMMENT '用户 IP',
  `user_remark` varchar(255) NULL COMMENT '用户备注',
  `status` int NULL COMMENT '订单状态 枚举 TradeOrderStatusEnum',
  `product_count` int NULL COMMENT '购买的商品数量',
  `finish_time` datetime NULL COMMENT '订单完成时间',
  `cancel_time` datetime NULL COMMENT '订单取消时间',
  `cancel_type` int NULL COMMENT '取消类型 枚举 TradeOrderCancelTypeEnum',
  `remark` text NULL COMMENT '商家备注',
  `comment_status` bit(1) NULL COMMENT '是否评价 true - 已评价 false - 未评价',
  `brokerage_user_id` bigint NULL COMMENT '推广人编号 关联 BrokerageUserDO#getId() 字段，即 MemberUserRespDTO#getId() 字段',
  `pay_order_id` bigint NULL COMMENT '支付订单编号 对接 pay-module-biz 支付服务的支付订单编号，即 PayOrderDO 的 id 编号',
  `pay_status` bit(1) NULL COMMENT '是否已支付 true - 已经支付过 false - 没有支付过',
  `pay_time` datetime NULL COMMENT '付款时间',
  `pay_channel_code` varchar(255) NULL COMMENT '支付渠道 对应 PayChannelEnum 枚举',
  `total_price` int NULL COMMENT '商品原价，单位：分 totalPrice = TradeOrderItemDO#getPrice() * TradeOrderItemDO#getCount() 求和 对应 taobao 的 trade.total_fee 字段',
  `discount_price` int NULL COMMENT '优惠金额，单位：分 对应 taobao 的 order.discount_fee 字段',
  `delivery_price` int NULL COMMENT '运费金额，单位：分',
  `adjust_price` int NULL COMMENT '订单调价，单位：分 正数，加价；负数，减价',
  `pay_price` int NULL COMMENT '应付金额（总），单位：分 = #totalPrice - #couponPrice - #pointPrice - #discountPrice + #deliveryPrice + #adjustPrice - #vipPrice',
  `delivery_type` int NULL COMMENT '配送方式 枚举 DeliveryTypeEnum',
  `logistics_id` bigint NULL COMMENT '发货物流公司编号 如果无需发货，则 logisticsId 设置为 0。原因是，不想再添加额外字段 关联 DeliveryExpressDO#getId()',
  `logistics_no` varchar(255) NULL COMMENT '发货物流单号 如果无需发货，则 logisticsNo 设置 ""。原因是，不想再添加额外字段',
  `delivery_time` datetime NULL COMMENT '发货时间',
  `receive_time` datetime NULL COMMENT '收货时间',
  `receiver_name` varchar(255) NULL COMMENT '收件人名称',
  `receiver_mobile` varchar(255) NULL COMMENT '收件人手机',
  `receiver_area_id` int NULL COMMENT '收件人地区编号',
  `receiver_detail_address` varchar(255) NULL COMMENT '收件人详细地址',
  `pick_up_store_id` bigint NULL COMMENT '自提门店编号 关联 DeliveryPickUpStoreDO#getId()',
  `pick_up_verify_code` varchar(255) NULL COMMENT '自提核销码',
  `refund_status` int NULL COMMENT '售后状态 枚举 TradeOrderRefundStatusEnum',
  `refund_price` int NULL COMMENT '退款金额，单位：分 注意，退款并不会影响 #payPrice 实际支付金额 也就说，一个订单最终产生多少金额的收入 = payPrice - refundPrice',
  `coupon_id` bigint NULL COMMENT '优惠劵编号',
  `coupon_price` int NULL COMMENT '优惠劵减免金额，单位：分 对应 taobao 的 trade.coupon_fee 字段',
  `use_point` int NULL COMMENT '使用的积分',
  `point_price` int NULL COMMENT '积分抵扣的金额，单位：分 对应 taobao 的 trade.point_fee 字段',
  `give_point` int NULL COMMENT '赠送的积分',
  `refund_point` int NULL COMMENT '退还的使用的积分',
  `vip_price` int NULL COMMENT 'VIP 减免金额，单位：分',
  `give_coupon_template_counts` json NULL COMMENT '赠送的优惠劵 key: 优惠劵模版编号 value：对应的优惠券数量 目的：用于订单支付后赠送优惠券',
  `give_coupon_ids` text NULL COMMENT '赠送的优惠劵编号 目的：用于后续取消或者售后订单时，需要扣减赠送',
  `seckill_activity_id` bigint NULL COMMENT '秒杀活动编号 关联 SeckillActivityDO 的 id 字段',
  `bargain_activity_id` bigint NULL COMMENT '砍价活动编号 关联 BargainActivityDO 的 id 字段',
  `bargain_record_id` bigint NULL COMMENT '砍价记录编号 关联 BargainRecordDO 的 id 字段',
  `combination_activity_id` bigint NULL COMMENT '拼团活动编号 关联 CombinationActivityDO 的 id 字段',
  `combination_head_id` bigint NULL COMMENT '拼团团长编号 关联 CombinationRecordDO 的 headId 字段',
  `combination_record_id` bigint NULL COMMENT '拼团记录编号 关联 CombinationRecordDO 的 id 字段',
  `point_activity_id` bigint NULL COMMENT '积分商城活动的编号 关联 PointActivityDO 的 id 字段',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易订单 DO';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/order/TradeOrderItemDO.java
-- Entity: TradeOrderItemDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, order_id bigint, cart_id bigint, spu_id bigint, spu_name varchar(255), sku_id bigint, properties json, pic_url varchar(1024), count int, comment_status bit(1), price int, discount_price int, delivery_price int, adjust_price int, pay_price int, coupon_price int, point_price int, use_point int, give_point int, vip_price int, after_sale_id bigint, after_sale_status int
CREATE TABLE `trade_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 MemberUserDO 的 id 编号',
  `order_id` bigint NULL COMMENT '订单编号 关联 TradeOrderDO#getId()',
  `cart_id` bigint NULL COMMENT '购物车项编号 关联 CartDO#getId()',
  `spu_id` bigint NULL COMMENT '商品 SPU 编号 关联 ProductSkuDO 的 spuId 编号',
  `spu_name` varchar(255) NULL COMMENT '商品 SPU 名称 冗余 ProductSkuDO 的 spuName 编号',
  `sku_id` bigint NULL COMMENT '商品 SKU 编号 关联 ProductSkuDO 的 id 编号',
  `properties` json NULL COMMENT '属性数组，JSON 格式 冗余 ProductSkuDO 的 properties 字段',
  `pic_url` varchar(1024) NULL COMMENT '商品图片',
  `count` int NULL COMMENT '购买数量',
  `comment_status` bit(1) NULL COMMENT '是否评价 true - 已评价 false - 未评价',
  `price` int NULL COMMENT '商品原价（单），单位：分 对应 ProductSkuDO 的 price 字段 对应 taobao 的 order.price 字段',
  `discount_price` int NULL COMMENT '优惠金额（总），单位：分 对应 taobao 的 order.discount_fee 字段',
  `delivery_price` int NULL COMMENT '运费金额（总），单位：分',
  `adjust_price` int NULL COMMENT '订单调价（总），单位：分 正数，加价；负数，减价',
  `pay_price` int NULL COMMENT '应付金额（总），单位：分 = #price * #count - #couponPrice - #pointPrice - #discountPrice + #deliveryPrice + #adjustPrice - #vipPrice',
  `coupon_price` int NULL COMMENT '优惠劵减免金额，单位：分 对应 taobao 的 trade.coupon_fee 字段',
  `point_price` int NULL COMMENT '积分抵扣的金额，单位：分 对应 taobao 的 trade.point_fee 字段',
  `use_point` int NULL COMMENT '使用的积分 目的：用于后续取消或者售后订单时，需要归还赠送',
  `give_point` int NULL COMMENT '赠送的积分 目的：用于后续取消或者售后订单时，需要扣减赠送',
  `vip_price` int NULL COMMENT 'VIP 减免金额，单位：分',
  `after_sale_id` bigint NULL COMMENT '售后单编号 关联 AfterSaleDO#getId() 字段',
  `after_sale_status` int NULL COMMENT '售后状态 枚举 TradeOrderItemAfterSaleStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交易订单项 DO';

-- Source: yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/order/TradeOrderLogDO.java
-- Entity: TradeOrderLogDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, user_type int, order_id bigint, before_status int, after_status int, operate_type int, content text
CREATE TABLE `trade_order_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserDO 的 id 字段、或者 MemberUserDO 的 id 字段',
  `user_type` int NULL COMMENT '用户类型 枚举 UserTypeEnum',
  `order_id` bigint NULL COMMENT '订单号 关联 TradeOrderDO#getId()',
  `before_status` int NULL COMMENT '操作前状态',
  `after_status` int NULL COMMENT '操作后状态',
  `operate_type` int NULL COMMENT '操作类型 TradeOrderOperateTypeEnum',
  `content` text NULL COMMENT '订单日志信息',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单日志 DO';
