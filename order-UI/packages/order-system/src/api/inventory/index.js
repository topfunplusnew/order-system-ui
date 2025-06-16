import request from '@/utils/request';

/**
 * 入库统计列表
 * @param {Object} query 查询参数
 * @returns {Promise}
 */
export function listInStatistics(query) {
	return request({
		url: '/system/inventoryStatistics/inStatistics',
		method: 'get',
		params: query
	});
}

/**
 * 出库统计列表
 * @param {Object} query 查询参数
 * @returns {Promise}
 */
export function listOutStatistics(query) {
	return request({
		url: '/system/inventoryStatistics/outStatistics',
		method: 'get',
		params: query
	});
}

/**
 * 导出入库统计
 * @param {Object} query 请求参数
 * @returns {Promise}
 */
export function exportInStatistics(query) {
	return request({
		url: '/system/inventoryStatistics/exportInStatistics',
		method: 'post',
		params: query
	});
}

/**
 * 导出出库统计
 * @param {Object} query 请求参数
 * @returns {Promise}
 */
export function exportOutStatistics(query) {
	return request({
		url: '/system/inventoryStatistics/exportOutStatistics',
		method: 'post',
		params: query
	});
}
