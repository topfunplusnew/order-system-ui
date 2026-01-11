require('dotenv').config();

module.exports = {
  port: process.env.PORT || 3100,
  mongoUri: process.env.MONGODB_URI || 'mongodb://localhost:27017/codeless'
};
