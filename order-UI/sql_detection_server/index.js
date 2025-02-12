const express = require('express');
const mysql = require('mysql');

const app = express();
const port = 40010;

// 创建数据库连接
const db = mysql.createConnection({
	host: 'localhost',
	user: 'order_local',
	password: 'order_local',
	database: 'order_local'
});

// 连接到数据库
db.connect(err => {
	if (err) {
		console.error('数据库连接失败: ' + err.stack);
		return;
	}
	console.log('已连接到数据库');
});

// 定义一个简单的查询接口
app.get('/query', (req, res) => {
	const sql = 'SHOW COLUMNS FROM recovermoney;';
	db.query(sql, (err, results) => {
		if (err) {
			res.status(500).send('查询失败: ' + err);
			return;
		}
		res.json(results);
	});
});

// 启动服务器
app.listen(port, () => {
	console.log(`服务器运行在 http://localhost:${port}`);
});
