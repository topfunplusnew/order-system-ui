// 存储请求数据
const requestStore = new Map();
const MAX_STORE_SIZE = 1000; // 最多存储1000个请求

// Service Worker 启动时输出日志
console.log('Network Request Copier Service Worker started');
console.log('Request store initialized, current size:', requestStore.size);

// 确保 Service Worker 保持活跃
chrome.runtime.onStartup.addListener(() => {
	console.log('Extension started');
});

chrome.runtime.onInstalled.addListener(() => {
	console.log('Extension installed/updated');
});

// 监听所有网络请求
chrome.webRequest.onBeforeRequest.addListener(
	details => {
		// 只处理 http 和 https 请求
		if (!details.url.startsWith('http')) {
			return;
		}

		const requestId = details.requestId;

		// 获取请求体
		let requestBody = null;
		if (details.requestBody) {
			if (details.requestBody.formData) {
				requestBody = details.requestBody.formData;
			} else if (details.requestBody.raw) {
				// 对于原始数据，需要解码
				try {
					const decoder = new TextDecoder('utf-8');
					requestBody = details.requestBody.raw.map(item => decoder.decode(item.bytes)).join('');
				} catch (e) {
					requestBody = details.requestBody.raw;
				}
			} else if (details.requestBody.raw) {
				requestBody = details.requestBody;
			}
		}

		// 存储请求信息
		const requestInfo = {
			requestId: requestId,
			method: details.method,
			url: details.url,
			requestBody: requestBody,
			timestamp: Date.now(),
			requestHeaders: [], // 将在 onBeforeSendHeaders 中更新
			responseBody: null, // 将在 content script 中更新
			responseData: null // 解析后的响应数据
		};
		requestStore.set(requestId, requestInfo);
		console.log('[Background] Request stored:', requestId, details.method, details.url);

		// 限制存储大小
		if (requestStore.size > MAX_STORE_SIZE) {
			const firstKey = requestStore.keys().next().value;
			requestStore.delete(firstKey);
		}
	},
	{ urls: ['<all_urls>'] },
	['requestBody']
);

// 监听请求头（在发送请求之前）
chrome.webRequest.onBeforeSendHeaders.addListener(
	details => {
		const requestId = details.requestId;
		const stored = requestStore.get(requestId);

		if (stored) {
			stored.requestHeaders = details.requestHeaders || [];
		}
	},
	{ urls: ['<all_urls>'] },
	['requestHeaders']
);

// 监听响应头
chrome.webRequest.onHeadersReceived.addListener(
	details => {
		const requestId = details.requestId;
		const stored = requestStore.get(requestId);

		if (stored) {
			stored.statusCode = details.statusCode;
			stored.responseHeaders = details.responseHeaders || [];
		}
	},
	{ urls: ['<all_urls>'] },
	['responseHeaders']
);

// 监听响应完成
chrome.webRequest.onCompleted.addListener(
	details => {
		const requestId = details.requestId;
		const stored = requestStore.get(requestId);

		if (stored) {
			stored.completed = true;
			stored.statusCode = details.statusCode;
			console.log('Request completed:', details.method, details.url, details.statusCode);
		}
	},
	{ urls: ['<all_urls>'] }
);

// 监听响应错误
chrome.webRequest.onErrorOccurred.addListener(
	details => {
		const requestId = details.requestId;
		const stored = requestStore.get(requestId);

		if (stored) {
			stored.error = true;
			stored.errorInfo = details.error;
		}
	},
	{ urls: ['<all_urls>'] }
);

