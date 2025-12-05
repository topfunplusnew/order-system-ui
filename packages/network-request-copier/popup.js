// Popup 脚本

// HTML转义函数
function escapeHtml(text) {
	const div = document.createElement('div');
	div.textContent = text;
	return div.innerHTML;
}

document.addEventListener('DOMContentLoaded', () => {
	loadRequestList();

	// 刷新按钮
	document.getElementById('refresh-btn').addEventListener('click', () => {
		loadRequestList();
	});

	// 清空按钮
	document.getElementById('clear-btn').addEventListener('click', () => {
		if (confirm('确定要清空所有请求记录吗？')) {
			chrome.runtime.sendMessage({ action: 'clearRequests' }, () => {
				loadRequestList();
			});
		}
	});
});

// 加载请求列表
function loadRequestList() {
	const listContainer = document.getElementById('request-list');
	listContainer.innerHTML = '<div class="loading">加载中...</div>';

	// 设置超时，防止一直显示"加载中"
	const timeout = setTimeout(() => {
		listContainer.innerHTML = '<div class="empty-state">请求超时<br>请检查扩展是否正常运行</div>';
	}, 3000);

	// 使用 Promise 方式处理消息
	chrome.runtime.sendMessage({ action: 'getAllRequests' }, response => {
		clearTimeout(timeout);

		// 检查 Chrome 运行时错误
		if (chrome.runtime.lastError) {
			console.error('Error:', chrome.runtime.lastError);
			listContainer.innerHTML = '<div class="empty-state">连接失败：' + chrome.runtime.lastError.message + '<br>请尝试重新加载扩展</div>';
			return;
		}

		// 如果没有响应，可能是 Service Worker 没有运行
		if (!response) {
			console.warn('No response from service worker');
			listContainer.innerHTML = '<div class="empty-state">Service Worker 未响应<br>请尝试重新加载扩展或访问网页后刷新</div>';
			return;
		}

		if (response.success) {
			renderRequestList(response.data || []);
		} else {
			console.warn('Request failed:', response);
			listContainer.innerHTML = '<div class="empty-state">加载失败：' + (response.error || '未知错误') + '</div>';
		}
	});
}

// 解析URL参数
function parseUrlParams(url) {
	if (!url) return null;
	try {
		const urlObj = new URL(url);
		const params = {};
		if (urlObj.search) {
			const searchParams = new URLSearchParams(urlObj.search);
			for (const [key, value] of searchParams.entries()) {
				// 尝试解码参数值
				try {
					params[decodeURIComponent(key)] = decodeURIComponent(value);
				} catch (e) {
					params[key] = value;
				}
			}
		}
		return Object.keys(params).length > 0 ? params : null;
	} catch (e) {
		return null;
	}
}

// 渲染请求列表
function renderRequestList(requests) {
	const listContainer = document.getElementById('request-list');

	if (requests.length === 0) {
		listContainer.innerHTML = '<div class="empty-state">暂无请求数据<br>请访问网页后刷新</div>';
		return;
	}

	let html = '';
	requests.forEach(req => {
		const methodClass = `method-${req.method.toLowerCase()}`;
		const statusClass = req.statusCode >= 200 && req.statusCode < 300 ? 'status-success' : req.statusCode >= 400 ? 'status-error' : 'status-warning';

		// 解码URL用于显示
		let displayUrl = req.url;
		try {
			displayUrl = decodeURIComponent(req.url);
		} catch (e) {
			// 如果解码失败，使用原始URL
		}

		// 解析URL参数
		const params = parseUrlParams(req.url);
		let paramsHtml = '';
		if (params) {
			paramsHtml = '<div class="request-params" style="width: 100%; box-sizing: border-box;"><div class="request-params-title">查询参数：</div>';
			for (const [key, value] of Object.entries(params)) {
				paramsHtml += `<div class="request-param-item" style="width: 100%; box-sizing: border-box;"><span class="request-param-key">${escapeHtml(key)}</span>: <span class="request-param-value">${escapeHtml(value)}</span></div>`;
			}
			paramsHtml += '</div>';
		}

		html += `
			<div class="request-item" style="width: 100%; box-sizing: border-box;">
				<div class="request-header" style="width: 100%;  box-sizing: border-box;">
					<span class="method-badge ${methodClass}">${req.method}</span>
					${req.statusCode ? `<span class="status-badge ${statusClass}">${req.statusCode}</span>` : ''}
					<button class="btn btn-primary copy-btn" data-request-id="${req.requestId}" style="font-size: 11px; padding: 4px 8px; margin-left: auto; flex-shrink: 0; margin-right: 4px;">复制</button>
					<button class="btn copy-image-btn" data-request-id="${req.requestId}" style="font-size: 11px; padding: 4px 8px; background: #67c23a; color: white; border: none; border-radius: 4px; cursor: pointer; flex-shrink: 0;">复制图片</button>
				</div>
				<div class="request-url-full" style="width: 100%;  box-sizing: border-box;">${escapeHtml(displayUrl)}</div>
				${paramsHtml}
				<div class="request-time">${new Date(req.timestamp).toLocaleString()}</div>
			</div>
		`;
	});

	listContainer.innerHTML = html;

	// 绑定复制按钮事件
	listContainer.querySelectorAll('.copy-btn').forEach(btn => {
		btn.addEventListener('click', e => {
			const requestId = e.target.getAttribute('data-request-id');
			copyRequestInfo(requestId);
		});
	});

	// 绑定复制图片按钮事件
	listContainer.querySelectorAll('.copy-image-btn').forEach(btn => {
		btn.addEventListener('click', e => {
			const requestId = e.target.getAttribute('data-request-id');
			copyRequestAsImage(requestId);
		});
	});
}

