const fs = require('fs');
const path = require('path');
const [inputPath, resultsPath, outputPath] = process.argv.slice(2);
if (!inputPath || !resultsPath || !outputPath) throw new Error('用法: node ua-arch-assign.js <输入> <结构分析> <输出>');
const input=JSON.parse(fs.readFileSync(inputPath,'utf8'));
const stats=JSON.parse(fs.readFileSync(resultsPath,'utf8'));
if (stats.scriptCompleted!==true || stats.fileStats.totalFileNodes!==8939) throw new Error(`结构分析节点数不符: ${stats.fileStats?.totalFileNodes}`);
const layers=[
{id:'layer:api',name:'API 接入层',description:'承接各业务模块的 REST 控制器与网关请求入口，将请求校验、权限处理和响应组织委派给下游服务。',nodeIds:[]},
{id:'layer:service',name:'业务服务层',description:'组织系统管理、工作流、商城、制造、供应链、人力资源、AI 与物联网等业务流程，并协调跨模块能力。',nodeIds:[]},
{id:'layer:data',name:'数据与持久化层',description:'承载 MyBatis 持久化映射、数据对象、Mapper 与数据库表结构，覆盖各业务模块及多数据库方言脚本。',nodeIds:[]},
{id:'layer:types',name:'接口契约与类型层',description:'定义模块间 RPC/API 契约、请求响应 DTO 与共享类型，为服务间调用和前后端交互提供稳定的数据边界。',nodeIds:[]},
{id:'layer:framework',name:'共享框架层',description:'提供 yudao-framework 中可复用的 Spring Boot starter、通用组件及安全、租户、消息、缓存和 Web 基础能力。',nodeIds:[]},
{id:'layer:ui',name:'前端项目层',description:'收录 Vue、Vben 与 UniApp 管理端及商城前端的项目说明入口；前端源码位于这些独立项目目录中。',nodeIds:[]},
{id:'layer:config',name:'配置与构建层',description:'管理 Maven 多模块构建、依赖版本、应用参数及各模块运行配置，连接后端服务与构建工具链。',nodeIds:[]},
{id:'layer:infrastructure',name:'运行与部署层',description:'包含 Docker 镜像与 Compose 编排、CI 工作流、运维脚本及服务启动入口，支撑应用构建和部署运行。',nodeIds:[]},
{id:'layer:test',name:'测试与生成夹具层',description:'验证网关、框架和业务模块行为，并提供测试数据库、代码生成模板与前端生成样例等测试夹具。',nodeIds:[]},
{id:'layer:documentation',name:'文档层',description:'说明平台整体结构、业务域流程、数据库设计与开发使用方式，为模块理解和项目接入提供参考。',nodeIds:[]}
];
const byId=new Map(input.fileNodes.map(n=>[n.id,n]));
if(byId.size!==input.fileNodes.length)throw new Error('输入包含重复节点 ID');
function classify(n){
  const p=(n.filePath||n.id.replace(/^[^:]+:/,'')).replace(/\\/g,'/');
  const base=path.posix.basename(p), low=p.toLowerCase(), tags=new Set(n.tags||[]);
  if(low.startsWith('yudao-ui/')) return 'layer:ui';
  if(n.type==='document'||low.startsWith('docs/')||/\.(md|rst)$/i.test(base)) return 'layer:documentation';
  if(/(^|\/)src\/test\//i.test(p)||/(^|\/)test\//i.test(p)||/\bTest\.(java|kt)$/i.test(base)||/\bTests\.(cs)$/i.test(base)||tags.has('test')||tags.has('unit-test')||tags.has('单元测试')||tags.has('测试')) return 'layer:test';
  if(n.type==='service'||/^\.github\//.test(p)||/^\.gitee\//.test(p)||/^script\//.test(p)||/dockerfile|docker-compose/i.test(base)||/\.github\/workflows\//i.test(p)) return 'layer:infrastructure';
  if(n.type==='config'||/^(pom\.xml|lombok\.config|makefile)$/i.test(base)||/application\.(yml|yaml|properties)$/i.test(base)||tags.has('configuration')||tags.has('配置')) return 'layer:config';
  if(n.type==='table'||/\.sql$/i.test(base)||/(^|\/)dal\/(do|dataobject|mysql|postgresql|oracle|sqlserver|db2|dm|kingbase|opengauss|highgo)\//i.test(p)||/(^|\/)(mapper|repository|entity|entities|dataobject|do)\//i.test(p)||['persistence','持久化','数据访问','database','mybatis'].some(t=>tags.has(t))) return 'layer:data';
  if(tags.has('api-handler')||/(^|\/)controller(s)?\//i.test(p)||n.type==='endpoint') return 'layer:api';
  if(/(^|\/)yudao-module-[^/]+-api\//.test(p)||/(^|\/)(dto|request|response|vo|contract|contracts)\//i.test(p)||['接口契约','共享类型','type-definition','request-response'].some(t=>tags.has(t))) return 'layer:types';
  if(/^yudao-framework\//.test(p)||/^yudao-dependencies\//.test(p)||tags.has('framework')) return 'layer:framework';
  if(/^yudao-server\//.test(p)||/YudaoServerApplication\.(java|kt)$/i.test(base)) return 'layer:infrastructure';
  if(['business-logic','service-layer','service','业务服务'].some(t=>tags.has(t))||/(^|\/)service(s)?\//i.test(p)) return 'layer:service';
  return 'layer:service';
}
for(const n of input.fileNodes){const layer=layers.find(l=>l.id===classify(n));if(!layer)throw new Error(`无匹配层: ${n.id}`);layer.nodeIds.push(n.id)}
const all=layers.flatMap(l=>l.nodeIds), counts=new Map();for(const id of all)counts.set(id,(counts.get(id)||0)+1);
const missing=input.fileNodes.filter(n=>!counts.has(n.id)).map(n=>n.id), duplicates=[...counts].filter(([,c])=>c!==1).map(([id,c])=>({id,count:c})), extras=all.filter(id=>!byId.has(id));
if(layers.length<3||layers.length>10||layers.some(l=>!l.nodeIds.length)||all.length!==stats.fileStats.totalFileNodes||missing.length||duplicates.length||extras.length)throw new Error(JSON.stringify({layers:layers.length,counts:layers.map(l=>[l.id,l.nodeIds.length]),total:all.length,expected:stats.fileStats.totalFileNodes,missing:missing.slice(0,20),duplicates:duplicates.slice(0,20),extras:extras.slice(0,20)}));
fs.writeFileSync(outputPath,JSON.stringify(layers,null,2)+'\n');
console.log(JSON.stringify({layers:layers.map(({id,name,nodeIds})=>({id,name,count:nodeIds.length})),total:all.length,missing:missing.length,duplicates:duplicates.length,extras:extras.length},null,2));
