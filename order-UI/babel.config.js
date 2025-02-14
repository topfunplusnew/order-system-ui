module.exports = {
	presets: [
		'@babel/preset-env', // 转换 ES6+ 语法
		'@babel/preset-react' // 如果你使用 React
	],
	plugins: [
		'@babel/plugin-transform-runtime', // 支持 async/await 等语法
		'@babel/plugin-proposal-class-properties' // 支持类属性
	],
	overrides: [
		{
			test: './apps/order-system', // 可以为特定包配置不同的设置
			presets: ['@babel/preset-env']
		}
	]
};
