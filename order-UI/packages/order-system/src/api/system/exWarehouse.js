import request from '@/utils/request';

// 查询出库列表
export function listExWarehouse(query) {
	return request({
		url: '/system/exWarehouse/list',
		method: 'get',
		params: query
	});
}

// 查询出库详细
export function getExWarehouse(id) {
	return request({
		url: '/system/exWarehouse/' + id,
		method: 'get'
	});
}

// 新增出库
export function addExWarehouse(data) {
	return request({
		url: '/system/exWarehouse',
		method: 'post',
		data: data
	});
}

// 修改出库
export function updateExWarehouse(data) {
	return request({
		url: '/system/exWarehouse',
		method: 'put',
		data: data
	});
}

// 删除出库
export function delExWarehouse(id) {
	return request({
		url: '/system/exWarehouse/' + id,
		method: 'delete'
	});
}
