const fs=require('fs'),path=require('path'),ua='.ua',dir=ua+'/intermediate',bs=JSON.parse(fs.readFileSync(dir+'/batches.json','utf8')).batches;
const desc={
'README.md':'项目入口文档，介绍芋道 Cloud 的平台定位、前后端项目关系、内置业务模块、技术栈与演示入口。',
'SQLServer数据库表设计最佳实践.md':'汇总 SQL Server 数据库表设计规范，覆盖命名、类型、主键与索引、约束、空值、规范化、审计字段、大表分区及评审清单。',
'arch-yudao-candidate.json':'描述芋道 Cloud 架构图的结构化候选数据，包含组件、业务与基础设施边界、连接关系及说明卡片，并指定 HTML 输出文件。',
'pom.xml':'Maven 根聚合 POM，声明各业务和基础设施模块，并集中管理 Java、Spring Boot、编译器及测试插件版本。',
'yudao-cloud-architecture.html':'由 Archify 生成的交互式芋道 Cloud 微服务架构图页面，展示前端、服务层、业务域和基础设施组件，支持主题与图表操作。',
'docs/business/README.md':'业务知识文档索引，说明阅读约定并引导读者按模块查阅业务域文档。',
'docs/business/ai.md':'说明 AI 应用模块的职责边界、模型与知识库能力、主要业务流程、协作方式及实现限制。',
'docs/business/bpm.md':'说明 BPM 流程与审批能力，覆盖流程定义、请假发起、审批流转、撤销取消和抄送等流程。',
'docs/business/crm.md':'梳理 CRM 的线索、客户、公海、联系人、商机、合同与回款业务，以及权限、状态规则和跨模块协作。',
'docs/business/erp.md':'梳理 ERP 进销存主数据、采购、销售、仓储与库存流水，说明单据流转、金额库存规则和模块边界。',
'docs/business/fms.md':'梳理财务模块账套、科目、辅助核算、凭证、账簿报表、期末结转与关账流程及相关规则。',
'docs/business/hrm.md':'梳理人力资源业务域，包括招聘、员工档案、考勤请假、薪资社保和绩效流程，并说明状态与台账规则。',
'docs/business/im.md':'说明即时通信模块的好友与群组、消息收发撤回、已读补拉、频道分发及 RTC 流程。',
'docs/business/infra.md':'说明基础设施模块的文件、参数配置、数据源、代码生成、可观测性等能力及典型流程。',
'docs/business/iot.md':'梳理 IoT 设备接入、产品物模型、设备认证、属性时序、数据流转、告警及 OTA 流程。',
'docs/business/mall.md':'梳理商城商品目录、营销、交易、配送、售后与分销业务，说明多个服务的职责边界及订单闭环。',
'docs/business/member.md':'说明会员档案、分组标签、登录注册、地址、签到积分经验与等级权益等能力和业务规则。',
'docs/business/mes.md':'梳理 MES 制造执行域，包括排班资源、工艺、工单报工、质量、设备维修和仓储，并描述关键生产流程。',
'docs/business/mp.md':'说明微信公众号账号与租户路由、粉丝标签、消息回复、素材发布及回调处理流程。',
'docs/business/pay.md':'说明支付平台应用、渠道、支付单、退款转账、通知和钱包充值流程及责任边界。',
'docs/business/pms.md':'梳理项目协作与知识库能力，覆盖项目空间、工作项看板、迭代、文档权限、分享和回收恢复。',
'docs/business/report.md':'说明报表大屏创建发布及数据获取方式，区分 SQL 与 HTTP 数据接口的实际能力边界。',
'docs/business/system.md':'梳理系统管理的身份权限、组织、认证令牌、社交账号、多租户、字典、消息通知和审计流程。',
'docs/business/wms.md':'梳理 WMS 商品与仓库主数据、入库出库、移库、盘点和库存查询，说明库存规则、协作边界及端到端流程。'
};
function tags(p){if(p==='README.md')return['documentation','entry-point','platform-overview'];if(p.endsWith('.md'))return['documentation','business-domain','workflow'];if(p.endsWith('.json'))return['configuration','architecture-model','diagram-source'];if(p.endsWith('pom.xml'))return['configuration','maven','build-system'];if(p.endsWith('.html'))return['architecture-diagram','markup','interactive'];return['documentation','reference','database-design']}
function complexity(n){return n>200?'complex':n>=50?'moderate':'simple'}
for(const i of [213,214]){const b=bs.find(x=>x.batchIndex===i),x=JSON.parse(fs.readFileSync(`${ua}/tmp/ua-file-extract-results-${i}.json`,'utf8')),byPath=new Map(x.results.map(f=>[f.path,f])),nodes=[],edges=[];for(const s of b.files){const f=byPath.get(s.path),skipped=x.filesSkipped.includes(s.path);let type=s.fileCategory==='docs'?'document':s.fileCategory==='config'?'config':s.fileCategory==='infra'?'service':'file';let lines=f?.nonEmptyLines??s.sizeLines,summary=desc[s.path]||`说明${f?.sections?.[0]?.heading||path.basename(s.path)}的项目用途与主要内容。`;if(skipped&&s.path.endsWith('.html'))lines=s.sizeLines;nodes.push({id:`${type}:${s.path}`,type,name:path.basename(s.path),filePath:s.path,summary,tags:tags(s.path),complexity:complexity(lines)});}if(i===213){const source='config:arch-yudao-candidate.json',target='file:yudao-cloud-architecture.html';edges.push({source,target,type:'generates',direction:'forward',weight:.9})}const seen=new Set();const de=edges.filter(e=>{const k=`${e.source}|${e.target}|${e.type}`;if(seen.has(k))return false;seen.add(k);return true});const out=path.join(dir,`batch-${i}.json`);for(const n of fs.readdirSync(dir))if(new RegExp(`^batch-${i}(?:-part-\\d+)?\\.json$`).test(n))fs.unlinkSync(path.join(dir,n));fs.writeFileSync(out,JSON.stringify({nodes,edges:de},null,2)+'\n');console.log(JSON.stringify({batchIndex:i,inputFiles:b.files.length,analyzed:x.filesAnalyzed,skipped:x.filesSkipped.length,unreadable:x.filesUnreadable.length,nodes:nodes.length,edges:de.length,imports:de.filter(e=>e.type==='imports').length}));}