// 复制请求信息
function copyRequestInfo(requestId) {
	chrome.runtime.sendMessage({ action: 'getRequest', requestId: requestId }, response => {
		if (chrome.runtime.lastError) {
			console.error('Error:', chrome.runtime.lastError);
			showMessage('获取请求失败：' + chrome.runtime.lastError.message, 'error');
			return;
		}

		if (response && response.success && response.data) {
			const data = response.data;

			// 解码URL，去除URL编码
			let decodedUrl = data.url;
			if (decodedUrl) {
				try {
					// 尝试解码整个URL
					decodedUrl = decodeURIComponent(decodedUrl);
				} catch (e) {
					// 如果解码失败，尝试分段解码查询参数
					try {
						const urlObj = new URL(decodedUrl);
						if (urlObj.search) {
							const params = new URLSearchParams(urlObj.search);
							const decodedParams = new URLSearchParams();
							for (const [key, value] of params.entries()) {
								try {
									decodedParams.append(decodeURIComponent(key), decodeURIComponent(value));
								} catch (err) {
									decodedParams.append(key, value);
								}
							}
							urlObj.search = decodedParams.toString();
							decodedUrl = urlObj.toString();
						}
					} catch (err) {
						// 如果都失败了，使用原始URL
					}
				}
			}

			const copyData = {
				请求方法: data.method,
				请求地址: decodedUrl,
				请求载荷: data.requestBody,
				响应结构: {
					状态码: data.statusCode,
					响应头: data.responseHeaders,
					响应数据: data.responseData || data.responseBody || null
				}
			};

			const formatted = JSON.stringify(copyData, null, 2);

			// 复制到剪贴板
			navigator.clipboard
				.writeText(formatted)
				.then(() => {
					showMessage('已复制到剪贴板', 'success');
				})
				.catch(() => {
					// 降级方案
					const textarea = document.createElement('textarea');
					textarea.value = formatted;
					document.body.appendChild(textarea);
					textarea.select();
					document.execCommand('copy');
					document.body.removeChild(textarea);
					showMessage('已复制到剪贴板', 'success');
				});
		} else {
			showMessage('复制失败：请求数据不存在', 'error');
		}
	});
}

// 复制请求信息为图片
function copyRequestAsImage(requestId) {
	chrome.runtime.sendMessage({ action: 'getRequest', requestId: requestId }, response => {
		if (chrome.runtime.lastError) {
			console.error('Error:', chrome.runtime.lastError);
			showMessage('获取请求失败：' + chrome.runtime.lastError.message, 'error');
			return;
		}

		if (response && response.success && response.data) {
			const data = response.data;
			generateRequestImage(data)
				.then(() => {
					showMessage('图片已复制到剪贴板');
				})
				.catch(err => {
					console.error('Failed to copy image:', err);
					showMessage('复制图片失败：' + err.message, 'error');
				});
		} else {
			showMessage('复制失败：请求数据不存在', 'error');
		}
	});
}

