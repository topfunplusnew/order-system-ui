import { listGoodsOrder } from '../../../../api/system/goodsOrder';

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
			}
		};
	},
	methods: {
		// 查询订单的列表
		getList() {
			if (!this.queryParams.isAdjust) {
				const isAdjust = this.isAdjustOrder ? -1 : 0;
				listGoodsOrder({
					...this.queryParams,
					isAdjust: isAdjust
				}).then(response => {
					// 预处理订单数据，添加供应商和仓库的预处理信息
					this.goodsOrderList = this.preprocessOrderData(response.rows);
					this.total = response.total;
					this.loading = false;
				});
			} else {
				listGoodsOrder(this.queryParams).then(response => {
					// 预处理订单数据，添加供应商和仓库的预处理信息
					this.goodsOrderList = this.preprocessOrderData(response.rows);
					this.total = response.total;
					this.loading = false;
				});
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
