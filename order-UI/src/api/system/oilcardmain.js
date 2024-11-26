import request from '@/utils/request';

// 查询基础信息-加油卡主卡登记列表
export function listOilcardmain(query) {
	return request({
		url: '/system/oilcardmain/list',
		method: 'get',
		params: query
	});
}

// 查询基础信息-加油卡主卡登记详细
export function getOilcardmain(id) {
	return request({
		url: '/system/oilcardmain/' + id,
		method: 'get'
	});
}

// 新增基础信息-加油卡主卡登记
export function addOilcardmain(data) {
	return request({
		url: '/system/oilcardmain',
		method: 'post',
		data: data
	});
}

// 修改基础信息-加油卡主卡登记
export function updateOilcardmain(data) {
	return request({
		url: '/system/oilcardmain',
		method: 'put',
		data: data
	});
}

// 删除基础信息-加油卡主卡登记
export function delOilcardmain(id) {
	return request({
		url: '/system/oilcardmain/' + id,
		method: 'delete'
	});
}
