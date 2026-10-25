const fs = require('fs');
try {
  const [inputPath, outputPath] = process.argv.slice(2);
  if (!inputPath || !outputPath) throw new Error('用法: node ua-tour-analyze.js <输入.json> <输出.json>');
  const data=JSON.parse(fs.readFileSync(inputPath,'utf8'));
  const {nodes,edges,layers}=data;
  if(!Array.isArray(nodes)||!Array.isArray(edges)||!Array.isArray(layers))throw new Error('输入必须包含 nodes/edges/layers 数组');
  const byId=new Map(nodes.map(n=>[n.id,n]));if(byId.size!==nodes.length)throw new Error('输入节点 ID 重复');
  const fanIn=new Map(),fanOut=new Map(), adj=new Map(), importAdj=new Map();
  for(const n of nodes){fanIn.set(n.id,0);fanOut.set(n.id,0);adj.set(n.id,[]);importAdj.set(n.id,[])}
  const pairedEdges=new Map(), importCallDirections=new Map();
  for(const e of edges){if(!byId.has(e.source)||!byId.has(e.target))continue;
    fanOut.set(e.source,fanOut.get(e.source)+1);fanIn.set(e.target,fanIn.get(e.target)+1);adj.get(e.source).push(e.target);
    if(e.type==='imports'||e.type==='calls'){
      importAdj.get(e.source).push(e.target);
      const k=`${e.source}\0${e.target}`;importCallDirections.set(k,(importCallDirections.get(k)||0)+1);
      const pair=e.source<e.target?`${e.source}\0${e.target}`:`${e.target}\0${e.source}`;
      if(!pairedEdges.has(pair))pairedEdges.set(pair,{a:e.source<e.target?e.source:e.target,b:e.source<e.target?e.target:e.source,count:0,ab:0,ba:0});
      const p=pairedEdges.get(pair);p.count++;if(e.source===p.a)p.ab++;else p.ba++;
    }
  }
  const n=nodes.length,fanOutVals=[...fanOut.values()].sort((a,b)=>a-b),fanInVals=[...fanIn.values()].sort((a,b)=>a-b);
  const p90=fanOutVals[Math.floor((n-1)*0.9)]||0,p25=fanInVals[Math.floor((n-1)*0.25)]||0;
  const appPattern=/^(index\.(ts|js)|main\.(ts|js|go|rs|cpp|c)|app\.(ts|js|py)|server\.(ts|js)|mod\.rs|main\.py|manage\.py|wsgi\.py|asgi\.py|run\.py|__main__\.py|Application\.java|Main\.java|Program\.cs|config\.ru|index\.php|App\.swift|Application\.kt)$/i;
  const codeNodes=nodes.filter(x=>x.type==='file');
  const candidates=[];
  for(const n of codeNodes){let score=0;const base=n.name||n.filePath?.split('/').pop()||'';const p=n.filePath||'';if(appPattern.test(base)||/Application\.(java|kt)$/i.test(base)||/ServerApplication\.(java|kt)$/i.test(base))score+=3;if(p.split('/').length<=2)score+=1;if((fanOut.get(n.id)||0)>=p90)score+=1;if((fanIn.get(n.id)||0)<=p25)score+=1;if(score)candidates.push({id:n.id,score,name:n.name,summary:n.summary})}
  for(const n of nodes){if(n.type==='document'&&n.filePath==='README.md')candidates.push({id:n.id,score:5,name:n.name,summary:n.summary});else if(n.type==='document'&&n.filePath&&!n.filePath.includes('/')&&/\.md$/i.test(n.filePath))candidates.push({id:n.id,score:2,name:n.name,summary:n.summary})}
  candidates.sort((a,b)=>b.score-a.score||a.id.localeCompare(b.id));
  const rankings=(map,key)=>[...map].sort((a,b)=>b[1]-a[1]||a[0].localeCompare(b[0])).slice(0,20).map(([id,count])=>({id,[key]:count,name:byId.get(id)?.name||id}));
  const preferredStart='file:yudao-server/src/main/java/cn/iocoder/yudao/server/YudaoServerApplication.java';
  const startCandidate=byId.has(preferredStart)?{id:preferredStart}:candidates.find(c=>byId.get(c.id)?.type==='file');
  const startId=startCandidate?.id;
  const order=[],depthMap={};if(startId){const q=[startId];depthMap[startId]=0;for(let i=0;i<q.length;i++){const id=q[i];order.push(id);for(const target of importAdj.get(id)||[]){if(depthMap[target]===undefined){depthMap[target]=depthMap[id]+1;q.push(target)}}}}
  const byDepth={};for(const id of order)(byDepth[depthMap[id]]??=[]).push(id);
  const nonCodeFiles={documentation:[],infrastructure:[],data:[],config:[]};
  for(const x of nodes){const item={id:x.id,name:x.name,type:x.type,summary:x.summary};if(x.type==='document')nonCodeFiles.documentation.push(item);if(['service','pipeline','resource'].includes(x.type))nonCodeFiles.infrastructure.push(item);if(['table','schema','endpoint'].includes(x.type))nonCodeFiles.data.push(item);if(x.type==='config')nonCodeFiles.config.push(item)}
  const mutualAdj=new Map(nodes.map(x=>[x.id,new Set()]));
  const importCallAdj=new Map(nodes.map(x=>[x.id,new Set()]));
  for(const p of pairedEdges.values()){importCallAdj.get(p.a).add(p.b);importCallAdj.get(p.b).add(p.a);if(p.ab>0&&p.ba>0){mutualAdj.get(p.a).add(p.b);mutualAdj.get(p.b).add(p.a)}}
  const uniqueClusters=[],visitedMutual=new Set();
  for(const id of nodes.map(x=>x.id)){
    if(visitedMutual.has(id)||!mutualAdj.get(id).size)continue;
    const component=[],queue=[id];visitedMutual.add(id);
    for(let i=0;i<queue.length;i++){const cur=queue[i];component.push(cur);for(const next of mutualAdj.get(cur))if(!visitedMutual.has(next)){visitedMutual.add(next);queue.push(next)}}
    const seed=[...component].sort((a,b)=>mutualAdj.get(b).size-mutualAdj.get(a).size||a.localeCompare(b))[0];
    const members=[seed],seen=new Set([seed]),frontier=[seed];
    while(frontier.length&&members.length<5){const cur=frontier.shift();for(const next of mutualAdj.get(cur)){if(seen.has(next))continue;seen.add(next);members.push(next);frontier.push(next);if(members.length===5)break}}
    while(members.length<5){
      const candidates=new Set();for(const member of members)for(const next of importCallAdj.get(member))if(!members.includes(next))candidates.add(next);
      let best=null,bestLinks=1;for(const candidate of candidates){let links=0;for(const member of members)if(importCallAdj.get(candidate).has(member))links++;if(links>bestLinks||(links===bestLinks&&links>1&&(!best||candidate.localeCompare(best)<0))){best=candidate;bestLinks=links}}
      if(!best)break;members.push(best);
    }
    if(members.length>=2){let edgeCount=0;for(let i=0;i<members.length;i++)for(let j=i+1;j<members.length;j++){const a=members[i],b=members[j],p=pairedEdges.get(a<b?`${a}\0${b}`:`${b}\0${a}`);if(p)edgeCount+=p.count}uniqueClusters.push({nodes:members,edgeCount})}
  }
  uniqueClusters.sort((a,b)=>b.edgeCount-a.edgeCount||b.nodes.length-a.nodes.length);const finalClusters=uniqueClusters.slice(0,10).map(({nodes,edgeCount})=>({nodes,edgeCount}));
  const out={scriptCompleted:true,entryPointCandidates:candidates.slice(0,5),fanInRanking:rankings(fanIn,'fanIn'),fanOutRanking:rankings(fanOut,'fanOut'),bfsTraversal:{startNode:startId||null,order,depthMap,byDepth},nonCodeFiles,clusters:finalClusters,layers:{count:layers.length,list:layers.map(({id,name,description})=>({id,name,description}))},nodeSummaryIndex:Object.fromEntries(nodes.map(x=>[x.id,{name:x.name,type:x.type,summary:x.summary}])),totalNodes:nodes.length,totalEdges:edges.length,analyzedEdgesWithinNodeInventory: [...fanIn.values()].reduce((s,x)=>s+x,0)};
  fs.writeFileSync(outputPath,JSON.stringify(out,null,2)+'\n');
} catch(e){console.error(e.stack||e);process.exit(1)}
