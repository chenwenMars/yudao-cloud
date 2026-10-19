-- MES 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/holiday/MesCalHolidayDO.java
-- Entity: MesCalHolidayDO extends BaseDO
-- 推断字段类型：id bigint, day datetime, type int, remark text
CREATE TABLE `mes_cal_holiday` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `day` datetime NULL COMMENT '日期',
  `type` int NULL COMMENT '日期类型 字典 cn.iocoder.yudao.module.mes.enums.DictTypeConstants#MES_CAL_HOLIDAY_TYPE',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 假期设置 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/plan/MesCalPlanDO.java
-- Entity: MesCalPlanDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), calendar_type int, start_date datetime, end_date datetime, shift_type int, shift_method int, shift_count int, status int, remark text
CREATE TABLE `mes_cal_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '计划编号',
  `code` varchar(255) NULL COMMENT '计划编码',
  `name` varchar(255) NULL COMMENT '计划名称',
  `calendar_type` int NULL COMMENT '班组类型',
  `start_date` datetime NULL COMMENT '开始日期',
  `end_date` datetime NULL COMMENT '结束日期',
  `shift_type` int NULL COMMENT '轮班方式 字典 DictTypeConstants#MES_CAL_SHIFT_TYPE 枚举 MesCalShiftTypeEnum',
  `shift_method` int NULL COMMENT '倒班方式 字典 DictTypeConstants#MES_CAL_SHIFT_METHOD 枚举 MesCalShiftMethodEnum',
  `shift_count` int NULL COMMENT '倒班天数',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_CAL_PLAN_STATUS 枚举 MesCalPlanStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 排班计划 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/plan/MesCalPlanShiftDO.java
-- Entity: MesCalPlanShiftDO extends BaseDO
-- 推断字段类型：id bigint, plan_id bigint, sort int, name varchar(255), start_time varchar(5), end_time varchar(5), remark text
-- 特殊类型依据：mes_cal_plan_shift.start_time 实体 String 注释明示 HH:mm 格式；VARCHAR(5) 长度由格式推断，保留字符串存储
-- 特殊类型依据：mes_cal_plan_shift.end_time 实体 String 注释明示 HH:mm 格式；VARCHAR(5) 长度由格式推断，保留字符串存储
CREATE TABLE `mes_cal_plan_shift` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '班次编号',
  `plan_id` bigint NULL COMMENT '排班计划编号 关联 MesCalPlanDO#getId()',
  `sort` int NULL COMMENT '显示顺序',
  `name` varchar(255) NULL COMMENT '班次名称',
  `start_time` varchar(5) NULL COMMENT '开始时间（HH:mm 格式）',
  `end_time` varchar(5) NULL COMMENT '结束时间（HH:mm 格式）',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 计划班次 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/plan/MesCalPlanTeamDO.java
-- Entity: MesCalPlanTeamDO extends BaseDO
-- 推断字段类型：id bigint, plan_id bigint, team_id bigint, remark text
CREATE TABLE `mes_cal_plan_team` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `plan_id` bigint NULL COMMENT '排班计划编号 关联 MesCalPlanDO#getId()',
  `team_id` bigint NULL COMMENT '班组编号 关联 MesCalTeamDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 计划班组关联 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/team/MesCalTeamDO.java
-- Entity: MesCalTeamDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), calendar_type int, remark text
CREATE TABLE `mes_cal_team` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '班组编号',
  `code` varchar(255) NULL COMMENT '班组编码',
  `name` varchar(255) NULL COMMENT '班组名称',
  `calendar_type` int NULL COMMENT '班组类型',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 班组 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/team/MesCalTeamMemberDO.java
-- Entity: MesCalTeamMemberDO extends BaseDO
-- 推断字段类型：id bigint, team_id bigint, user_id bigint, remark text
CREATE TABLE `mes_cal_team_member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '班组成员编号',
  `team_id` bigint NULL COMMENT '班组编号 关联 MesCalTeamDO#getId()',
  `user_id` bigint NULL COMMENT '用户编号 关联 system_users 表',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 班组成员 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/team/MesCalTeamShiftDO.java
-- Entity: MesCalTeamShiftDO extends BaseDO
-- 推断字段类型：id bigint, plan_id bigint, team_id bigint, shift_id bigint, day datetime, sort int, remark text
CREATE TABLE `mes_cal_team_shift` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `plan_id` bigint NULL COMMENT '排班计划编号 关联 MesCalPlanDO#getId()',
  `team_id` bigint NULL COMMENT '班组编号 关联 MesCalTeamDO#getId()',
  `shift_id` bigint NULL COMMENT '班次编号 关联 MesCalPlanShiftDO#getId()',
  `day` datetime NULL COMMENT '日期',
  `sort` int NULL COMMENT '排序',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 班组排班 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/checkplan/MesDvCheckPlanDO.java
-- Entity: MesDvCheckPlanDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), type int, start_date datetime, end_date datetime, cycle_type int, cycle_count int, status int, remark text
CREATE TABLE `mes_dv_check_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '方案编码',
  `name` varchar(255) NULL COMMENT '方案名称',
  `type` int NULL COMMENT '方案类型 字典 DictTypeConstants#MES_DV_SUBJECT_TYPE',
  `start_date` datetime NULL COMMENT '开始日期',
  `end_date` datetime NULL COMMENT '结束日期',
  `cycle_type` int NULL COMMENT '周期类型 字典 DictTypeConstants#MES_DV_CYCLE_TYPE',
  `cycle_count` int NULL COMMENT '周期数量',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_DV_CHECK_PLAN_STATUS 枚举 MesDvCheckPlanStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 点检保养方案 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/checkplan/MesDvCheckPlanMachineryDO.java
-- Entity: MesDvCheckPlanMachineryDO extends BaseDO
-- 推断字段类型：id bigint, plan_id bigint, machinery_id bigint, remark text
CREATE TABLE `mes_dv_check_plan_machinery` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `plan_id` bigint NULL COMMENT '方案编号 关联 MesDvCheckPlanDO#getId()',
  `machinery_id` bigint NULL COMMENT '设备编号 关联 MesDvMachineryDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 点检保养方案设备 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/checkplan/MesDvCheckPlanSubjectDO.java
-- Entity: MesDvCheckPlanSubjectDO extends BaseDO
-- 推断字段类型：id bigint, plan_id bigint, subject_id bigint, remark text
CREATE TABLE `mes_dv_check_plan_subject` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `plan_id` bigint NULL COMMENT '方案编号 关联 MesDvCheckPlanDO#getId()',
  `subject_id` bigint NULL COMMENT '项目编号 关联 MesDvSubjectDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 点检保养方案项目 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/checkrecord/MesDvCheckRecordDO.java
-- Entity: MesDvCheckRecordDO extends BaseDO
-- 推断字段类型：id bigint, plan_id bigint, machinery_id bigint, check_time datetime, user_id bigint, status int, remark text
CREATE TABLE `mes_dv_check_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `plan_id` bigint NULL COMMENT '点检计划编号 关联 MesDvCheckPlanDO#getId()',
  `machinery_id` bigint NULL COMMENT '设备编号 关联 MesDvMachineryDO#getId()',
  `check_time` datetime NULL COMMENT '点检时间',
  `user_id` bigint NULL COMMENT '点检人编号 关联 AdminUserDO#getId()',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_DV_CHECK_RECORD_STATUS 枚举 MesDvCheckRecordStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 设备点检记录 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/checkrecord/MesDvCheckRecordLineDO.java
-- Entity: MesDvCheckRecordLineDO extends BaseDO
-- 推断字段类型：id bigint, record_id bigint, subject_id bigint, check_status int, check_result text, remark text
-- 特殊类型依据：mes_dv_check_record_line.check_result 实体注释为异常描述，TEXT 容量为业务推断
CREATE TABLE `mes_dv_check_record_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `record_id` bigint NULL COMMENT '点检记录编号 关联 MesDvCheckRecordDO#getId()',
  `subject_id` bigint NULL COMMENT '点检项目编号 关联 MesDvSubjectDO#getId()',
  `check_status` int NULL COMMENT '点检结果 字典 DictTypeConstants#MES_DV_CHECK_RESULT 枚举 MesDvCheckResultEnum',
  `check_result` text NULL COMMENT '异常描述 仅 #checkStatus 为异常时使用',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 设备点检记录明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/machinery/MesDvMachineryDO.java
-- Entity: MesDvMachineryDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), brand varchar(255), specification varchar(255), machinery_type_id bigint, workshop_id bigint, status int, last_mainten_time datetime, last_check_time datetime, remark text
CREATE TABLE `mes_dv_machinery` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '设备编码',
  `name` varchar(255) NULL COMMENT '设备名称',
  `brand` varchar(255) NULL COMMENT '品牌',
  `specification` varchar(255) NULL COMMENT '规格型号',
  `machinery_type_id` bigint NULL COMMENT '设备类型编号 关联 MesDvMachineryTypeDO#getId()',
  `workshop_id` bigint NULL COMMENT '所属车间编号 关联 cn.iocoder.yudao.module.mes.dal.dataobject.md.workstation.MesMdWorkshopDO#getId()',
  `status` int NULL COMMENT '设备状态 字典 DictTypeConstants#MES_DV_MACHINERY_STATUS 枚举 cn.iocoder.yudao.module.mes.enums.dv.MesDvMachineryStatusEnum',
  `last_mainten_time` datetime NULL COMMENT '最近保养时间',
  `last_check_time` datetime NULL COMMENT '最近点检时间',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 设备台账 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/machinery/MesDvMachineryTypeDO.java
-- Entity: MesDvMachineryTypeDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), parent_id bigint, status int, sort int, remark text
CREATE TABLE `mes_dv_machinery_type` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '类型编码',
  `name` varchar(255) NULL COMMENT '类型名称',
  `parent_id` bigint NULL COMMENT '父类型编号 关联 MesDvMachineryTypeDO#getId()',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `sort` int NULL COMMENT '显示排序',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 设备类型 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/maintenrecord/MesDvMaintenRecordDO.java
-- Entity: MesDvMaintenRecordDO extends BaseDO
-- 推断字段类型：id bigint, plan_id bigint, machinery_id bigint, mainten_time datetime, user_id bigint, status int, remark text
CREATE TABLE `mes_dv_mainten_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `plan_id` bigint NULL COMMENT '计划编号 关联 MesDvCheckPlanDO#getId()',
  `machinery_id` bigint NULL COMMENT '设备编号 关联 MesDvMachineryDO#getId()',
  `mainten_time` datetime NULL COMMENT '保养时间',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserDO#getId()',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_MAINTEN_RECORD_STATUS 枚举 MesDvMaintenRecordStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 设备保养记录 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/maintenrecord/MesDvMaintenRecordLineDO.java
-- Entity: MesDvMaintenRecordLineDO extends BaseDO
-- 推断字段类型：id bigint, record_id bigint, subject_id bigint, status int, result text, remark text
CREATE TABLE `mes_dv_mainten_record_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `record_id` bigint NULL COMMENT '保养记录编号 关联 MesDvMaintenRecordDO#getId()',
  `subject_id` bigint NULL COMMENT '项目编号 关联 MesDvSubjectDO#getId()',
  `status` int NULL COMMENT '保养结果 字典 DictTypeConstants#MES_MAINTEN_STATUS 枚举 MesDvMaintenStatusEnum',
  `result` text NULL COMMENT '异常描述',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 设备保养记录明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/repair/MesDvRepairDO.java
-- Entity: MesDvRepairDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), machinery_id bigint, require_date datetime, finish_date datetime, confirm_date datetime, result int, accepted_user_id bigint, confirm_user_id bigint, source_doc_type int, source_doc_id bigint, source_doc_code varchar(255), status int, remark text
CREATE TABLE `mes_dv_repair` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '维修工单编码',
  `name` varchar(255) NULL COMMENT '维修工单名称',
  `machinery_id` bigint NULL COMMENT '设备编号 关联 MesDvMachineryDO#getId()',
  `require_date` datetime NULL COMMENT '报修日期',
  `finish_date` datetime NULL COMMENT '维修完成日期',
  `confirm_date` datetime NULL COMMENT '验收日期',
  `result` int NULL COMMENT '维修结果 字典 DictTypeConstants#MES_DV_REPAIR_RESULT 枚举 MesDvRepairResultEnum',
  `accepted_user_id` bigint NULL COMMENT '维修人用户编号 关联 AdminUserDO#getId()',
  `confirm_user_id` bigint NULL COMMENT '验收人用户编号 关联 AdminUserDO#getId()',
  `source_doc_type` int NULL COMMENT '来源单据类型',
  `source_doc_id` bigint NULL COMMENT '来源单据编号',
  `source_doc_code` varchar(255) NULL COMMENT '来源单据编码',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_DV_REPAIR_STATUS 枚举 MesDvRepairStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 维修工单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/repair/MesDvRepairLineDO.java
-- Entity: MesDvRepairLineDO extends BaseDO
-- 推断字段类型：id bigint, repair_id bigint, subject_id bigint, malfunction text, malfunction_url varchar(1024), description text, remark text
-- 特殊类型依据：mes_dv_repair_line.malfunction 实体注释为故障描述，TEXT 容量为业务推断
CREATE TABLE `mes_dv_repair_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `repair_id` bigint NULL COMMENT '维修工单编号 关联 MesDvRepairDO#getId()',
  `subject_id` bigint NULL COMMENT '点检保养项目编号 关联 MesDvSubjectDO#getId()',
  `malfunction` text NULL COMMENT '故障描述',
  `malfunction_url` varchar(1024) NULL COMMENT '故障图片 URL',
  `description` text NULL COMMENT '维修描述',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 维修工单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/subject/MesDvSubjectDO.java
-- Entity: MesDvSubjectDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), type int, content text, standard text, status int, remark text
-- 特殊类型依据：mes_dv_subject.standard 设备点检保养项目的标准说明，TEXT 容量为业务推断
CREATE TABLE `mes_dv_subject` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '项目编码',
  `name` varchar(255) NULL COMMENT '项目名称',
  `type` int NULL COMMENT '项目类型 字典类型 mes_dv_subject_type',
  `content` text NULL COMMENT '项目内容',
  `standard` text NULL COMMENT '标准',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 点检保养项目 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/autocode/MesMdAutoCodePartDO.java
-- Entity: MesMdAutoCodePartDO extends BaseDO
-- 推断字段类型：id bigint, rule_id bigint, sort int, type int, length int, date_format varchar(255), fix_character varchar(255), serial_start_no int, serial_step int, cycle_flag bit(1), cycle_method int, remark text
CREATE TABLE `mes_md_auto_code_part` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分段 ID',
  `rule_id` bigint NULL COMMENT '规则 ID 关联 MesMdAutoCodeRuleDO#getId()',
  `sort` int NULL COMMENT '分段序号',
  `type` int NULL COMMENT '分段类型 字典 DictTypeConstants#MES_MD_AUTO_CODE_PART_TYPE 枚举 cn.iocoder.yudao.module.mes.enums.md.autocode.MesMdAutoCodePartTypeEnum',
  `length` int NULL COMMENT '分段长度',
  `date_format` varchar(255) NULL COMMENT '日期格式 例如：yyyyMMdd、yyyyMM、HHmmss',
  `fix_character` varchar(255) NULL COMMENT '固定字符',
  `serial_start_no` int NULL COMMENT '流水号起始值',
  `serial_step` int NULL COMMENT '流水号步长',
  `cycle_flag` bit(1) NULL COMMENT '流水号是否循环',
  `cycle_method` int NULL COMMENT '循环方式 字典 DictTypeConstants#MES_MD_AUTO_CODE_CYCLE_METHOD 枚举 cn.iocoder.yudao.module.mes.enums.md.autocode.MesMdAutoCodeCycleMethodEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 编码规则组成 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/autocode/MesMdAutoCodeRecordDO.java
-- Entity: MesMdAutoCodeRecordDO extends BaseDO
-- 推断字段类型：id bigint, rule_id bigint, result text, serial_no bigint, input_char varchar(255)
CREATE TABLE `mes_md_auto_code_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录 ID',
  `rule_id` bigint NULL COMMENT '规则 ID 关联 MesMdAutoCodeRuleDO#getId()',
  `result` text NULL COMMENT '生成的编码',
  `serial_no` bigint NULL COMMENT '生成的流水号 当规则组成中包含流水号分段（MesMdAutoCodePartTypeEnum#SERIAL_NUMBER）时记录，方便追溯和调试',
  `input_char` varchar(255) NULL COMMENT '传入的参数',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 编码生成记录 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/autocode/MesMdAutoCodeRuleDO.java
-- Entity: MesMdAutoCodeRuleDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), description text, max_length int, padded bit(1), padded_char varchar(255), padded_method int, status int, remark text
CREATE TABLE `mes_md_auto_code_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '规则 ID',
  `code` varchar(255) NULL COMMENT '规则编码',
  `name` varchar(255) NULL COMMENT '规则名称',
  `description` text NULL COMMENT '描述',
  `max_length` int NULL COMMENT '最大长度',
  `padded` bit(1) NULL COMMENT '是否补齐',
  `padded_char` varchar(255) NULL COMMENT '补齐字符',
  `padded_method` int NULL COMMENT '补齐方式 字典 DictTypeConstants#MES_MD_AUTO_CODE_PADDED_METHOD 枚举 cn.iocoder.yudao.module.mes.enums.md.autocode.MesMdAutoCodePaddedMethodEnum',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 编码规则 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/client/MesMdClientDO.java
