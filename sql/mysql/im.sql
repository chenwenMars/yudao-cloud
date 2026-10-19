-- IM 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/channel/ImChannelDO.java
-- Entity: ImChannelDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), avatar varchar(1024), sort int, status int
CREATE TABLE `im_channel` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '频道业务码',
  `name` varchar(255) NULL COMMENT '频道名称',
  `avatar` varchar(1024) NULL COMMENT '频道头像',
  `sort` int NULL COMMENT '排序',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 频道 DO 业务语义： - 频道是运营单向推送的主体；C 端用户不能向频道发消息 - #code 是业务码（API / 字典外露），id 是数字主键给前端会话 targetId 用';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/channel/ImChannelMaterialDO.java
-- Entity: ImChannelMaterialDO extends BaseDO
-- 推断字段类型：id bigint, channel_id bigint, type int, title varchar(255), cover_url varchar(1024), summary varchar(255), content longtext, url varchar(1024)
-- 特殊类型依据：im_channel_material.content 源实体注释为富文本 HTML；LONGTEXT 容量为推断
CREATE TABLE `im_channel_material` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `channel_id` bigint NULL COMMENT '频道编号 关联 ImChannelDO#getId()',
  `type` int NULL COMMENT '素材内容类型 枚举 ImChannelMaterialTypeEnum',
  `title` varchar(255) NULL COMMENT '标题',
  `cover_url` varchar(1024) NULL COMMENT '封面图',
  `summary` varchar(255) NULL COMMENT '摘要',
  `content` longtext NULL COMMENT '富文本 HTML；在 ImChannelMaterialTypeEnum#CONTENT 使用',
  `url` varchar(1024) NULL COMMENT '跳转链接；在 ImChannelMaterialTypeEnum#LINK 使用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 频道素材 DO 业务语义： - 运营素材库，可被反复推送 - 一条素材 1:N 关联多条 ImChannelMessageDO - #content 富文本仅在素材详情接口按需返回，推送 payload 不带，避免压爆 WebSocket 通道';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/conversation/ImConversationReadDO.java
-- Entity: ImConversationReadDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, conversation_type int, target_id bigint, message_id bigint, read_time datetime
CREATE TABLE `im_conversation_read` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserDO 的 id 字段',
  `conversation_type` int NULL COMMENT '会话类型 枚举 ImConversationTypeEnum',
  `target_id` bigint NULL COMMENT '目标编号 私聊关联 AdminUserDO 的 id；群聊关联 ImGroupDO#getId()；频道关联 ImChannelDO#getId()',
  `message_id` bigint NULL COMMENT '最大已读消息编号 关联 ImPrivateMessageDO#getId()、ImGroupMessageDO#getId()、ImChannelMessageDO#getId()',
  `read_time` datetime NULL COMMENT '最近已读时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 会话读位置 DO 只表达「用户在某个会话的最大已读位置」，私聊 / 群聊 / 频道统一落这张表，是读位置的唯一权威。';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/face/ImFacePackDO.java
-- Entity: ImFacePackDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), icon varchar(512), sort int, status int
-- 特殊类型依据：im_face_pack.icon ImFacePackSaveReqVO.icon @Size(max=512)；按入口上限选用 VARCHAR(512)，物理长度为推断
CREATE TABLE `im_face_pack` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '表情包名称',
  `icon` varchar(512) NULL COMMENT '表情包图标 面板底部 tab 栏显示',
  `sort` int NULL COMMENT '排序',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 表情包 DO（运营配置的系统表情包元数据）';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/face/ImFacePackItemDO.java
