<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

## 通用要求（所有 AI 助手必须遵守）

- **沟通语言**：与用户沟通必须使用中文；如需生成 git 提交信息，也必须使用中文。
- **Git 操作**：除非用户明确要求，否则不要执行切分支、提交（commit）、推送（push）等操作（远端环境可能会自动处理这些流程）。
- **基于证据的分析**：在分析/修改代码前，必须先读取相关文件或规范，避免“凭空假设”字段、逻辑或约定。

## 前端技术栈铁律（Vue2 + JavaScript）

- **框架与语法**：仅允许 Vue2 + Options API + 纯 JavaScript；不允许 TypeScript、Vue3 Composition API、class-style 语法。
- **请求库**：统一使用 axios（若项目已统一封装为 `this.$http`，则遵循项目现状）。

## API 约束（APIfox 文档为唯一准绳）

- **写任何前端字段前必须先读文档**：涉及 data 字段、表单、请求参数、响应处理、表格列、校验规则、mock 数据、API 封装等，必须先通过 APIfox MCP 拉取对应接口的最新文档。
- **字段与规则 100% 对齐**：接口路径、方法、参数位置、字段命名（含下划线）、必填/默认值、长度、正则、枚举、嵌套结构、响应结构、错误码结构、Content-Type 必须逐条对齐文档。
- **弃用限制**：文档标记“已弃用”的接口/字段，必须拒绝使用并提示用户。
- **文档缺失处理**：若 APIfox 未找到接口或字段规则不完整，必须明确告知：
  - “APIfox 中未找到该接口”
  - 或 “字段 xxx 缺少必填/长度/正则规则，请先在 APIfox 补全文档”
- **代码生成落款**：每次生成完代码，必须附加：
  - “以上代码已严格依据 APIfox 项目《XXX》中的接口《接口名称》（路径：xxx）于 {{当前日期时间}} 的最新文档生成。如有文档更新，请重新让我读取。”

## 编码规范与项目约束

- **单文件行数**：单个文件尽量不超过 500 行；类型/常量较多时建议拆分到独立文件。
- **设计原则**：遵循 SOLID + 迪米特法则，保持单一职责与低耦合。
- **异常处理**：尽量不要使用 try/catch；优先遵循项目统一的异常处理与拦截器规范。
- **计算逻辑**：所有涉及“计算”的逻辑必须使用 mathjs 优化实现（严格执行）。
- **安全访问与默认值**：
  - 接口返回值访问优先使用可选链（`?.`）。
  - 可能为空的数组访问前使用 `|| []` 提供默认值，避免运行时错误。
- **watch/listener 副作用**：用监听器处理副作用（例如清理变量）时，必须评估是否会影响其他业务流（例如“点击修改”触发赋值从而误触发 watch）。
- **表单清空**：禁止在 `.vue` 中通过 `this.form = {}` 或手写空对象直接“清空”表单（易导致引用残留问题）；应按项目规范逐字段重置。
- **样式与结构**：CSS 尽量少且精准；能一行实现不写两行；不额外加不必要 class；不增加多余 DOM 层级/无意义 div。