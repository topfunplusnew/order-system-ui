// deepseek-analyzer.js
// 用于调用DeepSeek API分析git变更并生成功能描述

const { execSync } = require('child_process');
const https = require('https');
const fs = require('fs');
const path = require('path');

/**
 * 获取git变更信息
 */
function getGitChanges() {
	try {
		// 获取未提交的变更
		const status = execSync('git status --porcelain', { encoding: 'utf-8' });
		if (!status.trim()) {
			return {
				hasChanges: false,
				message: '没有检测到git变更'
			};
		}

		// 获取变更的文件列表（只获取文件名，不获取diff内容）
		let changedFiles = '';
		try {
			const diffFiles = execSync('git diff --name-status HEAD', { encoding: 'utf-8' });
			changedFiles = diffFiles.trim();
		} catch (e) {
			// 如果失败，尝试获取暂存区的文件
			try {
				const stagedFiles = execSync('git diff --cached --name-status', { encoding: 'utf-8' });
				changedFiles = stagedFiles.trim();
			} catch (e2) {
				// 如果都失败，使用status输出
				changedFiles = status.trim();
			}
		}

		// 获取变更的摘要（只显示统计信息，不包含具体内容）
		let diffSummary = '';
		try {
			const stat = execSync('git diff --stat HEAD', { encoding: 'utf-8', maxBuffer: 1024 * 1024 });
			diffSummary = stat.trim();
		} catch (e) {
			// 如果失败，尝试获取暂存区的统计
			try {
				const stagedStat = execSync('git diff --cached --stat', { encoding: 'utf-8', maxBuffer: 1024 * 1024 });
				diffSummary = stagedStat.trim();
			} catch (e2) {
				diffSummary = '';
			}
		}

		return {
			hasChanges: true,
			changedFiles: changedFiles,
			diffSummary: diffSummary,
			status: status.trim()
		};
	} catch (error) {
		console.warn('⚠️  无法获取git变更信息:', error.message);
		return {
			hasChanges: false,
			message: '无法获取git变更信息'
		};
	}
}

/**
 * 读取DeepSeek API Key
 */
function getApiKey() {
	// 优先从环境变量读取
	if (process.env.DEEPSEEK_API_KEY) {
		return process.env.DEEPSEEK_API_KEY;
	}

	// 从配置文件读取
	const configPath = path.resolve(__dirname, '.deepseek-config.json');
	if (fs.existsSync(configPath)) {
		try {
			const config = JSON.parse(fs.readFileSync(configPath, 'utf-8'));
			if (config.apiKey) {
				return config.apiKey;
			}
		} catch (error) {
			console.warn('⚠️  读取配置文件失败:', error.message);
		}
	}

	return null;
}

/**
 * 清理和转义文本内容，确保可以安全地放入JSON
 */
function sanitizeText(text) {
	if (!text) return '';
	// 移除所有可能导致JSON解析问题的字符
	return text
		.replace(/[\x00-\x08\x0B-\x0C\x0E-\x1F\x7F-\x9F]/g, '') // 移除所有控制字符和扩展控制字符
		.replace(/\r\n/g, '\n') // 统一换行符
		.replace(/\r/g, '\n')
		.replace(/[\u200B-\u200D\uFEFF]/g, '') // 移除零宽字符
		.replace(/\u2028/g, '\n') // 将行分隔符转换为换行符
		.replace(/\u2029/g, '\n') // 将段落分隔符转换为换行符
		.trim()
		.substring(0, 2000); // 限制长度，避免过长
}

/**
 * 调用DeepSeek API分析变更
 */
