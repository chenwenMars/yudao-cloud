-- HRM 模块：根据当前 MyBatis Plus 实体反推的 MySQL 8 建表 DDL。
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

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/attendance/config/HrmAttendanceGroupDO.java
-- Entity: HrmAttendanceGroupDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), dept_ids text, employee_ids text, open_wifi_card bit(1), open_point_card bit(1), shifts json, rest bit(1), special_dates json, points json, wifis json, deduct_rule json, default_status bit(1)
CREATE TABLE `hrm_attendance_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '考勤组编号',
  `name` varchar(255) NULL COMMENT '考勤组名称',
  `dept_ids` text NULL COMMENT '适用部门编号 关联 DeptRespDTO#getId()',
  `employee_ids` text NULL COMMENT '适用员工编号 关联 HrmEmployeeDO#getId()',
  `open_wifi_card` bit(1) NULL COMMENT '是否启用 WiFi 打卡',
  `open_point_card` bit(1) NULL COMMENT '是否启用定位打卡',
  `shifts` json NULL COMMENT '班次配置',
  `rest` bit(1) NULL COMMENT '是否法定节假日休息',
  `special_dates` json NULL COMMENT '特殊日期设置数组',
  `points` json NULL COMMENT '打卡地点配置',
  `wifis` json NULL COMMENT 'WiFi 打卡配置',
  `deduct_rule` json NULL COMMENT '扣款规则',
  `default_status` bit(1) NULL COMMENT '是否默认考勤组',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 考勤组 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/attendance/config/HrmAttendanceHolidayDO.java
-- Entity: HrmAttendanceHolidayDO extends BaseDO
-- 推断字段类型：id bigint, date datetime, type int
CREATE TABLE `hrm_attendance_holiday` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '节假日编号',
  `date` datetime NULL COMMENT '日期',
  `type` int NULL COMMENT '日期类型 枚举 HrmAttendanceHolidayTypeEnum 字典 DictTypeConstants#HRM_ATTENDANCE_HOLIDAY_TYPE',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 考勤节假日 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/attendance/record/HrmAttendanceClockDO.java
-- Entity: HrmAttendanceClockDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, clock_time datetime, type int, attendance_time datetime, source_type int, status int, stage int, address varchar(255), longitude decimal(24,6), latitude decimal(24,6), ssid varchar(255), mac varchar(255), remark text
CREATE TABLE `hrm_attendance_clock` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '打卡记录编号',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `clock_time` datetime NULL COMMENT '打卡时间',
  `type` int NULL COMMENT '打卡类型 枚举 HrmAttendanceClockTypeEnum 字典 DictTypeConstants#HRM_ATTENDANCE_CLOCK_TYPE',
  `attendance_time` datetime NULL COMMENT '应打卡时间',
  `source_type` int NULL COMMENT '打卡来源 枚举 HrmAttendanceClockSourceEnum 字典 DictTypeConstants#HRM_ATTENDANCE_CLOCK_SOURCE',
  `status` int NULL COMMENT '打卡状态 枚举 HrmAttendanceClockStatusEnum 字典 DictTypeConstants#HRM_ATTENDANCE_CLOCK_STATUS',
  `stage` int NULL COMMENT '打卡阶段 枚举 HrmAttendanceClockStageEnum',
  `address` varchar(255) NULL COMMENT '打卡地址',
  `longitude` decimal(24,6) NULL COMMENT '经度',
  `latitude` decimal(24,6) NULL COMMENT '纬度',
  `ssid` varchar(255) NULL COMMENT 'WiFi 名称',
  `mac` varchar(255) NULL COMMENT 'WiFi MAC 地址',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 考勤打卡记录 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/attendance/record/HrmAttendanceLeaveDO.java
-- Entity: HrmAttendanceLeaveDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, type varchar(255), start_time datetime, end_time datetime, day decimal(10,2), reason text, remark text, approval_status int, process_instance_id varchar(255), approval_time datetime, approval_reason text
-- 特殊类型依据：hrm_attendance_leave.day yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/attendance/vo/leave/HrmAttendanceLeaveCreateReqVO.java:37 @Digits(integer=8, fraction=2)；按入口上限选择容量，原始物理精度仍为推断
-- 特殊类型依据：hrm_attendance_leave.approval_reason yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/attendance/record/HrmAttendanceLeaveDO.java:91 审批或取消原因；按自由填写的意见/原因/备注选择 TEXT，容量为业务推断
CREATE TABLE `hrm_attendance_leave` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '请假记录编号',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `type` varchar(255) NULL COMMENT '请假类型 字典 DictTypeConstants#HRM_ATTENDANCE_LEAVE_TYPE',
  `start_time` datetime NULL COMMENT '请假开始时间',
  `end_time` datetime NULL COMMENT '请假结束时间',
  `day` decimal(10,2) NULL COMMENT '请假时长',
  `reason` text NULL COMMENT '请假理由',
  `remark` text NULL COMMENT '备注',
  `approval_status` int NULL COMMENT '审批状态 枚举 BpmProcessInstanceStatusEnum',
  `process_instance_id` varchar(255) NULL COMMENT 'BPM 流程实例编号 关联 ProcessInstance 的 id 属性',
  `approval_time` datetime NULL COMMENT '审批完成时间',
  `approval_reason` text NULL COMMENT '审批或取消原因',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 考勤请假 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/config/HrmConfigDO.java
-- Entity: HrmConfigDO extends BaseDO
-- 推断字段类型：id bigint, type int, value varchar(255), sort int
CREATE TABLE `hrm_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `type` int NULL COMMENT '配置类型 枚举 HrmConfigTypeEnum',
  `value` varchar(255) NULL COMMENT '配置值',
  `sort` int NULL COMMENT '显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 通用业务配置 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/employment/HrmEmployeeChangeRecordDO.java
-- Entity: HrmEmployeeChangeRecordDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, type int, reason int, old_dept_id bigint, new_dept_id bigint, old_post_name varchar(255), new_post_name varchar(255), old_post_level varchar(255), new_post_level varchar(255), old_work_address varchar(255), new_work_address varchar(255), old_leader_employee_id bigint, new_leader_employee_id bigint, probation int, effect_time datetime, applied_time datetime, remark text
CREATE TABLE `hrm_employee_change_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '异动记录编号',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `type` int NULL COMMENT '异动类型 枚举 HrmEmployeeChangeTypeEnum',
  `reason` int NULL COMMENT '异动原因 枚举 HrmEmployeeChangeReasonEnum',
  `old_dept_id` bigint NULL COMMENT '原部门编号 关联 DeptRespDTO#getId()',
  `new_dept_id` bigint NULL COMMENT '新部门编号 关联 DeptRespDTO#getId()',
  `old_post_name` varchar(255) NULL COMMENT '原岗位',
  `new_post_name` varchar(255) NULL COMMENT '新岗位',
  `old_post_level` varchar(255) NULL COMMENT '原职级',
  `new_post_level` varchar(255) NULL COMMENT '新职级',
  `old_work_address` varchar(255) NULL COMMENT '原工作地点',
  `new_work_address` varchar(255) NULL COMMENT '新工作地点',
  `old_leader_employee_id` bigint NULL COMMENT '原直属上级员工编号 关联 HrmEmployeeDO#getId()',
  `new_leader_employee_id` bigint NULL COMMENT '新直属上级员工编号 关联 HrmEmployeeDO#getId()',
  `probation` int NULL COMMENT '试用期，单位：月',
  `effect_time` datetime NULL COMMENT '生效日期',
  `applied_time` datetime NULL COMMENT '实际生效时间',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工异动记录 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/employment/HrmEmployeeContractDO.java
-- Entity: HrmEmployeeContractDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, no varchar(255), type int, start_time datetime, end_time datetime, term int, status int, sign_company varchar(255), sign_time datetime, remark text, expire_remind bit(1), sort int, file_urls text
CREATE TABLE `hrm_employee_contract` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '合同编号',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `no` varchar(255) NULL COMMENT '合同编号',
  `type` int NULL COMMENT '合同类型 枚举 HrmEmployeeContractTypeEnum',
  `start_time` datetime NULL COMMENT '合同开始日期',
  `end_time` datetime NULL COMMENT '合同结束日期',
  `term` int NULL COMMENT '合同期限，单位：年',
  `status` int NULL COMMENT '合同状态 枚举 HrmEmployeeContractStatusEnum',
  `sign_company` varchar(255) NULL COMMENT '签约公司',
  `sign_time` datetime NULL COMMENT '合同签订日期',
  `remark` text NULL COMMENT '备注',
  `expire_remind` bit(1) NULL COMMENT '是否到期提醒',
  `sort` int NULL COMMENT '显示顺序',
  `file_urls` text NULL COMMENT '附件地址数组',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工合同 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/employment/HrmEmployeeQuitInfoDO.java
-- Entity: HrmEmployeeQuitInfoDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, plan_quit_time datetime, apply_quit_time datetime, salary_settlement_time datetime, type int, reason int, remark text, old_employee_status int
CREATE TABLE `hrm_employee_quit_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '离职信息编号',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `plan_quit_time` datetime NULL COMMENT '计划离职时间',
  `apply_quit_time` datetime NULL COMMENT '申请离职时间',
  `salary_settlement_time` datetime NULL COMMENT '薪资结算时间',
  `type` int NULL COMMENT '离职类型 枚举 HrmEmployeeQuitTypeEnum',
  `reason` int NULL COMMENT '离职原因 枚举 HrmEmployeeQuitReasonEnum',
  `remark` text NULL COMMENT '备注',
  `old_employee_status` int NULL COMMENT '离职前员工状态 枚举 HrmEmployeeStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工离职信息 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/employment/HrmEmployeeSalaryCardDO.java
-- Entity: HrmEmployeeSalaryCardDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, bank_card_number varchar(255), bank_area_id int, bank_name varchar(255), bank_branch_name varchar(255)
CREATE TABLE `hrm_employee_salary_card` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号（注释推断，实体未声明）',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `bank_card_number` varchar(255) NULL COMMENT '银行卡号',
  `bank_area_id` int NULL COMMENT '开户地区编号 关联 Area#getId()',
  `bank_name` varchar(255) NULL COMMENT '银行名称',
  `bank_branch_name` varchar(255) NULL COMMENT '开户支行名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工工资卡 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/experience/HrmEmployeeCertificateDO.java
-- Entity: HrmEmployeeCertificateDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, name varchar(255), level varchar(255), no varchar(255), start_time datetime, end_time datetime, issuing_authority varchar(255), issuing_time datetime, remark text, sort int
CREATE TABLE `hrm_employee_certificate` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '证书编号',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `name` varchar(255) NULL COMMENT '证书名称',
  `level` varchar(255) NULL COMMENT '证书级别',
  `no` varchar(255) NULL COMMENT '证书编号',
  `start_time` datetime NULL COMMENT '有效开始日期',
  `end_time` datetime NULL COMMENT '有效结束日期',
  `issuing_authority` varchar(255) NULL COMMENT '发证机构',
  `issuing_time` datetime NULL COMMENT '发证日期',
  `remark` text NULL COMMENT '备注',
  `sort` int NULL COMMENT '显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工证书 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/experience/HrmEmployeeEducationExperienceDO.java
-- Entity: HrmEmployeeEducationExperienceDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, education int, graduate_school varchar(255), major varchar(255), admission_time datetime, graduation_time datetime, teaching_methods int, first_degree bit(1), sort int
CREATE TABLE `hrm_employee_education_experience` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '教育经历编号',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `education` int NULL COMMENT '学历 枚举 HrmEmployeeEducationEnum 字典 DictTypeConstants#HRM_EMPLOYEE_EDUCATION',
  `graduate_school` varchar(255) NULL COMMENT '毕业院校',
  `major` varchar(255) NULL COMMENT '专业',
  `admission_time` datetime NULL COMMENT '入学日期',
  `graduation_time` datetime NULL COMMENT '毕业日期',
  `teaching_methods` int NULL COMMENT '教学方式 枚举 HrmEmployeeTeachingMethodEnum',
  `first_degree` bit(1) NULL COMMENT '是否第一学历',
  `sort` int NULL COMMENT '显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工教育经历 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/experience/HrmEmployeeTrainingExperienceDO.java
-- Entity: HrmEmployeeTrainingExperienceDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, course varchar(255), organization_name varchar(255), start_time datetime, end_time datetime, duration varchar(255), result text, certificate_name varchar(255), remark text, sort int
CREATE TABLE `hrm_employee_training_experience` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '培训经历编号',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `course` varchar(255) NULL COMMENT '培训课程',
  `organization_name` varchar(255) NULL COMMENT '培训机构名称',
  `start_time` datetime NULL COMMENT '培训开始日期',
  `end_time` datetime NULL COMMENT '培训结束日期',
  `duration` varchar(255) NULL COMMENT '培训时长',
  `result` text NULL COMMENT '培训成绩',
  `certificate_name` varchar(255) NULL COMMENT '培训证书名称',
  `remark` text NULL COMMENT '备注',
  `sort` int NULL COMMENT '显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工培训经历 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/experience/HrmEmployeeWorkExperienceDO.java
-- Entity: HrmEmployeeWorkExperienceDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, work_unit varchar(255), post_name varchar(255), start_time datetime, end_time datetime, reason text, witness_name varchar(255), witness_phone varchar(255), remark text, sort int
CREATE TABLE `hrm_employee_work_experience` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '工作经历编号',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `work_unit` varchar(255) NULL COMMENT '工作单位',
  `post_name` varchar(255) NULL COMMENT '职务',
  `start_time` datetime NULL COMMENT '工作开始日期',
  `end_time` datetime NULL COMMENT '工作结束日期',
  `reason` text NULL COMMENT '离职原因',
  `witness_name` varchar(255) NULL COMMENT '证明人',
  `witness_phone` varchar(255) NULL COMMENT '证明人手机号',
  `remark` text NULL COMMENT '工作备注',
  `sort` int NULL COMMENT '显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工工作经历 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/info/HrmEmployeeContactDO.java
-- Entity: HrmEmployeeContactDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, name varchar(255), relation varchar(255), phone varchar(255), work_unit varchar(255), post_name varchar(255), address varchar(255), sort int
CREATE TABLE `hrm_employee_contact` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '联系人编号',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `name` varchar(255) NULL COMMENT '联系人名称',
  `relation` varchar(255) NULL COMMENT '与员工的关系',
  `phone` varchar(255) NULL COMMENT '联系人电话',
  `work_unit` varchar(255) NULL COMMENT '联系人工作单位',
  `post_name` varchar(255) NULL COMMENT '联系人职务',
  `address` varchar(255) NULL COMMENT '联系人地址',
  `sort` int NULL COMMENT '显示顺序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工联系人 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/info/HrmEmployeeDO.java
