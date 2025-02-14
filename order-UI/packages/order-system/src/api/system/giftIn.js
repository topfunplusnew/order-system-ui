import request from '@/utils/request';

// 查询购入礼品信息列表
export function listGiftIn(query) {
	return request({
		url: '/system/giftIn/list',
		method: 'get',
		params: query
	});
}

// 查询购入礼品信息详细
export function getGiftIn(id) {
	return request({
		url: '/system/giftIn/' + id,
		method: 'get'
	});
}

// 新增购入礼品信息
export function addGiftIn(data) {
	return request({
		url: '/system/giftIn',
		method: 'post',
		data: data
	});
}

// 修改购入礼品信息
export function updateGiftIn(data) {
	return request({
		url: '/system/giftIn',
		method: 'put',
		data: data
	});
}

// 删除购入礼品信息
export function delGiftIn(id) {
	return request({
		url: '/system/giftIn/' + id,
		method: 'delete'
	});
}
