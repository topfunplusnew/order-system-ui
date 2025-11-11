module.exports = {
    printWidth: 300, // 增加最大行宽，减少换行
    tabWidth: 4, // 保持使用 4 个空格
    useTabs: true, // 使用 tab 缩进
    semi: true, // 行尾加分号
    singleQuote: true, // 使用单引号
    quoteProps: 'as-needed', // 对象的 key 仅在必要时用引号
    jsxSingleQuote: false, // JSX 使用双引号
    trailingComma: 'none', // 不使用拖尾逗号
    bracketSpacing: true, // 在对象，数组括号与文字之间加空格
    jsxBracketSameLine: false, // JSX 标签闭合不在同一行
    htmlWhitespaceSensitivity: 'ignore', // 忽略 HTML 中的空格敏感度，避免自动换行
    arrowParens: 'avoid', // 只有一个参数的箭头函数去掉圆括号
    endOfLine: 'auto' // 保持文件原有的行尾换行符
};