-- Entity: HrmEmployeeDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), job_number varchar(255), user_id bigint, mobile varchar(255), country varchar(255), nation varchar(255), id_type int, id_number varchar(255), sex int, email varchar(255), native_place varchar(255), birthday datetime, age int, address varchar(255), highest_education int, dept_id bigint, leader_employee_id bigint, entry_status int, status int, type int, entry_time datetime, probation int, regular_time datetime, leave_time datetime, post_name varchar(255), post_level varchar(255), work_city varchar(255), work_address varchar(255), work_detail_address varchar(255), channel_id bigint, company_age_start_time datetime, company_age int, candidate_id bigint, remark text
CREATE TABLE `hrm_employee` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '员工编号',
  `name` varchar(255) NULL COMMENT '员工姓名',
  `job_number` varchar(255) NULL COMMENT '工号',
  `user_id` bigint NULL COMMENT '后台用户编号 关联 AdminUserRespDTO#getId() 允许为空，用于待入职、离职历史等没有登录账号的员工档案',
  `mobile` varchar(255) NULL COMMENT '手机号码',
  `country` varchar(255) NULL COMMENT '国家或地区',
  `nation` varchar(255) NULL COMMENT '民族',
  `id_type` int NULL COMMENT '证件类型 枚举 HrmEmployeeIdTypeEnum',
  `id_number` varchar(255) NULL COMMENT '证件号码',
  `sex` int NULL COMMENT '性别 枚举 SexEnum',
  `email` varchar(255) NULL COMMENT '邮箱',
  `native_place` varchar(255) NULL COMMENT '籍贯',
  `birthday` datetime NULL COMMENT '出生时间',
  `age` int NULL COMMENT '年龄',
  `address` varchar(255) NULL COMMENT '户籍地址',
  `highest_education` int NULL COMMENT '最高学历 枚举 HrmEmployeeEducationEnum 字典 DictTypeConstants#HRM_EMPLOYEE_EDUCATION',
  `dept_id` bigint NULL COMMENT '部门编号 关联 DeptRespDTO#getId()',
  `leader_employee_id` bigint NULL COMMENT '直属上级员工编号 关联 #id',
  `entry_status` int NULL COMMENT '入职状态 枚举 HrmEmployeeEntryStatusEnum 字典 DictTypeConstants#HRM_EMPLOYEE_ENTRY_STATUS',
  `status` int NULL COMMENT '员工状态 枚举 HrmEmployeeStatusEnum 字典 DictTypeConstants#HRM_EMPLOYEE_STATUS',
  `type` int NULL COMMENT '聘用形式 枚举 HrmEmployeeTypeEnum 字典 DictTypeConstants#HRM_EMPLOYEE_TYPE',
  `entry_time` datetime NULL COMMENT '入职时间',
  `probation` int NULL COMMENT '试用期，单位：月 0 表示无试用期',
  `regular_time` datetime NULL COMMENT '转正时间',
  `leave_time` datetime NULL COMMENT '离职时间',
  `post_name` varchar(255) NULL COMMENT '职位名称',
  `post_level` varchar(255) NULL COMMENT '岗位职级',
  `work_city` varchar(255) NULL COMMENT '工作城市',
  `work_address` varchar(255) NULL COMMENT '工作地址',
  `work_detail_address` varchar(255) NULL COMMENT '工作详细地址',
  `channel_id` bigint NULL COMMENT '招聘渠道编号 关联 HrmRecruitChannelDO#getId()',
  `company_age_start_time` datetime NULL COMMENT '司龄开始时间',
  `company_age` int NULL COMMENT '司龄，单位：年',
  `candidate_id` bigint NULL COMMENT '招聘候选人编号 关联 HrmRecruitCandidateDO#getId()',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工档案 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/info/HrmEmployeeFileDO.java
-- Entity: HrmEmployeeFileDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, type int, url varchar(1024)
CREATE TABLE `hrm_employee_file` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '附件编号',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `type` int NULL COMMENT '附件类型 枚举 HrmEmployeeFileTypeEnum',
  `url` varchar(1024) NULL COMMENT '附件地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工材料附件 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/info/HrmEmployeePersonalNoteDO.java
-- Entity: HrmEmployeePersonalNoteDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, content text, reminder_time datetime
CREATE TABLE `hrm_employee_personal_note` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号（注释推断，实体未声明）',
  `employee_id` bigint NULL COMMENT '所属员工编号 关联 HrmEmployeeDO#getId()',
  `content` text NULL COMMENT '备忘内容',
  `reminder_time` datetime NULL COMMENT '提醒时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工个人备忘 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/insurance/config/HrmInsuranceSchemeDO.java
-- Entity: HrmInsuranceSchemeDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), area_id int, household_type varchar(255), type int
CREATE TABLE `hrm_insurance_scheme` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '方案名称',
  `area_id` int NULL COMMENT '参保地区编号',
  `household_type` varchar(255) NULL COMMENT '户籍类型',
  `type` int NULL COMMENT '方案类型 枚举 HrmInsuranceSchemeTypeEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 社保方案 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/insurance/config/HrmInsuranceSchemeProjectDO.java
-- Entity: HrmInsuranceSchemeProjectDO extends BaseDO
-- 推断字段类型：id bigint, scheme_id bigint, type int, name varchar(255), base_amount decimal(12,2), corporate_rate decimal(5,2), personal_rate decimal(5,2), corporate_amount decimal(12,2), personal_amount decimal(12,2)
-- 特殊类型依据：hrm_insurance_scheme_project.base_amount yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/insurance/vo/scheme/HrmInsuranceSchemeProjectSaveReqVO.java:36 @Digits(integer=10, fraction=2)；按入口上限选择容量，原始物理精度仍为推断
-- 特殊类型依据：hrm_insurance_scheme_project.corporate_rate yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/insurance/vo/scheme/HrmInsuranceSchemeProjectSaveReqVO.java:42 @Digits(integer=3, fraction=2)；按入口上限选择容量，原始物理精度仍为推断
-- 特殊类型依据：hrm_insurance_scheme_project.personal_rate yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/insurance/vo/scheme/HrmInsuranceSchemeProjectSaveReqVO.java:48 @Digits(integer=3, fraction=2)；按入口上限选择容量，原始物理精度仍为推断
-- 特殊类型依据：hrm_insurance_scheme_project.corporate_amount yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/insurance/vo/scheme/HrmInsuranceSchemeProjectSaveReqVO.java:53 @Digits(integer=10, fraction=2)；按入口上限选择容量，原始物理精度仍为推断
-- 特殊类型依据：hrm_insurance_scheme_project.personal_amount yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/insurance/vo/scheme/HrmInsuranceSchemeProjectSaveReqVO.java:58 @Digits(integer=10, fraction=2)；按入口上限选择容量，原始物理精度仍为推断
CREATE TABLE `hrm_insurance_scheme_project` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `scheme_id` bigint NULL COMMENT '社保方案编号 关联 HrmInsuranceSchemeDO#getId()',
  `type` int NULL COMMENT '项目类型 枚举 HrmInsuranceProjectTypeEnum',
  `name` varchar(255) NULL COMMENT '项目名称',
  `base_amount` decimal(12,2) NULL COMMENT '缴纳基数',
  `corporate_rate` decimal(5,2) NULL COMMENT '公司缴纳比例',
  `personal_rate` decimal(5,2) NULL COMMENT '个人缴纳比例',
  `corporate_amount` decimal(12,2) NULL COMMENT '公司缴纳金额',
  `personal_amount` decimal(12,2) NULL COMMENT '个人缴纳金额',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 社保方案项目 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/insurance/employee/HrmInsuranceEmployeeInfoDO.java
-- Entity: HrmInsuranceEmployeeInfoDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, first_social_security bit(1), first_accumulation_fund bit(1), social_security_number varchar(255), accumulation_fund_number varchar(255), social_security_start_month datetime, scheme_id bigint
CREATE TABLE `hrm_insurance_employee_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号（注释推断，实体未声明）',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `first_social_security` bit(1) NULL COMMENT '是否首次参保',
  `first_accumulation_fund` bit(1) NULL COMMENT '是否首次缴纳公积金',
  `social_security_number` varchar(255) NULL COMMENT '社保账号',
  `accumulation_fund_number` varchar(255) NULL COMMENT '公积金账号',
  `social_security_start_month` datetime NULL COMMENT '社保起缴月份',
  `scheme_id` bigint NULL COMMENT '社保方案编号 关联 HrmInsuranceSchemeDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工参保信息 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/insurance/monthrecord/HrmInsuranceMonthEmployeeRecordDO.java
-- Entity: HrmInsuranceMonthEmployeeRecordDO extends BaseDO
-- 推断字段类型：id bigint, month_record_id bigint, employee_id bigint, scheme_id bigint, year int, month int, personal_insurance_amount decimal(24,6), personal_provident_fund_amount decimal(24,6), corporate_insurance_amount decimal(24,6), corporate_provident_fund_amount decimal(24,6), status int, projects json
CREATE TABLE `hrm_insurance_month_employee_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `month_record_id` bigint NULL COMMENT '月度社保表编号 关联 HrmInsuranceMonthRecordDO#getId()',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `scheme_id` bigint NULL COMMENT '社保方案编号 关联 HrmInsuranceSchemeDO#getId()',
  `year` int NULL COMMENT '年份',
  `month` int NULL COMMENT '月份',
  `personal_insurance_amount` decimal(24,6) NULL COMMENT '个人社保金额',
  `personal_provident_fund_amount` decimal(24,6) NULL COMMENT '个人公积金金额',
  `corporate_insurance_amount` decimal(24,6) NULL COMMENT '公司社保金额',
  `corporate_provident_fund_amount` decimal(24,6) NULL COMMENT '公司公积金金额',
  `status` int NULL COMMENT '参保状态 枚举 HrmInsuranceEmployeeStatusEnum',
  `projects` json NULL COMMENT '参保项目快照',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工月度社保记录 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/insurance/monthrecord/HrmInsuranceMonthRecordDO.java
