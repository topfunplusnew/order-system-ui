import request from '@/utils/request';

// 查询接口
export function getInternalFundsSummary(params) {
	return request({
		url: '/statistics/InternalFundsSummary',
		method: 'get',
		params: params
	});
}

// 导出接口
export function exportInternalFunds(params) {
	return request({
		url: '/statistics/export/ExportInternalFundsSummary',
		method: 'post',
		data: params,
		responseType: 'blob'
	});
}
