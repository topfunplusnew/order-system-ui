/**
 * 请求日志服务主入口
 * 提供HTTP接口接收前端发送的请求日志
 */
const express = require('express');
const cors = require('cors');
const compression = require('compression');
const config = require('./config');
const { logRequest } = require('./logger');
const { startCleanup, stopCleanup } = require('./cleanup');

const app = express();

// 中间件配置
app.use(compression()); // 启用压缩
app.use(cors()); // 启用CORS
app.use(express.json({ limit: '10mb' })); // 解析JSON请求体
app.use(express.urlencoded({ extended: true, limit: '10mb' })); // 解析URL编码请求体

// 请求ID生成器
let requestCounter = 0;
function generateRequestId() {
	return `req-${Date.now()}-${++requestCounter}`;
}

// 健康检查接口
app.get('/health', (req, res) => {
	res.json({
		status: 'ok',
		timestamp: new Date().toISOString(),
		service: 'request-logger'
	});
});

// 日志记录接口
app.post('/log', (req, res) => {
	try {
		const logData = req.body;

		// 验证必要字段
		if (!logData.method || !logData.url) {
			return res.status(400).json({
				success: false,
				error: 'Missing required fields: method, url'
			});
		}

		// 检查是否需要过滤此请求
		const shouldLog = shouldLogRequest(logData);

		if (!shouldLog) {
			return res.json({
				success: true,
				message: 'Request filtered out'
			});
		}

		// 生成请求ID（如果未提供）
		if (!logData.requestId) {
			logData.requestId = generateRequestId();
		}

		// 添加时间戳（如果未提供）
		if (!logData.timestamp) {
			logData.timestamp = new Date().toISOString();
		}

		// 添加客户端信息
		logData.ip = req.ip || req.connection.remoteAddress;
		logData.userAgent = req.get('user-agent');

		// 记录日志
		logRequest(logData);

		// 返回成功响应
		res.json({
			success: true,
			requestId: logData.requestId,
			timestamp: logData.timestamp
		});
	} catch (error) {
		console.error('Error logging request:', error);
		res.status(500).json({
			success: false,
			error: error.message
		});
	}
});

// 批量日志记录接口
app.post('/log/batch', (req, res) => {
	try {
		const logEntries = req.body;

		if (!Array.isArray(logEntries)) {
			return res.status(400).json({
				success: false,
				error: 'Body must be an array of log entries'
			});
		}

		const results = [];
		for (const logData of logEntries) {
			try {
				if (!logData.method || !logData.url) {
					results.push({
						success: false,
						error: 'Missing required fields: method, url'
					});
					continue;
				}

				const shouldLog = shouldLogRequest(logData);

				if (!shouldLog) {
					results.push({
						success: true,
						message: 'Request filtered out'
					});
					continue;
				}

				if (!logData.requestId) {
					logData.requestId = generateRequestId();
				}

				if (!logData.timestamp) {
					logData.timestamp = new Date().toISOString();
				}

				logData.ip = req.ip || req.connection.remoteAddress;
				logData.userAgent = req.get('user-agent');

				logRequest(logData);

				results.push({
					success: true,
					requestId: logData.requestId
				});
			} catch (error) {
				results.push({
					success: false,
					error: error.message
				});
			}
		}

		res.json({
			success: true,
			processed: results.length,
			results
		});
	} catch (error) {
		console.error('Error logging batch requests:', error);
		res.status(500).json({
			success: false,
			error: error.message
		});
	}
});

/**
 * 判断是否应该记录此请求
 * @param {Object} logData - 日志数据
 * @returns {boolean}
 */
function shouldLogRequest(logData) {
	// 检查URL是否在排除列表中
	const excludePaths = config.filter.excludePaths;
	if (excludePaths && excludePaths.length > 0) {
		const fullURL = logData.fullURL || logData.url || '';
		for (const pattern of excludePaths) {
			if (new RegExp(pattern).test(fullURL)) {
				return false;
			}
		}
	}

	// 检查是否记录成功请求
	if (!config.filter.logSuccess && logData.status >= 200 && logData.status < 300) {
		return false;
	}

	// 检查是否记录错误请求
	if (!config.filter.logErrors && (logData.error || logData.status >= 400)) {
		return false;
	}

	return true;
}

// 启动服务器
const server = app.listen(config.server.port, config.server.host, () => {
	console.log(`
╔═══════════════════════════════════════════════════════════╗
║          Request Logger Service Started                   ║
╠═══════════════════════════════════════════════════════════╣
║  Server:     http://${config.server.host}:${config.server.port}                    ║
║  Log Dir:    ${config.log.dir}                            ║
║  Max Size:   ${(config.log.maxSize / 1024 / 1024).toFixed(2)} MB                              ║
║  Max Files:  ${config.log.maxFiles} days                                  ║
║  Cleanup:    ${config.cleanup.enabled ? 'Enabled' : 'Disabled'}                              ║
╚═══════════════════════════════════════════════════════════╝
	`);
});

// 启动自动清理
startCleanup();

// 优雅关闭
process.on('SIGTERM', () => {
	console.log('\n[SIGTERM] Shutting down gracefully...');
	stopCleanup();
	server.close(() => {
		console.log('Server closed');
		process.exit(0);
	});
});

process.on('SIGINT', () => {
	console.log('\n[SIGINT] Shutting down gracefully...');
	stopCleanup();
	server.close(() => {
		console.log('Server closed');
		process.exit(0);
	});
});

// 错误处理
process.on('uncaughtException', error => {
	console.error('Uncaught Exception:', error);
	stopCleanup();
	process.exit(1);
});

process.on('unhandledRejection', (reason, promise) => {
	console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

module.exports = app;
