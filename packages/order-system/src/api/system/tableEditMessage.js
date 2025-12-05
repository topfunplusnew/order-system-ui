import request from '@/utils/request';

// 查询编辑原因列表
export function listTableEditMessage(query) {
	return request({
		url: '/system/tableEditMessage/list',
		method: 'get',
		params: query
	});
}

// 查询编辑原因详细
export function getTableEditMessage(id) {
	return request({
		url: '/system/tableEditMessage/' + id,
		method: 'get'
	});
}

// 新增编辑原因
export function addTableEditMessage(data) {
	return request({
		url: '/system/tableEditMessage',
		method: 'post',
		data: data
	});
}

// 修改编辑原因
export function updateTableEditMessage(data) {
	return request({
		url: '/system/tableEditMessage',
		method: 'put',
		data: data
	});
}

// 删除编辑原因
export function delTableEditMessage(id) {
	return request({
		url: '/system/tableEditMessage/' + id,
		method: 'delete'
	});
}
