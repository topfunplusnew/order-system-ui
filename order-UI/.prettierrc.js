module.exports = {
  semi: false, // 禁用分号，适配 ESLint 的 semi: 0
  singleQuote: true, // 使用单引号，适配 quotes: ['error', 'single']
  trailingComma: 'none', // 禁用尾随逗号，适配 ESLint 的规则
  bracketSpacing: true, // 对象大括号内有空格，适配 object-curly-spacing: ['error', 'always']
  arrowParens: 'always', // 箭头函数参数总是带括号，未明确冲突但更通用
  htmlWhitespaceSensitivity: 'ignore', // Vue 文件中忽略 HTML 格式空格的敏感性
  vueIndentScriptAndStyle: true, // Vue 文件中的 `<script>` 和 `<style>` 标签中缩进
  endOfLine: 'lf' // 使用 LF 换行符，避免跨平台问题
}