-- Entity: HrmInsuranceMonthRecordDO extends BaseDO
-- 推断字段类型：id bigint, title varchar(255), year int, month int, insured_employee_count int, stopped_employee_count int, status int, personal_insurance_amount decimal(24,6), personal_provident_fund_amount decimal(24,6), corporate_insurance_amount decimal(24,6), corporate_provident_fund_amount decimal(24,6)
CREATE TABLE `hrm_insurance_month_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `title` varchar(255) NULL COMMENT '标题',
  `year` int NULL COMMENT '年份',
  `month` int NULL COMMENT '月份',
  `insured_employee_count` int NULL COMMENT '参保人数',
  `stopped_employee_count` int NULL COMMENT '停保人数',
  `status` int NULL COMMENT '状态 枚举 HrmInsuranceMonthStatusEnum',
  `personal_insurance_amount` decimal(24,6) NULL COMMENT '个人社保金额',
  `personal_provident_fund_amount` decimal(24,6) NULL COMMENT '个人公积金金额',
  `corporate_insurance_amount` decimal(24,6) NULL COMMENT '公司社保金额',
  `corporate_provident_fund_amount` decimal(24,6) NULL COMMENT '公司公积金金额',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 月度社保表 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentActionRecordDO.java
-- Entity: HrmPerformanceAssessmentActionRecordDO extends BaseDO
-- 推断字段类型：id bigint, assessment_id bigint, stage_id bigint, employee_id bigint, type int, title varchar(255), content text, file_urls json, status int
CREATE TABLE `hrm_performance_assessment_action_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '动作记录编号',
  `assessment_id` bigint NULL COMMENT '员工绩效考核编号 关联 HrmPerformanceAssessmentDO#getId()',
  `stage_id` bigint NULL COMMENT '员工绩效考核阶段编号 关联 HrmPerformanceAssessmentStageDO#getId()',
  `employee_id` bigint NULL COMMENT '操作员工编号 关联 HrmEmployeeDO#getId()',
  `type` int NULL COMMENT '动作类型 枚举 HrmPerformanceAssessmentActionTypeEnum',
  `title` varchar(255) NULL COMMENT '动作标题',
  `content` text NULL COMMENT '动作内容',
  `file_urls` json NULL COMMENT '附件地址列表',
  `status` int NULL COMMENT '动作完成后的阶段状态 枚举 HrmPerformanceAssessmentStageStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工绩效考核动作记录 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentAppealRecordDO.java
-- Entity: HrmPerformanceAssessmentAppealRecordDO extends BaseDO
-- 推断字段类型：id bigint, assessment_id bigint, stage_id bigint, status int
CREATE TABLE `hrm_performance_assessment_appeal_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '申诉记录编号',
  `assessment_id` bigint NULL COMMENT '员工绩效考核编号 关联 HrmPerformanceAssessmentDO#getId()',
  `stage_id` bigint NULL COMMENT '员工绩效考核阶段编号 关联 HrmPerformanceAssessmentStageDO#getId()',
  `status` int NULL COMMENT '处理状态 枚举 HrmPerformanceAppealRecordStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工绩效考核申诉记录 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentDO.java
-- Entity: HrmPerformanceAssessmentDO extends BaseDO
-- 推断字段类型：id bigint, plan_id bigint, employee_id bigint, status int, process_status int, stage_type int, stage_sort int, score decimal(24,6), result_level varchar(255), coefficient decimal(24,6), target_confirmation_result int, target_confirmation_comment text, target_confirmation_time datetime, self_comment text, reviewer_comment text, result_comment text, result_confirmation_time datetime, result_audit_status int, result_audit_time datetime, result_audit_reason text, appeal_reason text, appeal_file_urls text, appeal_submit_time datetime, appeal_status int, appeal_time datetime, appeal_comment text, archive_time datetime
-- 特殊类型依据：hrm_performance_assessment.target_confirmation_comment yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentDO.java:103 目标确认意见；按自由填写的意见/原因/备注选择 TEXT，容量为业务推断
-- 特殊类型依据：hrm_performance_assessment.self_comment yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentDO.java:111 自评说明；按自由填写的意见/原因/备注选择 TEXT，容量为业务推断
-- 特殊类型依据：hrm_performance_assessment.reviewer_comment yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentDO.java:115 他评说明；按自由填写的意见/原因/备注选择 TEXT，容量为业务推断
-- 特殊类型依据：hrm_performance_assessment.result_comment yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentDO.java:119 结果说明；按自由填写的意见/原因/备注选择 TEXT，容量为业务推断
-- 特殊类型依据：hrm_performance_assessment.result_audit_reason yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentDO.java:137 结果审核意见；按自由填写的意见/原因/备注选择 TEXT，容量为业务推断
-- 特殊类型依据：hrm_performance_assessment.appeal_reason yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentDO.java:142 申诉原因；按自由填写的意见/原因/备注选择 TEXT，容量为业务推断
-- 特殊类型依据：hrm_performance_assessment.appeal_comment yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentDO.java:165 申诉处理意见；按自由填写的意见/原因/备注选择 TEXT，容量为业务推断
CREATE TABLE `hrm_performance_assessment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '员工绩效考核编号',
  `plan_id` bigint NULL COMMENT '绩效计划编号 关联 HrmPerformancePlanDO#getId()',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `status` int NULL COMMENT '考核状态 枚举 HrmPerformancePlanStatusEnum',
  `process_status` int NULL COMMENT '流程处理状态 枚举 HrmPerformanceAssessmentProcessStatusEnum',
  `stage_type` int NULL COMMENT '当前业务阶段类型 枚举 HrmPerformanceStageTypeEnum',
  `stage_sort` int NULL COMMENT '当前阶段排序',
  `score` decimal(24,6) NULL COMMENT '综合得分',
  `result_level` varchar(255) NULL COMMENT '结果等级',
  `coefficient` decimal(24,6) NULL COMMENT '绩效系数',
  `target_confirmation_result` int NULL COMMENT '目标确认结果 枚举 HrmPerformanceConfirmationResultEnum',
  `target_confirmation_comment` text NULL COMMENT '目标确认意见',
  `target_confirmation_time` datetime NULL COMMENT '目标确认时间',
  `self_comment` text NULL COMMENT '自评说明',
  `reviewer_comment` text NULL COMMENT '他评说明',
  `result_comment` text NULL COMMENT '结果说明',
  `result_confirmation_time` datetime NULL COMMENT '结果确认时间',
  `result_audit_status` int NULL COMMENT '结果审核状态 枚举 HrmPerformanceResultAuditStatusEnum',
  `result_audit_time` datetime NULL COMMENT '结果审核时间',
  `result_audit_reason` text NULL COMMENT '结果审核意见',
  `appeal_reason` text NULL COMMENT '申诉原因',
  `appeal_file_urls` text NULL COMMENT '申诉附件地址列表',
  `appeal_submit_time` datetime NULL COMMENT '申诉提交时间',
  `appeal_status` int NULL COMMENT '申诉状态 枚举 HrmPerformanceAppealStatusEnum',
  `appeal_time` datetime NULL COMMENT '申诉完成时间',
  `appeal_comment` text NULL COMMENT '申诉处理意见',
  `archive_time` datetime NULL COMMENT '归档时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工绩效考核 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentDimensionDO.java
