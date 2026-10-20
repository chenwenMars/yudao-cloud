# HRM 人力资源管理业务知识

> 本文从当前 HRM 模块的管理端与员工门户 Controller、Service、DO、枚举、Mapper 和推断 DDL 静态整理而来，未执行登录、通知、薪资计算、考勤统计或绩效流程。员工、薪资和考核都涉及敏感数据，本文不能代替运行权限核验、隐私合规审计或实际人事制度。

## 技术栈、服务模块与主要作用

| 项目 | 当前代码依据 |
| --- | --- |
| 后端服务 | `yudao-module-hrm-server`（[pom.xml](../../yudao-module-hrm/yudao-module-hrm-server/pom.xml)） |
| 基础技术栈 | Java 17、Spring Boot 3.5.15、Maven、MyBatis、租户/IP/安全、模块 RPC、Nacos 服务发现与配置。 |
| 模块专项依赖 | System、HRM、BPM API；任务调度、Excel 与监控 starter。 |
| 主要作用 | 处理招聘、员工档案与异动、考勤、薪酬、社保、绩效和员工自助服务。 |

## 1. 定位、角色与边界

HRM 覆盖招聘、入职与员工档案、异动/离职、考勤、薪酬、社保、绩效和员工自助门户。HR 管理员维护组织下的员工、合同、履历、薪资/社保规则和月度批次；招聘人员管理岗位、渠道、候选人和面试；部门负责人或绩效评审人推进考核；员工通过 Portal 维护个人资料、打卡/请假、查看社保、绩效待办和工资条。

`hrm_employee` 是业务员工档案，`user_id` 连接 SYSTEM 后台用户；两者不是同一实体。服务会借助 `AdminUserApi`、`DeptApi` 校验用户/部门，并通过通知 API 发送入职补档和绩效消息。员工的入职状态、任职状态、转正、调动、晋升、降职、离职与再入职都有专门流程，不能直接把档案更新等同于人事状态迁移。[确认入职](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/employee/info/HrmEmployeeServiceImpl.java:167)。

HRM 输出薪资、社保和绩效业务台账，但静态扫描未发现自动创建 PAY 打款、FMS 凭证或 BPM 流程实例。考勤统计是根据班组/班次、打卡、请假及计算时点得出的查询结果，不是单独的月度考勤事实表；工资和社保月度记录才是按月的业务快照。

## 2. 完整业务域

### 2.1 招聘、候选人与入职转化

招聘域提供招聘配置、渠道、职级/岗位类别、岗位、候选人和面试。候选人可变更渠道、投递岗位、状态或淘汰信息，面试记录绑定候选人；候选人转员工时服务会校验候选人状态并创建待入职员工，再由员工确认入职同步候选人入职结果。招聘流程不是仅靠一个候选人状态字段串联，员工档案可携带 `candidateId` 保留转化来源。[候选人服务](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/recruit/candidate/HrmRecruitCandidateServiceImpl.java:55) [候选人转员工入口](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/recruit/HrmRecruitCandidateController.java:141)。

### 2.2 员工档案、任职与自助资料

员工域包括基础档案、动态字段配置、联系方式、证书、教育/培训/工作履历、附件、个人备注、合同、薪资卡、异动记录和离职信息。确认入职会验证固定与配置化必填字段、人员重复性并写为在职；转正、调动、晋升、降职、离职、撤销离职和再入职均写员工及相应异动/离职信息。Portal 入口复用员工档案服务，但由当前登录用户定位员工，不能把管理端批量修改的权限扩展给员工本人。

### 2.3 考勤与请假

考勤组定义适用员工/部门及班次规则，节假日单独维护；员工打卡记录保存上/下班、阶段、时间与状态，请假记录提供时间区间。统计服务将排班、跨日班次、打卡、请假、节假日和当前计算时点合并，计算迟到、早退、旷工、请假天数及有效打卡次数。这里的“实时统计”受当前时间影响，同一日期在下班截止前后可能不同；它不等于已结算给薪的考勤月账。[考勤统计核心](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/attendance/statistics/HrmAttendanceStatisticsServiceImpl.java:347)。

