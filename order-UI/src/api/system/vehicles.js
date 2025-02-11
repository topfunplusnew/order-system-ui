import request from '@/utils/request';

// 查询车辆信息列表
export function listVehicles(query) {
	return request({
		url: '/system/vehicles/list',
		method: 'get',
		params: query
	});
}

// 查询车辆信息详细
export function getVehicles(id) {
	return request({
		url: '/system/vehicles/' + id,
		method: 'get'
	});
}

// 新增车辆信息
export function addVehicles(data) {
	return request({
		url: '/system/vehicles',
		method: 'post',
		data: data
	});
}

// 修改车辆信息
export function updateVehicles(data) {
	return request({
		url: '/system/vehicles',
		method: 'put',
		data: data
	});
}

// 删除车辆信息
export function delVehicles(id) {
	return request({
		url: '/system/vehicles/' + id,
		method: 'delete'
	});
}
