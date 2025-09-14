import request from '@/utils/request';

// 查询现金记账列表
export function listRecord(query) {
	return request({
		url: '/system/record/list',
		method: 'get',
		params: query
	});
}

// 查询现金记账详细
export function getRecord(id) {
	return request({
		url: '/system/record/' + id,
		method: 'get'
	});
}

// 新增现金记账
export function addRecord(data) {
	return request({
		url: '/system/record',
		method: 'post',
		data: data
	});
}

// 批量新增现金记账
export function addRecordBatch(data) {
	return request({
		url: '/system/record/batch',
		method: 'post',
		data: data
	});
}

// 修改现金记账
export function updateRecord(data) {
	return request({
		url: '/system/record',
		method: 'put',
		data: data
	});
}

// 删除现金记账
export function delRecord(id) {
	return request({
		url: '/system/record/' + id,
		method: 'delete'
	});
}
