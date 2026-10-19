-- IOT 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/alert/IotAlertConfigDO.java
-- Entity: IotAlertConfigDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), description text, level int, status int, scene_rule_ids text, receive_user_ids text, receive_types text, sms_template_code varchar(255), mail_template_code varchar(255), notify_template_code varchar(255)
CREATE TABLE `iot_alert_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置编号',
  `name` varchar(255) NULL COMMENT '配置名称',
  `description` text NULL COMMENT '配置描述',
  `level` int NULL COMMENT '配置状态 字典 DictTypeConstants#ALERT_LEVEL',
  `status` int NULL COMMENT '配置状态 枚举 CommonStatusEnum',
  `scene_rule_ids` text NULL COMMENT '关联的场景联动规则编号数组 关联 IotSceneRuleDO#getId()',
  `receive_user_ids` text NULL COMMENT '接收的用户编号数组 关联 AdminUserRespDTO#getId()',
  `receive_types` text NULL COMMENT '接收的类型数组 枚举 IotAlertReceiveTypeEnum',
  `sms_template_code` varchar(255) NULL COMMENT '短信模板编号 关联 SmsTemplateDO 的 code 属性',
  `mail_template_code` varchar(255) NULL COMMENT '邮件模板编号 关联 MailTemplateDO 的 code 属性',
  `notify_template_code` varchar(255) NULL COMMENT '站内信模板编号 关联 NotifyTemplateDO 的 code 属性',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT 告警配置 DO';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/alert/IotAlertRecordDO.java
-- Entity: IotAlertRecordDO extends BaseDO
-- 推断字段类型：id bigint, config_id bigint, config_name varchar(255), config_level int, scene_rule_id bigint, product_id bigint, device_id bigint, device_message json, process_status bit(1), process_remark varchar(255)
CREATE TABLE `iot_alert_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录编号',
  `config_id` bigint NULL COMMENT '告警名称 冗余 IotAlertConfigDO#getId()',
  `config_name` varchar(255) NULL COMMENT '告警名称 冗余 IotAlertConfigDO#getName()',
  `config_level` int NULL COMMENT '告警级别 冗余 IotAlertConfigDO#getLevel() 字典 cn.iocoder.yudao.module.iot.enums.DictTypeConstants#ALERT_LEVEL',
  `scene_rule_id` bigint NULL COMMENT '场景规则编号 关联 IotSceneRuleDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 IotProductDO#getId()',
  `device_id` bigint NULL COMMENT '设备编号 关联 IotDeviceDO#getId()',
  `device_message` json NULL COMMENT '触发的设备消息',
  `process_status` bit(1) NULL COMMENT '是否处理',
  `process_remark` varchar(255) NULL COMMENT '处理结果（备注）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT 告警记录 DO';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/device/IotDeviceDO.java
-- Entity: IotDeviceDO extends TenantBaseDO
-- 推断字段类型：id bigint, device_name varchar(255), nickname varchar(255), serial_number varchar(255), pic_url varchar(1024), group_ids text, product_id bigint, product_key varchar(255), device_type int, gateway_id bigint, state int, online_time datetime, offline_time datetime, active_time datetime, firmware_id bigint, device_secret varchar(255), latitude decimal(24,6), longitude decimal(24,6), config longtext
-- 特殊类型依据：iot_device.config 源实体明确 JSON 格式自定义设备配置，Java String 无类型处理器；保持 JSON 文本语义，LONGTEXT 容量为推断
CREATE TABLE `iot_device` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '设备 ID，主键，自增',
  `device_name` varchar(255) NULL COMMENT '设备名称，在产品内唯一，用于标识设备',
  `nickname` varchar(255) NULL COMMENT '设备备注名称',
  `serial_number` varchar(255) NULL COMMENT '设备序列号',
  `pic_url` varchar(1024) NULL COMMENT '设备图片',
  `group_ids` text NULL COMMENT '设备分组编号集合 关联 IotDeviceGroupDO#getId()',
  `product_id` bigint NULL COMMENT '产品编号 关联 IotProductDO#getId()',
  `product_key` varchar(255) NULL COMMENT '产品标识 冗余 IotProductDO#getProductKey()',
  `device_type` int NULL COMMENT '设备类型 冗余 IotProductDO#getDeviceType()',
  `gateway_id` bigint NULL COMMENT '网关设备编号 子设备需要关联的网关设备 ID 关联 IotDeviceDO#getId()',
  `state` int NULL COMMENT '设备状态 枚举 IotDeviceStateEnum',
  `online_time` datetime NULL COMMENT '最后上线时间',
  `offline_time` datetime NULL COMMENT '最后离线时间',
  `active_time` datetime NULL COMMENT '设备激活时间',
  `firmware_id` bigint NULL COMMENT '固件编号 关联 IotOtaFirmwareDO#getId()',
  `device_secret` varchar(255) NULL COMMENT '设备密钥，用于设备认证',
  `latitude` decimal(24,6) NULL COMMENT '设备位置的纬度',
  `longitude` decimal(24,6) NULL COMMENT '设备位置的经度',
  `config` longtext NULL COMMENT '设备配置 JSON 格式，可下发给 device 进行自定义配置',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT 设备 DO';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/device/IotDeviceGroupDO.java
