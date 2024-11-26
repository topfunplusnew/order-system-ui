import request from '@/utils/request';

/**
 * 查询全部发票
 * @param {any} query
 * @returns {any}
 */
export function listInvoiceAll(query) {
	return request({
		url: '/system/allinvoice/list',
		method: 'get',
		params: query
	});
}
