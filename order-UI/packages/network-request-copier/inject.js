// 注入到页面上下文的脚本，用于拦截 XMLHttpRequest 和 fetch
// 这个脚本运行在页面上下文中，可以访问页面的 window 对象

// 防止重复注入
if (window.__NETWORK_REQUEST_COPIER_INJECTED__) {
	console.log('[Inject Script] Already injected, skipping');
} else {
	window.__NETWORK_REQUEST_COPIER_INJECTED__ = true;
	console.log('[Inject Script] Network Request Copier inject script loaded at', new Date().toISOString());

	// 获取完整 URL
	function getFullUrl(url) {
		if (!url) return url;
		try {
			// 如果是完整 URL，直接返回
			if (url.startsWith('http://') || url.startsWith('https://')) {
				return url;
			}
			// 如果是相对路径，转换为完整 URL
			return new URL(url, window.location.origin).href;
		} catch (e) {
			return url;
		}
	}

	// 拦截 fetch 请求
	console.log('[Inject Script] Setting up fetch interceptor');
	const originalFetch = window.fetch;
	window.fetch = function (...args) {
		let url = typeof args[0] === 'string' ? args[0] : args[0].url;
		url = getFullUrl(url);
		const method = args[1]?.method || 'GET';
		const requestKey = `${method}:${url}`;

		return originalFetch
			.apply(this, args)
			.then(response => {
				// 克隆响应以便读取
				const clonedResponse = response.clone();

				// 尝试读取响应体
				clonedResponse
					.text()
					.then(text => {
						try {
							// 尝试解析为 JSON
							const jsonData = JSON.parse(text);
							const responseInfo = {
								url: url,
								method: method,
								status: response.status,
								statusText: response.statusText,
								headers: Object.fromEntries(response.headers.entries()),
								body: jsonData,
								bodyText: text,
								timestamp: Date.now()
							};

							console.log('[Inject Script] Fetch Response captured:', requestKey, 'Status:', response.status, 'Body type:', typeof jsonData);

							// 通过 window.postMessage 发送给 content script
							window.postMessage(
								{
									type: 'NETWORK_REQUEST_COPIER_RESPONSE',
									action: 'updateResponse',
									requestKey: requestKey,
									responseData: responseInfo
								},
								'*'
							);
						} catch (e) {
							// 如果不是 JSON，存储为文本
							const responseInfo = {
								url: url,
								method: method,
								status: response.status,
								statusText: response.statusText,
								headers: Object.fromEntries(response.headers.entries()),
								body: text,
								bodyText: text,
								timestamp: Date.now()
							};

							console.log('[Inject Script] Fetch Response captured (text):', requestKey, 'Status:', response.status);

							// 通过 window.postMessage 发送给 content script
							window.postMessage(
								{
									type: 'NETWORK_REQUEST_COPIER_RESPONSE',
									action: 'updateResponse',
									requestKey: requestKey,
									responseData: responseInfo
								},
								'*'
							);
						}
					})
					.catch(err => {
						console.warn('[Inject Script] Failed to read response body:', err);
					});

				return response;
			})
			.catch(error => {
				return Promise.reject(error);
			});
	};

	// 拦截 XMLHttpRequest
	console.log('[Inject Script] Setting up XMLHttpRequest interceptor');
	const originalXHROpen = XMLHttpRequest.prototype.open;
	const originalXHRSend = XMLHttpRequest.prototype.send;

	XMLHttpRequest.prototype.open = function (method, url, ...rest) {
		this._method = method;
		this._url = url;
		// 存储原始 URL，因为 axios 可能会修改它
		this._originalUrl = url;
		return originalXHROpen.apply(this, [method, url, ...rest]);
	};

	XMLHttpRequest.prototype.send = function (...args) {
		const method = this._method || 'GET';
		const originalUrl = this._originalUrl || this._url || '';

		// 监听响应
		this.addEventListener('load', function () {
			try {
				// 获取最终请求的 URL（axios 可能会修改 URL）
				const finalUrl = this.responseURL || this._url || originalUrl;
				let url = getFullUrl(finalUrl);
				const originalFullUrl = getFullUrl(originalUrl);

				// 使用最终 URL 作为主要 key
				const requestKey = `${method}:${url}`;
				const originalRequestKey = `${method}:${originalFullUrl}`;

				let responseData = null;
				let responseText = this.responseText;

				// 尝试解析为 JSON
				try {
					responseData = JSON.parse(responseText);
				} catch (e) {
					responseData = responseText;
				}

				const responseInfo = {
					url: url,
					originalUrl: originalFullUrl, // 保存原始 URL 用于匹配
					method: method,
					status: this.status,
					statusText: this.statusText,
					headers: {},
					body: responseData,
					bodyText: responseText,
					timestamp: Date.now()
				};

				// 获取响应头
				const responseHeaders = this.getAllResponseHeaders();
				if (responseHeaders) {
					const headers = {};
					responseHeaders.split('\r\n').forEach(line => {
						const parts = line.split(': ');
						if (parts.length === 2) {
							headers[parts[0].toLowerCase()] = parts[1];
						}
					});
					responseInfo.headers = headers;
				}

				console.log('[Inject Script] XHR Response captured:', requestKey, 'Status:', this.status, 'Body type:', typeof responseData, 'Body:', responseData ? 'has data' : 'null');

				// 通过 window.postMessage 发送给 content script（使用两个 key 都尝试）
				window.postMessage(
					{
						type: 'NETWORK_REQUEST_COPIER_RESPONSE',
						action: 'updateResponse',
						requestKey: requestKey,
						responseData: responseInfo
					},
					'*'
				);

				if (originalRequestKey !== requestKey) {
					window.postMessage(
						{
							type: 'NETWORK_REQUEST_COPIER_RESPONSE',
							action: 'updateResponse',
							requestKey: originalRequestKey,
							responseData: responseInfo
						},
						'*'
					);
				}
			} catch (err) {
				console.warn('[Inject Script] Failed to capture XHR response:', err);
			}
		});

		// 也监听 error 事件
		this.addEventListener('error', function () {
			console.warn('[Inject Script] XHR request failed:', originalUrl);
		});

		return originalXHRSend.apply(this, args);
	};

	console.log('[Inject Script] Interceptors installed successfully');
}
