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

export function downloadFileByName(fileName) {
	return service({
		url: '/system/allExport/download',
		method: 'get',
		params: {
			fileName
		}
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