### 2.4 薪资、工资条与社保

薪资配置定义薪资组、薪资项、薪资变动模板、个税规则、工资条模板和员工薪资信息；薪资变动记录是调薪历史。按月的 `hrm_salary_month_record` 和 `hrm_salary_month_employee_record` 固化本期发薪批次及员工计算结果，工资条和发送记录服务于向员工展示/通知。代码中月记录与员工月记录存在单独创建、计算、确认/发送等动作，不能把员工当前薪资档案当成历史工资单。

社保同样区分方案/标准、员工参保信息、月度批次与月度员工记录；生成下月批次和员工清单是独立入口。社保、薪资月度数据均可能包含手工调整；本文不依据字段名推断已实现外部社保申报或银行代发。[薪资配置创建月记录](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/salary/config/HrmSalaryConfigServiceImpl.java:44) [社保月度记录入口](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/insurance/monthrecord/HrmInsuranceMonthRecordServiceImpl.java:55)。

### 2.5 绩效计划与考核流程

绩效模板定义考核指标、维度和结果档位；绩效计划选择人员范围、模板、评分人、权重、目标确认、结果审核、结果确认和申诉配置。启动计划时为每位适用员工创建考核与指标/阶段实例。阶段可以包含员工填指标、目标确认、自评或他评、结果审核、结果确认、申诉确认及结束；评分人无法解析时，代码会合并权重到相邻可执行阶段，而不是假装创建不可执行待办。处理人必须绑定后台用户，否则初始化失败。[启动计划](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/performance/plan/HrmPerformancePlanServiceImpl.java:266) [阶段初始化与处理人校验](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/performance/assessment/HrmPerformanceAssessmentProcessServiceImpl.java:87)。

## 3. 核心对象与表关系

| 业务链 | 主要表 | 关系意义 |
| --- | --- | --- |
| 招聘 | `hrm_recruit_*` | 岗位类别—岗位、渠道—候选人、候选人—面试；候选人可转为员工 |
| 员工档案 | `hrm_employee`、联系/附件/履历/证书/备注/合同/薪资卡表 | 全部以员工 id 归档，动态字段配置决定资料收集要求 |
| 任职变动 | `hrm_employee_change_record`、`hrm_employee_quit_info` | 变动历史与当前员工档案分开，离职与撤销/再入职不能只看当前状态 |
| 考勤 | `hrm_attendance_group`、`holiday`、`clock`、`leave` | 班组班次、节假日、打卡和请假共同组成统计输入 |
| 薪资 | `hrm_salary_*`、`hrm_salary_slip*` | 当前薪资设置、变动、月度汇总/员工明细、工资条与发送记录分层 |
| 社保 | `hrm_insurance_scheme*`、`employee_info`、`month_record*` | 方案标准、员工参保和月度快照分开 |
| 绩效 | `hrm_performance_plan`、模板、`assessment*`、`appeal_record` | 计划配置生成员工考核、指标、评分阶段、分数及申诉记录 |

参见 [HRM ER 图](/Users/chenwen/workspace2/yudao-cloud/docs/er/hrm-er.drawio) 与 [HRM 推断 DDL](/Users/chenwen/workspace2/yudao-cloud/sql/mysql/hrm.sql)。表间连接是应用逻辑关系，不表示数据库已配置外键或级联删除。

## 4. 主要端到端流程

### 流程 A：候选人到正式员工

1. 招聘人员维护渠道、岗位和候选人，记录一个或多个面试。
2. 招聘确认录用时，把候选人转为待入职员工；候选人与员工通过 `candidateId` 保留来源。
3. HR 补全必填档案、部门、岗位、入职日期和身份/联系信息，执行确认入职。
4. 服务校验待入职状态、动态字段和唯一性后，将员工更新为在职，并回写候选人的入职状态。
5. 后续转正、调动、晋升、降职和离职走单独入口并记录异动；再入职要求原状态为离职。

