import { TableName } from '@/api/tool/enums';

export const TableConfig = {
	// 订单
	[TableName.GOODS_ORDER]: {
		mappers: {
			params: {
				isHaveOrderLandfreight: '是否有陆运费',
				isHaveOrderSeafreight: '是否有海运费'
			},
			orderDate: '订单日期',
			customer: '客户名称',
			landCarNo: '陆运车牌',
			landDriverTel: '陆运司机电话',
			landDriverName: '陆运司机姓名',
			seaCarNo: '海运车牌',
			seaDriverTel: '海运司机电话',
			seaDriverName: '海运司机姓名',
			checkState: '审核状态',
			invoiceState: '发票状态',
			path: '路径',
			landBankName: '陆运开户行',
			landBankNo: '陆运账号',
			seaBankName: '海运开户行',
			seaBankNo: '海运账号',
			receiveProof: '收货凭证',
			saleManager: '销售经理',
			fleet: '车队名称',
			isAdjusted: '是否调整',
			adjustDate: '调整日期',
			isAdjust: '调整状态',
			customerIsInvoice: '客户是否开票',
			isSupplierInvoice: '供应商是否开票',
			comments: '备注',
			landFreight: '陆运费用',
			seaFreight: '海运费用',
			supplierNames: '供应商名称',
			allPayments: '总支付金额',
			allPaymentFactory: '总出厂货款',
			allTonnage: '总吨位',
			allFreightPrice: '总运费'
		},
		options(callback) {
			return typeof callback === 'function' ? callback(this) : this;
		}
	},
	// 订单货物
	[TableName.ORDER_DETAIL]: {
		mappers: {
			supplier: '供应商',
			levelName: '产品级别',
			countingUnit: '计量单位',
			height: '厚度',
			length: '长度',
			width: '宽度',
			packs: '包数',
			piecesPerPack: '每包片数',
			pieces: '出厂片数',
			price: '出厂单价',
			isIncludeTaxFactory: '出厂是否含税',
			sundryCost: '杂费',
			paymentFactory: '出厂货款',
			actualPieces: '卸货片数',
			paymentUnload: '卸货价',
			isIncludeTaxSale: '销售是否含税',
			paymentsWithSundry: '总货款杂费',
			payments: '总货款',
			erro: '误差',
			tonnage: '吨位',
			landFreightPrice: '陆运费单价',
			additionalFees: '加费',
			landFreight: '陆运费用',
			seaFreight: '海运费用',
			freight: '总运费',
			otherCost: '其他费用',
			logisticsProfit: '物流利润',
			customerCommission: '客户佣金',
			factoryCommission: '厂家佣金',
			factoryRebateAmount: '计提厂家返利金额',
			factoryDiscountAmount: '计提厂家降价金额',
			comments: '备注',
			customer: '客户名称',
			carNumber: '车牌号',
			driverPhone: '司机电话',
			seaFreightNumber: '海运单号',
			seaFreightCompanyPhone: '海运公司电话',
			storeHouseName: '仓库名称',
			supplierInvoiceDate: '供应商开票日期',
			invoiceAmount: '发票金额',
			customerInvoiceDate: '客户开票日期',
			customerInvoiceAmount: '客户发票金额',
			customerInvoiceTaxEntity: '客户发票税实体',
			profit: '利润',
			profitNoTax: '不含税利润',
			salesManager: '销售经理',
			fleet: '车队名称',
			isAdjusted: '是否调整',
			isAdjust: '调整状态',
			adjustDate: '调整日期',
			isAudit: '是否审核',
			exWarehouseDate: '出库日期'
		},
		options(callback) {
			return typeof callback === 'function' ? callback(this) : this;
		}
	}
};
