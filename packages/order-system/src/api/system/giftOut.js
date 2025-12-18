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

// 退回礼品出库信息
export function returnGiftOut(data) {
	const { id, quantity, localDate } = data;
	return request({
		url: '/system/giftOut/reGiftStockOut',
		method: 'put',
		params: {
			id: id,
			quantity: quantity,
			localDate: localDate
		}
	});
}

// 查看再入库详情（退回记录会显示在这里）
export function getGiftOutReInDetail(id) {
	return request({
		url: '/system/giftOut/reGiftStockIn/',
		method: 'get',
		params: { id: id }
	});
}

// 根据出库id查看来自的入库信息
export function getGiftOutInDetail(id) {
	return request({
		url: '/system/giftOut/reGiftStockIn',
		method: 'get',
		params: { id: id }
	});
}

// 查看出库详情
export function getGiftOutOutDetail(id) {
	return request({
		url: '/system/giftOut/selectGiftStockOut',
		method: 'get',
		params: { id: id }
	});
}
