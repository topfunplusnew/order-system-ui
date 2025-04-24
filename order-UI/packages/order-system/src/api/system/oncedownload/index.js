import service from '@/utils/request';

// ��ѯ�����ļ��б� (֧��ʱ�䷶Χɸѡ��ʱ�䵹������)
export function getAllExportList(query) {
	return service({
		url: '/system/allExport/list',
		method: 'get',
		params: query
	});
}

// һ�����أ�������̨�������ṩ���أ�
export function startExportAll(query) {
	return service({
		url: '/system/allExport/export',
		method: 'post',
		params: query
	});
}

// ɾ��ָ�����ļ�
export function deleteExport(fileName) {
	return service({
		url: '/system/allExport/delete',
		method: 'delete',
		params: {
			fileName // Ҫɾ�����ļ��� (����: "һ������(2025-03-26 10:14:56).xlsx")
		}
	});
}

// ����ָ���ĵ����ļ�
export function downloadFileByName(fileName) {
	return service({
		url: '/system/allExport/download',
		method: 'get',
		params: {
			fileName // Ҫ���ص��ļ��� (����: "һ������(2025-03-26 10:14:56).xlsx")
		}
	});
}

// ����һ�����أ�������̨����)
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
