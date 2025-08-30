module.exports = {
	parser: 'vue-eslint-parser', // 使用 vue-eslint-parser 解析 Vue 文件
	parserOptions: {
		parser: '@babel/eslint-parser', // 使用 Babel 解析器
		requireConfigFile: false // 不需要每个包单独配置 Babel 配置
	},
	env: {
		browser: true,
		node: true,
		es2021: true
	},
	overrides: [
		{
			// 针对 Vue 2 项目
			files: ['packages/order-system/**/*'],
			extends: [
				'plugin:vue/essential',
				'eslint:recommended',
				'plugin:prettier/recommended' // 确保 Prettier 规则被应用
			],
			parser: 'vue-eslint-parser', // 使用 vue-eslint-parser 解析 Vue 文件
			parserOptions: {
				parser: '@babel/eslint-parser',
				requireConfigFile: false
			},
			rules: {
				'no-console': process.env.NODE_ENV === 'production' ? 'error' : 'off',
				'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
				'vue/multi-word-component-names': 'off', // 不校验组件名
				'vue/no-multiple-template-root': 0, // 不需要使用根元素包裹template的内容
				'vue/no-mutating-props': 0, //允许子元素通过v-model修改父元素传的props值
				'vue/no-use-v-if-with-v-for': 0, //允许v-if和v-for共存
				'vue/valid-template-root': 0, //允许只有一个template
				'no-empty': 0, //允许代码块为空
				'no-unused-vars': 0 //允许定义变量不使用
			}
		},
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
