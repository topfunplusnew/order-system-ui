import request from '@/utils/request';

// 查询通用附件列表
export function listAttachments(query) {
	return request({
		url: '/system/attachments/list',
		method: 'get',
		params: query
	});
}

// 查询通用附件详细
export function getAttachments(id) {
	return request({
		url: '/system/attachments/' + id,
		method: 'get'
	});
}

// 新增通用附件
export function addAttachments(data) {
	return request({
		url: '/system/attachments',
		method: 'post',
		data: data
	});
}

// 修改通用附件
export function updateAttachments(data) {
	return request({
		url: '/system/attachments',
		method: 'put',
		data: data
	});
}

// 删除通用附件
export function delAttachments(id) {
	return request({
		url: '/system/attachments/' + id,
		method: 'delete'
	});
}
