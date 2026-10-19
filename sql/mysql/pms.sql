-- PMS 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/content/PmsKnowledgeContentPermissionDO.java
-- Entity: PmsKnowledgeContentPermissionDO extends BaseDO
-- 推断字段类型：id bigint, library_id bigint, open_status bit(1), open_level int
CREATE TABLE `pms_knowledge_content_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '内容协作权限编号',
  `library_id` bigint NULL COMMENT '知识库编号 关联 PmsKnowledgeLibraryDO#getId()',
  `open_status` bit(1) NULL COMMENT '是否对知识库可访问人公开',
  `open_level` int NULL COMMENT '公开协作等级 枚举 PmsKnowledgeContentLevelEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识内容协作权限 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/content/PmsKnowledgeContentPermissionMemberDO.java
-- Entity: PmsKnowledgeContentPermissionMemberDO extends BaseDO
-- 推断字段类型：id bigint, permission_id bigint, user_id bigint, dept_id bigint, level int
CREATE TABLE `pms_knowledge_content_permission_member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '协作者编号',
  `permission_id` bigint NULL COMMENT '内容协作权限编号 关联 PmsKnowledgeContentPermissionDO#getId()',
  `user_id` bigint NULL COMMENT '后台用户编号 关联 AdminUserRespDTO#getId()',
  `dept_id` bigint NULL COMMENT '部门编号 关联 DeptRespDTO#getId()',
  `level` int NULL COMMENT '协作等级 枚举 PmsKnowledgeContentLevelEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识内容协作者 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/content/PmsKnowledgeDocumentDO.java
-- Entity: PmsKnowledgeDocumentDO extends BaseDO
-- 推断字段类型：id bigint, library_id bigint, permission_id bigint, folder_id bigint, parent_id bigint, title varchar(255), content longtext, type int, file_type varchar(255), file_size bigint, status int, label_ids text, delete_user_id bigint, delete_time datetime
-- 特殊类型依据：pms_knowledge_document.content 源实体为文档正文或文件地址；LONGTEXT 容量为推断
CREATE TABLE `pms_knowledge_document` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文档编号',
  `library_id` bigint NULL COMMENT '知识库编号 关联 PmsKnowledgeLibraryDO#getId()',
  `permission_id` bigint NULL COMMENT '内容协作权限编号 关联 PmsKnowledgeContentPermissionDO#getId()',
  `folder_id` bigint NULL COMMENT '文件夹编号，0 表示不在文件夹中 关联 PmsKnowledgeFolderDO#getId()',
  `parent_id` bigint NULL COMMENT '父文档编号，0 表示根文档 关联 #getId()',
  `title` varchar(255) NULL COMMENT '文档标题',
  `content` longtext NULL COMMENT '文档内容或文件地址',
  `type` int NULL COMMENT '文档类型 枚举 PmsKnowledgeDocumentTypeEnum',
  `file_type` varchar(255) NULL COMMENT '文件类型',
  `file_size` bigint NULL COMMENT '文件大小，单位：字节',
  `status` int NULL COMMENT '文档状态 枚举 PmsKnowledgeDocumentStatusEnum',
  `label_ids` text NULL COMMENT '标签编号列表 关联 PmsKnowledgeDocumentLabelDO#getId()',
  `delete_user_id` bigint NULL COMMENT '删除人用户编号 关联 AdminUserRespDTO#getId()',
  `delete_time` datetime NULL COMMENT '删除时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识库文档 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/content/PmsKnowledgeDocumentLabelDO.java
-- Entity: PmsKnowledgeDocumentLabelDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), color varchar(255)
CREATE TABLE `pms_knowledge_document_label` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文档标签编号',
  `name` varchar(255) NULL COMMENT '标签名称',
  `color` varchar(255) NULL COMMENT '标签颜色',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识库文档标签 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/content/PmsKnowledgeFolderDO.java
