-- MP 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/account/MpAccountDO.java
-- Entity: MpAccountDO extends TenantBaseDO
-- 推断字段类型：id bigint, name varchar(255), account varchar(255), app_id varchar(255), app_secret varchar(255), token varchar(255), aes_key varchar(255), qr_code_url varchar(1024), remark text
CREATE TABLE `mp_account` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '公众号名称',
  `account` varchar(255) NULL COMMENT '公众号账号',
  `app_id` varchar(255) NULL COMMENT '公众号 appid',
  `app_secret` varchar(255) NULL COMMENT '公众号密钥',
  `token` varchar(255) NULL COMMENT '公众号token',
  `aes_key` varchar(255) NULL COMMENT '消息加解密密钥',
  `qr_code_url` varchar(1024) NULL COMMENT '二维码图片 URL',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公众号账号 DO';

-- Source: yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/material/MpMaterialDO.java
-- Entity: MpMaterialDO extends BaseDO
-- 推断字段类型：id bigint, account_id bigint, app_id varchar(255), media_id varchar(255), type varchar(255), permanent bit(1), url varchar(1024), name varchar(255), mp_url varchar(1024), title varchar(255), introduction text
-- 特殊类型依据：mp_material.introduction 媒体素材简介按长文本保存；物理容量为推断
CREATE TABLE `mp_material` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account_id` bigint NULL COMMENT '公众号账号的编号 关联 MpAccountDO#getId()',
  `app_id` varchar(255) NULL COMMENT '公众号 appId 冗余 MpAccountDO#getAppId()',
  `media_id` varchar(255) NULL COMMENT '公众号素材 id',
  `type` varchar(255) NULL COMMENT '文件类型 枚举 WxConsts.MediaFileType',
  `permanent` bit(1) NULL COMMENT '是否永久 true - 永久素材 false - 临时素材',
  `url` varchar(1024) NULL COMMENT '文件服务器的 URL',
  `name` varchar(255) NULL COMMENT '名字 永久素材：非空 临时素材：可能为空。 1. 为空的情况：粉丝主动发送的图片、语音等 2. 非空的情况：主动发送给粉丝的图片、语音等',
  `mp_url` varchar(1024) NULL COMMENT '公众号文件 URL 只有【永久素材】使用',
  `title` varchar(255) NULL COMMENT '视频素材的标题 只有【永久素材】使用',
  `introduction` text NULL COMMENT '视频素材的描述 只有【永久素材】使用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公众号素材 DO 1. 临时素材 2. 永久素材';

-- Source: yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/menu/MpMenuDO.java
-- Entity: MpMenuDO extends BaseDO
-- 推断字段类型：id bigint, account_id bigint, app_id varchar(255), name varchar(255), menu_key varchar(255), parent_id bigint, type varchar(255), url varchar(1024), mini_program_app_id varchar(255), mini_program_page_path varchar(255), article_id varchar(255), reply_message_type varchar(255), reply_content text, reply_media_id varchar(255), reply_media_url varchar(1024), reply_title varchar(255), reply_description text, reply_thumb_media_id varchar(255), reply_thumb_media_url varchar(1024), reply_articles json, reply_music_url varchar(1024), reply_hq_music_url varchar(1024)
-- 特殊类型依据：mp_menu.reply_description 图文或视频回复描述按长文本保存；物理容量为推断
CREATE TABLE `mp_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `account_id` bigint NULL COMMENT '公众号账号的编号 关联 MpAccountDO#getId()',
  `app_id` varchar(255) NULL COMMENT '公众号 appId 冗余 MpAccountDO#getAppId()',
  `name` varchar(255) NULL COMMENT '菜单名称',
  `menu_key` varchar(255) NULL COMMENT '菜单标识 支持多 DB 类型时，无法直接使用 key + @TableField("menuKey") 来实现转换，原因是 "menuKey" AS key 而存在报错',
  `parent_id` bigint NULL COMMENT '父菜单编号',
  `type` varchar(255) NULL COMMENT '按钮类型 枚举 MenuButtonType',
  `url` varchar(1024) NULL COMMENT '网页链接 粉丝点击菜单可打开链接，不超过 1024 字节 类型为 WxConsts.XmlMsgType 的 VIEW、MINIPROGRAM',
  `mini_program_app_id` varchar(255) NULL COMMENT '小程序的 appId 类型为 MenuButtonType 的 MINIPROGRAM',
  `mini_program_page_path` varchar(255) NULL COMMENT '小程序的页面路径 类型为 MenuButtonType 的 MINIPROGRAM',
  `article_id` varchar(255) NULL COMMENT '跳转图文的媒体编号',
  `reply_message_type` varchar(255) NULL COMMENT '消息类型 当 #type 为 CLICK、SCANCODE_WAITMSG 枚举 WxConsts.XmlMsgType 中的 TEXT、IMAGE、VOICE、VIDEO、NEWS、MUSIC',
  `reply_content` text NULL COMMENT '回复的消息内容 消息类型为 WxConsts.XmlMsgType 的 TEXT',
  `reply_media_id` varchar(255) NULL COMMENT '回复的媒体 id 消息类型为 WxConsts.XmlMsgType 的 IMAGE、VOICE、VIDEO',
  `reply_media_url` varchar(1024) NULL COMMENT '回复的媒体 URL 消息类型为 WxConsts.XmlMsgType 的 IMAGE、VOICE、VIDEO',
  `reply_title` varchar(255) NULL COMMENT '回复的标题 消息类型为 WxConsts.XmlMsgType 的 VIDEO',
  `reply_description` text NULL COMMENT '回复的描述 消息类型为 WxConsts.XmlMsgType 的 VIDEO',
  `reply_thumb_media_id` varchar(255) NULL COMMENT '回复的缩略图的媒体 id，通过素材管理中的接口上传多媒体文件，得到的 id 消息类型为 WxConsts.XmlMsgType 的 MUSIC、VIDEO',
  `reply_thumb_media_url` varchar(1024) NULL COMMENT '回复的缩略图的媒体 URL 消息类型为 WxConsts.XmlMsgType 的 MUSIC、VIDEO',
  `reply_articles` json NULL COMMENT '回复的图文消息数组 消息类型为 WxConsts.XmlMsgType 的 NEWS',
  `reply_music_url` varchar(1024) NULL COMMENT '回复的音乐链接 消息类型为 WxConsts.XmlMsgType 的 MUSIC',
  `reply_hq_music_url` varchar(1024) NULL COMMENT '回复的高质量音乐链接 WIFI 环境优先使用该链接播放音乐 消息类型为 WxConsts.XmlMsgType 的 MUSIC',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公众号菜单 DO';

