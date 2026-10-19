-- BPM 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/definition/BpmCategoryDO.java
-- Entity: BpmCategoryDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), code varchar(255), description text, status int, sort int
CREATE TABLE `bpm_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类编号',
  `name` varchar(255) NULL COMMENT '分类名',
  `code` varchar(255) NULL COMMENT '分类标志',
  `description` text NULL COMMENT '分类描述',
  `status` int NULL COMMENT '分类状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `sort` int NULL COMMENT '分类排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BPM 流程分类 DO';

-- Source: yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/definition/BpmFormDO.java
-- Entity: BpmFormDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), status int, conf longtext, fields json, remark text
-- 特殊类型依据：bpm_form.conf 源实体为动态表单配置及其发布快照，Java String 无类型处理器；LONGTEXT 容量为推断
CREATE TABLE `bpm_form` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '表单名',
  `status` int NULL COMMENT '状态',
  `conf` longtext NULL COMMENT '表单的配置',
  `fields` json NULL COMMENT '表单项的数组 目前直接将 https://github.com/JakHuang/form-generator 生成的 JSON 串，直接保存 定义：https://github.com/JakHuang/form-generator/issues/46',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BPM 工作流的表单定义 用于工作流的申请表单，需要动态配置的场景';

-- Source: yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/definition/BpmProcessDefinitionInfoDO.java
-- Entity: BpmProcessDefinitionInfoDO extends BaseDO
-- 推断字段类型：id bigint, process_definition_id varchar(255), model_id varchar(255), model_type int, category varchar(255), icon varchar(255), description text, form_type int, form_id bigint, form_conf longtext, form_fields json, form_custom_create_path varchar(1024), form_custom_view_path varchar(1024), simple_model longtext, visible bit(1), sort bigint, start_user_ids text, start_dept_ids text, manager_user_ids text, allow_cancel_running_process bit(1), allow_withdraw_task bit(1), process_id_rule json, auto_approval_type int, title_setting json, summary_setting json, process_before_trigger_setting json, process_after_trigger_setting json, task_before_trigger_setting json, task_after_trigger_setting json, print_template_setting json
-- 特殊类型依据：bpm_process_definition_info.form_conf 源实体为动态表单配置及其发布快照，Java String 无类型处理器；LONGTEXT 容量为推断
-- 特殊类型依据：bpm_process_definition_info.form_custom_create_path 源实体为自定义表单 Vue 路由路径；VARCHAR(1024) 容量为推断
-- 特殊类型依据：bpm_process_definition_info.form_custom_view_path 源实体为自定义表单 Vue 路由路径；VARCHAR(1024) 容量为推断
-- 特殊类型依据：bpm_process_definition_info.simple_model 源实体明示 SIMPLE 设计器模型 JSON 快照且服务 JsonUtils.parseObject 读取；保持 Java String 文本语义，LONGTEXT 容量为推断
CREATE TABLE `bpm_process_definition_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `process_definition_id` varchar(255) NULL COMMENT '流程定义的编号 关联 ProcessDefinition#getId() 属性',
  `model_id` varchar(255) NULL COMMENT '流程模型的编号 关联 Model#getId() 属性',
  `model_type` int NULL COMMENT '流程模型的类型 枚举 BpmModelTypeEnum',
  `category` varchar(255) NULL COMMENT '流程分类的编码 关联 BpmCategoryDO#getCode() 为什么要存储？原因是，ProcessDefinition#getCategory() 无法设置',
  `icon` varchar(255) NULL COMMENT '图标',
  `description` text NULL COMMENT '描述',
  `form_type` int NULL COMMENT '表单类型 枚举 BpmModelFormTypeEnum',
  `form_id` bigint NULL COMMENT '动态表单编号 在表单类型为 BpmModelFormTypeEnum#NORMAL 时 关联 BpmFormDO#getId()',
  `form_conf` longtext NULL COMMENT '表单的配置 在表单类型为 BpmModelFormTypeEnum#NORMAL 时 冗余 BpmFormDO#getConf()',
  `form_fields` json NULL COMMENT '表单项的数组 在表单类型为 BpmModelFormTypeEnum#NORMAL 时 冗余 BpmFormDO#getFields()',
  `form_custom_create_path` varchar(1024) NULL COMMENT '自定义表单的提交路径，使用 Vue 的路由地址 在表单类型为 BpmModelFormTypeEnum#CUSTOM 时',
  `form_custom_view_path` varchar(1024) NULL COMMENT '自定义表单的查看路径，使用 Vue 的路由地址 在表单类型为 BpmModelFormTypeEnum#CUSTOM 时',
  `simple_model` longtext NULL COMMENT 'SIMPLE 设计器模型数据 json 格式 目的：当使用仿钉钉设计器时。流程模型发布的时候，需要保存流程模型设计器的快照数据。',
  `visible` bit(1) NULL COMMENT '是否可见 目的：如果 false 不可见，则不展示在“发起流程”的列表里',
  `sort` bigint NULL COMMENT '排序值',
  `start_user_ids` text NULL COMMENT '可发起用户编号数组 关联 AdminUserRespDTO#getId() 字段的数组 如果为空，则表示“全部可以发起”！ 它和 #visible 的区别在于： 1. #visible 只是决定是否可见。即使不可见，还是可以发起 2. startUserIds 决定某个用户是否可以发起。如果该用户不可发起，则他也是不可见的',
  `start_dept_ids` text NULL COMMENT '可发起部门编号数组 关联 AdminUserRespDTO#getDeptId() 字段的数组',
  `manager_user_ids` text NULL COMMENT '可管理用户编号数组 关联 AdminUserRespDTO#getId() 字段的数组',
  `allow_cancel_running_process` bit(1) NULL COMMENT '是否允许撤销审批中的申请',
  `allow_withdraw_task` bit(1) NULL COMMENT '是否允许审批人撤回任务',
  `process_id_rule` json NULL COMMENT '流程 ID 规则',
  `auto_approval_type` int NULL COMMENT '自动去重类型 枚举 BpmAutoApproveTypeEnum',
  `title_setting` json NULL COMMENT '标题设置',
  `summary_setting` json NULL COMMENT '摘要设置',
  `process_before_trigger_setting` json NULL COMMENT '流程前置通知设置',
  `process_after_trigger_setting` json NULL COMMENT '流程后置通知设置',
  `task_before_trigger_setting` json NULL COMMENT '任务前置通知设置',
  `task_after_trigger_setting` json NULL COMMENT '任务后置通知设置',
  `print_template_setting` json NULL COMMENT '自定义打印模板设置',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BPM 流程定义的拓信息 主要解决 Flowable org.flowable.engine.repository.ProcessDefinition 不支持拓展字段，所以新建该表';