-- Entity: PmsKnowledgeFolderDO extends BaseDO
-- 推断字段类型：id bigint, library_id bigint, permission_id bigint, parent_id bigint, title varchar(255), status int, delete_user_id bigint, delete_time datetime
CREATE TABLE `pms_knowledge_folder` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文件夹编号',
  `library_id` bigint NULL COMMENT '知识库编号 关联 PmsKnowledgeLibraryDO#getId()',
  `permission_id` bigint NULL COMMENT '内容协作权限编号 关联 PmsKnowledgeContentPermissionDO#getId()',
  `parent_id` bigint NULL COMMENT '父文件夹编号，0 表示根目录 关联 #getId()',
  `title` varchar(255) NULL COMMENT '文件夹标题',
  `status` int NULL COMMENT '文件夹状态 枚举 PmsKnowledgeDocumentStatusEnum',
  `delete_user_id` bigint NULL COMMENT '删除人用户编号 关联 AdminUserRespDTO#getId()',
  `delete_time` datetime NULL COMMENT '删除时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识库文件夹 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/interaction/PmsKnowledgeDocumentCommentDO.java
-- Entity: PmsKnowledgeDocumentCommentDO extends BaseDO
-- 推断字段类型：id bigint, document_id bigint, user_id bigint, main_id bigint, reply_user_id bigint, content text
-- 特殊类型依据：pms_knowledge_document_comment.content 对应 SaveReqVO.content @Size(max=2000)；TEXT 可容纳 2000 字符，物理容量为推断
CREATE TABLE `pms_knowledge_document_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论编号',
  `document_id` bigint NULL COMMENT '文档编号 关联 PmsKnowledgeDocumentDO#getId()',
  `user_id` bigint NULL COMMENT '评论人用户编号 关联 AdminUserRespDTO#getId()',
  `main_id` bigint NULL COMMENT '主评论编号，0 表示主评论 关联 #getId()',
  `reply_user_id` bigint NULL COMMENT '回复对象用户编号 关联 AdminUserRespDTO#getId()',
  `content` text NULL COMMENT '评论内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识库文档评论 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/interaction/PmsKnowledgeDocumentLikeDO.java
-- Entity: PmsKnowledgeDocumentLikeDO extends BaseDO
-- 推断字段类型：id bigint, document_id bigint, user_id bigint
CREATE TABLE `pms_knowledge_document_like` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '点赞编号',
  `document_id` bigint NULL COMMENT '文档编号 关联 PmsKnowledgeDocumentDO#getId()',
  `user_id` bigint NULL COMMENT '点赞人用户编号 关联 AdminUserRespDTO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识文档点赞 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/interaction/PmsKnowledgeDocumentShareDO.java
-- Entity: PmsKnowledgeDocumentShareDO extends BaseDO
-- 推断字段类型：id bigint, document_id bigint, share_user_ids json, token varchar(255), status int, close_user_id bigint, close_time datetime
CREATE TABLE `pms_knowledge_document_share` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分享编号',
  `document_id` bigint NULL COMMENT '文档编号 关联 PmsKnowledgeDocumentDO#getId()',
  `share_user_ids` json NULL COMMENT '内部分享成员用户编号列表 关联 AdminUserRespDTO#getId()',
  `token` varchar(255) NULL COMMENT '外部查看令牌',
  `status` int NULL COMMENT '分享状态 枚举 CommonStatusEnum',
  `close_user_id` bigint NULL COMMENT '关闭人用户编号 关联 AdminUserRespDTO#getId()',
  `close_time` datetime NULL COMMENT '关闭时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识库文档分享 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/interaction/PmsKnowledgeFavoriteDO.java
-- Entity: PmsKnowledgeFavoriteDO extends BaseDO
-- 推断字段类型：id bigint, library_id bigint, type int, entity_id bigint, user_id bigint
CREATE TABLE `pms_knowledge_favorite` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '收藏编号',
  `library_id` bigint NULL COMMENT '知识库编号 关联 PmsKnowledgeLibraryDO#getId()',
  `type` int NULL COMMENT '收藏对象类型 枚举 PmsKnowledgeObjectTypeEnum',
  `entity_id` bigint NULL COMMENT '收藏对象编号 根据 #getType() 关联知识库、文件夹或文档编号',
  `user_id` bigint NULL COMMENT '收藏人用户编号 关联 AdminUserRespDTO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识收藏（关注）DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/interaction/PmsKnowledgeViewRecordDO.java
-- Entity: PmsKnowledgeViewRecordDO extends BaseDO
-- 推断字段类型：id bigint, library_id bigint, type int, entity_id bigint, user_id bigint
CREATE TABLE `pms_knowledge_view_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '浏览记录编号',
  `library_id` bigint NULL COMMENT '知识库编号 关联 PmsKnowledgeLibraryDO#getId()',
  `type` int NULL COMMENT '浏览对象类型 枚举 PmsKnowledgeObjectTypeEnum',
  `entity_id` bigint NULL COMMENT '浏览对象编号 根据 #getType() 关联文件夹或文档编号',
  `user_id` bigint NULL COMMENT '浏览人用户编号 关联 AdminUserRespDTO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识最近浏览记录 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/library/PmsKnowledgeGroupDO.java
-- Entity: PmsKnowledgeGroupDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, name varchar(255), sort int, type int
CREATE TABLE `pms_knowledge_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '知识库分组编号',
  `user_id` bigint NULL COMMENT '后台用户编号 关联 AdminUserRespDTO#getId()',
  `name` varchar(255) NULL COMMENT '分组名称',
  `sort` int NULL COMMENT '显示顺序',
  `type` int NULL COMMENT '分组类型 枚举 PmsKnowledgeGroupTypeEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 个人知识库分组 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/library/PmsKnowledgeGroupRelationDO.java
-- Entity: PmsKnowledgeGroupRelationDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, group_id bigint, library_id bigint, sort int
CREATE TABLE `pms_knowledge_group_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '后台用户编号 关联 AdminUserRespDTO#getId()',
  `group_id` bigint NULL COMMENT '知识库分组编号 关联 PmsKnowledgeGroupDO#getId()',
  `library_id` bigint NULL COMMENT '知识库编号 关联 PmsKnowledgeLibraryDO#getId()',
  `sort` int NULL COMMENT '显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 个人知识库分组关系 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/library/PmsKnowledgeLibraryDO.java
-- Entity: PmsKnowledgeLibraryDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), description text, open_status bit(1), cover_url varchar(1024), status int, delete_user_id bigint, delete_time datetime
CREATE TABLE `pms_knowledge_library` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '知识库编号',
  `name` varchar(255) NULL COMMENT '知识库名称',
  `description` text NULL COMMENT '知识库简介',
  `open_status` bit(1) NULL COMMENT '是否公开',
  `cover_url` varchar(1024) NULL COMMENT '知识库封面',
  `status` int NULL COMMENT '知识库状态 枚举 PmsKnowledgeDocumentStatusEnum',
  `delete_user_id` bigint NULL COMMENT '删除人用户编号 关联 AdminUserRespDTO#getId()',
  `delete_time` datetime NULL COMMENT '删除时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识库 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/library/PmsKnowledgeLibraryMemberDO.java
-- Entity: PmsKnowledgeLibraryMemberDO extends BaseDO
-- 推断字段类型：id bigint, library_id bigint, user_id bigint, dept_id bigint, level int
CREATE TABLE `pms_knowledge_library_member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '成员编号',
  `library_id` bigint NULL COMMENT '知识库编号 关联 PmsKnowledgeLibraryDO#getId()',
  `user_id` bigint NULL COMMENT '后台用户编号 关联 AdminUserRespDTO#getId()',
  `dept_id` bigint NULL COMMENT '部门编号 关联 DeptRespDTO#getId()',
  `level` int NULL COMMENT '成员等级 枚举 PmsKnowledgeLibraryMemberLevelEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识库成员 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/library/PmsKnowledgeLibraryTemplateDO.java
-- Entity: PmsKnowledgeLibraryTemplateDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), description text, cover_url varchar(1024), status int, sort int, documents json
CREATE TABLE `pms_knowledge_library_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '模板编号',
  `name` varchar(255) NULL COMMENT '模板名称',
  `description` text NULL COMMENT '模板简介',
  `cover_url` varchar(1024) NULL COMMENT '模板封面地址',
  `status` int NULL COMMENT '模板状态 枚举 CommonStatusEnum',
  `sort` int NULL COMMENT '显示顺序',
  `documents` json NULL COMMENT '模板文档列表',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识库模板 DO 模板只保存新建知识库时使用的默认文档，知识库创建后会生成独立的文档内容';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/recycle/PmsKnowledgeRecycleRecordDO.java
