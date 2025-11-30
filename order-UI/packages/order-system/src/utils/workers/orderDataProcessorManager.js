/**
 * Web Worker 管理器
 * 负责创建、管理和销毁 Web Worker 实例
 */

class OrderDataProcessorManager {
	constructor() {
		this.worker = null;
		this.isReady = false;
		this.pendingTasks = [];
		this.taskIdCounter = 0;
		this.callbacks = new Map();
	}

	/**
	 * 初始化 Worker
	 */
	init() {
		if (this.worker) {
			return Promise.resolve();
		}

		return new Promise(resolve => {
			try {
				// 在 Vue CLI 中，使用相对路径创建 Worker
				// 使用内联 Blob URL 方式创建 Worker，避免路径问题
				const workerCode = `
					${this.getWorkerCode()}
				`;
				const blob = new Blob([workerCode], { type: 'application/javascript' });
				this.workerUrl = URL.createObjectURL(blob);
				this.worker = new Worker(this.workerUrl);

				// 监听 Worker 消息
				this.worker.addEventListener('message', this.handleMessage.bind(this));
				this.worker.addEventListener('error', this.handleError.bind(this));

				// 等待 Worker 准备就绪
				const readyHandler = e => {
					if (e.data.type === 'WORKER_READY') {
						this.isReady = true;
						this.worker.removeEventListener('message', readyHandler);
						resolve();
					}
				};
				this.worker.addEventListener('message', readyHandler);

				// 设置超时，如果 Worker 在 5 秒内没有响应，使用降级方案
				setTimeout(() => {
					if (!this.isReady) {
						console.warn('Worker initialization timeout, using fallback');
						if (this.worker) {
							this.worker.terminate();
							URL.revokeObjectURL(this.workerUrl);
							this.workerUrl = null;
						}
						this.worker = null;
						resolve(); // 仍然 resolve，使用降级方案
					}
				}, 5000);
			} catch (error) {
				console.warn('Failed to create Worker, using fallback:', error);
				// 如果 Worker 创建失败，使用降级方案（在主线程处理）
				this.worker = null;
				resolve(); // 仍然 resolve，使用降级方案
			}
		});
	}

	/**
	 * 获取 Worker 代码字符串
	 */
	getWorkerCode() {
		return `
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

			function preprocessBatch(orderList, startIndex, batchSize) {
				const endIndex = Math.min(startIndex + batchSize, orderList.length);
				const batch = orderList.slice(startIndex, endIndex);
				return batch.map(order => preprocessOrder(order));
			}

			self.addEventListener('message', function(e) {
				const { type, payload } = e.data;
				try {
					switch (type) {
						case 'PREPROCESS_BATCH':
							const { orderList, startIndex, batchSize } = payload;
							const processedBatch = preprocessBatch(orderList, startIndex, batchSize);
							self.postMessage({
								type: 'PREPROCESS_BATCH_SUCCESS',
								payload: {
									data: processedBatch,
									startIndex,
									endIndex: startIndex + processedBatch.length,
									taskId: payload.taskId
								}
							});
							break;
						case 'PREPROCESS_ALL':
							const { orderList: allOrderList } = payload;
							const processedAll = allOrderList.map(order => preprocessOrder(order));
							self.postMessage({
								type: 'PREPROCESS_ALL_SUCCESS',
								payload: {
									data: processedAll,
									taskId: payload.taskId
								}
							});
							break;
						default:
							self.postMessage({
								type: 'ERROR',
								payload: {
									error: 'Unknown message type: ' + type,
									taskId: payload?.taskId
								}
							});
					}
				} catch (error) {
					self.postMessage({
						type: 'ERROR',
						payload: {
							error: error.message,
							stack: error.stack,
							taskId: payload?.taskId
						}
					});
				}
			});

			self.postMessage({ type: 'WORKER_READY', payload: {} });
		`;
	}

	/**
	 * 处理 Worker 消息
	 */
	handleMessage(e) {
		const { type, payload } = e.data;

		if (type === 'WORKER_READY') {
			this.isReady = true;
			// 处理待处理的任务
			this.processPendingTasks();
			return;
		}

		// 查找对应的回调
		const taskId = payload?.taskId;
		if (taskId && this.callbacks.has(taskId)) {
			const { resolve, reject } = this.callbacks.get(taskId);
			this.callbacks.delete(taskId);

			if (type.includes('SUCCESS')) {
				resolve(payload);
			} else if (type === 'ERROR') {
				reject(new Error(payload.error || 'Worker processing error'));
			}
		}
	}

