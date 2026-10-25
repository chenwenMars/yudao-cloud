const fs = require('fs');
const path = require('path');
const root='/Users/chenwen/workspace2/yudao-cloud';
const skills='/Users/chenwen/.skills-manager/cache/repos/2d68b2890014937e/understand-anything-plugin/skills/understand';
const ua=path.join(root,'.ua');
const summaryMethod={
  createApiAccessLog:'创建 API 访问日志并提供异步写入入口。', createApiErrorLog:'创建 API 错误日志并提供异步写入入口。', createOperateLog:'创建操作审计日志并提供异步写入入口。',
  createAccessToken:'创建 OAuth2 访问令牌。',checkAccessToken:'校验 OAuth2 访问令牌并返回令牌信息。',removeAccessToken:'删除指定 OAuth2 访问令牌。',refreshAccessToken:'刷新 OAuth2 访问令牌。',
  hasAnyPermissions:'检查当前调用方是否拥有所需权限。',hasAnyRoles:'检查当前调用方是否具备指定角色。',getDeptDataPermission:'获取部门数据权限范围。',getTenantIdList:'获取租户标识列表。',validTenant:'校验租户状态与有效性。',
  valueOf:'按输入值解析对应枚举项。',array:'返回可供遍历的枚举数组。',getCode:'读取异常错误码。',setCode:'更新异常错误码。',getMessage:'读取异常消息。',setMessage:'更新异常消息。',
  error:'构造带错误码和消息的失败结果。',success:'构造成功响应并封装返回数据。',isSuccess:'判断响应是否表示成功。',isError:'判断响应是否表示错误。',checkError:'检查响应错误状态并按约定抛出异常。',getCheckedData:'校验响应后提取业务数据。',
  of:'根据给定时间或日期字段创建时间对象。',addTime:'按指定时长计算新的时间值。',isExpired:'判断时间是否已经过期。',buildTime:'按日期与时分秒字段组合时间。',max:'比较时间值并返回较晚者。',isToday:'判断时间是否属于今天。',isYesterday:'判断时间是否属于昨天。',
  getTraceId:'读取当前请求的分布式追踪标识。',writeJSON:'向 HTTP 响应写入 JSON 内容。',getUserAgent:'读取请求中的 User-Agent 信息。',getRequest:'获取当前 HTTP 请求对象。',getClientIP:'解析客户端 IP 地址。',isJsonRequest:'判断请求是否以 JSON 形式提交。',getBody:'读取请求体文本。',getBodyBytes:'读取请求体字节数组。',getParamMap:'读取请求参数集合。',getHeaderMap:'读取请求头集合。',writeAttachment:'以附件形式写入响应内容。',
  maxLength:'按长度约束截取或限制文本。',startWithAny:'判断文本是否以候选前缀之一开头。',splitToLong:'将分隔文本解析为 Long 列表。',splitToLongSet:'将分隔文本解析为 Long 集合。',splitToInteger:'将分隔文本解析为 Integer 列表。',removeLineContains:'移除包含指定内容的文本行。',toPinyin:'将中文文本转换为拼音形式。',joinMethodArgs:'组合方法参数为可读字符串。',
  dataPermissionRuleFactory:'创建数据权限规则集合。',dataPermissionRuleHandler:'构造并应用数据权限 SQL 条件。',dataPermissionAnnotationAdvisor:'注册数据权限注解切面。',dataPermissionRequestInterceptor:'在 RPC 请求中传递数据权限上下文。',dataPermissionRpcFilter:'通过 Web filter 传播 RPC 数据权限信息。',deptDataPermissionRule:'提供部门范围的数据权限规则。',
  buildPointcut:'构造匹配数据权限注解的切点。',invoke:'拦截方法调用并应用数据权限规则。',findAnnotation:'查找目标方法或类上的数据权限注解。',get:'读取当前线程的数据权限上下文。',add:'向当前数据权限上下文加入规则。',remove:'移除当前上下文中的指定规则。',getAll:'获取当前线程的全部数据权限规则。',clear:'清理当前线程的数据权限上下文。',getSqlSegment:'将当前数据权限规则转换为 SQL 条件片段。',apply:'将 RPC 数据权限上下文附加到请求中。',doFilterInternal:'从 HTTP 请求读取并传递数据权限上下文。',
  dictUtils:'初始化字典相关工具组件。',init:'初始化字典数据访问依赖。',clearCache:'清理字典缓存。',parseDictDataLabel:'将字典值解析为展示标签。',getDictDataLabelList:'批量解析字典值对应的标签列表。',parseDictDataValue:'将字典标签解析为实际字典值。',getDictDataValueList:'批量解析字典标签对应的值列表。',
  initialize:'初始化校验器使用的字典参数。',isValid:'校验输入值是否属于字典允许范围。',supportJavaTypeKey:'声明转换器支持的 Java 数据类型。',supportExcelTypeKey:'声明转换器支持的 Excel 单元格类型。',convertToJavaData:'将 Excel 单元格内容转换为 Java 数据。',convertToExcelData:'将 Java 数据转换为 Excel 单元格内容。',getType:'返回转换器所处理的数据类型。',convertToFieldValue:'将字符串值转换为目标字段类型。',convertToArray:'将输入值转换为数组。',convertToCollection:'将输入值转换为集合。',createCollection:'按目标类型创建集合实例。',getCollectionElementClazz:'推断集合元素类型。',convertToStringList:'将多值内容规范化为字符串列表。',addStringValue:'向结果列表加入非空字符串值。',
  afterSheetCreate:'在工作表创建后配置下拉选择与单元格行为。',isStaticFinalOrTransient:'判断字段是否应排除在 Excel 处理之外。',getSelectDataList:'读取字段可选项并转换为显示列表。',setColumnSelect:'为指定列设置数据验证下拉选项。',setUp:'初始化测试依赖与测试数据。',
  executeBefore:'声明解析函数执行前的处理阶段。',functionName:'返回该解析函数注册时使用的名称。',apply:'将展示值解析为对应业务值。',
  testParseDictDataLabel:'验证字典值到标签的转换结果。',testParseDictDataValue:'验证字典标签到值的转换结果。',
};
function leaf(p){return p.slice(p.lastIndexOf('/')+1)}
function complexity(n){return n<50?'simple':n<=200?'moderate':'complex'}
function tagsFor(path, kind='file', name=''){
 const p=(path+' '+name).toLowerCase(); const t=[];
 if(p.includes('/test/')||p.endsWith('test.java')) t.push('测试','单元测试');
 if(/dto|respvo|reqvo|vo\.java/.test(p)) t.push('数据模型','接口契约');
 if(/commonapi|api\.java/.test(p)) t.push('服务接口','rpc');
 if(/permission|interceptor|filter|advisor|rule/.test(p)) t.push('权限控制','middleware');
 if(/controller\//.test(p)) t.push('管理端接口','api-handler','REST API');
 if(/fms|finance/.test(p)) t.push('财务管理');
 if(/bpm/.test(p)) t.push('工作流','流程管理');
 if(/hrm|employee/.test(p)) t.push('人力资源','员工管理');
 if(/member|auth|social/.test(p)) t.push('会员认证','社交登录');
 if(/mpstatistics|mp\//.test(p)) t.push('公众号','运营统计');
 if(/mes|warehouse|stock/.test(p)) t.push('制造执行','仓储管理');
 if(/mesqc/.test(p)) t.push('质量检验');
 if(/meswm/.test(p)) t.push('仓储单据','库存数据');
 if(/mesqc.*line|meswm.*detail|meswm.*line/.test(p)) t.push('明细记录');
 if(/meswm.*stock|meswm.*sn/.test(p)) t.push('库存追溯');
 if(/arrivalnotice|receipt/.test(p)) t.push('入库管理');
 if(/issue|consume/.test(p)) t.push('出库管理');
 if(/barcode/.test(p)) t.push('条码管理');
 if(/batch/.test(p)) t.push('批次追溯');
 if(/materialstock/.test(p)) t.push('库存管理');
 if(/tool/.test(p)) t.push('工装管理');
 if(/pms|knowledge/.test(p)) t.push('项目管理','知识文档');
 if(/goview|datasql/.test(p)) t.push('数据可视化','查询接口');
 if(/mall|trade|coupon|seckill|brokerage|aftersale|deliveryexpress/.test(p)) t.push('商城交易');
 if(/coupon|coupon/.test(p)) t.push('优惠券');
 if(/after.?sale/.test(p)) t.push('售后服务');
 if(/express|delivery/.test(p)) t.push('物流配送');
 if(/brokerage/.test(p)) t.push('分销');
 if(/im|livekit|kefu|channel|message/.test(p)) t.push('即时通讯','消息处理');
 if(/apierrorlog|apiaccesslog/.test(p)) t.push('接口日志','日志服务');
 if(/member|auth/.test(p)) t.push('会员认证');
 if(/attendance|clock/.test(p)) t.push('考勤管理');
 if(/performance/.test(p)) t.push('绩效管理');
 if(/salary|insurance/.test(p)) t.push('薪酬社保');
 if(/portal/.test(p)) t.push('员工门户');
 if(/recruit/.test(p)) t.push('招聘管理');
 if(/salary|payroll/.test(p)) t.push('薪酬管理');
 if(/performance/.test(p)) t.push('绩效管理');
 if(/imface|sensitiveword/.test(p)) t.push('即时通讯','内容管理');
 if(/mes/.test(p)) t.push('制造执行','设备管理');
 if(/mapper/.test(p)) t.push('数据访问','mybatis');
 if(/hrm|employee/.test(p)) t.push('人力资源','员工管理');
 if(/serviceimpl|service\.java/.test(p)) t.push('业务服务','service-layer');
 if(/idempotent/.test(p)) t.push('幂等控制','防重复提交');
 if(/rate.?limiter|ratelimit/.test(p)) t.push('限流','流量控制');
 if(/signature/.test(p)) t.push('签名校验','接口安全');
 if(/security|authentication|token/.test(p)) t.push('身份认证','访问控制');
 if(/cache/.test(p)) t.push('缓存','redis');
 if(/logrecord|apilog|trace/.test(p)) t.push('日志','请求追踪');
 if(/xss|filter|wrapper/.test(p)) t.push('web过滤器','请求处理');
 if(/dict/.test(p)) t.push('字典','数据转换');
 if(/excel|convert|handler/.test(p)) t.push('excel','数据转换');
 if(/utils|utils\.java/.test(p)) t.push('工具函数','common');
 if(/enum|constants/.test(p)) t.push('枚举','常量');
 if(/exception|error/.test(p)) t.push('异常处理','错误码');
 if(/oauth|token/.test(p)) t.push('oauth2','认证');
 if(/date/.test(p)) t.push('日期时间','工具函数');
 if(kind==='class') t.push('java','类定义');
 if(kind==='function') t.push('java','方法');
 while(t.length<3)t.push(kind==='function'?'工具方法':'基础组件');
 return [...new Set(t)].slice(0,5);
}
function fileSummary(f){
 const p=f.path.toLowerCase(), n=leaf(f.path).replace(/\.java$/,'');
 if(n.endsWith('DO')) return `定义 ${n.replace(/DO$/,'')} 持久化数据对象，承载数据库记录字段供服务和 Mapper 使用。`;
 if(n.endsWith('Mapper')) return `声明 ${n.replace(/Mapper$/,'')} 的 MyBatis 数据访问方法，连接领域服务与持久化数据。`;
 if(n==='LiveKitClient') return '封装 LiveKit RTC 服务端 API 调用，支撑即时音视频会议和房间管理。';
 if(n==='FriendInfoUpdatedNotification'||n==='FriendRequestApprovedNotification') return `定义 ${n.replace(/Notification$/,'')} 即时通讯通知事件，在用户或好友状态变化时传播消息。`;
 if(n==='AdminUserProfileUpdateConsumer') return '消费管理员资料更新事件并同步即时通讯侧的用户资料。';
 if(n==='ApiErrorLogServiceImpl') return '实现 API 错误日志写入、检索和分页查询服务。';
 if(n.endsWith('Controller')) return `提供 ${n.replace(/Controller$/,'')} 管理端 REST API，接收请求并委托服务层完成业务操作。`;
 if(n==='MemberAuthServiceImpl') return '实现短信验证码、社交登录与会员身份认证流程，并协同用户服务完成登录态建立。';
 if(n==='MemberUserServiceImpl') return '实现会员资料、联系方式及用户状态的查询和维护逻辑。';
 if(n==='MpStatisticsService') return '定义公众号运营统计数据查询契约，供消息与用户统计接口调用。';
 if(n==='MpStatisticsConvert') return '将公众号统计领域数据转换为接口响应结构。';
 if(n==='GoViewDataController') return '提供 GoView 可视化数据查询接口，支持按请求参数获取数据及执行 SQL 查询。';
 if(n==='PmsKnowledgeDocumentLikeController') return '提供知识文档点赞与取消点赞的管理端接口。';
 if(n.startsWith('MesWm')&&n.endsWith('Controller')) return `提供 ${n.replace(/^MesWm/,'').replace(/Controller$/,'')} 仓储业务管理端 REST API，支持单据或库存信息的查询与操作。`;
 if(n.startsWith('MesTm')&&n.endsWith('Controller')) return `提供 ${n.replace(/^MesTm/,'').replace(/Controller$/,'')} 工装管理 REST API，处理工装及类型维护请求。`;
 if(n.endsWith('DO')) return `定义 ${n.replace(/^MesQc/,'质量检验').replace(/^MesTm/,'工装管理').replace(/^MesWm/,'仓储管理').replace(/DO$/,'')} 持久化数据对象，承载 MES 质量、工装或仓储业务记录字段。`;
 if(n.endsWith('Enum')) return `定义 ${n.replace(/^MesWm/,'仓储').replace(/^MesMd/,'制造主数据')} 的制造、库存或单据状态枚举。`;
 if(/ServiceImpl$/.test(n)) return `实现 ${n.replace(/^(Hrm|Fms|Im|KeFu|Combination|Coupon|Discount|Point|Reward|Seckill|Trade|Brokerage)/,'').replace(/ServiceImpl$/,'')} 相关业务服务，组织数据访问、规则校验及交易流程协作。`;
 if(/Service$/.test(n)) return `声明 ${n.replace(/^(Hrm|Fms|Im|KeFu|Combination|Coupon|Discount|Point|Reward|Seckill|Trade|Brokerage)/,'').replace(/Service$/,'')} 领域服务操作契约，供控制器和其他服务调用。`;
 if(/Enum$/.test(n)) return `定义 ${n.replace(/^(Trade|AfterSale|Brokerage|Delivery)/,'')} 的交易或售后状态类型，供商城服务统一判断业务状态。`;
 if(n.endsWith('ApiImpl')) return `实现 ${n.replace(/Impl$/,'')} 服务接口，提供微服务间交易数据查询或操作。`;
 if(/Service$/.test(n)) return `声明 ${n.replace(/^(Hrm|Fms|Im|KeFu|Api)/,'').replace(/Service$/,'')} 领域服务操作契约，供控制器和其他服务调用。`;
 if(n.endsWith('DO')) return `定义 ${n.replace(/DO$/,'')} 持久化对象，承载即时通讯或客服会话相关数据库字段。`;
 if(n.endsWith('Mapper')) return `声明 ${n.replace(/Mapper$/,'')} 的 MyBatis 数据访问方法。`;
 if(/Job$/.test(n)) return `定义 ${n.replace(/^Hrm/,'')} 的定时或异步任务入口，执行对应的人力资源流程处理。`;
 if(/ParseFunction$/.test(n)) return `实现 ${n.replace(/^Hrm/,'')} 字典解析函数，将业务编码转换为展示文本。`;
 if(/Enum$/.test(n)) return `集中定义 ${n.replace(/^Hrm/,'')} 的状态或类型枚举，供考勤、绩效与薪酬流程统一引用。`;
 if(/Service$/.test(n)) return `声明 ${n.replace(/^Fms/,'').replace(/Service$/,'')} 领域服务的操作契约，供控制器和其他服务调用。`;
 if(n==='IdempotentAspect') return '通过 AOP 拦截幂等注解方法，根据请求键判定是否允许重复执行。';
 if(n==='RateLimiterAspect') return '通过 AOP 拦截限流注解方法，并根据配置的限流键申请访问配额。';
 if(n==='ApiSignatureAspect') return '校验 API 请求签名、时间戳与 nonce，阻止伪造或重放请求。';
 if(n==='ApiSignatureRedisDAO') return '使用 Redis 保存签名 nonce 并读取应用密钥，支持请求重放校验。';
 if(n==='LogRecordServiceImpl') return '组装操作日志中的用户、模块和请求信息，并提供日志查询能力。';
 if(n==='TimeoutRedisCacheManager') return '扩展 RedisCacheManager，使缓存项 TTL 可从配置值解析并应用。';
 if(n==='GlobalExceptionHandler') return '统一处理参数校验、HTTP、权限和业务异常，并构造错误响应及日志。';
 if(n==='GlobalResponseBodyHandler') return '在 MVC 响应写出前统一处理响应体包装逻辑。';
 if(n==='ApiAccessLogFilter') return '在请求过滤链中采集 API 访问信息、脱敏请求内容并生成访问日志。';
 if(n==='ApiEncryptFilter') return '拦截需要加密处理的 API 请求，并应用接口加解密策略。';
 if(n==='TokenAuthenticationFilter') return '从请求令牌中解析登录用户并建立 Spring Security 认证上下文。';
 if(n==='SecurityFrameworkUtils') return '提供登录用户、认证对象与权限检查相关的 Security 上下文工具。';
 if(n==='YudaoWebSecurityConfigurerAdapter') return '配置管理端与应用端的 Spring Security 过滤链和公开访问路径。';
 if(n==='YudaoSwaggerAutoConfiguration') return '组装 OpenAPI 元数据、安全方案、分组文档和接口标识定制器。';
 if(n==='JsoupXssCleaner') return '基于 Jsoup Safelist 清理不安全 HTML 内容，降低 XSS 注入风险。';
 if(n==='WebFrameworkUtils') return '从 HTTP 或 RPC 上下文读取租户、用户类型与终端信息，并构造公共响应。';
 if(n.endsWith('Controller')) return `提供 ${n.replace(/Controller$/,'')} 相关的管理端 REST API，接收请求并委托服务层完成业务操作。`;
 if(n==='LocalDateTimeUtils') return '提供日期时间解析、区间运算、工作日边界和时间段重叠判断等公共能力。';
 if(n==='NumberUtils') return '提供数值解析、空值归零、数字串校验及距离计算等通用方法。';
 if(n==='LambdaQueryWrapperX') return '扩展 MyBatis-Plus LambdaQueryWrapper，提供忽略空值的条件构造及查询排序辅助方法。';
 if(n==='FmsInitialBalanceExcelHelper') return '负责科目期初余额 Excel 模板生成、表头校验、行解析与导入数据转换。';
 if(n.endsWith('CommonApi')) return `定义 ${n.replace(/CommonApi$/,'')} 相关服务间调用的 Java 接口契约，供其他模块复用。`;
 if(n.endsWith('DTO')) return `承载 ${n.replace(/DTO$/,'')} 相关请求或响应字段，在模块间传递结构化数据。`;
 if(n.endsWith('VO')) return `定义 ${n.replace(/VO$/,'')} 的接口展示或请求字段，供管理端 API 交互使用。`;
 if(n.endsWith('Enum')) return `集中定义 ${n.replace(/Enum$/,'')} 业务状态或类型选项，供框架及业务模块统一引用。`;
 if(n.endsWith('Constants')) return `集中维护 ${n.replace(/Constants$/,'')} 相关常量，避免调用方重复定义约定值。`;
 if(n.endsWith('Exception')) return `封装服务运行时异常及其错误码、消息访问能力，供业务流程统一报告失败。`;
 if(n.endsWith('Utils')) return `提供 ${n.replace(/Utils$/,'')} 相关公共辅助能力，供框架和业务代码复用。`;
 if(n.endsWith('Validator')) return `实现 ${n.replace(/Validator$/,'')} 的 Bean Validation 校验逻辑，并使用字典或业务约束判断输入有效性。`;
 if(n.endsWith('AutoConfiguration')) return `注册 ${n.replace(/^Yudao/,'').replace(/AutoConfiguration$/,'')} 相关 Spring Boot 自动配置组件。`;
 if(n.endsWith('Interceptor')||n.endsWith('Advisor')||n.endsWith('WebFilter')) return `通过 ${n.replace(/^DataPermission/,'数据权限')} 拦截或过滤环节传递上下文并应用访问控制规则。`;
 if(n.endsWith('RuleHandler')) return `把数据权限规则转换为可执行的 SQL 条件，供数据访问层拼接查询。`;
 if(n.endsWith('RuleFactory')) return `组织并提供数据权限规则实例，供权限处理器统一应用。`;
 if(n.endsWith('Rule')) return `定义 ${n.replace(/Rule$/,'')} 规则契约，用于描述查询的数据权限范围。`;
 if(n.endsWith('Convert')) return `实现 ${n.replace(/Convert$/,'')} 数据格式转换，连接 Java 字段与 Excel 单元格表示。`;
 if(n.endsWith('Test')) return `覆盖 ${n.replace(/Test$/,'')} 的关键行为，验证转换和边界输入的预期结果。`;
 if(n.endsWith('Handler')) return `处理 Excel 工作表创建后的列选择配置与数据验证。`;
 if(n==='Mobile') return '声明手机号字段的校验注解，供 API 输入模型复用。';
 if(n==='DataPermission') return '声明数据权限注解及其规则参数，供 AOP 拦截器读取并执行。';
 return `定义 ${n} 相关的 Java 公共类型，供框架和业务模块复用。`;
}
function classSummary(n,p){const f={
  ApiAccessLogCommonApi:'定义 API 访问日志的服务调用契约。',ApiErrorLogCommonApi:'定义 API 错误日志的服务调用契约。',OperateLogCommonApi:'定义操作日志的服务调用契约。',OAuth2TokenCommonApi:'定义 OAuth2 访问令牌的创建、校验、删除与刷新接口。',PermissionCommonApi:'定义权限与部门数据范围的远程查询契约。',TenantCommonApi:'定义租户状态校验与租户标识查询契约。',CommonResult:'封装统一 API 响应的成功数据、错误码和检查方法。',DateUtils:'提供日期创建、比较、过期判断及日历边界计算能力。',ServletUtils:'提供 HTTP 请求读取、客户端信息解析和响应写入工具。',StrUtils:'提供字符串处理、分隔值解析、拼音转换与方法参数格式化能力。',TracerUtils:'提供当前分布式调用 traceId 的读取能力。',DataPermissionAnnotationInterceptor:'拦截带数据权限注解的方法，并解析注解及其执行上下文。',DataPermissionContextHolder:'以线程上下文维护当前请求的数据权限规则集合。',DataPermissionRuleHandler:'读取规则并生成数据权限 SQL 条件片段。',DataPermissionAnnotationAdvisor:'将数据权限注解匹配规则注册为 Spring AOP advisor。',DictFrameworkUtils:'封装字典缓存读取及字典标签和值的转换能力。',MultiDictConvert:'在 Excel 多值字段与 Java 数组、集合及字符串列表之间双向转换。',SelectSheetWriteHandler:'在 Excel 工作表生成后，为指定字段配置下拉数据验证。'
}; if(f[n])return f[n]; return fileSummary({path:p}).replace(/^定义/,'实现');}
function methodSummary(n){if(summaryMethod[n])return summaryMethod[n]; const specialized={aroundPointCut:'拦截幂等方法调用并根据幂等键阻止重复执行。',beforePointCut:'在目标方法执行前校验限流状态或请求签名。',verifySignature:'计算并校验请求签名与有效期。',verifyHeaders:'读取并校验签名请求头。',buildSignatureString:'按约定顺序构造待签名字符串。',getRequestHeaderMap:'读取并整理当前请求头。',getRequestParameterMap:'读取并整理当前请求参数。',resolver:'根据注解配置解析幂等或限流键。',tryAcquire:'尝试从 Redis 获取限流许可。',getRRateLimiter:'获取或创建 Redis 限流器实例。',setIfAbsent:'使用 Redis 原子写入确保幂等键首次提交成功。',delete:'删除 Redis 中的幂等或限流记录。',record:'写入结构化操作日志记录。',fillUserFields:'补齐操作日志中的用户信息。',fillModuleFields:'补齐操作日志中的模块信息。',fillRequestFields:'补齐操作日志中的请求上下文信息。',buildAdminApi:'构造管理端 API 的访问规则。',buildAppApi:'构造应用端 API 的访问规则。',getPermitAllUrlsFromAnnotations:'从注解中收集允许匿名访问的 URL。',buildLoginUserByToken:'从访问令牌解析登录用户。',mockLoginUser:'构造测试或模拟场景下的登录用户。',buildLoginUserByHeader:'从请求头解析登录用户信息。',handle:'生成访问拒绝响应。',commence:'生成未认证请求的入口响应。',doFilterInternal:'处理当前 HTTP 请求并继续过滤链。',shouldNotFilter:'判断当前请求是否应跳过该过滤器。',allExceptionHandler:'统一捕获未分类异常并生成标准错误响应。',beforeBodyWrite:'在响应写出前转换统一响应体。',clean:'清理 HTML 中不安全的标签和属性。'};if(specialized[n])return specialized[n]; if(/^(create|update|delete|save|close|cancel|generate|initialize|import|export|get|build|query|validate|check|calculate|aggregate|accumulate|find|merge|intersect|flatten|expand|resolve|format|copy|sum|count|has|is|lock|subtract|append|prune|collect|filter|parse|convert|fill|first|to|valid|disable|enable|random|send|receive|approve|reject|read|mark|join|leave|accept|add|remove|switch|start|finish|sync)/.test(n)){const v=n.match(/^(create|update|delete|save|close|cancel|generate|initialize|import|export|get|build|query|validate|check|calculate|aggregate|accumulate|find|merge|intersect|flatten|expand|resolve|format|copy|sum|count|has|is|lock|subtract|append|prune|collect|filter|parse|convert|fill|first|to|valid|disable|enable|random|send|receive|approve|reject|read|mark|join|leave|accept|add|remove|switch|start|finish|sync)/)[1];const m={create:'创建或登记',update:'更新',delete:'删除',save:'保存',close:'执行结账',cancel:'取消结账',generate:'生成',initialize:'初始化',import:'导入',export:'导出',get:'查询',build:'组装',query:'查询',validate:'校验',check:'检查',calculate:'计算',aggregate:'汇总',accumulate:'累加',find:'查找',merge:'合并',intersect:'求交集',flatten:'展开',expand:'展开',resolve:'解析',format:'格式化',copy:'复制',sum:'汇总',count:'统计',has:'判断是否存在',is:'判断',lock:'锁定',subtract:'计算差值',append:'追加',prune:'裁剪',collect:'收集',filter:'筛选',parse:'解析',convert:'转换',fill:'填充',first:'获取首项',to:'转换为',valid:'验证',disable:'停用',enable:'启用',random:'生成测试数据',send:'发送',receive:'接收',approve:'批准',reject:'拒绝',read:'读取',mark:'标记',join:'加入',leave:'退出',accept:'接受',add:'添加',remove:'移除',switch:'切换',start:'启动',finish:'完成',sync:'同步'};return `${m[v]} ${n.slice(v.length)} 相关数据或业务状态。`;} if(n.startsWith('test'))return `验证 ${n.replace(/^test/,'')} 场景下的预期行为。`; if(n.startsWith('get'))return `读取并返回 ${n.slice(3)} 相关数据。`; if(n.startsWith('set'))return `设置 ${n.slice(3)} 相关属性。`; if(n.startsWith('convert'))return `执行 ${n.replace(/^convert/,'')} 数据转换。`; if(n.startsWith('is'))return `判断 ${n.slice(2)} 是否满足指定条件。`; if(n.startsWith('parse'))return `解析输入并转换为 ${n.slice(5)} 结果。`; return `执行 ${n} 相关的框架处理逻辑。`;}
function typeForMethod(n){return n;}
function generate(i){
 const input=JSON.parse(fs.readFileSync(path.join(ua,`tmp/ua-file-analyzer-input-${i}.json`),'utf8'));
 const ext=JSON.parse(fs.readFileSync(path.join(ua,`tmp/ua-file-extract-results-${i}.json`),'utf8'));
 if(!ext.scriptCompleted) throw new Error('extract not completed');
 const nodes=[], edges=[], idset=new Set();
 const addNode=n=>{if(idset.has(n.id))return; idset.add(n.id); nodes.push(n)};
 const fileNodeByPath={};
 for(const f of ext.results){
   const id=`file:${f.path}`; const name=leaf(f.path); fileNodeByPath[f.path]=id;
   addNode({id,type:'file',name,filePath:f.path,summary:fileSummary(f),tags:tagsFor(f.path,'file',name),complexity:complexity(f.nonEmptyLines||0)});
 }
 const exported=(f,n)=> (f.exports||[]).some(e=>e.name===n);
 const classIds={};
 for(const f of ext.results){
   for(const c of f.classes||[]){
     const significant=(c.endLine-c.startLine+1>=20)||(c.methods||[]).length>=2||exported(f,c.name);
     if(!significant)continue;
     const id=`class:${f.path}:${c.name}`; classIds[`${f.path}\0${c.name}`]=id;
     const className=c.name;
     addNode({id,type:'class',name:className,filePath:f.path,lineRange:[c.startLine,c.endLine],summary:classSummary(className,f.path),tags:tagsFor(f.path,'class',className),complexity:complexity(c.endLine-c.startLine+1)});
     edges.push({source:`file:${f.path}`,target:id,type:'contains',direction:'forward',weight:1.0});
     if(exported(f,className))edges.push({source:`file:${f.path}`,target:id,type:'exports',direction:'forward',weight:0.8});
   }
 }
 for(const f of ext.results){
   const classesByLine=(f.classes||[]).slice().sort((a,b)=>a.startLine-b.startLine);
   for(const fn of f.functions||[]){
     const size=fn.endLine-fn.startLine+1;
     if(size<10&&!exported(f,fn.name))continue;
     const id=`function:${f.path}:${fn.name}`;
     const cls=[...classesByLine].reverse().find(c=>fn.startLine>=c.startLine&&fn.startLine<=c.endLine);
     const owner=cls?.name;
     addNode({id,type:'function',name:fn.name,filePath:f.path,lineRange:[fn.startLine,fn.endLine],summary:methodSummary(fn.name),tags:tagsFor(f.path,'function',fn.name),complexity:complexity(size)});
     edges.push({source:`file:${f.path}`,target:id,type:'contains',direction:'forward',weight:1.0});
     if(exported(f,fn.name))edges.push({source:`file:${f.path}`,target:id,type:'exports',direction:'forward',weight:0.8});
   }
 }
 let expectedImports=0;
 for(const f of input.batchFiles){
   for(const dest of input.batchImportData[f.path]||[]){edges.push({source:`file:${f.path}`,target:`file:${dest}`,type:'imports',direction:'forward',weight:0.7}); expectedImports++;}
 }
 // Connect test files to production files they import using canonical production -> test direction.
 const testPaths=new Set(input.batchFiles.filter(f=>/Test\.java$/.test(f.path)).map(f=>f.path));
 for(const tp of testPaths){ for(const prod of input.batchImportData[tp]||[]){ if(!/Test\.java$/.test(prod)){ edges.push({source:`file:${tp}`,target:`file:${prod}`,type:'tested_by',direction:'forward',weight:0.5}); } } }
 if(edges.filter(e=>e.type==='imports').length!==expectedImports)throw new Error('import count mismatch');
 // Partition alphabetically by file path so each part stays within limits.
 const files=input.batchFiles.map(f=>f.path).sort((a,b)=>a.localeCompare(b));
 let parts=Math.ceil(Math.max(nodes.length/60,edges.length/120,1));
 let chunkSize=Math.ceil(files.length/parts); let out=[]; let part=0;
 for(let off=0;off<files.length;off+=chunkSize){part++; const subset=new Set(files.slice(off,off+chunkSize));const ns=nodes.filter(n=>subset.has(n.filePath));const nids=new Set(ns.map(n=>n.id));const es=edges.filter(e=>{const sourcePath=e.source.slice(e.source.indexOf(':')+1).split(':')[0];return nids.has(e.source)||subset.has(sourcePath)});out.push({part,nodes:ns,edges:es});}
 const finalParts=[];
 for(const p of out){const filename=out.length===1?`batch-${i}.json`:`batch-${i}-part-${p.part}.json`;const full=path.join(ua,'intermediate',filename);fs.writeFileSync(full,JSON.stringify({nodes:p.nodes,edges:p.edges},null,2)+'\n');const check=JSON.parse(fs.readFileSync(full,'utf8'));if(!Array.isArray(check.nodes)||!Array.isArray(check.edges))throw new Error('bad graph json '+filename);finalParts.push({filename,nodes:p.nodes.length,edges:p.edges.length});}
 console.log(JSON.stringify({batch:i,files:ext.filesAnalyzed,nodes:nodes.length,edges:edges.length,imports:expectedImports,parts:finalParts}));
}
for(const i of [81,82])generate(i);
