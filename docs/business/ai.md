# AI 应用模块业务知识

> 本文依据当前工作区源码进行静态分析，未启动服务、未调用模型、未验证外部供应商或向量存储的运行行为。数据库结构见 [ai.sql](../../sql/mysql/ai.sql)，对象关系见 [AI ER 图](../er/ai-er.drawio)。

## 1. 定位、使用者与责任边界

AI 模块把模型配置、聊天、知识库检索与内容生成组织成可管理的业务功能。它的调用者主要是管理后台中的登录用户：普通使用者操作“我的”对话和创作记录，管理员维护密钥、模型、角色、工具及全局记录。所有控制器目前位于 `controller/admin`，不能据此声称已经存在面向匿名访客的独立 AI 门户或会员计费产品。

这里的“角色”是提示词和能力配置：它可绑定模型、知识库、工具和 MCP 客户端名称；不是组织权限角色，也不是能够自主承接任意业务的通用代理。模型执行交给 Spring AI 或特定供应商适配器；本模块保留配置、输入、输出、检索引用和生成任务身份。默认模型按类型从已启用模型中选取，没有可用默认模型会抛业务异常；指定模型也要校验启用状态。[模型选择与工厂调用](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/model/AiModelServiceImpl.java:99)

## 2. 各业务域提供什么能力

| 业务域 | 操作对象、动作与结果 |
|---|---|
| 模型与密钥 | 维护供应商平台、密钥、接入URL、模型标识、模型类型和生成参数；为聊天、Embedding、图片等调用创建相应客户端。密钥记录不等于一次推理结果。 |
| 聊天角色与工具 | 维护角色设定、关联模型和能力列表；工具管理保存已有可解析工具的名称、描述等配置，创建/更新时通过 `ToolCallbackResolver` 验证工具存在，并不上传或动态编译任意Java代码。 |
| 对话与消息 | 创建“我的”对话、修改标题/模型/置顶、查询和删除消息；支持整段返回和流式返回，管理员另有全局分页与删除入口。 |
| 知识库 | 管理知识库、文档、段落、启停与检索测试；下载文件后提取文本、切分、写关系库与向量存储，检索返回段落、分数和文档信息。 |
| 图片 | 普通图片生成、公开作品列表、个人记录；Midjourney另有任务提交、进展通知、同步和Action二次生成。 |
| 音乐 | 经Suno适配器提交生成、同步任务进展，管理音频/视频/封面与公开状态。 |
| 写作与思维导图 | 按输入及助手角色构造Prompt，流式生成文本并保存记录；导图后端返回模型生成内容，不能把这里写成服务器完成了可视化图形排版。 |
| 工作流 | 保存名称、code与graph配置，提供测试执行入口；不是BPM审批流，也未在这里发现完整的发布版本、运行实例、人工任务及调度体系。 |

工具名称的真实解析见 [AiToolServiceImpl](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/model/AiToolServiceImpl.java:75)。工作流测试实现见 [testWorkflow](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/workflow/AiWorkflowServiceImpl.java:111)。

## 3. 核心对象及关系

`ai_api_key → ai_model` 是接入配置层；`ai_chat_role` 组织能力，`ai_chat_conversation` 保存用户当前会话的模型和参数快照，`ai_chat_message` 属于会话。助手消息的 `reply_id` 指向对应用户消息，由此形成问答对；历史上下文按问答组筛选，不是简单把整张消息表全部塞入Prompt。

知识库由 `ai_knowledge → ai_knowledge_document → ai_knowledge_segment` 组成；段落既保存文本和检索次数，也保存外部向量记录的 `vector_id`。角色的 `knowledge_ids/tool_ids` 和消息的 `segment_ids` 是集合字段，不是中间表。`mcp_client_names` 引用应用配置中的客户端名称，不能在ER图中虚构MCP客户端数据库表。`ai_workflow.graph` 是JSON文本，图片和音乐的 `task_id` 是外部服务任务身份。

