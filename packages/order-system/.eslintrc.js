// 使用共享的 ESLint 配置
// 注意：由于 ESLint 可能无法直接解析 workspace 包，使用相对路径
const path = require('path');
const sharedConfig = require(path.resolve(__dirname, '../config/eslint-config'));

module.exports = {
	...sharedConfig
};