-- Entity: ImFacePackItemDO extends BaseDO
-- 推断字段类型：id bigint, pack_id bigint, url varchar(1024), name varchar(255), width int, height int, sort int, status int
CREATE TABLE `im_face_pack_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `pack_id` bigint NULL COMMENT '所属表情包编号',
  `url` varchar(1024) NULL COMMENT '表情图 URL',
  `name` varchar(255) NULL COMMENT '表情名（可选；如「狗头」「捂脸」）',
  `width` int NULL COMMENT '渲染宽度（像素）',
  `height` int NULL COMMENT '渲染高度（像素）',
  `sort` int NULL COMMENT '排序',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 表情包项 DO（系统表情包内的单张表情图）';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/face/ImFaceUserItemDO.java
-- Entity: ImFaceUserItemDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, url varchar(1024), name varchar(255), width int, height int, sort int
CREATE TABLE `im_face_user_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '所属用户编号 关联 AdminUserDO 的 id 编号',
  `url` varchar(1024) NULL COMMENT '表情图 URL',
  `name` varchar(255) NULL COMMENT '表情名（可选） 用户私有表情通常不带名字，留字段以备将来「重命名」交互',
  `width` int NULL COMMENT '渲染宽度（像素）',
  `height` int NULL COMMENT '渲染高度（像素）',
  `sort` int NULL COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 用户私有表情 DO（个人表情包，对照微信「我的表情」）';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/friend/ImFriendDO.java
-- Entity: ImFriendDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, friend_user_id bigint, silent bit(1), display_name varchar(255), add_source int, pinned bit(1), blocked bit(1), status int, add_time datetime, delete_time datetime
CREATE TABLE `im_friend` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserDO 的 id 字段',
  `friend_user_id` bigint NULL COMMENT '好友用户编号 关联 AdminUserDO 的 id 字段',
  `silent` bit(1) NULL COMMENT '是否免打扰',
  `display_name` varchar(255) NULL COMMENT '好友展示备注',
  `add_source` int NULL COMMENT '添加来源 枚举 cn.iocoder.yudao.module.im.enums.friend.ImFriendAddSourceEnum',
  `pinned` bit(1) NULL COMMENT '是否置顶联系人',
  `blocked` bit(1) NULL COMMENT '是否拉黑（弱关联 friend，单边屏蔽对方私聊消息）',
  `status` int NULL COMMENT '好友状态 枚举 CommonStatusEnum',
  `add_time` datetime NULL COMMENT '添加好友时间',
  `delete_time` datetime NULL COMMENT '删除好友时间 不为 null 时表示已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 好友关系 DO 业务语义： - 双向关系：A-B 互为好友会存 2 条记录（userId=A, friendUserId=B 和 userId=B, friendUserId=A） - 状态管理：#status 使用 CommonStatusEnum，ENABLE=正常，DISABLE=已删除 - 免打扰：#silent 控制是否屏蔽来自该好友的通知 - 联系人置顶：#pinned 单边，影响联系人 / 会话排序 - 黑名单：#blocked 弱关联 friend，单边屏蔽对方消息（必须先是好友）';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/friend/ImFriendRequestDO.java
-- Entity: ImFriendRequestDO extends BaseDO
-- 推断字段类型：id bigint, from_user_id bigint, to_user_id bigint, apply_content text, display_name varchar(255), add_source int, handle_result int, handle_content text, handle_time datetime
CREATE TABLE `im_friend_request` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `from_user_id` bigint NULL COMMENT '发起方用户编号 关联 AdminUserDO 的 id 字段',
  `to_user_id` bigint NULL COMMENT '接收方用户编号 关联 AdminUserDO 的 id 字段',
  `apply_content` text NULL COMMENT '申请理由',
  `display_name` varchar(255) NULL COMMENT '发起方对接收方的备注 同意后写入 A 侧 ImFriendDO#getDisplayName()；B 侧不动',
  `add_source` int NULL COMMENT '添加来源 枚举 ImFriendAddSourceEnum',
  `handle_result` int NULL COMMENT '处理结果 枚举 ImFriendRequestHandleResultEnum',
  `handle_content` text NULL COMMENT '处理理由（接收方拒绝时可选填）',
  `handle_time` datetime NULL COMMENT '处理时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 好友申请记录 DO 配合「申请 - 审批」流程： - 发起方调 apply 接口落库（handleResult=UNHANDLED） - 接收方调 agree / refuse 处理（更新 handleResult / handleTime / handleContent） - 申请通过后，displayName / addSource 同步写入 ImFriendDO';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/group/ImGroupDO.java