// 处理来自 content script 或 popup 的消息
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
	try {
		if (request.action === 'getRequest') {
			const requestData = requestStore.get(request.requestId);
			sendResponse({ success: true, data: requestData });
		} else if (request.action === 'getAllRequests') {
			// 返回最近的请求列表
			const requests = Array.from(requestStore.values())
				.filter(req => req.completed || req.error)
				.sort((a, b) => b.timestamp - a.timestamp)
				.slice(0, 100); // 最多返回100个
			console.log('Sending requests:', requests.length);
			sendResponse({ success: true, data: requests });
		} else if (request.action === 'clearRequests') {
			requestStore.clear();
			sendResponse({ success: true });
		} else if (request.action === 'updateResponse') {
			// 更新响应数据（来自 content script）
			const { requestKey, responseData } = request;
			console.log('[Background] Updating response for key:', requestKey);
			console.log('[Background] Response URL:', responseData?.url);
			console.log('[Background] Response status:', responseData?.status);
			console.log('[Background] Response body type:', typeof responseData?.body);
			console.log('[Background] Current requestStore size:', requestStore.size);

			// 查找匹配的请求并更新响应数据
			// 使用更灵活的匹配方式：URL 可能不完全一致（可能有查询参数顺序不同等）
			let matched = false;

			// 首先尝试精确匹配
			for (const [requestId, requestData] of requestStore.entries()) {
				const storedKey = `${requestData.method}:${requestData.url}`;
				const incomingKey = requestKey;

				console.log('[Background] Comparing:', storedKey, 'vs', incomingKey);

				// 精确匹配
				if (storedKey === incomingKey) {
					requestData.responseBody = responseData.bodyText;
					requestData.responseData = responseData.body;
					requestData.responseHeaders = Object.entries(responseData.headers || {}).map(([name, value]) => ({
						name: name,
						value: value
					}));
					if (!requestData.statusCode) {
						requestData.statusCode = responseData.status;
					}
					matched = true;
					console.log('[Background] Matched request (exact):', requestId, requestData.url);
					break;
				}
			}

			// 如果精确匹配失败，尝试模糊匹配
			if (!matched) {
				console.log('[Background] Exact match failed, trying fuzzy match...');
				for (const [requestId, requestData] of requestStore.entries()) {
					// 模糊匹配：比较 URL 路径和查询参数（忽略顺序）
					try {
						const storedUrl = new URL(requestData.url);
						const incomingUrl = new URL(responseData.url);

						// 比较路径和方法
						if (requestData.method === responseData.method && storedUrl.pathname === incomingUrl.pathname && storedUrl.host === incomingUrl.host) {
							// 比较查询参数
							const storedParams = new URLSearchParams(storedUrl.search);
							const incomingParams = new URLSearchParams(incomingUrl.search);

							let paramsMatch = true;
							for (const [key, value] of storedParams.entries()) {
								if (incomingParams.get(key) !== value) {
									paramsMatch = false;
									break;
								}
							}

							if (paramsMatch && storedParams.toString().length === incomingParams.toString().length) {
								requestData.responseBody = responseData.bodyText;
								requestData.responseData = responseData.body;
								requestData.responseHeaders = Object.entries(responseData.headers || {}).map(([name, value]) => ({
									name: name,
									value: value
								}));
								if (!requestData.statusCode) {
									requestData.statusCode = responseData.status;
								}
								matched = true;
								console.log('[Background] Matched request (fuzzy):', requestId, requestData.url);
								break;
							}
						}
					} catch (e) {
						// URL 解析失败，跳过
						console.warn('[Background] URL parse error:', e);
					}
				}
			}

			if (!matched) {
				console.warn('[Background] No matching request found for:', requestKey);
				console.warn('[Background] Available requests in store:');
				for (const [requestId, requestData] of requestStore.entries()) {
					console.warn('[Background]   -', requestId, `${requestData.method}:${requestData.url}`);
				}
			}

			sendResponse({ success: true });
		} else if (request.action === 'copyRequest') {
			// 复制请求信息到剪贴板
			const requestData = requestStore.get(request.requestId);
			if (requestData) {
				const copyData = {
					method: requestData.method,
					url: requestData.url,
					requestBody: requestData.requestBody,
					responseHeaders: requestData.responseHeaders,
					statusCode: requestData.statusCode,
					responseData: requestData.responseData,
					responseBody: requestData.responseBody
				};

				// 格式化数据
				const formatted = formatRequestData(copyData, request.format);
				copyToClipboard(formatted);
				sendResponse({ success: true });
			} else {
				sendResponse({ success: false, error: 'Request not found' });
			}
		} else {
			sendResponse({ success: false, error: 'Unknown action' });
		}
	} catch (error) {
		console.error('Error handling message:', error);
		sendResponse({ success: false, error: error.message });
	}
	return true; // 保持消息通道开放
});

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

// 格式化请求数据
function formatRequestData(data, format = 'json') {
	// 解码URL
	const decodedUrl = decodeUrl(data.url);

	if (format === 'json') {
		return JSON.stringify(
			{
				请求方法: data.method,
				请求地址: decodedUrl,
				请求载荷: data.requestBody,
				响应结构: {
					状态码: data.statusCode,
					响应头: data.responseHeaders,
					响应数据: data.responseData || data.responseBody || null
				}
			},
			null,
			2
		);
	} else if (format === 'curl') {
		// 生成 curl 命令格式
		let curl = `curl -X ${data.method} "${decodedUrl}"`;
		if (data.requestBody) {
			curl += ` \\\n  -d '${JSON.stringify(data.requestBody)}'`;
		}
		return curl;
	} else {
		// 简单文本格式
		return `请求方法: ${data.method}\n请求地址: ${decodedUrl}\n请求载荷: ${JSON.stringify(data.requestBody, null, 2)}\n响应结构: ${JSON.stringify({ 状态码: data.statusCode, 响应头: data.responseHeaders, 响应数据: data.responseData || data.responseBody || null }, null, 2)}`;
	}
}

// 复制到剪贴板（通过 content script）
function copyToClipboard(text) {
	// 发送消息给 content script 来执行复制
	chrome.tabs.query({ active: true, currentWindow: true }, tabs => {
		if (tabs[0]) {
			chrome.tabs.sendMessage(tabs[0].id, {
				action: 'copyToClipboard',
				text: text
			});
		}
	});
}

// 创建右键菜单
chrome.runtime.onInstalled.addListener(() => {
	chrome.contextMenus.create({
		id: 'copyRequestInfo',
		title: '复制请求信息',
		contexts: ['all']
	});
});

// 处理右键菜单点击
chrome.contextMenus.onClicked.addListener((info, tab) => {
	// 这个功能需要通过 content script 来实现
	chrome.tabs.sendMessage(tab.id, {
		action: 'showRequestList'
	});
});