-- Entity: MesMdClientDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), nickname varchar(255), english_name varchar(255), description text, logo varchar(1024), type int, address varchar(255), website varchar(1024), email varchar(255), telephone varchar(255), contact1_name varchar(255), contact1_telephone varchar(255), contact1_email varchar(255), contact2_name varchar(255), contact2_telephone varchar(255), contact2_email varchar(255), credit_code varchar(255), status int, remark text
-- 特殊类型依据：mes_md_client.logo 实体注释为客户 LOGO 地址，VARCHAR(1024) 地址容量为推断
-- 特殊类型依据：mes_md_client.website 实体注释为客户官网地址，VARCHAR(1024) 地址容量为推断
CREATE TABLE `mes_md_client` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '客户编号',
  `code` varchar(255) NULL COMMENT '客户编码',
  `name` varchar(255) NULL COMMENT '客户名称',
  `nickname` varchar(255) NULL COMMENT '客户简称',
  `english_name` varchar(255) NULL COMMENT '客户英文名称',
  `description` text NULL COMMENT '客户简介',
  `logo` varchar(1024) NULL COMMENT '客户LOGO地址',
  `type` int NULL COMMENT '客户类型 字典 cn.iocoder.yudao.module.mes.enums.DictTypeConstants#MES_CLIENT_TYPE',
  `address` varchar(255) NULL COMMENT '客户地址',
  `website` varchar(1024) NULL COMMENT '客户官网地址',
  `email` varchar(255) NULL COMMENT '客户邮箱地址',
  `telephone` varchar(255) NULL COMMENT '客户电话',
  `contact1_name` varchar(255) NULL COMMENT '联系人1',
  `contact1_telephone` varchar(255) NULL COMMENT '联系人1-电话',
  `contact1_email` varchar(255) NULL COMMENT '联系人1-邮箱',
  `contact2_name` varchar(255) NULL COMMENT '联系人2',
  `contact2_telephone` varchar(255) NULL COMMENT '联系人2-电话',
  `contact2_email` varchar(255) NULL COMMENT '联系人2-邮箱',
  `credit_code` varchar(255) NULL COMMENT '统一社会信用代码',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 客户 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/item/MesMdItemBatchConfigDO.java
-- Entity: MesMdItemBatchConfigDO extends BaseDO
-- 推断字段类型：id bigint, item_id bigint, produce_date_flag bit(1), expire_date_flag bit(1), receipt_date_flag bit(1), vendor_flag bit(1), client_flag bit(1), sales_order_code_flag bit(1), purchase_order_code_flag bit(1), work_order_flag bit(1), task_flag bit(1), workstation_flag bit(1), tool_flag bit(1), mold_flag bit(1), lot_number_flag bit(1), quality_status_flag bit(1)
CREATE TABLE `mes_md_item_batch_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `produce_date_flag` bit(1) NULL COMMENT '批次属性-生产日期',
  `expire_date_flag` bit(1) NULL COMMENT '批次属性-有效期',
  `receipt_date_flag` bit(1) NULL COMMENT '批次属性-入库日期',
  `vendor_flag` bit(1) NULL COMMENT '批次属性-供应商',
  `client_flag` bit(1) NULL COMMENT '批次属性-客户',
  `sales_order_code_flag` bit(1) NULL COMMENT '批次属性-销售订单编号',
  `purchase_order_code_flag` bit(1) NULL COMMENT '批次属性-采购订单编号',
  `work_order_flag` bit(1) NULL COMMENT '批次属性-生产工单',
  `task_flag` bit(1) NULL COMMENT '批次属性-生产任务',
  `workstation_flag` bit(1) NULL COMMENT '批次属性-工作站',
  `tool_flag` bit(1) NULL COMMENT '批次属性-工具',
  `mold_flag` bit(1) NULL COMMENT '批次属性-模具',
  `lot_number_flag` bit(1) NULL COMMENT '批次属性-生产批号',
  `quality_status_flag` bit(1) NULL COMMENT '批次属性-质量状态',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 物料批次属性配置 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/item/MesMdItemDO.java
-- Entity: MesMdItemDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), specification varchar(255), unit_measure_id bigint, item_type_id bigint, status int, safe_stock_flag bit(1), min_stock decimal(24,6), max_stock decimal(24,6), high_value bit(1), batch_flag bit(1), remark text
CREATE TABLE `mes_md_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '物料编号',
  `code` varchar(255) NULL COMMENT '物料编码',
  `name` varchar(255) NULL COMMENT '物料名称',
  `specification` varchar(255) NULL COMMENT '规格型号',
  `unit_measure_id` bigint NULL COMMENT '计量单位编号 关联 MesMdUnitMeasureDO#getId()',
  `item_type_id` bigint NULL COMMENT '物料分类编号 关联 MesMdItemTypeDO#getId()',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `safe_stock_flag` bit(1) NULL COMMENT '是否启用安全库存',
  `min_stock` decimal(24,6) NULL COMMENT '最低库存量',
  `max_stock` decimal(24,6) NULL COMMENT '最高库存量',
  `high_value` bit(1) NULL COMMENT '是否高值物料',
  `batch_flag` bit(1) NULL COMMENT '是否启用批次管理',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 物料产品 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/item/MesMdItemTypeDO.java
-- Entity: MesMdItemTypeDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), parent_id bigint, item_or_product varchar(255), sort int, status int, remark text
CREATE TABLE `mes_md_item_type` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类编号',
  `code` varchar(255) NULL COMMENT '分类编码',
  `name` varchar(255) NULL COMMENT '分类名称',
  `parent_id` bigint NULL COMMENT '父分类编号',
  `item_or_product` varchar(255) NULL COMMENT '物料/产品标识 字典 DictTypeConstants#MES_MD_ITEM_OR_PRODUCT 枚举 cn.iocoder.yudao.module.mes.enums.md.MesMdItemTypeEnum',
  `sort` int NULL COMMENT '显示排序',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 物料产品分类 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/item/MesMdProductBomDO.java
-- Entity: MesMdProductBomDO extends BaseDO
-- 推断字段类型：id bigint, item_id bigint, bom_item_id bigint, quantity decimal(24,6), status int, remark text
CREATE TABLE `mes_md_product_bom` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'BOM编号',
  `item_id` bigint NULL COMMENT '物料产品编号 关联 MesMdItemDO#getId()',
  `bom_item_id` bigint NULL COMMENT 'BOM物料编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '物料使用比例',
  `status` int NULL COMMENT '是否启用 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 产品 BOM DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/item/MesMdProductSipDO.java
-- Entity: MesMdProductSipDO extends BaseDO
-- 推断字段类型：id bigint, item_id bigint, sort int, process_id bigint, title varchar(255), description text, url varchar(1024), remark text
CREATE TABLE `mes_md_product_sip` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `item_id` bigint NULL COMMENT '物料产品编号 关联 MesMdItemDO#getId()',
  `sort` int NULL COMMENT '排列顺序',
  `process_id` bigint NULL COMMENT '工序编号',
  `title` varchar(255) NULL COMMENT '标题',
  `description` text NULL COMMENT '详细描述',
  `url` varchar(1024) NULL COMMENT '图片地址',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 产品SIP DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/item/MesMdProductSopDO.java
-- Entity: MesMdProductSopDO extends BaseDO
-- 推断字段类型：id bigint, item_id bigint, sort int, process_id bigint, title varchar(255), description text, url varchar(1024), remark text
CREATE TABLE `mes_md_product_sop` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `item_id` bigint NULL COMMENT '物料产品编号 关联 MesMdItemDO#getId()',
  `sort` int NULL COMMENT '排列顺序',
  `process_id` bigint NULL COMMENT '工序编号',
  `title` varchar(255) NULL COMMENT '标题',
  `description` text NULL COMMENT '详细描述',
  `url` varchar(1024) NULL COMMENT '图片地址',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 产品SOP DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/unitmeasure/MesMdUnitMeasureDO.java
-- Entity: MesMdUnitMeasureDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), primary_flag bit(1), primary_id bigint, change_rate decimal(24,6), status int, remark text
CREATE TABLE `mes_md_unit_measure` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '单位编号',
  `code` varchar(255) NULL COMMENT '单位编码',
  `name` varchar(255) NULL COMMENT '单位名称',
  `primary_flag` bit(1) NULL COMMENT '是否主单位',
  `primary_id` bigint NULL COMMENT '主单位编号 关联 MesMdUnitMeasureDO#getId()',
  `change_rate` decimal(24,6) NULL COMMENT '与主单位换算比例',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 计量单位 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/vendor/MesMdVendorDO.java
-- Entity: MesMdVendorDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), nickname varchar(255), english_name varchar(255), description text, logo varchar(1024), level varchar(255), score int, address varchar(255), website varchar(1024), email varchar(255), telephone varchar(255), contact1_name varchar(255), contact1_telephone varchar(255), contact1_email varchar(255), contact2_name varchar(255), contact2_telephone varchar(255), contact2_email varchar(255), credit_code varchar(255), status int, remark text
-- 特殊类型依据：mes_md_vendor.logo 实体注释为供应商 LOGO 地址，VARCHAR(1024) 地址容量为推断
-- 特殊类型依据：mes_md_vendor.website 实体注释为供应商官网地址，VARCHAR(1024) 地址容量为推断
CREATE TABLE `mes_md_vendor` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '供应商编号',
  `code` varchar(255) NULL COMMENT '供应商编码',
  `name` varchar(255) NULL COMMENT '供应商名称',
  `nickname` varchar(255) NULL COMMENT '供应商简称',
  `english_name` varchar(255) NULL COMMENT '供应商英文名称',
  `description` text NULL COMMENT '供应商简介',
  `logo` varchar(1024) NULL COMMENT '供应商LOGO地址',
  `level` varchar(255) NULL COMMENT '供应商等级 字典 cn.iocoder.yudao.module.mes.enums.DictTypeConstants#MES_VENDOR_LEVEL',
  `score` int NULL COMMENT '供应商评分',
  `address` varchar(255) NULL COMMENT '供应商地址',
  `website` varchar(1024) NULL COMMENT '供应商官网地址',
  `email` varchar(255) NULL COMMENT '供应商邮箱地址',
  `telephone` varchar(255) NULL COMMENT '供应商电话',
  `contact1_name` varchar(255) NULL COMMENT '联系人1',
  `contact1_telephone` varchar(255) NULL COMMENT '联系人1-电话',
  `contact1_email` varchar(255) NULL COMMENT '联系人1-邮箱',
  `contact2_name` varchar(255) NULL COMMENT '联系人2',
  `contact2_telephone` varchar(255) NULL COMMENT '联系人2-电话',
  `contact2_email` varchar(255) NULL COMMENT '联系人2-邮箱',
  `credit_code` varchar(255) NULL COMMENT '统一社会信用代码',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 供应商 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/workstation/MesMdWorkshopDO.java
-- Entity: MesMdWorkshopDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), area decimal(24,6), charge_user_id bigint, status int, remark text
CREATE TABLE `mes_md_workshop` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '车间编码',
  `name` varchar(255) NULL COMMENT '车间名称',
  `area` decimal(24,6) NULL COMMENT '面积（平方米）',
  `charge_user_id` bigint NULL COMMENT '负责人用户编号 关联 AdminUserDO 的 id',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 车间 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/workstation/MesMdWorkstationDO.java
-- Entity: MesMdWorkstationDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), address varchar(255), workshop_id bigint, process_id bigint, warehouse_id bigint, location_id bigint, area_id bigint, status int, remark text
CREATE TABLE `mes_md_workstation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '工作站编码',
  `name` varchar(255) NULL COMMENT '工作站名称',
  `address` varchar(255) NULL COMMENT '工作站地点',
  `workshop_id` bigint NULL COMMENT '所在车间编号 关联 MesMdWorkshopDO#getId()',
  `process_id` bigint NULL COMMENT '工序编号 关联 MesProProcessDO#getId()',
  `warehouse_id` bigint NULL COMMENT '线边库编号 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区编号 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位编号 关联 MesWmWarehouseAreaDO#getId()',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 工作站 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/workstation/MesMdWorkstationMachineDO.java
-- Entity: MesMdWorkstationMachineDO extends BaseDO
-- 推断字段类型：id bigint, workstation_id bigint, machinery_id bigint, quantity int, remark text
CREATE TABLE `mes_md_workstation_machine` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `workstation_id` bigint NULL COMMENT '工作站编号 关联 MesMdWorkstationDO#getId()',
  `machinery_id` bigint NULL COMMENT '设备编号 TODO @芋艿：等 dv 模块，关联设备表',
  `quantity` int NULL COMMENT '数量',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 设备资源 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/workstation/MesMdWorkstationToolDO.java
-- Entity: MesMdWorkstationToolDO extends BaseDO
-- 推断字段类型：id bigint, workstation_id bigint, tool_type_id bigint, quantity int, remark text
CREATE TABLE `mes_md_workstation_tool` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `workstation_id` bigint NULL COMMENT '工作站编号 关联 MesMdWorkstationDO#getId()',
  `tool_type_id` bigint NULL COMMENT '工具类型编号 TODO @芋艿：等 tm 模块，关联工具类型表',
  `quantity` int NULL COMMENT '数量',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 工装夹具资源 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/workstation/MesMdWorkstationWorkerDO.java
-- Entity: MesMdWorkstationWorkerDO extends BaseDO
-- 推断字段类型：id bigint, workstation_id bigint, post_id bigint, quantity int, remark text
CREATE TABLE `mes_md_workstation_worker` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `workstation_id` bigint NULL COMMENT '工作站编号 关联 MesMdWorkstationDO#getId()',
  `post_id` bigint NULL COMMENT '岗位编号 关联 system_post 的 id',
  `quantity` int NULL COMMENT '数量',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 人力资源 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/andon/MesProAndonConfigDO.java
-- Entity: MesProAndonConfigDO extends BaseDO
-- 推断字段类型：id bigint, reason text, level int, handler_role_id bigint, handler_user_id bigint, remark text
CREATE TABLE `mes_pro_andon_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `reason` text NULL COMMENT '呼叫原因',
  `level` int NULL COMMENT '级别 字典 DictTypeConstants#MES_PRO_ANDON_LEVEL 枚举 MesProAndonLevelEnum',
  `handler_role_id` bigint NULL COMMENT '处置人角色编号 关联 system_role#id',
  `handler_user_id` bigint NULL COMMENT '处置人编号 关联 system_users#id',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 安灯呼叫配置 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/andon/MesProAndonRecordDO.java