// 生成请求信息图片
async function generateRequestImage(data) {
	// 解码URL
	let decodedUrl = data.url;
	if (decodedUrl) {
		try {
			decodedUrl = decodeURIComponent(decodedUrl);
		} catch (e) {
			try {
				const urlObj = new URL(decodedUrl);
				if (urlObj.search) {
					const params = new URLSearchParams(urlObj.search);
					const decodedParams = new URLSearchParams();
					for (const [key, value] of params.entries()) {
						try {
							decodedParams.append(decodeURIComponent(key), decodeURIComponent(value));
						} catch (err) {
							decodedParams.append(key, value);
						}
					}
					urlObj.search = decodedParams.toString();
					decodedUrl = urlObj.toString();
				}
			} catch (err) {
				// 使用原始URL
			}
		}
	}

	// 准备要显示的内容（使用对象来标记每行的类型和缩进）
	const contentLines = [];

	// 标题
	contentLines.push({ text: '网络请求信息', type: 'title' });
	contentLines.push({ text: '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', type: 'separator' });
	contentLines.push({ text: '', type: 'empty' });

	// 请求方法
	contentLines.push({ text: '请求方法: ' + data.method, type: 'label' });

	// 请求地址（可能需要换行）
	contentLines.push({ text: '请求地址: ' + decodedUrl, type: 'url' });
	contentLines.push({ text: '', type: 'empty' });

	// 请求载荷
	contentLines.push({ text: '请求载荷:', type: 'section' });
	const requestBodyLines = formatDataForImageLines(data.requestBody, 2);
	requestBodyLines.forEach(line => {
		contentLines.push({ text: line.text, type: line.type, indent: line.indent });
	});
	contentLines.push({ text: '', type: 'empty' });

	// 响应结构
	contentLines.push({ text: '响应结构:', type: 'section' });
	contentLines.push({ text: '  状态码: ' + (data.statusCode || 'N/A'), type: 'label', indent: 2 });
	contentLines.push({ text: '  响应头:', type: 'section', indent: 2 });
	const headerLines = formatHeadersForImageLines(data.responseHeaders, 4);
	headerLines.forEach(line => {
		contentLines.push({ text: line.text, type: line.type, indent: line.indent });
	});
	contentLines.push({ text: '  响应数据:', type: 'section', indent: 2 });
	const responseLines = formatDataForImageLines(data.responseData || data.responseBody || null, 2);
	responseLines.forEach(line => {
		contentLines.push({ text: line.text, type: line.type, indent: (line.indent || 0) + 2 });
	});
	contentLines.push({ text: '', type: 'empty' });

	// 时间
	contentLines.push({ text: '时间: ' + new Date(data.timestamp).toLocaleString(), type: 'label' });

	// 创建 Canvas
	const canvas = document.createElement('canvas');
	const ctx = canvas.getContext('2d');

	// 设置字体
	const fontSize = 13;
	const lineHeight = 22;
	const padding = 24;
	const indentSize = 20; // 每级缩进的大小
	const fontFamily = 'Consolas, Monaco, "Courier New", monospace';
	const maxLineWidth = 1400; // 最大宽度

	ctx.font = `${fontSize}px ${fontFamily}`;

	// 计算文本宽度和高度（考虑换行和缩进）
	let maxWidth = 0;
	const allLines = [];

	contentLines.forEach(item => {
		const indent = item.indent || 0;
		const indentStr = ' '.repeat(indent);
		const fullText = indentStr + item.text;

		const metrics = ctx.measureText(fullText);
		const lineWidth = metrics.width;
		const availableWidth = maxLineWidth - padding * 2;

		if (lineWidth > availableWidth && item.text) {
			// 需要换行（对于长URL或长字符串）
			const words = item.text.split('');
			let currentLine = '';
			for (let i = 0; i < words.length; i++) {
				const testLine = currentLine + words[i];
				const testFullText = indentStr + testLine;
				const testMetrics = ctx.measureText(testFullText);
				if (testMetrics.width > availableWidth && currentLine !== '') {
					allLines.push({ text: indentStr + currentLine, type: item.type, indent: indent });
					maxWidth = Math.max(maxWidth, ctx.measureText(indentStr + currentLine).width);
					currentLine = words[i];
				} else {
					currentLine = testLine;
				}
			}
			if (currentLine) {
				allLines.push({ text: indentStr + currentLine, type: item.type, indent: indent });
				maxWidth = Math.max(maxWidth, ctx.measureText(indentStr + currentLine).width);
			}
		} else {
			allLines.push({ text: fullText, type: item.type, indent: indent });
			maxWidth = Math.max(maxWidth, lineWidth);
		}
	});

	const textWidth = Math.min(maxWidth + padding * 2, maxLineWidth);
	const textHeight = allLines.length * lineHeight + padding * 2;

	canvas.width = textWidth;
	canvas.height = textHeight;

	// 重新设置字体
	ctx.font = `${fontSize}px ${fontFamily}`;

	// 绘制背景
	ctx.fillStyle = '#ffffff';
	ctx.fillRect(0, 0, canvas.width, canvas.height);

	// 绘制边框
	ctx.strokeStyle = '#e0e0e0';
	ctx.lineWidth = 1;
	ctx.strokeRect(0, 0, canvas.width, canvas.height);

	// 绘制标题背景
	ctx.fillStyle = '#409EFF';
	ctx.fillRect(0, 0, canvas.width, lineHeight + padding);

	// 绘制文本（带颜色区分）
	let y = padding + fontSize;

	// 颜色定义
	const colors = {
		title: '#ffffff',
		separator: '#ffffff',
		label: '#333333',
		url: '#409EFF',
		section: '#666666',
		key: '#881391', // JSON key 颜色（紫色）
		string: '#1A1AA6', // JSON string 颜色（蓝色）
		number: '#1C00CF', // JSON number 颜色（深蓝）
		boolean: '#0D22AA', // JSON boolean 颜色
		null: '#808080', // JSON null 颜色（灰色）
		empty: '#ffffff',
		default: '#333333'
	};

	allLines.forEach((item, index) => {
		const line = typeof item === 'string' ? item : item.text;
		const type = typeof item === 'string' ? 'default' : item.type || 'default';

		// 根据类型设置颜色和字体
		if (index === 0) {
			// 标题
			ctx.fillStyle = colors.title;
			ctx.font = `bold ${fontSize + 2}px ${fontFamily}`;
		} else if (index === 1) {
			// 分隔线
			ctx.fillStyle = colors.separator;
			ctx.font = `${fontSize}px ${fontFamily}`;
		} else {
			// 根据内容类型设置颜色
			let fillColor = colors[type] || colors.default;

			// 对于JSON内容，尝试识别类型
			if (type === 'default' || !colors[type]) {
				// 尝试识别JSON语法
				const trimmed = line.trim();
				if (trimmed.match(/^"[^"]+":/)) {
					// JSON key
					fillColor = colors.key;
				} else if (trimmed.match(/^".*"$/)) {
					// JSON string value
					fillColor = colors.string;
				} else if (trimmed.match(/^-?\d+\.?\d*$/)) {
					// JSON number
					fillColor = colors.number;
				} else if (trimmed === 'true' || trimmed === 'false') {
					// JSON boolean
					fillColor = colors.boolean;
				} else if (trimmed === 'null') {
					// JSON null
					fillColor = colors.null;
				} else {
					fillColor = colors[type] || colors.default;
				}
			}

			ctx.fillStyle = fillColor;
			ctx.font = `${fontSize}px ${fontFamily}`;
		}

		ctx.fillText(line, padding, y);
		y += lineHeight;
	});

	// 将 Canvas 转换为 Blob
	return new Promise((resolve, reject) => {
		canvas.toBlob(blob => {
			if (!blob) {
				reject(new Error('Failed to create image blob'));
				return;
			}

			// 复制到剪贴板
			if (navigator.clipboard && navigator.clipboard.write) {
				const clipboardItem = new ClipboardItem({ 'image/png': blob });
				navigator.clipboard
					.write([clipboardItem])
					.then(() => {
						resolve();
					})
					.catch(err => {
						reject(err);
					});
			} else {
				// 降级方案：下载图片
				const url = URL.createObjectURL(blob);
				const a = document.createElement('a');
				a.href = url;
				a.download = 'request-info.png';
				a.click();
				URL.revokeObjectURL(url);
				resolve();
			}
		}, 'image/png');
	});
}

