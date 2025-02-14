import request from '@/utils/request';

// 查询发票购入信息列表
export function listInvoiceIn(query) {
	return request({
		url: '/system/invoiceIn/list',
		method: 'get',
		params: query
	});
}

// 查询发票购入信息详细
export function getInvoiceIn(id) {
	return request({
		url: '/system/invoiceIn/' + id,
		method: 'get'
	});
}

// 新增发票购入信息
export function addInvoiceIn(data) {
	return request({
		url: '/system/invoiceIn',
		method: 'post',
		data: data
	});
}

// 修改发票购入信息
export function updateInvoiceIn(data) {
	return request({
		url: '/system/invoiceIn',
		method: 'put',
		data: data
	});
}

// 删除发票购入信息
export function delInvoiceIn(id) {
	return request({
		url: '/system/invoiceIn/' + id,
		method: 'delete'
	});
}