-- Entity: MesProAndonRecordDO extends BaseDO
-- 推断字段类型：id bigint, config_id bigint, workstation_id bigint, user_id bigint, work_order_id bigint, process_id bigint, reason text, level int, status int, handle_time datetime, handler_user_id bigint, remark text
CREATE TABLE `mes_pro_andon_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `config_id` bigint NULL COMMENT '安灯配置编号 关联 MesProAndonConfigDO#getId()',
  `workstation_id` bigint NULL COMMENT '工作站编号 关联 MesMdWorkstationDO#getId()',
  `user_id` bigint NULL COMMENT '发起用户编号 关联 system_users#id',
  `work_order_id` bigint NULL COMMENT '生产工单编号 关联 MesProWorkOrderDO#getId()',
  `process_id` bigint NULL COMMENT '工序编号 关联 MesProProcessDO#getId()',
  `reason` text NULL COMMENT '呼叫原因（快照值，不随配置变更）',
  `level` int NULL COMMENT '级别（快照值） 字典 DictTypeConstants#MES_PRO_ANDON_LEVEL 枚举 MesProAndonLevelEnum',
  `status` int NULL COMMENT '处置状态 字典 DictTypeConstants#MES_PRO_ANDON_STATUS 枚举 MesProAndonStatusEnum',
  `handle_time` datetime NULL COMMENT '处置时间',
  `handler_user_id` bigint NULL COMMENT '处置人编号 关联 system_users#id',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 安灯呼叫记录 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/card/MesProCardDO.java
-- Entity: MesProCardDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), work_order_id bigint, item_id bigint, batch_code varchar(255), transfered_quantity decimal(24,6), status int, remark text
CREATE TABLE `mes_pro_card` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '流转卡编码',
  `work_order_id` bigint NULL COMMENT '生产工单编号 关联 MesProWorkOrderDO#getId()',
  `item_id` bigint NULL COMMENT '产品物料编号 关联 MesMdItemDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `transfered_quantity` decimal(24,6) NULL COMMENT '流转数量',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_PRO_WORK_ORDER_STATUS 枚举 cn.iocoder.yudao.module.mes.enums.pro.MesProWorkOrderStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产流转卡 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/card/MesProCardProcessDO.java
-- Entity: MesProCardProcessDO extends BaseDO
-- 推断字段类型：id bigint, card_id bigint, sort int, process_id bigint, input_time datetime, output_time datetime, input_quantity decimal(24,6), output_quantity decimal(24,6), unqualified_quantity decimal(24,6), workstation_id bigint, user_id bigint, ipqc_id bigint, remark text
CREATE TABLE `mes_pro_card_process` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `card_id` bigint NULL COMMENT '流转卡编号 关联 MesProCardDO#getId()',
  `sort` int NULL COMMENT '序号',
  `process_id` bigint NULL COMMENT '工序编号 关联 MesProProcessDO#getId()',
  `input_time` datetime NULL COMMENT '进入工序时间',
  `output_time` datetime NULL COMMENT '出工序时间',
  `input_quantity` decimal(24,6) NULL COMMENT '投入数量',
  `output_quantity` decimal(24,6) NULL COMMENT '产出数量',
  `unqualified_quantity` decimal(24,6) NULL COMMENT '不合格品数量',
  `workstation_id` bigint NULL COMMENT '工位编号 关联 MesMdWorkstationDO#getId()',
  `user_id` bigint NULL COMMENT '操作人编号 关联 AdminUserDO#getId()',
  `ipqc_id` bigint NULL COMMENT '过程检验单编号 TODO @芋艿：关联 mes_qc_ipqc 表，等 IPQC 模块迁移后再对接',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 流转卡工序记录 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/feedback/MesProFeedbackDO.java
-- Entity: MesProFeedbackDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), type int, channel varchar(255), feedback_time datetime, workstation_id bigint, route_id bigint, process_id bigint, work_order_id bigint, task_id bigint, item_id bigint, expire_date datetime, lot_number varchar(255), scheduled_quantity decimal(24,6), feedback_quantity decimal(24,6), qualified_quantity decimal(24,6), unqualified_quantity decimal(24,6), uncheck_quantity decimal(24,6), labor_scrap_quantity decimal(24,6), material_scrap_quantity decimal(24,6), other_scrap_quantity decimal(24,6), feedback_user_id bigint, approve_user_id bigint, status int, remark text
CREATE TABLE `mes_pro_feedback` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '报工单编号',
  `type` int NULL COMMENT '报工类型 字典 DictTypeConstants#MES_PRO_FEEDBACK_TYPE 枚举 MesProFeedbackTypeEnum',
  `channel` varchar(255) NULL COMMENT '报工途径 字典类型 mes_pro_feedback_channel',
  `feedback_time` datetime NULL COMMENT '报工时间',
  `workstation_id` bigint NULL COMMENT '工作站编号 关联 MesMdWorkstationDO#getId()',
  `route_id` bigint NULL COMMENT '工艺路线编号 关联 MesProRouteDO#getId()',
  `process_id` bigint NULL COMMENT '工序编号 关联 MesProProcessDO#getId()',
  `work_order_id` bigint NULL COMMENT '生产工单编号 关联 MesProWorkOrderDO#getId()',
  `task_id` bigint NULL COMMENT '生产任务编号',
  `item_id` bigint NULL COMMENT '产品物料编号（冗余自任务） 关联 MesMdItemDO#getId()',
  `expire_date` datetime NULL COMMENT '过期日期',
  `lot_number` varchar(255) NULL COMMENT '生产批号 TODO @芋艿：预留字段，当前未启用',
  `scheduled_quantity` decimal(24,6) NULL COMMENT '排产数量',
  `feedback_quantity` decimal(24,6) NULL COMMENT '本次报工数量',
  `qualified_quantity` decimal(24,6) NULL COMMENT '合格品数量',
  `unqualified_quantity` decimal(24,6) NULL COMMENT '不良品数量',
  `uncheck_quantity` decimal(24,6) NULL COMMENT '待检测数量',
  `labor_scrap_quantity` decimal(24,6) NULL COMMENT '工废数量',
  `material_scrap_quantity` decimal(24,6) NULL COMMENT '料废数量',
  `other_scrap_quantity` decimal(24,6) NULL COMMENT '其他废品数量',
  `feedback_user_id` bigint NULL COMMENT '报工用户编号 关联 AdminUserDO#getId()',
  `approve_user_id` bigint NULL COMMENT '审核用户编号 关联 AdminUserDO#getId()',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_PRO_FEEDBACK_STATUS 枚举 MesProFeedbackStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产报工 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/process/MesProProcessContentDO.java
-- Entity: MesProProcessContentDO extends BaseDO
-- 推断字段类型：id bigint, process_id bigint, sort int, content text, device varchar(255), material varchar(255), doc_url varchar(1024), remark text
CREATE TABLE `mes_pro_process_content` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `process_id` bigint NULL COMMENT '工序编号 关联 MesProProcessDO#getId()',
  `sort` int NULL COMMENT '顺序编号',
  `content` text NULL COMMENT '步骤说明',
  `device` varchar(255) NULL COMMENT '辅助设备',
  `material` varchar(255) NULL COMMENT '辅助材料',
  `doc_url` varchar(1024) NULL COMMENT '材料文档 URL',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产工序内容 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/process/MesProProcessDO.java
-- Entity: MesProProcessDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), attention text, status int, remark text
-- 特殊类型依据：mes_pro_process.attention 实体注释为工艺要求，TEXT 容量为业务推断
CREATE TABLE `mes_pro_process` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '工序编码',
  `name` varchar(255) NULL COMMENT '工序名称',
  `attention` text NULL COMMENT '工艺要求',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产工序 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/route/MesProRouteDO.java
-- Entity: MesProRouteDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), description text, status int, remark text
CREATE TABLE `mes_pro_route` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '工艺路线编码',
  `name` varchar(255) NULL COMMENT '工艺路线名称',
  `description` text NULL COMMENT '工艺路线说明',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 工艺路线 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/route/MesProRouteProcessDO.java
-- Entity: MesProRouteProcessDO extends BaseDO
-- 推断字段类型：id bigint, route_id bigint, process_id bigint, sort int, next_process_id bigint, link_type int, prepare_time int, wait_time int, color_code varchar(255), key_flag bit(1), check_flag bit(1), remark text
CREATE TABLE `mes_pro_route_process` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `route_id` bigint NULL COMMENT '工艺路线编号 关联 MesProRouteDO#getId()',
  `process_id` bigint NULL COMMENT '工序编号 关联 MesProProcessDO#getId()',
  `sort` int NULL COMMENT '序号',
  `next_process_id` bigint NULL COMMENT '下一道工序编号 关联 MesProProcessDO#getId()',
  `link_type` int NULL COMMENT '与下一道工序关系 字典 cn.iocoder.yudao.module.mes.enums.DictTypeConstants#MES_PRO_LINK_TYPE 枚举 cn.iocoder.yudao.module.mes.enums.pro.MesProLinkTypeEnum',
  `prepare_time` int NULL COMMENT '准备时间（分钟）',
  `wait_time` int NULL COMMENT '等待时间（分钟）',
  `color_code` varchar(255) NULL COMMENT '甘特图显示颜色',
  `key_flag` bit(1) NULL COMMENT '是否关键工序',
  `check_flag` bit(1) NULL COMMENT '是否质检工序',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 工艺路线工序 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/route/MesProRouteProductBomDO.java
-- Entity: MesProRouteProductBomDO extends BaseDO
-- 推断字段类型：id bigint, route_id bigint, process_id bigint, product_id bigint, item_id bigint, quantity decimal(24,6), remark text
CREATE TABLE `mes_pro_route_product_bom` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `route_id` bigint NULL COMMENT '工艺路线编号 关联 MesProRouteDO#getId()',
  `process_id` bigint NULL COMMENT '工序编号 关联 MesProProcessDO#getId()',
  `product_id` bigint NULL COMMENT '产品物料编号 关联 cn.iocoder.yudao.module.mes.dal.dataobject.md.item.MesMdItemDO#getId()',
  `item_id` bigint NULL COMMENT 'BOM 物料编号 关联 cn.iocoder.yudao.module.mes.dal.dataobject.md.item.MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '用料比例',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 工艺路线产品 BOM DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/route/MesProRouteProductDO.java
-- Entity: MesProRouteProductDO extends BaseDO
-- 推断字段类型：id bigint, route_id bigint, item_id bigint, quantity int, production_time decimal(24,6), time_unit_type varchar(255), remark text
CREATE TABLE `mes_pro_route_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `route_id` bigint NULL COMMENT '工艺路线编号 关联 MesProRouteDO#getId()',
  `item_id` bigint NULL COMMENT '产品物料编号 关联 cn.iocoder.yudao.module.mes.dal.dataobject.md.item.MesMdItemDO#getId()',
  `quantity` int NULL COMMENT '生产数量',
  `production_time` decimal(24,6) NULL COMMENT '生产用时',
  `time_unit_type` varchar(255) NULL COMMENT '时间单位 字典 cn.iocoder.yudao.module.mes.enums.DictTypeConstants#MES_TIME_UNIT_TYPE 枚举 cn.iocoder.yudao.module.mes.enums.pro.MesTimeUnitTypeEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 工艺路线产品 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/task/MesProTaskDO.java
-- Entity: MesProTaskDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), work_order_id bigint, workstation_id bigint, route_id bigint, process_id bigint, item_id bigint, quantity decimal(24,6), produced_quantity decimal(24,6), qualify_quantity decimal(24,6), unqualify_quantity decimal(24,6), changed_quantity decimal(24,6), client_id bigint, start_time datetime, duration int, end_time datetime, color_code varchar(255), finish_date datetime, cancel_date datetime, status int, remark text
CREATE TABLE `mes_pro_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '任务编码',
  `name` varchar(255) NULL COMMENT '任务名称',
  `work_order_id` bigint NULL COMMENT '生产工单编号 关联 MesProWorkOrderDO#getId()',
  `workstation_id` bigint NULL COMMENT '工作站编号 关联 MesMdWorkstationDO#getId()',
  `route_id` bigint NULL COMMENT '工艺路线编号 关联 MesProRouteDO#getId()',
  `process_id` bigint NULL COMMENT '工序编号 关联 MesProProcessDO#getId()',
  `item_id` bigint NULL COMMENT '产品物料编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '排产数量',
  `produced_quantity` decimal(24,6) NULL COMMENT '已生产数量',
  `qualify_quantity` decimal(24,6) NULL COMMENT '合格品数量',
  `unqualify_quantity` decimal(24,6) NULL COMMENT '不良品数量',
  `changed_quantity` decimal(24,6) NULL COMMENT '调整数量',
  `client_id` bigint NULL COMMENT '客户编号 关联 MesMdClientDO#getId()',
  `start_time` datetime NULL COMMENT '开始生产时间',
  `duration` int NULL COMMENT '生产时长（工作日，1=8小时）',
  `end_time` datetime NULL COMMENT '结束生产时间',
  `color_code` varchar(255) NULL COMMENT '甘特图显示颜色',
  `finish_date` datetime NULL COMMENT '完成日期',
  `cancel_date` datetime NULL COMMENT '取消日期',
  `status` int NULL COMMENT '任务状态 字典 DictTypeConstants#MES_PRO_TASK_STATUS 枚举 MesProTaskStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产任务 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/task/MesProTaskIssueDO.java
-- Entity: MesProTaskIssueDO extends BaseDO
-- 推断字段类型：id bigint, task_id bigint, work_order_id bigint, workstation_id bigint, source_doc_type varchar(255), source_doc_id bigint, source_line_id bigint, source_doc_code varchar(255), batch_code varchar(255), item_id bigint, unit_measure_id bigint, issued_quantity decimal(24,6), available_quantity decimal(24,6), used_quantity decimal(24,6), remark text
CREATE TABLE `mes_pro_task_issue` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `task_id` bigint NULL COMMENT '生产任务编号 关联 MesProTaskDO#getId()',
  `work_order_id` bigint NULL COMMENT '生产工单编号 关联 MesProWorkOrderDO#getId()',
  `workstation_id` bigint NULL COMMENT '工作站编号 关联 MesMdWorkstationDO#getId()',
  `source_doc_type` varchar(255) NULL COMMENT '来源单据类型',
  `source_doc_id` bigint NULL COMMENT '来源单据编号',
  `source_line_id` bigint NULL COMMENT '来源单据行编号',
  `source_doc_code` varchar(255) NULL COMMENT '来源单据编码',
  `batch_code` varchar(255) NULL COMMENT '投料批次',
  `item_id` bigint NULL COMMENT '产品物料编号 关联 MesMdItemDO#getId()',
  `unit_measure_id` bigint NULL COMMENT '单位编号 关联 MesMdUnitMeasureDO#getId()',
  `issued_quantity` decimal(24,6) NULL COMMENT '总投料数量',
  `available_quantity` decimal(24,6) NULL COMMENT '当前可用数量',
  `used_quantity` decimal(24,6) NULL COMMENT '当前使用数量',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产任务投料 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/workorder/MesProWorkOrderBomDO.java
-- Entity: MesProWorkOrderBomDO extends BaseDO
-- 推断字段类型：id bigint, work_order_id bigint, item_id bigint, quantity decimal(24,6), remark text
CREATE TABLE `mes_pro_work_order_bom` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `work_order_id` bigint NULL COMMENT '生产工单编号 关联 MesProWorkOrderDO#getId()',
  `item_id` bigint NULL COMMENT 'BOM 物料编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '预计使用量',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产工单 BOM DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/workorder/MesProWorkOrderDO.java
-- Entity: MesProWorkOrderDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), type int, order_source_type int, order_source_code varchar(255), product_id bigint, quantity decimal(24,6), quantity_produced decimal(24,6), quantity_changed decimal(24,6), quantity_scheduled decimal(24,6), client_id bigint, vendor_id bigint, batch_code varchar(255), request_date datetime, parent_id bigint, finish_date datetime, cancel_date datetime, status int, remark text
CREATE TABLE `mes_pro_work_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '工单编码',
  `name` varchar(255) NULL COMMENT '工单名称',
  `type` int NULL COMMENT '工单类型 字典 DictTypeConstants#MES_PRO_WORK_ORDER_TYPE 枚举 MesProWorkOrderTypeEnum',
  `order_source_type` int NULL COMMENT '来源类型 字典 DictTypeConstants#MES_PRO_WORK_ORDER_SOURCE_TYPE 枚举 MesProWorkOrderSourceTypeEnum',
  `order_source_code` varchar(255) NULL COMMENT '来源单据编号',
  `product_id` bigint NULL COMMENT '产品编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '生产数量',
  `quantity_produced` decimal(24,6) NULL COMMENT '已生产数量',
  `quantity_changed` decimal(24,6) NULL COMMENT '调整数量',
  `quantity_scheduled` decimal(24,6) NULL COMMENT '已排产数量',
  `client_id` bigint NULL COMMENT '客户编号 关联 MesMdClientDO#getId()',
  `vendor_id` bigint NULL COMMENT '供应商编号 关联 MesMdVendorDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `request_date` datetime NULL COMMENT '需求日期',
  `parent_id` bigint NULL COMMENT '父工单编号 关联 MesProWorkOrderDO#getId()',
  `finish_date` datetime NULL COMMENT '完成时间',
  `cancel_date` datetime NULL COMMENT '取消时间',
  `status` int NULL COMMENT '工单状态 字典 DictTypeConstants#MES_PRO_WORK_ORDER_STATUS 枚举 MesProWorkOrderStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产工单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/workrecord/MesProWorkRecordDO.java
-- Entity: MesProWorkRecordDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, workstation_id bigint, type int, clock_in_time datetime, clock_out_time datetime, remark text
CREATE TABLE `mes_pro_work_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserDO#getId()',
  `workstation_id` bigint NULL COMMENT '工作站编号 关联 MesMdWorkstationDO#getId()',
  `type` int NULL COMMENT '当前状态 字典 DictTypeConstants#MES_PRO_WORK_RECORD_TYPE 枚举 cn.iocoder.yudao.module.mes.enums.pro.MesProWorkRecordTypeEnum',
  `clock_in_time` datetime NULL COMMENT '上工时间',
  `clock_out_time` datetime NULL COMMENT '下工时间',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 用户工作站绑定关系（当前快照） DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/workrecord/MesProWorkRecordLogDO.java
-- Entity: MesProWorkRecordLogDO extends BaseDO
-- 推断字段类型：id bigint, user_id bigint, workstation_id bigint, type int, remark text
CREATE TABLE `mes_pro_work_record_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint NULL COMMENT '用户编号 关联 AdminUserDO#getId()',
  `workstation_id` bigint NULL COMMENT '工作站编号 关联 MesMdWorkstationDO#getId()',
  `type` int NULL COMMENT '操作类型 字典 DictTypeConstants#MES_PRO_WORK_RECORD_TYPE 枚举 MesProWorkRecordTypeEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 上下工记录流水 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/defect/MesQcDefectDO.java
-- Entity: MesQcDefectDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), type int, level int, remark text
CREATE TABLE `mes_qc_defect` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '缺陷编码',
  `name` varchar(255) NULL COMMENT '缺陷描述',
  `type` int NULL COMMENT '检测项类型 字典类型 cn.iocoder.yudao.module.mes.enums.DictTypeConstants#MES_INDICATOR_TYPE',
  `level` int NULL COMMENT '缺陷等级 字典 DictTypeConstants#MES_DEFECT_LEVEL 枚举 cn.iocoder.yudao.module.mes.enums.qc.MesQcDefectLevelEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 缺陷类型 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/defectrecord/MesQcDefectRecordDO.java