核心代码见 [确认入职](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/employee/info/HrmEmployeeServiceImpl.java:167) 和 [再入职](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/employee/info/HrmEmployeeServiceImpl.java:198)。

### 流程 B：排班、打卡、请假到考勤结果

1. HR 配置考勤组、班次适用范围与节假日；员工或管理员产生上班/下班打卡和请假记录。
2. 查询日/月统计时，服务先确定员工当日班次和跨日工作区间，再加载对应打卡、请假和计算时间。
3. 对工作时段扣除请假，判断首个上班、最后下班打卡及迟到/早退阈值；未到截止时间不能过早认定缺卡或旷工。
4. 形成迟到、早退、旷工、请假、出勤天数和打卡明细的响应；它没有直接写薪资月度记录。

源码见 [考勤统计](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/attendance/statistics/HrmAttendanceStatisticsServiceImpl.java:274)。

### 流程 C：薪资与工资条月度处理

1. 先设置薪资组、薪资项、个税规则、工资条模板和员工薪资信息，调薪写为独立变动记录。
2. 薪资配置服务可创建月度发薪记录；月记录再生成或维护员工月度薪资明细。
3. 业务人员按月记录计算、调整或确认员工明细，工资条服务基于明细和模板生成/查询工资条。
4. 发送工资条时保留发送记录，Portal 仅查询当前员工可见的工资条。
5. 静态分析未发现这里自动调用 PAY 打款或 FMS 记账，因此“工资条已发”不能表述为“已银行代发”。

月度服务入口见 [HrmSalaryMonthRecordServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/salary/monthrecord/HrmSalaryMonthRecordServiceImpl.java:73)。

### 流程 D：社保月度处理

1. 配置社保方案及标准，为员工保存参保方案/基数等信息。
2. 创建首期或下期社保月记录，按规则生成员工月度参保清单。
3. 管理员对月度员工记录做调整、停缴或补建清单；员工 Portal 查询自己的参保信息。
4. 月度记录保留历史口径，当前员工方案更新不应被视为已经回写历史月份。

对应入口见 [社保月记录 Controller](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/insurance/HrmInsuranceMonthRecordController.java:30)。

### 流程 E：绩效计划到评分、确认与申诉

1. 配置考核模板、结果模板后，建立绩效计划，定义范围、指标设置方式、评分人及权重。
2. 启动计划时为范围内员工创建考核实例，并初始化目标、评分、审核、确认、申诉等阶段。
3. 每个阶段必须能解析到已绑定系统账号的员工；无法执行的评分阶段会合并权重而非生成无处理人的任务。
4. 员工与评审人通过 Portal/管理端处理待办、打分、审核、确认或申诉，服务记录动作和阶段状态。
5. 结果可按计划配置同步到薪资的月份字段，但这一配置不等于已验证的薪资计算或发放联动。

参考 [绩效计划](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/performance/plan/HrmPerformancePlanServiceImpl.java:102) 和 [绩效流程](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/service/performance/assessment/HrmPerformanceAssessmentProcessServiceImpl.java:87)。

## 5. 状态、金额与台账影响

| 维度 | 已核对规则 |
| --- | --- |
| 员工 | 确认入职要求待入职；再入职要求已离职；转正/异动/离职各有专门校验与记录 |
| 考勤 | 迟到、早退、旷工以班次、打卡、请假和当前时间计算；跨日班次被显式处理 |
| 薪资 | 当前薪资设置、调薪记录、月度员工记录和工资条是不同层；文档不将任一金额解释为实付银行流水 |
| 社保 | 方案/标准与员工月度参保快照分离；停缴和修改月度记录属于业务动作 |
| 绩效 | 计划可处于草稿、未开始、进行/归档等状态，阶段有未处理、待处理及已完成等语义；只能以具体枚举和服务校验判断可转移性 |
| 访问 | 管理端与 Portal 使用不同入口，Portal 根据当前账号映射员工，敏感字段展示须以实际权限和脱敏实现验证 |