-- Entity: ImGroupDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), owner_user_id bigint, avatar varchar(1024), notice text, join_approval bit(1), banned bit(1), banned_reason varchar(255), banned_time datetime, status int, dissolved_time datetime, muted_all bit(1), pinned_message_ids text
-- 特殊类型依据：im_group.notice ImGroupUpdateReqVO.notice @Size(max=2048)，可容纳 2048 字符的 TEXT 为容量推断
CREATE TABLE `im_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '群名称',
  `owner_user_id` bigint NULL COMMENT '群主用户编号 关联 AdminUserDO 的 id 字段',
  `avatar` varchar(1024) NULL COMMENT '群头像',
  `notice` text NULL COMMENT '群公告',
  `join_approval` bit(1) NULL COMMENT '进群是否需群主 / 管理员审批 false 自由进群（默认）；true 需审批，所有「申请」「邀请」路径都需群主 / 管理员同意',
  `banned` bit(1) NULL COMMENT '是否封禁',
  `banned_reason` varchar(255) NULL COMMENT '封禁原因',
  `banned_time` datetime NULL COMMENT '封禁时间',
  `status` int NULL COMMENT '群状态 枚举 CommonStatusEnum ENABLE = 正常，DISABLE = 已解散',
  `dissolved_time` datetime NULL COMMENT '解散时间',
  `muted_all` bit(1) NULL COMMENT '是否全群禁言',
  `pinned_message_ids` text NULL COMMENT '群置顶消息编号列表 仅存 messageId，操作人 / 置顶时间从对应 PIN 事件的消息记录里反查',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 群信息 DO';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/group/ImGroupMemberDO.java
-- Entity: ImGroupMemberDO extends BaseDO
-- 推断字段类型：id bigint, group_id bigint, user_id bigint, display_user_name varchar(255), group_remark varchar(255), silent bit(1), status int, role int, join_time datetime, add_source int, inviter_user_id bigint, quit_time datetime, mute_end_time datetime
CREATE TABLE `im_group_member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `group_id` bigint NULL COMMENT '群编号 关联 ImGroupDO#getId()',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserDO 的 id 字段',
  `display_user_name` varchar(255) NULL COMMENT '组内显示名',
  `group_remark` varchar(255) NULL COMMENT '群备注',
  `silent` bit(1) NULL COMMENT '是否免打扰',
  `status` int NULL COMMENT '成员状态 枚举 CommonStatusEnum',
  `role` int NULL COMMENT '成员角色 枚举 ImGroupMemberRoleEnum',
  `join_time` datetime NULL COMMENT '入群时间',
  `add_source` int NULL COMMENT '加入来源 枚举 ImGroupAddSourceEnum',
  `inviter_user_id` bigint NULL COMMENT '邀请人用户编号 关联 AdminUserDO 的 id 字段；用户主动申请进群时为 NULL',
  `quit_time` datetime NULL COMMENT '退群时间',
  `mute_end_time` datetime NULL COMMENT '禁言到期时间 null 表示未禁言；非 null 且在未来表示禁言中；',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 群成员 DO';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/group/ImGroupRequestDO.java
