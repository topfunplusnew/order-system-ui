/**
 * 低代码系统后端服务
 */
const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
const { initDatabase } = require('./db');

const app = express();
const PORT = process.env.CODELESS_PORT || 3100;

// 确保数据目录存在
const dataDir = path.join(__dirname, '../data');
if (!fs.existsSync(dataDir)) {
	fs.mkdirSync(dataDir, { recursive: true });
}

// 初始化数据库
initDatabase();

// 中间件
app.use(cors());
app.use(express.json({ limit: '10mb' }));

// 路由
app.use('/api/codeless/pages', require('./routes/pages'));
app.use('/api/codeless/components', require('./routes/components'));

// 健康检查
app.get('/api/codeless/health', (req, res) => {
	res.json({ code: 200, msg: '低代码服务运行正常', timestamp: new Date().toISOString() });
});

// 错误处理
app.use((err, req, res, next) => {
	console.error('服务错误:', err);
	res.status(500).json({ code: 500, msg: '服务器内部错误' });
});

app.listen(PORT, () => {
	console.log(`\n🚀 低代码系统后端服务已启动`);
	console.log(`📍 地址: http://localhost:${PORT}`);
	console.log(`📖 API 文档:`);
	console.log(`   - 页面管理: GET/POST /api/codeless/pages`);
	console.log(`   - 组件列表: GET /api/codeless/components`);
	console.log(`   - 健康检查: GET /api/codeless/health\n`);
});
