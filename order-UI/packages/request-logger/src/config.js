/**
 * 日志服务配置
 * 可以通过环境变量或配置文件进行覆盖
 */
const path = require('path');
const os = require('os');

const config = {
	// 服务器配置
	server: {
		port: process.env.LOGGER_PORT || 3001,
		host: process.env.LOGGER_HOST || 'localhost'
	},

	// 日志文件配置
	log: {
		// 日志文件存储目录（默认：项目根目录下的 logs 文件夹）
		dir: process.env.LOG_DIR || path.join(process.cwd(), 'logs'),

		// 日志文件名格式（支持日期占位符和路径分隔符）
		// 使用 YYYY/MM/DD 创建年月日目录层级
		// 例如：YYYY/MM/DD/request.log
		filename: process.env.LOG_FILENAME || 'YYYY/MM/DD/request.log',

		// 日期格式（用于目录和文件名）
		// 注意：当filename中包含路径时，datePattern用于替换路径中的日期占位符
		datePattern: process.env.LOG_DATE_PATTERN || 'YYYY-MM-DD',

		// 最大文件大小（字节），超过此大小会创建新文件
		// 默认 10MB
		maxSize: process.env.LOG_MAX_SIZE ? parseInt(process.env.LOG_MAX_SIZE) : 10 * 1024 * 1024, // 10MB

		// 保留的日志文件数量（按日期）
		// 例如：设置为7，则保留最近7天的日志文件
		maxFiles: process.env.LOG_MAX_FILES ? parseInt(process.env.LOG_MAX_FILES) : 7, // 保留7天

		// 是否压缩旧日志文件
		zippedArchive: process.env.LOG_ZIPPED_ARCHIVE !== 'false',

		// 日志级别：error, warn, info, verbose, debug, silly
		level: process.env.LOG_LEVEL || 'info',

		// 日志格式选项
		format: {
			// 是否包含时间戳
			includeTimestamp: true,
			// 是否包含请求ID
			includeRequestId: true,
			// 是否美化JSON输出
			prettyPrint: process.env.NODE_ENV === 'development'
		}
	},

	// 清理策略配置
	cleanup: {
		// 是否启用自动清理
		enabled: process.env.LOG_CLEANUP_ENABLED !== 'false',

		// 清理检查间隔（毫秒）
		// 默认每小时检查一次
		interval: process.env.LOG_CLEANUP_INTERVAL ? parseInt(process.env.LOG_CLEANUP_INTERVAL) : 60 * 60 * 1000, // 1小时

		// 最大总日志大小（字节），超过此大小会删除最旧的日志
		// 默认 100MB
		maxTotalSize: process.env.LOG_MAX_TOTAL_SIZE ? parseInt(process.env.LOG_MAX_TOTAL_SIZE) : 100 * 1024 * 1024, // 100MB

		// 保留的最少文件数量（即使超过最大总大小，也至少保留这些文件）
		minFiles: process.env.LOG_MIN_FILES ? parseInt(process.env.LOG_MIN_FILES) : 3
	},

	// 请求过滤配置
	filter: {
		// 是否记录成功的请求（200状态码）
		logSuccess: process.env.LOG_SUCCESS !== 'false',

		// 是否记录失败的请求
		logErrors: true,

		// 排除的URL路径（正则表达式数组）
		excludePaths: [
			// 可以添加不需要记录的路径
			// 例如：/health, /metrics 等
		],

		// 敏感字段（这些字段的值会被脱敏）
		sensitiveFields: ['password', 'token', 'authorization', 'secret', 'apiKey', 'accessToken', 'refreshToken']
	}
};

module.exports = config;
