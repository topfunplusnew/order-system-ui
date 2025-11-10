// 根目录 ESLint 配置
// 注意：子包有自己的 .eslintrc.js，这里只配置根目录文件
module.exports = {
    parser: 'vue-eslint-parser',
    parserOptions: {
        parser: '@babel/eslint-parser',
        requireConfigFile: false
    },
    env: {
        browser: true,
        node: true,
        es2021: true
    },
    // 根目录不处理 packages 下的文件，由各自的 .eslintrc.js 处理
    ignorePatterns: ['packages/**'],
    overrides: [
        {
            // 针对 React 项目
            files: ['packages/react-project/**/*'],
            extends: [
                'eslint:recommended',
                'plugin:react/recommended' // React 推荐规则
            ],
            parserOptions: {
                parser: '@babel/eslint-parser'
            },
            settings: {
                react: {
                    version: 'detect' // 自动检测 React 版本
                }
            }
        },
        {
            // 针对 Node.js 项目
            files: ['packages/node-project/**/*'],
            extends: [
                'eslint:recommended',
                'plugin:node/recommended' // Node.js 推荐规则
            ],
            env: {
                node: true,
                es2021: true
            }
        }
    ],
    rules: {
        // 全局规则可以在这里添加
    }
};
