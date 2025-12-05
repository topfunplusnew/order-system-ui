// 根目录 Babel 配置
// 使用共享配置
const sharedBabelConfig = require('./packages/config/babel-config');

module.exports = {
	...sharedBabelConfig
};
