const mongoose = require('mongoose');
const config = require('./index');

/**
 * 隐藏连接字符串中的密码
 */
function maskUri(uri) {
  return uri.replace(/:([^:@]+)@/, ':***@');
}

/**
 * 连接 MongoDB
 */
async function connectDB() {
  try {
    await mongoose.connect(config.mongoUri);
    console.log('[MongoDB] 连接成功:', maskUri(config.mongoUri));
  } catch (error) {
    console.error('[MongoDB] 连接失败:', error.message);
    process.exit(1);
  }
}

module.exports = { connectDB };
