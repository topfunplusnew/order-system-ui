/**
 * 请求日志客户端
 * 用于将请求日志发送到日志服务
 */
import axios from 'axios';

// 日志服务配置
const LOGGER_SERVICE_URL = process.env.VUE_APP_LOGGER_SERVICE_URL || 'http://localhost:3001';

// 是否启用日志记录
const ENABLED = process.env.VUE_APP_ENABLE_REQUEST_LOG !== 'false';

// 请求ID生成器
let requestCounter = 0;
function generateRequestId() {
	return `req-${Date.now()}-${++requestCounter}`;
}

// 日志队列（用于批量发送）
let logQueue = [];
let queueTimer = null;
const QUEUE_MAX_SIZE = 10; // 队列最大长度
const QUEUE_FLUSH_INTERVAL = 5000; // 5秒刷新一次队列

/**
 * 发送日志到日志服务
 * @param {Object} logData - 日志数据
 * @param {boolean} immediate - 是否立即发送（不加入队列）
 */
export function sendLog(logData, immediate = false) {
	if (!ENABLED) {
		return;
	}

	// 如果立即发送，直接发送
	if (immediate) {
		sendLogToService(logData).catch(error => {
			console.warn('[RequestLogger] Failed to send log:', error);
		});
		return;
	}

	// 否则加入队列
	logQueue.push(logData);

	// 如果队列满了，立即发送
	if (logQueue.length >= QUEUE_MAX_SIZE) {
		flushLogQueue();
		return;
	}

	// 设置定时器（如果还没有）
	if (!queueTimer) {
		queueTimer = setTimeout(() => {
			flushLogQueue();
		}, QUEUE_FLUSH_INTERVAL);
	}
}

/**
 * 刷新日志队列
 */
function flushLogQueue() {
	if (logQueue.length === 0) {
		return;
	}

	const logsToSend = [...logQueue];
	logQueue = [];

	if (queueTimer) {
		clearTimeout(queueTimer);
		queueTimer = null;
	}

	// 批量发送
	if (logsToSend.length === 1) {
		sendLogToService(logsToSend[0]).catch(error => {
			console.warn('[RequestLogger] Failed to send log:', error);
		});
	} else {
		sendBatchLogsToService(logsToSend).catch(error => {
			console.warn('[RequestLogger] Failed to send batch logs:', error);
		});
	}
}

/**
 * 发送单个日志到服务
 * @param {Object} logData - 日志数据
 */
async function sendLogToService(logData) {
	try {
		await axios.post(`${LOGGER_SERVICE_URL}/log`, logData, {
			timeout: 3000 // 3秒超时
		});
	} catch (error) {
		// 静默失败，不影响主流程
		if (process.env.NODE_ENV === 'development') {
			console.warn('[RequestLogger] Failed to send log to service:', error.message);
		}
	}
}

/**
 * 批量发送日志到服务
 * @param {Array} logs - 日志数组
 */
async function sendBatchLogsToService(logs) {
	try {
		await axios.post(`${LOGGER_SERVICE_URL}/log/batch`, logs, {
			timeout: 5000 // 5秒超时
		});
	} catch (error) {
		// 静默失败，不影响主流程
		if (process.env.NODE_ENV === 'development') {
			console.warn('[RequestLogger] Failed to send batch logs to service:', error.message);
		}
	}
}

/**
 * 记录请求开始
 * @param {Object} config - axios请求配置
 * @returns {string} 请求ID
 */
export function logRequestStart(config) {
	if (!ENABLED) {
		return null;
	}

	const requestId = generateRequestId();
	const startTime = Date.now();

	// 存储请求开始时间和请求ID
	config._requestLogger = {
		requestId,
		startTime
	};

	return requestId;
}

/**
 * 记录请求成功
 * @param {Object} config - axios请求配置
 * @param {Object} response - axios响应对象
 */