-- Entity: ImGroupRequestDO extends BaseDO
-- 推断字段类型：id bigint, group_id bigint, user_id bigint, inviter_user_id bigint, apply_content text, add_source int, handle_result int, handle_user_id bigint, handle_content text, handle_time datetime
CREATE TABLE `im_group_request` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `group_id` bigint NULL COMMENT '群编号 关联 ImGroupDO#getId()',
  `user_id` bigint NULL COMMENT '申请人 / 被邀请人用户编号 关联 AdminUserDO 的 id 字段',
  `inviter_user_id` bigint NULL COMMENT '邀请人用户编号 NULL 表示用户主动申请进群；非 NULL 表示由群成员邀请、待群主 / 管理员审批',
  `apply_content` text NULL COMMENT '申请理由',
  `add_source` int NULL COMMENT '加入来源 枚举 ImGroupAddSourceEnum；同意时同步写入 ImGroupMemberDO#getAddSource()',
  `handle_result` int NULL COMMENT '处理结果 枚举 ImGroupRequestHandleResultEnum',
  `handle_user_id` bigint NULL COMMENT '处理人用户编号（群主或管理员）',
  `handle_content` text NULL COMMENT '处理理由（拒绝时可选填）',
  `handle_time` datetime NULL COMMENT '处理时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 加群申请记录 DO 配合「申请 - 审批」流程： 用户主动申请：调 apply 接口落库（inviterUserId=null，handleResult=UNHANDLED），群主 / 管理员审批 普通成员邀请：群 joinType=APPLY_AND_NORMAL_INVITE 时落库（inviterUserId=操作人），群主 / 管理员审批 处理：群主 / 管理员调 agree / refuse 推进状态机；同意时把 addSource / inviterUserId 同步写入 ImGroupMemberDO';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/message/ImChannelMessageDO.java
-- Entity: ImChannelMessageDO extends BaseDO
-- 推断字段类型：id bigint, channel_id bigint, material_id bigint, type int, content text, receiver_user_ids text, send_time datetime
CREATE TABLE `im_channel_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `channel_id` bigint NULL COMMENT '频道编号 关联 ImChannelDO#getId()；冗余便于按频道检索',
  `material_id` bigint NULL COMMENT '关联素材编号 关联 ImChannelMaterialDO#getId()',
  `type` int NULL COMMENT '消息类型 枚举 ImContentTypeEnum',
  `content` text NULL COMMENT '消息内容；推送时 payload 的 JSON 快照',
  `receiver_user_ids` text NULL COMMENT '接收人编号列表；为空表示全员',
  `send_time` datetime NULL COMMENT '发送时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 频道消息 DO 业务语义： - 一次推送 1 行；#receiverUserIds 为空表示全员 - #channelId 冗余 ImChannelMaterialDO#getChannelId() 便于按频道检索 - #content 存推送时 payload 的 JSON 快照（title / coverUrl / summary / url）；不含富文本正文';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/message/ImGroupMessageDO.java
-- Entity: ImGroupMessageDO extends BaseDO
-- 不入库字段：readCount
-- 推断字段类型：id bigint, client_message_id varchar(255), sender_id bigint, group_id bigint, type int, content text, status int, send_time datetime, receiver_user_ids text, at_user_ids text, receipt_status int
CREATE TABLE `im_group_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `client_message_id` varchar(255) NULL COMMENT '客户端消息编号，用于发送幂等',
  `sender_id` bigint NULL COMMENT '发送人编号 关联 AdminUserDO 的 id 字段',
  `group_id` bigint NULL COMMENT '群编号 关联 ImGroupDO#getId()',
  `type` int NULL COMMENT '消息类型 枚举 ImContentTypeEnum',
  `content` text NULL COMMENT '消息内容，JSON 格式 参考 content 包下的 TextMessage、ImageMessage 等结构化模型',
  `status` int NULL COMMENT '消息状态 枚举 ImMessageStatusEnum',
  `send_time` datetime NULL COMMENT '发送时间',
  `receiver_user_ids` text NULL COMMENT '定向接收用户编号列表，以逗号分隔 为空表示全员可见 关联 AdminUserDO 的 id 字段',
  `at_user_ids` text NULL COMMENT '@ 目标用户编号列表，以逗号分隔 关联 AdminUserDO 的 id 字段',
  `receipt_status` int NULL COMMENT '回执状态 枚举 ImMessageReceiptStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 群聊消息 DO';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/message/ImPrivateMessageDO.java
