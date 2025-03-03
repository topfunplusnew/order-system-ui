// 一键导出接口
import service from '@/utils/request';

// 能否导出
export function canExportAll() {
	return service.request({
		url: '/system/allExport/canExport',
		method: 'get'
	});
}

// 获取当前进度
export function getExportProgress() {
	return service.request({
		url: '/system/allExport/getProgress',
		method: 'get'
	});
}

// 导出接口
export function exportAll(body) {
	return service.request({
		url: '/system/allExport/export',
		method: 'post',
		data: body
	});
}
