// ==================== 基础CRUD操作 ====================
// 查询礼品库存列表
export function listGift(query) {
	return request({
		url: '/system/gift/list',
		method: 'get',
		params: query
	});
}

// 获取礼品详情
export function getGift(giftId) {
	return request({
		url: `/system/gift/${giftId}`,
		method: 'get'
	});
}

// 新增礼品
export function addGift(data) {
	return request({
		url: '/system/gift',
		method: 'post',
		data: data
	});
}

// 修改礼品
export function updateGift(data) {
	return request({
		url: '/system/gift',
		method: 'put',
		data: data
	});
}

// 删除礼品
export function delGift(giftId) {
	return request({
		url: `/system/gift/${giftId}`,
		method: 'delete'
	});
}

// ==================== 库存管理 ====================
// 更新礼品库存
export function updateGiftStock(giftId, stockChange) {
	return request({
		url: `/system/gift/${giftId}/stock`,
		method: 'put',
		data: { stockChange }
	});
}

// 调整礼品库存
export function adjustGiftStock(data) {
	return request({
		url: '/system/gift/adjust-stock',
		method: 'post',
		data: data
	});
}

// 库存预警
export function giftStockWarning(query) {
	return request({
		url: '/system/gift/stock-warning',
		method: 'get',
		params: query
	});
}

// 清除库存预警
export function clearGiftStockWarning() {
	return request({
		url: '/system/gift/clear-stock-warning',
		method: 'post'
	});
}

// 获取库存日志
export function getGiftStockLogs(query) {
	return request({
		url: '/system/gift/stock-logs',
		method: 'get',
		params: query
	});
}

// ==================== 导入导出 ====================
// 导出礼品
export function exportGift(query) {
	return request({
		url: '/system/gift/export',
		method: 'get',
		params: query
	});
}

// 导入礼品
export function importGift(data) {
	return request({
		url: '/system/gift/import',
		method: 'post',
		data: data
	});
}

// 下载导入模板
export function downloadGiftTemplate() {
	return request({
		url: '/system/gift/import/template',
		method: 'get'
	});
}

// 导出库存日志
export function exportGiftStockLogs(query) {
	return request({
		url: '/system/gift/stock-logs/export',
		method: 'get',
		params: query
	});
}

// ==================== 其他功能 ====================
// 获取礼品选项
export function getGiftOptions() {
	return request({
		url: '/system/gift/options',
		method: 'get'
	});
}

// 获取礼品统计信息
export function getGiftStatistics() {
	return request({
		url: '/system/gift/statistics',
		method: 'get'
	});
}

// 获取礼品分类
export function getGiftCategories() {
	return request({
		url: '/system/gift/categories',
		method: 'get'
	});
}