对话创建会从角色或默认模型复制参数；角色变更与既有会话参数并非天然实时同步。[对话创建](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/chat/AiChatConversationServiceImpl.java:58)

## 4. 主要端到端流程

### 4.1 带知识库、工具的聊天

1. 用户选择角色创建对话，服务取得角色模型或默认聊天模型，保存会话所属用户、模型标识及温度、Token和上下文数量等参数。
2. 发送消息时先校验会话存在且属于当前用户，再校验模型，读取会话历史；知识召回由会话绑定角色的 `knowledge_ids` 驱动。不能仅因请求VO出现 `knowledgeId` 就断言已经按该参数直接完成任意知识库绑定。
3. 如请求开启联网且搜索组件已配置，执行联网检索；随后保存用户消息和内容暂为空的助手消息，助手记录关联问答与引用段落。
4. Prompt依次组织系统设定、选中的历史问答、当前问题、知识引用、网页摘要和附件文本。工具列表来自角色绑定的本地工具名与匹配到的MCP客户端。
5. 调用模型后回写回答和推理内容；返回的引用段落补充文档名称。流式路径逐块返回，完成时持久化累计内容；异常或取消时保存已有部分，没有内容则删除助手占位记录。该处理不能描述为失败后自动切换供应商。

流程入口与权限归属见 [发送消息](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/chat/AiChatMessageServiceImpl.java:150)，Prompt与工具装配见 [buildPrompt](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/chat/AiChatMessageServiceImpl.java:331)，流式完成/失败处理见 [流式持久化](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/chat/AiChatMessageServiceImpl.java:273)。

### 4.2 文档进入知识库并被检索

管理员选择知识库和文件URL；服务验证知识库，下载文件并由 `TikaDocumentReader` 读取文本，保存文档内容、字符数和估算Token，再异步切分。段落写关系库后写入VectorStore，并把生成的向量ID回写段落；知识库ID、文档ID和段落ID作为向量元数据。预览切片与正式入库不是同一个操作结果。[文档导入](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/knowledge/AiKnowledgeDocumentServiceImpl.java:77)、[段落入库](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/knowledge/AiKnowledgeSegmentServiceImpl.java:95)

查询时按知识库ID过滤向量检索，取配置的topK与相似度阈值；如果注入了Rerank模型，先扩大召回范围，再重排和阈值过滤。找到段落后回查关系库并增加召回次数。禁用文档会删除对应段落/向量，启用时重新切分；修改最大切片Token也可能触发重建。这些操作涉及关系库与外部/内存向量存储，不能把数据库事务视为覆盖整个索引链路。[检索与重排](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/knowledge/AiKnowledgeSegmentServiceImpl.java:289)

### 4.3 图片与音乐生成

普通绘图先插入“进行中”记录，再异步调用ImageModel，取得图片后下载并经 `FileApi` 保存，成功时记录地址，失败时记录错误及失败状态。Midjourney提交返回外部taskId，后续通知或同步推进状态；Action会产生新生成记录。音乐经Suno提交后保留任务记录，由同步函数读取外部状态，完成后转存媒体文件。业务上的“提交成功”只表示取得任务，不等于作品生成成功。[绘图执行](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/image/AiImageServiceImpl.java:93)、[音乐生成与同步](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/music/AiMusicServiceImpl.java:54)

### 4.4 工作流测试

用户可传临时graph或指定已保存工作流；服务解析JSON，遍历nodes，对 `llmNode` 按 `llmId` 注册Tinyflow的LLM provider，随后将params作为变量执行 `toChain().executeForResult`。`internalNode` 在本服务switch中没有额外处理，其他节点也没有这里自建的实现分支；实际节点执行能力需继续查Tinyflow及前端图配置，不能凭节点名字许诺SQL执行、任意HTTP、持久化重试等能力。

