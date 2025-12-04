/**
 * 日志清理模块
 * 定期清理超过大小限制的旧日志文件
 */
const fs = require('fs');
const path = require('path');
const config = require('./config');

let cleanupInterval = null;

/**
 * 递归获取目录下所有日志文件（支持年月日目录结构）
 * @param {string} dir - 目录路径
 * @returns {Array} 文件信息数组 [{name, path, size, mtime}]
 */
function getLogFiles(dir) {
	if (!fs.existsSync(dir)) {
		return [];
	}

	const logFiles = [];

	/**
	 * 递归遍历目录
	 * @param {string} currentDir - 当前目录
	 */
	function traverseDirectory(currentDir) {
		try {
			const items = fs.readdirSync(currentDir);

			for (const item of items) {
				const itemPath = path.join(currentDir, item);
				let stat;

				try {
					stat = fs.statSync(itemPath);
				} catch (error) {
					// 如果无法读取文件信息，跳过
					continue;
				}

				if (stat.isDirectory()) {
					// 递归遍历子目录
					traverseDirectory(itemPath);
				} else if (stat.isFile() && (item.endsWith('.log') || item.endsWith('.gz'))) {
					// 找到日志文件
					logFiles.push({
						name: item,
						path: itemPath,
						size: stat.size,
						mtime: stat.mtime
					});
				}
			}
		} catch (error) {
			// 如果无法读取目录，跳过
			console.warn(`[Cleanup] Cannot read directory ${currentDir}:`, error.message);
		}
	}

	// 开始递归遍历
	traverseDirectory(dir);

	// 按修改时间排序（最旧的在前）
	return logFiles.sort((a, b) => a.mtime.getTime() - b.mtime.getTime());
}

/**
 * 计算目录下所有日志文件的总大小
 * @param {Array} files - 文件信息数组
 * @returns {number} 总大小（字节）
 */
function getTotalSize(files) {
	return files.reduce((total, file) => total + file.size, 0);
}

/**
 * 执行清理操作
 */
function performCleanup() {
	if (!config.cleanup.enabled) {
		return;
	}

	try {
		const logDir = config.log.dir;
		const logFiles = getLogFiles(logDir);
		const totalSize = getTotalSize(logFiles);

		// 如果总大小未超过限制，不需要清理
		if (totalSize <= config.cleanup.maxTotalSize) {
			return;
		}

		// 计算需要删除的文件
		const filesToDelete = [];
		let currentSize = totalSize;
		const minFiles = config.cleanup.minFiles;

		// 确保至少保留最小文件数量
		for (let i = 0; i < logFiles.length - minFiles; i++) {
			if (currentSize <= config.cleanup.maxTotalSize) {
				break;
			}

			filesToDelete.push(logFiles[i]);
			currentSize -= logFiles[i].size;
		}

		// 删除文件
		let deletedCount = 0;
		let freedSpace = 0;

		for (const file of filesToDelete) {
			try {
				fs.unlinkSync(file.path);
				deletedCount++;
				freedSpace += file.size;
			} catch (error) {
				console.error(`Failed to delete log file ${file.name}:`, error.message);
			}
		}

		if (deletedCount > 0) {
			console.log(`[Cleanup] Deleted ${deletedCount} log files, freed ${(freedSpace / 1024 / 1024).toFixed(2)} MB`);
		}
	} catch (error) {
		console.error('[Cleanup] Error during cleanup:', error);
	}
}

/**
 * 启动定期清理
 */
function startCleanup() {
	if (!config.cleanup.enabled) {
		return;
	}

	// 立即执行一次清理
	performCleanup();

	// 设置定期清理
	cleanupInterval = setInterval(() => {
		performCleanup();
	}, config.cleanup.interval);

	console.log(`[Cleanup] Started automatic cleanup (interval: ${config.cleanup.interval / 1000}s)`);
}

/**
 * 停止定期清理
 */
function stopCleanup() {
	if (cleanupInterval) {
		clearInterval(cleanupInterval);
		cleanupInterval = null;
		console.log('[Cleanup] Stopped automatic cleanup');
	}
}

module.exports = {
	startCleanup,
	stopCleanup,
	performCleanup,
	getLogFiles,
	getTotalSize
};
