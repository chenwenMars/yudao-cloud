-- MEMBER 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/address/MemberAddressDO.java
-- Entity: MemberAddressDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, name varchar(255), mobile varchar(255), area_id bigint, detail_address varchar(255), default_status bit(1)
CREATE TABLE `member_address` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号',
  `name` varchar(255) NULL COMMENT '收件人名称',
  `mobile` varchar(255) NULL COMMENT '手机号',
  `area_id` bigint NULL COMMENT '地区编号',
  `detail_address` varchar(255) NULL COMMENT '收件详细地址',
  `default_status` bit(1) NULL COMMENT '是否默认 true - 默认收件地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户收件地址 DO';

-- Source: yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/config/MemberConfigDO.java
-- Entity: MemberConfigDO extends BaseDO
-- 推断字段类型：id bigint, point_trade_deduct_enable bit(1), point_trade_deduct_unit_price int, point_trade_deduct_max_price int, point_trade_give_point int
CREATE TABLE `member_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `point_trade_deduct_enable` bit(1) NULL COMMENT '积分抵扣开关',
  `point_trade_deduct_unit_price` int NULL COMMENT '积分抵扣，单位：分 1 积分抵扣多少分',
  `point_trade_deduct_max_price` int NULL COMMENT '积分抵扣最大值',
  `point_trade_give_point` int NULL COMMENT '1 元赠送多少分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员配置 DO';

-- Source: yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/group/MemberGroupDO.java
-- Entity: MemberGroupDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), remark text, status int
CREATE TABLE `member_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '名称',
  `remark` text NULL COMMENT '备注',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户分组 DO';

-- Source: yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/level/MemberExperienceRecordDO.java
-- Entity: MemberExperienceRecordDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, biz_type int, biz_id varchar(255), title varchar(255), description text, experience int, total_experience int
CREATE TABLE `member_experience_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 MemberUserDO#getId() 字段',
  `biz_type` int NULL COMMENT '业务类型 枚举 MemberExperienceBizTypeEnum',
  `biz_id` varchar(255) NULL COMMENT '业务编号',
  `title` varchar(255) NULL COMMENT '标题',
  `description` text NULL COMMENT '描述',
  `experience` int NULL COMMENT '经验',
  `total_experience` int NULL COMMENT '变更后的经验',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员经验记录 DO';

-- Source: yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/level/MemberLevelDO.java
-- Entity: MemberLevelDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), level int, experience int, discount_percent int, icon varchar(1024), background_url varchar(1024), status int
-- 特殊类型依据：member_level.icon 等级图标存放资源地址；物理容量为推断
CREATE TABLE `member_level` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '等级名称',
  `level` int NULL COMMENT '等级',
  `experience` int NULL COMMENT '升级经验',
  `discount_percent` int NULL COMMENT '享受折扣',
  `icon` varchar(1024) NULL COMMENT '等级图标',
  `background_url` varchar(1024) NULL COMMENT '等级背景图',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员等级 DO 配置每个等级需要的积分';

-- Source: yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/level/MemberLevelRecordDO.java
-- Entity: MemberLevelRecordDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, level_id bigint, level int, discount_percent int, experience int, user_experience int, remark text, description text
CREATE TABLE `member_level_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 MemberUserDO#getId() 字段',
  `level_id` bigint NULL COMMENT '等级编号 关联 MemberLevelDO#getId() 字段',
  `level` int NULL COMMENT '会员等级 冗余 MemberLevelDO#getLevel() 字段',
  `discount_percent` int NULL COMMENT '享受折扣',
  `experience` int NULL COMMENT '升级经验',
  `user_experience` int NULL COMMENT '会员此时的经验',
  `remark` text NULL COMMENT '备注',
  `description` text NULL COMMENT '描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员等级记录 DO 用户每次等级发生变更时，记录一条日志';

