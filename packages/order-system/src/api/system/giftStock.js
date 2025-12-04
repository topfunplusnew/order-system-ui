import request from '@/utils/request';

export function listGiftStock(query) {
	return request({
		url: '/system/giftStock/list',
		method: 'get',
		params: query
	});
}
// 在 api/system/giftStock.js 中
// import request from '@/utils/request'

export function saveGiftStock(data) {
	return request({
		url: '/system/giftStock/save',
		method: 'post',
		data: data
	});
}
