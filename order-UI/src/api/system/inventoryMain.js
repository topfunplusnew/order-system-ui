import request from '@/utils/request';

// 查询库存库存主表列表
export function listInventoryMain(query) {
	return request({
		url: '/system/inventoryMain/list',
		method: 'get',
		params: query
	});
}

// 查询库存库存主表详细
export function getInventoryMain(id) {
	return request({
		url: '/system/inventoryMain/' + id,
		method: 'get'
	});
}

// 新增库存库存主表
export function addInventoryMain(data) {
	return request({
		url: '/system/inventoryMain',
		method: 'post',
		data: data
	});
}

// 修改库存库存主表
export function updateInventoryMain(data) {
	return request({
		url: '/system/inventoryMain',
		method: 'put',
		data: data
	});
}

// 删除库存库存主表
export function delInventoryMain(id) {
	return request({
		url: '/system/inventoryMain/' + id,
		method: 'delete'
	});
}
