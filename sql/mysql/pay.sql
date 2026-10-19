-- PAY 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/app/PayAppDO.java
-- Entity: PayAppDO extends BaseDO
-- 推断字段类型：id bigint, app_key varchar(255), name varchar(255), status int, remark text, order_notify_url varchar(1024), refund_notify_url varchar(1024), transfer_notify_url varchar(1024)
CREATE TABLE `pay_app` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '应用编号，数据库自增',
  `app_key` varchar(255) NULL COMMENT '应用标识',
  `name` varchar(255) NULL COMMENT '应用名',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `order_notify_url` varchar(1024) NULL COMMENT '支付结果的回调地址',
  `refund_notify_url` varchar(1024) NULL COMMENT '退款结果的回调地址',
  `transfer_notify_url` varchar(1024) NULL COMMENT '转账结果的回调地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付应用 DO 一个商户下，可能会有多个支付应用。例如说，京东有京东商城、京东到家等等 不过一般来说，一个商户，只有一个应用哈~ 即 PayMerchantDO : PayAppDO = 1 : n';

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/channel/PayChannelDO.java
-- Entity: PayChannelDO extends TenantBaseDO
-- 推断字段类型：id bigint, code varchar(255), status int, fee_rate double, remark text, app_id bigint, config json
CREATE TABLE `pay_channel` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '渠道编号，数据库自增',
  `code` varchar(255) NULL COMMENT '渠道编码 枚举 PayChannelEnum',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `fee_rate` double NULL COMMENT '渠道费率，单位：百分比',
  `remark` text NULL COMMENT '备注',
  `app_id` bigint NULL COMMENT '应用编号 关联 PayAppDO#getId()',
  `config` json NULL COMMENT '支付渠道配置',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付渠道 DO 一个应用下，会有多种支付渠道，例如说微信支付、支付宝支付等等 即 PayAppDO : PayChannelDO = 1 : n';

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/demo/PayDemoOrderDO.java
-- Entity: PayDemoOrderDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, spu_id bigint, spu_name varchar(255), price int, pay_status bit(1), pay_order_id bigint, pay_time datetime, pay_channel_code varchar(255), pay_refund_id bigint, refund_price int, refund_time datetime
CREATE TABLE `pay_demo_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单编号，自增',
  `user_id` bigint NULL COMMENT '用户编号',
  `spu_id` bigint NULL COMMENT '商品编号',
  `spu_name` varchar(255) NULL COMMENT '商品名称',
  `price` int NULL COMMENT '价格，单位：分',
  `pay_status` bit(1) NULL COMMENT '是否支付',
  `pay_order_id` bigint NULL COMMENT '支付订单编号 对接 pay-module-biz 支付服务的支付订单编号，即 PayOrderDO 的 id 编号',
  `pay_time` datetime NULL COMMENT '付款时间',
  `pay_channel_code` varchar(255) NULL COMMENT '支付渠道 对应 PayChannelEnum 枚举',
  `pay_refund_id` bigint NULL COMMENT '支付退款单号',
  `refund_price` int NULL COMMENT '退款金额，单位：分',
  `refund_time` datetime NULL COMMENT '退款完成时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='示例订单 演示业务系统的订单，如何接入 pay 系统的支付与退款';

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/demo/PayDemoWithdrawDO.java
-- Entity: PayDemoWithdrawDO extends BaseDO
-- 推断字段类型：id bigint, subject varchar(255), price int, user_account varchar(255), user_name varchar(255), type int, status int, pay_transfer_id bigint, transfer_channel_code varchar(255), transfer_time datetime, transfer_error_msg text
-- 特殊类型依据：pay_demo_withdraw.transfer_error_msg 转账错误信息按完整文本保存；物理容量为推断
CREATE TABLE `pay_demo_withdraw` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '提现单编号，自增',
  `subject` varchar(255) NULL COMMENT '提现标题',
  `price` int NULL COMMENT '提现金额，单位：分',
  `user_account` varchar(255) NULL COMMENT '收款人账号',
  `user_name` varchar(255) NULL COMMENT '收款人姓名',
  `type` int NULL COMMENT '提现方式 枚举 PayDemoWithdrawTypeEnum',
  `status` int NULL COMMENT '提现状态 枚举 PayDemoWithdrawStatusEnum',
  `pay_transfer_id` bigint NULL COMMENT '转账单编号 关联 PayTransferDO#getId()',
  `transfer_channel_code` varchar(255) NULL COMMENT '转账渠道 枚举 cn.iocoder.yudao.module.pay.enums.PayChannelEnum',
  `transfer_time` datetime NULL COMMENT '转账成功时间',
  `transfer_error_msg` text NULL COMMENT '转账错误提示',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='示例提现订单 演示业务系统的转账业务';

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/notify/PayNotifyLogDO.java
-- Entity: PayNotifyLogDO extends BaseDO
-- 推断字段类型：id bigint, task_id bigint, notify_times int, response text, status int
CREATE TABLE `pay_notify_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志编号，自增',
  `task_id` bigint NULL COMMENT '通知任务编号 关联 PayNotifyTaskDO#getId()',
  `notify_times` int NULL COMMENT '第几次被通知 对应到 PayNotifyTaskDO#getNotifyTimes()',
  `response` text NULL COMMENT 'HTTP 响应结果',
  `status` int NULL COMMENT '支付通知状态 枚举 PayNotifyStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商户支付、退款等的通知 Log 每次通知时，都会在该表中，记录一次 Log，方便排查问题';

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/notify/PayNotifyTaskDO.java
-- Entity: PayNotifyTaskDO extends TenantBaseDO
-- 推断字段类型：id bigint, app_id bigint, type int, data_id bigint, merchant_order_id varchar(255), merchant_refund_id varchar(255), merchant_transfer_id varchar(255), status int, next_notify_time datetime, last_execute_time datetime, notify_times int, max_notify_times int, notify_url varchar(1024)
CREATE TABLE `pay_notify_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，自增',
  `app_id` bigint NULL COMMENT '应用编号 关联 PayAppDO#getId()',
  `type` int NULL COMMENT '通知类型 枚举 PayNotifyTypeEnum',
  `data_id` bigint NULL COMMENT '数据编号，根据不同 type 进行关联： 1. PayNotifyTypeEnum#ORDER 时，关联 PayOrderDO#getId() 2. PayNotifyTypeEnum#REFUND 时，关联 PayRefundDO#getId() 3. PayNotifyTypeEnum#TRANSFER 时，关联 PayTransferDO#getId()',
  `merchant_order_id` varchar(255) NULL COMMENT '商户订单编号',
  `merchant_refund_id` varchar(255) NULL COMMENT '商户退款编号',
  `merchant_transfer_id` varchar(255) NULL COMMENT '商户转账编号',
  `status` int NULL COMMENT '通知状态 枚举 PayNotifyStatusEnum',
  `next_notify_time` datetime NULL COMMENT '下一次通知时间',
  `last_execute_time` datetime NULL COMMENT '最后一次执行时间',
  `notify_times` int NULL COMMENT '当前通知次数',
  `max_notify_times` int NULL COMMENT '最大可通知次数',
  `notify_url` varchar(1024) NULL COMMENT '通知地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付通知 在支付系统收到支付渠道的支付、退款的结果后，需要不断的通知到业务系统，直到成功。';

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/order/PayOrderDO.java
-- Entity: PayOrderDO extends BaseDO
-- 推断字段类型：id bigint, app_id bigint, channel_id bigint, channel_code varchar(255), user_id bigint, user_type int, merchant_order_id varchar(255), subject varchar(255), body text, notify_url varchar(1024), price int, channel_fee_rate double, channel_fee_price int, status int, user_ip varchar(255), expire_time datetime, success_time datetime, extension_id bigint, no varchar(255), refund_price int, channel_user_id varchar(255), channel_order_no varchar(255)
-- 特殊类型依据：pay_order.body 支付商品描述按文本保存；物理容量为推断
CREATE TABLE `pay_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单编号，数据库自增',
  `app_id` bigint NULL COMMENT '应用编号 关联 PayAppDO#getId()',
  `channel_id` bigint NULL COMMENT '渠道编号 关联 PayChannelDO#getId()',
  `channel_code` varchar(255) NULL COMMENT '渠道编码 枚举 PayChannelEnum',
  `user_id` bigint NULL COMMENT '用户编号',
  `user_type` int NULL COMMENT '用户类型',
  `merchant_order_id` varchar(255) NULL COMMENT '商户订单编号 例如说，内部系统 A 的订单号，需要保证每个 PayAppDO 唯一',
  `subject` varchar(255) NULL COMMENT '商品标题',
  `body` text NULL COMMENT '商品描述信息',
  `notify_url` varchar(1024) NULL COMMENT '异步通知地址',
  `price` int NULL COMMENT '支付金额，单位：分',
  `channel_fee_rate` double NULL COMMENT '渠道手续费，单位：百分比 冗余 PayChannelDO#getFeeRate()',
  `channel_fee_price` int NULL COMMENT '渠道手续金额，单位：分',
  `status` int NULL COMMENT '支付状态 枚举 PayOrderStatusEnum',
  `user_ip` varchar(255) NULL COMMENT '用户 IP',
  `expire_time` datetime NULL COMMENT '订单失效时间',
  `success_time` datetime NULL COMMENT '订单支付成功时间',
  `extension_id` bigint NULL COMMENT '支付成功的订单拓展单编号 关联 PayOrderExtensionDO#getId()',
  `no` varchar(255) NULL COMMENT '支付成功的外部订单号 关联 PayOrderExtensionDO#getNo()',
  `refund_price` int NULL COMMENT '退款总金额，单位：分',
  `channel_user_id` varchar(255) NULL COMMENT '渠道用户编号 例如说，微信 openid、支付宝 buyerId(buyerOpenId)',
  `channel_order_no` varchar(255) NULL COMMENT '渠道订单号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付订单 DO';

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/order/PayOrderExtensionDO.java
-- Entity: PayOrderExtensionDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), order_id bigint, channel_id bigint, channel_code varchar(255), user_ip varchar(255), status int, channel_extras json, channel_error_code varchar(255), channel_error_msg text, channel_notify_data text
-- 特殊类型依据：pay_order_extension.channel_error_msg 外部渠道错误信息可能超过普通短文本；物理容量为推断
-- 特殊类型依据：pay_order_extension.channel_notify_data 渠道回调保存原始完整JSON字符串，当前字段无JSON TypeHandler，使用TEXT保留字符串格式；物理容量为推断
CREATE TABLE `pay_order_extension` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单拓展编号，数据库自增',
  `no` varchar(255) NULL COMMENT '外部订单号，根据规则生成 调用支付渠道时，使用该字段作为对接的订单号： 1. 微信支付：对应 JSAPI 支付 的 out_trade_no 字段 2. 支付宝支付：对应 电脑网站支付 的 out_trade_no 字段 例如说，P202110132239124200055',
  `order_id` bigint NULL COMMENT '订单号 关联 PayOrderDO#getId()',
  `channel_id` bigint NULL COMMENT '渠道编号 关联 PayChannelDO#getId()',
  `channel_code` varchar(255) NULL COMMENT '渠道编码',
  `user_ip` varchar(255) NULL COMMENT '用户 IP',
  `status` int NULL COMMENT '支付状态 枚举 PayOrderStatusEnum',
  `channel_extras` json NULL COMMENT '支付渠道的额外参数 参见 参数说明',
  `channel_error_code` varchar(255) NULL COMMENT '调用渠道的错误码',
  `channel_error_msg` text NULL COMMENT '调用渠道报错时，错误信息',
  `channel_notify_data` text NULL COMMENT '支付渠道的同步/异步通知的内容 对应 PayOrderRespDTO#getRawData()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付订单拓展 DO 每次调用支付渠道，都会生成一条对应记录';

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/refund/PayRefundDO.java
-- Entity: PayRefundDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), app_id bigint, channel_id bigint, channel_code varchar(255), order_id bigint, order_no varchar(255), user_id bigint, user_type int, merchant_order_id varchar(255), merchant_refund_id varchar(255), notify_url varchar(1024), status int, pay_price int, refund_price int, reason text, user_ip varchar(255), channel_order_no varchar(255), channel_refund_no varchar(255), success_time datetime, channel_error_code varchar(255), channel_error_msg text, channel_notify_data text
-- 特殊类型依据：pay_refund.channel_error_msg 外部渠道错误信息可能超过普通短文本；物理容量为推断
-- 特殊类型依据：pay_refund.channel_notify_data 渠道回调保存原始完整JSON字符串，当前字段无JSON TypeHandler，使用TEXT保留字符串格式；物理容量为推断
CREATE TABLE `pay_refund` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '退款单编号，数据库自增',
  `no` varchar(255) NULL COMMENT '外部退款号，根据规则生成 调用支付渠道时，使用该字段作为对接的退款号： 1. 微信退款：对应 申请退款 的 out_refund_no 字段 2. 支付宝退款：对应 的 out_request_no 字段',
  `app_id` bigint NULL COMMENT '应用编号 关联 PayAppDO#getId()',
  `channel_id` bigint NULL COMMENT '渠道编号 关联 PayChannelDO#getId()',
  `channel_code` varchar(255) NULL COMMENT '渠道编码 枚举 PayChannelEnum',
  `order_id` bigint NULL COMMENT '订单编号 关联 PayOrderDO#getId()',
  `order_no` varchar(255) NULL COMMENT '支付订单编号 冗余 PayOrderDO#getNo()',
  `user_id` bigint NULL COMMENT '用户编号',
  `user_type` int NULL COMMENT '用户类型',
  `merchant_order_id` varchar(255) NULL COMMENT '商户订单编号 例如说，内部系统 A 的订单号，需要保证每个 PayAppDO 唯一',
  `merchant_refund_id` varchar(255) NULL COMMENT '商户退款订单号 例如说，内部系统 A 的订单号，需要保证每个 PayAppDO 唯一',
  `notify_url` varchar(1024) NULL COMMENT '异步通知地址',
  `status` int NULL COMMENT '退款状态 枚举 PayRefundStatusEnum',
  `pay_price` int NULL COMMENT '支付金额，单位：分',
  `refund_price` int NULL COMMENT '退款金额，单位：分',
  `reason` text NULL COMMENT '退款原因',
  `user_ip` varchar(255) NULL COMMENT '用户 IP',
  `channel_order_no` varchar(255) NULL COMMENT '渠道订单号 冗余 PayOrderDO#getChannelOrderNo()',
  `channel_refund_no` varchar(255) NULL COMMENT '渠道退款单号 1. 微信退款：对应 申请退款 的 refund_id 字段 2. 支付宝退款：没有字段',
  `success_time` datetime NULL COMMENT '退款成功时间',
  `channel_error_code` varchar(255) NULL COMMENT '调用渠道的错误码',
  `channel_error_msg` text NULL COMMENT '调用渠道的错误提示',
  `channel_notify_data` text NULL COMMENT '支付渠道的同步/异步通知的内容 对应 PayRefundRespDTO#getRawData()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付退款单 DO 一个支付订单，可以拥有多个支付退款单 即 PayOrderDO : PayRefundDO = 1 : n';

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/transfer/PayTransferDO.java
-- Entity: PayTransferDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), app_id bigint, channel_id bigint, channel_code varchar(255), user_id bigint, user_type int, merchant_transfer_id varchar(255), subject varchar(255), price int, user_account varchar(255), user_name varchar(255), status int, success_time datetime, notify_url varchar(1024), user_ip varchar(255), channel_extras json, channel_transfer_no varchar(255), channel_error_code varchar(255), channel_error_msg text, channel_notify_data text, channel_package_info text
-- 特殊类型依据：pay_transfer.channel_error_msg 外部渠道错误信息可能超过普通短文本；物理容量为推断
-- 特殊类型依据：pay_transfer.channel_notify_data 渠道回调保存原始完整JSON字符串，当前字段无JSON TypeHandler，使用TEXT保留字符串格式；物理容量为推断
-- 特殊类型依据：pay_transfer.channel_package_info 渠道扩展信息可能为完整JSON字符串；物理容量为推断
CREATE TABLE `pay_transfer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `no` varchar(255) NULL COMMENT '转账单号',
  `app_id` bigint NULL COMMENT '应用编号 关联 PayAppDO#getId()',
  `channel_id` bigint NULL COMMENT '转账渠道编号 关联 PayChannelDO#getId()',
  `channel_code` varchar(255) NULL COMMENT '转账渠道编码 枚举 PayChannelEnum',
  `user_id` bigint NULL COMMENT '用户编号',
  `user_type` int NULL COMMENT '用户类型',
  `merchant_transfer_id` varchar(255) NULL COMMENT '商户转账单编号 例如说，内部系统 A 的订单号，需要保证每个 PayAppDO 唯一',
  `subject` varchar(255) NULL COMMENT '转账标题',
  `price` int NULL COMMENT '转账金额，单位：分',
  `user_account` varchar(255) NULL COMMENT '收款人账号',
  `user_name` varchar(255) NULL COMMENT '收款人姓名',
  `status` int NULL COMMENT '转账状态 枚举 PayTransferStatusEnum',
  `success_time` datetime NULL COMMENT '订单转账成功时间',
  `notify_url` varchar(1024) NULL COMMENT '异步通知地址',
  `user_ip` varchar(255) NULL COMMENT '用户 IP',
  `channel_extras` json NULL COMMENT '渠道的额外参数',
  `channel_transfer_no` varchar(255) NULL COMMENT '渠道转账单号',
  `channel_error_code` varchar(255) NULL COMMENT '调用渠道的错误码',
  `channel_error_msg` text NULL COMMENT '调用渠道的错误提示',
  `channel_notify_data` text NULL COMMENT '渠道的同步/异步通知的内容',
  `channel_package_info` text NULL COMMENT '渠道 package 信息 特殊：目前只有微信转账有这个东西！！！ @see JSAPI 调起用户确认收款',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='转账单 DO';

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/wallet/PayWalletDO.java
-- Entity: PayWalletDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, user_type int, balance int, freeze_price int, total_expense int, total_recharge int
CREATE TABLE `pay_wallet` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户 id 关联 MemberUserDO 的 id 编号 关联 AdminUserDO 的 id 编号',
  `user_type` int NULL COMMENT '用户类型, 预留 多商户转帐可能需要用到 关联 UserTypeEnum',
  `balance` int NULL COMMENT '余额，单位分',
  `freeze_price` int NULL COMMENT '冻结金额，单位分',
  `total_expense` int NULL COMMENT '累计支出，单位分',
  `total_recharge` int NULL COMMENT '累计充值，单位分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员钱包 DO';

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/wallet/PayWalletRechargeDO.java
-- Entity: PayWalletRechargeDO extends BaseDO
-- 推断字段类型：id bigint, wallet_id bigint, total_price int, pay_price int, bonus_price int, package_id bigint, pay_status bit(1), pay_order_id bigint, pay_channel_code varchar(255), pay_time datetime, pay_refund_id bigint, refund_total_price int, refund_pay_price int, refund_bonus_price int, refund_time datetime, refund_status int
CREATE TABLE `pay_wallet_recharge` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `wallet_id` bigint NULL COMMENT '钱包编号 关联 PayWalletDO#getId()',
  `total_price` int NULL COMMENT '用户实际到账余额 例如充 100 送 20，则该值是 120',
  `pay_price` int NULL COMMENT '实际支付金额',
  `bonus_price` int NULL COMMENT '钱包赠送金额',
  `package_id` bigint NULL COMMENT '充值套餐编号 关联 PayWalletRechargeDO#getPackageId() 字段',
  `pay_status` bit(1) NULL COMMENT '是否已支付 true - 已支付 false - 未支付',
  `pay_order_id` bigint NULL COMMENT '支付订单编号 关联 PayOrderDO#getId()',
  `pay_channel_code` varchar(255) NULL COMMENT '支付成功的支付渠道 冗余 PayOrderDO#getChannelCode()',
  `pay_time` datetime NULL COMMENT '订单支付时间',
  `pay_refund_id` bigint NULL COMMENT '支付退款单编号 关联 PayRefundDO#getId()',
  `refund_total_price` int NULL COMMENT '退款金额，包含赠送金额',
  `refund_pay_price` int NULL COMMENT '退款支付金额',
  `refund_bonus_price` int NULL COMMENT '退款钱包赠送金额',
  `refund_time` datetime NULL COMMENT '退款时间',
  `refund_status` int NULL COMMENT '退款状态 枚举 PayRefundStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员钱包充值';

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/wallet/PayWalletRechargePackageDO.java
-- Entity: PayWalletRechargePackageDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), pay_price int, bonus_price int, status int
CREATE TABLE `pay_wallet_recharge_package` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '套餐名',
  `pay_price` int NULL COMMENT '支付金额',
  `bonus_price` int NULL COMMENT '赠送金额',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员钱包充值套餐 DO 通过充值套餐时，可以赠送一定金额；';

-- Source: yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/wallet/PayWalletTransactionDO.java
-- Entity: PayWalletTransactionDO extends BaseDO
-- 推断字段类型：id bigint, no varchar(255), wallet_id bigint, biz_type int, biz_id varchar(255), title varchar(255), price int, balance int
CREATE TABLE `pay_wallet_transaction` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `no` varchar(255) NULL COMMENT '流水号',
  `wallet_id` bigint NULL COMMENT '钱包编号 关联 PayWalletDO#getId()',
  `biz_type` int NULL COMMENT '关联业务分类 枚举 PayWalletBizTypeEnum#getType()',
  `biz_id` varchar(255) NULL COMMENT '关联业务编号',
  `title` varchar(255) NULL COMMENT '流水说明',
  `price` int NULL COMMENT '交易金额，单位分 正值表示余额增加，负值表示余额减少',
  `balance` int NULL COMMENT '交易后余额，单位分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员钱包流水 DO';
