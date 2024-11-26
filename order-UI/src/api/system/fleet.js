import request from '@/utils/request';

// 查询车队列表
export function listFleet(query) {
	return request({
		url: '/system/fleet/list',
		method: 'get',
		params: query
	});
}

// 查询车队详细
export function getFleet(id) {
	return request({
		url: '/system/fleet/' + id,
		method: 'get'
	});
}

// 新增车队
export function addFleet(data) {
	return request({
		url: '/system/fleet',
		method: 'post',
		data: data
	});
}

// 修改车队
export function updateFleet(data) {
	return request({
		url: '/system/fleet',
		method: 'put',
		data: data
	});
}

// 删除车队
export function delFleet(id) {
	return request({
		url: '/system/fleet/' + id,
		method: 'delete'
	});
}