-- Source: yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/message/MpAutoReplyDO.java
-- Entity: MpAutoReplyDO extends BaseDO
-- 推断字段类型：id bigint, account_id bigint, app_id varchar(255), type int, request_keyword varchar(255), request_match int, request_message_type varchar(255), response_message_type varchar(255), response_content text, response_media_id varchar(255), response_media_url varchar(1024), response_title varchar(255), response_description text, response_thumb_media_id varchar(255), response_thumb_media_url varchar(1024), response_articles json, response_music_url varchar(1024), response_hq_music_url varchar(1024)
-- 特殊类型依据：mp_auto_reply.response_description 自动回复媒体描述按长文本保存；物理容量为推断
CREATE TABLE `mp_auto_reply` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account_id` bigint NULL COMMENT '公众号账号的编号 关联 MpAccountDO#getId()',
  `app_id` varchar(255) NULL COMMENT '公众号 appId 冗余 MpAccountDO#getAppId()',
  `type` int NULL COMMENT '回复类型 枚举 MpAutoReplyTypeEnum',
  `request_keyword` varchar(255) NULL COMMENT '请求的关键字 当 #type 为 MpAutoReplyTypeEnum#KEYWORD',
  `request_match` int NULL COMMENT '请求的关键字的匹配 当 #type 为 MpAutoReplyTypeEnum#KEYWORD 枚举 MpAutoReplyMatchEnum',
  `request_message_type` varchar(255) NULL COMMENT '请求的消息类型 当 #type 为 MpAutoReplyTypeEnum#MESSAGE 枚举 XmlMsgType 中的 #REQUEST_MESSAGE_TYPE',
  `response_message_type` varchar(255) NULL COMMENT '回复的消息类型 枚举 XmlMsgType 中的 TEXT、IMAGE、VOICE、VIDEO、NEWS',
  `response_content` text NULL COMMENT '回复的消息内容 消息类型为 WxConsts.XmlMsgType 的 TEXT',
  `response_media_id` varchar(255) NULL COMMENT '回复的媒体 id 消息类型为 WxConsts.XmlMsgType 的 IMAGE、VOICE、VIDEO',
  `response_media_url` varchar(1024) NULL COMMENT '回复的媒体 URL',
  `response_title` varchar(255) NULL COMMENT '回复的标题 消息类型为 WxConsts.XmlMsgType 的 VIDEO',
  `response_description` text NULL COMMENT '回复的描述 消息类型为 WxConsts.XmlMsgType 的 VIDEO',
  `response_thumb_media_id` varchar(255) NULL COMMENT '回复的缩略图的媒体 id，通过素材管理中的接口上传多媒体文件，得到的 id 消息类型为 WxConsts.XmlMsgType 的 MUSIC、VIDEO',
  `response_thumb_media_url` varchar(1024) NULL COMMENT '回复的缩略图的媒体 URL 消息类型为 WxConsts.XmlMsgType 的 MUSIC、VIDEO',
  `response_articles` json NULL COMMENT '回复的图文消息 消息类型为 WxConsts.XmlMsgType 的 NEWS',
  `response_music_url` varchar(1024) NULL COMMENT '回复的音乐链接 消息类型为 WxConsts.XmlMsgType 的 MUSIC',
  `response_hq_music_url` varchar(1024) NULL COMMENT '回复的高质量音乐链接 WIFI 环境优先使用该链接播放音乐 消息类型为 WxConsts.XmlMsgType 的 MUSIC',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公众号消息自动回复 DO';

-- Source: yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/message/MpMessageDO.java
-- Entity: MpMessageDO extends BaseDO
-- 推断字段类型：id bigint, msg_id bigint, account_id bigint, app_id varchar(255), user_id bigint, openid varchar(255), type varchar(255), send_from int, content text, media_id varchar(255), media_url varchar(1024), recognition text, format varchar(255), title varchar(255), description text, thumb_media_id varchar(255), thumb_media_url varchar(1024), url varchar(1024), location_x double, location_y double, scale double, label varchar(255), articles json, music_url varchar(1024), hq_music_url varchar(1024), event varchar(255), event_key varchar(255)
-- 特殊类型依据：mp_message.recognition 语音识别结果可能为长文本；物理容量为推断
CREATE TABLE `mp_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msg_id` bigint NULL COMMENT '微信公众号消息 id',
  `account_id` bigint NULL COMMENT '公众号账号的 ID 关联 MpAccountDO#getId()',
  `app_id` varchar(255) NULL COMMENT '公众号 appid 冗余 MpAccountDO#getAppId()',
  `user_id` bigint NULL COMMENT '公众号粉丝的编号 关联 MpUserDO#getId()',
  `openid` varchar(255) NULL COMMENT '公众号粉丝标志 冗余 MpUserDO#getOpenid()',
  `type` varchar(255) NULL COMMENT '消息类型 枚举 WxConsts.XmlMsgType',
  `send_from` int NULL COMMENT '消息来源 枚举 MpMessageSendFromEnum',
  `content` text NULL COMMENT '消息内容 消息类型为 WxConsts.XmlMsgType 的 TEXT',
  `media_id` varchar(255) NULL COMMENT '媒体文件的编号 消息类型为 WxConsts.XmlMsgType 的 IMAGE、VOICE、VIDEO',
  `media_url` varchar(1024) NULL COMMENT '媒体文件的 URL',
  `recognition` text NULL COMMENT '语音识别后文本 消息类型为 WxConsts.XmlMsgType 的 VOICE',
  `format` varchar(255) NULL COMMENT '语音格式，如 amr，speex 等 消息类型为 WxConsts.XmlMsgType 的 VOICE',
  `title` varchar(255) NULL COMMENT '标题 消息类型为 WxConsts.XmlMsgType 的 VIDEO、MUSIC、LINK',
  `description` text NULL COMMENT '描述 消息类型为 WxConsts.XmlMsgType 的 VIDEO、MUSIC',
  `thumb_media_id` varchar(255) NULL COMMENT '缩略图的媒体 id，通过素材管理中的接口上传多媒体文件，得到的 id 消息类型为 WxConsts.XmlMsgType 的 MUSIC、VIDEO',
  `thumb_media_url` varchar(1024) NULL COMMENT '缩略图的媒体 URL 消息类型为 WxConsts.XmlMsgType 的 MUSIC、VIDEO',
  `url` varchar(1024) NULL COMMENT '点击图文消息跳转链接 消息类型为 WxConsts.XmlMsgType 的 LINK',
  `location_x` double NULL COMMENT '地理位置维度 消息类型为 WxConsts.XmlMsgType 的 LOCATION',
  `location_y` double NULL COMMENT '地理位置经度 消息类型为 WxConsts.XmlMsgType 的 LOCATION',
  `scale` double NULL COMMENT '地图缩放大小 消息类型为 WxConsts.XmlMsgType 的 LOCATION',
  `label` varchar(255) NULL COMMENT '详细地址 消息类型为 WxConsts.XmlMsgType 的 LOCATION 例如说杨浦区黄兴路 221-4 号临',
  `articles` json NULL COMMENT '图文消息数组 消息类型为 WxConsts.XmlMsgType 的 NEWS',
  `music_url` varchar(1024) NULL COMMENT '音乐链接 消息类型为 WxConsts.XmlMsgType 的 MUSIC',
  `hq_music_url` varchar(1024) NULL COMMENT '高质量音乐链接 WIFI 环境优先使用该链接播放音乐 消息类型为 WxConsts.XmlMsgType 的 MUSIC',
  `event` varchar(255) NULL COMMENT '事件类型 枚举 WxConsts.EventType',
  `event_key` varchar(255) NULL COMMENT '事件 Key 1. WxConsts.EventType 的 SCAN：qrscene_ 为前缀，后面为二维码的参数值 2. WxConsts.EventType 的 CLICK：与自定义菜单接口中 KEY 值对应',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公众号消息 DO';

-- Source: yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/message/MpMessageTemplateDO.java
-- Entity: MpMessageTemplateDO extends BaseDO
-- 推断字段类型：id bigint, account_id bigint, app_id varchar(255), template_id varchar(255), title varchar(255), content text, example text, primary_industry varchar(255), deputy_industry varchar(255)
-- 特殊类型依据：mp_message_template.example 微信模板示例可以包含完整多行内容；物理容量为推断
CREATE TABLE `mp_message_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account_id` bigint NULL COMMENT '公众号账号的编号 关联 MpAccountDO#getId()',
  `app_id` varchar(255) NULL COMMENT '公众号 appId 冗余 MpAccountDO#getAppId()',
  `template_id` varchar(255) NULL COMMENT '公众号模板 ID',
  `title` varchar(255) NULL COMMENT '标题',
  `content` text NULL COMMENT '模板内容',
  `example` text NULL COMMENT '模板示例',
  `primary_industry` varchar(255) NULL COMMENT '模板所属行业的一级行业',
  `deputy_industry` varchar(255) NULL COMMENT '模板所属行业的二级行业',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公众号模版消息 DO';

-- Source: yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/tag/MpTagDO.java
-- Entity: MpTagDO extends BaseDO
-- 推断字段类型：id bigint, tag_id bigint, name varchar(255), count int, account_id bigint, app_id varchar(255)
-- 主键策略：mp_tag.id 显式 IdType.INPUT，由应用提供编号，不设置 AUTO_INCREMENT。
CREATE TABLE `mp_tag` (
  `id` bigint NOT NULL COMMENT '主键',
  `tag_id` bigint NULL COMMENT '公众号标签 id',
  `name` varchar(255) NULL COMMENT '标签名',
  `count` int NULL COMMENT '此标签下粉丝数 冗余：WxUserTag#getCount() 字段，需要管理员点击【同步】后，更新该字段',
  `account_id` bigint NULL COMMENT '公众号账号的编号 关联 MpAccountDO#getId()',
  `app_id` varchar(255) NULL COMMENT '公众号 appId 冗余 MpAccountDO#getAppId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公众号标签 DO';

-- Source: yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/user/MpUserDO.java
-- Entity: MpUserDO extends BaseDO
-- 推断字段类型：id bigint, openid varchar(255), union_id varchar(255), subscribe_status int, subscribe_time datetime, unsubscribe_time datetime, nickname varchar(255), head_image_url varchar(1024), language varchar(255), country varchar(255), province varchar(255), city varchar(255), remark text, tag_ids text, account_id bigint, app_id varchar(255)
CREATE TABLE `mp_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `openid` varchar(255) NULL COMMENT '粉丝标识',
  `union_id` varchar(255) NULL COMMENT '微信生态唯一标识',
  `subscribe_status` int NULL COMMENT '关注状态 枚举 CommonStatusEnum 1. 开启 - 已关注 2. 禁用 - 取消关注',
  `subscribe_time` datetime NULL COMMENT '关注时间',
  `unsubscribe_time` datetime NULL COMMENT '取消关注时间',
  `nickname` varchar(255) NULL COMMENT '昵称 注意，2021-12-27 公众号接口不再返回头像和昵称，只能通过微信公众号的网页登录获取',
  `head_image_url` varchar(1024) NULL COMMENT '头像地址 注意，2021-12-27 公众号接口不再返回头像和昵称，只能通过微信公众号的网页登录获取',
  `language` varchar(255) NULL COMMENT '语言',
  `country` varchar(255) NULL COMMENT '国家',
  `province` varchar(255) NULL COMMENT '省份',
  `city` varchar(255) NULL COMMENT '城市',
  `remark` text NULL COMMENT '备注',
  `tag_ids` text NULL COMMENT '标签编号数组 注意，对应的是 MpTagDO#getTagId() 字段',
  `account_id` bigint NULL COMMENT '公众号账号的编号 关联 MpAccountDO#getId()',
  `app_id` varchar(255) NULL COMMENT '公众号 appId 冗余 MpAccountDO#getAppId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='微信公众号粉丝 DO';
