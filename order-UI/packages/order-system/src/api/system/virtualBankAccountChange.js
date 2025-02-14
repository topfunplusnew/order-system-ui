import request from '@/utils/request';

// 查询虚拟银行账号列表
export function listVirtualBankAccountChange(query) {
	return request({
		url: '/system/virtualBankAccountChange/list',
		method: 'get',
		params: query
	});
}

// 查询虚拟银行账号详细
export function getVirtualBankAccountChange(id) {
	return request({
		url: '/system/virtualBankAccountChange/' + id,
		method: 'get'
	});
}

// 新增虚拟银行账号
export function addVirtualBankAccountChange(data) {
	return request({
		url: '/system/virtualBankAccountChange',
		method: 'post',
		data: data
	});
}

// 修改虚拟银行账号
export function updateVirtualBankAccountChange(data) {
	return request({
		url: '/system/virtualBankAccountChange',
		method: 'put',
		data: data
	});
}

// 删除虚拟银行账号
export function delVirtualBankAccountChange(id) {
	return request({
		url: '/system/virtualBankAccountChange/' + id,
		method: 'delete'
	});
}
