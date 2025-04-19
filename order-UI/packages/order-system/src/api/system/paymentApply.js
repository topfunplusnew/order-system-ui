import request from '@/utils/request';

// 查询付款信息列表
export function listPaymentApply(query, data) {
	return request({
		url: '/system/paymentApply/list',
		method: 'post',
		params: query,
		data: data
	});
}

// 查询付款信息详细
export function getPaymentApply(id) {
	return request({
		url: '/system/paymentApply/' + id,
		method: 'get'
	});
}

// 新增付款信息
export function addPaymentApply(data) {
	return request({
		url: '/system/paymentApply',
		method: 'post',
		data: data
	});
}

// 修改付款信息
export function updatePaymentApply(data) {
	return request({
		url: '/system/paymentApply',
		method: 'put',
		data: data
	});
}

// 删除付款信息
export function delPaymentApply(id) {
	return request({
		url: '/system/paymentApply/' + id,
		method: 'delete'
	});
}
