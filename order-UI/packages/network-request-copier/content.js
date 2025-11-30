// 注入到页面的脚本，用于显示请求列表和复制功能

// 创建浮动按钮
let floatingButton = null;
let requestListPanel = null;

// 监听来自 background 的消息
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
	if (request.action === 'copyToClipboard') {
		copyToClipboard(request.text);
		sendResponse({ success: true });
	} else if (request.action === 'showRequestList') {
		showRequestList();
		sendResponse({ success: true });
	}
	return true;
});

// 创建浮动按钮
function createFloatingButton() {
	if (floatingButton) {
		return;
	}

	floatingButton = document.createElement('div');
	floatingButton.id = 'network-request-copier-btn';
	floatingButton.innerHTML = '📋';
	floatingButton.style.cssText = `
		position: fixed;
		bottom: 20px;
		right: 20px;
		width: 50px;
		height: 50px;
		background: #409EFF;
		color: white;
		border-radius: 50%;
		display: flex;
		align-items: center;
		justify-content: center;
		cursor: pointer;
		z-index: 999999;
		box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
		font-size: 24px;
		user-select: none;
	`;
	floatingButton.addEventListener('click', showRequestList);
	document.body.appendChild(floatingButton);
}

// 显示请求列表面板
function showRequestList() {
	if (requestListPanel) {
		requestListPanel.style.display = requestListPanel.style.display === 'none' ? 'block' : 'none';
		return;
	}

	// 创建面板
	requestListPanel = document.createElement('div');
	requestListPanel.id = 'network-request-copier-panel';
	requestListPanel.style.cssText = `
		position: fixed;
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
		width: 900px;
		max-height: 80vh;
		background: white;
		border-radius: 8px;
		box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
		z-index: 1000000;
		display: flex;
		flex-direction: column;
		font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
		overflow-x: hidden;
		box-sizing: border-box;
	`;

	// 创建头部
	const header = document.createElement('div');
	header.style.cssText = `
		padding: 16px;
		border-bottom: 1px solid #e0e0e0;
		display: flex;
		justify-content: space-between;
		align-items: center;
		background: #f5f5f5;
		border-radius: 8px 8px 0 0;
	`;
	header.innerHTML = `
		<h3 style="margin: 0; font-size: 18px; color: #333;">网络请求列表</h3>
		<div>
			<button id="refresh-btn" style="margin-right: 8px; padding: 6px 12px; background: #409EFF; color: white; border: none; border-radius: 4px; cursor: pointer;">刷新</button>
			<button id="clear-btn" style="margin-right: 8px; padding: 6px 12px; background: #f56c6c; color: white; border: none; border-radius: 4px; cursor: pointer;">清空</button>
			<button id="close-btn" style="padding: 6px 12px; background: #909399; color: white; border: none; border-radius: 4px; cursor: pointer;">关闭</button>
		</div>
	`;

	// 创建内容区域
	const content = document.createElement('div');
	content.id = 'request-list-content';
	content.style.cssText = `
		padding: 16px;
		overflow-y: auto;
		overflow-x: hidden;
		flex: 1;
		width: 100%;
		max-width: 100%;
		box-sizing: border-box;
	`;

	// 创建遮罩层
	const overlay = document.createElement('div');
	overlay.style.cssText = `
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background: rgba(0, 0, 0, 0.5);
		z-index: 999999;
	`;

	requestListPanel.appendChild(header);
	requestListPanel.appendChild(content);
	document.body.appendChild(overlay);
	document.body.appendChild(requestListPanel);

	// 绑定事件
	document.getElementById('close-btn').addEventListener('click', () => {
		requestListPanel.style.display = 'none';
		overlay.style.display = 'none';
	});

	document.getElementById('clear-btn').addEventListener('click', () => {
		chrome.runtime.sendMessage({ action: 'clearRequests' }, () => {
			loadRequestList();
		});
	});

	document.getElementById('refresh-btn').addEventListener('click', () => {
		loadRequestList();
	});

	overlay.addEventListener('click', () => {
		requestListPanel.style.display = 'none';
		overlay.style.display = 'none';
	});

	// 加载请求列表
	loadRequestList();
}