-- Entity: MesQcDefectRecordDO extends BaseDO
-- 推断字段类型：id bigint, qc_type int, qc_id bigint, line_id bigint, name varchar(255), level int, quantity int, remark text
CREATE TABLE `mes_qc_defect_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `qc_type` int NULL COMMENT '检验类型 字典 DictTypeConstants#MES_QC_TYPE 枚举 MesQcTypeEnum',
  `qc_id` bigint NULL COMMENT '检验单 ID 关联 MesQcIqcDO#getId() 关联 MesQcIpqcDO#getId()',
  `line_id` bigint NULL COMMENT '检验行 ID 关联 MesQcIqcLineDO#getId() 关联 MesQcIpqcLineDO#getId()',
  `name` varchar(255) NULL COMMENT '缺陷描述',
  `level` int NULL COMMENT '缺陷等级 字典 DictTypeConstants#MES_DEFECT_LEVEL 枚举 MesQcDefectLevelEnum',
  `quantity` int NULL COMMENT '缺陷数量',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 质检缺陷记录 DO 通用缺陷记录表，通过 #qcType 区分检验类型（IQC、IPQC、OQC、RQC），多模块复用';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/indicator/MesQcIndicatorDO.java
-- Entity: MesQcIndicatorDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), type int, tool varchar(255), result_type int, result_specification varchar(255), remark text
CREATE TABLE `mes_qc_indicator` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '检测项编码',
  `name` varchar(255) NULL COMMENT '检测项名称',
  `type` int NULL COMMENT '检测项类型 枚举 cn.iocoder.yudao.module.mes.enums.DictTypeConstants#MES_INDICATOR_TYPE',
  `tool` varchar(255) NULL COMMENT '检测工具',
  `result_type` int NULL COMMENT '结果值类型 字典 DictTypeConstants#MES_QC_RESULT_TYPE 枚举 cn.iocoder.yudao.module.mes.enums.qc.MesQcResultValueTypeEnum',
  `result_specification` varchar(255) NULL COMMENT '结果值属性 1. FILE 时：存 IMG/FILE 2. DICT 时：存字典类型名',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 质检指标 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/indicatorresult/MesQcIndicatorResultDO.java
-- Entity: MesQcIndicatorResultDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), qc_id bigint, qc_type int, item_id bigint, sn varchar(255), remark text
CREATE TABLE `mes_qc_indicator_result` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '样品编号',
  `qc_id` bigint NULL COMMENT '关联质检单 ID（IQC/IPQC/OQC/RQC 的 id） 关联 IQC MesQcIqcDO#getId() 关联 IPQC MesQcIpqcDO#getId() 关联 OQC MesQcOqcDO#getId() 关联 RQC MesQcRqcDO#getId()',
  `qc_type` int NULL COMMENT '质检类型 字典 DictTypeConstants#MES_QC_TYPE 枚举 MesQcTypeEnum',
  `item_id` bigint NULL COMMENT '产品物料 ID 关联 MesMdItemDO#getId()',
  `sn` varchar(255) NULL COMMENT '物资 SN',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 检验结果记录 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/indicatorresult/MesQcIndicatorResultDetailDO.java
-- Entity: MesQcIndicatorResultDetailDO extends BaseDO
-- 推断字段类型：id bigint, result_id bigint, indicator_id bigint, value text, remark text
-- 特殊类型依据：mes_qc_indicator_result_detail.value 实体注释为统一字符串检测值，可能承载文件地址或文本检测结果；TEXT 容量为推断
CREATE TABLE `mes_qc_indicator_result_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `result_id` bigint NULL COMMENT '关联检验结果 ID 关联 MesQcIndicatorResultDO#getId()',
  `indicator_id` bigint NULL COMMENT '检测指标 ID 关联 MesQcIndicatorDO#getId()',
  `value` text NULL COMMENT '检测值（统一存为字符串）',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 检验结果明细记录 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/ipqc/MesQcIpqcDO.java
-- Entity: MesQcIpqcDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), type int, template_id bigint, source_doc_type int, source_doc_id bigint, source_line_id bigint, source_doc_code varchar(255), work_order_id bigint, task_id bigint, workstation_id bigint, process_id bigint, item_id bigint, check_quantity decimal(24,6), qualified_quantity decimal(24,6), unqualified_quantity decimal(24,6), labor_scrap_quantity decimal(24,6), material_scrap_quantity decimal(24,6), other_scrap_quantity decimal(24,6), critical_rate decimal(24,6), major_rate decimal(24,6), minor_rate decimal(24,6), critical_quantity int, major_quantity int, minor_quantity int, check_result int, inspect_date datetime, inspector_user_id bigint, status int, remark text
CREATE TABLE `mes_qc_ipqc` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '检验单编号',
  `name` varchar(255) NULL COMMENT '检验单名称',
  `type` int NULL COMMENT 'IPQC 检验类型 字典 cn.iocoder.yudao.module.mes.enums.DictTypeConstants#MES_IPQC_TYPE',
  `template_id` bigint NULL COMMENT '检验模板 ID 关联 MesQcTemplateDO#getId()',
  `source_doc_type` int NULL COMMENT '来源单据类型 字典 DictTypeConstants#MES_QC_SOURCE_DOC_TYPE 枚举 MesQcSourceDocTypeEnum',
  `source_doc_id` bigint NULL COMMENT '来源单据 ID 关联：根据 #sourceDocType 不同： 1. MesQcSourceDocTypeEnum#PRO_FEEDBACK 时，关联 MesProFeedbackDO#getId()',
  `source_line_id` bigint NULL COMMENT '来源单据行 ID 关联：根据 #sourceDocType 不同： 1. MesQcSourceDocTypeEnum#PRO_FEEDBACK 时，关联 cn.iocoder.yudao.module.mes.dal.dataobject.wm.productproduce.MesWmProductProduceLineDO#getId()',
  `source_doc_code` varchar(255) NULL COMMENT '来源单据编号（冗余）',
  `work_order_id` bigint NULL COMMENT '生产工单 ID 关联 MesProWorkOrderDO#getId()',
  `task_id` bigint NULL COMMENT '生产任务 ID 关联 cn.iocoder.yudao.module.mes.dal.dataobject.pro.task.MesProTaskDO#getId()',
  `workstation_id` bigint NULL COMMENT '工位 ID 关联 MesMdWorkstationDO#getId()',
  `process_id` bigint NULL COMMENT '工序 ID 关联 cn.iocoder.yudao.module.mes.dal.dataobject.pro.process.MesProProcessDO#getId()',
  `item_id` bigint NULL COMMENT '产品物料 ID 关联 MesMdItemDO#getId()',
  `check_quantity` decimal(24,6) NULL COMMENT '检测数量',
  `qualified_quantity` decimal(24,6) NULL COMMENT '合格品数量',
  `unqualified_quantity` decimal(24,6) NULL COMMENT '不合格品数量',
  `labor_scrap_quantity` decimal(24,6) NULL COMMENT '工废数量',
  `material_scrap_quantity` decimal(24,6) NULL COMMENT '料废数量',
  `other_scrap_quantity` decimal(24,6) NULL COMMENT '其他废品数量',
  `critical_rate` decimal(24,6) NULL COMMENT '致命缺陷率（%）',
  `major_rate` decimal(24,6) NULL COMMENT '严重缺陷率（%）',
  `minor_rate` decimal(24,6) NULL COMMENT '轻微缺陷率（%）',
  `critical_quantity` int NULL COMMENT '致命缺陷数量',
  `major_quantity` int NULL COMMENT '严重缺陷数量',
  `minor_quantity` int NULL COMMENT '轻微缺陷数量',
  `check_result` int NULL COMMENT '检测结果 字典 DictTypeConstants#MES_QC_CHECK_RESULT 枚举 cn.iocoder.yudao.module.mes.enums.qc.MesQcCheckResultEnum',
  `inspect_date` datetime NULL COMMENT '检测日期',
  `inspector_user_id` bigint NULL COMMENT '检测人员用户 ID 关联 AdminUserDO 的 id',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_ORDER_STATUS 枚举 MesQcStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 过程检验单（IPQC, In-Process Quality Control） DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/ipqc/MesQcIpqcLineDO.java
-- Entity: MesQcIpqcLineDO extends BaseDO
-- 推断字段类型：id bigint, ipqc_id bigint, indicator_id bigint, tool varchar(255), check_method text, standard_value decimal(24,6), unit_measure_id bigint, max_threshold decimal(24,6), min_threshold decimal(24,6), critical_quantity int, major_quantity int, minor_quantity int, remark text
-- 特殊类型依据：mes_qc_ipqc_line.check_method 实体注释为检测方法说明，TEXT 容量为业务推断
CREATE TABLE `mes_qc_ipqc_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `ipqc_id` bigint NULL COMMENT '过程检验单 ID 关联 MesQcIpqcDO#getId()',
  `indicator_id` bigint NULL COMMENT '检测指标 ID 关联 MesQcIndicatorDO#getId()',
  `tool` varchar(255) NULL COMMENT '检测工具 冗余 MesQcIndicatorDO#getTool()',
  `check_method` text NULL COMMENT '检测方法',
  `standard_value` decimal(24,6) NULL COMMENT '标准值',
  `unit_measure_id` bigint NULL COMMENT '计量单位 ID 关联 MesMdUnitMeasureDO#getId()',
  `max_threshold` decimal(24,6) NULL COMMENT '误差上限',
  `min_threshold` decimal(24,6) NULL COMMENT '误差下限',
  `critical_quantity` int NULL COMMENT '致命缺陷数量',
  `major_quantity` int NULL COMMENT '严重缺陷数量',
  `minor_quantity` int NULL COMMENT '轻微缺陷数量',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 过程检验单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/iqc/MesQcIqcDO.java
-- Entity: MesQcIqcDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), template_id bigint, source_doc_type int, source_doc_id bigint, source_line_id bigint, source_doc_code varchar(255), vendor_id bigint, vendor_batch varchar(255), item_id bigint, received_quantity decimal(24,6), check_quantity decimal(24,6), qualified_quantity decimal(24,6), unqualified_quantity decimal(24,6), critical_rate decimal(24,6), major_rate decimal(24,6), minor_rate decimal(24,6), critical_quantity int, major_quantity int, minor_quantity int, check_result int, receive_date datetime, inspect_date datetime, inspector_user_id bigint, status int, remark text
CREATE TABLE `mes_qc_iqc` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '检验单编号',
  `name` varchar(255) NULL COMMENT '检验单名称',
  `template_id` bigint NULL COMMENT '检验模板 ID 关联 MesQcTemplateDO#getId()',
  `source_doc_type` int NULL COMMENT '来源单据类型 字典 DictTypeConstants#MES_QC_SOURCE_DOC_TYPE 枚举 MesQcSourceDocTypeEnum',
  `source_doc_id` bigint NULL COMMENT '来源单据 ID 关联：根据 #sourceDocType 不同： 1. MesQcSourceDocTypeEnum#ARRIVAL_NOTICE 时，关联 MesWmArrivalNoticeDO#getId()',
  `source_line_id` bigint NULL COMMENT '来源单据行 ID 关联：根据 #sourceDocType 不同： 1. MesQcSourceDocTypeEnum#ARRIVAL_NOTICE 时，关联 MesWmArrivalNoticeLineDO#getId()',
  `source_doc_code` varchar(255) NULL COMMENT '来源单据编号（冗余）',
  `vendor_id` bigint NULL COMMENT '供应商 ID 关联 MesMdVendorDO#getId()',
  `vendor_batch` varchar(255) NULL COMMENT '供应商批次号',
  `item_id` bigint NULL COMMENT '产品物料 ID 关联 MesMdItemDO#getId()',
  `received_quantity` decimal(24,6) NULL COMMENT '本次接收数量',
  `check_quantity` decimal(24,6) NULL COMMENT '本次检测数量',
  `qualified_quantity` decimal(24,6) NULL COMMENT '合格品数量',
  `unqualified_quantity` decimal(24,6) NULL COMMENT '不合格品数量',
  `critical_rate` decimal(24,6) NULL COMMENT '致命缺陷率（%）',
  `major_rate` decimal(24,6) NULL COMMENT '严重缺陷率（%）',
  `minor_rate` decimal(24,6) NULL COMMENT '轻微缺陷率（%）',
  `critical_quantity` int NULL COMMENT '致命缺陷数量',
  `major_quantity` int NULL COMMENT '严重缺陷数量',
  `minor_quantity` int NULL COMMENT '轻微缺陷数量',
  `check_result` int NULL COMMENT '检测结果 字典 DictTypeConstants#MES_QC_CHECK_RESULT 枚举 MesQcCheckResultEnum',
  `receive_date` datetime NULL COMMENT '来料日期',
  `inspect_date` datetime NULL COMMENT '检测日期',
  `inspector_user_id` bigint NULL COMMENT '检测人员用户 ID 关联 AdminUserDO 的 id',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_ORDER_STATUS 枚举 MesQcStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 来料检验单（IQC, Incoming Quality Control） DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/iqc/MesQcIqcLineDO.java
-- Entity: MesQcIqcLineDO extends BaseDO
-- 推断字段类型：id bigint, iqc_id bigint, indicator_id bigint, tool varchar(255), check_method text, standard_value decimal(24,6), unit_measure_id bigint, max_threshold decimal(24,6), min_threshold decimal(24,6), critical_quantity int, major_quantity int, minor_quantity int, remark text
-- 特殊类型依据：mes_qc_iqc_line.check_method 实体注释为检测方法说明，TEXT 容量为业务推断
CREATE TABLE `mes_qc_iqc_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `iqc_id` bigint NULL COMMENT '来料检验单 ID 关联 MesQcIqcDO#getId()',
  `indicator_id` bigint NULL COMMENT '检测指标 ID 关联 MesQcIndicatorDO#getId()',
  `tool` varchar(255) NULL COMMENT '检测工具 冗余 MesQcIndicatorDO#getTool()',
  `check_method` text NULL COMMENT '检测方法',
  `standard_value` decimal(24,6) NULL COMMENT '标准值',
  `unit_measure_id` bigint NULL COMMENT '计量单位 ID 关联 MesMdUnitMeasureDO#getId()',
  `max_threshold` decimal(24,6) NULL COMMENT '误差上限',
  `min_threshold` decimal(24,6) NULL COMMENT '误差下限',
  `critical_quantity` int NULL COMMENT '致命缺陷数量',
  `major_quantity` int NULL COMMENT '严重缺陷数量',
  `minor_quantity` int NULL COMMENT '轻微缺陷数量',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 来料检验单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/oqc/MesQcOqcDO.java
-- Entity: MesQcOqcDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), template_id bigint, source_doc_type int, source_doc_id bigint, source_line_id bigint, source_doc_code varchar(255), client_id bigint, batch_code varchar(255), item_id bigint, min_check_quantity int, max_unqualified_quantity int, out_quantity decimal(24,6), check_quantity decimal(24,6), qualified_quantity decimal(24,6), unqualified_quantity decimal(24,6), critical_rate decimal(24,6), major_rate decimal(24,6), minor_rate decimal(24,6), critical_quantity int, major_quantity int, minor_quantity int, check_result int, out_date datetime, inspect_date datetime, inspector_user_id bigint, status int, remark text
CREATE TABLE `mes_qc_oqc` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '检验单编号',
  `name` varchar(255) NULL COMMENT '检验单名称',
  `template_id` bigint NULL COMMENT '检验模板 ID 关联 MesQcTemplateDO#getId()',
  `source_doc_type` int NULL COMMENT '来源单据类型 字典 DictTypeConstants#MES_QC_SOURCE_DOC_TYPE 枚举 cn.iocoder.yudao.module.mes.enums.qc.MesQcSourceDocTypeEnum',
  `source_doc_id` bigint NULL COMMENT '来源单据 ID 关联：根据 #sourceDocType 不同： 1. cn.iocoder.yudao.module.mes.enums.qc.MesQcSourceDocTypeEnum#PRODUCT_SALES 时，关联 cn.iocoder.yudao.module.mes.dal.dataobject.wm.productsales.MesWmProductSalesDO#getId()',
  `source_line_id` bigint NULL COMMENT '来源单据行 ID 关联：根据 #sourceDocType 不同： 1. cn.iocoder.yudao.module.mes.enums.qc.MesQcSourceDocTypeEnum#PRODUCT_SALES 时，关联 cn.iocoder.yudao.module.mes.dal.dataobject.wm.productsales.MesWmProductSalesLineDO#getId()',
  `source_doc_code` varchar(255) NULL COMMENT '来源单据编号（冗余）',
  `client_id` bigint NULL COMMENT '客户 ID 关联 MesMdClientDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `item_id` bigint NULL COMMENT '产品物料 ID 关联 MesMdItemDO#getId()',
  `min_check_quantity` int NULL COMMENT '最低检测数',
  `max_unqualified_quantity` int NULL COMMENT '最大不合格数',
  `out_quantity` decimal(24,6) NULL COMMENT '本次出货数量',
  `check_quantity` decimal(24,6) NULL COMMENT '本次检测数量',
  `qualified_quantity` decimal(24,6) NULL COMMENT '合格品数量',
  `unqualified_quantity` decimal(24,6) NULL COMMENT '不合格品数量',
  `critical_rate` decimal(24,6) NULL COMMENT '致命缺陷率（%）',
  `major_rate` decimal(24,6) NULL COMMENT '严重缺陷率（%）',
  `minor_rate` decimal(24,6) NULL COMMENT '轻微缺陷率（%）',
  `critical_quantity` int NULL COMMENT '致命缺陷数量',
  `major_quantity` int NULL COMMENT '严重缺陷数量',
  `minor_quantity` int NULL COMMENT '轻微缺陷数量',
  `check_result` int NULL COMMENT '检测结果 字典 DictTypeConstants#MES_QC_CHECK_RESULT 枚举 cn.iocoder.yudao.module.mes.enums.qc.MesQcCheckResultEnum',
  `out_date` datetime NULL COMMENT '出货日期',
  `inspect_date` datetime NULL COMMENT '检测日期',
  `inspector_user_id` bigint NULL COMMENT '检测人员用户 ID 关联 AdminUserDO 的 id',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_ORDER_STATUS 枚举 cn.iocoder.yudao.module.mes.enums.qc.MesQcStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 出货检验单（OQC, Outgoing Quality Control） DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/oqc/MesQcOqcLineDO.java
