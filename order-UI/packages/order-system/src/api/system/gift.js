// ==================== 基础CRUD操作 ====================
/**
 * 查询礼品库存列表
 * @param {Object} query - 查询参数
 * @returns {Promise} 返回礼品库存列表数据
 */
export function listGift(query) {
	return request({
		url: '/system/gift/list',
		method: 'get',
		params: query
	});
}

/**
 * 获取礼品详情
 * @param {number|string} giftId - 礼品ID
 * @returns {Promise} 返回礼品详情数据
 */
export function getGift(giftId) {
	return request({
		url: `/system/gift/${giftId}`,
		method: 'get'
	});
}

/**
 * 新增礼品
 * @param {Object} data - 礼品数据
 * @returns {Promise} 返回操作结果
 */
export function addGift(data) {
	return request({
		url: '/system/gift',
		method: 'post',
		data: data
	});
}

/**
 * 修改礼品
 * @param {Object} data - 礼品数据
 * @returns {Promise} 返回操作结果
 */
export function updateGift(data) {
	return request({
		url: '/system/gift',
		method: 'put',
		data: data
	});
}

/**
 * 删除礼品
 * @param {number|string} giftId - 礼品ID
 * @returns {Promise} 返回操作结果
 */
export function delGift(giftId) {
	return request({
		url: `/system/gift/${giftId}`,
		method: 'delete'
	});
}

// ==================== 库存管理 ====================
/**
 * 更新礼品库存
 * @param {number|string} giftId - 礼品ID
 * @param {number} stockChange - 库存变化量
 * @returns {Promise} 返回操作结果
 */
export function updateGiftStock(giftId, stockChange) {
	return request({
		url: `/system/gift/${giftId}/stock`,
		method: 'put',
		data: { stockChange }
	});
}

/**
 * 调整礼品库存
 * @param {Object} data - 库存调整数据
 * @returns {Promise} 返回操作结果
 */
export function adjustGiftStock(data) {
	return request({
		url: '/system/gift/adjust-stock',
		method: 'post',
		data: data
	});
}

/**
 * 库存预警
 * @param {Object} query - 查询参数
 * @returns {Promise} 返回预警列表数据
 */
export function giftStockWarning(query) {
	return request({
		url: '/system/gift/stock-warning',
		method: 'get',
		params: query
	});
}

/**
 * 清除库存预警
 * @returns {Promise} 返回操作结果
 */
export function clearGiftStockWarning() {
	return request({
		url: '/system/gift/clear-stock-warning',
		method: 'post'
	});
}

/**
 * 获取库存日志
 * @param {Object} query - 查询参数
 * @returns {Promise} 返回库存日志数据
 */
export function getGiftStockLogs(query) {
	return request({
		url: '/system/gift/stock-logs',
		method: 'get',
		params: query
	});
}

// ==================== 导入导出 ====================
/**
 * 导出礼品
 * @param {Object} query - 导出查询参数
 * @returns {Promise} 返回导出文件流
 */
export function exportGift(query) {
	return request({
		url: '/system/gift/export',
		method: 'get',
		params: query,
		responseType: 'blob'
	});
}

/**
 * 导入礼品
 * @param {Object} data - 导入数据
 * @returns {Promise} 返回导入结果
 */
export function importGift(data) {
	return request({
		url: '/system/gift/import',
		method: 'post',
		data: data
	});
}

/**
 * 下载导入模板
 * @returns {Promise} 返回模板文件
 */
export function downloadGiftTemplate() {
	return request({
		url: '/system/gift/import/template',
		method: 'get'
	});
}

/**
 * 导出库存日志
 * @param {Object} query - 导出查询参数
 * @returns {Promise} 返回导出文件流
 */
export function exportGiftStockLogs(query) {
	return request({
		url: '/system/gift/stock-logs/export',
		method: 'get',
		params: query,
		responseType: 'blob'
	});
}

// ==================== 批量操作 ====================
/**
 * 批量删除礼品
 * @param {Array} giftIds - 礼品ID数组
 * @returns {Promise} 返回操作结果
 */
export function batchDeleteGifts(giftIds) {
	return request({
		url: '/system/gift/batch',
		method: 'delete',
		data: giftIds
	});
}

/**
 * 批量更新礼品状态
 * @param {Object} data - 批量更新数据
 * @returns {Promise} 返回操作结果
 */
export function batchUpdateGiftStatus(data) {
	return request({
		url: '/system/gift/batch/status',
		method: 'put',
		data: data
	});
}

// ==================== 库存操作 ====================
/**
 * 礼品入库
 * @param {Object} data - 入库数据
 * @returns {Promise} 返回操作结果
 */
export function giftStockIn(data) {
	return request({
		url: '/system/gift/stock-in',
		method: 'post',
		data: data
	});
}

/**
 * 礼品出库
 * @param {Object} data - 出库数据
 * @returns {Promise} 返回操作结果
 */
export function giftStockOut(data) {
	return request({
		url: '/system/gift/stock-out',
		method: 'post',
		data: data
	});
}

// ==================== 其他功能 ====================
/**
 * 获取礼品选项
 * @returns {Promise} 返回礼品选项数据
 */
export function getGiftOptions() {
	return request({
		url: '/system/gift/options',
		method: 'get'
	});
}

/**
 * 获取礼品统计信息
 * @returns {Promise} 返回统计信息数据
 */
export function getGiftStatistics() {
	return request({
		url: '/system/gift/statistics',
		method: 'get'
	});
}

/**
 * 获取礼品分类
 * @returns {Promise} 返回分类数据
 */
export function getGiftCategories() {
	return request({
		url: '/system/gift/categories',
		method: 'get'
	});
}

/**
 * 获取礼品库存统计
 * @returns {Promise} 返回库存统计信息
 */
export function getGiftStockStatistics() {
	return request({
		url: '/system/gift/stock-statistics',
		method: 'get'
	});
}
