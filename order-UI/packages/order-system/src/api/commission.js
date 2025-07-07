// 厂家佣金和客户佣金
import service from '@/utils/request';

// 返回的结果中 id是空的数据说明没有佣金信息 可以新增，否则不可以 只能付款
export function listCommission(query, type, companyName = '') {
	return service.request({
		url: '/system/ordercommission/list',
		method: 'get',
		params: {
			...query,
			type,
			companyName
		}
	});
}

export function getCommission(id) {
	return service.request({
		url: '/system/ordercommission/' + id,
		method: 'get'
	});
}

export function addCommission(data) {
	return service.request({
		url: '/system/ordercommission',
		method: 'post',
		data: data
	});
}

export function updateCommission(data) {
	return service.request({
		url: '/system/ordercommission',
		method: 'put',
		data: data
	});
}

export function deleteCommission(id) {
	return service.request({
		url: '/system/ordercommission/' + id,
		method: 'delete'
	});
}

// 填写差异原因
export function updateDifferenceReason(id, differenceReason) {
	return service.request({
		url: `/system/ordercommission/reason/${id}`,
		method: 'put',
		params: {
			differenceReason
		}
	});
}
