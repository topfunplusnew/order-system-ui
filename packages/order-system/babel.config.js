// 使用共享的 Babel 配置
// 注意：使用相对路径引用，避免 workspace 解析问题
const path = require('path');
const sharedBabelConfig = require(path.resolve(__dirname, '../config/babel-config'));

module.exports = {
	...sharedBabelConfig
};