// 加载请求列表
function loadRequestList() {
	const content = document.getElementById('request-list-content');
	if (!content) return;

	content.innerHTML = '<div style="text-align: center; padding: 20px; color: #999;">加载中...</div>';

	chrome.runtime.sendMessage({ action: 'getAllRequests' }, response => {
		if (response && response.success) {
			renderRequestList(response.data);
		} else {
			content.innerHTML = '<div style="text-align: center; padding: 20px; color: #f56c6c;">加载失败</div>';
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

// HTML转义函数
function escapeHtml(text) {
	const div = document.createElement('div');
	div.textContent = text;
	return div.innerHTML;
}

// 渲染请求列表
function renderRequestList(requests) {
	const content = document.getElementById('request-list-content');
	if (!content) return;

	if (requests.length === 0) {
		content.innerHTML = '<div style="text-align: center; padding: 20px; color: #999;">暂无请求数据</div>';
		return;
	}

	let html = '<div style="display: flex; flex-direction: column; gap: 12px;">';

	requests.forEach(req => {
		const methodColor = getMethodColor(req.method);
		const statusColor = req.statusCode >= 200 && req.statusCode < 300 ? '#67c23a' : req.statusCode >= 400 ? '#f56c6c' : '#e6a23c';

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
			paramsHtml =
				'<div style="margin-top: 8px; padding: 8px; background: #f5f5f5; border-radius: 4px; font-size: 11px; overflow-x: hidden; word-wrap: break-word; width: 100%; max-width: 100%; box-sizing: border-box;"><div style="font-weight: bold; color: #666; margin-bottom: 4px;">查询参数：</div>';
			for (const [key, value] of Object.entries(params)) {
				paramsHtml += `<div style="padding: 2px 0; word-break: break-all; width: 100%; max-width: 100%; overflow-wrap: break-word; box-sizing: border-box;"><span style="color: #409EFF; font-weight: 500;">${escapeHtml(key)}</span>: <span style="color: #67c23a; margin-left: 4px;">${escapeHtml(
					value
				)}</span></div>`;
			}
			paramsHtml += '</div>';
		}

		html += `
			<div style="border: 1px solid #e0e0e0; border-radius: 4px; padding: 12px; background: #fafafa; overflow-x: hidden; word-wrap: break-word; width: 100%; max-width: 100%; box-sizing: border-box;">
				<div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px; flex-wrap: wrap; width: 100%; max-width: 100%; box-sizing: border-box;">
					<span style="padding: 2px 8px; background: ${methodColor}; color: white; border-radius: 4px; font-size: 12px; font-weight: bold; flex-shrink: 0;">${req.method}</span>
					${req.statusCode ? `<span style="padding: 2px 8px; background: ${statusColor}; color: white; border-radius: 4px; font-size: 12px; flex-shrink: 0;">${req.statusCode}</span>` : ''}
					<button class="copy-btn" data-request-id="${req.requestId}" style="padding: 4px 12px; background: #409EFF; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; margin-left: auto; flex-shrink: 0;">复制</button>
				</div>
				<div style="font-size: 12px; color: #333; word-break: break-all; margin-bottom: 8px; overflow-x: hidden; width: 100%; max-width: 100%; overflow-wrap: break-word; box-sizing: border-box;">${escapeHtml(displayUrl)}</div>
				${paramsHtml}
				<div style="font-size: 11px; color: #999; margin-top: 8px;">${new Date(req.timestamp).toLocaleString()}</div>
			</div>
		`;
	});

	html += '</div>';
	content.innerHTML = html;

	// 绑定复制按钮事件
	content.querySelectorAll('.copy-btn').forEach(btn => {
		btn.addEventListener('click', e => {
			const requestId = e.target.getAttribute('data-request-id');
			copyRequestInfo(requestId);
		});
	});
}

// 获取请求方法的颜色
function getMethodColor(method) {
	const colors = {
		GET: '#67c23a',
		POST: '#409EFF',
		PUT: '#e6a23c',
		DELETE: '#f56c6c',
		PATCH: '#909399'
	};
	return colors[method] || '#909399';
}

// 解码URL，去除URL编码
function decodeUrl(url) {
	if (!url) return url;
	try {
		// 尝试解码整个URL
		return decodeURIComponent(url);
	} catch (e) {
		// 如果解码失败，尝试分段解码
		try {
			const urlObj = new URL(url);
			// 解码查询参数
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
				return urlObj.toString();
			}
			return url;
		} catch (err) {
			// 如果都失败了，返回原始URL
			return url;
		}
	}
}

// 复制请求信息
function copyRequestInfo(requestId) {
	chrome.runtime.sendMessage({ action: 'getRequest', requestId: requestId }, response => {
		if (response && response.success && response.data) {
			const data = response.data;

			// 解码URL
			const decodedUrl = decodeUrl(data.url);

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
			copyToClipboard(formatted);

			// 显示提示
			showToast('已复制到剪贴板');
		} else {
			showToast('复制失败：请求数据不存在', 'error');
		}
	});
}

// 复制到剪贴板
function copyToClipboard(text) {
	const textarea = document.createElement('textarea');
	textarea.value = text;
	textarea.style.position = 'fixed';
	textarea.style.opacity = '0';
	document.body.appendChild(textarea);
	textarea.select();
	document.execCommand('copy');
	document.body.removeChild(textarea);
}

// 显示提示
function showToast(message, type = 'success') {
	const toast = document.createElement('div');
	toast.textContent = message;
	toast.style.cssText = `
		position: fixed;
		top: 20px;
		right: 20px;
		padding: 12px 24px;
		background: ${type === 'error' ? '#f56c6c' : '#67c23a'};
		color: white;
		border-radius: 4px;
		z-index: 1000001;
		box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
		font-size: 14px;
	`;
	document.body.appendChild(toast);

	setTimeout(() => {
		toast.style.opacity = '0';
		toast.style.transition = 'opacity 0.3s';
		setTimeout(() => {
			document.body.removeChild(toast);
		}, 300);
	}, 2000);
}

// 页面加载完成后创建浮动按钮
function initFloatingButton() {
	if (document.body) {
		createFloatingButton();
	} else {
		// 如果 body 还不存在，等待 DOM 加载
		const observer = new MutationObserver((mutations, obs) => {
			if (document.body) {
				createFloatingButton();
				obs.disconnect();
			}
		});
		observer.observe(document.documentElement, {
			childList: true,
			subtree: true
		});
	}
}

if (document.readyState === 'loading') {
	document.addEventListener('DOMContentLoaded', initFloatingButton);
} else {
	initFloatingButton();
}