-- Entity: PmsKnowledgeRecycleRecordDO extends BaseDO
-- 推断字段类型：id bigint, library_id bigint, type int, entity_id bigint, name varchar(255), delete_user_id bigint, delete_time datetime
CREATE TABLE `pms_knowledge_recycle_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '回收站记录编号',
  `library_id` bigint NULL COMMENT '知识库编号 关联 PmsKnowledgeLibraryDO#getId()',
  `type` int NULL COMMENT '回收对象类型 枚举 PmsKnowledgeObjectTypeEnum',
  `entity_id` bigint NULL COMMENT '回收对象编号 根据 #getType() 关联知识库、文件夹或文档编号',
  `name` varchar(255) NULL COMMENT '回收对象名称',
  `delete_user_id` bigint NULL COMMENT '删除人用户编号 关联 AdminUserRespDTO#getId()',
  `delete_time` datetime NULL COMMENT '删除时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 知识库回收站记录 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/iteration/PmsIterationDO.java
-- Entity: PmsIterationDO extends BaseDO
-- 推断字段类型：id bigint, project_id bigint, name varchar(255), owner_user_id bigint, status int, start_time datetime, end_time datetime, finish_time datetime, target varchar(255), description text, sort int
CREATE TABLE `pms_iteration` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '迭代编号',
  `project_id` bigint NULL COMMENT '项目编号 关联 PmsProjectDO#getId()',
  `name` varchar(255) NULL COMMENT '迭代名称',
  `owner_user_id` bigint NULL COMMENT '负责人用户编号 关联 AdminUserRespDTO#getId()',
  `status` int NULL COMMENT '迭代状态 枚举 PmsIterationStatusEnum',
  `start_time` datetime NULL COMMENT '开始时间',
  `end_time` datetime NULL COMMENT '结束时间',
  `finish_time` datetime NULL COMMENT '完成时间',
  `target` varchar(255) NULL COMMENT '迭代目标',
  `description` text NULL COMMENT '迭代描述',
  `sort` int NULL COMMENT '显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 项目迭代 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectAnnouncementDO.java
-- Entity: PmsProjectAnnouncementDO extends BaseDO
-- 推断字段类型：id bigint, project_id bigint, content text, file_urls json
-- 特殊类型依据：pms_project_announcement.content PmsProjectAnnouncementSaveReqVO.content @Size(max=5000)；TEXT 可容纳 5000 字符，物理容量为推断
CREATE TABLE `pms_project_announcement` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告编号',
  `project_id` bigint NULL COMMENT '项目编号 关联 PmsProjectDO#getId()',
  `content` text NULL COMMENT '公告内容',
  `file_urls` json NULL COMMENT '附件地址列表',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 项目公告 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectDO.java
-- Entity: PmsProjectDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), status int, type int, level int, description text, open_status bit(1), icon varchar(255), sort int, start_time datetime, end_time datetime, archive_time datetime, recycle_time datetime, access_time datetime
CREATE TABLE `pms_project` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '项目编号',
  `name` varchar(255) NULL COMMENT '项目名称',
  `status` int NULL COMMENT '项目状态 枚举 PmsProjectStatusEnum',
  `type` int NULL COMMENT '项目类型 枚举 PmsProjectTypeEnum',
  `level` int NULL COMMENT '项目优先级 枚举 PmsProjectLevelEnum',
  `description` text NULL COMMENT '项目描述',
  `open_status` bit(1) NULL COMMENT '是否公开',
  `icon` varchar(255) NULL COMMENT '项目图标',
  `sort` int NULL COMMENT '显示顺序',
  `start_time` datetime NULL COMMENT '开始时间',
  `end_time` datetime NULL COMMENT '截止时间',
  `archive_time` datetime NULL COMMENT '归档时间',
  `recycle_time` datetime NULL COMMENT '移入回收站时间',
  `access_time` datetime NULL COMMENT '最近访问时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 项目 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectFavoriteDO.java
-- Entity: PmsProjectFavoriteDO extends BaseDO
-- 推断字段类型：id bigint, project_id bigint, user_id bigint
CREATE TABLE `pms_project_favorite` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '收藏编号',
  `project_id` bigint NULL COMMENT '项目编号 关联 PmsProjectDO#getId()',
  `user_id` bigint NULL COMMENT '收藏人用户编号 关联 AdminUserRespDTO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 项目收藏 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectGroupDO.java
-- Entity: PmsProjectGroupDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, name varchar(255), sort int, type int
CREATE TABLE `pms_project_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分组编号',
  `user_id` bigint NULL COMMENT '后台用户编号 关联 AdminUserRespDTO#getId()',
  `name` varchar(255) NULL COMMENT '分组名称',
  `sort` int NULL COMMENT '显示顺序',
  `type` int NULL COMMENT '分组类型 枚举 PmsProjectGroupTypeEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 项目分组 DO 项目分组是后台用户个人维护的项目视图，不影响其他成员看到的项目分组';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectGroupRelationDO.java
-- Entity: PmsProjectGroupRelationDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, group_id bigint, project_id bigint, sort int
CREATE TABLE `pms_project_group_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '后台用户编号 关联 AdminUserRespDTO#getId()',
  `group_id` bigint NULL COMMENT '项目分组编号 关联 PmsProjectGroupDO#getId()',
  `project_id` bigint NULL COMMENT '项目编号 关联 PmsProjectDO#getId()',
  `sort` int NULL COMMENT '显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 项目分组关系 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectMemberDO.java
-- Entity: PmsProjectMemberDO extends BaseDO
-- 推断字段类型：id bigint, project_id bigint, user_id bigint, level int
CREATE TABLE `pms_project_member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `project_id` bigint NULL COMMENT '项目编号 关联 PmsProjectDO#getId()',
  `user_id` bigint NULL COMMENT '后台用户编号 关联 AdminUserRespDTO#getId()',
  `level` int NULL COMMENT '成员权限级别 枚举 PmsProjectMemberLevelEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 项目成员 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectTemplateDO.java
-- Entity: PmsProjectTemplateDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), description text, project_type int, status int, sort int, item_types json, statuses json, boards json
CREATE TABLE `pms_project_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '模板编号',
  `name` varchar(255) NULL COMMENT '模板名称',
  `description` text NULL COMMENT '模板描述',
  `project_type` int NULL COMMENT '项目类型 枚举 PmsProjectTypeEnum',
  `status` int NULL COMMENT '模板状态 枚举 CommonStatusEnum',
  `sort` int NULL COMMENT '显示顺序',
  `item_types` json NULL COMMENT '启用的工作项类型列表 枚举 PmsWorkItemTypeEnum',
  `statuses` json NULL COMMENT '工作项状态模板列表',
  `boards` json NULL COMMENT '看板列模板列表',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 项目模板 DO 模板只保存新建项目时使用的默认协作配置，项目创建后会生成自己的运行配置';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemActivityDO.java
-- Entity: PmsWorkItemActivityDO extends BaseDO
-- 推断字段类型：id bigint, project_id bigint, work_item_id bigint, operator_user_id bigint, content text
CREATE TABLE `pms_work_item_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '动态编号',
  `project_id` bigint NULL COMMENT '项目编号 关联 PmsProjectDO#getId()',
  `work_item_id` bigint NULL COMMENT '工作项编号 关联 PmsWorkItemDO#getId()',
  `operator_user_id` bigint NULL COMMENT '操作人用户编号 关联 AdminUserRespDTO#getId()',
  `content` text NULL COMMENT '动态内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 工作项动态 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemBoardDO.java
