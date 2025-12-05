/**
 * 日志记录器
 * 使用 winston 和 winston-daily-rotate-file 实现日志轮转
 */
const winston = require('winston');
const DailyRotateFile = require('winston-daily-rotate-file');
const path = require('path');
const fs = require('fs');
const config = require('./config');

// 确保日志目录存在
const logDir = config.log.dir;
if (!fs.existsSync(logDir)) {
	fs.mkdirSync(logDir, { recursive: true });
}

/**
 * 递归格式化日志条目，添加缩进
 * @param {*} obj - 要格式化的对象
 * @param {number} indent - 当前缩进级别
 * @param {number} maxDepth - 最大递归深度
 * @param {number} maxArrayItems - 数组最大显示项数
 * @returns {string} 格式化后的字符串
 */
function formatLogEntry(obj, indent = 0, maxDepth = 10, maxArrayItems = 5) {
	const indentStr = '  '.repeat(indent);

	// 限制递归深度
	if (indent > maxDepth) {
		return `${indentStr}... (max depth reached)\n`;
	}

	if (obj === null || obj === undefined) {
		return `${indentStr}null\n`;
	}

	if (typeof obj !== 'object') {
		const str = String(obj);
		if (str.length > 200) {
			return `${indentStr}${str.substring(0, 200)}... (${str.length} chars)\n`;
		}
		return `${indentStr}${str}\n`;
	}

	if (Array.isArray(obj)) {
		if (obj.length === 0) {
			return `${indentStr}[] (empty array)\n`;
		}

		// 对于大数组，只显示前几项
		const displayCount = Math.min(obj.length, maxArrayItems);
		let result = `${indentStr}[${obj.length} items]\n`;

		for (let i = 0; i < displayCount; i++) {
			result += `${indentStr}  [${i}]:\n`;
			result += formatLogEntry(obj[i], indent + 2, maxDepth, maxArrayItems);
		}

		if (obj.length > maxArrayItems) {
			result += `${indentStr}  ... (${obj.length - maxArrayItems} more items)\n`;
		}

		return result;
	}

	// 处理对象
	let result = '';
	const keys = Object.keys(obj);

	if (keys.length === 0) {
		return `${indentStr}{} (empty object)\n`;
	}

	// 对于大对象，先尝试序列化看看大小
	try {
		const jsonStr = JSON.stringify(obj);
		if (jsonStr.length > 50000) {
			// 对象太大，只显示键名和类型
			result += `${indentStr}{${keys.length} keys, size: ${(jsonStr.length / 1024).toFixed(2)} KB}\n`;
			keys.slice(0, 10).forEach((key, index) => {
				const isLast = index === keys.length - 1 || index === 9;
				const prefix = isLast ? '└─' : '├─';
				const value = obj[key];
				const type = Array.isArray(value) ? `Array[${value.length}]` : typeof value;
				result += `${indentStr}  ${prefix} ${key}: <${type}>\n`;
			});
			if (keys.length > 10) {
				result += `${indentStr}  ... (${keys.length - 10} more keys)\n`;
			}
			return result;
		}
	} catch (e) {
		// 如果无法序列化（循环引用等），使用简化显示
		result += `${indentStr}{${keys.length} keys, contains circular reference}\n`;
		keys.slice(0, 10).forEach(key => {
			result += `${indentStr}  ├─ ${key}: <object>\n`;
		});
		if (keys.length > 10) {
			result += `${indentStr}  ... (${keys.length - 10} more keys)\n`;
		}
		return result;
	}

	keys.forEach((key, index) => {
		const value = obj[key];
		const isLast = index === keys.length - 1;
		const prefix = isLast ? '└─' : '├─';

		// 对于"请求体"和"响应数据"字段，如果是JSON字符串，直接显示（带缩进）
		if ((key === '请求体' || key === '响应数据') && typeof value === 'string') {
			result += `${indentStr}${prefix} ${key}:\n`;
			// 为JSON字符串的每一行添加缩进
			const jsonLines = value.split('\n');
			jsonLines.forEach(line => {
				if (line.trim() || jsonLines.length <= 1) {
					// 保持JSON的原始缩进，只添加一级缩进
					result += `${indentStr}  ${line}\n`;
				}
			});
			return;
		}

		if (value === null || value === undefined) {
			result += `${indentStr}${prefix} ${key}: null\n`;
		} else if (typeof value === 'object') {
			// 检查是否是空对象或空数组
			if (Array.isArray(value) && value.length === 0) {
				result += `${indentStr}${prefix} ${key}: [] (empty)\n`;
			} else if (!Array.isArray(value) && Object.keys(value).length === 0) {
				result += `${indentStr}${prefix} ${key}: {} (empty)\n`;
			} else {
				result += `${indentStr}${prefix} ${key}:\n`;
				result += formatLogEntry(value, indent + 1, maxDepth, maxArrayItems);
			}
		} else if (typeof value === 'string') {
			if (value.length > 200) {
				// 长字符串截断，保留前后部分
				const preview = value.substring(0, 100);
				const suffix = value.substring(value.length - 50);
				result += `${indentStr}${prefix} ${key}: ${preview}...${suffix} (${value.length} chars)\n`;
			} else {
				result += `${indentStr}${prefix} ${key}: ${value}\n`;
			}
		} else {
			result += `${indentStr}${prefix} ${key}: ${String(value)}\n`;
		}
	});

	return result;
}

