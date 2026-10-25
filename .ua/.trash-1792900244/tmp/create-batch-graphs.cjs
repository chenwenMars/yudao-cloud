const fs=require('fs'),path=require('path');
const root='/Users/chenwen/workspace2/yudao-cloud';
const modules={'yudao-framework':'基础框架','yudao-gateway':'API 网关','yudao-module-bpm':'工作流','yudao-module-fms':'财务','yudao-module-hrm':'人力资源','yudao-module-ai':'AI'};
const allNodes=[],allEdges=[];
const base=p=>path.posix.basename(p), area=p=>modules[p.split('/')[0]]||'业务';
const complexity=n=>n>200?'complex':n>=50?'moderate':'simple';
function summary(p){const n=base(p).replace(/\.java$/,'');
 if(p.includes('/controller/')){
  if(/AttendanceClock/.test(n))return '提供人力资源考勤打卡及班次管理接口，委托业务服务执行新增、修改、查询、删除和导出。';
  if(/AttendanceGroup/.test(n))return '提供人力资源考勤组管理接口，处理考勤组配置、当前用户组查询及分页读取。';
  if(/AttendanceHoliday/.test(n))return '提供人力资源节假日管理接口，处理维护、校验和分页查询。';
  if(/AttendanceStatistics/.test(n))return '提供人力资源考勤统计接口，查询日/月明细与概览，并支持统计结果导出。';
  if(/EmployeeCertificate/.test(n))return '提供人力资源员工证书查询、创建、更新和删除接口。';
  if(/ChatConversation/.test(n))return '提供 AI 聊天会话管理接口，处理用户会话创建、读取、更新、删除及管理员查询。';
  if(/ChatMessage/.test(n))return '提供 AI 聊天消息接口，处理消息发送、流式回复、会话消息读取和管理端查询。';
  if(/AiImage/.test(n))return '提供 AI 图片生成与管理接口，支持图片查询、绘图任务、Midjourney 回调及图片维护。';
  if(/AiKnowledgeDocument/.test(n))return '提供 AI 知识库文档管理接口，处理文档创建、批量导入、更新、状态变更和删除。';
  if(/AiKnowledge/.test(n))return '提供 AI 知识库管理接口，支持分页查询、创建、更新、删除及简单列表读取。';
  return `提供${area(p)}管理端 HTTP 接口，接收请求并调用业务服务。`;
 }
 if(p.includes('/vo/'))return `定义${area(p)}接口的请求或响应数据结构，承载业务字段及必要的数据校验约束。`;
 if(p.includes('/enums/')){if(n==='ErrorCodeConstants')return '集中定义 AI 模块业务错误码常量，供服务与接口层复用。';if(n==='DictTypeConstants')return '集中定义 AI 模块字典类型标识，避免业务代码散落字面量。';return `定义${area(p)}使用的${n.replace(/Enum$/,'')}业务枚举及相关查询辅助方法。`;}
 if(n==='ArrayValuable')return '定义可将枚举等类型转换为数组的通用接口契约。';
 if(n==='ArrayUtils')return '提供数组追加、集合转数组及按位置读取等通用操作。';
 if(n==='SetUtils')return '提供集合创建辅助方法，用于从给定元素构造 Set。';
 if(n==='InEnumCollectionValidator')return '实现集合字段的枚举值校验，确保元素均属于注解指定范围。';
 if(n==='InEnumValidator')return '实现单值枚举校验器，检查字段值是否属于注解声明的枚举常量。';
 if(n==='InEnum')return '定义枚举成员校验注解，将字段约束关联到具体枚举类型。';
 if(n==='InDict')return '定义字典值校验注解，供参数校验阶段检查字典数据。';
 if(n==='CacheUtils')return '封装本地缓存构建方法，支持普通缓存及异步刷新缓存。';
 if(n==='AssertUtils')return '提供测试断言工具，用于比较 POJO 并校验服务异常行为。';
 if(n==='ProjectReactor')return '提供网关测试目录中的项目文件复制、遍历和内容替换辅助程序。';
 return `定义${area(p)}中的 ${n}，供相关模块共享使用。`;
}
function tags(p){const n=base(p);if(p.includes('/controller/'))return ['api-handler','管理端接口','业务控制器'];if(p.includes('/vo/'))return ['type-definition','接口数据模型','数据校验'];if(p.includes('/enums/'))return ['业务枚举','共享类型','常量定义'];if(/Validator\.java$/.test(n)||n==='InEnum.java'||n==='InDict.java')return ['validation','枚举校验','参数约束'];if(/Utils\.java$/.test(n))return ['utility','通用工具','基础组件'];if(n==='ProjectReactor.java')return ['test','文件操作','开发工具'];return ['Java','共享组件','业务类型'];}
function fnSummary(n){const table=[[/^create/,'创建'],[/^update/,'更新'],[/^delete/,'删除'],[/^(get|find|query|load|list)/,'查询'],[/^export/,'导出'],[/^build/,'构建'],[/^fill/,'填充'],[/^write/,'写入'],[/^format/,'格式化'],[/^validate/,'校验'],[/^is/,'判断'],[/^copy/,'复制'],[/^replace/,'替换'],[/^append/,'追加'],[/^toArray/,'转换为数组'],[/^asSet/,'构造集合'],[/^array/,'返回枚举数组'],[/^valueOf/,'按值查找'],[/^typeOf/,'按类型查找'],[/^assert/,'断言'],[/^main$/,'执行工具入口']];let v='处理';for(const [r,t]of table)if(r.test(n)){v=t;break;}const target=n.replace(/([a-z0-9])([A-Z])/g,'$1 $2').toLowerCase().replace(/attendance/g,'考勤').replace(/clock/g,'打卡').replace(/group/g,'考勤组').replace(/holiday/g,'节假日').replace(/certificate/g,'证书').replace(/chat/g,'聊天').replace(/conversation/g,'会话').replace(/message/g,'消息').replace(/knowledge/g,'知识库').replace(/document/g,'文档').replace(/image/g,'图片').replace(/month/g,'月度').replace(/daily/g,'日常').replace(/page/g,'分页').replace(/shift/g,'班次').replace(/array/g,'数组').replace(/file/g,'文件').trim();return `${v}${target?' '+target:''}相关数据。`;}
const batchIds=process.argv.slice(2).map(Number);
if(!batchIds.length)throw new Error('pass literal batch indices');
for(const id of batchIds){
 const ex=JSON.parse(fs.readFileSync(`${root}/.ua/tmp/ua-file-extract-results-${id}.json`,'utf8'));
 const input=JSON.parse(fs.readFileSync(`${root}/.ua/tmp/ua-file-analyzer-input-${id}.json`,'utf8'));
 const pathSet=new Set(input.batchFiles.map(f=>f.path)), emitted=new Set();
 for(const f of ex.results){const p=f.path,fileId=`file:${p}`,node={id:fileId,type:'file',name:base(p),filePath:p,summary:summary(p),tags:tags(p),complexity:complexity(f.nonEmptyLines||0)};allNodes.push(node);emitted.add(fileId);
   for(const t of input.batchImportData?.[p]||[])allEdges.push({source:fileId,target:`file:${t}`,type:'imports',direction:'forward',weight:0.7});
   const exports=new Set((f.exports||[]).map(e=>e.name));const classByName=new Map();
   for(const c of f.classes||[]){const cid=`class:${p}:${c.name}`;const desc=p.includes('/controller/')?'承载管理端请求处理逻辑并调用业务服务。':p.includes('/vo/')?'描述接口字段、校验约束及请求或响应结构。':c.name.endsWith('Enum')?'封装共享枚举值与辅助查询行为。':'提供可复用类型或组件。';allNodes.push({id:cid,type:'class',name:c.name,filePath:p,lineRange:[c.startLine,c.endLine],summary:desc,tags:p.includes('/controller/')?['api-handler','业务控制器','管理端']:p.includes('/vo/')?['type-definition','接口数据模型','数据校验']:['Java','共享类型','业务组件'],complexity:complexity((c.endLine||0)-(c.startLine||0)+1)});emitted.add(cid);classByName.set(c.name,cid);allEdges.push({source:fileId,target:cid,type:'contains',direction:'forward',weight:1});if(exports.has(c.name))allEdges.push({source:fileId,target:cid,type:'exports',direction:'forward',weight:0.8});}
   const fnByName=new Map();for(const fn of f.functions||[])if(!fnByName.has(fn.name))fnByName.set(fn.name,fn);
   for(const [name,fn] of fnByName){const span=(fn.endLine||0)-(fn.startLine||0)+1;if(!exports.has(name)&&span<10)continue;const fid=`function:${p}:${name}`;allNodes.push({id:fid,type:'function',name,filePath:p,lineRange:[fn.startLine,fn.endLine],summary:fnSummary(name),tags:p.includes('/controller/')?['接口操作','业务方法','管理端']:['工具方法','Java','共享逻辑'],complexity:complexity(span)});emitted.add(fid);allEdges.push({source:fileId,target:fid,type:'contains',direction:'forward',weight:1});if(exports.has(name))allEdges.push({source:fileId,target:fid,type:'exports',direction:'forward',weight:0.8});}
   for(const call of f.callGraph||[]){const s=`function:${p}:${call.caller}`,t=`function:${p}:${call.callee}`;if(emitted.has(s)&&emitted.has(t))allEdges.push({source:s,target:t,type:'calls',direction:'forward',weight:0.8});}
 }
 const nodes=[...new Map(allNodes.filter(n=>pathSet.has(n.filePath)).map(n=>[n.id,n])).values()];
 const owns=e=>{for(const p of pathSet){if(e.source===`file:${p}`||e.source.startsWith(`function:${p}:`)||e.source.startsWith(`class:${p}:`))return true;}return false;};
 const edges=[...new Map(allEdges.filter(owns).map(e=>[[e.source,e.target,e.type].join('|'),e])).values()];
 const inputImports=Object.values(input.batchImportData||{}).reduce((n,a)=>n+a.length,0),outImports=edges.filter(e=>e.type==='imports').length;if(inputImports!==outImports)throw Error(`batch ${id}: expected ${inputImports} imports, wrote ${outImports}`);
 fs.writeFileSync(`${root}/.ua/intermediate/batch-${id}.json`,JSON.stringify({nodes,edges},null,2));console.log(`batch ${id}: ${pathSet.size} files, ${nodes.length} nodes, ${edges.length} edges (${outImports} imports)`);
}
