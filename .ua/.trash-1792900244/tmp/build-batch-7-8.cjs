const fs = require('fs');
const path = require('path');
const root='/Users/chenwen/workspace2/yudao-cloud';
const ua=path.join(root,'.ua');
const batches=JSON.parse(fs.readFileSync(path.join(ua,'intermediate/batches.json'),'utf8')).batches;
const roleFor=(p)=>{
 if (p.includes('/controller/')) return 'controller';
 if (p.includes('/vo/')) return 'api-model';
 if (p.includes('/dataobject/')) return 'data-model';
 if (p.includes('/mysql/')) return 'mapper';
 if (p.includes('/service/')) return 'business-service';
 if (p.includes('/job/')) return 'scheduled-job';
 if (p.includes('/enums/')) return 'domain-enum';
 if (p.includes('/util/')) return 'utility';
 if (p.includes('/validation/')) return 'validation';
 if (p.includes('/config/')) return 'configuration';
 if (p.includes('/handler/')) return 'handler';
 if (p.includes('/annotation/')) return 'annotation';
 if (p.includes('/core/')) return 'framework-core';
 return 'java-component';
};
const roleZh={
 controller:'管理 HTTP 接口，接收请求参数并调用应用服务返回响应。',
 'api-model':'定义接口请求或响应的数据结构，供控制器与前端/API 调用方传递业务字段。',
 'data-model':'映射业务持久化数据，承载数据库字段及实体相关元信息。',
 mapper:'封装数据库访问入口，为业务服务提供对应领域数据的查询与写入能力。',
 'business-service':'声明或实现业务服务能力，协调领域数据访问与业务规则。',
 'scheduled-job':'定义定时任务入口，在调度触发时执行对应的后台业务处理。',
 'domain-enum':'集中定义领域状态、类型或常量，供业务逻辑保持一致的取值约束。',
 utility:'提供可复用的通用处理逻辑，供框架或业务模块调用。',
 validation:'实现输入或领域数据校验规则，支持参数合法性检查。',
 configuration:'配置 Spring 组件或基础设施集成，决定模块运行时装配行为。',
 handler:'处理框架扩展点或数据转换流程，为基础设施能力提供定制行为。',
 annotation:'声明可复用的元数据标注，用于框架配置、运行时处理或接口描述。',
 'framework-core':'提供框架级基础抽象与共享能力，供多个业务组件复用。',
 'java-component':'定义 Java 组件或领域类型，为所属模块提供基础功能。'
};
const op=(n)=>{
 const s=n.replace(/([a-z0-9])([A-Z])/g,'$1 $2').replace(/_/g,' ').toLowerCase();
 if (/^(get|query|find|select|page|list|count|load|fetch)/.test(s)) return `查询或读取${s.replace(/^(get|query|find|select|page|list|count|load|fetch)\s*/, '') || '相关业务数据'}`;
 if (/^(create|add|save|insert|submit|register)/.test(s)) return `创建或保存${s.replace(/^(create|add|save|insert|submit|register)\s*/, '') || '业务数据'}`;
 if (/^(update|modify|change|set)/.test(s)) return `更新${s.replace(/^(update|modify|change|set)\s*/, '') || '业务状态'}`;
 if (/^(delete|remove|clear)/.test(s)) return `删除或清理${s.replace(/^(delete|remove|clear)\s*/, '') || '业务数据'}`;
 if (/^(approve|audit|reject|review)/.test(s)) return `审核并处理${s.replace(/^(approve|audit|reject|review)\s*/, '') || '业务记录'}`;
 if (/^(expire|cleanup|clean|cancel|close)/.test(s)) return `执行${s.replace(/^(expire|cleanup|clean|cancel|close)\s*/, '') || '后台清理任务'}`;
 if (/^(validate|check|verify)/.test(s)) return `校验${s.replace(/^(validate|check|verify)\s*/, '') || '输入或业务状态'}`;
 if (/^(format|convert|to|from)/.test(s)) return `转换或格式化${s.replace(/^(format|convert|to|from)\s*/, '') || '数据'}`;
 return `处理${s}相关逻辑。`;
};
const nodeTags=(role)=>({
 controller:['api-handler','service','web'], 'api-model':['data-model','api','validation'], 'data-model':['data-model','persistence','domain'], mapper:['persistence','mapper','database'], 'business-service':['service','business-logic','domain'], 'scheduled-job':['scheduled-job','background-task','service'], 'domain-enum':['domain','constants','type-definition'], utility:['utility','helper','shared'], validation:['validation','input-check','utility'], configuration:['configuration','spring-boot','infrastructure'], handler:['handler','extension-point','framework'], annotation:['annotation','metadata','framework'], 'framework-core':['framework','shared','infrastructure'], 'java-component':['java','component','module']
}[role]||['java','component','module']);
const complexity=(n)=>n>200?'complex':n>=50?'moderate':'simple';
const nodeType=(f)=>{
 if(f.fileCategory==='config') return 'config'; if(f.fileCategory==='docs') return 'document';
 if(f.fileCategory==='infra') return /Dockerfile|compose|k8s/i.test(f.path)?'service':'pipeline';
 if(f.fileCategory==='data') return /\.sql$/i.test(f.path)?'table':'schema'; return 'file';
};
for(const index of [7,8]) {
 const b=batches.find(x=>x.batchIndex===index); const x=JSON.parse(fs.readFileSync(path.join(ua,`tmp/ua-file-extract-results-${index}.json`),'utf8'));
 const files=new Map(b.files.map(f=>[f.path,f])); const resultByPath=new Map(x.results.map(f=>[f.path,f]));
 const nodes=[],edges=[],ids=new Set(); const pushNode=n=>{if(ids.has(n.id))return;ids.add(n.id);nodes.push(n)};
 const fileIds=new Map();
 for(const src of b.files){
  const f=resultByPath.get(src.path); if(!f) continue;
  const role=roleFor(src.path); const type=nodeType(src); const id=`${type}:${src.path}`; fileIds.set(src.path,id);
  const baseName=path.basename(src.path); const className=f.classes?.[0]?.name;
  const summary=roleZh[role];
  const tags=nodeTags(role);
  pushNode({id,type,name:baseName,filePath:src.path,summary,tags,complexity:complexity(f.nonEmptyLines??f.totalLines)});
 }
 for(const src of b.files){
  const f=resultByPath.get(src.path); if(!f) continue;
  const fileId=fileIds.get(src.path); if(!fileId) continue;
  const exported=new Set((f.exports||[]).map(e=>e.name));
  for(const c of f.classes||[]){
   const clsId=`class:${src.path}:${c.name}`; const exportedClass=exported.has(c.name);
   if((c.methods?.length||0)>=2 || c.endLine-c.startLine+1>=20 || exportedClass){
    const role=roleFor(src.path); pushNode({id:clsId,type:'class',name:c.name,filePath:src.path,lineRange:[c.startLine,c.endLine],summary:`${c.name}：${roleZh[role]}`,tags:nodeTags(role),complexity:complexity(c.endLine-c.startLine+1)});
    edges.push({source:fileId,target:clsId,type:'contains',direction:'forward',weight:1.0});
    if(exportedClass) edges.push({source:fileId,target:clsId,type:'exports',direction:'forward',weight:0.8});
   }
  }
  const funcsByName=new Map(); for(const fn of f.functions||[]){const prev=funcsByName.get(fn.name); if(!prev || fn.endLine-fn.startLine>prev.endLine-prev.startLine) funcsByName.set(fn.name,fn);}
  for(const fn of funcsByName.values()){
   const len=fn.endLine-fn.startLine+1; const exportedFn=exported.has(fn.name);
   if(len<10&&!exportedFn) continue;
   const id=`function:${src.path}:${fn.name}`; const role=roleFor(src.path);
   pushNode({id,type:'function',name:fn.name,filePath:src.path,lineRange:[fn.startLine,fn.endLine],summary:`${op(fn.name)}。`,tags:nodeTags(role),complexity:complexity(len)});
   edges.push({source:fileId,target:id,type:'contains',direction:'forward',weight:1.0});
   if(exportedFn) edges.push({source:fileId,target:id,type:'exports',direction:'forward',weight:0.8});
  }
  for(const target of b.batchImportData?.[src.path]||[]){edges.push({source:fileId,target:`file:${target}`,type:'imports',direction:'forward',weight:0.7});}
  const localFnNames=new Set(funcsByName.keys());
  for(const cg of f.callGraph||[]){ if(localFnNames.has(cg.caller)&&localFnNames.has(cg.callee)){edges.push({source:`function:${src.path}:${cg.caller}`,target:`function:${src.path}:${cg.callee}`,type:'calls',direction:'forward',weight:0.8});} }
 }
 // Deduplicate graph edges by semantic identity.
 const edgeSeen=new Set(); const deduped=edges.filter(e=>{const k=`${e.source}|${e.target}|${e.type}`;if(edgeSeen.has(k))return false;edgeSeen.add(k);return true;});
 const byFile=new Map(b.files.map(f=>[f.path,[]]));
 for(const n of nodes){const p=n.filePath;if(byFile.has(p))byFile.get(p).push(n);}
 const outEdgesByFile=new Map(b.files.map(f=>[f.path,[]]));
 for(const e of deduped){const sourcePath=e.source.slice(e.source.indexOf(':')+1).split(':')[0]; const file=Array.from(b.files).find(f=>e.source===fileIds.get(f.path)||e.source.startsWith(`function:${f.path}:`)||e.source.startsWith(`class:${f.path}:`));if(file)outEdgesByFile.get(file.path).push(e);}
 const totalImports=Object.values(b.batchImportData||{}).reduce((a,arr)=>a+arr.length,0); const actualImports=deduped.filter(e=>e.type==='imports').length;
 if(totalImports!==actualImports) throw new Error(`batch ${index}: expected ${totalImports} import edges, got ${actualImports}`);
 let parts=1; if(nodes.length>60||deduped.length>120)parts=Math.ceil(Math.max(nodes.length/60,deduped.length/120));
 const sortedFiles=[...b.files].sort((a,z)=>a.path.localeCompare(z.path)); const groupSize=Math.ceil(sortedFiles.length/parts);
 const partFiles=Array.from({length:parts},(_,i)=>new Set(sortedFiles.slice(i*groupSize,(i+1)*groupSize).map(f=>f.path)));
 for(let pi=0;pi<parts;pi++){
  const pnodes=nodes.filter(n=>partFiles[pi].has(n.filePath)); const pids=new Set(pnodes.map(n=>n.id));
  const pedges=deduped.filter(e=>pids.has(e.source));
  const out=path.join(ua,'intermediate',parts===1?`batch-${index}.json`:`batch-${index}-part-${pi+1}.json`);
  fs.writeFileSync(out,JSON.stringify({nodes:pnodes,edges:pedges},null,2)+'\n');
 }
 console.log(JSON.stringify({batchIndex:index,files:x.results.length,skipped:x.filesSkipped,nodes:nodes.length,edges:deduped.length,imports:actualImports,parts}));
}
