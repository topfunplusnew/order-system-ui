import request from '@/utils/request';

// 查询库房列表
export function listStoreHouse(query) {
	return request({
		url: '/system/StoreHouse/list',
		method: 'get',
		params: query
	});
}

// 查询库房详细
export function getStoreHouse(id) {
	return request({
		url: '/system/StoreHouse/' + id,
		method: 'get'
	});
}

// 新增库房
export function addStoreHouse(data) {
	return request({
		url: '/system/StoreHouse',
		method: 'post',
		data: data
	});
}

// 修改库房
export function updateStoreHouse(data) {
	return request({
		url: '/system/StoreHouse',
		method: 'put',
		data: data
	});
}

// 删除库房
export function delStoreHouse(id) {
	return request({
		url: '/system/StoreHouse/' + id,
		method: 'delete'
	});
}

// 查询仓库余额
export function getWarehouseBalance(params) {
	return request({
		url: '/system/inventoryStatistics/warehouseBalance',
		method: 'get',
		params: params
	});
}

// 导出仓库余额
export function exportWarehouseBalance(params) {
	return request({
		url: '/system/inventoryStatistics/exportWarehouseBalance',
		method: 'post',
		params: params,
		responseType: 'blob'
	});
}