export function logRequestSuccess(config, response) {
	if (!ENABLED || !config._requestLogger) {
		return;
	}

	const { requestId, startTime } = config._requestLogger;
	const duration = Date.now() - startTime;

	// 限制响应数据大小（避免日志过大）
	const responseData = limitDataSize(response?.data, 50000); // 限制50KB

	const logData = {
		requestId,
		timestamp: new Date().toISOString(),
		method: config.method?.toUpperCase() || 'GET',
		url: config.url || '',
		baseURL: config.baseURL || '',
		fullURL: getFullURL(config),
		headers: config.headers || {},
		params: config.params || {},
		data: limitDataSize(config.data, 50000), // 限制请求数据大小
		response: {
			status: response?.status,
			statusText: response?.statusText,
			headers: response?.headers || {},
			data: responseData
		},
		error: null,
		duration,
		status: response?.status
	};

	sendLog(logData);
}

/**
 * 记录请求失败
 * @param {Object} config - axios请求配置
 * @param {Object} error - 错误对象
 */
export function logRequestError(config, error) {
	if (!ENABLED) {
		return;
	}

	// 如果config不存在（可能是请求配置错误），创建一个基本配置
	const requestLogger = config?._requestLogger || {};
	const requestId = requestLogger.requestId || generateRequestId();
	const startTime = requestLogger.startTime || Date.now();
	const duration = Date.now() - startTime;

	const logData = {
		requestId,
		timestamp: new Date().toISOString(),
		method: config?.method?.toUpperCase() || 'GET',
		url: config?.url || '',
		baseURL: config?.baseURL || '',
		fullURL: getFullURL(config),
		headers: config?.headers || {},
		params: config?.params || {},
		data: limitDataSize(config?.data, 50000), // 限制请求数据大小
		response: error.response
			? {
					status: error.response.status,
					statusText: error.response.statusText,
					headers: error.response.headers || {},
					data: limitDataSize(error.response.data, 50000) // 限制响应数据大小
			  }
			: null,
		error: {
			message: error.message || 'Unknown error',
			code: error.code,
			stack: error.stack ? error.stack.substring(0, 2000) : null // 限制堆栈长度
		},
		duration,
		status: error.response?.status || 0
	};

	// 错误日志立即发送
	sendLog(logData, true);
}

/**
 * 获取完整URL
 * @param {Object} config - axios请求配置
 * @returns {string}
 */
function getFullURL(config) {
	if (!config) {
		return '';
	}

	const baseURL = config.baseURL || '';
	const url = config.url || '';

	if (!baseURL) {
		return url;
	}

	// 处理baseURL和url的拼接
	if (url.startsWith('http://') || url.startsWith('https://')) {
		return url;
	}

	const baseURLWithoutSlash = baseURL.endsWith('/') ? baseURL.slice(0, -1) : baseURL;
	const urlWithSlash = url.startsWith('/') ? url : `/${url}`;

	return `${baseURLWithoutSlash}${urlWithSlash}`;
}

/**
 * 限制数据大小，避免日志过大
 * @param {*} data - 要限制的数据
 * @param {number} maxSize - 最大大小（字节）
 * @returns {*} 处理后的数据
 */
function limitDataSize(data, maxSize = 50000) {
	if (!data) {
		return data;
	}

	try {
		const jsonString = JSON.stringify(data);
		if (jsonString.length <= maxSize) {
			return data;
		}

		// 如果数据过大，返回截断提示
		return {
			_truncated: true,
			_originalSize: jsonString.length,
			_message: `数据过大已截断，原始大小: ${(jsonString.length / 1024).toFixed(2)} KB`,
			_preview: jsonString.substring(0, maxSize / 2)
		};
	} catch (error) {
		// 如果无法序列化，返回类型信息
		return {
			_type: typeof data,
			_isCircular: true,
			_message: '数据无法序列化（可能包含循环引用）'
		};
	}
}

/**
 * 页面卸载时刷新日志队列
 */
if (typeof window !== 'undefined') {
	window.addEventListener('beforeunload', () => {
		flushLogQueue();
	});

	// 页面可见性变化时也刷新
	document.addEventListener('visibilitychange', () => {
		if (document.hidden) {
			flushLogQueue();
		}
	});
}

export default {
	sendLog,
	logRequestStart,
	logRequestSuccess,
	logRequestError
};
