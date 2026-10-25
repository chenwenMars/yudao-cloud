import json,datetime
from pathlib import Path
root=Path('/Users/chenwen/workspace2/yudao-cloud')
g=json.load(open(root/'.ua/knowledge-graph.json')); files={n.get('filePath') for n in g['nodes']}
base='src/main/java/cn/iocoder/yudao/module/'
bpm='yudao-module-bpm/yudao-module-bpm-server/'+base+'bpm/'
bapi='yudao-module-bpm/yudao-module-bpm-api/'+base+'bpm/'
crm='yudao-module-crm/yudao-module-crm-server/'+base+'crm/'
hrm='yudao-module-hrm/yudao-module-hrm-server/'+base+'hrm/'
ns=[];es=[]
def node(i,t,name,summary,path=None,meta=None):
 n={'id':i,'type':t,'name':name,'summary':summary,'tags':['业务审批','流程集成'],'complexity':'moderate'}
 if path:
  assert path in files,path
  n['filePath']=path
 if meta:n['domainMeta']=meta
 ns.append(n)
def domain(k,name,summary,entities,rules,interactions):
 node('domain:'+k,'domain',name,summary,meta={'entities':entities,'businessRules':rules,'crossDomainInteractions':interactions})
def flow(dom,k,name,summary,entry,typ,steps):
 fid='flow:'+k
 node(fid,'flow',name,summary,meta={'entryPoint':entry,'entryType':typ});es.append({'source':'domain:'+dom,'target':fid,'type':'contains_flow','direction':'forward','weight':1.0})
 for i,(sk,sn,ss,sp) in enumerate(steps,1):
  sid='step:'+k+':'+sk;node(sid,'step',sn,ss,sp);es.append({'source':fid,'target':sid,'type':'flow_step','direction':'forward','weight':round(i/len(steps),3)})
domain('contract-approval','CRM 合同审批','管理合同提交审批与审批结果回写。现有 CRM 示例同时包含业务服务接收端和 BPM 服务内的远程结果桥接。',['合同','审批状态','流程实例编号'],['提交前校验合同处于 DRAFT。','业务编号作为 businessKey，流程实例编号回写合同。'],['通过 BPM Feign API 发起流程。','BPM 结果桥接通过 HTTP 调用 CRM 回写接口。'])
domain('workflow-execution','BPM 流程执行与结果分发','负责按流程定义启动实例、处理任务审批并发布流程状态事件。Spring 应用事件只在当前进程传播；跨服务业务通过已注册桥接转发结果。',['流程定义','流程实例','审批任务','状态事件'],['按流程定义 key 查找可用定义并校验发起权限和自选审批人。','自定义业务以 businessKey 关联实例。','processAfterTriggerSetting 仅在通过分支执行，不能替代拒绝和撤销结果处理。'],['向 CRM 服务转发合同状态事件。','本地业务监听器可直接消费同进程应用事件。'])
domain('leave-approval','HRM 请假审批','提供请假申请、取消及审批状态更新能力。现有请假监听器是本地 Spring 组件，图谱明确区分它与 CRM 的跨服务回调方案。',['请假单','流程实例编号','审批状态'],['回写需匹配流程实例且单据处于 RUNNING。','采用带状态条件的 Mapper 更新避免覆盖已变更记录。','现有 BPM RPC 配置未注册 HRM 桥接，独立部署需补齐结果投递。'],['调用 BPM 流程实例 API。','通过本地状态事件监听器进入请假审批状态更新。'])
cs=crm+'service/contract/CrmContractServiceImpl.java'
flow('contract-approval','submit-contract','提交合同审批','展示现有合同从草稿到审批中的业务接入路径。','CrmContractServiceImpl.submitContract','manual',[
 ('check-draft','校验可提交状态','提交前校验合同处于 DRAFT，业务服务保留单据状态的决定权。',cs),
 ('create-instance','调用 BPM 创建实例','使用 crm-contract-audit 流程定义 key、合同编号 businessKey 和发起人调用 BpmProcessInstanceApi.createProcessInstance，并检查远程结果。',bapi+'api/task/BpmProcessInstanceApi.java'),
 ('save-instance','保存实例和审批中状态','将返回的流程实例编号和 PROCESS 状态保存到合同，建立业务记录与流程实例的双向关联。',cs)])
flow('contract-approval','receive-contract-result','接收合同审批结果','展示 BPM 远程桥接到 CRM 业务回写入口的现有实现。','POST /rpc-api/crm/contract/update-audit-status','http',[
 ('receive-event','接收状态事件','CRM RestController 监听器接收流程状态事件；载荷含业务编号和流程状态。',crm+'service/contract/listener/CrmContractStatusListener.java'),
 ('resolve-contract','按 businessKey 定位合同','从事件 businessKey 转换合同编号，并将流程状态交给合同服务处理。',crm+'service/contract/listener/CrmContractStatusListener.java'),
 ('update-audit','回写业务审批状态','合同服务 updateContractAuditStatus 负责流程结果与合同审批状态的衔接及持久化。',cs)])
