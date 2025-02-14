import request from '@/utils/request';

// 查询产品级别列表
export function listProductLevel(query) {
	return request({
		url: '/system/productLevel/list',
		method: 'get',
		params: query
	});
}

// 查询产品级别详细
export function getProductLevel(id) {
	return request({
		url: '/system/productLevel/' + id,
		method: 'get'
	});
}

// 新增产品级别
export function addProductLevel(data) {
	return request({
		url: '/system/productLevel',
		method: 'post',
		data: data
	});
}

// 修改产品级别
export function updateProductLevel(data) {
	return request({
		url: '/system/productLevel',
		method: 'put',
		data: data
	});
}

// 删除产品级别
export function delProductLevel(id) {
	return request({
		url: '/system/productLevel/' + id,
		method: 'delete'
	});
}

// 查询各个分类最大的levelNo
export function getMaxLevelNo() {
	return request({
		url: '/system/productLevel/MaxLevelNo',
		method: 'get'
	});
}
