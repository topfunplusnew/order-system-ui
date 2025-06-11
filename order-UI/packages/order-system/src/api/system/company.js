import request from '@/utils/request';

//校验客户是否已经存在
export function checkCustomerIsExit(companyName, companyId) {
	return request({
		url: '/system/company/checkCustomerNameUnique',
		method: 'get',
		params: {
			companyName: companyName,
			id: companyId
		}
	});
}

//校验供应商会否已经存在
export function checkSupplierIsExit(companyName, companyId) {
	return request({
		url: '/system/company/checkSupplierNameUnique',
		method: 'get',
		params: {
			companyName: companyName,
			id: companyId
		}
	});
}

// 查询客户、供应商信息列表
export function listCompany(query) {
	return request({
		url: '/system/company/list',
		method: 'get',
		params: query
	});
}

// 查询客户、供应商信息详细
export function getCompany(id, params) {
	return request({
		url: '/system/company/' + id,
		method: 'get',
		params: {
			companyType: params
		}
	});
}

// 新增客户、供应商信息
export function addCompany(data) {
	return request({
		url: '/system/company',
		method: 'post',
		data: data
	});
}

// 修改客户、供应商信息
export function updateCompany(data) {
	return request({
		url: '/system/company',
		method: 'put',
		data: data
	});
}

// 删除客户、供应商信息
export function delCompany(id, params) {
	return request({
		url: '/system/company/' + id,
		method: 'delete',
		params: {
			companyType: params
		}
	});
}