## 6. 跨模块协作

- **SYSTEM**：员工绑定后台用户，部门归属与主管解析依赖 SYSTEM 用户/部门 API；招聘、绩效、补档消息通过通知 API 发出。代码调用存在不代表模板、通知渠道已配置或成功送达。
- **INFRA**：Excel 导入导出、附件地址和操作日志由通用组件支持；附件字段不能单独证明本模块包含文件上传存储。
- **PAY/FMS/BPM**：未读到 HRM 将工资、社保或绩效直接发送到支付、总账或流程引擎的核心调用，不能把 HRM 月度记录宣称为发薪/会计完成。

## 7. 典型场景

1. 新员工入职：候选人经过面试转为待入职员工，HR 完成档案确认入职，后续由本人在 Portal 补资料。
2. 月度考勤：班组和请假配置后，主管查看按班次计算的迟到、早退和缺卡，而非手工汇总打卡次数。
3. 薪资处理：薪酬人员维护员工薪资和调薪，建立当月批次生成员工明细与工资条，员工在 Portal 自助查询。
4. 绩效考核：设置多角色评分及权重，启动后系统为员工生成阶段待办；评分、结果确认和申诉形成可追溯过程记录。

## 8. 当前限制与待验证事项

- 员工、薪资、社保和绩效计算包含大量规则和 JSON 配置，必须以真实组织、班次、税率、权限和通知通道做集成验证；本文仅验证静态路径。
- `syncToSalary` 和 `paidForMonth` 目前可见于绩效计划 DO、请求校验及按计薪月查询；本次未读到薪资 Service 消费这两个字段的调用，因此不能把该配置写成已实现的工资计算联动，更不能推断 FMS 凭证或 PAY 发放。
- Portal 与管理端共用若干服务但权限主体不同；需要专门测试用户未绑定员工、员工离职、跨部门主管和多次再入职的访问边界。
- 推断 DDL 中的 JSON、历史快照、脱敏字段、索引和物理外键不等于生产表结构；薪资/身份信息的加密、脱敏、审计和数据保留期应另做安全核查。

## 9. Controller 接口域覆盖与源码阅读入口

建议阅读“招聘转员工 → 确认入职 → 考勤统计 → 薪资月记录 → 绩效阶段”主线，再按需检查 Portal 的当前用户限制。下面覆盖全部 62 个管理端 Controller；Portal 也单列，避免把员工自助能力漏算为后台能力。

| Controller 包（相对 `controller/admin`） | 控制器数 | 覆盖入口 |
| --- | ---: | --- |
| [employee](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/employee) | 13 | 员工档案、字段配置、联系方式、履历/证书、合同、工资卡、异动、离职、附件/备注 |
| [recruit](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/recruit) | 6 | 候选人、面试、渠道、岗位、岗位类别、招聘配置 |
| [attendance](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/attendance) | 5 | 考勤组、节假日、打卡、请假及统计 |
| [salary](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/salary) | 12 | 薪资配置/项/组/个税、员工薪资与调薪、月记录/员工记录、工资条/模板/发送 |
| [insurance](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/insurance) | 5 | 社保方案、标准、员工参保、月记录与月度员工记录 |
| [performance](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/performance) | 4 | 绩效计划、考核、考核模板、结果模板 |
| [portal](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/portal) | 15 | 员工自助档案、考勤、社保、绩效、工资条和首页 |
| [home](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/home) | 1 | HR 首页统计 |
| [operatelog](/Users/chenwen/workspace2/yudao-cloud/yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/controller/admin/operatelog) | 1 | 人事操作日志查询 |

覆盖合计 62 个 Controller、50 张持久表。接口权限注解、Portal 数据隔离、通知配置和薪资/社保实际公式均需在可运行环境验证。