-- Source: yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/definition/BpmProcessExpressionDO.java
-- Entity: BpmProcessExpressionDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), status int, expression text
-- 特殊类型依据：bpm_process_expression.expression 源实体保存执行表达式或监听器配置值；TEXT 容量为推断
CREATE TABLE `bpm_process_expression` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '表达式名字',
  `status` int NULL COMMENT '表达式状态 枚举 TODO common_status 对应的类',
  `expression` text NULL COMMENT '表达式',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BPM 流程表达式 DO';

-- Source: yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/definition/BpmProcessListenerDO.java
-- Entity: BpmProcessListenerDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), status int, type varchar(255), event varchar(255), value_type varchar(255), value text
-- 特殊类型依据：bpm_process_listener.value 源实体保存执行表达式或监听器配置值；TEXT 容量为推断
CREATE TABLE `bpm_process_listener` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID，自增',
  `name` varchar(255) NULL COMMENT '监听器名字',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `type` varchar(255) NULL COMMENT '监听类型 枚举 BpmProcessListenerTypeEnum 1. execution：ExecutionListener 执行监听器 2. task：TaskListener 任务监听器',
  `event` varchar(255) NULL COMMENT '监听事件 execution 时：start、end task 时：create 创建、assignment 指派、complete 完成、delete 删除、update 更新、timeout 超时',
  `value_type` varchar(255) NULL COMMENT '值类型 1. class：Java 类，ExecutionListener 需要 org.flowable.engine.delegate.JavaDelegate，TaskListener 需要 org.flowable.engine.delegate.TaskListener 2. delegateExpression：委托表达式，在 class 的基础上，需要注册到 Spring 容器里，后续表达式通过 Spring Bean 名称即可 3. expression：表达式，一个普通类的普通方法，将这个普通类注册到 Spring 容器中，然后表达式中还可以执行这个类中的方法',
  `value` text NULL COMMENT '值',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BPM 流程监听器 DO 目的：本质上它是流程监听器的模版，用于 BPMN 在设计时，直接选择这些模版';

