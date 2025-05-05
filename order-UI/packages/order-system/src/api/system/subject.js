import request from '@/utils/request';

// 查询科目列表
export function listSubject(query) {
	return request({
		url: '/system/subject/list',
		method: 'get',
		params: query
	});
}

// 查询科目详细
export function getSubject(id) {
	return request({
		url: '/system/subject/' + id,
		method: 'get'
	});
}

// 新增科目
export function addSubject(data) {
	return request({
		url: '/system/subject',
		method: 'post',
		data: data
	});
}

// 修改科目
export function updateSubject(data) {
	return request({
		url: '/system/subject',
		method: 'put',
		data: data
	});
}

// 删除科目
export function delSubject(id) {
	return request({
		url: '/system/subject/' + id,
		method: 'delete'
	});
}

// 根据级别编码 获取产品级别
export function getSubjectLevel(no) {
	return request({
		url: '/system/subject/subjectno/' + no,
		method: 'get'
	});
}

// 获取一个产品级别的树形结构
export function getSubjectLevelTree(no) {
	return request({
		url: '/system/subject/subjecttree/' + no,
		method: 'get'
	});
}
