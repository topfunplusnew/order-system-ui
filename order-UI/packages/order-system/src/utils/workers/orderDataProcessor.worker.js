/**
 * Web Worker 用于处理订单数据预处理
 * 将耗时的数据预处理操作移到 Worker 线程，避免阻塞主线程
 */

/**
 * 获取去重的供应商列表
 * @param {Array} smailOrderDetails - 订单详情数组
 * @returns {Array} 去重后的供应商列表
 */
function getUniqueSuppliers(smailOrderDetails) {
	if (!Array.isArray(smailOrderDetails) || smailOrderDetails.length === 0) {
		return [];
	}

	const supplierMap = new Map();

	smailOrderDetails.forEach(item => {
		if (item.supplierID && item.supplier && item.supplier.trim()) {
			if (!supplierMap.has(item.supplierID)) {
				supplierMap.set(item.supplierID, {
					supplier: item.supplier.trim(),
					supplierID: item.supplierID,
					isIncludeTaxFactory: item.isIncludeTaxFactory
				});
			}
		}
	});

	return Array.from(supplierMap.values());
}

/**
 * 获取去重的仓库列表
 * @param {Array} smailOrderDetails - 订单详情数组
 * @returns {Array} 去重后的仓库列表
 */
function getUniqueWarehouses(smailOrderDetails) {
	if (!Array.isArray(smailOrderDetails) || smailOrderDetails.length === 0) {
		return [];
	}

	const warehouseMap = new Map();

	smailOrderDetails.forEach(item => {
		if (item.storeHouseID && item.storeHouseName && item.storeHouseName.trim()) {
			if (!warehouseMap.has(item.storeHouseID)) {
				warehouseMap.set(item.storeHouseID, {
					storeHouseName: item.storeHouseName.trim(),
					storeHouseID: item.storeHouseID
				});
			}
		}
	});

	return Array.from(warehouseMap.values());
}

/**
 * 预处理单个订单数据
 * @param {Object} order - 订单对象
 * @returns {Object} 处理后的订单对象
 */
function preprocessOrder(order) {
	const processedOrder = { ...order };

	if (order.smailOrderDetails && Array.isArray(order.smailOrderDetails)) {
		processedOrder._uniqueSuppliers = getUniqueSuppliers(order.smailOrderDetails);
		processedOrder._uniqueWarehouses = getUniqueWarehouses(order.smailOrderDetails);
	} else {
		processedOrder._uniqueSuppliers = [];
		processedOrder._uniqueWarehouses = [];
	}

	return processedOrder;
}

/**
 * 批量预处理订单数据
 * @param {Array} orderList - 原始订单列表
 * @param {number} startIndex - 起始索引
 * @param {number} batchSize - 批次大小
 * @returns {Array} 处理后的订单列表
 */
function preprocessBatch(orderList, startIndex, batchSize) {
	const endIndex = Math.min(startIndex + batchSize, orderList.length);
	const batch = orderList.slice(startIndex, endIndex);
	
	return batch.map(order => preprocessOrder(order));
}

// 监听主线程消息
self.addEventListener('message', function(e) {
	const { type, payload } = e.data;

	try {
		switch (type) {
			case 'PREPROCESS_BATCH':
				// 预处理一批数据
				const { orderList, startIndex, batchSize } = payload;
				const processedBatch = preprocessBatch(orderList, startIndex, batchSize);
				
				// 使用 transferable objects 优化性能（如果可能）
				self.postMessage({
					type: 'PREPROCESS_BATCH_SUCCESS',
					payload: {
						data: processedBatch,
						startIndex,
						endIndex: startIndex + processedBatch.length
					}
				});
				break;

			case 'PREPROCESS_ALL':
				// 预处理所有数据（用于初始加载）
				const { orderList: allOrderList } = payload;
				const processedAll = allOrderList.map(order => preprocessOrder(order));
				
				self.postMessage({
					type: 'PREPROCESS_ALL_SUCCESS',
					payload: {
						data: processedAll
					}
				});
				break;

			default:
				self.postMessage({
					type: 'ERROR',
					payload: {
						error: `Unknown message type: ${type}`
					}
				});
		}
	} catch (error) {
		self.postMessage({
			type: 'ERROR',
			payload: {
				error: error.message,
				stack: error.stack
			}
		});
	}
});

// Worker 初始化完成
self.postMessage({
	type: 'WORKER_READY',
	payload: {}
});

