import request from '@/utils/request';

// 查询订单发票列表
export function listOrderinvoice(query) {
	return request({
		url: '/system/orderinvoice/list',
		method: 'get',
		params: query
	});
}

// 查询订单发票详细
export function getOrderinvoice(id) {
	return request({
		url: '/system/orderinvoice/' + id,
		method: 'get'
	});
}

// 新增订单发票
export function addOrderinvoice(data) {
	return request({
		url: '/system/orderinvoice',
		method: 'post',
		data: data
	});
}

// 修改订单发票
export function updateOrderinvoice(data) {
	return request({
		url: '/system/orderinvoice',
		method: 'put',
		data: data
	});
}

// 删除订单发票
export function delOrderinvoice(id) {
	return request({
		url: '/system/orderinvoice/' + id,
		method: 'delete'
	});
}