-- Entity: IotDeviceGroupDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), status int, description text
CREATE TABLE `iot_device_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分组 ID',
  `name` varchar(255) NULL COMMENT '分组名字',
  `status` int NULL COMMENT '分组状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `description` text NULL COMMENT '分组描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT 设备分组 DO';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/device/IotDeviceModbusConfigDO.java
-- Entity: IotDeviceModbusConfigDO extends TenantBaseDO
-- 推断字段类型：id bigint, product_id bigint, device_id bigint, ip varchar(255), port int, slave_id int, timeout int, retry_interval int, mode int, frame_format int, status int
CREATE TABLE `iot_device_modbus_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `product_id` bigint NULL COMMENT '产品编号 关联 IotProductDO#getId()',
  `device_id` bigint NULL COMMENT '设备编号 关联 IotDeviceDO#getId()',
  `ip` varchar(255) NULL COMMENT 'Modbus 服务器 IP 地址',
  `port` int NULL COMMENT 'Modbus 服务器端口',
  `slave_id` int NULL COMMENT '从站地址',
  `timeout` int NULL COMMENT '连接超时时间，单位：毫秒',
  `retry_interval` int NULL COMMENT '重试间隔，单位：毫秒',
  `mode` int NULL COMMENT '模式 @see IotModbusModeEnum',
  `frame_format` int NULL COMMENT '数据帧格式 @see IotModbusFrameFormatEnum',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT 设备 Modbus 连接配置 DO';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/device/IotDeviceModbusPointDO.java
-- Entity: IotDeviceModbusPointDO extends TenantBaseDO
-- 推断字段类型：id bigint, device_id bigint, thing_model_id bigint, identifier varchar(255), name varchar(255), function_code int, register_address int, register_count int, byte_order varchar(255), raw_data_type varchar(255), scale decimal(24,6), poll_interval int, status int
CREATE TABLE `iot_device_modbus_point` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `device_id` bigint NULL COMMENT '设备编号 关联 IotDeviceDO#getId()',
  `thing_model_id` bigint NULL COMMENT '物模型属性编号 关联 IotThingModelDO#getId()',
  `identifier` varchar(255) NULL COMMENT '属性标识符 冗余 IotThingModelDO#getIdentifier()',
  `name` varchar(255) NULL COMMENT '属性名称 冗余 IotThingModelDO#getName()',
  `function_code` int NULL COMMENT 'Modbus 功能码 取值范围：FC01-04（读线圈、读离散输入、读保持寄存器、读输入寄存器）',
  `register_address` int NULL COMMENT '寄存器起始地址',
  `register_count` int NULL COMMENT '寄存器数量',
  `byte_order` varchar(255) NULL COMMENT '字节序 枚举 IotModbusByteOrderEnum',
  `raw_data_type` varchar(255) NULL COMMENT '原始数据类型 枚举 IotModbusRawDataTypeEnum',
  `scale` decimal(24,6) NULL COMMENT '缩放因子',
  `poll_interval` int NULL COMMENT '轮询间隔（毫秒）',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT 设备 Modbus 点位配置 DO';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/ota/IotOtaFirmwareDO.java
