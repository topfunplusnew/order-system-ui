import request from '@/utils/request';

// 查询固定资产列表
export function listFixedAssets(query) {
	return request({
		url: '/system/fixedAssets/list',
		method: 'get',
		params: query
	});
}

// 查询固定资产详细
export function getFixedAssets(id) {
	return request({
		url: '/system/fixedAssets/' + id,
		method: 'get'
	});
}

// 新增固定资产
export function addFixedAssets(data) {
	return request({
		url: '/system/fixedAssets',
		method: 'post',
		data: data
	});
}

// 修改固定资产
export function updateFixedAssets(data) {
	return request({
		url: '/system/fixedAssets',
		method: 'put',
		data: data
	});
}

// 删除固定资产
export function delFixedAssets(id) {
	return request({
		url: '/system/fixedAssets/' + id,
		method: 'delete'
	});
}