-- Entity: MesQcOqcLineDO extends BaseDO
-- 推断字段类型：id bigint, oqc_id bigint, indicator_id bigint, tool varchar(255), check_method text, standard_value decimal(24,6), unit_measure_id bigint, max_threshold decimal(24,6), min_threshold decimal(24,6), critical_quantity int, major_quantity int, minor_quantity int, remark text
-- 特殊类型依据：mes_qc_oqc_line.check_method 实体注释为检测方法说明，TEXT 容量为业务推断
CREATE TABLE `mes_qc_oqc_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `oqc_id` bigint NULL COMMENT '出货检验单 ID 关联 MesQcOqcDO#getId()',
  `indicator_id` bigint NULL COMMENT '检测指标 ID 关联 MesQcIndicatorDO#getId()',
  `tool` varchar(255) NULL COMMENT '检测工具 冗余 MesQcIndicatorDO#getTool()',
  `check_method` text NULL COMMENT '检测方法',
  `standard_value` decimal(24,6) NULL COMMENT '标准值',
  `unit_measure_id` bigint NULL COMMENT '计量单位 ID 关联 MesMdUnitMeasureDO#getId()',
  `max_threshold` decimal(24,6) NULL COMMENT '误差上限',
  `min_threshold` decimal(24,6) NULL COMMENT '误差下限',
  `critical_quantity` int NULL COMMENT '致命缺陷数量',
  `major_quantity` int NULL COMMENT '严重缺陷数量',
  `minor_quantity` int NULL COMMENT '轻微缺陷数量',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 出货检验单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/rqc/MesQcRqcDO.java
-- Entity: MesQcRqcDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), template_id bigint, source_doc_type int, source_doc_id bigint, source_line_id bigint, source_doc_code varchar(255), type int, item_id bigint, batch_code varchar(255), check_quantity decimal(24,6), qualified_quantity decimal(24,6), unqualified_quantity decimal(24,6), critical_rate decimal(24,6), major_rate decimal(24,6), minor_rate decimal(24,6), critical_quantity int, major_quantity int, minor_quantity int, check_result int, inspect_date datetime, inspector_user_id bigint, status int, remark text
CREATE TABLE `mes_qc_rqc` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '检验单编号',
  `name` varchar(255) NULL COMMENT '检验单名称',
  `template_id` bigint NULL COMMENT '检验模板 ID 关联 MesQcTemplateDO#getId()',
  `source_doc_type` int NULL COMMENT '来源单据类型 关联 cn.iocoder.yudao.module.mes.enums.MesBizTypeConstants',
  `source_doc_id` bigint NULL COMMENT '来源单据 ID',
  `source_line_id` bigint NULL COMMENT '来源单据行 ID',
  `source_doc_code` varchar(255) NULL COMMENT '来源单据编码（冗余）',
  `type` int NULL COMMENT '检验类型 字典 mes_rqc_type',
  `item_id` bigint NULL COMMENT '产品物料 ID 关联 MesMdItemDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `check_quantity` decimal(24,6) NULL COMMENT '检测数量',
  `qualified_quantity` decimal(24,6) NULL COMMENT '合格品数量',
  `unqualified_quantity` decimal(24,6) NULL COMMENT '不合格数量',
  `critical_rate` decimal(24,6) NULL COMMENT '致命缺陷率（%）',
  `major_rate` decimal(24,6) NULL COMMENT '严重缺陷率（%）',
  `minor_rate` decimal(24,6) NULL COMMENT '轻微缺陷率（%）',
  `critical_quantity` int NULL COMMENT '致命缺陷数量',
  `major_quantity` int NULL COMMENT '严重缺陷数量',
  `minor_quantity` int NULL COMMENT '轻微缺陷数量',
  `check_result` int NULL COMMENT '检测结果 字典 DictTypeConstants#MES_QC_CHECK_RESULT 枚举 cn.iocoder.yudao.module.mes.enums.qc.MesQcCheckResultEnum',
  `inspect_date` datetime NULL COMMENT '检测日期',
  `inspector_user_id` bigint NULL COMMENT '检测人员用户 ID 关联 AdminUserDO 的 id',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_ORDER_STATUS 枚举 MesQcStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 退货检验单（RQC, Return Quality Control） DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/rqc/MesQcRqcLineDO.java
-- Entity: MesQcRqcLineDO extends BaseDO
-- 推断字段类型：id bigint, rqc_id bigint, indicator_id bigint, tool varchar(255), check_method text, standard_value decimal(24,6), unit_measure_id bigint, max_threshold decimal(24,6), min_threshold decimal(24,6), critical_quantity int, major_quantity int, minor_quantity int, remark text
-- 特殊类型依据：mes_qc_rqc_line.check_method 实体注释为检测方法说明，TEXT 容量为业务推断
CREATE TABLE `mes_qc_rqc_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `rqc_id` bigint NULL COMMENT '退货检验单 ID 关联 MesQcRqcDO#getId()',
  `indicator_id` bigint NULL COMMENT '检测指标 ID 关联 MesQcIndicatorDO#getId()',
  `tool` varchar(255) NULL COMMENT '检测工具 冗余 MesQcIndicatorDO#getTool()',
  `check_method` text NULL COMMENT '检测方法',
  `standard_value` decimal(24,6) NULL COMMENT '标准值',
  `unit_measure_id` bigint NULL COMMENT '计量单位 ID 关联 MesMdUnitMeasureDO#getId()',
  `max_threshold` decimal(24,6) NULL COMMENT '误差上限',
  `min_threshold` decimal(24,6) NULL COMMENT '误差下限',
  `critical_quantity` int NULL COMMENT '致命缺陷数量',
  `major_quantity` int NULL COMMENT '严重缺陷数量',
  `minor_quantity` int NULL COMMENT '轻微缺陷数量',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 退货检验行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/template/MesQcTemplateDO.java
-- Entity: MesQcTemplateDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), types varchar(255), status int, remark text
-- 特殊类型依据：mes_qc_template.types IntegerListTypeHandler 明示 JDBC VARCHAR 并按逗号连接整数，Mapper 使用 FIND_IN_SET；VARCHAR(255) 容量为推断
CREATE TABLE `mes_qc_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '方案编号',
  `name` varchar(255) NULL COMMENT '方案名称',
  `types` varchar(255) NULL COMMENT '检测种类 字典 DictTypeConstants#MES_QC_TYPE',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 质检方案 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/template/MesQcTemplateIndicatorDO.java
-- Entity: MesQcTemplateIndicatorDO extends BaseDO
-- 推断字段类型：id bigint, template_id bigint, indicator_id bigint, check_method text, standard_value decimal(24,6), unit_measure_id bigint, threshold_max decimal(24,6), threshold_min decimal(24,6), doc_url varchar(1024), remark text
-- 特殊类型依据：mes_qc_template_indicator.check_method 实体注释为检测方法说明，TEXT 容量为业务推断
CREATE TABLE `mes_qc_template_indicator` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `template_id` bigint NULL COMMENT '质检方案编号 关联 MesQcTemplateDO#getId()',
  `indicator_id` bigint NULL COMMENT '质检指标编号 关联 MesQcIndicatorDO#getId()',
  `check_method` text NULL COMMENT '检测方法',
  `standard_value` decimal(24,6) NULL COMMENT '标准值',
  `unit_measure_id` bigint NULL COMMENT '计量单位编号 关联 MesMdUnitMeasureDO#getId()',
  `threshold_max` decimal(24,6) NULL COMMENT '误差上限',
  `threshold_min` decimal(24,6) NULL COMMENT '误差下限',
  `doc_url` varchar(1024) NULL COMMENT '说明图 URL',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 质检方案-检测指标项 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/template/MesQcTemplateItemDO.java
-- Entity: MesQcTemplateItemDO extends BaseDO
-- 推断字段类型：id bigint, template_id bigint, item_id bigint, quantity_check int, quantity_unqualified int, critical_rate decimal(24,6), major_rate decimal(24,6), minor_rate decimal(24,6), remark text
CREATE TABLE `mes_qc_template_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `template_id` bigint NULL COMMENT '质检方案编号 关联 MesQcTemplateDO#getId()',
  `item_id` bigint NULL COMMENT '产品物料编号 关联 MesMdItemDO#getId()',
  `quantity_check` int NULL COMMENT '最低检测数',
  `quantity_unqualified` int NULL COMMENT '最大不合格数（0=不启用）',
  `critical_rate` decimal(24,6) NULL COMMENT '最大致命缺陷率（%，0=不允许）',
  `major_rate` decimal(24,6) NULL COMMENT '最大严重缺陷率（%，0=不允许）',
  `minor_rate` decimal(24,6) NULL COMMENT '最大轻微缺陷率（%）',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 质检方案-产品关联 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/tm/tool/MesTmToolDO.java
-- Entity: MesTmToolDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), brand varchar(255), specification varchar(255), tool_type_id bigint, quantity int, available_quantity int, mainten_type int, next_mainten_period int, next_mainten_date datetime, status int, remark text
CREATE TABLE `mes_tm_tool` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '工具编码',
  `name` varchar(255) NULL COMMENT '工具名称',
  `brand` varchar(255) NULL COMMENT '品牌',
  `specification` varchar(255) NULL COMMENT '型号规格',
  `tool_type_id` bigint NULL COMMENT '工具类型编号 关联 MesTmToolTypeDO#getId()',
  `quantity` int NULL COMMENT '数量',
  `available_quantity` int NULL COMMENT '可用数量',
  `mainten_type` int NULL COMMENT '保养维护类型 字典 DictTypeConstants#MES_TM_MAINTEN_TYPE 枚举 MesTmMaintenTypeEnum',
  `next_mainten_period` int NULL COMMENT '下次保养周期（次数）',
  `next_mainten_date` datetime NULL COMMENT '下次保养日期',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_TM_TOOL_STATUS 枚举 MesTmToolStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 工具台账 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/tm/tool/MesTmToolTypeDO.java
-- Entity: MesTmToolTypeDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), code_flag bit(1), mainten_type int, mainten_period int, remark text
CREATE TABLE `mes_tm_tool_type` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '类型编码',
  `name` varchar(255) NULL COMMENT '类型名称',
  `code_flag` bit(1) NULL COMMENT '是否编码管理',
  `mainten_type` int NULL COMMENT '保养维护类型 字典 DictTypeConstants#MES_TM_MAINTEN_TYPE 枚举 MesTmMaintenTypeEnum',
  `mainten_period` int NULL COMMENT '保养周期',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 工具类型 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/arrivalnotice/MesWmArrivalNoticeDO.java
-- Entity: MesWmArrivalNoticeDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), purchase_order_code varchar(255), vendor_id bigint, arrival_date datetime, contact_name varchar(255), contact_telephone varchar(255), status int, remark text
CREATE TABLE `mes_wm_arrival_notice` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '通知单编码',
  `name` varchar(255) NULL COMMENT '通知单名称',
  `purchase_order_code` varchar(255) NULL COMMENT '采购订单编号',
  `vendor_id` bigint NULL COMMENT '供应商编号 关联 MesMdVendorDO#getId()',
  `arrival_date` datetime NULL COMMENT '到货日期',
  `contact_name` varchar(255) NULL COMMENT '联系人',
  `contact_telephone` varchar(255) NULL COMMENT '联系电话',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_ARRIVAL_NOTICE_STATUS 枚举 MesWmArrivalNoticeStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 到货通知单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/arrivalnotice/MesWmArrivalNoticeLineDO.java
-- Entity: MesWmArrivalNoticeLineDO extends BaseDO
-- 推断字段类型：id bigint, notice_id bigint, item_id bigint, arrival_quantity decimal(24,6), qualified_quantity decimal(24,6), iqc_check_flag bit(1), iqc_id bigint, remark text
CREATE TABLE `mes_wm_arrival_notice_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `notice_id` bigint NULL COMMENT '到货通知单编号 关联 MesWmArrivalNoticeDO#getId()',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `arrival_quantity` decimal(24,6) NULL COMMENT '到货数量',
  `qualified_quantity` decimal(24,6) NULL COMMENT '合格数量',
  `iqc_check_flag` bit(1) NULL COMMENT '是否需要来料检验',
  `iqc_id` bigint NULL COMMENT '来料检验单编号 关联 MesQcIqcDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 到货通知单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/barcode/MesWmBarcodeConfigDO.java
-- Entity: MesWmBarcodeConfigDO extends BaseDO
-- 推断字段类型：id bigint, format int, biz_type int, content_format text, content_example text, auto_generate_flag bit(1), default_template text, status int, remark text
-- 特殊类型依据：mes_wm_barcode_config.content_format 实体注释为含业务编码占位符的内容格式模板，TEXT 容量为业务推断
-- 特殊类型依据：mes_wm_barcode_config.content_example 实体注释为条码内容样例，TEXT 容量为业务推断
-- 特殊类型依据：mes_wm_barcode_config.default_template 实体注释为默认打印模板，TEXT 容量为业务推断
CREATE TABLE `mes_wm_barcode_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `format` int NULL COMMENT '条码格式 字典 DictTypeConstants#MES_BARCODE_FORMAT 枚举 cn.iocoder.yudao.module.mes.enums.wm.BarcodeFormatEnum',
  `biz_type` int NULL COMMENT '业务类型 字典 DictTypeConstants#MES_BARCODE_BIZ_TYPE 枚举 cn.iocoder.yudao.module.mes.enums.wm.BarcodeBizTypeEnum',
  `content_format` text NULL COMMENT '内容格式模板（支持 {BUSINESSCODE} 占位符） @see #PLACEHOLDER_BUSINESS_CODE',
  `content_example` text NULL COMMENT '内容样例',
  `auto_generate_flag` bit(1) NULL COMMENT '是否自动生成',
  `default_template` text NULL COMMENT '默认打印模板',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 条码配置 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/barcode/MesWmBarcodeDO.java
-- Entity: MesWmBarcodeDO extends BaseDO
-- 推断字段类型：id bigint, config_id bigint, format int, biz_type int, content text, biz_id bigint, biz_code varchar(255), biz_name varchar(255), status int, remark text
CREATE TABLE `mes_wm_barcode` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `config_id` bigint NULL COMMENT '条码配置编号 关联 MesWmBarcodeConfigDO#getId()',
  `format` int NULL COMMENT '条码格式 字典 DictTypeConstants#MES_BARCODE_FORMAT 枚举 cn.iocoder.yudao.module.mes.enums.wm.BarcodeFormatEnum',
  `biz_type` int NULL COMMENT '业务类型 字典 DictTypeConstants#MES_BARCODE_BIZ_TYPE 枚举 cn.iocoder.yudao.module.mes.enums.wm.BarcodeBizTypeEnum',
  `content` text NULL COMMENT '条码内容（核心字段，前端根据此内容生成条码图片）',
  `biz_id` bigint NULL COMMENT '业务编号',
  `biz_code` varchar(255) NULL COMMENT '业务编码',
  `biz_name` varchar(255) NULL COMMENT '业务名称',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 条码清单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/batch/MesWmBatchDO.java
-- Entity: MesWmBatchDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), item_id bigint, produce_date datetime, expire_date datetime, receipt_date datetime, vendor_id bigint, client_id bigint, sales_order_code varchar(255), purchase_order_code varchar(255), work_order_id bigint, task_id bigint, workstation_id bigint, tool_id bigint, mold_id bigint, lot_number varchar(255), quality_status int, remark text
CREATE TABLE `mes_wm_batch` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '批次ID',
  `code` varchar(255) NULL COMMENT '批次编码',
  `item_id` bigint NULL COMMENT '物料ID 关联 MesMdItemDO#getId()',
  `produce_date` datetime NULL COMMENT '生产日期',
  `expire_date` datetime NULL COMMENT '有效期',
  `receipt_date` datetime NULL COMMENT '入库日期',
  `vendor_id` bigint NULL COMMENT '供应商ID 关联 MesMdVendorDO#getId()',
  `client_id` bigint NULL COMMENT '客户ID 关联 MesMdClientDO#getId()',
  `sales_order_code` varchar(255) NULL COMMENT '销售订单编号',
  `purchase_order_code` varchar(255) NULL COMMENT '采购订单编号',
  `work_order_id` bigint NULL COMMENT '生产工单ID 关联 MesProWorkOrderDO#getId()',
  `task_id` bigint NULL COMMENT '生产任务ID 关联 MesProTaskDO#getId()',
  `workstation_id` bigint NULL COMMENT '工作站ID 关联 MesMdWorkstationDO#getId()',
  `tool_id` bigint NULL COMMENT '工具ID 关联 MesTmToolDO#getId()',
  `mold_id` bigint NULL COMMENT '模具 ID',
  `lot_number` varchar(255) NULL COMMENT '生产批号',
  `quality_status` int NULL COMMENT '质量状态',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='批次管理 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/itemconsume/MesWmItemConsumeDO.java
-- Entity: MesWmItemConsumeDO extends BaseDO
-- 推断字段类型：id bigint, work_order_id bigint, task_id bigint, workstation_id bigint, process_id bigint, feedback_id bigint, consume_date datetime, status int, remark text
CREATE TABLE `mes_wm_item_consume` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `work_order_id` bigint NULL COMMENT '生产工单编号 关联 MesProWorkOrderDO#getId()',
  `task_id` bigint NULL COMMENT '生产任务编号 关联 MesProTaskDO#getId()',
  `workstation_id` bigint NULL COMMENT '工作站编号 关联 MesMdWorkstationDO#getId()',
  `process_id` bigint NULL COMMENT '工序编号 关联 MesProProcessDO#getId()',
  `feedback_id` bigint NULL COMMENT '报工记录编号 关联 MesProFeedbackDO#getId()',
  `consume_date` datetime NULL COMMENT '消耗日期',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_ITEM_CONSUME_STATUS 枚举 cn.iocoder.yudao.module.mes.enums.wm.MesWmItemConsumeStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 物料消耗记录 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/itemconsume/MesWmItemConsumeDetailDO.java
