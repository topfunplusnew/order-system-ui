import request from '@/utils/request';

// 查询出差列表
export function listBusinessTrip(query) {
	return request({
		url: '/system/BusinessTrip/list',
		method: 'get',
		params: query
	});
}

// 查询出差详细
export function getBusinessTrip(id) {
	return request({
		url: '/system/BusinessTrip/' + id,
		method: 'get'
	});
}

// 新增出差
export function addBusinessTrip(data) {
	return request({
		url: '/system/BusinessTrip',
		method: 'post',
		data: data
	});
}

// 修改出差
export function updateBusinessTrip(data) {
	return request({
		url: '/system/BusinessTrip',
		method: 'put',
		data: data
	});
}

// 删除出差
export function delBusinessTrip(id) {
	return request({
		url: '/system/BusinessTrip/' + id,
		method: 'delete'
	});
}

// 查询车辆审核状态
export function getCarApplyAuditStatus(bTripId) {
	return request({
		url: '/system/BusinessTrip/carApplyAuditStatus/' + bTripId,
		method: 'get'
	});
}
