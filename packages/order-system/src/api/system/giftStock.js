import request from '@/utils/request';

// 查询礼品列表（用于选择物品）
export function listGift(query) {
	return request({
		url: '/system/gift/list',
		method: 'get',
		params: query
	});
}
// 删除礼品库存
// 在 @/api/system/giftStock.js 中确认 delGift 方法定义正确
export function delGift(ids) {
	return request({
		url: `/system/gift/${ids}`,
		method: 'delete'
	});
}

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

// 导出礼品库存列表
export function exportGiftStock(query) {
	return request({
		url: '/system/giftStock/export',
		method: 'post',
		params: query,
		responseType: 'blob'
	});
}

// 导出礼品库存列表（兼容旧接口）
export function exportGift(query) {
	return request({
		url: '/system/gift/export',
		method: 'post',
		params: query,
		responseType: 'blob'
	});
}
