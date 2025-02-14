import request from '@/utils/request';

// 查询社保基金列表
export function listSocialInsurance(query) {
	return request({
		url: '/system/socialInsurance/list',
		method: 'get',
		params: query
	});
}

// 查询社保基金详细
export function getSocialInsurance(id) {
	return request({
		url: '/system/socialInsurance/' + id,
		method: 'get'
	});
}

// 新增社保基金
export function addSocialInsurance(data) {
	return request({
		url: '/system/socialInsurance',
		method: 'post',
		data: data
	});
}

// 修改社保基金
export function updateSocialInsurance(data) {
	return request({
		url: '/system/socialInsurance',
		method: 'put',
		data: data
	});
}

// 删除社保基金
export function delSocialInsurance(id) {
	return request({
		url: '/system/socialInsurance/' + id,
		method: 'delete'
	});
}

// 批量新增社保基金
export function batchAddSocialInsurance(data) {
	return request({
		url: '/system/socialInsurance/batchAdd',
		method: 'post',
		data: data
	});
}
