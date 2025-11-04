let currentVersion = null;

export async function checkVersion() {
	try {
		const response = await fetch('/version.json', { cache: 'no-store' });
		const data = await response.json();

		if (!currentVersion) {
			currentVersion = data.version;
			return;
		}

		if (data.version !== currentVersion) {
			window.dispatchEvent(new CustomEvent('app-version-changed'));
		}
	} catch (error) {
		console.error('版本检测失败:', error);
	}
}
