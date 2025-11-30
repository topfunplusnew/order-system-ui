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
					<button class="btn btn-primary copy-btn" data-request-id="${req.requestId}" style="font-size: 11px; padding: 4px 8px; margin-left: auto; flex-shrink: 0;">复制</button>
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
					响应头: data.responseHeaders
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
