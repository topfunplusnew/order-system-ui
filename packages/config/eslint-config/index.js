// ESLint 共享配置
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
	extends: [
		'plugin:vue/essential',
		'eslint:recommended',
		'plugin:prettier/recommended'
	],
	rules: {
		'no-console': process.env.NODE_ENV === 'production' ? 'error' : 'off',
		'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
		'vue/multi-word-component-names': 'off',
		'vue/no-multiple-template-root': 0,
		'vue/no-mutating-props': 0,
		'vue/no-use-v-if-with-v-for': 0,
		'vue/valid-template-root': 0,
		'no-empty': 0,
		'no-unused-vars': 0
	}
};

