import request from '@/utils/request';

// 查询车辆使用申请列表
export function listCarApply(query) {
	return request({
		url: '/system/carApply/list',
		method: 'get',
		params: query
	});
}

// 查询车辆使用申请详细
export function getCarApply(id) {
	return request({
		url: '/system/carApply/' + id,
		method: 'get'
	});
}

// 新增车辆使用申请
export function addCarApply(data) {
	return request({
		url: '/system/carApply',
		method: 'post',
		data: data
	});
}

// 修改车辆使用申请
export function updateCarApply(data) {
	return request({
		url: '/system/carApply',
		method: 'put',
		data: data
	});
}

// 删除车辆使用申请
export function delCarApply(id) {
	return request({
		url: '/system/carApply/' + id,
		method: 'delete'
	});
}