-- Entity: PmsWorkItemBoardDO extends BaseDO
-- 推断字段类型：id bigint, project_id bigint, work_item_type int, name varchar(255), sort int
CREATE TABLE `pms_work_item_board` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '看板列编号',
  `project_id` bigint NULL COMMENT '项目编号 关联 PmsProjectDO#getId()',
  `work_item_type` int NULL COMMENT '工作项类型 枚举 PmsWorkItemTypeEnum',
  `name` varchar(255) NULL COMMENT '看板列名称',
  `sort` int NULL COMMENT '显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 工作项看板列 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemCommentDO.java
-- Entity: PmsWorkItemCommentDO extends BaseDO
-- 推断字段类型：id bigint, work_item_id bigint, user_id bigint, main_id bigint, reply_user_id bigint, content text
-- 特殊类型依据：pms_work_item_comment.content 对应 SaveReqVO.content @Size(max=2000)；TEXT 可容纳 2000 字符，物理容量为推断
CREATE TABLE `pms_work_item_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论编号',
  `work_item_id` bigint NULL COMMENT '工作项编号 关联 PmsWorkItemDO#getId()',
  `user_id` bigint NULL COMMENT '评论人用户编号 关联 AdminUserRespDTO#getId()',
  `main_id` bigint NULL COMMENT '主评论编号，#MAIN_ID_ROOT 表示主评论 关联 #getId()',
  `reply_user_id` bigint NULL COMMENT '回复对象用户编号 关联 AdminUserRespDTO#getId()',
  `content` text NULL COMMENT '评论内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 工作项评论 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemDO.java
-- Entity: PmsWorkItemDO extends BaseDO
-- 推断字段类型：id bigint, project_id bigint, type int, serial_number int, name varchar(255), description text, priority int, assignee_user_id bigint, status_id bigint, status int, lifecycle_status int, archive_time datetime, recycle_time datetime, iteration_id bigint, parent_id bigint, related_requirement_id bigint, defect_type int, start_time datetime, end_time datetime, estimated_hours int, progress int, file_urls json, label_ids json, sort int
-- 特殊类型依据：pms_work_item.description PmsWorkItemSaveReqVO.description @Size(max=5000)；TEXT 可容纳 5000 字符，物理容量为推断
CREATE TABLE `pms_work_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '工作项编号',
  `project_id` bigint NULL COMMENT '项目编号 关联 PmsProjectDO#getId()',
  `type` int NULL COMMENT '工作项类型 枚举 PmsWorkItemTypeEnum',
  `serial_number` int NULL COMMENT '项目内工作项序号',
  `name` varchar(255) NULL COMMENT '工作项标题',
  `description` text NULL COMMENT '工作项描述',
  `priority` int NULL COMMENT '优先级 枚举 PmsWorkItemPriorityEnum',
  `assignee_user_id` bigint NULL COMMENT '负责人用户编号 关联 AdminUserRespDTO#getId()',
  `status_id` bigint NULL COMMENT '看板状态编号 关联 PmsWorkItemStatusDO#getId()',
  `status` int NULL COMMENT '语义状态 枚举 PmsWorkItemStatusTypeEnum',
  `lifecycle_status` int NULL COMMENT '生命周期状态 枚举 PmsWorkItemLifecycleStatusEnum',
  `archive_time` datetime NULL COMMENT '归档时间',
  `recycle_time` datetime NULL COMMENT '移入回收站时间',
  `iteration_id` bigint NULL COMMENT '所属迭代编号 关联 PmsIterationDO#getId()',
  `parent_id` bigint NULL COMMENT '父工作项编号 关联 #getId()',
  `related_requirement_id` bigint NULL COMMENT '关联需求编号 关联 #getId()',
  `defect_type` int NULL COMMENT '缺陷类型 枚举 PmsWorkItemDefectTypeEnum',
  `start_time` datetime NULL COMMENT '开始时间',
  `end_time` datetime NULL COMMENT '截止时间',
  `estimated_hours` int NULL COMMENT '预估工时，单位：小时',
  `progress` int NULL COMMENT '完成进度，取值范围 0-100',
  `file_urls` json NULL COMMENT '附件地址列表',
  `label_ids` json NULL COMMENT '标签编号列表 关联 PmsWorkItemLabelDO#getId()',
  `sort` int NULL COMMENT '看板内显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 工作项 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemLabelDO.java