-- Source: yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/definition/BpmUserGroupDO.java
-- Entity: BpmUserGroupDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), description text, status int, user_ids json
CREATE TABLE `bpm_user_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号，自增',
  `name` varchar(255) NULL COMMENT '组名',
  `description` text NULL COMMENT '描述',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `user_ids` json NULL COMMENT '成员用户编号数组',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BPM 用户组';

-- Source: yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/oa/BpmOALeaveDO.java
-- Entity: BpmOALeaveDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, type int, reason text, start_time datetime, end_time datetime, day bigint, status int, process_instance_id varchar(255)
CREATE TABLE `bpm_oa_leave` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '请假表单主键',
  `user_id` bigint NULL COMMENT '申请人的用户编号 关联 AdminUserDO 的 id 属性',
  `type` int NULL COMMENT '请假类型',
  `reason` text NULL COMMENT '原因',
  `start_time` datetime NULL COMMENT '开始时间',
  `end_time` datetime NULL COMMENT '结束时间',
  `day` bigint NULL COMMENT '请假天数',
  `status` int NULL COMMENT '审批结果 枚举 BpmTaskStatusEnum 考虑到简单，所以直接复用了 BpmProcessInstanceStatusEnum 枚举，也可以自己定义一个枚举哈',
  `process_instance_id` varchar(255) NULL COMMENT '对应的流程编号 关联 ProcessInstance 的 id 属性',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OA 请假申请 DO #day 请假天数，目前先简单做。一般是分成请假上午和下午，可以是 1 整天，可以是 0.5 半天';

-- Source: yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/task/BpmProcessInstanceCopyDO.java
-- Entity: BpmProcessInstanceCopyDO extends BaseDO
-- 推断字段类型：id bigint, start_user_id bigint, process_instance_name varchar(255), process_instance_id varchar(255), process_definition_id varchar(255), category varchar(255), activity_id varchar(255), activity_name varchar(255), task_id varchar(255), user_id bigint, reason text
CREATE TABLE `bpm_process_instance_copy` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `start_user_id` bigint NULL COMMENT '发起人 Id 冗余 ProcessInstance 的 startUserId 字段',
  `process_instance_name` varchar(255) NULL COMMENT '流程名 冗余 ProcessInstance 的 name 字段',
  `process_instance_id` varchar(255) NULL COMMENT '流程实例的编号 关联 ProcessInstance 的 id 属性',
  `process_definition_id` varchar(255) NULL COMMENT '流程实例的流程定义编号 关联 ProcessInstance 的 processDefinitionId 属性',
  `category` varchar(255) NULL COMMENT '流程分类 冗余 ProcessInstance 的 category 字段',
  `activity_id` varchar(255) NULL COMMENT '流程活动的编号 冗余 FlowNode#getId()，对应 BPMN XML 节点编号 原因：用于查询抄送节点的表单字段权限。因为仿钉钉/飞书的抄送节点 (ServiceTask)，没有 taskId，只有 activityId',
  `activity_name` varchar(255) NULL COMMENT '流程活动的名字 冗余 FlowNode#getName()',
  `task_id` varchar(255) NULL COMMENT '流程活动的编号 关联 HistoricTaskInstance#getId()',
  `user_id` bigint NULL COMMENT '用户编号（被抄送的用户编号） 关联 system_users 的 id 属性',
  `reason` text NULL COMMENT '抄送意见',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='流程抄送 DO';
