import request from '@/utils/request';

// 查询订单备份列表
export function listBack(query) {
	return request({
		url: '/system/back/list',
		method: 'get',
		params: query
	});
}

// 查询订单备份详细
export function getBack(id) {
	return request({
		url: '/system/back/' + id,
		method: 'get'
	});
}

// 新增订单备份
export function addBack(data) {
	return request({
		url: '/system/back',
		method: 'post',
		data: data
	});
}

// 修改订单备份
export function updateBack(data) {
	return request({
		url: '/system/back',
		method: 'put',
		data: data
	});
}

// 删除订单备份
export function delBack(id) {
	return request({
		url: '/system/back/' + id,
		method: 'delete'
	});
}
