import request from '@/utils/request';

// 查询外部车辆信息列表
export function listCars(query) {
	return request({
		url: '/system/cars/list',
		method: 'get',
		params: query
	});
}

// 查询外部车辆信息详细
export function getCars(id) {
	return request({
		url: '/system/cars/' + id,
		method: 'get'
	});
}

// 新增外部车辆信息
export function addCars(data) {
	return request({
		url: '/system/cars',
		method: 'post',
		data: data
	});
}

// 修改外部车辆信息
export function updateCars(data) {
	return request({
		url: '/system/cars',
		method: 'put',
		data: data
	});
}

// 删除外部车辆信息
export function delCars(id) {
	return request({
		url: '/system/cars/' + id,
		method: 'delete'
	});
}
