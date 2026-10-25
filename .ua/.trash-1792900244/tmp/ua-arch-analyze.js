const fs = require('fs');
const path = require('path');
try {
  const [inputPath, outputPath] = process.argv.slice(2);
  if (!inputPath || !outputPath) throw new Error('用法: node ua-arch-analyze.js <输入.json> <输出.json>');
  const data = JSON.parse(fs.readFileSync(inputPath, 'utf8'));
  const { fileNodes, importEdges, allEdges } = data;
  if (!Array.isArray(fileNodes) || !Array.isArray(importEdges) || !Array.isArray(allEdges)) throw new Error('输入必须包含 fileNodes/importEdges/allEdges 数组');
  const nodeById = new Map(fileNodes.map(n => [n.id, n]));
  const paths = fileNodes.map(n => n.filePath || n.id.replace(/^[^:]+:/, '')).filter(Boolean).map(p => p.replace(/\\/g, '/'));
  const common = paths.length ? paths[0].split('/') : [];
  for (const p of paths.slice(1)) { const parts=p.split('/'); let i=0; while(i<common.length && i<parts.length && common[i]===parts[i]) i++; common.length=i; }
  const commonPrefix = common.join('/');
  const groups = new Map();
  const groupOf = new Map();
  const ext = p => path.posix.extname(p).toLowerCase() || '(无扩展名)';
  for (const n of fileNodes) {
    const p=(n.filePath||n.id.replace(/^[^:]+:/,'')).replace(/\\/g,'/');
    let rel=p;
    if (commonPrefix && p.startsWith(commonPrefix+'/')) rel=p.slice(commonPrefix.length+1);
    const parts=rel.split('/').filter(Boolean);
    let g=parts.length>1?parts[0]:(parts.length===1?'(根目录)':'(未知目录)');
    if (commonPrefix && !p.startsWith(commonPrefix+'/')) g=parts.length>1?parts[0]:'(根目录)';
    if (paths.every(q=>!q.includes('/'))) { g=/\.test\.|\.spec\./i.test(p)?'测试':/\.config\./i.test(p)?'配置':ext(p); }
    if(!groups.has(g))groups.set(g,[]); groups.get(g).push(n.id); groupOf.set(n.id,g);
  }
  const typeGroups={}; for(const n of fileNodes){(typeGroups[n.type]??=[]).push(n.id)}
  const fanOut=new Map(),fanIn=new Map(), groupImports=new Map();
  const edgeCounts=new Map(), crossCategory=new Map(), internal=new Map(), involvement=new Map();
  const inter=new Map(), pairCounts=new Map();
  for(const e of importEdges){
    fanOut.set(e.source,(fanOut.get(e.source)||0)+1);fanIn.set(e.target,(fanIn.get(e.target)||0)+1);
    const a=groupOf.get(e.source),b=groupOf.get(e.target); if(a!==undefined&&b!==undefined){const key=`${a}\0${b}`;inter.set(key,(inter.get(key)||0)+1);if(a===b)internal.set(a,(internal.get(a)||0)+1);involvement.set(a,(involvement.get(a)||0)+1);involvement.set(b,(involvement.get(b)||0)+1)}
  }
  for(const e of allEdges){
    edgeCounts.set(e.type,(edgeCounts.get(e.type)||0)+1);
    const a=nodeById.get(e.source),b=nodeById.get(e.target); if(a&&b&&a.type!==b.type){const key=`${a.type}\0${b.type}\0${e.type}`;crossCategory.set(key,(crossCategory.get(key)||0)+1)}
  }
  const namePatterns={api:['routes','api','controller','controllers','endpoints','handlers','routers','serializers'],service:['services','service','core','lib','domain','logic','internal','composables','jobs'],data:['models','model','db','data','persistence','repository','repositories','entities','entity','migrations','sql','database','schema'],ui:['components','views','pages','ui','layouts','screens','yudao-ui'],middleware:['middleware','plugins','interceptors','guards'],utility:['utils','util','helpers','common','shared','tools','pkg'],config:['config','configs','constants','env','settings','management','commands'],test:['test','tests','spec','specs','__tests__'],types:['types','interfaces','schemas','contracts','dtos','dto','request','response'],state:['store','stores','state','reducers','actions','slices'],assets:['assets','static','public'],documentation:['docs','documentation','wiki'],infrastructure:['deploy','deployment','infra','infrastructure','k8s','kubernetes','helm','charts','terraform','tf','docker','script'],entry:['cmd','bin']};
  const match={}; for(const g of groups.keys()){const s=g.toLowerCase(); for(const [label,names] of Object.entries(namePatterns))if(names.includes(s)){match[g]=label;break}}
  const infraFiles=[],schemaFiles=[],migrationFiles=[],dataModelFiles=[],apiHandlerFiles=[];
  let hasDockerfile=false,hasCompose=false,hasK8s=false,hasTerraform=false,hasCI=false;
  const docPaths=[];
  for(const n of fileNodes){const p=(n.filePath||'').replace(/\\/g,'/'),b=path.posix.basename(p).toLowerCase();
    if(/(^|\/)(dockerfile|docker-compose\.[^/]+)$/i.test(p)||/\.tf(vars)?$/i.test(p)||/(^|\/)(k8s|kubernetes|helm)\//i.test(p)||/(^|\/)(\.github\/workflows|\.gitlab-ci|jenkinsfile)/i.test(p)){infraFiles.push(p)}
    if(/^dockerfile/i.test(b))hasDockerfile=true;if(/docker-compose\./i.test(b))hasCompose=true;if(/(^|\/)(k8s|kubernetes|helm)\//i.test(p))hasK8s=true;if(/\.tf(vars)?$/i.test(p))hasTerraform=true;if(/(^|\/)(\.github\/workflows|\.gitlab-ci\.yml|jenkinsfile)/i.test(p))hasCI=true;
    if(/\.(sql|graphql|gql|proto|prisma)$/i.test(p))schemaFiles.push(p);
    if(/(^|\/)(migrations?|db\/migration)\//i.test(p)||/\.(up|down)\.sql$/i.test(p))migrationFiles.push(p);
    if(/(entity|model|mapper|repository|do)\.(java|kt)$/i.test(b)||/\/(entity|model|mapper|repository)\//i.test(p))dataModelFiles.push(p);
    if(/(controller|resource|endpoint|handler)\.(java|kt)$/i.test(b)||/\/(controller|controllers|routes|api)\//i.test(p))apiHandlerFiles.push(p);
    if(/\.md$|\.rst$/i.test(p))docPaths.push(p);
  }
  const groupDocs=[...groups.keys()].filter(g=>docPaths.some(p=>{const n=nodeById.get([...groups.get(g)][0]);const gp=(n.filePath||'').split('/')[0];return p.split('/')[0]===gp || p.toLowerCase().startsWith(g.toLowerCase()+'/')}));
  const dirs=[...groups.keys()].sort();
  const result={scriptCompleted:true,commonPathPrefix:commonPrefix?commonPrefix+'/':'',directoryGroups:Object.fromEntries(groups),nodeTypeGroups:typeGroups,crossCategoryEdges:[...crossCategory.entries()].map(([k,count])=>{const [fromType,toType,edgeType]=k.split('\0');return{fromType,toType,edgeType,count}}).sort((a,b)=>b.count-a.count),interGroupImports:[...inter.entries()].map(([k,count])=>{const [from,to]=k.split('\0');return{from,to,count}}).sort((a,b)=>b.count-a.count),intraGroupDensity:Object.fromEntries(dirs.map(g=>{const total=involvement.get(g)||0,inside=internal.get(g)||0;return[g,{internalEdges:inside,totalEdges:total,density:total?inside/total:0}]})),patternMatches:match,deploymentTopology:{hasDockerfile,hasCompose,hasK8s,hasTerraform,hasCI,infraFiles},dataPipeline:{schemaFiles,migrationFiles,dataModelFiles,apiHandlerFiles},docCoverage:{groupsWithDocs:groupDocs.length,totalGroups:groups.size,coverageRatio:groups.size?groupDocs.length/groups.size:0,undocumentedGroups:dirs.filter(g=>!groupDocs.includes(g))},dependencyDirection:[...inter.entries()].filter(([k])=>{const [a,b]=k.split('\0');return a!==b}).map(([k,count])=>{const[a,b]=k.split('\0'),reverse=inter.get(`${b}\0${a}`)||0;return {dependent:count>=reverse?a:b,dependsOn:count>=reverse?b:a,count:Math.max(count,reverse)}}).filter((x,i,arr)=>arr.findIndex(y=>y.dependent===x.dependent&&y.dependsOn===x.dependsOn)===i).sort((a,b)=>b.count-a.count),fileStats:{totalFileNodes:fileNodes.length,filesPerGroup:Object.fromEntries([...groups.entries()].map(([k,v])=>[k,v.length])),nodeTypeCounts:Object.fromEntries(Object.entries(typeGroups).map(([k,v])=>[k,v.length])),importEdgeCount:importEdges.length,allEdgeCount:allEdges.length,edgeTypeCounts:Object.fromEntries(edgeCounts)},fileFanIn:Object.fromEntries([...fanIn].sort((a,b)=>b[1]-a[1]).slice(0,100)),fileFanOut:Object.fromEntries([...fanOut].sort((a,b)=>b[1]-a[1]).slice(0,100))};
  fs.writeFileSync(outputPath,JSON.stringify(result,null,2)+'\n');
} catch(e) { console.error(e.stack||e); process.exit(1); }