-- Entity: ImPrivateMessageDO extends BaseDO
-- 推断字段类型：id bigint, client_message_id varchar(255), sender_id bigint, receiver_id bigint, type int, content text, status int, receipt_status int, send_time datetime
CREATE TABLE `im_private_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `client_message_id` varchar(255) NULL COMMENT '客户端消息编号，用于发送幂等',
  `sender_id` bigint NULL COMMENT '发送人编号 关联 AdminUserDO 的 id 字段',
  `receiver_id` bigint NULL COMMENT '接收人编号 关联 AdminUserDO 的 id 字段',
  `type` int NULL COMMENT '消息类型 枚举 ImContentTypeEnum',
  `content` text NULL COMMENT '消息内容，JSON 格式 参考 content 包下的 TextMessage、ImageMessage 等结构化模型',
  `status` int NULL COMMENT '消息状态 枚举 ImMessageStatusEnum',
  `receipt_status` int NULL COMMENT '回执状态 枚举 ImMessageReceiptStatusEnum',
  `send_time` datetime NULL COMMENT '发送时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 私聊消息 DO';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/rtc/ImRtcCallDO.java
-- Entity: ImRtcCallDO extends BaseDO
-- 推断字段类型：id bigint, room varchar(255), conversation_type int, media_type int, inviter_user_id bigint, group_id bigint, status int, end_reason int, start_time datetime, accept_time datetime, end_time datetime
CREATE TABLE `im_rtc_call` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `room` varchar(255) NULL COMMENT '业务通话编号（UUID，同时作为 LiveKit 房间名）；唯一',
  `conversation_type` int NULL COMMENT '会话类型 枚举 ImConversationTypeEnum',
  `media_type` int NULL COMMENT '媒体类型 枚举 ImRtcCallMediaTypeEnum',
  `inviter_user_id` bigint NULL COMMENT '发起人用户编号 关联 AdminUserDO 的 id 字段',
  `group_id` bigint NULL COMMENT '群编号；私聊为 NULL 关联 ImGroupDO#getId()',
  `status` int NULL COMMENT '通话状态 枚举 ImRtcCallStatusEnum',
  `end_reason` int NULL COMMENT '结束原因；通话未结束时为 NULL 枚举 ImRtcCallEndReasonEnum',
  `start_time` datetime NULL COMMENT '发起时间',
  `accept_time` datetime NULL COMMENT '接通时间 首个非发起人加入时写入；未接通保持 NULL',
  `end_time` datetime NULL COMMENT '通话结束时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 通话记录 DO（房间级 / 主表） 一通通话一行；状态机 CREATED → RUNNING → ENDED；和明细表 ImRtcParticipantDO 通过 #room 关联';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/rtc/ImRtcParticipantDO.java
-- Entity: ImRtcParticipantDO extends BaseDO
-- 推断字段类型：id bigint, call_id bigint, room varchar(255), user_id bigint, role int, status int, invite_time datetime, accept_time datetime, leave_time datetime
CREATE TABLE `im_rtc_participant` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `call_id` bigint NULL COMMENT '通话编号 关联 ImRtcCallDO#getId()',
  `room` varchar(255) NULL COMMENT '业务通话编号 关联 ImRtcCallDO#getRoom()',
  `user_id` bigint NULL COMMENT '参与者用户编号 关联 AdminUserDO 的 id 字段',
  `role` int NULL COMMENT '参与角色 枚举 ImRtcParticipantRoleEnum',
  `status` int NULL COMMENT '参与状态 枚举 ImRtcParticipantStatusEnum',
  `invite_time` datetime NULL COMMENT '被邀请时间；发起人取通话 startTime',
  `accept_time` datetime NULL COMMENT '接听时间；未接听 NULL',
  `leave_time` datetime NULL COMMENT '离开时间；未加入 NULL',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 通话参与者 DO（用户级 / 明细表） 一通通话每个参与者一行；通过 #room 关联主表 ImRtcCallDO 终态闭合：通话 ENDED 时所有明细 status 必属 {LEFT / REJECTED / NO_ANSWER} 之一';

-- Source: yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/sensitiveword/ImSensitiveWordDO.java
-- Entity: ImSensitiveWordDO extends BaseDO
-- 推断字段类型：id bigint, word varchar(255), status int
CREATE TABLE `im_sensitive_word` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `word` varchar(255) NULL COMMENT '敏感词',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='IM 敏感词 DO';