-- Entity: PmsWorkItemLabelDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), color varchar(255)
CREATE TABLE `pms_work_item_label` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '标签编号',
  `name` varchar(255) NULL COMMENT '标签名称',
  `color` varchar(255) NULL COMMENT '标签颜色',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 工作项标签 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemMemberDO.java
-- Entity: PmsWorkItemMemberDO extends BaseDO
-- 推断字段类型：id bigint, project_id bigint, work_item_id bigint, user_id bigint
CREATE TABLE `pms_work_item_member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `project_id` bigint NULL COMMENT '项目编号 关联 PmsProjectDO#getId()',
  `work_item_id` bigint NULL COMMENT '工作项编号 关联 PmsWorkItemDO#getId()',
  `user_id` bigint NULL COMMENT '后台用户编号 关联 AdminUserRespDTO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 工作项参与人 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemStatusDO.java
-- Entity: PmsWorkItemStatusDO extends BaseDO
-- 推断字段类型：id bigint, project_id bigint, work_item_type int, name varchar(255), status_type int, description text, board_name varchar(255), system_code varchar(255), default_status bit(1), sort int
CREATE TABLE `pms_work_item_status` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '状态编号',
  `project_id` bigint NULL COMMENT '项目编号 关联 PmsProjectDO#getId()',
  `work_item_type` int NULL COMMENT '工作项类型 枚举 PmsWorkItemTypeEnum',
  `name` varchar(255) NULL COMMENT '状态名称',
  `status_type` int NULL COMMENT '语义状态 枚举 PmsWorkItemStatusTypeEnum',
  `description` text NULL COMMENT '状态描述',
  `board_name` varchar(255) NULL COMMENT '所属看板列名称，为空时不在看板展示',
  `system_code` varchar(255) NULL COMMENT '系统状态编码，仅默认状态使用，用于保证并发初始化幂等',
  `default_status` bit(1) NULL COMMENT '是否初始状态',
  `sort` int NULL COMMENT '显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 工作项看板状态 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemUserSortDO.java
-- Entity: PmsWorkItemUserSortDO extends BaseDO
-- 推断字段类型：id bigint, project_id bigint, work_item_id bigint, user_id bigint, sort int
CREATE TABLE `pms_work_item_user_sort` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `project_id` bigint NULL COMMENT '项目编号 关联 PmsProjectDO#getId()',
  `work_item_id` bigint NULL COMMENT '工作项编号 关联 PmsWorkItemDO#getId()',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserRespDTO#getId()',
  `sort` int NULL COMMENT '显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 工作项个人排序 DO';

-- Source: yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemWorkLogDO.java
-- Entity: PmsWorkItemWorkLogDO extends BaseDO
-- 推断字段类型：id bigint, project_id bigint, work_item_id bigint, actual_hours int, remaining_hours int, description text
CREATE TABLE `pms_work_item_work_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '工时记录编号',
  `project_id` bigint NULL COMMENT '项目编号 关联 PmsProjectDO#getId()',
  `work_item_id` bigint NULL COMMENT '工作项编号 关联 PmsWorkItemDO#getId()',
  `actual_hours` int NULL COMMENT '实际投入工时，单位：小时',
  `remaining_hours` int NULL COMMENT '本次登记后的剩余工时，单位：小时',
  `description` text NULL COMMENT '工时说明',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PMS 工作项工时记录 DO';
