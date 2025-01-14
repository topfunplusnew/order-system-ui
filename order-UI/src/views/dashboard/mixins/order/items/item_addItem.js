/**
 * 添加订单个体的混入
 */
export var mixin_item_addItem = {
	data: function () {
		return {
			orderItemInfo: {}
		};
	},
	watch: {
		orderItemInfo: {
			handler() {
				// 运费自动填充
				this.orderItemInfo.freight =
					Number(this.orderItemInfo.landFreight) +
					(this.isSea ? Number(this.orderItemInfo.seaFreight) : 0);

				// 根据不同的符号来设置对应的值
				const taxMapping = {
					'00': {
						paymentFactory: this.paymentFactory00,
						payments: this.payments00,
						tonnage: this.tonnage00,
						landFreight: this.landFreight00,
						profit: this.profit00,
						profitNoTax: this.profitNoTax00
					},
					10: {
						paymentFactory: this.paymentFactory10,
						payments: this.payments10,
						tonnage: this.tonnage10,
						landFreight: this.landFreight10,
						profit: this.profit10,
						profitNoTax: this.profitNoTax10
					},
					'01': {
						paymentFactory: this.paymentFactory01,
						payments: this.payments01,
						tonnage: this.tonnage01,
						landFreight: this.landFreight01,
						profit: this.profit01,
						profitNoTax: this.profitNoTax01
					},
					11: {
						paymentFactory: this.paymentFactory11,
						payments: this.payments11,
						tonnage: this.tonnage11,
						landFreight: this.landFreight11,
						profit: this.profit11,
						profitNoTax: this.profitNoTax11
					}
				};
				// 根据 isIncludeTaxFactory 和 isIncludeTaxSale 确定映射键
				const key = `${this.orderItemInfo.isIncludeTaxFactory}${this.orderItemInfo.isIncludeTaxSale}`;
				// 获取对应的数据并解构赋值到 orderItemInfo 中
				Object.assign(this.orderItemInfo, taxMapping[key]);
			},
			deep: true,
			immediate: true
		}
	},
	methods: {
		// 添加订单到vuex进行管理 添加的是货物
		addOrderItem() {
			this.loading = true;
			this.$store.commit('order/changeOrderItemStatus', {
				...this.orderItemInfo,
				orderIndex: this.index
			});
			this.$message.success('添加货物成功');
			this.disabled = true;
			this.buttonText = '已添加该货物';
			this.loading = false;
		},
		// 供应商信息 从供应商发货
		handleCommitBackCompany(val) {
			// 重置
			this.resetOrderItemInfo();
			this.orderItemInfo.supplierID = val.id; // goodsOrderList->供应商ID
			this.orderItemInfo.supplier = val.companyName;
		},


		// 重置订单个体信息
		resetOrderItemInfo() {
			this.orderItemInfo = {
				orderDate: null,
				supplier: null,
				supplierID: null,
				customer: null,
				customerID: null,
				levelID: null,
				levelName: null,
				countingUnit: '片',
				height: null,
				length: null,
				width: null,
				pieces: null,
				piecesPerPack: null,
				packs: null,
				price: null,
				isIncludeTaxFactory: 0,
				sundryCost: null,
				paymentFactory: null,
				paymentUnload: null,
				isIncludeTaxSale: 0,
				payments: null,
				erro: null,
				tonnage: null,
				landFreightPrice: null,
				landFreight: null,
				seaFreight: null,
				freight: null,
				otherCost: null,
				profit: null,
				profitNoTax: null,
				actualPieces: null,
				paymentsWithSundry: null,
				additionalFees: null,
				storeHouseID: null,
				storeHouseName: null,
				storeID: null,
				logisticsProfit: null,
				customerCommission: null,
				isAdjusted: null,
				adjustDate: null,
				comments: null,
				addtime: null,
				userId: null,
				exWarehouseDate: null,
				outPieces: null
			};
		}
	}
};