function analyzeWithDeepSeek(changes) {
	return new Promise((resolve, reject) => {
		const apiKey = getApiKey();
		if (!apiKey) {
			reject(new Error('未找到DeepSeek API Key，请设置环境变量 DEEPSEEK_API_KEY 或创建 .deepseek-config.json 文件'));
			return;
		}

		// 清理git输出内容
		const changedFilesText = sanitizeText(changes.changedFiles || changes.status);
		const diffSummaryText = sanitizeText(changes.diffSummary);

		// 构建prompt，使用数组拼接避免模板字符串问题
		const promptLines = ['请分析以下git变更，用一句话（不超过30个字）总结本次修改的主要功能需求。只返回总结内容，不要其他说明文字。', '', '变更文件：', changedFilesText, '', '变更统计：', diffSummaryText || '无统计信息', '', '请用简洁的中文总结本次修改的主要功能需求：'];
		const prompt = promptLines.join('\n');

		// 构建请求数据
		const requestData = {
			model: 'deepseek-chat',
			messages: [
				{
					role: 'user',
					content: prompt
				}
			],
			temperature: 0.7,
			max_tokens: 100
		};

		// 序列化为JSON，并验证
		let data;
		try {
			data = JSON.stringify(requestData);
			// 验证JSON是否有效
			try {
				JSON.parse(data);
			} catch (parseError) {
				reject(new Error(`生成的JSON无效: ${parseError.message}。内容长度: ${data.length}`));
				return;
			}
		} catch (error) {
			reject(new Error(`JSON序列化失败: ${error.message}`));
			return;
		}

		// 将数据转换为Buffer以确保正确的字节长度计算
		const dataBuffer = Buffer.from(data, 'utf-8');

		const options = {
			hostname: 'api.deepseek.com',
			path: '/chat/completions',
			method: 'POST',
			headers: {
				'Content-Type': 'application/json; charset=utf-8',
				Authorization: `Bearer ${apiKey}`,
				'Content-Length': dataBuffer.length
			}
		};

		const req = https.request(options, res => {
			let responseData = '';

			// 检查HTTP状态码
			if (res.statusCode !== 200) {
				res.on('data', chunk => {
					responseData += chunk;
				});
				res.on('end', () => {
					// 尝试解析错误响应
					let errorMsg = `HTTP ${res.statusCode}`;
					try {
						const errorResult = JSON.parse(responseData);
						if (errorResult.error && errorResult.error.message) {
							errorMsg = errorResult.error.message;
						} else if (errorResult.message) {
							errorMsg = errorResult.message;
						}
					} catch (e) {
						// 如果不是JSON，直接使用响应文本（截取前200字符）
						errorMsg = responseData.substring(0, 200) || `HTTP ${res.statusCode} 错误`;
					}
					reject(new Error(`DeepSeek API请求失败 (${res.statusCode}): ${errorMsg}`));
				});
				return;
			}

			res.on('data', chunk => {
				responseData += chunk;
			});

			res.on('end', () => {
				try {
					// 检查响应是否为空
					if (!responseData || !responseData.trim()) {
						reject(new Error('DeepSeek API返回空响应'));
						return;
					}

					const result = JSON.parse(responseData);
					if (result.error) {
						reject(new Error(`DeepSeek API错误: ${result.error.message || JSON.stringify(result.error)}`));
					} else if (result.choices && result.choices.length > 0) {
						const content = result.choices[0].message.content.trim();
						// 清理可能的引号和其他格式
						const cleanContent = content.replace(/^["']|["']$/g, '').trim();
						resolve(cleanContent);
					} else {
						reject(new Error(`DeepSeek API返回格式异常，响应: ${JSON.stringify(result).substring(0, 200)}`));
					}
				} catch (error) {
					// 输出原始响应前200字符以便调试
					const preview = responseData.substring(0, 200);
					reject(new Error(`解析API响应失败: ${error.message}。响应预览: ${preview}`));
				}
			});
		});

		req.on('error', error => {
			reject(new Error(`请求失败: ${error.message}`));
		});

		// 使用Buffer发送数据
		req.write(dataBuffer);
		req.end();
	});
}

/**
 * 主函数：分析git变更并生成功能描述
 */
async function analyzeChanges() {
	const changes = getGitChanges();

	if (!changes.hasChanges) {
		console.log('ℹ️  ' + (changes.message || '没有检测到变更'));
		return '常规更新';
	}

	console.log('🔍 正在分析git变更...');
	console.log('变更文件:', changes.changedFiles || changes.status);

	try {
		const description = await analyzeWithDeepSeek(changes);
		console.log('✅ AI分析完成:', description);
		return description;
	} catch (error) {
		console.error('❌ AI分析失败:', error.message);
		console.log('⚠️  使用默认描述: 常规更新');
		return '常规更新';
	}
}

// 如果直接运行此脚本
if (require.main === module) {
	analyzeChanges()
		.then(description => {
			console.log('功能描述:', description);
			process.exit(0);
		})
		.catch(error => {
			console.error('错误:', error.message);
			process.exit(1);
		});
}

module.exports = { analyzeChanges, getApiKey };
