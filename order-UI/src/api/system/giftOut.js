import request from '@/utils/request';

// 查询礼品出库信息列表
export function listGiftOut(query) {
	return request({
		url: '/system/giftOut/list',
		method: 'get',
		params: query
	});
}

// 查询礼品出库信息详细
export function getGiftOut(id) {
	return request({
		url: '/system/giftOut/' + id,
		method: 'get'
	});
}

// 新增礼品出库信息
export function addGiftOut(data) {
	return request({
		url: '/system/giftOut',
		method: 'post',
		data: data
	});
}

// 修改礼品出库信息
export function updateGiftOut(data) {
	return request({
		url: '/system/giftOut',
		method: 'put',
		data: data
	});
}

// 删除礼品出库信息
export function delGiftOut(id) {
	return request({
		url: '/system/giftOut/' + id,
		method: 'delete'
	});
}
