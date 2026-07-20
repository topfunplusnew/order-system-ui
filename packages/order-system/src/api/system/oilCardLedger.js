/* 用户需求：创建主卡登记与副卡登记页面并完成油卡登记台账接口对接。实际改动：新增油卡登记台账列表、详情、新增、修改和删除请求方法。 */
import request from '@/utils/request';

export function listOilCardLedger(query) {
	return request({
		url: '/system/oilCardLedger/list',
		method: 'get',
		params: query
	});
}

export function getOilCardLedger(id) {
	return request({
		url: `/system/oilCardLedger/${id}`,
		method: 'get'
	});
}

export function addOilCardLedger(data) {
	return request({
		url: '/system/oilCardLedger',
		method: 'post',
		data
	});
}

export function updateOilCardLedger(data) {
	return request({
		url: '/system/oilCardLedger',
		method: 'put',
		data
	});
}

export function delOilCardLedger(ids) {
	return request({
		url: `/system/oilCardLedger/${ids}`,
		method: 'delete'
	});
}
