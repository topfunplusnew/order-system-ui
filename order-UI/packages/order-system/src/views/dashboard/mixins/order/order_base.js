import { listGoodsOrder } from '../../../../api/system/goodsOrder';
import orderDataProcessorManager from '../../../../utils/workers/orderDataProcessorManager';

/**
 * 订单基类
 */
export var mixin_order_base = {
	data: function () {
		return {
			queryOrderInfo: {},
			mapper: {
				orderDate: '订单日期',
				supplier: '供应商名称',
				customer: '客户名称',
				levelName: '级别名称',
				countingUnit: '计数单位',
				height: '厚度',
				length: '长度',
				width: '宽度',
				pieces: '数量',
				piecesPerPack: '每包数量',
				packs: '包数',
				price: '单价',
				isIncludeTaxFactory: '是否含税（工厂）',
				sundryCost: '杂费',
				paymentFactory: '出厂货款',
				paymentUnload: '卸货费用',
				isIncludeTaxSale: '是否含税（销售）',
				payments: '销售付款',
				erro: '误差',
				tonnage: '吨位',
				landFreightPrice: '陆运价格',
				landFreight: '陆运费',
				seaFreight: '海运费',
				freight: '运费',
				otherCost: '其他费用',
				profit: '利润',
				profitNoTax: '无税利润',
				actualPieces: '实际数量',
				paymentsWithSundry: '含杂费付款',
				additionalFees: '额外费用',
				storeHouseName: '仓库名称',
				logisticsProfit: '物流利润',
				customerCommission: '客户佣金',
				comments: '备注',
				updateTime: '订单修改时间',
				remark: '修改记录',
				landCarNo: '陆运车牌号',
				landDriverName: '陆运司机姓名',
				landBankNo: '陆运司机银行卡号',
				landDriverTel: '陆运司机电话',
				fleet: '车队',
				seaCarNo: '柜号',
				seaDriverName: '海运公司',
				seaDriverTel: '海运司机电话',
				seaBankNo: '海运司机银行卡号',
				seaBankName: '海运司机开户名',
				landBankName: '陆运司机开户名',
				companyName: '公司名称',
				saleManager: '销售经理',
				userName: '修改人',
				supplierNames: '供应商',
				allPayments: '总货款'
			},
			// 订单表格中的数据
			goodsOrderList: [],
			renderedList: [], // 用于在表格中显示的数据，实现分时渲染
			renderedDataMap: new Map(), // 已渲染数据的缓存 Map，key 为 id，value 为数据对象
			batchSize: 60, // 每次渲染的行数，根据性能调整
			currentIndex: 0, // 当前渲染的起始索引
			isLoadingBatch: false, // 是否正在加载批次，防止重复加载
			preloadNextBatch: true, // 是否预加载下一批数据
			preloadedBatch: null, // 预加载的批次数据
			rafId: null // requestAnimationFrame ID，用于取消
		};
	},
	created() {
		// 初始化 Worker
		orderDataProcessorManager.init().catch(err => {
			console.warn('Worker initialization failed, using fallback:', err);
		});
	},
	methods: {
		// 查询订单的列表 分批渲染 因为dom太多
		getList() {
			// 取消之前的预加载任务
			if (this.rafId) {
				cancelAnimationFrame(this.rafId);
				this.rafId = null;
			}
			this.preloadedBatch = null;

			if (!this.queryParams.isAdjust) {
				const isAdjust = this.isAdjustOrder ? -1 : 0;
				const query = {
					...this.queryParams,
					isAdjust: isAdjust
				};
				listGoodsOrder(query).then(response => {
					// 使用 Worker 预处理订单数据
					this.preprocessOrderDataWithWorker(response.rows)
						.then(processedData => {
							this.updateOrderListWithCache(processedData);
							this.total = response.total;
							this.loading = false;
						})
						.catch(err => {
							console.error('Data preprocessing failed:', err);
							// 降级到主线程处理
							const processedData = this.preprocessOrderData(response.rows);
							this.updateOrderListWithCache(processedData);
							this.total = response.total;
							this.loading = false;
						});
				});
			} else {
				listGoodsOrder(this.queryParams).then(response => {
					// 使用 Worker 预处理订单数据
					this.preprocessOrderDataWithWorker(response.rows)
						.then(processedData => {
							this.updateOrderListWithCache(processedData);
							this.total = response.total;
							this.loading = false;
						})
						.catch(err => {
							console.error('Data preprocessing failed:', err);
							// 降级到主线程处理
							const processedData = this.preprocessOrderData(response.rows);
							this.updateOrderListWithCache(processedData);
							this.total = response.total;
							this.loading = false;
						});
				});
			}
		},
		/**
		 * 使用缓存机制更新订单列表，只更新变化的数据
		 * @param {Array} newProcessedData - 新处理后的订单数据
		 */
		updateOrderListWithCache(newProcessedData) {
			// 更新 goodsOrderList，保持顺序
			const updatedGoodsOrderList = [];
			const updatedRenderedDataMap = new Map();

			// 遍历新数据，更新或添加
			newProcessedData.forEach(newItem => {
				const itemId = newItem.id;
				const cachedItem = this.renderedDataMap.get(itemId);

				if (cachedItem && this.isDataUnchanged(cachedItem, newItem)) {
					// 数据未变化，保留原有对象引用（保持响应式）
					updatedGoodsOrderList.push(cachedItem);
					updatedRenderedDataMap.set(itemId, cachedItem);
				} else {
					// 数据变化或新数据，使用新对象
					updatedGoodsOrderList.push(newItem);
					updatedRenderedDataMap.set(itemId, newItem);
				}
			});

			// 更新 goodsOrderList（保持响应式）
			this.goodsOrderList = updatedGoodsOrderList;
			this.renderedDataMap = updatedRenderedDataMap;

			// 更新 renderedList，只保留仍然存在的数据，并保持顺序
			// 创建已渲染数据的 id 集合，用于快速查找
			const renderedIdSet = new Set(this.renderedList.map(item => item.id));
			const newRenderedList = [];

			// 按照 goodsOrderList 的顺序，只保留已渲染的数据
			updatedGoodsOrderList.forEach(item => {
				// 检查该数据是否已经在 renderedList 中（使用 Set 快速查找）
				if (renderedIdSet.has(item.id)) {
					// 使用更新后的数据（可能是缓存的或新的）
					newRenderedList.push(item);
				}
			});

			// 更新 renderedList（保持响应式）
			this.renderedList = newRenderedList;

			// 更新 currentIndex，确保分片加载逻辑正确
			this.currentIndex = this.renderedList.length;
			this.isLoadingBatch = false;

			// 如果还有未渲染的数据，继续渲染
			if (this.currentIndex < this.goodsOrderList.length) {
				this.renderBatch();
				// 预加载下一批数据
				if (this.preloadNextBatch) {
					this.preloadNextBatchData();
				}
			}
		},
		/**
		 * 判断数据是否未变化（用于缓存判断）
		 * 通过比较关键字段来判断数据是否变化
		 * @param {Object} oldData - 旧数据
		 * @param {Object} newData - 新数据
		 * @returns {boolean} 如果数据未变化返回 true
		 */
		isDataUnchanged(oldData, newData) {
			if (!oldData || !newData || oldData.id !== newData.id) {
				return false;
			}

			// 比较关键字段，这些字段变化时需要重新渲染
			const keyFields = [
				'orderDate',
				'customer',
				'checkState',
				'fleet',
				'landCarNo',
				'landDriverTel',
				'landDriverName',
				'seaCarNo',
				'seaDriverTel',
				'seaDriverName',
				'allPayments',
				'allTonnage',
				'landFreight',
				'seaFreight',
				'allProfit',
				'allProfitNoTax',
				'saleManager',
				'userName',
				'comments',
				'isedit',
				'isAdjust',
				'addtime',
				'updateTime',
				'attachmentList',
				'historyCount',
				'isAdjusted',
				'adjustOrderid',
				'smailOrderDetails'
			];

			// 比较关键字段
			for (const field of keyFields) {
				if (JSON.stringify(oldData[field]) !== JSON.stringify(newData[field])) {
					return false;
				}
			}

			// 比较预处理后的供应商和仓库信息
			if (JSON.stringify(oldData._uniqueSuppliers) !== JSON.stringify(newData._uniqueSuppliers)) {
				return false;
			}
			if (JSON.stringify(oldData._uniqueWarehouses) !== JSON.stringify(newData._uniqueWarehouses)) {
				return false;
			}

			return true;
		},
		/**
		 * 渲染一批数据（使用 requestAnimationFrame 优化渲染性能）
		 */
		renderBatch() {
			// 如果已经全部渲染完成，直接返回
			if (this.currentIndex >= this.goodsOrderList.length) {
				this.isLoadingBatch = false;
				return;
			}
			// 如果正在加载，防止重复加载
			if (this.isLoadingBatch) {
				return;
			}
			// 标记为正在加载
			this.isLoadingBatch = true;

			// 使用 requestAnimationFrame 来平滑渲染，不阻塞主线程
			this.rafId = requestAnimationFrame(() => {
				let nextBatch = [];

				// 如果有预加载的数据，直接使用
				if (this.preloadedBatch && this.preloadedBatch.startIndex === this.currentIndex) {
					nextBatch = this.preloadedBatch.data;
					this.currentIndex = this.preloadedBatch.endIndex;
					this.preloadedBatch = null;
				} else {
					// 否则从原始数据中获取
					nextBatch = this.goodsOrderList.slice(this.currentIndex, this.currentIndex + this.batchSize);
					this.currentIndex += this.batchSize;
				}

				// 将新批次数据添加到 renderedList（保持响应式）
				// 使用 push 来确保响应式，Vue 会自动检测数组变化
				nextBatch.forEach(item => {
					// 确保数据已缓存到 renderedDataMap（应该已经存在，但为了安全起见还是检查）
					const cachedItem = this.renderedDataMap.get(item.id);
					if (cachedItem) {
						// 使用缓存的数据（保持响应式）
						this.renderedList.push(cachedItem);
					} else {
						// 如果缓存中没有，添加到缓存并添加到渲染列表
						this.renderedDataMap.set(item.id, item);
						this.renderedList.push(item);
					}
				});

				// 使用 $nextTick 确保 DOM 更新完成后再隐藏加载状态
				this.$nextTick(() => {
					// 标记加载完成
					this.isLoadingBatch = false;
					// 预加载下一批数据
					if (this.preloadNextBatch && this.currentIndex < this.goodsOrderList.length) {
						this.preloadNextBatchData();
					}
				});
				this.rafId = null;
			});
		},
		/**
		 * 预加载下一批数据（在 Worker 中处理）
		 */
		preloadNextBatchData() {
			// 如果已经有预加载的数据或正在加载，不重复预加载
			if (this.preloadedBatch || this.isLoadingBatch) {
				return;
			}

			// 如果已经全部加载完成，不需要预加载
			if (this.currentIndex >= this.goodsOrderList.length) {
				return;
			}

			const nextStartIndex = this.currentIndex;
			const nextBatchSize = this.batchSize;

			// 使用 Worker 预加载下一批数据
			orderDataProcessorManager
				.preprocessBatch(this.goodsOrderList, nextStartIndex, nextBatchSize)
				.then(result => {
					// 只有当预加载的数据仍然有效时才保存（防止用户快速滚动导致数据过期）
					if (nextStartIndex === this.currentIndex && !this.preloadedBatch) {
						this.preloadedBatch = {
							data: result.data,
							startIndex: result.startIndex,
							endIndex: result.endIndex
						};
					}
				})
				.catch(err => {
					// 预加载失败不影响主流程，静默处理
					console.warn('Preload batch failed:', err);
				});
		},
		/**
		 * 使用 Worker 预处理订单数据
		 */
		preprocessOrderDataWithWorker(orderList) {
			if (!Array.isArray(orderList) || orderList.length === 0) {
				return Promise.resolve([]);
			}

			// 如果数据量较小，直接在主线程处理
			if (orderList.length <= 50) {
				return Promise.resolve(this.preprocessOrderData(orderList));
			}

			// 使用 Worker 处理大数据量
			return orderDataProcessorManager
				.preprocessAll(orderList)
				.then(result => {
					return result.data;
				})
				.catch(err => {
					console.warn('Worker preprocessing failed, using fallback:', err);
					// 降级到主线程处理
					return this.preprocessOrderData(orderList);
				});
		},
		/**
		 * 处理表格滚动事件，当滚动到底部时加载下一批数据
		 * 使用节流优化性能，并使用 requestAnimationFrame 平滑渲染
		 * @param {Event} event - 滚动事件对象
		 */
		handleTableScroll(event) {
			const target = event.target;
			// 如果正在加载或已经全部渲染完成，直接返回
			if (this.isLoadingBatch || this.currentIndex >= this.goodsOrderList.length) {
				return;
			}
			// 计算滚动位置
			const scrollTop = target.scrollTop;
			const scrollHeight = target.scrollHeight;
			const clientHeight = target.clientHeight;
			// 当滚动到距离底部100px以内时，开始加载下一批数据（提前加载，更流畅）
			const threshold = 100;
			if (scrollHeight - scrollTop - clientHeight <= threshold) {
				// 使用 requestAnimationFrame 来平滑触发加载，避免阻塞滚动
				if (!this._scrollRafId) {
					this._scrollRafId = requestAnimationFrame(() => {
						this.renderBatch();
						this._scrollRafId = null;
					});
				}
			}
		},
		/**
		 * 重置分片加载状态，清空已渲染的数据，重新开始分片加载
		 */
		resetBatchLoading() {
			// 如果数据列表为空，不需要重置
			if (!this.goodsOrderList || this.goodsOrderList.length === 0) {
				return;
			}
			// 取消之前的动画帧
			if (this.rafId) {
				cancelAnimationFrame(this.rafId);
				this.rafId = null;
			}
			if (this._scrollRafId) {
				cancelAnimationFrame(this._scrollRafId);
				this._scrollRafId = null;
			}
			// 重置分片加载相关状态
			// 注意：不清空 renderedDataMap，保留缓存
			this.renderedList = [];
			this.currentIndex = 0;
			this.isLoadingBatch = false;
			this.preloadedBatch = null;
			// 重新开始分片加载
			this.renderBatch();
			// 预加载下一批数据
			if (this.preloadNextBatch) {
				this.preloadNextBatchData();
			}
		},
		// 获取供应商的名称列表 主要用于表格的供应商列表的展示
		getSupplierNames(list) {
			if (list.length === 0) {
				return;
			}
			// 使用 Map 根据 supplierID 去重
			const supplierMap = new Map();
			list.forEach(item => {
				if (item.supplierID && !supplierMap.has(item.supplierID)) {
					supplierMap.set(item.supplierID, {
						supplier: item.supplier,
						supplierID: item.supplierID
					});
				}
			});
			// 返回去重后的数组
			return Array.from(supplierMap.values());
		},
		/**
		 * 预处理订单数据，为每个订单添加预处理的供应商和仓库信息
		 * 优化渲染性能，避免在模板中重复计算
		 * @param {Array} orderList - 原始订单列表
		 * @returns {Array} 处理后的订单列表
		 * 时间复杂度: O(n×m), 空间复杂度: O(n×m)
		 */
		preprocessOrderData(orderList) {
			if (!Array.isArray(orderList)) {
				return [];
			}

			return orderList.map(order => {
				// 深拷贝订单数据，避免修改原始数据
				const processedOrder = { ...order };

				// 预处理供应商和仓库信息
				if (order.smailOrderDetails && Array.isArray(order.smailOrderDetails)) {
					// 获取去重的供应商列表
					processedOrder._uniqueSuppliers = this.getUniqueSuppliers(order.smailOrderDetails);
					// 获取去重的仓库列表
					processedOrder._uniqueWarehouses = this.getUniqueWarehouses(order.smailOrderDetails);
				} else {
					processedOrder._uniqueSuppliers = [];
					processedOrder._uniqueWarehouses = [];
				}

				return processedOrder;
			});
		},
		/**
		 * 获取去重的供应商列表
		 * @param {Array} smailOrderDetails - 订单详情数组
		 * @returns {Array} 去重后的供应商列表
		 * 时间复杂度: O(n), 空间复杂度: O(n)
		 */
		getUniqueSuppliers(smailOrderDetails) {
			// 边界条件处理
			if (!Array.isArray(smailOrderDetails) || smailOrderDetails.length === 0) {
				return [];
			}

			// 使用 Map 进行去重，以 supplierID 为键
			const supplierMap = new Map();

			smailOrderDetails.forEach(item => {
				// 只处理有效的供应商数据：supplierID 不为 null 且 supplier 不为空
				if (item.supplierID && item.supplier && item.supplier.trim()) {
					if (!supplierMap.has(item.supplierID)) {
						// 创建不可变的供应商对象，包含原有的属性
						supplierMap.set(item.supplierID, {
							supplier: item.supplier.trim(),
							supplierID: item.supplierID,
							isIncludeTaxFactory: item.isIncludeTaxFactory
						});
					}
				}
			});

			// 返回去重后的数组
			return Array.from(supplierMap.values());
		},
		/**
		 * 获取去重的仓库列表
		 * @param {Array} smailOrderDetails - 订单详情数组
		 * @returns {Array} 去重后的仓库列表
		 * 时间复杂度: O(n), 空间复杂度: O(n)
		 */
		getUniqueWarehouses(smailOrderDetails) {
			// 边界条件处理
			if (!Array.isArray(smailOrderDetails) || smailOrderDetails.length === 0) {
				return [];
			}

			// 使用 Map 进行去重，以 storeHouseID 为键
			const warehouseMap = new Map();

			smailOrderDetails.forEach(item => {
				// 只处理有效的仓库数据：storeHouseID 不为 null 且 storeHouseName 不为空
				if (item.storeHouseID && item.storeHouseName && item.storeHouseName.trim()) {
					if (!warehouseMap.has(item.storeHouseID)) {
						// 创建不可变的仓库对象
						warehouseMap.set(item.storeHouseID, {
							storeHouseName: item.storeHouseName.trim(),
							storeHouseID: item.storeHouseID
						});
					}
				}
			});

			// 返回去重后的数组
			return Array.from(warehouseMap.values());
		},
		// 休眠函数
		sleep(ms) {
			return new Promise(resolve => setTimeout(resolve, ms));
		},
		// 格式化对象
		formatData(data) {
			let formattedString = '';
			for (const key in data) {
				if (Reflect.has(data, key)) {
					const value = data[key];
					const mappedKey = this.mapper[key] || key;
					formattedString += `${mappedKey}: ${value}\n`;
				}
			}
			return formattedString.trim(); // 去掉最后一个换行符
		}
	}
};
