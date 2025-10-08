// 获取发货列表
import request from '../../utils/request';

// 区域统计
export function getRegionalSummary(query) {
	return request({
		url: '/statistics/regionalSummary',
		method: 'get',
		params: query
	});
}

// 客户统计
export function getCustomerTotal(query) {
	return request({
		url: '/statistics/customerSummary',
		method: 'get',
		params: query
	});
}

// 供应商统计
export function getSalesManagerTotal(query) {
	return request({
		url: '/statistics/salesManagerSummary',
		method: 'get',
		params: query
	});
}

