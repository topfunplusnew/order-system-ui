export class Logger {
	/**
	 * 日志工具类
	 * @param {object} options 配置项
	 * @param {boolean} options.showTime 是否显示时间（默认true）
	 * @param {boolean} options.enableDebug 是否开启debug级别日志（默认false）
	 * @param {string} options.prefix 日志前缀（默认''）
	 */
	constructor(options = {}) {
		this.config = {
			showTime: options.showTime !== false,
			enableDebug: options.enableDebug || false,
			prefix: options.prefix || '',
			colors: {
				debug: '\x1b[36m', // 青色
				info: '\x1b[32m', // 绿色
				warn: '\x1b[33m', // 黄色
				error: '\x1b[31m', // 红色
				reset: '\x1b[0m' // 重置颜色
			}
		};
	}

	#getTimestamp() {
		return this.config.showTime ? `[${new Date().toISOString()}] ` : '';
	}

	#formatMessage(level, message) {
		const color = this.config.colors[level];
		const prefix = this.config.prefix ? `[${this.config.prefix}] ` : '';
		return `${this.#getTimestamp()}${prefix}${color}${level.toUpperCase()}\x1b[0m: ${message}`;
	}

	/**
	 * 调试信息（仅当enableDebug为true时显示）
	 */
	debug(message) {
		if (this.config.enableDebug) {
			console.debug(this.#formatMessage('debug', message));
		}
	}

	/**
	 * 普通信息
	 */
	info(message) {
		console.info(this.#formatMessage('info', message));
	}

	/**
	 * 警告信息
	 */
	warn(message) {
		console.warn(this.#formatMessage('warn', message));
	}

	/**
	 * 错误信息
	 */
	error(message) {
		console.error(this.#formatMessage('error', message));
	}

	/**
	 * 打印对象（适合调试复杂数据）
	 */
	dir(obj, level = 'debug') {
		if (level === 'debug' && !this.config.enableDebug) return;

		const color = this.config.colors[level];
		console.log(`${this.#getTimestamp()}${color}${level.toUpperCase()}:\x1b[0m`);
		console.dir(obj);
	}
}

// ==================== 使用示例 ====================
// const logger = new Logger({
// 	prefix: 'MyApp',
// 	enableDebug: true
// });

// logger.debug('This is debug message'); // 青色输出（仅在enableDebug为true时显示）
// logger.info('System started'); // 绿色输出
// logger.warn('Memory usage high'); // 黄色输出
// logger.error('Failed to load data');   // 红色输出
// logger.dir({foo: 'bar'}, 'debug');   // 打印对象