// 格式化数据用于图片显示（返回行数组，每行包含文本、类型和缩进）
function formatDataForImageLines(data, baseIndent = 0) {
	if (data === null || data === undefined) {
		return [{ text: 'null', type: 'null', indent: baseIndent }];
	}

	if (typeof data === 'string') {
		// 尝试解析为 JSON
		try {
			const parsed = JSON.parse(data);
			return formatJsonLines(parsed, baseIndent);
		} catch (e) {
			// 不是JSON，作为普通字符串返回
			return [{ text: data, type: 'string', indent: baseIndent }];
		}
	}

	if (typeof data === 'object') {
		return formatJsonLines(data, baseIndent);
	}

	return [{ text: String(data), type: 'default', indent: baseIndent }];
}

// 格式化JSON为行数组（保持正确的缩进）
function formatJsonLines(obj, baseIndent = 0, indentStep = 2) {
	const lines = [];

	if (obj === null) {
		lines.push({ text: 'null', type: 'null', indent: baseIndent });
		return lines;
	}

	if (Array.isArray(obj)) {
		if (obj.length === 0) {
			lines.push({ text: '[]', type: 'default', indent: baseIndent });
			return lines;
		}
		lines.push({ text: '[', type: 'default', indent: baseIndent });
		obj.forEach((item, index) => {
			const itemLines = formatJsonLines(item, baseIndent + indentStep, indentStep);
			// 最后一个元素不需要逗号
			if (index < obj.length - 1) {
				itemLines[itemLines.length - 1].text += ',';
			}
			lines.push(...itemLines);
		});
		lines.push({ text: ']', type: 'default', indent: baseIndent });
		return lines;
	}

	if (typeof obj === 'object') {
		const keys = Object.keys(obj);
		if (keys.length === 0) {
			lines.push({ text: '{}', type: 'default', indent: baseIndent });
			return lines;
		}
		lines.push({ text: '{', type: 'default', indent: baseIndent });
		keys.forEach((key, index) => {
			const value = obj[key];
			const keyLine = `"${key}":`;
			const indent = baseIndent + indentStep;

			// 处理值
			if (value === null || value === undefined || typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean') {
				// 简单值，可以放在同一行
				let valueStr;
				if (typeof value === 'string') {
					valueStr = `"${value}"`;
				} else if (value === null) {
					valueStr = 'null';
				} else {
					valueStr = String(value);
				}
				const lineText = `${keyLine} ${valueStr}${index < keys.length - 1 ? ',' : ''}`;
				lines.push({ text: lineText, type: 'key', indent: indent });
			} else {
				// 复杂值（对象或数组），需要多行
				lines.push({ text: keyLine, type: 'key', indent: indent });
				const valueLines = formatJsonLines(value, indent, indentStep);
				if (index < keys.length - 1) {
					valueLines[valueLines.length - 1].text += ',';
				}
				lines.push(...valueLines);
			}
		});
		lines.push({ text: '}', type: 'default', indent: baseIndent });
		return lines;
	}

	// 基本类型
	let text = String(obj);
	if (typeof obj === 'string') {
		text = `"${obj}"`;
	}
	lines.push({ text: text, type: typeof obj, indent: baseIndent });
	return lines;
}

// 格式化响应头用于图片显示（返回行数组）
function formatHeadersForImageLines(headers, baseIndent = 0) {
	if (!headers || !Array.isArray(headers)) {
		return [{ text: 'null', type: 'null', indent: baseIndent }];
	}

	return headers.map(h => ({
		text: `${h.name}: ${h.value}`,
		type: 'label',
		indent: baseIndent
	}));
}

// 显示消息提示
function showMessage(message, type = 'success') {
	const messageDiv = document.createElement('div');
	messageDiv.textContent = message;
	messageDiv.style.cssText = `
		position: fixed;
		top: 10px;
		right: 10px;
		padding: 8px 16px;
		background: ${type === 'error' ? '#f56c6c' : '#67c23a'};
		color: white;
		border-radius: 4px;
		z-index: 10000;
		font-size: 12px;
	`;
	document.body.appendChild(messageDiv);

	setTimeout(() => {
		messageDiv.style.opacity = '0';
		messageDiv.style.transition = 'opacity 0.3s';
		setTimeout(() => {
			document.body.removeChild(messageDiv);
		}, 300);
	}, 2000);
}
