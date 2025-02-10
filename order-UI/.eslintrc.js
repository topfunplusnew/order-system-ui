module.exports = {
	root: true, // 在根目录下寻找.eslintrc.js文件，如果当前工作区打开的项目不是在根目录，则查找.eslintrc.js文件会失败，且eslint检查也不会生效
	env: {
		node: true
	},
	extends: [
		'plugin:vue/essential',
		'eslint:recommended',
		'plugin:prettier/recommended' // 冲突时使用prettier的规则进行覆盖
	],
	parserOptions: {
		parser: '@babel/eslint-parser'
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
};