-- Entity: MesWmItemConsumeDetailDO extends BaseDO
-- 推断字段类型：id bigint, consume_id bigint, line_id bigint, material_stock_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_item_consume_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `consume_id` bigint NULL COMMENT '消耗记录编号 关联 MesWmItemConsumeDO#getId()',
  `line_id` bigint NULL COMMENT '消耗记录行编号 关联 MesWmItemConsumeLineDO#getId()',
  `material_stock_id` bigint NULL COMMENT '库存台账编号 关联 MesWmMaterialStockDO#getId() 当线边库中无可用库存时为 null',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '消耗数量',
  `batch_id` bigint NULL COMMENT '批次编号 关联 MesWmBatchDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号 冗余 MesWmBatchDO#getCode()',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区编号 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位编号 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 物料消耗记录明细 DO 记录 line 级别的消耗按线边库 FIFO 分配到具体批次的明细。 一条 line 可能拆分为多条 detail（当一个批次库存不够，需要从下一个批次继续分配时）。';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/itemconsume/MesWmItemConsumeLineDO.java
-- Entity: MesWmItemConsumeLineDO extends BaseDO
-- 推断字段类型：id bigint, consume_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), remark text
CREATE TABLE `mes_wm_item_consume_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `consume_id` bigint NULL COMMENT '消耗记录编号 关联 MesWmItemConsumeDO#getId()',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '消耗数量',
  `batch_id` bigint NULL COMMENT '批次编号 关联 cn.iocoder.yudao.module.mes.dal.dataobject.wm.batch.MesWmBatchDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号 冗余 cn.iocoder.yudao.module.mes.dal.dataobject.wm.batch.MesWmBatchDO#getCode()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 物料消耗记录行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/itemreceipt/MesWmItemReceiptDO.java
-- Entity: MesWmItemReceiptDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), iqc_id bigint, notice_id bigint, purchase_order_code varchar(255), vendor_id bigint, receipt_date datetime, status int, remark text
CREATE TABLE `mes_wm_item_receipt` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '入库单编码',
  `name` varchar(255) NULL COMMENT '入库单名称',
  `iqc_id` bigint NULL COMMENT '来料检验单编号 关联 MesQcIqcDO#getId()',
  `notice_id` bigint NULL COMMENT '到货通知单编号 关联 MesWmArrivalNoticeDO#getId()',
  `purchase_order_code` varchar(255) NULL COMMENT '采购订单号 冗余自 MesWmArrivalNoticeDO#getPurchaseOrderCode()，也可以手动填写',
  `vendor_id` bigint NULL COMMENT '供应商编号 关联 MesMdVendorDO#getId()',
  `receipt_date` datetime NULL COMMENT '入库日期',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_ITEM_RECEIPT_STATUS 枚举 MesWmItemReceiptStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 采购入库单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/itemreceipt/MesWmItemReceiptDetailDO.java
-- Entity: MesWmItemReceiptDetailDO extends BaseDO
-- 推断字段类型：id bigint, line_id bigint, receipt_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_item_receipt_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `line_id` bigint NULL COMMENT '入库单行编号 关联 MesWmItemReceiptLineDO#getId()',
  `receipt_id` bigint NULL COMMENT '入库单编号 关联 MesWmItemReceiptDO#getId()',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '上架数量',
  `batch_id` bigint NULL COMMENT '批次编号 TODO DONE @芋艿：保留。待 mes_wm_batch 模块迁移后补充 @link 关联',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区编号 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位编号 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 采购入库明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/itemreceipt/MesWmItemReceiptLineDO.java
-- Entity: MesWmItemReceiptLineDO extends BaseDO
-- 推断字段类型：id bigint, receipt_id bigint, arrival_notice_line_id bigint, item_id bigint, received_quantity decimal(24,6), batch_id bigint, batch_code varchar(255), production_date datetime, expire_date datetime, lot_number varchar(255), remark text
CREATE TABLE `mes_wm_item_receipt_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `receipt_id` bigint NULL COMMENT '入库单编号 关联 MesWmItemReceiptDO#getId()',
  `arrival_notice_line_id` bigint NULL COMMENT '到货通知单行编号 关联 MesWmArrivalNoticeLineDO#getId()',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `received_quantity` decimal(24,6) NULL COMMENT '入库数量',
  `batch_id` bigint NULL COMMENT '批次编号 关联 MesWmBatchDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次编码 关联 MesWmBatchDO#getCode()',
  `production_date` datetime NULL COMMENT '生产日期',
  `expire_date` datetime NULL COMMENT '有效期',
  `lot_number` varchar(255) NULL COMMENT '生产批号',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 采购入库单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/materialstock/MesWmMaterialStockDO.java
-- Entity: MesWmMaterialStockDO extends BaseDO
-- 推断字段类型：id bigint, item_type_id bigint, item_id bigint, batch_id bigint, batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, vendor_id bigint, quantity decimal(24,6), receipt_time datetime, frozen bit(1)
CREATE TABLE `mes_wm_material_stock` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `item_type_id` bigint NULL COMMENT '物料分类编号 关联 MesMdItemTypeDO#getId()',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `batch_id` bigint NULL COMMENT '批次编号 关联 MesWmBatchDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号 关联 MesWmBatchDO#getCode()',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区编号 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位编号 关联 MesWmWarehouseAreaDO#getId()',
  `vendor_id` bigint NULL COMMENT '供应商编号 关联 MesMdVendorDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '在库数量',
  `receipt_time` datetime NULL COMMENT '入库时间',
  `frozen` bit(1) NULL COMMENT '是否冻结',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 库存台账（仓库现有量）DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/miscissue/MesWmMiscIssueDO.java
-- Entity: MesWmMiscIssueDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), type int, source_doc_type varchar(255), source_doc_id bigint, source_doc_code varchar(255), issue_date datetime, status int, remark text
CREATE TABLE `mes_wm_misc_issue` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '出库单编号',
  `name` varchar(255) NULL COMMENT '出库单名称',
  `type` int NULL COMMENT '杂项类型 字典 DictTypeConstants#MES_WM_MISC_ISSUE_TYPE 枚举 cn.iocoder.yudao.module.mes.enums.wm.MesWmMiscIssueTypeEnum',
  `source_doc_type` varchar(255) NULL COMMENT '来源单据类型',
  `source_doc_id` bigint NULL COMMENT '来源单据 ID',
  `source_doc_code` varchar(255) NULL COMMENT '来源单据编号',
  `issue_date` datetime NULL COMMENT '出库日期',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_MISC_ISSUE_STATUS 枚举 MesWmMiscIssueStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 杂项出库单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/miscissue/MesWmMiscIssueDetailDO.java
-- Entity: MesWmMiscIssueDetailDO extends BaseDO
-- 推断字段类型：id bigint, issue_id bigint, line_id bigint, material_stock_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_misc_issue_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `issue_id` bigint NULL COMMENT '出库单ID 关联 MesWmMiscIssueDO#getId()',
  `line_id` bigint NULL COMMENT '行ID 关联 MesWmMiscIssueLineDO#getId()',
  `material_stock_id` bigint NULL COMMENT '库存记录ID 关联 MesWmMaterialStockDO#getId()',
  `item_id` bigint NULL COMMENT '物料ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '出库数量',
  `batch_id` bigint NULL COMMENT '批次ID',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `warehouse_id` bigint NULL COMMENT '仓库ID 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区ID 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位ID 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 杂项出库明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/miscissue/MesWmMiscIssueLineDO.java
-- Entity: MesWmMiscIssueLineDO extends BaseDO
-- 推断字段类型：id bigint, issue_id bigint, source_doc_line_id bigint, material_stock_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_misc_issue_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `issue_id` bigint NULL COMMENT '出库单编号 关联 MesWmMiscIssueDO#getId()',
  `source_doc_line_id` bigint NULL COMMENT '来源单据行ID',
  `material_stock_id` bigint NULL COMMENT '库存记录ID',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '出库数量',
  `batch_id` bigint NULL COMMENT '批次编号 关联 MesWmBatchDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号 挂你兰 MesWmBatchDO#getCode()',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区编号 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位编号 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 杂项出库单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/miscreceipt/MesWmMiscReceiptDO.java
-- Entity: MesWmMiscReceiptDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), type int, source_doc_type varchar(255), source_doc_id bigint, source_doc_code varchar(255), receipt_date datetime, status int, remark text
CREATE TABLE `mes_wm_misc_receipt` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '入库单编码',
  `name` varchar(255) NULL COMMENT '入库单名称',
  `type` int NULL COMMENT '杂项类型 字典 DictTypeConstants#MES_WM_MISC_RECEIPT_TYPE',
  `source_doc_type` varchar(255) NULL COMMENT '来源单据类型',
  `source_doc_id` bigint NULL COMMENT '来源单据 ID',
  `source_doc_code` varchar(255) NULL COMMENT '来源单据编码',
  `receipt_date` datetime NULL COMMENT '入库日期',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_MISC_RECEIPT_STATUS 枚举 MesWmMiscReceiptStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 杂项入库单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/miscreceipt/MesWmMiscReceiptDetailDO.java
-- Entity: MesWmMiscReceiptDetailDO extends BaseDO
-- 推断字段类型：id bigint, receipt_id bigint, line_id bigint, item_id bigint, quantity decimal(24,6), batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_misc_receipt_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `receipt_id` bigint NULL COMMENT '入库单ID 关联 MesWmMiscReceiptDO#getId()',
  `line_id` bigint NULL COMMENT '行ID 关联 MesWmMiscReceiptLineDO#getId()',
  `item_id` bigint NULL COMMENT '物料ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '入库数量',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `warehouse_id` bigint NULL COMMENT '仓库ID 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区ID 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位ID 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 杂项入库明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/miscreceipt/MesWmMiscReceiptLineDO.java
-- Entity: MesWmMiscReceiptLineDO extends BaseDO
-- 推断字段类型：id bigint, receipt_id bigint, item_id bigint, quantity decimal(24,6), batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_misc_receipt_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `receipt_id` bigint NULL COMMENT '入库单编号 关联 MesWmMiscReceiptDO#getId()',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '入库数量',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区编号 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位编号 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 杂项入库单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/outsourceissue/MesWmOutsourceIssueDO.java
-- Entity: MesWmOutsourceIssueDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), vendor_id bigint, work_order_id bigint, issue_date datetime, status int, remark text
CREATE TABLE `mes_wm_outsource_issue` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '发料单ID',
  `code` varchar(255) NULL COMMENT '发料单编号',
  `name` varchar(255) NULL COMMENT '发料单名称',
  `vendor_id` bigint NULL COMMENT '供应商ID 关联 MesMdVendorDO#getId()',
  `work_order_id` bigint NULL COMMENT '生产工单ID 关联 MesProWorkOrderDO#getId()',
  `issue_date` datetime NULL COMMENT '发料日期',
  `status` int NULL COMMENT '单据状态 字典 DictTypeConstants#MES_WM_OUTSOURCE_ISSUE_STATUS 枚举 MesWmOutsourceIssueStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 外协发料单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/outsourceissue/MesWmOutsourceIssueDetailDO.java
-- Entity: MesWmOutsourceIssueDetailDO extends BaseDO
-- 推断字段类型：id bigint, line_id bigint, issue_id bigint, material_stock_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_outsource_issue_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `line_id` bigint NULL COMMENT '行ID 关联 MesWmOutsourceIssueLineDO#getId()',
  `issue_id` bigint NULL COMMENT '发料单ID 关联 MesWmOutsourceIssueDO#getId()',
  `material_stock_id` bigint NULL COMMENT '库存ID 关联 MesWmMaterialStockDO#getId()',
  `item_id` bigint NULL COMMENT '物料ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '数量',
  `batch_id` bigint NULL COMMENT '批次ID',
  `warehouse_id` bigint NULL COMMENT '仓库ID 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库位ID',
  `area_id` bigint NULL COMMENT '库区ID',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 外协发料单明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/outsourceissue/MesWmOutsourceIssueLineDO.java
-- Entity: MesWmOutsourceIssueLineDO extends BaseDO
-- 推断字段类型：id bigint, issue_id bigint, material_stock_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, remark text
CREATE TABLE `mes_wm_outsource_issue_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '行ID',
  `issue_id` bigint NULL COMMENT '发料单ID 关联 MesWmOutsourceIssueDO#getId()',
  `material_stock_id` bigint NULL COMMENT '库存ID',
  `item_id` bigint NULL COMMENT '物料ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '发料数量',
  `batch_id` bigint NULL COMMENT '批次ID',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 外协发料单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/outsourcereceipt/MesWmOutsourceReceiptDO.java
-- Entity: MesWmOutsourceReceiptDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), work_order_id bigint, vendor_id bigint, receipt_date datetime, status int, remark text
CREATE TABLE `mes_wm_outsource_receipt` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '入库单编码',
  `name` varchar(255) NULL COMMENT '入库单名称',
  `work_order_id` bigint NULL COMMENT '外协工单编号 关联 cn.iocoder.yudao.module.mes.dal.dataobject.pro.workorder.MesProWorkOrderDO#getId()',
  `vendor_id` bigint NULL COMMENT '供应商编号 关联 MesMdVendorDO#getId()',
  `receipt_date` datetime NULL COMMENT '入库日期',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_OUTSOURCE_RECEIPT_STATUS 枚举 MesWmOutsourceReceiptStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 外协入库单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/outsourcereceipt/MesWmOutsourceReceiptDetailDO.java
-- Entity: MesWmOutsourceReceiptDetailDO extends BaseDO
-- 推断字段类型：id bigint, line_id bigint, receipt_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_outsource_receipt_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `line_id` bigint NULL COMMENT '入库单行编号 关联 MesWmOutsourceReceiptLineDO#getId()',
  `receipt_id` bigint NULL COMMENT '入库单编号 关联 MesWmOutsourceReceiptDO#getId()',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '上架数量',
  `batch_id` bigint NULL COMMENT '批次编号 DONE @芋艿：保留。待 mes_wm_batch 模块迁移后补充 @link 关联（AI 未修复原因：标注为后续处理，需人工介入）',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区编号 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位编号 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 外协入库明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/outsourcereceipt/MesWmOutsourceReceiptLineDO.java
-- Entity: MesWmOutsourceReceiptLineDO extends BaseDO
-- 推断字段类型：id bigint, receipt_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), production_date datetime, expire_date datetime, lot_number varchar(255), remark text, iqc_id bigint, iqc_check_flag bit(1), quality_status int
CREATE TABLE `mes_wm_outsource_receipt_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `receipt_id` bigint NULL COMMENT '入库单编号 关联 MesWmOutsourceReceiptDO#getId()',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '入库数量',
  `batch_id` bigint NULL COMMENT '批次编号 关联 MesWmBatchDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号 关联 MesWmBatchDO#getCode()',
  `production_date` datetime NULL COMMENT '生产日期',
  `expire_date` datetime NULL COMMENT '有效期',
  `lot_number` varchar(255) NULL COMMENT '生产批号',
  `remark` text NULL COMMENT '备注',
  `iqc_id` bigint NULL COMMENT '来料检验单编号 关联 MesQcIqcDO#getId()',
  `iqc_check_flag` bit(1) NULL COMMENT '是否需要质检',
  `quality_status` int NULL COMMENT '质量状态 字典 DictTypeConstants#MES_WM_QUALITY_STATUS 枚举 cn.iocoder.yudao.module.mes.enums.wm.MesWmQualityStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 外协入库单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/packages/MesWmPackageDO.java
-- Entity: MesWmPackageDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), parent_id bigint, package_date datetime, sales_order_code varchar(255), invoice_code varchar(255), client_id bigint, length decimal(24,6), width decimal(24,6), height decimal(24,6), size_unit_id bigint, net_weight decimal(24,6), gross_weight decimal(24,6), weight_unit_id bigint, inspector_user_id bigint, status int, remark text
CREATE TABLE `mes_wm_package` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号（注释推断，实体未声明）',
  `code` varchar(255) NULL COMMENT '装箱单编号',
  `parent_id` bigint NULL COMMENT '父箱 ID',
  `package_date` datetime NULL COMMENT '装箱日期',
  `sales_order_code` varchar(255) NULL COMMENT '销售订单编号',
  `invoice_code` varchar(255) NULL COMMENT '发票编号',
  `client_id` bigint NULL COMMENT '客户 ID 关联 MesMdClientDO#getId()',
  `length` decimal(24,6) NULL COMMENT '箱长度',
  `width` decimal(24,6) NULL COMMENT '箱宽度',
  `height` decimal(24,6) NULL COMMENT '箱高度',
  `size_unit_id` bigint NULL COMMENT '尺寸单位 ID 关联 MesMdUnitMeasureDO#getId()',
  `net_weight` decimal(24,6) NULL COMMENT '净重',
  `gross_weight` decimal(24,6) NULL COMMENT '毛重',
  `weight_unit_id` bigint NULL COMMENT '重量单位 ID 关联 MesMdUnitMeasureDO#getId()',
  `inspector_user_id` bigint NULL COMMENT '检查员用户 ID 关联 AdminUserDO 的 id',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_PACKAGE_STATUS 枚举 cn.iocoder.yudao.module.mes.enums.wm.MesWmPackageStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 装箱单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/packages/MesWmPackageLineDO.java