-- Entity: HrmPerformanceAssessmentDimensionDO extends BaseDO
-- 推断字段类型：id bigint, assessment_id bigint, name varchar(255), quota_type int, weight decimal(24,6), remark text, allow_edit bit(1), sort int
CREATE TABLE `hrm_performance_assessment_dimension` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '考核维度编号',
  `assessment_id` bigint NULL COMMENT '员工绩效考核编号 关联 HrmPerformanceAssessmentDO#getId()',
  `name` varchar(255) NULL COMMENT '维度名称',
  `quota_type` int NULL COMMENT '指标类型 枚举 HrmPerformanceQuotaTypeEnum',
  `weight` decimal(24,6) NULL COMMENT '维度权重',
  `remark` text NULL COMMENT '备注',
  `allow_edit` bit(1) NULL COMMENT '是否允许员工编辑指标',
  `sort` int NULL COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工绩效考核维度 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentQuotaDO.java
-- Entity: HrmPerformanceAssessmentQuotaDO extends BaseDO
-- 推断字段类型：id bigint, assessment_id bigint, dimension_id bigint, preset bit(1), name varchar(255), description text, standard varchar(255), weight decimal(24,6), score_type int, target_value varchar(255), actual_value varchar(255), self_score decimal(24,6), reviewer_score decimal(24,6), final_score decimal(24,6), sort int
CREATE TABLE `hrm_performance_assessment_quota` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '考核指标编号',
  `assessment_id` bigint NULL COMMENT '员工绩效考核编号 关联 HrmPerformanceAssessmentDO#getId()',
  `dimension_id` bigint NULL COMMENT '考核维度编号 关联 HrmPerformanceAssessmentDimensionDO#getId()',
  `preset` bit(1) NULL COMMENT '是否预置指标',
  `name` varchar(255) NULL COMMENT '指标名称',
  `description` text NULL COMMENT '指标说明',
  `standard` varchar(255) NULL COMMENT '评分标准',
  `weight` decimal(24,6) NULL COMMENT '指标权重',
  `score_type` int NULL COMMENT '评分类型 枚举 HrmPerformanceQuotaScoreTypeEnum',
  `target_value` varchar(255) NULL COMMENT '目标值',
  `actual_value` varchar(255) NULL COMMENT '实际值',
  `self_score` decimal(24,6) NULL COMMENT '自评汇总分',
  `reviewer_score` decimal(24,6) NULL COMMENT '他评汇总分',
  `final_score` decimal(24,6) NULL COMMENT '最终指标得分',
  `sort` int NULL COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工绩效考核指标 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentQuotaScoreDO.java
-- Entity: HrmPerformanceAssessmentQuotaScoreDO extends BaseDO
-- 推断字段类型：id bigint, assessment_stage_id bigint, assessment_quota_id bigint, score decimal(24,6), comment text
-- 特殊类型依据：hrm_performance_assessment_quota_score.comment yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentQuotaScoreDO.java:49 指标评语；按自由填写的意见/原因/备注选择 TEXT，容量为业务推断
CREATE TABLE `hrm_performance_assessment_quota_score` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '考核指标评分编号',
  `assessment_stage_id` bigint NULL COMMENT '员工绩效考核阶段编号 关联 HrmPerformanceAssessmentStageDO#getId()',
  `assessment_quota_id` bigint NULL COMMENT '员工绩效考核指标编号 关联 HrmPerformanceAssessmentQuotaDO#getId()',
  `score` decimal(24,6) NULL COMMENT '指标得分',
  `comment` text NULL COMMENT '指标评语',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工绩效考核指标评分 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentStageDO.java
-- Entity: HrmPerformanceAssessmentStageDO extends BaseDO
-- 推断字段类型：id bigint, assessment_id bigint, type int, name varchar(255), handler_employee_id bigint, rater_type int, weight decimal(24,6), scoring_type int, visible_content int, required_setting bit(1), reject_authority bit(1), sort int, status int, score decimal(24,6), result_level varchar(255), comment text, reject_reason text, submit_time datetime, deadline_time datetime
-- 特殊类型依据：hrm_performance_assessment_stage.comment yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentStageDO.java:110 阶段意见；按自由填写的意见/原因/备注选择 TEXT，容量为业务推断
-- 特殊类型依据：hrm_performance_assessment_stage.reject_reason yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentStageDO.java:114 最近一次驳回原因；按自由填写的意见/原因/备注选择 TEXT，容量为业务推断
CREATE TABLE `hrm_performance_assessment_stage` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '考核阶段编号',
  `assessment_id` bigint NULL COMMENT '员工绩效考核编号 关联 HrmPerformanceAssessmentDO#getId()',
  `type` int NULL COMMENT '业务阶段类型 枚举 HrmPerformanceStageTypeEnum',
  `name` varchar(255) NULL COMMENT '阶段名称',
  `handler_employee_id` bigint NULL COMMENT '实际处理员工编号 关联 HrmEmployeeDO#getId()',
  `rater_type` int NULL COMMENT '评分人类型 枚举 HrmPerformanceRaterTypeEnum',
  `weight` decimal(24,6) NULL COMMENT '评分权重快照',
  `scoring_type` int NULL COMMENT '评分方式快照 枚举 HrmPerformanceReviewScoringTypeEnum',
  `visible_content` int NULL COMMENT '评分内容可见范围快照 枚举 HrmPerformanceReviewVisibleContentEnum',
  `required_setting` bit(1) NULL COMMENT '评语是否必填',
  `reject_authority` bit(1) NULL COMMENT '是否允许驳回',
  `sort` int NULL COMMENT '排序',
  `status` int NULL COMMENT '阶段处理状态 枚举 HrmPerformanceAssessmentStageStatusEnum',
  `score` decimal(24,6) NULL COMMENT '阶段汇总得分',
  `result_level` varchar(255) NULL COMMENT '阶段结果等级',
  `comment` text NULL COMMENT '阶段意见',
  `reject_reason` text NULL COMMENT '最近一次驳回原因',
  `submit_time` datetime NULL COMMENT '提交时间',
  `deadline_time` datetime NULL COMMENT '截止时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工绩效考核阶段 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/config/HrmPerformanceAssessmentTemplateDO.java
-- Entity: HrmPerformanceAssessmentTemplateDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), illustrate varchar(255), score_calculation int, upper_limit_type int, upper_limit_score decimal(24,6), dimension_count int, quota_count int, dimensions json, status int
CREATE TABLE `hrm_performance_assessment_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '绩效考核模板编号',
  `name` varchar(255) NULL COMMENT '模板名称',
  `illustrate` varchar(255) NULL COMMENT '模板说明',
  `score_calculation` int NULL COMMENT '计分方式 枚举 HrmPerformanceScoreCalculationEnum',
  `upper_limit_type` int NULL COMMENT '分数上限类型 枚举 HrmPerformanceUpperLimitTypeEnum',
  `upper_limit_score` decimal(24,6) NULL COMMENT '分数上限',
  `dimension_count` int NULL COMMENT '维度数量',
  `quota_count` int NULL COMMENT '指标数量',
  `dimensions` json NULL COMMENT '考核维度配置',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 绩效考核模板 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/config/HrmPerformanceResultTemplateDO.java
-- Entity: HrmPerformanceResultTemplateDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), status int, levels json
CREATE TABLE `hrm_performance_result_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '绩效结果模板编号',
  `name` varchar(255) NULL COMMENT '模板名称',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `levels` json NULL COMMENT '结果等级配置',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 绩效结果模板 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/plan/HrmPerformancePlanDO.java
