-- AI 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/chat/AiChatConversationDO.java
-- Entity: AiChatConversationDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, title varchar(255), pinned bit(1), pinned_time datetime, role_id bigint, model_id bigint, model varchar(255), system_message longtext, temperature double, max_tokens int, max_contexts int
-- 特殊类型依据：ai_chat_conversation.system_message 源实体角色设定为自然语言系统提示词；LONGTEXT 容量为推断，避免 VARCHAR(255) 限制完整提示词
CREATE TABLE `ai_chat_conversation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID 编号，自增',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserDO 的 userId 字段',
  `title` varchar(255) NULL COMMENT '对话标题 默认由系统自动生成，可用户手动修改',
  `pinned` bit(1) NULL COMMENT '是否置顶',
  `pinned_time` datetime NULL COMMENT '置顶时间',
  `role_id` bigint NULL COMMENT '角色编号 关联 AiChatRoleDO#getId()',
  `model_id` bigint NULL COMMENT '模型编号 关联 AiModelDO#getId() 字段',
  `model` varchar(255) NULL COMMENT '模型标志 冗余 AiModelDO#getModel() 字段',
  `system_message` longtext NULL COMMENT '角色设定',
  `temperature` double NULL COMMENT '温度参数 用于调整生成回复的随机性和多样性程度：较低的温度值会使输出更收敛于高频词汇，较高的则增加多样性',
  `max_tokens` int NULL COMMENT '单条回复的最大 Token 数量',
  `max_contexts` int NULL COMMENT '上下文的最大 Message 数量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI Chat 对话 DO 用户每次发起 Chat 聊天时，会创建一个 AiChatConversationDO 对象，将它的消息关联在一起';

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/chat/AiChatMessageDO.java
-- Entity: AiChatMessageDO extends BaseDO
-- 推断字段类型：id bigint, conversation_id bigint, reply_id bigint, type varchar(255), user_id bigint, role_id bigint, model varchar(255), model_id bigint, content text, reasoning_content text, use_context bit(1), segment_ids text, web_search_pages json, attachment_urls text
CREATE TABLE `ai_chat_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，作为每条聊天记录的唯一标识符',
  `conversation_id` bigint NULL COMMENT '对话编号 关联 AiChatConversationDO#getId() 字段',
  `reply_id` bigint NULL COMMENT '回复消息编号 关联 #id 字段 大模型回复的消息编号，用于“问答”的关联',
  `type` varchar(255) NULL COMMENT '消息类型 也等价于 OpenAPI 的 role 字段 枚举 MessageType',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserDO 的 userId 字段',
  `role_id` bigint NULL COMMENT '角色编号 关联 AiChatRoleDO#getId() 字段',
  `model` varchar(255) NULL COMMENT '模型标志 冗余 AiModelDO#getModel()',
  `model_id` bigint NULL COMMENT '模型编号 关联 AiModelDO#getId() 字段',
  `content` text NULL COMMENT '聊天内容',
  `reasoning_content` text NULL COMMENT '推理内容',
  `use_context` bit(1) NULL COMMENT '是否携带上下文',
  `segment_ids` text NULL COMMENT '知识库段落编号数组 关联 AiKnowledgeSegmentDO#getId() 字段',
  `web_search_pages` json NULL COMMENT '联网搜索的网页内容数组',
  `attachment_urls` text NULL COMMENT '附件 URL 数组',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI Chat 消息 DO';

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/image/AiImageDO.java
-- Entity: AiImageDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, prompt text, platform varchar(255), model_id bigint, model varchar(255), width int, height int, status int, finish_time datetime, error_message text, pic_url varchar(1024), public_status bit(1), options json, buttons json, task_id varchar(255)
-- 特殊类型依据：ai_image.error_message 源实体保存外部服务错误消息；TEXT 容量为推断
CREATE TABLE `ai_image` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserRespDTO#getId()',
  `prompt` text NULL COMMENT '提示词',
  `platform` varchar(255) NULL COMMENT '平台 枚举 AiPlatformEnum',
  `model_id` bigint NULL COMMENT '模型编号 关联 AiModelDO#getId()',
  `model` varchar(255) NULL COMMENT '模型标识 冗余 AiModelDO#getModel()',
  `width` int NULL COMMENT '图片宽度',
  `height` int NULL COMMENT '图片高度',
  `status` int NULL COMMENT '生成状态 枚举 AiImageStatusEnum',
  `finish_time` datetime NULL COMMENT '完成时间',
  `error_message` text NULL COMMENT '绘画错误信息',
  `pic_url` varchar(1024) NULL COMMENT '图片地址',
  `public_status` bit(1) NULL COMMENT '是否公开',
  `options` json NULL COMMENT '绘制参数，不同 platform 的不同参数 1. OpenAiImageOptions 2. StabilityAiImageOptions',
  `buttons` json NULL COMMENT 'mj buttons 按钮',
  `task_id` varchar(255) NULL COMMENT '任务编号 1. midjourney proxy：关联的 task id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI 绘画 DO';

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/knowledge/AiKnowledgeDO.java
-- Entity: AiKnowledgeDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), description text, embedding_model_id bigint, embedding_model varchar(255), top_k int, similarity_threshold double, status int
CREATE TABLE `ai_knowledge` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '知识库名称',
  `description` text NULL COMMENT '知识库描述',
  `embedding_model_id` bigint NULL COMMENT '向量模型编号 关联 AiModelDO#getId()',
  `embedding_model` varchar(255) NULL COMMENT '模型标识 冗余 AiModelDO#getModel()',
  `top_k` int NULL COMMENT 'topK',
  `similarity_threshold` double NULL COMMENT '相似度阈值',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI 知识库 DO';

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/knowledge/AiKnowledgeDocumentDO.java
-- Entity: AiKnowledgeDocumentDO extends BaseDO
-- 推断字段类型：id bigint, knowledge_id bigint, name varchar(255), url varchar(1024), content longtext, content_length int, tokens int, segment_max_tokens int, retrieval_count int, status int
-- 特殊类型依据：ai_knowledge_document.content 源实体保存完整文档、生成正文或原文；LONGTEXT 容量为推断
CREATE TABLE `ai_knowledge_document` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `knowledge_id` bigint NULL COMMENT '知识库编号 关联 AiKnowledgeDO#getId()',
  `name` varchar(255) NULL COMMENT '文档名称',
  `url` varchar(1024) NULL COMMENT '文件 URL',
  `content` longtext NULL COMMENT '内容',
  `content_length` int NULL COMMENT '文档长度',
  `tokens` int NULL COMMENT '文档 token 数量',
  `segment_max_tokens` int NULL COMMENT '分片最大 Token 数',
  `retrieval_count` int NULL COMMENT '召回次数',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI 知识库-文档 DO';

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/knowledge/AiKnowledgeSegmentDO.java
-- Entity: AiKnowledgeSegmentDO extends BaseDO
-- 推断字段类型：id bigint, knowledge_id bigint, document_id bigint, content longtext, content_length int, vector_id varchar(255), tokens int, retrieval_count int, status int
-- 特殊类型依据：ai_knowledge_segment.content 源实体保存完整文档、生成正文或原文；LONGTEXT 容量为推断
CREATE TABLE `ai_knowledge_segment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `knowledge_id` bigint NULL COMMENT '知识库编号 关联 AiKnowledgeDO#getId()',
  `document_id` bigint NULL COMMENT '文档编号 关联 AiKnowledgeDocumentDO#getId()',
  `content` longtext NULL COMMENT '切片内容',
  `content_length` int NULL COMMENT '切片内容长度',
  `vector_id` varchar(255) NULL COMMENT '向量库的编号',
  `tokens` int NULL COMMENT 'token 数量',
  `retrieval_count` int NULL COMMENT '召回次数',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI 知识库-文档分段 DO';

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/mindmap/AiMindMapDO.java
-- Entity: AiMindMapDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, platform varchar(255), model_id bigint, model varchar(255), prompt text, generated_content longtext, error_message text
-- 特殊类型依据：ai_mind_map.generated_content 源实体保存完整文档、生成正文或原文；LONGTEXT 容量为推断
-- 特殊类型依据：ai_mind_map.error_message 源实体保存外部服务错误消息；TEXT 容量为推断
CREATE TABLE `ai_mind_map` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserDO 的 userId 字段',
  `platform` varchar(255) NULL COMMENT '平台 枚举 AiPlatformEnum',
  `model_id` bigint NULL COMMENT '模型编号 关联 AiModelDO#getId()',
  `model` varchar(255) NULL COMMENT '模型',
  `prompt` text NULL COMMENT '生成内容提示',
  `generated_content` longtext NULL COMMENT '生成的内容',
  `error_message` text NULL COMMENT '错误信息',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI 思维导图 DO';

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/model/AiApiKeyDO.java
-- Entity: AiApiKeyDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), api_key varchar(255), platform varchar(255), url varchar(1024), status int
CREATE TABLE `ai_api_key` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '名称',
  `api_key` varchar(255) NULL COMMENT '密钥',
  `platform` varchar(255) NULL COMMENT '平台 枚举 AiPlatformEnum',
  `url` varchar(1024) NULL COMMENT 'API 地址',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI API 秘钥 DO';

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/model/AiChatRoleDO.java
-- Entity: AiChatRoleDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), avatar varchar(1024), category varchar(255), description text, system_message longtext, user_id bigint, model_id bigint, knowledge_ids text, tool_ids text, mcp_client_names text, public_status bit(1), sort int, status int
-- 特殊类型依据：ai_chat_role.system_message 源实体角色设定为自然语言系统提示词；LONGTEXT 容量为推断，避免 VARCHAR(255) 限制完整提示词
CREATE TABLE `ai_chat_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '角色名称',
  `avatar` varchar(1024) NULL COMMENT '角色头像',
  `category` varchar(255) NULL COMMENT '角色分类',
  `description` text NULL COMMENT '角色描述',
  `system_message` longtext NULL COMMENT '角色设定',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserDO 的 userId 字段',
  `model_id` bigint NULL COMMENT '模型编号 关联 AiModelDO#getId() 字段',
  `knowledge_ids` text NULL COMMENT '引用的知识库编号列表 关联 AiKnowledgeDO#getId() 字段',
  `tool_ids` text NULL COMMENT '引用的工具编号列表 关联 AiToolDO#getId() 字段',
  `mcp_client_names` text NULL COMMENT '引用的 MCP Client 名字列表 关联 spring.ai.mcp.client 下的名字',
  `public_status` bit(1) NULL COMMENT '是否公开 1. true - 公开；由管理员在【角色管理】所创建 2. false - 私有；由个人在【我的角色】所创建',
  `sort` int NULL COMMENT '排序值',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI 聊天角色 DO';

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/model/AiModelDO.java
-- Entity: AiModelDO extends BaseDO
-- 推断字段类型：id bigint, key_id bigint, name varchar(255), model varchar(255), platform varchar(255), type int, sort int, status int, temperature double, max_tokens int, max_contexts int
CREATE TABLE `ai_model` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `key_id` bigint NULL COMMENT 'API 秘钥编号 关联 AiApiKeyDO#getId()',
  `name` varchar(255) NULL COMMENT '模型名称',
  `model` varchar(255) NULL COMMENT '模型标志',
  `platform` varchar(255) NULL COMMENT '平台 枚举 AiPlatformEnum',
  `type` int NULL COMMENT '类型 枚举 AiModelTypeEnum',
  `sort` int NULL COMMENT '排序值',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `temperature` double NULL COMMENT '温度参数 用于调整生成回复的随机性和多样性程度：较低的温度值会使输出更收敛于高频词汇，较高的则增加多样性',
  `max_tokens` int NULL COMMENT '单条回复的最大 Token 数量',
  `max_contexts` int NULL COMMENT '上下文的最大 Message 数量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI 模型 DO 默认模型：#status 为开启，并且 #sort 排序第一';

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/model/AiToolDO.java
-- Entity: AiToolDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), description text, status int
CREATE TABLE `ai_tool` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '工具编号',
  `name` varchar(255) NULL COMMENT '工具名称 对应 Bean 的名字，例如说： 1. DirectoryListToolFunction 的 Bean 名字是 directory_list 2. WeatherQueryToolFunction 的 Bean 名字是 weather_query',
  `description` text NULL COMMENT '工具描述',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI 工具 DO';

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/music/AiMusicDO.java
-- Entity: AiMusicDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, title varchar(255), lyric text, image_url varchar(1024), audio_url varchar(1024), video_url varchar(1024), status int, generate_mode int, description text, platform varchar(255), model varchar(255), tags json, duration double, public_status bit(1), task_id varchar(255), error_message text
-- 特殊类型依据：ai_music.lyric 源实体为完整歌词；TEXT 容量为推断
-- 特殊类型依据：ai_music.error_message 源实体保存外部服务错误消息；TEXT 容量为推断
CREATE TABLE `ai_music` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserDO 的 userId 字段',
  `title` varchar(255) NULL COMMENT '音乐名称',
  `lyric` text NULL COMMENT '歌词',
  `image_url` varchar(1024) NULL COMMENT '图片地址',
  `audio_url` varchar(1024) NULL COMMENT '音频地址',
  `video_url` varchar(1024) NULL COMMENT '视频地址',
  `status` int NULL COMMENT '音乐状态 枚举 AiMusicStatusEnum',
  `generate_mode` int NULL COMMENT '生成模式 枚举 AiMusicGenerateModeEnum',
  `description` text NULL COMMENT '描述词',
  `platform` varchar(255) NULL COMMENT '平台 枚举 AiPlatformEnum',
  `model` varchar(255) NULL COMMENT '模型',
  `tags` json NULL COMMENT '音乐风格标签',
  `duration` double NULL COMMENT '音乐时长',
  `public_status` bit(1) NULL COMMENT '是否公开',
  `task_id` varchar(255) NULL COMMENT '任务编号',
  `error_message` text NULL COMMENT '错误信息',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI 音乐 DO';

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/workflow/AiWorkflowDO.java
-- Entity: AiWorkflowDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), code varchar(255), graph longtext, remark text, status int
-- 特殊类型依据：ai_workflow.graph AiWorkflowDO.graph 注释明确工作流模型 JSON 数据，Java String 无类型处理器；保持 JSON 文本语义，LONGTEXT 容量为推断
CREATE TABLE `ai_workflow` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '工作流名称',
  `code` varchar(255) NULL COMMENT '工作流标识',
  `graph` longtext NULL COMMENT '工作流模型 JSON 数据',
  `remark` text NULL COMMENT '备注',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI 工作流 DO';

