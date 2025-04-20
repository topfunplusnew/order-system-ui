import service from '@/utils/request';

// 查询导出文件列表 (支持时间范围筛选和时间倒序排序)
export function getAllExportList(query) {
	return service({
		url: '/system/allExport/list',
		method: 'get',
		params: query
	});
}

// 一键下载（触发后台导出并提供下载）
export function startExportAll(query) {
	return service({
		url: '/system/allExport/export',
		method: 'get',
		params: query
	});
}

// 删除指定的文件
export function deleteExport(fileName) {
	return service({
		url: '/system/allExport/delete',
		method: 'delete',
		params: {
			fileName // 要删除的文件名 (例如: "一键下载(2025-03-26 10:14:56).xlsx")
		}
	});
}

// 下载指定的导出文件
export function downloadFileByName(fileName) {
	return service({
		url: '/system/allExport/download',
		method: 'get',
		params: {
			fileName // 要下载的文件名 (例如: "一键下载(2025-03-26 10:14:56).xlsx")
		}
	});
}

// 请求一键下载（触发后台导出)
export function syncExportAll(date, exportEmptyData = false) {
	return service({
		url: '/system/allExport/syncExport',
		method: 'post',
		params: {
			date, // 2025-04-19
			exportEmptyData
		}
	});
}
