// 获取当前是否可以下载

import service from '@/utils/request';

export function getDownLoadStatus() {
	return new Promise((resolve, reject) => {
		service
			.request({
				url: '/system/allExport/canExport',
				method: 'GET'
			})
			.then(res => {
				resolve(res.data);
			})
			.catch(err => {
				reject(err);
			});
	});
}

// 获取当前下载进度
export function getDownLoadProgress() {
	return service.request({
		url: '/system/allExport/getProgress',
		method: 'GET'
	});
}

// 重置下载进度
export function resetDownLoadProgress() {
	return service.request({
		url: '/system/allExport/resetExportStatus',
		method: 'POST'
	});
}
