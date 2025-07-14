import request from '@/utils/request';

// 新增通用附件（文件上传）
export function addAttachments(file, params = {}) {
	const formData = new FormData();
	formData.append('file', file);

	// 构建查询参数
	const queryParams = new URLSearchParams();
	if (params.flag) {
		queryParams.append('flag', params.flag);
	}
	if (params.extraInfo) {
		queryParams.append('extraInfo', JSON.stringify(params.extraInfo));
	}

	const url = queryParams.toString() ? `/system/attachments?${queryParams.toString()}` : '/system/attachments';

	return request({
		url: url,
		method: 'post',
		data: formData,
		headers: {
			'Content-Type': 'multipart/form-data'
		}
	});
}

// 更新附件信息
export function updateAttachments(data) {
	return request({
		url: '/system/attachments',
		method: 'put',
		data: data
	});
}

// 删除附件
export function deleteAttachments(id) {
	return request({
		url: `/system/attachments/${id}`,
		method: 'delete'
	});
}

// 获取附件列表
export function getAttachmentsList(params) {
	return request({
		url: '/system/attachments',
		method: 'get',
		params: params
	});
}