-- Entity: MesWmPackageLineDO extends BaseDO
-- 推断字段类型：id bigint, package_id bigint, material_stock_id bigint, item_id bigint, quantity decimal(24,6), work_order_id bigint, expire_date datetime, remark text
CREATE TABLE `mes_wm_package_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号（注释推断，实体未声明）',
  `package_id` bigint NULL COMMENT '装箱单 ID 关联 MesWmPackageDO#getId()',
  `material_stock_id` bigint NULL COMMENT '库存记录 ID',
  `item_id` bigint NULL COMMENT '产品物料 ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '装箱数量',
  `work_order_id` bigint NULL COMMENT '生产工单 ID 关联 MesProWorkOrderDO#getId()',
  `expire_date` datetime NULL COMMENT '有效期',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 装箱明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productissue/MesWmProductIssueDO.java
-- Entity: MesWmProductIssueDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), workstation_id bigint, work_order_id bigint, task_id bigint, issue_date datetime, required_time datetime, status int, remark text
CREATE TABLE `mes_wm_product_issue` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '领料单编号',
  `name` varchar(255) NULL COMMENT '领料单名称',
  `workstation_id` bigint NULL COMMENT '工作站 ID 关联 MesMdWorkstationDO#getId()',
  `work_order_id` bigint NULL COMMENT '生产工单 ID 关联 MesProWorkOrderDO#getId()',
  `task_id` bigint NULL COMMENT '生产任务 ID 关联 MesProTaskDO#getId()',
  `issue_date` datetime NULL COMMENT '领料日期',
  `required_time` datetime NULL COMMENT '需求时间',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_PRODUCT_ISSUE_STATUS 枚举 MesWmProductIssueStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 领料出库单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productissue/MesWmProductIssueDetailDO.java
-- Entity: MesWmProductIssueDetailDO extends BaseDO
-- 推断字段类型：id bigint, issue_id bigint, line_id bigint, material_stock_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_product_issue_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `issue_id` bigint NULL COMMENT '领料单ID 关联 MesWmProductIssueDO#getId()',
  `line_id` bigint NULL COMMENT '行ID 关联 MesWmProductIssueLineDO#getId()',
  `material_stock_id` bigint NULL COMMENT '库存记录ID 关联 MesWmMaterialStockDO#getId()',
  `item_id` bigint NULL COMMENT '物料ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '领料数量',
  `batch_id` bigint NULL COMMENT '批次ID',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `warehouse_id` bigint NULL COMMENT '仓库ID 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区ID 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位ID 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 领料出库明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productissue/MesWmProductIssueLineDO.java
-- Entity: MesWmProductIssueLineDO extends BaseDO
-- 推断字段类型：id bigint, issue_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, remark text
CREATE TABLE `mes_wm_product_issue_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `issue_id` bigint NULL COMMENT '领料单 ID 关联 MesWmProductIssueDO#getId()',
  `item_id` bigint NULL COMMENT '物料 ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '领料数量',
  `batch_id` bigint NULL COMMENT '批次 ID',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 领料出库单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productproduce/MesWmProductProduceDO.java
-- Entity: MesWmProductProduceDO extends BaseDO
-- 推断字段类型：id bigint, work_order_id bigint, feedback_id bigint, task_id bigint, workstation_id bigint, process_id bigint, produce_date datetime, status int, remark text
CREATE TABLE `mes_wm_product_produce` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `work_order_id` bigint NULL COMMENT '生产工单 ID 关联 MesProWorkOrderDO#getId()',
  `feedback_id` bigint NULL COMMENT '报工记录 ID 关联 MesProFeedbackDO#getId()',
  `task_id` bigint NULL COMMENT '生产任务 ID 关联 MesProTaskDO#getId()',
  `workstation_id` bigint NULL COMMENT '工作站 ID 关联 MesMdWorkstationDO#getId()',
  `process_id` bigint NULL COMMENT '工序 ID 关联 MesProProcessDO#getId()',
  `produce_date` datetime NULL COMMENT '生产日期',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_PRODUCT_PRODUCE_STATUS 枚举 MesWmProductProduceStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产入库单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productproduce/MesWmProductProduceDetailDO.java
-- Entity: MesWmProductProduceDetailDO extends BaseDO
-- 推断字段类型：id bigint, produce_id bigint, line_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_product_produce_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `produce_id` bigint NULL COMMENT '入库单 ID 关联 MesWmProductProduceDO#getId()',
  `line_id` bigint NULL COMMENT '行 ID 关联 MesWmProductProduceLineDO#getId()',
  `item_id` bigint NULL COMMENT '物料 ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '入库数量',
  `batch_id` bigint NULL COMMENT '批次 ID',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `warehouse_id` bigint NULL COMMENT '仓库 ID 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区 ID 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位 ID 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产入库明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productproduce/MesWmProductProduceLineDO.java
-- Entity: MesWmProductProduceLineDO extends BaseDO
-- 推断字段类型：id bigint, produce_id bigint, feedback_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), expire_date datetime, lot_number varchar(255), quality_status int, remark text
CREATE TABLE `mes_wm_product_produce_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `produce_id` bigint NULL COMMENT '入库单 ID 关联 MesWmProductProduceDO#getId()',
  `feedback_id` bigint NULL COMMENT '报工记录 ID 关联 MesProFeedbackDO#getId()',
  `item_id` bigint NULL COMMENT '物料 ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '入库数量',
  `batch_id` bigint NULL COMMENT '批次 ID',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `expire_date` datetime NULL COMMENT '过期日期',
  `lot_number` varchar(255) NULL COMMENT '生产批号',
  `quality_status` int NULL COMMENT '质量状态 字典 DictTypeConstants#MES_WM_QUALITY_STATUS 枚举 cn.iocoder.yudao.module.mes.enums.wm.MesWmQualityStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产入库单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productreceipt/MesWmProductReceiptDO.java
-- Entity: MesWmProductReceiptDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), work_order_id bigint, item_id bigint, receipt_date datetime, status int, remark text
CREATE TABLE `mes_wm_product_receipt` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '收货单编码',
  `name` varchar(255) NULL COMMENT '收货单名称',
  `work_order_id` bigint NULL COMMENT '生产工单编号 关联 MesProWorkOrderDO#getId()',
  `item_id` bigint NULL COMMENT '产品物料编号 关联 MesMdItemDO#getId()',
  `receipt_date` datetime NULL COMMENT '收货日期',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_PRODUCT_RECEIPT_STATUS 枚举 MesWmProductReceiptStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 产品收货（入库）单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productreceipt/MesWmProductReceiptDetailDO.java
-- Entity: MesWmProductReceiptDetailDO extends BaseDO
-- 推断字段类型：id bigint, line_id bigint, receipt_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_product_receipt_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `line_id` bigint NULL COMMENT '收货单行编号 关联 MesWmProductReceiptLineDO#getId()',
  `receipt_id` bigint NULL COMMENT '收货单编号 关联 MesWmProductReceiptDO#getId()',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '上架数量',
  `batch_id` bigint NULL COMMENT '批次编号 TODO DONE @芋艿：保留。待 mes_wm_batch 模块迁移后补充 @link 关联',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区编号 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位编号 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 产品收货（入库）单明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productreceipt/MesWmProductReceiptLineDO.java
-- Entity: MesWmProductReceiptLineDO extends BaseDO
-- 推断字段类型：id bigint, receipt_id bigint, item_id bigint, material_stock_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), remark text
CREATE TABLE `mes_wm_product_receipt_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `receipt_id` bigint NULL COMMENT '收货单编号 关联 MesWmProductReceiptDO#getId()',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `material_stock_id` bigint NULL COMMENT '库存物资记录编号 关联 cn.iocoder.yudao.module.mes.dal.dataobject.wm.materialstock.MesWmMaterialStockDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '收货数量',
  `batch_id` bigint NULL COMMENT '批次编号 关联 MesWmBatchDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号 关联 MesWmBatchDO#getCode()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 产品收货（入库）单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productsales/MesWmProductSalesDO.java
-- Entity: MesWmProductSalesDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), client_id bigint, sales_order_code varchar(255), notice_id bigint, sales_date datetime, contact_name varchar(255), contact_telephone varchar(255), contact_address varchar(255), carrier varchar(255), shipping_number varchar(255), status int, remark text
CREATE TABLE `mes_wm_product_sales` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '出库单号',
  `name` varchar(255) NULL COMMENT '出库单名称',
  `client_id` bigint NULL COMMENT '客户ID 关联 MesMdClientDO#getId()',
  `sales_order_code` varchar(255) NULL COMMENT '销售订单号',
  `notice_id` bigint NULL COMMENT '发货通知单 ID 关联 MesWmSalesNoticeDO#getId()',
  `sales_date` datetime NULL COMMENT '出库日期',
  `contact_name` varchar(255) NULL COMMENT '联系人',
  `contact_telephone` varchar(255) NULL COMMENT '联系电话',
  `contact_address` varchar(255) NULL COMMENT '收货地址',
  `carrier` varchar(255) NULL COMMENT '承运商',
  `shipping_number` varchar(255) NULL COMMENT '运输单号',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_PRODUCT_SALES_STATUS 枚举 MesWmProductSalesStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 销售出库单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productsales/MesWmProductSalesDetailDO.java
-- Entity: MesWmProductSalesDetailDO extends BaseDO
-- 推断字段类型：id bigint, line_id bigint, sales_id bigint, item_id bigint, quantity decimal(24,6), material_stock_id bigint, batch_id bigint, batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_product_sales_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `line_id` bigint NULL COMMENT '出库单行ID 关联 MesWmProductSalesLineDO#getId()',
  `sales_id` bigint NULL COMMENT '出库单ID 关联 MesWmProductSalesDO#getId()',
  `item_id` bigint NULL COMMENT '物料ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '拣货数量',
  `material_stock_id` bigint NULL COMMENT '库存记录ID 关联 MesWmMaterialStockDO#getId()',
  `batch_id` bigint NULL COMMENT '批次 ID 关联 MesWmBatchDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号 关联 MesWmBatchDO#getCode()',
  `warehouse_id` bigint NULL COMMENT '仓库ID 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区ID 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位ID 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 销售出库明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productsales/MesWmProductSalesLineDO.java
-- Entity: MesWmProductSalesLineDO extends BaseDO
-- 推断字段类型：id bigint, sales_id bigint, notice_line_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), material_stock_id bigint, oqc_check_flag bit(1), oqc_id bigint, quality_status int, remark text
CREATE TABLE `mes_wm_product_sales_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `sales_id` bigint NULL COMMENT '出库单ID 关联 MesWmProductSalesDO#getId()',
  `notice_line_id` bigint NULL COMMENT '发货通知单行ID 关联 MesWmSalesNoticeLineDO#getId()',
  `item_id` bigint NULL COMMENT '物料ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '出库数量',
  `batch_id` bigint NULL COMMENT '批次 ID 关联 MesWmBatchDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号 关联 MesWmBatchDO#getCode()',
  `material_stock_id` bigint NULL COMMENT '库存记录ID 关联 MesWmMaterialStockDO#getId()',
  `oqc_check_flag` bit(1) NULL COMMENT '是否出厂检验',
  `oqc_id` bigint NULL COMMENT '出厂检验单 ID 关联 MesQcOqcDO#getId()',
  `quality_status` int NULL COMMENT '质量状态 字典 DictTypeConstants#MES_WM_QUALITY_STATUS 枚举 MesWmQualityStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 销售出库单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnissue/MesWmReturnIssueDO.java
-- Entity: MesWmReturnIssueDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), work_order_id bigint, workstation_id bigint, type int, return_date datetime, status int, remark text
CREATE TABLE `mes_wm_return_issue` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '退料单编号',
  `name` varchar(255) NULL COMMENT '退料单名称',
  `work_order_id` bigint NULL COMMENT '生产工单 ID 关联 MesProWorkOrderDO#getId()',
  `workstation_id` bigint NULL COMMENT '工作站 ID 关联 MesMdWorkstationDO#getId()',
  `type` int NULL COMMENT '退料类型 字典 DictTypeConstants#MES_WM_RETURN_ISSUE_TYPE 枚举 cn.iocoder.yudao.module.mes.enums.wm.MesWmReturnIssueTypeEnum',
  `return_date` datetime NULL COMMENT '退料日期',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_RETURN_ISSUE_STATUS 枚举 MesWmReturnIssueStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产退料单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnissue/MesWmReturnIssueDetailDO.java
-- Entity: MesWmReturnIssueDetailDO extends BaseDO
-- 推断字段类型：id bigint, issue_id bigint, line_id bigint, material_stock_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_return_issue_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `issue_id` bigint NULL COMMENT '退料单 ID 关联 MesWmReturnIssueDO#getId()',
  `line_id` bigint NULL COMMENT '行 ID 关联 MesWmReturnIssueLineDO#getId()',
  `material_stock_id` bigint NULL COMMENT '库存记录 ID 关联 MesWmMaterialStockDO#getId()',
  `item_id` bigint NULL COMMENT '物料 ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '退料数量',
  `batch_id` bigint NULL COMMENT '批次 ID',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `warehouse_id` bigint NULL COMMENT '仓库 ID 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区 ID 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位 ID 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产退料明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnissue/MesWmReturnIssueLineDO.java
-- Entity: MesWmReturnIssueLineDO extends BaseDO
-- 推断字段类型：id bigint, issue_id bigint, material_stock_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), rqc_id bigint, rqc_check_flag bit(1), quality_status int, remark text
CREATE TABLE `mes_wm_return_issue_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `issue_id` bigint NULL COMMENT '退料单 ID 关联 MesWmReturnIssueDO#getId()',
  `material_stock_id` bigint NULL COMMENT '库存记录 ID 关联 MesWmMaterialStockDO#getId()',
  `item_id` bigint NULL COMMENT '物料 ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '退料数量',
  `batch_id` bigint NULL COMMENT '批次 ID 关联 MesWmBatchDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次编码 关联 MesWmBatchDO#getCode()',
  `rqc_id` bigint NULL COMMENT '退货检验单 ID 关联 MesQcRqcDO#getId()',
  `rqc_check_flag` bit(1) NULL COMMENT '是否需要质检',
  `quality_status` int NULL COMMENT '质量状态 字典 DictTypeConstants#MES_WM_QUALITY_STATUS 枚举 cn.iocoder.yudao.module.mes.enums.wm.MesWmQualityStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 生产退料单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnsales/MesWmReturnSalesDO.java
-- Entity: MesWmReturnSalesDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), sales_order_code varchar(255), client_id bigint, return_date datetime, return_reason varchar(255), status int, remark text
CREATE TABLE `mes_wm_return_sales` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '退货单编号',
  `name` varchar(255) NULL COMMENT '退货单名称',
  `sales_order_code` varchar(255) NULL COMMENT '销售订单编号',
  `client_id` bigint NULL COMMENT '客户 ID 关联 MesMdClientDO#getId()',
  `return_date` datetime NULL COMMENT '退货日期',
  `return_reason` varchar(255) NULL COMMENT '退货原因',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_RETURN_SALES_STATUS 枚举 MesWmReturnSalesStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 销售退货单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnsales/MesWmReturnSalesDetailDO.java
-- Entity: MesWmReturnSalesDetailDO extends BaseDO
-- 推断字段类型：id bigint, return_id bigint, line_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_return_sales_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `return_id` bigint NULL COMMENT '退货单 ID 关联 MesWmReturnSalesDO#getId()',
  `line_id` bigint NULL COMMENT '行 ID 关联 MesWmReturnSalesLineDO#getId()',
  `item_id` bigint NULL COMMENT '物料 ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '数量',
  `batch_id` bigint NULL COMMENT '批次 ID',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `warehouse_id` bigint NULL COMMENT '仓库 ID 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区 ID 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位 ID 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 销售退货明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnsales/MesWmReturnSalesLineDO.java
-- Entity: MesWmReturnSalesLineDO extends BaseDO
-- 推断字段类型：id bigint, return_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), rqc_id bigint, rqc_check_flag bit(1), quality_status int, remark text
CREATE TABLE `mes_wm_return_sales_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `return_id` bigint NULL COMMENT '退货单 ID 关联 MesWmReturnSalesDO#getId()',
  `item_id` bigint NULL COMMENT '物料 ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '退货数量',
  `batch_id` bigint NULL COMMENT '批次 ID',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `rqc_id` bigint NULL COMMENT '退货检验单 ID',
  `rqc_check_flag` bit(1) NULL COMMENT '是否需要质检',
  `quality_status` int NULL COMMENT '质量状态 字典 DictTypeConstants#MES_WM_QUALITY_STATUS 枚举 cn.iocoder.yudao.module.mes.enums.wm.MesWmQualityStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 销售退货单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnvendor/MesWmReturnVendorDO.java
-- Entity: MesWmReturnVendorDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), purchase_order_code varchar(255), vendor_id bigint, return_date datetime, return_reason varchar(255), transport_code varchar(255), transport_telephone varchar(255), status int, remark text
CREATE TABLE `mes_wm_return_vendor` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '退货单编号',
  `name` varchar(255) NULL COMMENT '退货单名称',
  `purchase_order_code` varchar(255) NULL COMMENT '采购订单编号',
  `vendor_id` bigint NULL COMMENT '供应商 ID 关联 MesMdVendorDO#getId()',
  `return_date` datetime NULL COMMENT '退货日期',
  `return_reason` varchar(255) NULL COMMENT '退货原因',
  `transport_code` varchar(255) NULL COMMENT '物流单号',
  `transport_telephone` varchar(255) NULL COMMENT '物流联系电话',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_RETURN_VENDOR_STATUS 枚举 MesWmReturnVendorStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 供应商退货单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnvendor/MesWmReturnVendorDetailDO.java
-- Entity: MesWmReturnVendorDetailDO extends BaseDO
-- 推断字段类型：id bigint, return_id bigint, line_id bigint, material_stock_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, remark text
CREATE TABLE `mes_wm_return_vendor_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `return_id` bigint NULL COMMENT '退货单 ID 关联 MesWmReturnVendorDO#getId()',
  `line_id` bigint NULL COMMENT '行 ID 关联 MesWmReturnVendorLineDO#getId()',
  `material_stock_id` bigint NULL COMMENT '库存记录 ID 关联 MesWmMaterialStockDO#getId()',
  `item_id` bigint NULL COMMENT '物料 ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '退货数量',
  `batch_id` bigint NULL COMMENT '批次 ID',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `warehouse_id` bigint NULL COMMENT '仓库 ID 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区 ID 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位 ID 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 供应商退货明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnvendor/MesWmReturnVendorLineDO.java
