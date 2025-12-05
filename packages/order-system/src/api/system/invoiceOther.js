import request from '@/utils/request';

// 查询商家直接给客户开发票列表
export function listInvoiceOther(query) {
	return request({
		url: '/system/invoiceOther/list',
		method: 'get',
		params: query
	});
}

// 查询商家直接给客户开发票详细
export function getInvoiceOther(id) {
	return request({
		url: '/system/invoiceOther/' + id,
		method: 'get'
	});
}

// 新增商家直接给客户开发票
export function addInvoiceOther(data) {
	return request({
		url: '/system/invoiceOther',
		method: 'post',
		data: data
	});
}

// 修改商家直接给客户开发票
export function updateInvoiceOther(data) {
	return request({
		url: '/system/invoiceOther',
		method: 'put',
		data: data
	});
}

// 删除商家直接给客户开发票
export function delInvoiceOther(id) {
	return request({
		url: '/system/invoiceOther/' + id,
		method: 'delete'
	});
}

// 更新商家直接给客户开发票的额外信息
export function updateInvoiceOtherExtra(id, extraInfo) {
	return request({
		url: '/system/invoiceOther/extraInfo/' + id,
		method: 'put',
		data: extraInfo
	});
}