// 自定义格式化函数 - 美化JSON输出
const prettyPrintFormat = winston.format.printf(info => {
	const { timestamp, level, message, service, ...meta } = info;

	// 构建基础信息行
	let output = `\n${'='.repeat(100)}\n`;
	output += `[${timestamp}] [${level.toUpperCase()}] ${message}\n`;
	output += `${'='.repeat(100)}\n`;

	// 格式化元数据（排除service字段）
	if (Object.keys(meta).length > 0) {
		output += formatLogEntry(meta, 0);
	}

	output += `${'='.repeat(100)}\n`;
	return output;
});

// 自定义日志格式 - 使用美化格式
const logFormat = winston.format.combine(winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss.SSS' }), winston.format.errors({ stack: true }), winston.format.splat(), prettyPrintFormat);

// 控制台输出格式（开发环境使用）- 使用美化格式
const consoleFormat = winston.format.combine(winston.format.colorize(), winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss.SSS' }), prettyPrintFormat);

/**
 * 获取当前日期的目录路径
 * @param {string} baseDir - 基础目录
 * @returns {string} 日期目录路径
 */
function getDateDir(baseDir) {
	const now = new Date();
	const year = String(now.getFullYear());
	const month = String(now.getMonth() + 1).padStart(2, '0');
	const day = String(now.getDate()).padStart(2, '0');
	return path.join(baseDir, year, month, day);
}

/**
 * 创建带年月日目录的日志传输器
 * @param {string} baseDir - 基础目录
 * @param {string} filename - 文件名
 * @param {Object} options - 其他选项
 * @returns {DailyRotateFile} 日志传输器实例
 */
function createDateBasedTransport(baseDir, filename, options = {}) {
	// 获取当前日期的目录路径
	const currentDateDir = getDateDir(baseDir);

	// 确保当前日期的目录存在
	if (!fs.existsSync(currentDateDir)) {
		fs.mkdirSync(currentDateDir, { recursive: true });
	}

	// 构建初始文件路径（完整路径，不包含 %DATE%）
	const initialFilePath = path.join(currentDateDir, filename);

	// 创建传输器
	const transport = new DailyRotateFile({
		filename: initialFilePath,
		datePattern: 'YYYY-MM-DD',
		maxSize: config.log.maxSize,
		maxFiles: config.log.maxFiles,
		zippedArchive: config.log.zippedArchive,
		format: logFormat,
		createSymlink: false,
		...options
	});

	// 重写 log 方法，在每次写入前检查并更新路径
	const originalLog = transport.log.bind(transport);
	transport.log = function (info, callback) {
		// 获取当前日期的目录
		const dateDir = getDateDir(baseDir);

		// 确保目录存在
		if (!fs.existsSync(dateDir)) {
			fs.mkdirSync(dateDir, { recursive: true });
		}

		// 构建当前文件路径
		const currentFilePath = path.join(dateDir, filename);

		// 如果路径改变了，更新传输器的文件名
		if (this.filename !== currentFilePath) {
			// 关闭旧流
			if (this._stream) {
				this._stream.end();
				this._stream = null;
			}
			// 更新文件名
			this.filename = currentFilePath;
		}

		// 调用原始 log 方法
		return originalLog(info, callback);
	};

	// 监听文件创建事件，确保目录存在
	transport.on('new', newFilename => {
		const dir = path.dirname(newFilename);
		if (!fs.existsSync(dir)) {
			fs.mkdirSync(dir, { recursive: true });
		}
	});

	return transport;
}

// 创建文件传输器（带轮转）
// 使用自定义路径格式：YYYY/MM/DD/request.log
const fileTransport = createDateBasedTransport(logDir, 'request.log', {
	level: config.log.level
});

// 创建错误日志文件传输器（单独记录错误）
const errorFileTransport = createDateBasedTransport(logDir, 'error.log', {
	level: 'error'
});

// 创建logger实例
const logger = winston.createLogger({
	level: config.log.level,
	format: logFormat,
	defaultMeta: { service: 'request-logger' },
	transports: [fileTransport, errorFileTransport],
	// 异常处理
	exceptionHandlers: [createDateBasedTransport(logDir, 'exceptions.log')],
	// 拒绝处理（Promise rejection）
	rejectionHandlers: [createDateBasedTransport(logDir, 'rejections.log')]
});

// 开发环境添加控制台输出
if (process.env.NODE_ENV === 'development') {
	logger.add(
		new winston.transports.Console({
			format: consoleFormat
		})
	);
}

/**
 * 记录请求日志
 * @param {Object} logData - 日志数据对象
 */
function logRequest(logData) {
	const { requestId, timestamp, method, url, baseURL, fullURL, headers, params, data, response, error, duration, status, userAgent, ip } = logData;

	// 格式化时间戳
	const logTimestamp = timestamp
		? new Date(timestamp).toLocaleString('zh-CN', {
				year: 'numeric',
				month: '2-digit',
				day: '2-digit',
				hour: '2-digit',
				minute: '2-digit',
				second: '2-digit',
				millisecond: '3-digit'
		  })
		: new Date().toLocaleString('zh-CN', {
				year: 'numeric',
				month: '2-digit',
				day: '2-digit',
				hour: '2-digit',
				minute: '2-digit',
				second: '2-digit',
				millisecond: '3-digit'
		  });

	// 格式化请求体和响应数据为JSON字符串
	const formatJSON = obj => {
		if (obj === null || obj === undefined) {
			return null;
		}
		// 如果已经是字符串，尝试解析后再格式化
		if (typeof obj === 'string') {
			try {
				const parsed = JSON.parse(obj);
				return JSON.stringify(parsed, null, 2);
			} catch (e) {
				// 如果不是JSON字符串，直接返回
				return obj;
			}
		}
		try {
			return JSON.stringify(obj, null, 2);
		} catch (e) {
			// 如果无法序列化（循环引用等），返回类型信息
			return `[无法序列化: ${typeof obj}]`;
		}
	};

	// 构建结构化的日志对象，便于格式化输出
	const logEntry = {
		请求ID: requestId,
		时间戳: logTimestamp,
		请求信息: {
			方法: method,
			URL: url,
			基础URL: baseURL,
			完整URL: fullURL,
			请求头: sanitizeHeaders(headers),
			查询参数: params || {},
			请求体: formatJSON(sanitizeData(data))
		},
		响应信息: response
			? {
					状态码: response.status || status,
					状态文本: response.statusText,
					响应头: sanitizeHeaders(response.headers),
					响应数据: formatJSON(sanitizeData(response.data)),
					'耗时(ms)': duration
			  }
			: null,
		错误信息: error
			? {
					错误消息: error.message,
					错误代码: error.code,
					堆栈跟踪: error.stack
			  }
			: null,
		元数据: {
			客户端IP: ip,
			用户代理: userAgent,
			'总耗时(ms)': duration
		}
	};

	// 根据状态记录不同级别的日志
	if (error) {
		logger.error('❌ 请求失败', logEntry);
	} else if (status >= 400) {
		logger.warn('⚠️  请求错误', logEntry);
	} else {
		logger.info('✅ 请求成功', logEntry);
	}
}

/**
 * 脱敏处理敏感字段
 * @param {Object} obj - 需要脱敏的对象
 * @returns {Object} 脱敏后的对象
 */
function sanitizeData(obj) {
	if (!obj || typeof obj !== 'object') {
		return obj;
	}

	if (Array.isArray(obj)) {
		return obj.map(item => sanitizeData(item));
	}

	const sanitized = { ...obj };
	const sensitiveFields = config.filter.sensitiveFields;

	for (const field of sensitiveFields) {
		if (sanitized[field]) {
			sanitized[field] = '***REDACTED***';
		}
	}

	// 递归处理嵌套对象
	for (const key in sanitized) {
		if (sanitized[key] && typeof sanitized[key] === 'object') {
			sanitized[key] = sanitizeData(sanitized[key]);
		}
	}

	return sanitized;
}

/**
 * 脱敏处理请求头
 * @param {Object} headers - 请求头对象
 * @returns {Object} 脱敏后的请求头
 */
function sanitizeHeaders(headers) {
	if (!headers || typeof headers !== 'object') {
		return headers;
	}

	const sanitized = { ...headers };
	const sensitiveFields = config.filter.sensitiveFields;

	for (const field of sensitiveFields) {
		const lowerField = field.toLowerCase();
		for (const headerKey in sanitized) {
			if (headerKey.toLowerCase() === lowerField) {
				sanitized[headerKey] = '***REDACTED***';
			}
		}
	}

	return sanitized;
}

module.exports = {
	logger,
	logRequest,
	sanitizeData,
	sanitizeHeaders
};