-- Entity: HrmPerformancePlanDO extends BaseDO
-- 推断字段类型：id bigint, status int, stage_type int, operation_type int, terminate_time datetime, name varchar(255), cycle_type int, cycle varchar(255), quarter int, start_time datetime, end_time datetime, description text, scopes json, assessment_template_id bigint, assessment_config json, quota_setting_type int, target_confirmation bit(1), target_confirmation_stage json, review_stages json, result_audit bit(1), result_audit_stages json, result_confirmation bit(1), appeal_stages json, appeal_timeout_days int, appeal_timeout_action int, result_template_id bigint, result_config json, sync_to_salary bit(1), paid_for_month varchar(255)
CREATE TABLE `hrm_performance_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '计划编号',
  `status` int NULL COMMENT '计划状态 枚举 HrmPerformancePlanStatusEnum',
  `stage_type` int NULL COMMENT '当前业务阶段类型 枚举 HrmPerformanceStageTypeEnum',
  `operation_type` int NULL COMMENT '当前可执行操作类型 枚举 HrmPerformancePlanOperationTypeEnum',
  `terminate_time` datetime NULL COMMENT '终止时间',
  `name` varchar(255) NULL COMMENT '计划名称',
  `cycle_type` int NULL COMMENT '考核周期类型 枚举 HrmPerformanceCycleTypeEnum',
  `cycle` varchar(255) NULL COMMENT '考核周期',
  `quarter` int NULL COMMENT '季度 枚举 HrmPerformanceQuarterEnum',
  `start_time` datetime NULL COMMENT '开始时间',
  `end_time` datetime NULL COMMENT '结束时间',
  `description` text NULL COMMENT '考核说明',
  `scopes` json NULL COMMENT '考评范围列表',
  `assessment_template_id` bigint NULL COMMENT '考核模板编号 关联 HrmPerformanceAssessmentTemplateDO#getId()',
  `assessment_config` json NULL COMMENT '考核配置快照',
  `quota_setting_type` int NULL COMMENT '指标制定类型 枚举 HrmPerformanceQuotaSettingTypeEnum',
  `target_confirmation` bit(1) NULL COMMENT '是否开启目标确认',
  `target_confirmation_stage` json NULL COMMENT '目标确认节点',
  `review_stages` json NULL COMMENT '评分阶段列表',
  `result_audit` bit(1) NULL COMMENT '是否开启结果审核',
  `result_audit_stages` json NULL COMMENT '结果审核节点列表',
  `result_confirmation` bit(1) NULL COMMENT '是否开启结果确认',
  `appeal_stages` json NULL COMMENT '申诉处理节点列表',
  `appeal_timeout_days` int NULL COMMENT '申诉超期天数',
  `appeal_timeout_action` int NULL COMMENT '申诉超期处理动作 枚举 HrmPerformanceAppealTimeoutActionEnum',
  `result_template_id` bigint NULL COMMENT '结果模板编号 关联 HrmPerformanceResultTemplateDO#getId()',
  `result_config` json NULL COMMENT '结果配置快照',
  `sync_to_salary` bit(1) NULL COMMENT '是否同步到薪资',
  `paid_for_month` varchar(255) NULL COMMENT '计薪月份',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 绩效考核计划 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/recruit/candidate/HrmRecruitCandidateDO.java
-- Entity: HrmRecruitCandidateDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), mobile varchar(255), sex int, age int, email varchar(255), post_id bigint, stage_number int, work_time int, education int, graduate_school varchar(255), latest_work_place varchar(255), channel_id bigint, remark text, status int, eliminate varchar(255), status_update_time datetime, entry_time datetime, resume_urls text
CREATE TABLE `hrm_recruit_candidate` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '候选人编号',
  `name` varchar(255) NULL COMMENT '候选人姓名',
  `mobile` varchar(255) NULL COMMENT '手机号码',
  `sex` int NULL COMMENT '性别 枚举 SexEnum',
  `age` int NULL COMMENT '年龄',
  `email` varchar(255) NULL COMMENT '邮箱',
  `post_id` bigint NULL COMMENT '应聘职位编号 关联 HrmRecruitPostDO#getId()',
  `stage_number` int NULL COMMENT '面试轮次',
  `work_time` int NULL COMMENT '工作年限，单位：年',
  `education` int NULL COMMENT '学历 字典 DictTypeConstants#HRM_RECRUIT_CANDIDATE_EDUCATION',
  `graduate_school` varchar(255) NULL COMMENT '毕业院校',
  `latest_work_place` varchar(255) NULL COMMENT '最近工作单位',
  `channel_id` bigint NULL COMMENT '招聘渠道编号 关联 HrmRecruitChannelDO#getId()',
  `remark` text NULL COMMENT '备注',
  `status` int NULL COMMENT '候选人状态 枚举 HrmRecruitCandidateStatusEnum 字典 DictTypeConstants#HRM_RECRUIT_CANDIDATE_STATUS',
  `eliminate` varchar(255) NULL COMMENT '淘汰原因',
  `status_update_time` datetime NULL COMMENT '状态更新时间',
  `entry_time` datetime NULL COMMENT '入职时间',
  `resume_urls` text NULL COMMENT '简历附件地址数组',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 招聘候选人 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/recruit/candidate/HrmRecruitInterviewDO.java
-- Entity: HrmRecruitInterviewDO extends BaseDO
-- 推断字段类型：id bigint, candidate_id bigint, type int, stage_number int, interview_employee_id bigint, other_interview_employee_ids text, interview_time datetime, address varchar(255), remark text, result int, evaluate varchar(255), cancel_reason varchar(255)
CREATE TABLE `hrm_recruit_interview` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '面试编号',
  `candidate_id` bigint NULL COMMENT '候选人编号 关联 HrmRecruitCandidateDO#getId()',
  `type` int NULL COMMENT '面试方式 字典 DictTypeConstants#HRM_RECRUIT_INTERVIEW_TYPE',
  `stage_number` int NULL COMMENT '面试轮次',
  `interview_employee_id` bigint NULL COMMENT '主面试官员工编号 关联 HrmEmployeeDO#getId()',
  `other_interview_employee_ids` text NULL COMMENT '其他面试官员工编号数组 关联 HrmEmployeeDO#getId()',
  `interview_time` datetime NULL COMMENT '面试时间',
  `address` varchar(255) NULL COMMENT '面试地址',
  `remark` text NULL COMMENT '备注',
  `result` int NULL COMMENT '面试结果 枚举 HrmRecruitInterviewResultEnum 字典 DictTypeConstants#HRM_RECRUIT_INTERVIEW_RESULT',
  `evaluate` varchar(255) NULL COMMENT '面试评价',
  `cancel_reason` varchar(255) NULL COMMENT '取消原因',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 招聘面试记录 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/recruit/config/HrmRecruitChannelDO.java
-- Entity: HrmRecruitChannelDO extends BaseDO
-- 推断字段类型：id bigint, system_flag bit(1), status int, name varchar(255), sort int, remark text
CREATE TABLE `hrm_recruit_channel` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '招聘渠道编号',
  `system_flag` bit(1) NULL COMMENT '是否系统内置',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `name` varchar(255) NULL COMMENT '渠道名称',
  `sort` int NULL COMMENT '显示顺序',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 招聘渠道 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/recruit/post/HrmRecruitPostDO.java
-- Entity: HrmRecruitPostDO extends BaseDO
-- 推断字段类型：id bigint, post_name varchar(255), dept_id bigint, job_nature int, area_id int, recruit_num int, reason text, work_time int, education_require int, min_salary decimal(10,2), max_salary decimal(10,2), salary_unit int, min_age int, max_age int, latest_entry_time datetime, owner_employee_id bigint, interview_employee_ids text, description text, emergency_level int, post_type_id bigint, status int, stop_reason varchar(255)
-- 特殊类型依据：hrm_recruit_post.min_salary yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/recruit/vo/post/HrmRecruitPostSaveReqVO.java:70 @Digits(integer=8, fraction=2)；按入口上限选择容量，原始物理精度仍为推断
-- 特殊类型依据：hrm_recruit_post.max_salary yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/recruit/vo/post/HrmRecruitPostSaveReqVO.java:75 @Digits(integer=8, fraction=2)；按入口上限选择容量，原始物理精度仍为推断
CREATE TABLE `hrm_recruit_post` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '招聘职位编号',
  `post_name` varchar(255) NULL COMMENT '职位名称',
  `dept_id` bigint NULL COMMENT '部门编号 关联 DeptRespDTO#getId()',
  `job_nature` int NULL COMMENT '工作性质 字典 DictTypeConstants#HRM_RECRUIT_JOB_NATURE',
  `area_id` int NULL COMMENT '工作城市地区编号 关联 cn.iocoder.yudao.framework.ip.core.Area#getId()',
  `recruit_num` int NULL COMMENT '招聘人数',
  `reason` text NULL COMMENT '招聘原因',
  `work_time` int NULL COMMENT '工作经验要求 字典 DictTypeConstants#HRM_RECRUIT_WORK_TIME',
  `education_require` int NULL COMMENT '学历要求 字典 DictTypeConstants#HRM_RECRUIT_POST_EDUCATION',
  `min_salary` decimal(10,2) NULL COMMENT '最低薪资 -1 表示面议',
  `max_salary` decimal(10,2) NULL COMMENT '最高薪资 -1 表示面议',
  `salary_unit` int NULL COMMENT '薪资单位 字典 DictTypeConstants#HRM_RECRUIT_SALARY_UNIT',
  `min_age` int NULL COMMENT '最小年龄 -1 表示不限',
  `max_age` int NULL COMMENT '最大年龄 -1 表示不限',
  `latest_entry_time` datetime NULL COMMENT '最迟到岗时间',
  `owner_employee_id` bigint NULL COMMENT '招聘负责人员工编号 关联 HrmEmployeeDO#getId()',
  `interview_employee_ids` text NULL COMMENT '面试官员工编号数组 关联 HrmEmployeeDO#getId()',
  `description` text NULL COMMENT '职位描述',
  `emergency_level` int NULL COMMENT '紧急程度 字典 DictTypeConstants#HRM_RECRUIT_EMERGENCY_LEVEL',
  `post_type_id` bigint NULL COMMENT '职位类型编号 关联 HrmRecruitPostTypeDO#getId()',
  `status` int NULL COMMENT '职位状态 枚举 HrmRecruitPostStatusEnum 字典 DictTypeConstants#HRM_RECRUIT_POST_STATUS',
  `stop_reason` varchar(255) NULL COMMENT '停止原因',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 招聘职位 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/recruit/post/HrmRecruitPostTypeDO.java
-- Entity: HrmRecruitPostTypeDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), parent_id bigint, sort int, status int
CREATE TABLE `hrm_recruit_post_type` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '职位类型编号',
  `name` varchar(255) NULL COMMENT '类型名称',
  `parent_id` bigint NULL COMMENT '父类型编号 关联 #id',
  `sort` int NULL COMMENT '显示顺序',
  `status` int NULL COMMENT '状态 枚举 CommonStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 招聘职位类型 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/config/HrmSalaryChangeTemplateDO.java
-- Entity: HrmSalaryChangeTemplateDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), default_status bit(1), options json
CREATE TABLE `hrm_salary_change_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '调薪模板编号',
  `name` varchar(255) NULL COMMENT '模板名称',
  `default_status` bit(1) NULL COMMENT '是否默认模板',
  `options` json NULL COMMENT '调薪项配置',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 调薪模板 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/config/HrmSalaryConfigDO.java