ps=bpm+'service/task/BpmProcessInstanceServiceImpl.java'
flow('workflow-execution','start-and-approve','创建实例与处理审批','BPM 接受业务发起请求，建立流程实例并通过任务服务处理审批动作。','BpmProcessInstanceApi.createProcessInstance','http',[
 ('resolve-definition','解析流程定义','按请求的 processDefinitionKey 查找可用流程定义，为业务单据选择对应审批模型。',ps),
 ('validate-start','校验发起与审批人','检查发起权限和发起人选择的审批人，保证流程定义约束得到执行。',ps),
 ('start-engine','启动流程实例','传入 businessKey 与变量启动引擎，并返回实例编号给业务模块。',ps),
 ('handle-task','处理同意或拒绝','BpmTaskServiceImpl 的 approveTask、rejectTask 承担任务审批动作；业务模块通过流程状态结果获知最终处理。',bpm+'service/task/BpmTaskServiceImpl.java')])
flow('workflow-execution','dispatch-process-result','分发流程结果','从引擎流程完成处理，经本地应用事件，再由 CRM 桥接转发至业务服务。该桥接在 RPC 配置中按缺少同名本地监听器的条件注册。','BpmProcessInstanceServiceImpl.processProcessInstanceCompleted','event',[
 ('complete-instance','处理流程完成','处理流程实例完成和最终状态；模型配置的完成后 HTTP 触发设置仅在通过分支执行。',ps),
 ('publish-event','发布状态应用事件','发布携带实例编号、定义 key、状态、原因和 businessKey 的 Spring 应用事件。',bpm+'framework/flowable/core/event/BpmProcessInstanceEventPublisher.java'),
 ('select-listener','匹配流程监听器','状态事件监听器按流程定义 key 路由；RPC 配置以 ConditionalOnMissingBean 条件注册 CRM 远程桥接。',bpm+'framework/rpc/config/RpcConfiguration.java'),
 ('forward-crm','转发到 CRM 服务','BPM 内的合同监听器通过负载均衡 RestTemplate 调用 crm-server 的合同状态回写接口。',bpm+'api/event/CrmContractStatusListener.java')])
hs=hrm+'service/attendance/record/HrmAttendanceLeaveServiceImpl.java'
flow('leave-approval','create-leave','创建请假审批申请','HRM 请假服务负责业务申请数据，并依赖 BPM 创建实例 API 衔接工作流。此流程不表示远程回调链已配置完毕。','HrmAttendanceLeaveServiceImpl.createLeave','manual',[
 ('accept-leave','处理请假申请','createLeave 接收请假业务申请并组织记录创建与流程发起。',hs),
 ('build-request','构造流程创建请求','使用 BpmProcessInstanceCreateReqDTO 提供流程定义 key、businessKey、变量和可选自选审批人。',bapi+'api/task/dto/BpmProcessInstanceCreateReqDTO.java'),
 ('invoke-bpm','调用流程实例 API','请假服务通过 BpmProcessInstanceApi 调用流程实例能力；具体持久化步骤应以服务源码为准。',bapi+'api/task/BpmProcessInstanceApi.java')])
flow('leave-approval','update-leave-result','本地请假审批结果回写','展示 HRM 本地监听器到请假数据条件更新的路径。独立部署时该本地事件链不会自动跨服务，需要另行配置远程结果投递。','HrmAttendanceLeaveStatusListener','event',[
 ('listen-locally','监听同进程状态事件','HrmAttendanceLeaveStatusListener 为本地组件；当前 BPM RPC 配置未注册 HRM 对应远程桥接。',hrm+'service/attendance/record/listener/HrmAttendanceLeaveStatusListener.java'),
 ('validate-instance','核对实例与审批中状态','updateLeaveApprovalStatus 校验事件对应实例与记录一致，且请假单当前处于 RUNNING。',hs),
 ('conditional-update','按条件回写状态','通过 Mapper 的条件更新写入审批结果，避免并发或旧事件覆盖已经变化的状态。',hrm+'dal/mysql/attendance/record/HrmAttendanceLeaveMapper.java')])
for a,b,d in [('contract-approval','workflow-execution','合同服务通过 BPM API 发起 crm-contract-audit 流程。'),('workflow-execution','contract-approval','已注册 CRM 桥接将流程事件 HTTP 转发给合同回写入口。'),('leave-approval','workflow-execution','请假服务调用流程实例 API；独立部署时还需补齐远程结果回传。'),('workflow-execution','leave-approval','同进程可由 HRM 本地监听器消费事件；当前无 HRM 远程桥接。')]:
 es.append({'source':'domain:'+a,'target':'domain:'+b,'type':'cross_domain','direction':'forward','description':d,'weight':0.6})
p=dict(g['project']);p['description']='审批业务接入专题：CRM 合同远程审批闭环、BPM 流程执行与 HRM 请假本地结果回写。基于现有知识图谱及本轮源码核对，未进行运行时联调。';p['analyzedAt']=datetime.datetime.now(datetime.timezone.utc).isoformat()
out={'version':'1.0.0','project':p,'nodes':ns,'edges':es,'layers':[],'tour':[]}
ids={n['id'] for n in ns};assert len(ids)==len(ns)
assert all(e['source'] in ids and e['target'] in ids and e['source']!=e['target'] and 0<=e['weight']<=1 for e in es)
for f in [n for n in ns if n['type']=='flow']:
 weights=[e['weight'] for e in es if e['source']==f['id'] and e['type']=='flow_step'];assert weights==sorted(set(weights))
(root/'.ua/intermediate/domain-analysis.json').write_text(json.dumps(out,ensure_ascii=False,indent=2)+'\n')
print({t:sum(n['type']==t for n in ns) for t in ['domain','flow','step']},'edges',len(es))
