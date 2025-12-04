import request from '@/utils/request';

/**
 * 查询库存子详细
 * @param {*} query
 * @returns
 */
export function listDetail(query) {
	return request({
		url: '/system/inventoryDetail/list',
		method: 'get',
		params: query
	});
}

// 查询库存子详细
export function getDetail(id) {
	return request({
		url: '/system/inventoryDetail/' + id,
		method: 'get'
	});
}

// 新增库存子
export function addDetail(data) {
	return request({
		url: '/system/inventoryDetail',
		method: 'post',
		data: data
	});
}

// 修改库存子
export function updateDetail(data) {
	return request({
		url: '/system/inventoryDetail',
		method: 'put',
		data: data
	});
}

// 删除库存子
export function delDetail(id) {
	return request({
		url: '/system/inventoryDetail/' + id,
		method: 'delete'
	});
}

// 根据明细ID获取完整的库存主表信息
export function getInventoryMainByDetailId(detailId) {
	return request({
		url: '/system/inventoryMain/getByDetailId/' + detailId,
		method: 'get'
	});
}