-- Entity: HrmSalaryConfigDO extends BaseDO
-- 推断字段类型：id bigint, cycle_start_day int, cycle_end_day int, social_security_month_type int, start_year int, start_month int
CREATE TABLE `hrm_salary_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号（注释推断，实体未声明）',
  `cycle_start_day` int NULL COMMENT '计薪周期开始日',
  `cycle_end_day` int NULL COMMENT '计薪周期结束日',
  `social_security_month_type` int NULL COMMENT '社保对应月份类型 枚举 HrmSalarySocialSecurityMonthTypeEnum',
  `start_year` int NULL COMMENT '工资开始年份',
  `start_month` int NULL COMMENT '工资开始月份',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 计薪配置 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/config/HrmSalaryGroupDO.java
-- Entity: HrmSalaryGroupDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), salary_standard decimal(24,6), change_rule varchar(255), dept_ids json, employee_ids json, tax_rule_id bigint
CREATE TABLE `hrm_salary_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号（注释推断，实体未声明）',
  `name` varchar(255) NULL COMMENT '薪资组名称',
  `salary_standard` decimal(24,6) NULL COMMENT '月计薪标准',
  `change_rule` varchar(255) NULL COMMENT '转正、调薪月规则',
  `dept_ids` json NULL COMMENT '适用部门编号列表 关联 DeptRespDTO#getId()',
  `employee_ids` json NULL COMMENT '适用员工编号列表 关联 HrmEmployeeDO#getId()',
  `tax_rule_id` bigint NULL COMMENT '计税规则编号 关联 HrmSalaryTaxRuleDO#getId()',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 薪资组 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/config/HrmSalaryOptionDO.java
-- Entity: HrmSalaryOptionDO extends BaseDO
-- 推断字段类型：id bigint, template_id bigint, code int, parent_code int, name varchar(255), remark text, system_flag bit(1), type int, visible bit(1), enabled bit(1), tax_enabled bit(1), calculate_enabled bit(1)
CREATE TABLE `hrm_salary_option` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '薪资项编号',
  `template_id` bigint NULL COMMENT '标准薪资项目录编号（可选） 关联 HrmSalaryOptionTemplateDO#getId()',
  `code` int NULL COMMENT '薪资项编码',
  `parent_code` int NULL COMMENT '父薪资项编码 关联 #code',
  `name` varchar(255) NULL COMMENT '薪资项名称',
  `remark` text NULL COMMENT '备注',
  `system_flag` bit(1) NULL COMMENT '是否系统默认项',
  `type` int NULL COMMENT '薪资项类型 枚举 HrmSalaryOptionTypeEnum',
  `visible` bit(1) NULL COMMENT '是否显示',
  `enabled` bit(1) NULL COMMENT '是否启用',
  `tax_enabled` bit(1) NULL COMMENT '是否计税',
  `calculate_enabled` bit(1) NULL COMMENT '是否参与计算',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 工资表薪资项 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/config/HrmSalaryOptionTemplateDO.java
-- Entity: HrmSalaryOptionTemplateDO extends BaseDO
-- 推断字段类型：id bigint, code int, parent_code int, name varchar(255), remark text, system_flag bit(1), type int, visible bit(1), tax_enabled bit(1), calculate_enabled bit(1)
CREATE TABLE `hrm_salary_option_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '标准薪资项编号',
  `code` int NULL COMMENT '薪资项编码',
  `parent_code` int NULL COMMENT '父薪资项编码 关联 #code',
  `name` varchar(255) NULL COMMENT '薪资项名称',
  `remark` text NULL COMMENT '备注',
  `system_flag` bit(1) NULL COMMENT '是否系统默认项',
  `type` int NULL COMMENT '薪资项类型 枚举 HrmSalaryOptionTypeEnum',
  `visible` bit(1) NULL COMMENT '是否显示',
  `tax_enabled` bit(1) NULL COMMENT '是否计税',
  `calculate_enabled` bit(1) NULL COMMENT '是否参与计算',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 标准薪资项目录 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/config/HrmSalaryTaxRuleDO.java
-- Entity: HrmSalaryTaxRuleDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), type int, tax_enabled bit(1), threshold decimal(12,2), decimal_scale int, cycle_type int
-- 特殊类型依据：hrm_salary_tax_rule.threshold yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/salary/vo/taxrule/HrmSalaryTaxRuleSaveReqVO.java:46 @Digits(integer=10, fraction=2)；按入口上限选择容量，原始物理精度仍为推断
CREATE TABLE `hrm_salary_tax_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键编号（注释推断，实体未声明）',
  `name` varchar(255) NULL COMMENT '计税规则名称',
  `type` int NULL COMMENT '计税类型 枚举 HrmSalaryTaxTypeEnum',
  `tax_enabled` bit(1) NULL COMMENT '是否计税',
  `threshold` decimal(12,2) NULL COMMENT '起征阈值',
  `decimal_scale` int NULL COMMENT '小数位数',
  `cycle_type` int NULL COMMENT '计税周期类型 枚举 HrmSalaryTaxCycleTypeEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 计税规则 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/employee/HrmSalaryChangeRecordDO.java
-- Entity: HrmSalaryChangeRecordDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, type int, reason int, effect_time datetime, before_total decimal(24,6), after_total decimal(24,6), probation_before_total decimal(24,6), probation_after_total decimal(24,6), salary_options json, probation_salary_options json, status int, remark text
CREATE TABLE `hrm_salary_change_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `type` int NULL COMMENT '记录类型 枚举 HrmSalaryChangeRecordTypeEnum',
  `reason` int NULL COMMENT '调整原因 枚举 HrmSalaryChangeReasonEnum',
  `effect_time` datetime NULL COMMENT '生效时间',
  `before_total` decimal(24,6) NULL COMMENT '调整前正式薪资',
  `after_total` decimal(24,6) NULL COMMENT '调整后正式薪资',
  `probation_before_total` decimal(24,6) NULL COMMENT '调整前试用期薪资',
  `probation_after_total` decimal(24,6) NULL COMMENT '调整后试用期薪资',
  `salary_options` json NULL COMMENT '正式薪资项后态快照',
  `probation_salary_options` json NULL COMMENT '试用期薪资项后态快照',
  `status` int NULL COMMENT '状态 枚举 HrmSalaryChangeRecordStatusEnum',
  `remark` text NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 定薪/调薪记录 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/employee/HrmSalaryEmployeeInfoDO.java
-- Entity: HrmSalaryEmployeeInfoDO extends BaseDO
-- 推断字段类型：id bigint, employee_id bigint, change_reason int, effect_time datetime, change_type int, probation_salary decimal(24,6), regular_salary decimal(24,6), remark text, salary_options json, probation_salary_options json
CREATE TABLE `hrm_salary_employee_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `change_reason` int NULL COMMENT '定薪、调薪原因 枚举 HrmSalaryChangeReasonEnum',
  `effect_time` datetime NULL COMMENT '生效时间',
  `change_type` int NULL COMMENT '薪资信息变更类型 枚举 HrmSalaryEmployeeInfoChangeTypeEnum',
  `probation_salary` decimal(24,6) NULL COMMENT '试用期工资',
  `regular_salary` decimal(24,6) NULL COMMENT '正式工资',
  `remark` text NULL COMMENT '备注',
  `salary_options` json NULL COMMENT '正式薪资项 薪资项随员工薪资信息整体维护',
  `probation_salary_options` json NULL COMMENT '试用期薪资项 薪资项随员工薪资信息整体维护',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工薪资信息 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/monthrecord/HrmSalaryMonthEmployeeRecordDO.java
-- Entity: HrmSalaryMonthEmployeeRecordDO extends BaseDO
-- 推断字段类型：id bigint, month_record_id bigint, employee_id bigint, actual_work_day decimal(24,6), need_work_day decimal(24,6), year int, month int, expected_pay_salary decimal(24,6), taxable_salary decimal(24,6), personal_tax decimal(24,6), real_pay_salary decimal(24,6), option_values json
CREATE TABLE `hrm_salary_month_employee_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `month_record_id` bigint NULL COMMENT '月度工资表编号 关联 HrmSalaryMonthRecordDO#getId()',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `actual_work_day` decimal(24,6) NULL COMMENT '实际工作天数',
  `need_work_day` decimal(24,6) NULL COMMENT '应工作天数',
  `year` int NULL COMMENT '年份',
  `month` int NULL COMMENT '月份',
  `expected_pay_salary` decimal(24,6) NULL COMMENT '应发工资',
  `taxable_salary` decimal(24,6) NULL COMMENT '应税工资',
  `personal_tax` decimal(24,6) NULL COMMENT '个人所得税',
  `real_pay_salary` decimal(24,6) NULL COMMENT '实发工资',
  `option_values` json NULL COMMENT '薪资项值快照 薪资项值随员工月度工资记录整体维护',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 员工月度工资记录 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/monthrecord/HrmSalaryMonthRecordDO.java
-- Entity: HrmSalaryMonthRecordDO extends BaseDO
-- 推断字段类型：id bigint, title varchar(255), year int, month int, employee_count int, start_time datetime, end_time datetime, expected_pay_salary decimal(24,6), personal_tax decimal(24,6), real_pay_salary decimal(24,6), personal_insurance_amount decimal(24,6), personal_provident_fund_amount decimal(24,6), corporate_insurance_amount decimal(24,6), corporate_provident_fund_amount decimal(24,6), option_headers json, status int
CREATE TABLE `hrm_salary_month_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `title` varchar(255) NULL COMMENT '工资表标题',
  `year` int NULL COMMENT '年份',
  `month` int NULL COMMENT '月份',
  `employee_count` int NULL COMMENT '员工人数',
  `start_time` datetime NULL COMMENT '计薪开始日期',
  `end_time` datetime NULL COMMENT '计薪结束日期',
  `expected_pay_salary` decimal(24,6) NULL COMMENT '应发工资',
  `personal_tax` decimal(24,6) NULL COMMENT '个人所得税',
  `real_pay_salary` decimal(24,6) NULL COMMENT '实发工资',
  `personal_insurance_amount` decimal(24,6) NULL COMMENT '个人社保金额',
  `personal_provident_fund_amount` decimal(24,6) NULL COMMENT '个人公积金金额',
  `corporate_insurance_amount` decimal(24,6) NULL COMMENT '公司社保金额',
  `corporate_provident_fund_amount` decimal(24,6) NULL COMMENT '公司公积金金额',
  `option_headers` json NULL COMMENT '薪资项表头快照',
  `status` int NULL COMMENT '状态 枚举 HrmSalaryMonthRecordStatusEnum',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 月度工资表 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/slip/HrmSalarySlipDO.java
-- Entity: HrmSalarySlipDO extends BaseDO
-- 推断字段类型：id bigint, send_record_id bigint, month_employee_record_id bigint, employee_id bigint, year int, month int, read_status int, real_pay_salary decimal(24,6), remark text, options json
CREATE TABLE `hrm_salary_slip` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `send_record_id` bigint NULL COMMENT '工资条发放记录编号 关联 HrmSalarySlipSendRecordDO#getId()',
  `month_employee_record_id` bigint NULL COMMENT '员工月度工资记录编号 关联 HrmSalaryMonthEmployeeRecordDO#getId()',
  `employee_id` bigint NULL COMMENT '员工编号 关联 HrmEmployeeDO#getId()',
  `year` int NULL COMMENT '年份',
  `month` int NULL COMMENT '月份',
  `read_status` int NULL COMMENT '阅读状态 枚举 HrmSalarySlipReadStatusEnum',
  `real_pay_salary` decimal(24,6) NULL COMMENT '实发工资',
  `remark` text NULL COMMENT '备注',
  `options` json NULL COMMENT '工资条项 工资条项随员工工资条整体维护，通过 Option#getChildren() 表达父子关系',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 工资条 DO';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/slip/HrmSalarySlipSendRecordDO.java
-- Entity: HrmSalarySlipSendRecordDO extends BaseDO
-- 推断字段类型：id bigint, month_record_id bigint, employee_count int, send_employee_count int, year int, month int
CREATE TABLE `hrm_salary_slip_send_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `month_record_id` bigint NULL COMMENT '月度工资表编号 关联 HrmSalaryMonthRecordDO#getId()',
  `employee_count` int NULL COMMENT '工资表总人数',
  `send_employee_count` int NULL COMMENT '本批次发放人数',
  `year` int NULL COMMENT '年份',
  `month` int NULL COMMENT '月份',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 工资条发放记录 DO 同一月度工资表可以分多批次发放工资条，因此发放记录保持独立实体。';

-- Source: yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/slip/HrmSalarySlipTemplateDO.java
-- Entity: HrmSalarySlipTemplateDO extends BaseDO
-- 推断字段类型：id bigint, name varchar(255), hide_empty bit(1), default_status bit(1), options json
CREATE TABLE `hrm_salary_slip_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(255) NULL COMMENT '模板名称',
  `hide_empty` bit(1) NULL COMMENT '是否隐藏空项',
  `default_status` bit(1) NULL COMMENT '是否默认模板',
  `options` json NULL COMMENT '工资条模板项 模板项随工资条模板整体维护，通过 Option#getChildren() 表达父子关系',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HRM 工资条模板 DO';
