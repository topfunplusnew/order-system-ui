# apifox-full

请先通过 MCP 工具读取我当前光标所在文件注释里写的 APIfox 接口路径（或我手动告诉你的接口），然后严格按照 APIfox 最新文档生成 Vue2 + JavaScript 完整代码，包括：
- data() 中所有字段及初始值
- 完整的 axios 请求（带 query/body/header）
- VeeValidate 3 完整的校验 rules（必填、长度、正则、枚举全都要）
- 提交方法、错误处理、成功后的 this.$message
- 表格列或表单项全部写好
字段命名、层级、必填一项都不能错！