-- Source: yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/write/AiWriteDO.java
-- Entity: AiWriteDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, type int, platform varchar(255), model_id bigint, model varchar(255), prompt text, generated_content longtext, original_content longtext, length int, format int, tone int, language int, error_message text
-- 特殊类型依据：ai_write.generated_content 源实体保存完整文档、生成正文或原文；LONGTEXT 容量为推断
-- 特殊类型依据：ai_write.original_content 源实体保存完整文档、生成正文或原文；LONGTEXT 容量为推断
-- 特殊类型依据：ai_write.error_message 源实体保存外部服务错误消息；TEXT 容量为推断
CREATE TABLE `ai_write` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserDO 的 userId 字段',
  `type` int NULL COMMENT '写作类型 枚举 AiWriteTypeEnum',
  `platform` varchar(255) NULL COMMENT '平台 枚举 AiPlatformEnum',
  `model_id` bigint NULL COMMENT '模型编号 关联 AiModelDO#getId()',
  `model` varchar(255) NULL COMMENT '模型',
  `prompt` text NULL COMMENT '生成内容提示',
  `generated_content` longtext NULL COMMENT '生成的内容',
  `original_content` longtext NULL COMMENT '原文',
  `length` int NULL COMMENT '长度提示词 字典：DictTypeConstants#AI_WRITE_LENGTH',
  `format` int NULL COMMENT '格式提示词 字典：DictTypeConstants#AI_WRITE_FORMAT',
  `tone` int NULL COMMENT '语气提示词 字典：DictTypeConstants#AI_WRITE_TONE',
  `language` int NULL COMMENT '语言提示词 字典：DictTypeConstants#AI_WRITE_LANGUAGE',
  `error_message` text NULL COMMENT '错误信息',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI 写作 DO';
