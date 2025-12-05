import request from '@/utils/request';

/**
 * 导出入库统计
 * @param {Object} query 请求参数
 * @returns {Promise}
 */
export function listMoneyDetail(query) {
	return request({
		url: '/system/expenseDetail/list',
		method: 'get',
		params: query
	});
}

/**
 * 导出出库统计
 * @param {Object} query 请求参数
 * @returns {Promise}
 */
export function exportMoneyDetail(query) {
	return request({
		url: '/system/expenseDetail/export',
		method: 'post',
		params: query
	});
}