-- Entity: IotOtaFirmwareDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), description text, version varchar(255), product_id bigint, file_url varchar(1024), file_size bigint, file_digest_algorithm varchar(255), file_digest_value varchar(255)
CREATE TABLE `iot_ota_firmware` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '固件编号',
  `name` varchar(255) NULL COMMENT '固件名称',
  `description` text NULL COMMENT '固件描述',
  `version` varchar(255) NULL COMMENT '版本号',
  `product_id` bigint NULL COMMENT '产品编号 关联 cn.iocoder.yudao.module.iot.dal.dataobject.product.IotProductDO#getId()',
  `file_url` varchar(1024) NULL COMMENT '固件文件 URL',
  `file_size` bigint NULL COMMENT '固件文件大小',
  `file_digest_algorithm` varchar(255) NULL COMMENT '固件文件签名算法 枚举 DigestAlgorithm，目前只使用 MD5',
  `file_digest_value` varchar(255) NULL COMMENT '固件文件签名结果',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT OTA 固件 DO @see https://help.aliyun.com/zh/iot/user-guide/ota-upgrade-overview';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/ota/IotOtaTaskDO.java
-- Entity: IotOtaTaskDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), description text, firmware_id bigint, status int, device_scope int, device_total_count int, device_success_count int
CREATE TABLE `iot_ota_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务编号',
  `name` varchar(255) NULL COMMENT '任务名称',
  `description` text NULL COMMENT '任务描述',
  `firmware_id` bigint NULL COMMENT '固件编号 关联 IotOtaFirmwareDO#getId()',
  `status` int NULL COMMENT '任务状态 关联 IotOtaTaskStatusEnum',
  `device_scope` int NULL COMMENT '设备升级范围 关联 IotOtaTaskDeviceScopeEnum',
  `device_total_count` int NULL COMMENT '设备总数数量',
  `device_success_count` int NULL COMMENT '设备成功数量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT OTA 升级任务 DO';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/ota/IotOtaTaskRecordDO.java
-- Entity: IotOtaTaskRecordDO extends BaseDO
-- 推断字段类型：id bigint, firmware_id bigint, task_id bigint, device_id bigint, from_firmware_id bigint, status int, progress int, description text
CREATE TABLE `iot_ota_task_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '升级记录编号',
  `firmware_id` bigint NULL COMMENT '固件编号 关联 IotOtaFirmwareDO#getId()',
  `task_id` bigint NULL COMMENT '任务编号 关联 IotOtaTaskDO#getId()',
  `device_id` bigint NULL COMMENT '设备编号 关联 IotDeviceDO#getId()',
  `from_firmware_id` bigint NULL COMMENT '来源的固件编号 关联 IotDeviceDO#getFirmwareId()',
  `status` int NULL COMMENT '升级状态 关联 IotOtaTaskRecordStatusEnum',
  `progress` int NULL COMMENT '升级进度，百分比',
  `description` text NULL COMMENT '升级进度描述 注意，只记录设备最后一次的升级进度描述 如果想看历史记录，可以查看 IotDeviceMessageDO 设备日志',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT OTA 升级任务记录 DO';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/product/IotProductCategoryDO.java
-- Entity: IotProductCategoryDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), sort int, status int, description text
CREATE TABLE `iot_product_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类 ID',
  `name` varchar(255) NULL COMMENT '分类名字',
  `sort` int NULL COMMENT '分类排序',
  `status` int NULL COMMENT '分类状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `description` text NULL COMMENT '分类描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT 产品分类 DO';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/product/IotProductDO.java
-- Entity: IotProductDO extends TenantBaseDO
-- 推断字段类型：id bigint, name varchar(255), product_key varchar(255), product_secret varchar(255), register_enabled bit(1), category_id bigint, icon varchar(255), pic_url varchar(1024), description text, status int, device_type int, net_type int, protocol_type varchar(255), serialize_type varchar(255)
CREATE TABLE `iot_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '产品 ID',
  `name` varchar(255) NULL COMMENT '产品名称',
  `product_key` varchar(255) NULL COMMENT '产品标识',
  `product_secret` varchar(255) NULL COMMENT '产品密钥，用于一型一密动态注册',
  `register_enabled` bit(1) NULL COMMENT '是否开启动态注册',
  `category_id` bigint NULL COMMENT '产品分类编号 关联 IotProductCategoryDO#getId()',
  `icon` varchar(255) NULL COMMENT '产品图标',
  `pic_url` varchar(1024) NULL COMMENT '产品图片',
  `description` text NULL COMMENT '产品描述',
  `status` int NULL COMMENT '产品状态 枚举 cn.iocoder.yudao.module.iot.enums.product.IotProductStatusEnum',
  `device_type` int NULL COMMENT '设备类型 枚举 cn.iocoder.yudao.module.iot.enums.product.IotProductDeviceTypeEnum',
  `net_type` int NULL COMMENT '联网方式 枚举 cn.iocoder.yudao.module.iot.enums.product.IotNetTypeEnum',
  `protocol_type` varchar(255) NULL COMMENT '协议类型 枚举 cn.iocoder.yudao.module.iot.core.enums.IotProtocolTypeEnum',
  `serialize_type` varchar(255) NULL COMMENT '序列化类型 枚举 cn.iocoder.yudao.module.iot.core.enums.IotSerializeTypeEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT 产品 DO';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/rule/IotDataRuleDO.java
