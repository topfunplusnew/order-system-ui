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
	// TODO 这里可能需要改成批量 等待后端
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

// 批量上传附件：files 可以是 FileList、File[] 或者 { filename: File }
// params 为按文件名映射的元数据对象，后端会根据文件名匹配对应的 metadata
export function addAttachmentsBatch(files, params = {}) {
	const formData = new FormData();

	// 规范化 files 到数组
	let fileArray = [];
	if (!files) fileArray = [];
	else if (files instanceof FileList) fileArray = Array.from(files);
	else if (Array.isArray(files)) fileArray = files;
	else if (typeof files === 'object') {
		// 可能是 { filename: File } 的映射
		fileArray = Object.keys(files).map(k => files[k]);
	}

	// 将所有文件追加到 formData，后端按 filename 识别
	fileArray.forEach(file => {
		// 第三个参数确保浏览器发送原始文件名
		if (file && file.name) {
			formData.append('files', file, file.name);
		}
	});

	// 将 params 放到查询参数中（序列化为 JSON 字符串）
	const queryParams = new URLSearchParams();
	queryParams.append('fileAttachmentMap', JSON.stringify(params || {}));
	const url = `/system/attachments/batch?${queryParams.toString()}`;

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