-- Entity: MesWmReturnVendorLineDO extends BaseDO
-- 推断字段类型：id bigint, return_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), remark text
CREATE TABLE `mes_wm_return_vendor_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `return_id` bigint NULL COMMENT '退货单 ID 关联 MesWmReturnVendorDO#getId()',
  `item_id` bigint NULL COMMENT '物料 ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '退货数量',
  `batch_id` bigint NULL COMMENT '批次 ID 关联 MesWmBatchDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号 关联 MesWmBatchDO#getCode()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 供应商退货单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/salesnotice/MesWmSalesNoticeDO.java
-- Entity: MesWmSalesNoticeDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), sales_order_code varchar(255), client_id bigint, sales_date datetime, recipient_name varchar(255), recipient_telephone varchar(255), recipient_address varchar(255), status int, remark text
CREATE TABLE `mes_wm_sales_notice` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '通知单编码',
  `name` varchar(255) NULL COMMENT '通知单名称',
  `sales_order_code` varchar(255) NULL COMMENT '销售订单编号',
  `client_id` bigint NULL COMMENT '客户编号 关联 MesMdClientDO#getId()',
  `sales_date` datetime NULL COMMENT '发货日期',
  `recipient_name` varchar(255) NULL COMMENT '收货人',
  `recipient_telephone` varchar(255) NULL COMMENT '联系方式',
  `recipient_address` varchar(255) NULL COMMENT '收货地址',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_SALES_NOTICE_STATUS 枚举 cn.iocoder.yudao.module.mes.enums.wm.MesWmSalesNoticeStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 发货通知单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/salesnotice/MesWmSalesNoticeLineDO.java
-- Entity: MesWmSalesNoticeLineDO extends BaseDO
-- 推断字段类型：id bigint, notice_id bigint, item_id bigint, batch_id bigint, batch_code varchar(255), quantity decimal(24,6), oqc_check_flag bit(1), remark text
CREATE TABLE `mes_wm_sales_notice_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `notice_id` bigint NULL COMMENT '发货通知单编号 关联 MesWmSalesNoticeDO#getId()',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `batch_id` bigint NULL COMMENT '批次编号 关联 MesWmBatchDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号 关联 MesWmBatchDO#getCode()',
  `quantity` decimal(24,6) NULL COMMENT '发货数量',
  `oqc_check_flag` bit(1) NULL COMMENT '是否检验',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 发货通知单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/sn/MesWmSnDO.java
-- Entity: MesWmSnDO extends BaseDO
-- 推断字段类型：id bigint, uuid varchar(255), code varchar(255), item_id bigint, batch_code varchar(255), work_order_id bigint
CREATE TABLE `mes_wm_sn` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `uuid` varchar(255) NULL COMMENT '批次 UUID（用于标记同一批次生成的 SN 码）',
  `code` varchar(255) NULL COMMENT 'SN 码（唯一）',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号',
  `work_order_id` bigint NULL COMMENT '生产工单编号 关联 MesProWorkOrderDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES SN 码 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/stocktaking/plan/MesWmStockTakingPlanDO.java
-- Entity: MesWmStockTakingPlanDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), type int, start_time datetime, end_time datetime, blind_flag bit(1), frozen bit(1), status int, remark text
CREATE TABLE `mes_wm_stock_taking_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '方案编码',
  `name` varchar(255) NULL COMMENT '方案名称',
  `type` int NULL COMMENT '盘点类型 字典 DictTypeConstants#MES_WM_STOCK_TAKING_TYPE 枚举 MesWmStockTakingTypeEnum',
  `start_time` datetime NULL COMMENT '计划开始时间',
  `end_time` datetime NULL COMMENT '计划结束时间',
  `blind_flag` bit(1) NULL COMMENT '是否盲盘',
  `frozen` bit(1) NULL COMMENT '是否冻结库存',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 盘点方案 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/stocktaking/plan/MesWmStockTakingPlanParamDO.java
-- Entity: MesWmStockTakingPlanParamDO extends BaseDO
-- 推断字段类型：id bigint, plan_id bigint, type int, value_id bigint, value_code varchar(255), value_name varchar(255), remark text
CREATE TABLE `mes_wm_stock_taking_plan_param` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `plan_id` bigint NULL COMMENT '盘点方案编号 关联 MesWmStockTakingPlanDO#getId()',
  `type` int NULL COMMENT '参数值类型 字典 DictTypeConstants#MES_WM_STOCK_TAKING_PLAN_PARAM_TYPE 枚举 MesWmStockTakingPlanParamTypeEnum',
  `value_id` bigint NULL COMMENT '参数值编号，例如仓库、库区、库位、物料、批次的主键 ID',
  `value_code` varchar(255) NULL COMMENT '参数值编码，例如仓库编码、库区编码、库位编码、物料编码、批次编码',
  `value_name` varchar(255) NULL COMMENT '参数值名称，例如仓库名称、库区名称、库位名称、物料名称、批次名称',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 盘点方案参数 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/stocktaking/task/MesWmStockTakingTaskDO.java
-- Entity: MesWmStockTakingTaskDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), taking_date datetime, type int, user_id bigint, plan_id bigint, blind_flag bit(1), frozen bit(1), start_time datetime, end_time datetime, status int, remark text
CREATE TABLE `mes_wm_stock_taking_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '任务编码',
  `name` varchar(255) NULL COMMENT '任务名称',
  `taking_date` datetime NULL COMMENT '盘点日期',
  `type` int NULL COMMENT '盘点类型 字典 DictTypeConstants#MES_WM_STOCK_TAKING_TYPE 枚举 MesWmStockTakingTypeEnum',
  `user_id` bigint NULL COMMENT '盘点人编号 关联 AdminUserDO 的 id 字段',
  `plan_id` bigint NULL COMMENT '盘点计划编号 关联 MesWmStockTakingPlanDO#getId()',
  `blind_flag` bit(1) NULL COMMENT '是否盲盘',
  `frozen` bit(1) NULL COMMENT '是否冻结库存',
  `start_time` datetime NULL COMMENT '开始时间',
  `end_time` datetime NULL COMMENT '结束时间',
  `status` int NULL COMMENT '任务状态 字典 DictTypeConstants#MES_WM_STOCK_TAKING_TASK_STATUS 枚举 MesWmStockTakingTaskStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 盘点任务 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/stocktaking/task/MesWmStockTakingTaskLineDO.java
-- Entity: MesWmStockTakingTaskLineDO extends BaseDO
-- 推断字段类型：id bigint, task_id bigint, material_stock_id bigint, item_id bigint, batch_id bigint, batch_code varchar(255), quantity decimal(24,6), taking_quantity decimal(24,6), warehouse_id bigint, location_id bigint, area_id bigint, status int, remark text
CREATE TABLE `mes_wm_stock_taking_task_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `task_id` bigint NULL COMMENT '盘点任务编号 关联 MesWmStockTakingTaskDO#getId()',
  `material_stock_id` bigint NULL COMMENT '库存编号',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `batch_id` bigint NULL COMMENT '批次编号',
  `batch_code` varchar(255) NULL COMMENT '批次编码',
  `quantity` decimal(24,6) NULL COMMENT '在库数量',
  `taking_quantity` decimal(24,6) NULL COMMENT '盘点数量',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库位编号 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库区编号 关联 MesWmWarehouseAreaDO#getId() ()}',
  `status` int NULL COMMENT '盘点状态 字典 DictTypeConstants#MES_WM_STOCK_TAKING_TASK_LINE_STATUS 枚举 MesWmStockTakingTaskLineStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 盘点任务行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/stocktaking/task/MesWmStockTakingTaskResultDO.java
-- Entity: MesWmStockTakingTaskResultDO extends BaseDO
-- 推断字段类型：id bigint, task_id bigint, line_id bigint, material_stock_id bigint, item_id bigint, batch_id bigint, batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, quantity decimal(24,6), taking_quantity decimal(24,6), remark text
CREATE TABLE `mes_wm_stock_taking_task_result` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `task_id` bigint NULL COMMENT '盘点任务编号 关联 MesWmStockTakingTaskDO#getId()',
  `line_id` bigint NULL COMMENT '盘点任务行编号 关联 MesWmStockTakingTaskLineDO#getId()',
  `material_stock_id` bigint NULL COMMENT '库存编号',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `batch_id` bigint NULL COMMENT '批次编号',
  `batch_code` varchar(255) NULL COMMENT '批次编码',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库位编号 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库区编号 关联 MesWmWarehouseAreaDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '在库数量',
  `taking_quantity` decimal(24,6) NULL COMMENT '盘点数量',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 盘点结果 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/transaction/MesWmTransactionDO.java
-- Entity: MesWmTransactionDO extends BaseDO
-- 推断字段类型：id bigint, type int, biz_type int, biz_id bigint, biz_code varchar(255), biz_line_id bigint, material_stock_id bigint, related_transaction_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, batch_code varchar(255), warehouse_id bigint, location_id bigint, area_id bigint, transaction_time datetime, erp_time datetime, receipt_time datetime
CREATE TABLE `mes_wm_transaction` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `type` int NULL COMMENT '事务类型 字典 DictTypeConstants#MES_WM_TRANSACTION_TYPE 枚举 MesWmTransactionTypeEnum',
  `biz_type` int NULL COMMENT '业务类型 对应 MesBizTypeConstants 中的常量',
  `biz_id` bigint NULL COMMENT '来源业务主单 ID',
  `biz_code` varchar(255) NULL COMMENT '来源业务单号',
  `biz_line_id` bigint NULL COMMENT '来源业务行 ID',
  `material_stock_id` bigint NULL COMMENT '库存记录 ID 关联 MesWmMaterialStockDO#getId()',
  `related_transaction_id` bigint NULL COMMENT '关联的事务 ID 关联 #getId()，用于调拨等成对流水关联',
  `item_id` bigint NULL COMMENT '物料 ID 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '本次变动数量 正数=入库，负数=出库',
  `batch_id` bigint NULL COMMENT '批次 ID 关联 MesWmBatchDO#getId()',
  `batch_code` varchar(255) NULL COMMENT '批次号 关联 MesWmBatchDO#getCode()',
  `warehouse_id` bigint NULL COMMENT '仓库 ID 关联 MesWmWarehouseDO#getId()',
  `location_id` bigint NULL COMMENT '库区 ID 关联 MesWmWarehouseLocationDO#getId()',
  `area_id` bigint NULL COMMENT '库位 ID 关联 MesWmWarehouseAreaDO#getId()',
  `transaction_time` datetime NULL COMMENT '事务发生时间',
  `erp_time` datetime NULL COMMENT 'ERP 账期',
  `receipt_time` datetime NULL COMMENT '入库时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 库存事务流水 DO 记录每一笔库存增减事件，系统自动生成，只读查询，不允许人工维护。';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/transfer/MesWmTransferDO.java
-- Entity: MesWmTransferDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), type int, delivery_flag bit(1), recipient_name varchar(255), recipient_telephone varchar(255), destination_address varchar(255), carrier varchar(255), shipping_number varchar(255), confirm_flag bit(1), transfer_date datetime, status int, remark text
CREATE TABLE `mes_wm_transfer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '转移单编号',
  `name` varchar(255) NULL COMMENT '转移单名称',
  `type` int NULL COMMENT '转移单类型 字典 DictTypeConstants#MES_WM_TRANSFER_TYPE 枚举 MesWmTransferTypeEnum',
  `delivery_flag` bit(1) NULL COMMENT '是否配送',
  `recipient_name` varchar(255) NULL COMMENT '收货人',
  `recipient_telephone` varchar(255) NULL COMMENT '联系方式',
  `destination_address` varchar(255) NULL COMMENT '目的地',
  `carrier` varchar(255) NULL COMMENT '承运商',
  `shipping_number` varchar(255) NULL COMMENT '运输单号',
  `confirm_flag` bit(1) NULL COMMENT '是否已确认',
  `transfer_date` datetime NULL COMMENT '转移日期',
  `status` int NULL COMMENT '状态 字典 DictTypeConstants#MES_WM_TRANSFER_STATUS 枚举 MesWmTransferStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 转移单 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/transfer/MesWmTransferDetailDO.java
-- Entity: MesWmTransferDetailDO extends BaseDO
-- 推断字段类型：id bigint, line_id bigint, transfer_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, to_warehouse_id bigint, to_location_id bigint, to_area_id bigint, remark text
CREATE TABLE `mes_wm_transfer_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `line_id` bigint NULL COMMENT '转移单行编号 关联 MesWmTransferLineDO#getId()',
  `transfer_id` bigint NULL COMMENT '转移单编号 关联 MesWmTransferDO#getId()',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '上架数量',
  `batch_id` bigint NULL COMMENT '批次编号',
  `to_warehouse_id` bigint NULL COMMENT '移入仓库编号 关联 MesWmWarehouseDO#getId()',
  `to_location_id` bigint NULL COMMENT '移入库区编号 关联 MesWmWarehouseLocationDO#getId()',
  `to_area_id` bigint NULL COMMENT '移入库位编号 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 调拨明细 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/transfer/MesWmTransferLineDO.java
-- Entity: MesWmTransferLineDO extends BaseDO
-- 推断字段类型：id bigint, transfer_id bigint, material_stock_id bigint, item_id bigint, quantity decimal(24,6), batch_id bigint, from_warehouse_id bigint, from_location_id bigint, from_area_id bigint, remark text
CREATE TABLE `mes_wm_transfer_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `transfer_id` bigint NULL COMMENT '转移单编号 关联 MesWmTransferDO#getId()',
  `material_stock_id` bigint NULL COMMENT '库存记录编号',
  `item_id` bigint NULL COMMENT '物料编号 关联 MesMdItemDO#getId()',
  `quantity` decimal(24,6) NULL COMMENT '转移数量',
  `batch_id` bigint NULL COMMENT '批次编号',
  `from_warehouse_id` bigint NULL COMMENT '移出仓库编号 关联 MesWmWarehouseDO#getId()',
  `from_location_id` bigint NULL COMMENT '移出库区编号 关联 MesWmWarehouseLocationDO#getId()',
  `from_area_id` bigint NULL COMMENT '移出库位编号 关联 MesWmWarehouseAreaDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 转移单行 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/warehouse/MesWmWarehouseAreaDO.java
-- Entity: MesWmWarehouseAreaDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), location_id bigint, area decimal(24,6), max_load decimal(24,6), position_x int, position_y int, position_z int, status int, frozen bit(1), allow_item_mixing bit(1), allow_batch_mixing bit(1), remark text
CREATE TABLE `mes_wm_warehouse_area` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '库位编码',
  `name` varchar(255) NULL COMMENT '库位名称',
  `location_id` bigint NULL COMMENT '库区编号 关联 MesWmWarehouseLocationDO#getId()',
  `area` decimal(24,6) NULL COMMENT '面积',
  `max_load` decimal(24,6) NULL COMMENT '最大载重',
  `position_x` int NULL COMMENT '位置 X',
  `position_y` int NULL COMMENT '位置 Y',
  `position_z` int NULL COMMENT '位置 Z',
  `status` int NULL COMMENT '状态 枚举 cn.iocoder.yudao.framework.common.enums.CommonStatusEnum',
  `frozen` bit(1) NULL COMMENT '是否冻结',
  `allow_item_mixing` bit(1) NULL COMMENT '是否允许物料混放',
  `allow_batch_mixing` bit(1) NULL COMMENT '是否允许批次混放',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 库位 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/warehouse/MesWmWarehouseDO.java
-- Entity: MesWmWarehouseDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), address varchar(255), area decimal(24,6), charge_user_id bigint, frozen bit(1), remark text
CREATE TABLE `mes_wm_warehouse` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '仓库编码',
  `name` varchar(255) NULL COMMENT '仓库名称',
  `address` varchar(255) NULL COMMENT '仓库地址',
  `area` decimal(24,6) NULL COMMENT '面积',
  `charge_user_id` bigint NULL COMMENT '负责人用户编号 关联 system_users 表的 id 字段',
  `frozen` bit(1) NULL COMMENT '是否冻结',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 仓库 DO';

-- Source: yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/warehouse/MesWmWarehouseLocationDO.java
-- Entity: MesWmWarehouseLocationDO extends BaseDO
-- 推断字段类型：id bigint, code varchar(255), name varchar(255), warehouse_id bigint, area decimal(24,6), frozen bit(1), remark text
CREATE TABLE `mes_wm_warehouse_location` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `code` varchar(255) NULL COMMENT '库区编码',
  `name` varchar(255) NULL COMMENT '库区名称',
  `warehouse_id` bigint NULL COMMENT '仓库编号 关联 MesWmWarehouseDO#getId()',
  `area` decimal(24,6) NULL COMMENT '面积',
  `frozen` bit(1) NULL COMMENT '是否冻结',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MES 库区 DO';