目前provider适配显式包含通义千问和Ollama，代码注释保留多模型链路与Spring AI整合TODO；模型配置列表的供应商数量不等于工作流支持的供应商数量。[graph执行](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/workflow/AiWorkflowServiceImpl.java:125)、[Tinyflow模型适配](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/model/AiModelServiceImpl.java:178)

## 5. 状态、协作及典型场景

模型、密钥、知识文档等启停沿用通用状态；图片/音乐区分进行中、成功和失败，公开状态是另一个维度。写作和导图主要以生成正文/错误信息记录结果，并没有与图片完全一致的一套任务状态机。[写作结果保存](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/write/AiWriteServiceImpl.java:65)

真实跨模块调用包括：用户资料工具调用 `AdminUserApi`，生成媒体调用 `FileApi`。角色的用户编号是系统用户引用，但数据库里有用户ID并不能证明每次操作都远程调用用户服务。联网搜索、MCP、供应商API、Tika、Tinyflow及向量存储属于外部组件或基础设施，不能写成业务数据库的直属子表。

典型场景：内部制度问答使用角色绑定知识库，回答附带段落溯源；运营人员用图片/音乐生成并管理公开作品；后台用户借写作助手改写文本；开发者保存graph后在测试入口验证变量和LLM节点组合。这里未发现按会话扣费、余额账本、模型质量评测平台或工作流人工审批，交接时应分别评估，不能作为已实现能力。

## 6. 当前实现局限与阅读重点

- 当前VectorStore创建路径明确使用 `SimpleVectorStore.class`，部署后的持久化、容量和重启恢复不能按“已具备生产向量数据库集群”来介绍。[向量存储选择](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/service/model/AiModelServiceImpl.java:159)
- `weather_query` 是随机模拟天气；`directory_list` 读取服务所在机器的目录，不是用户电脑文件浏览器；`user_profile_query` 才有真实用户API调用。工具能被模型调用不等于已具备业务审批和权限决策。[模拟天气](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/tool/function/WeatherQueryToolFunction.java:102)、[用户资料工具](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/tool/function/UserProfileQueryToolFunction.java:77)、[目录工具](/Users/chenwen/workspace2/yudao-cloud/yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/tool/function/DirectoryListToolFunction.java:81)
- 历史知识库/搜索是否重新拼接仍有TODO；写作、导图、聊天的流式取消和错误保存路径应分别阅读，不能用一种行为概括全部生成业务。
- 供应商连通性、MCP客户端实际连接、搜索组件启用、异步执行器及媒体转存均未在本文运行验证。

## 7. Controller 包覆盖清单与阅读顺序

所有路径相对于AI服务器的 `controller/`；同一包内同时存在个人操作和管理员全局操作时，应逐接口检查权限注解。

| 包 | 已覆盖控制器 | 业务入口 |
|---|---|---|
| `admin/model` | AiApiKey、AiModel、AiChatRole、AiTool | 密钥/模型/角色/工具维护与可用列表 |
| `admin/chat` | AiChatConversation、AiChatMessage | 我的会话、同步/流式消息、全局记录 |
| `admin/knowledge` | AiKnowledge、AiKnowledgeDocument、AiKnowledgeSegment | 知识库、文档、切片预览、段落检索与启停 |
| `admin/image` | AiImage | 绘图、公开作品、Midjourney通知和Action |
| `admin/music` | AiMusic | Suno生成、个人和全局音乐记录 |
| `admin/write` | AiWrite | 写作生成与历史记录 |
| `admin/mindmap` | AiMindMap | 导图内容生成与历史记录 |
| `admin/workflow` | AiWorkflow | graph配置与测试执行 |

建议按“对话Controller → ChatConversation/ChatMessage Service → 角色与模型 → 知识段落检索 → 工具实现 → 图工作流”阅读；附件与供应商差异最后沿各适配器确认，不从ER图推断运行流程。