-- Entity: IotDataRuleDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), description text, status int, source_configs json, sink_ids text
CREATE TABLE `iot_data_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '数据流转规格编号',
  `name` varchar(255) NULL COMMENT '数据流转规格名称',
  `description` text NULL COMMENT '数据流转规格描述',
  `status` int NULL COMMENT '数据流转规格状态 枚举 CommonStatusEnum',
  `source_configs` json NULL COMMENT '数据源配置数组',
  `sink_ids` text NULL COMMENT '数据目的编号数组 关联 IotDataSinkDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT 数据流转规则 DO 监听 SourceConfig 数据源，转发到 IotDataSinkDO 数据目的';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/rule/IotDataSinkDO.java
-- Entity: IotDataSinkDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), description text, status int, type int, config json
CREATE TABLE `iot_data_sink` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '数据流转目的编号',
  `name` varchar(255) NULL COMMENT '数据流转目的名称',
  `description` text NULL COMMENT '数据流转目的描述',
  `status` int NULL COMMENT '数据流转目的状态 枚举 CommonStatusEnum',
  `type` int NULL COMMENT '数据流转目的类型 枚举 IotDataSinkTypeEnum',
  `config` json NULL COMMENT '数据流转目的配置',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT 数据流转目的 DO';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/rule/IotSceneRuleDO.java
-- Entity: IotSceneRuleDO extends TenantBaseDO
-- 推断字段类型：id bigint, name varchar(255), description text, status int, last_trigger_time datetime, triggers json, actions json
CREATE TABLE `iot_scene_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '场景联动编号',
  `name` varchar(255) NULL COMMENT '场景联动名称',
  `description` text NULL COMMENT '场景联动描述',
  `status` int NULL COMMENT '场景联动状态 枚举 CommonStatusEnum',
  `last_trigger_time` datetime NULL COMMENT '最后触发时间',
  `triggers` json NULL COMMENT '场景定义配置',
  `actions` json NULL COMMENT '场景动作配置',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT 场景联动规则 DO';

-- Source: yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/thingmodel/IotThingModelDO.java
-- Entity: IotThingModelDO extends BaseDO
-- 推断字段类型：id bigint, identifier varchar(255), name varchar(255), description text, product_id bigint, product_key varchar(255), type int, property json, event json, service json
CREATE TABLE `iot_thing_model` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '物模型功能编号',
  `identifier` varchar(255) NULL COMMENT '功能标识',
  `name` varchar(255) NULL COMMENT '功能名称',
  `description` text NULL COMMENT '功能描述',
  `product_id` bigint NULL COMMENT '产品标识 关联 IotProductDO#getId()',
  `product_key` varchar(255) NULL COMMENT '产品标识 关联 IotProductDO#getProductKey()',
  `type` int NULL COMMENT '功能类型 枚举 IotThingModelTypeEnum',
  `property` json NULL COMMENT '属性',
  `event` json NULL COMMENT '事件',
  `service` json NULL COMMENT '服务',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IoT 产品物模型功能 DO 每个 IotProductDO 和 IotThingModelDO 是“一对多”的关系，它的每个属性、事件、服务都对应一条记录';