-- Source: yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/point/MemberPointRecordDO.java
-- Entity: MemberPointRecordDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, biz_id varchar(255), biz_type int, title varchar(255), description text, point int, total_point int
CREATE TABLE `member_point_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_id` bigint NULL COMMENT '用户编号 对应 MemberUserDO 的 id 属性',
  `biz_id` varchar(255) NULL COMMENT '业务编码',
  `biz_type` int NULL COMMENT '业务类型 枚举 MemberPointBizTypeEnum',
  `title` varchar(255) NULL COMMENT '积分标题',
  `description` text NULL COMMENT '积分描述',
  `point` int NULL COMMENT '变动积分 1、正数表示获得积分 2、负数表示消耗积分',
  `total_point` int NULL COMMENT '变动后的积分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户积分记录 DO';

-- Source: yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/signin/MemberSignInConfigDO.java
-- Entity: MemberSignInConfigDO extends BaseDO
-- 推断字段类型：id bigint, day int, point int, experience int, status int
CREATE TABLE `member_sign_in_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '规则自增主键',
  `day` int NULL COMMENT '签到第 x 天',
  `point` int NULL COMMENT '奖励积分',
  `experience` int NULL COMMENT '奖励经验',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='签到规则 DO';

-- Source: yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/signin/MemberSignInRecordDO.java
-- Entity: MemberSignInRecordDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, day int, point int, experience int
CREATE TABLE `member_sign_in_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '签到用户',
  `day` int NULL COMMENT '第几天签到',
  `point` int NULL COMMENT '签到的积分',
  `experience` int NULL COMMENT '签到的经验',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='签到记录 DO';

-- Source: yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/tag/MemberTagDO.java
-- Entity: MemberTagDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255)
CREATE TABLE `member_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '标签名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员标签 DO';

-- Source: yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/user/MemberUserDO.java
-- Entity: MemberUserDO extends TenantBaseDO
-- 推断字段类型：id bigint, mobile varchar(255), email varchar(255), password varchar(255), status int, register_ip varchar(255), register_terminal int, login_ip varchar(255), login_date datetime, nickname varchar(255), avatar varchar(1024), name varchar(255), sex int, birthday datetime, area_id int, mark text, point int, tag_ids text, level_id bigint, experience int, group_id bigint
-- 特殊类型依据：member_user.mark 会员用户备注按长文本保存；物理容量为推断
CREATE TABLE `member_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `mobile` varchar(255) NULL COMMENT '手机',
  `email` varchar(255) NULL COMMENT '邮箱',
  `password` varchar(255) NULL COMMENT '加密后的密码 因为目前使用 BCryptPasswordEncoder 加密器，所以无需自己处理 salt 盐',
  `status` int NULL COMMENT '帐号状态 枚举 CommonStatusEnum',
  `register_ip` varchar(255) NULL COMMENT '注册 IP',
  `register_terminal` int NULL COMMENT '注册终端 枚举 TerminalEnum',
  `login_ip` varchar(255) NULL COMMENT '最后登录IP',
  `login_date` datetime NULL COMMENT '最后登录时间',
  `nickname` varchar(255) NULL COMMENT '用户昵称',
  `avatar` varchar(1024) NULL COMMENT '用户头像',
  `name` varchar(255) NULL COMMENT '真实名字',
  `sex` int NULL COMMENT '性别 枚举 SexEnum',
  `birthday` datetime NULL COMMENT '出生日期',
  `area_id` int NULL COMMENT '所在地 关联 Area#getId() 字段',
  `mark` text NULL COMMENT '用户备注',
  `point` int NULL COMMENT '积分',
  `tag_ids` text NULL COMMENT '会员标签列表，以逗号分隔',
  `level_id` bigint NULL COMMENT '会员级别编号 关联 MemberLevelDO#getId() 字段',
  `experience` int NULL COMMENT '会员经验',
  `group_id` bigint NULL COMMENT '用户分组编号 关联 MemberGroupDO#getId() 字段',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员用户 DO uk_mobile 索引：基于 #mobile 字段';
