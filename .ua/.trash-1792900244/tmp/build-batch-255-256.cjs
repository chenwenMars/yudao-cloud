const fs = require('fs');
const path = require('path');
const ua = '.ua';
const dir = ua + '/intermediate';
const batches = JSON.parse(fs.readFileSync(dir + '/batches.json', 'utf8')).batches;
const roles = {
  ip: '提供 IP 地址归属地与行政区划编码查询相关资源。',
  tenant: '实现多租户隔离能力及其与 Web、数据访问、异步任务和消息队列的集成。',
  env: '支持开发环境拓展与环境上下文处理。',
  excel: '提供 Excel 导入导出、单元格格式和字典翻译支持。',
  job: '配置 XXL-JOB 定时任务与 Spring Async 异步执行能力。',
  monitor: '配置链路追踪与应用指标采集能力。',
  mq: '提供 Redis、RabbitMQ 等消息队列基础设施及自动配置。',
  mybatis: '提供数据源、MyBatis-Plus 查询和数据翻译扩展。',
  protection: '提供幂等、分布式锁、限流与 API 签名等保护能力。'
};
function moduleOf(p) {
  if (p.includes('biz-ip')) return 'ip';
  if (p.includes('biz-tenant')) return 'tenant';
  if (p.includes('starter-env')) return 'env';
  if (p.includes('starter-excel')) return 'excel';
  if (p.includes('starter-job')) return 'job';
  if (p.includes('starter-monitor')) return 'monitor';
  if (p.includes('starter-mq')) return 'mq';
  if (p.includes('starter-mybatis')) return 'mybatis';
  if (p.includes('starter-protection')) return 'protection';
  return 'framework';
}
function summary(p) {
  const m = moduleOf(p);
  const base = path.basename(p);
  if (base === 'pom.xml') return roles[m];
  if (base === 'area.csv') return '提供行政区划编码与名称的 CSV 查找数据，包含地区类型和父级编码字段。';
  if (base === 'ip2region.xdb') return '提供 ip2region 使用的二进制 IP 归属地数据库文件，供地址定位能力查询。';
  if (base === 'spring.factories') return '通过 Spring Boot EnvironmentPostProcessor 注册机制加载租户或开发环境处理器。';
  if (base === 'AutoConfiguration.imports') return `通过 Spring Boot 自动配置导入清单注册${roles[m]}`;
  if (base === 'package-info.java') {
    const source = fs.readFileSync(p, 'utf8');
    const comment = source.match(/\/\*\*([\s\S]*?)\*\//);
    return comment ? comment[1].replace(/^\s*\* ?/gm, '').trim().replace(/\s+/g, ' ').slice(0, 240) : `声明 ${m} 相关 Java 包。`;
  }
  if (p.includes('TenantKafkaEnvironmentPostProcessor')) return '在 Spring 环境初始化阶段处理 Kafka 配置，使多租户消息上下文可与 Kafka 集成。';
  if (p.endsWith('PoiExcelUtils.java')) return '提供基于 Apache POI 的 Excel 单元格读取、内容写入、表头合并、批注和样式创建工具。';
  if (p.endsWith('ExcelUtilsTest.java')) return '验证 Excel 读取工具的最大行数限制行为。';
  if (p.endsWith('XxlJobProperties.java')) return '承载 XXL-JOB 执行器的配置属性。';
  if (p.endsWith('YudaoAsyncAutoConfiguration.java')) return '自动配置 Spring Async 线程池处理器，用于异步线程上下文传递相关增强。';
  if (p.endsWith('YudaoXxlJobAutoConfiguration.java')) return '自动配置 XXL-JOB 执行器 Bean。';
  if (p.endsWith('TracerProperties.java')) return '承载链路追踪相关配置属性。';
  if (p.endsWith('YudaoMetricsAutoConfiguration.java')) return '自动为 Micrometer 指标添加应用公共标签。';
  if (p.endsWith('YudaoRabbitMQAutoConfiguration.java')) return '自动配置 RabbitMQ 消息转换器。';
  if (p.endsWith('DataSourceEnum.java')) return '定义主库与从库等数据源标识。';
  if (p.endsWith('LambdaQueryWrapperXTest.java')) return '验证 Lambda 查询包装器的范围条件等扩展行为。';
  if (p.endsWith('QueryWrapperXTest.java')) return '验证字符串字段查询包装器的范围条件扩展行为。';
  if (p.endsWith('Lock4jRedisKeyConstants.java')) return '集中定义 Lock4j 分布式锁使用的 Redis 键常量。';
  return roles[m];
}
function role(p) {
  if (p.includes('/src/test/')) return 'test';
  if (p.endsWith('package-info.java')) return 'package';
  if (p.includes('/config/')) return 'configuration';
  if (p.includes('/core/util/')) return 'utility';
  if (p.includes('/enums/')) return 'enum';
  if (p.includes('/resources/')) return 'resource';
  return 'java-component';
}
const tagMap = {
  test: ['test', 'unit-test', 'framework'],
  package: ['package-info', 'module-boundary', 'framework'],
  configuration: ['configuration', 'autoconfiguration', 'spring-boot'],
  utility: ['utility', 'excel', 'apache-poi'],
  enum: ['enum', 'data-source', 'persistence'],
  resource: ['configuration', 'spring-boot', 'resource-registration'],
  'java-component': ['java', 'framework', 'component']
};
function complexity(n) { return n > 200 ? 'complex' : n >= 50 ? 'moderate' : 'simple'; }
function action(n) {
  const spaced = n.replace(/([a-z0-9])([A-Z])/g, '$1 $2').replace(/_/g, ' ').toLowerCase();
  if (spaced.startsWith('test')) return `验证${spaced.replace(/^test\s*/, '') || '组件行为'}`;
  if (/^(get|find|query|select|read)/.test(spaced)) return `读取或查询${spaced.replace(/^(get|find|query|select|read)\s*/, '') || '数据'}`;
  if (/^(write|create|merge|add)/.test(spaced)) return `生成或写入${spaced.replace(/^(write|create|merge|add)\s*/, '') || '内容'}`;
  return `处理${spaced}相关逻辑`;
}
for (const batchIndex of [255, 256]) {
  const batch = batches.find(x => x.batchIndex === batchIndex);
  const extraction = JSON.parse(fs.readFileSync(`${ua}/tmp/ua-file-extract-results-${batchIndex}.json`, 'utf8'));
  const results = new Map(extraction.results.map(x => [x.path, x]));
  const nodes = [];
  const edges = [];
  const ids = new Set();
  function add(n) { if (!ids.has(n.id)) { ids.add(n.id); nodes.push(n); } }
  const fileIds = new Map();
  for (const file of batch.files) {
    const result = results.get(file.path);
    const nodeType = file.fileCategory === 'config' ? 'config' : 'file';
    const id = `${nodeType}:${file.path}`;
    fileIds.set(file.path, id);
    const r = role(file.path);
    add({ id, type: nodeType, name: path.basename(file.path), filePath: file.path, summary: summary(file.path), tags: tagMap[r] || ['java', 'framework', 'component'], complexity: complexity(result?.nonEmptyLines ?? file.sizeLines) });
  }
  for (const file of batch.files) {
    const result = results.get(file.path);
    if (!result) continue;
    const fileId = fileIds.get(file.path);
    const r = role(file.path);
    const exported = new Set((result.exports || []).map(x => x.name));
    const significantFunctions = new Set();
    for (const item of result.classes || []) {
      const lines = item.endLine - item.startLine + 1;
      if ((item.methods || []).length < 2 && lines < 20 && !exported.has(item.name)) continue;
      const id = `class:${file.path}:${item.name}`;
      add({ id, type: 'class', name: item.name, filePath: file.path, lineRange: [item.startLine, item.endLine], summary: `${item.name}：${summary(file.path)}`, tags: tagMap[r] || ['java', 'framework', 'component'], complexity: complexity(lines) });
      edges.push({ source: fileId, target: id, type: 'contains', direction: 'forward', weight: 1 });
      if (exported.has(item.name)) edges.push({ source: fileId, target: id, type: 'exports', direction: 'forward', weight: .8 });
    }
    const functionMap = new Map();
    for (const fn of result.functions || []) {
      const previous = functionMap.get(fn.name);
      if (!previous || fn.endLine - fn.startLine > previous.endLine - previous.startLine) functionMap.set(fn.name, fn);
    }
    for (const fn of functionMap.values()) {
      const lines = fn.endLine - fn.startLine + 1;
      if (lines < 10 && !exported.has(fn.name)) continue;
      significantFunctions.add(fn.name);
      const id = `function:${file.path}:${fn.name}`;
      add({ id, type: 'function', name: fn.name, filePath: file.path, lineRange: [fn.startLine, fn.endLine], summary: `${action(fn.name)}。`, tags: tagMap[r] || ['java', 'framework', 'component'], complexity: complexity(lines) });
      edges.push({ source: fileId, target: id, type: 'contains', direction: 'forward', weight: 1 });
      if (exported.has(fn.name)) edges.push({ source: fileId, target: id, type: 'exports', direction: 'forward', weight: .8 });
    }
    for (const call of result.callGraph || []) {
      if (call.caller === call.callee || !significantFunctions.has(call.caller) || !significantFunctions.has(call.callee)) continue;
      edges.push({ source: `function:${file.path}:${call.caller}`, target: `function:${file.path}:${call.callee}`, type: 'calls', direction: 'forward', weight: .8 });
    }
  }
  const uniqueEdges = [];
  const edgeKeys = new Set();
  for (const edge of edges) {
    const key = `${edge.source}|${edge.target}|${edge.type}`;
    if (!edgeKeys.has(key)) { edgeKeys.add(key); uniqueEdges.push(edge); }
  }
  const expectedImports = Object.values(batch.batchImportData || {}).reduce((n, xs) => n + xs.length, 0);
  const imports = uniqueEdges.filter(e => e.type === 'imports').length;
  if (imports !== expectedImports) throw new Error(`imports ${imports}/${expectedImports}`);
  const sortedPaths = [...new Set(nodes.map(n => n.filePath))].sort();
  const bins = [];
  let current = { paths: [], nodes: [], edges: [] };
  for (const p of sortedPaths) {
    const ns = nodes.filter(n => n.filePath === p);
    const sourceIds = new Set(ns.map(n => n.id));
    const es = uniqueEdges.filter(e => sourceIds.has(e.source));
    if (current.paths.length && (current.nodes.length + ns.length > 60 || current.edges.length + es.length > 120)) {
      bins.push(current);
      current = { paths: [], nodes: [], edges: [] };
    }
    current.paths.push(p); current.nodes.push(...ns); current.edges.push(...es);
  }
  if (current.paths.length) bins.push(current);
  for (const filename of fs.readdirSync(dir)) if (new RegExp(`^batch-${batchIndex}(?:-part-\\d+)?\\.json$`).test(filename)) fs.unlinkSync(path.join(dir, filename));
  bins.forEach((bin, index) => fs.writeFileSync(path.join(dir, bins.length === 1 ? `batch-${batchIndex}.json` : `batch-${batchIndex}-part-${index + 1}.json`), JSON.stringify({ nodes: bin.nodes, edges: bin.edges }, null, 2) + '\n'));
  console.log(JSON.stringify({ batchIndex, inputFiles: batch.files.length, extracted: extraction.filesAnalyzed, skipped: extraction.filesSkipped.length, unreadable: extraction.filesUnreadable.length, nodes: nodes.length, edges: uniqueEdges.length, imports, parts: bins.map(x => ({ files: x.paths.length, nodes: x.nodes.length, edges: x.edges.length })) }));
}