	/**
	 * 处理 Worker 错误
	 */
	handleError(error) {
		console.error('Worker error:', error);
		// 清理所有待处理的任务
		this.callbacks.forEach(({ reject }) => {
			reject(new Error('Worker error occurred'));
		});
		this.callbacks.clear();
	}

	/**
	 * 处理待处理的任务
	 */
	processPendingTasks() {
		while (this.pendingTasks.length > 0) {
			const task = this.pendingTasks.shift();
			this.sendTask(task);
		}
	}

	/**
	 * 发送任务到 Worker
	 */
	sendTask({ type, payload, taskId, resolve, reject }) {
		if (!this.worker || !this.isReady) {
			this.pendingTasks.push({ type, payload, taskId, resolve, reject });
			return;
		}

		this.callbacks.set(taskId, { resolve, reject });
		this.worker.postMessage({
			type,
			payload: {
				...payload,
				taskId
			}
		});
	}

	/**
	 * 预处理一批数据
	 * @param {Array} orderList - 订单列表
	 * @param {number} startIndex - 起始索引
	 * @param {number} batchSize - 批次大小
	 * @returns {Promise<Array>} 处理后的数据
	 */
	preprocessBatch(orderList, startIndex, batchSize) {
		const taskId = ++this.taskIdCounter;

		return new Promise((resolve, reject) => {
			// 如果 Worker 不可用，使用降级方案
			if (!this.worker) {
				// 降级到主线程处理
				try {
					const result = this.fallbackPreprocessBatch(orderList, startIndex, batchSize);
					resolve({ data: result, startIndex, endIndex: startIndex + result.length });
				} catch (error) {
					reject(error);
				}
				return;
			}

			this.sendTask({
				type: 'PREPROCESS_BATCH',
				payload: {
					orderList,
					startIndex,
					batchSize
				},
				taskId,
				resolve,
				reject
			});
		});
	}

	/**
	 * 预处理所有数据
	 * @param {Array} orderList - 订单列表
	 * @returns {Promise<Array>} 处理后的数据
	 */
	preprocessAll(orderList) {
		const taskId = ++this.taskIdCounter;

		return new Promise((resolve, reject) => {
			// 如果 Worker 不可用，使用降级方案
			if (!this.worker) {
				try {
					const result = this.fallbackPreprocessAll(orderList);
					resolve({ data: result });
				} catch (error) {
					reject(error);
				}
				return;
			}

			this.sendTask({
				type: 'PREPROCESS_ALL',
				payload: {
					orderList
				},
				taskId,
				resolve,
				reject
			});
		});
	}

	/**
	 * 降级方案：在主线程预处理一批数据
	 */
	fallbackPreprocessBatch(orderList, startIndex, batchSize) {
		const endIndex = Math.min(startIndex + batchSize, orderList.length);
		const batch = orderList.slice(startIndex, endIndex);

		return batch.map(order => this.fallbackPreprocessOrder(order));
	}

	/**
	 * 降级方案：在主线程预处理所有数据
	 */
	fallbackPreprocessAll(orderList) {
		return orderList.map(order => this.fallbackPreprocessOrder(order));
	}

	/**
	 * 降级方案：预处理单个订单
	 */
	fallbackPreprocessOrder(order) {
		const processedOrder = { ...order };

		if (order.smailOrderDetails && Array.isArray(order.smailOrderDetails)) {
			processedOrder._uniqueSuppliers = this.getUniqueSuppliers(order.smailOrderDetails);
			processedOrder._uniqueWarehouses = this.getUniqueWarehouses(order.smailOrderDetails);
		} else {
			processedOrder._uniqueSuppliers = [];
			processedOrder._uniqueWarehouses = [];
		}

		return processedOrder;
	}

	/**
	 * 获取去重的供应商列表
	 */
	getUniqueSuppliers(smailOrderDetails) {
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
	 */
	getUniqueWarehouses(smailOrderDetails) {
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
	 * 销毁 Worker
	 */
	destroy() {
		if (this.worker) {
			this.worker.terminate();
			// 清理 Blob URL（如果有）
			if (this.workerUrl) {
				URL.revokeObjectURL(this.workerUrl);
				this.workerUrl = null;
			}
			this.worker = null;
			this.isReady = false;
			this.callbacks.clear();
			this.pendingTasks = [];
		}
	}
}

// 创建单例实例
const orderDataProcessorManager = new OrderDataProcessorManager();

export default orderDataProcessorManager;
