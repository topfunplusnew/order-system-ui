let currentVersion = null;

export async function checkVersion() {
	try {
		// 添加时间戳参数强制绕过浏览器缓存
		const timestamp = new Date().getTime();
		const response = await fetch(`/version.json?t=${timestamp}`, {
			cache: 'no-store',
			headers: {
				'Cache-Control': 'no-cache, no-store, must-revalidate',
				'Pragma': 'no-cache',
				'Expires': '0'
			}
		});
		
		if (!response.ok) {
			console.error('版本检测失败: HTTP', response.status);
			return;
		}
		
		const data = await response.json();

		if (!currentVersion) {
			currentVersion = data.version;
			console.log('✅ 版本检测初始化，当前版本:', currentVersion);
			return;
		}

		if (data.version !== currentVersion) {
			console.log('🔄 检测到版本变化:', currentVersion, '->', data.version);
			currentVersion = data.version; // 更新当前版本号
			window.dispatchEvent(new CustomEvent('app-version-changed'));
		}
	} catch (error) {
		console.error('版本检测失败:', error);
	}
}
