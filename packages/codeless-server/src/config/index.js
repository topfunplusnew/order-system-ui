const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../.env') });

module.exports = {
  port: process.env.PORT || 3100,
  mongoUri: process.env.MONGODB_URI || 'mongodb://localhost:27017/codeless'
};
