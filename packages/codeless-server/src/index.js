const express = require('express');
const cors = require('cors');
const config = require('./config');
const { connectDB } = require('./config/db');
const dataRoutes = require('./routes/data');

const app = express();

// 中间件
app.use(cors());
app.use(express.json());

// 路由
app.use('/codeless/data', dataRoutes);

// 健康检查
app.get('/codeless/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// 启动服务
async function start() {
  await connectDB();
  
  app.listen(config.port, () => {
    console.log(`[CodeLess Server] 服务已启动: http://localhost:${config.port}`);
    console.log(`[CodeLess Server] API 路径: /codeless/data/:schemaKey`);
  });
}

start().catch(err => {
  console.error('[CodeLess Server] 启动失败:', err);
  process.exit(1);
});
