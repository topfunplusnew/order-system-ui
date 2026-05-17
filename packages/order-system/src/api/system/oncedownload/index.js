import service from '@/utils/request';

export function getAllExportList(query) {
	return service({
		url: '/system/allExport/list',
		method: 'get',
		params: query
	});
}

export function startExportAll(query) {
	return service({
		url: '/system/allExport/export',
		method: 'post',
		params: query
	});
}

export function deleteExport(fileName) {
	return service({
		url: '/system/allExport/delete',
		method: 'delete',
		params: {
			fileName
		}
	});
}

/**
 * 批量删除导出文件（一键清空当前列表）
 * @param {Array<number|string>} ids - 导出文件 id 列表
 * @returns {Promise}
 */
export function batchDeleteExport(ids) {
	return service({
		url: '/system/allExport/delete',
		method: 'delete',
		data: ids
	});
}

export function downloadFileByName(fileName) {
	return service({
		url: '/system/allExport/download',
		method: 'get',
		params: {
			fileName
		},
		responseType: 'blob'
	});
}

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
