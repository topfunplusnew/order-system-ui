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
// 在 api/system/giftIn.js 中添加
export function delGiftOut(giftOutId) {
	return request({
		url: `/system/gift/${giftOutId}`,
		method: 'delete'
	});
}

// 删除购入礼品信息
export function delGiftIn(id) {
	return request({
		url: '/system/giftIn/' + id,
		method: 'delete'
	});
}

// 退回购入礼品信息
export function returnGiftIn(data) {
	const { id, quantity, outLocation, remark, handler, localDate } = data;
	return request({
		url: '/system/giftIn/sendBack',
		method: 'put',
		params: {
			id: id,
			quantity: quantity,
			outLocation: outLocation,
			remark: remark,
			handler: handler,
			localDate: localDate
		}
	});
}

// 查看再入库详情（退回记录会显示在这里）
export function getGiftInReInDetail(id) {
	return request({
		url: '/system/giftIn/reGiftStockIn/',
		method: 'get',
		params: { id: id }
	});
}

// 查看出库详情
export function getGiftInOutDetail(id) {
	return request({
		url: '/system/giftIn/selectGiftStockOut',
		method: 'get',
		params: { id: id }
	});
}
