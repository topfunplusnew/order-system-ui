import { TableName } from '@/api/tool/enums';

// 如果是复合数据 列出详细表
export const MultiList = [TableName.INVENTORDETAIL, TableName.ORDER_DETAIL];
export const TableConfig = {
	// 订单主表
	// [TableName.GOODS_ORDER]: {
	// 	mappers: {
	// 		orderDate: '订单日期',
	// 		customer: '客户名称',
	// 		landCarNo: '陆运车牌号',
	// 		landDriverTel: '陆运司机电话',
	// 		landDriverName: '陆运司机姓名',
	// 		seaCarNo: '海运车牌号',
	// 		seaDriverTel: '海运公司电话',
	// 		seaDriverName: '海运公司名称',
	// 		checkState: '审核状态',
	// 		invoiceState: '开票状态',
	// 		landBankName: '陆运司机开户行',
	// 		landBankNo: '陆运司机银行账号',
	// 		seaBankName: '海运公司开户行',
	// 		seaBankNo: '海运公司银行账号',
	// 		saleManager: '销售经理',
	// 		fleet: '车队',
	// 		isAdjusted: '是否已调整',
	// 		adjustDate: '调整日期',
	// 		isAdjust: '是否调整单',
	// 		comments: '备注',
	// 		landFreight: '陆运运费(元)',
	// 		seaFreight: '海运运费(元)',
	// 		supplierNames: '供应商名称',
	// 		allPayments: '总货款金额(元)',
	// 		allPaymentFactory: '出厂货款(元)',
	// 		allTonnage: '总吨位(吨)',
	// 		allFreightPrice: '平均运费单价(元)'
	// 	},
	// 	params: [
	// 		{ name: 'landFreight', label: '陆运运费(元)' },
	// 		{ name: 'seaFreight', label: '海运运费(元)' },
	// 		{ name: 'allPayments', label: '总货款金额(元)' },
	// 		{ name: 'allPaymentFactory', label: '出厂货款(元)' },
	// 		{ name: 'allTonnage', label: '总吨位(吨)' },
	// 		{ name: 'allFreightPrice', label: '平均运费单价(元)' }
	// 	],
	// 	extraParams: [],
	// 	options(key, value) {
	// 		switch (key) {
	// 			case 'isAdjusted': {
	// 				if (value === 0) {
	// 					return '否';
	// 				}
	// 				if (value === 1) {
	// 					return '是';
	// 				}
	// 				break;
	// 			}
	// 			case 'isAdjust': {
	// 				if (value > 0) {
	// 					return '调整单';
	// 				}
	// 				if (value === 0) {
	// 					return '原订单';
	// 				}
	// 				if (value < 0) {
	// 					return '负数单';
	// 				}
	// 				break;
	// 			}
	// 			default: {
	// 				return value;
	// 			}
	// 		}
	// 	}
	// },

	// 订单货物
	[TableName.GOODS_ORDER]: {
		mappers: {
			customer: '客户名称',
			carNumber: '车牌号',
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
			exWarehouseDate: '出库日期',
			comments: '备注'
		},
		params: [
			{ name: 'packs', label: '包数' },
			{ name: 'piecesPerPack', label: '每包片数' },
			{ name: 'pieces', label: '出厂片数' },
			{ name: 'price', label: '出厂单价' },
			{ name: 'sundryCost', label: '杂费' },
			{ name: 'paymentFactory', label: '出厂货款' },
			{ name: 'actualPieces', label: '卸货片数' },
			{ name: 'paymentUnload', label: '卸货价' },
			{ name: 'paymentsWithSundry', label: '总货款杂费' },
			{ name: 'payments', label: '总货款' },
			{ name: 'erro', label: '误差' },
			{ name: 'tonnage', label: '吨位' },
			{ name: 'landFreightPrice', label: '陆运费单价' },
			{ name: 'additionalFees', label: '加费' },
			{ name: 'landFreight', label: '陆运费用' },
			{ name: 'seaFreight', label: '海运费用' },
			{ name: 'freight', label: '总运费' },
			{ name: 'otherCost', label: '其他费用' },
			{ name: 'logisticsProfit', label: '物流利润' },
			{ name: 'customerCommission', label: '客户佣金' },
			{ name: 'factoryCommission', label: '厂家佣金' },
			{ name: 'factoryRebateAmount', label: '计提厂家返利金额' },
			{ name: 'factoryDiscountAmount', label: '计提厂家降价金额' },
			{ name: 'invoiceAmount', label: '发票金额' },
			{ name: 'customerInvoiceAmount', label: '客户发票金额' },
			{ name: 'profit', label: '利润' },
			{ name: 'profitNoTax', label: '不含税利润' }
		],
		extraParams: [],
		options(key, value) {
			switch (key) {
				case 'isIncludeTaxSale': {
					if (value === 0) {
						return '否';
					}
					if (value === 1) {
						return '是';
					}
					break;
				}
				case 'isIncludeTaxFactory': {
					if (value === 0) {
						return '否';
					}
					if (value === 1) {
						return '是';
					}
					break;
				}
				case 'isAdjusted': {
					if (value === 0) {
						return '否';
					}
					if (value === 1) {
						return '是';
					}
					break;
				}
				case 'isAdjust': {
					if (value > 0) {
						return '调整单';
					}
					if (value === 0) {
						return '原订单';
					}
					if (value < 0) {
						return '负数单';
					}
					break;
				}
				case 'isAudit': {
					if (value === 0) {
						return '否';
					}
					if (value === 1) {
						return '是';
					}
					break;
				}
				default: {
					return value;
				}
			}
		}
	},

	// 库存主表
	// [TableName.INVENTORMAIN]: {
	// 	mappers: {
	// 		storeHouseName: '仓库名称',
	// 		storeDate: '入库日期',
	// 		landCarNo: '陆运车牌号',
	// 		landDriverTel: '陆运司机电话',
	// 		landDriverName: '陆运司机姓名',
	// 		seaCarNo: '海运车牌号',
	// 		seaDriverTel: '海运司机电话',
	// 		seaDriverName: '海运司机姓名',
	// 		landBankNo: '陆运银行账号',
	// 		seaBankNo: '海运银行账号',
	// 		landBankName: '陆运开户行',
	// 		seaBankName: '海运开户行',
	// 		allTonnage: '总吨位',
	// 		allFreightPrice: '平均运费单价',
	// 		fleet: '车队',
	// 		checkState: '审核状态'
	// 	},
	// 	params: [
	// 		{ name: 'allTonnage', label: '总吨位' },
	// 		{ name: 'allFreightPrice', label: '平均运费单价' }
	// 	],
	// 	options(key, value) {
	// 		switch (key) {
	// 			default: {
	// 				return value;
	// 			}
	// 		}
	// 	}
	// },

	// 库存子表货物
	[TableName.INVENTORMAIN]: {
		mappers: {
			storeHouseName: '仓库名称',
			storeDate: '入库日期',
			stockNumber: '库存数量',
			supplier: '供应商',
			levelName: '产品级别',
			countingUnit: '计量单位',
			height: '厚度',
			length: '长度',
			width: '宽度',
			pieces: '出厂片数',
			piecesPerPack: '每包片数',
			packs: '包数',
			price: '出厂单价',
			isIncludeTaxFactory: '出厂是否含税',
			sundryCost: '杂费',
			paymentFactory: '出厂货款',
			paymentUnload: '卸货价',
			isIncludeTaxSale: '销售是否含税',
			payments: '总货款',
			erro: '误差',
			tonnage: '吨位',
			landFreightPrice: '陆运费单价',
			landFreight: '陆运费用',
			seaFreight: '海运费用',
			freight: '总运费',
			otherCost: '其他费用',
			profit: '利润',
			profitNoTax: '不含税利润',
			actualPieces: '卸货片数',
			paymentsWithSundry: '总货款杂费',
			additionalFees: '加费',
			customerCommission: '客户佣金',
			factoryCommission: '厂家佣金',
			factoryRebateAmount: '计提厂家返利金额',
			factoryDiscountAmount: '计提厂家降价金额',
			comments: '备注'
		},
		params: [
			{ name: 'stockNumber', label: '库存数量' },
			{ name: 'pieces', label: '出厂片数' },
			{ name: 'piecesPerPack', label: '每包片数' },
			{ name: 'packs', label: '包数' },
			{ name: 'price', label: '出厂单价' },
			{ name: 'sundryCost', label: '杂费' },
			{ name: 'paymentFactory', label: '出厂货款' },
			{ name: 'paymentUnload', label: '卸货价' },
			{ name: 'payments', label: '总货款' },
			{ name: 'erro', label: '误差' },
			{ name: 'tonnage', label: '吨位' },
			{ name: 'landFreightPrice', label: '陆运费单价' },
			{ name: 'landFreight', label: '陆运费用' },
			{ name: 'seaFreight', label: '海运费用' },
			{ name: 'freight', label: '总运费' },
			{ name: 'otherCost', label: '其他费用' },
			{ name: 'profit', label: '利润' },
			{ name: 'profitNoTax', label: '不含税利润' },
			{ name: 'actualPieces', label: '卸货片数' },
			{ name: 'paymentsWithSundry', label: '总货款杂费' },
			{ name: 'additionalFees', label: '加费' },
			{ name: 'customerCommission', label: '客户佣金' },
			{ name: 'factoryCommission', label: '厂家佣金' },
			{ name: 'factoryRebateAmount', label: '计提厂家返利金额' },
			{ name: 'factoryDiscountAmount', label: '计提厂家降价金额' }
		],
		options(key, value) {
			switch (key) {
				default: {
					return value;
				}
			}
		}
	},

	// 订单运费
	[TableName.ORDER_FREIGHT]: {
		mappers: {
			freightType: '运输类型',
			moneyAmount: '金额',
			paidAmount: '已支付金额',
			selfAcountsName: '己方账户名称',
			selfBankNo: '己方银行账号',
			selfBankName: '己方银行名称',
			otherAcountsName: '对方账户名称',
			otherBankNo: '对方银行账号',
			otherBankName: '对方银行名称',
			paymentState: '支付状态',
			driverName: '司机姓名',
			carNo: '车牌号',
			fleet: '车队',
			applyUserName: '申请人',
			applyDate: '申请日期',
			payUserName: '支付用户名',
			payDate: '支付日期',
			comments: '备注',
			checkState: '审核状态'
		},
		params: [
			{ name: 'moneyAmount', label: '金额' },
			{ name: 'paidAmount', label: '已支付金额' }
		],
		options(key, value) {
			switch (key) {
				default: {
					return value;
				}
			}
		}
	},

	// 银行账户变动
	[TableName.BANK_ACCOUNT_CHANGE]: {
		mappers: {
			selfBankNo: '己方银行账号',
			operateDate: '操作日期',
			changeType: '变动类型',
			moneyAmount: '金额',
			comments: '备注',
			companyType: '公司类型',
			bankCardType: '银行卡类型'
		},
		params: [{ name: 'moneyAmount', label: '金额' }],
		options(key, value) {
			switch (key) {
				default: {
					return value;
				}
			}
		}
	},

	// 付款
	[TableName.PAYMENT]: {
		mappers: {
			fundsDate: '资金日期',
			payType: '支付类型',
			moneyAmount: '金额',
			selfAcountsName: '己方账户名称',
			selfBankNo: '己方银行账号',
			selfBankName: '己方银行名称',
			otherAcountsName: '对方账户名称',
			otherBankNo: '对方银行账号',
			otherBankName: '对方银行名称',
			paymentState: '支付状态',
			auditState: '审核状态',
			companyName: '公司名称',
			companyType: '公司类型',
			comments: '备注',
			transactionHistory: '交易历史'
		},
		params: [{ name: 'moneyAmount', label: '金额' }],
		options(key, value) {
			switch (key) {
				default: {
					return value;
				}
			}
		}
	},

	// 借出资金回收
	[TableName.RECOVER_MONEY]: {
		mappers: {
			recoverDate: '回收日期',
			acountsName: '账户名称',
			bankNo: '银行账号',
			moneyAmount: '金额',
			comments: '备注'
		},
		params: [{ name: 'moneyAmount', label: '金额' }],
		options(key, value) {
			switch (key) {
				default: {
					return value;
				}
			}
		}
	},

	// 借入款
	[TableName.BORROWED_MONEY]: {
		mappers: {
			origin: '来源',
			moneyAmount: '金额',
			ratio: '利率',
			loanDate: '贷款日期',
			loanDuring: '贷款期限',
			mortgageGuarantee: '抵押担保',
			acountsName: '账户名称',
			bankNo: '银行账号',
			comments: '备注'
		},
		params: [
			{ name: 'moneyAmount', label: '金额' },
			{ name: 'ratio', label: '利率' }
		],
		options(key, value) {
			switch (key) {
				default: {
					return value;
				}
			}
		}
	},

	// 借出款
	[TableName.LEND_MONEY]: {
		mappers: {
			futuresMarginCompany: '期货保证金公司',
			type: '类型',
			targetType: '目标类型',
			target: '目标',
			moneyAmount: '金额',
			targetAcountsName: '目标账户名称',
			targetBankNo: '目标银行账号',
			targetBankName: '目标银行名称',
			selfAcountsName: '己方账户名称',
			selfBankNo: '己方银行账号',
			selfBankName: '己方银行名称',
			futuresDate: '期货日期',
			reason: '原因',
			comments: '备注'
		},
		params: [{ name: 'moneyAmount', label: '金额' }],
		options(key, value) {
			switch (key) {
				default: {
					return value;
				}
			}
		}
	},

	// 贷款还款记录
	[TableName.REPAYMENT]: {
		mappers: {
			moneyAmount: '金额',
			ratio: '利率',
			payDate: '支付日期',
			acountsName: '账户名称',
			bankNo: '银行账号',
			comments: '备注',
			checkState: '审核状态'
		},
		params: [{ name: 'moneyAmount', label: '金额' }],
		options(key, value) {
			switch (key) {
				default: {
					return value;
				}
			}
		}
	},

	// 商业票据
	[TableName.BANK_ACCEPTANCE]: {
		mappers: {
			operateDate: '操作日期',
			issueDate: '开票日期',
			dueDate: '到期日期',
			billAccount: '票据账户',
			billDate: '票据日期',
			billType: '票据类型',
			reason: '原因',
			endorserName: '背书人名称',
			origin: '来源',
			billAmount: '票据金额',
			inDiscountPoints: '贴现点数',
			inDiscountAmount: '贴现金额',
			billCategory: '票据类别',
			comments: '备注'
		},
		params: [
			{ name: 'billAmount', label: '票据金额' },
			{ name: 'inDiscountAmount', label: '贴现金额' }
		],
		options(key, value) {
			switch (key) {
				default: {
					return value;
				}
			}
		}
	},

	// 收款
	[TableName.RECEIVE_MONEY]: {
		mappers: {
			fundsDate: '资金日期',
			receiveType: '收款类型',
			moneyAmount: '金额',
			selfAcountsName: '己方账户名称',
			selfBankNo: '己方银行账号',
			selfBankName: '己方银行名称',
			otherAcountsName: '对方账户名称',
			otherBankNo: '对方银行账号',
			otherBankName: '对方银行名称',
			companyName: '公司名称',
			companyType: '公司类型',
			comments: '备注',
			endTime: '结束时间'
		},
		params: [{ name: 'moneyAmount', label: '金额' }],
		options(key, value) {
			switch (key) {
				default: {
					return value;
				}
			}
		}
	},

	// 第三方发票
	[TableName.INVOICE_OTHER]: {
		mappers: {
			invoiceDate: '发票日期',
			invoiceAmount: '发票金额',
			supplierTicketPoint: '供应商税点',
			supplierPointAmount: '供应商税点金额',
			customer: '客户名称',
			invoiceCompanyName: '开票公司名称',
			customerTicketPoint: '客户税点',
			customerPointAmount: '客户税点金额',
			comments: '备注',
			endTime: '结束时间',
			oweAmount: '欠款金额',
			supplier: '供应商名称',
			userName: '用户名',
			Supplier: '供应商名称'
		},
		params: [
			{ name: 'invoiceAmount', label: '发票金额' },
			{ name: 'supplierPointAmount', label: '供应商税点金额' },
			{ name: 'customerPointAmount', label: '客户税点金额' },
			{ name: 'oweAmount', label: '欠款金额' }
		],
		options(key, value) {
			switch (key) {
				default: {
					return value;
				}
			}
		}
	},

	// 发票卖出
	[TableName.INVOICE_OUT]: {
		mappers: {
			invoiceDate: '发票日期',
			invoiceObject: '发票对象',
			invoiceAmount: '发票金额',
			companyType: '公司类型',
			companyName: '公司名称',
			invoiceCompanyName: '开票公司名称',
			ticketPoint: '税点',
			ticketPointAmount: '税点金额',
			isOrderTax: '是否订单税',
			comments: '备注',
			oweAmount: '欠款金额'
		},
		params: [
			{ name: 'invoiceAmount', label: '发票金额' },
			{ name: 'ticketPointAmount', label: '税点金额' },
			{ name: 'oweAmount', label: '欠款金额' }
		],
		options(key, value) {
			switch (key) {
				default: {
					return value;
				}
			}
		}
	},

	// 发票买入
	[TableName.INVOICE_IN]: {
		mappers: {
			invoiceDate: '发票日期',
			endTime: '结束时间',
			invoiceObject: '发票对象',
			invoiceAmount: '发票金额',
			companyType: '公司类型',
			companyName: '公司名称',
			invoiceCompanyName: '开票公司名称',
			ticketPoint: '税点',
			ticketPointAmount: '税点金额',
			isOrderTax: '是否订单税',
			comments: '备注'
		},
		params: [
			{ name: 'invoiceAmount', label: '发票金额' },
			{ name: 'ticketPointAmount', label: '税点金额' }
		],
		options(key, value) {
			switch (key) {
				default: {
					return value;
				}
			}
		}
	},

	// 冲抵货款/内部转账
	[TableName.CASH_RECORD]: {
		mappers: {
			id: 'ID',
			code: '编码',
			type: '冲抵类型',
			amount: '金额',
			transactionTime: '交易时间',
			userName: '操作人员姓名',
			targetCompanyName: '收入方',
			sourceCompanyName: '支出方',
			targetAccountName: '收款户名',
			targetBankNo: '收款账号',
			sourceAccountName: '支付户名',
			sourceBankNo: '支付账号',
			targetCompanyType: '收入公司类型',
			targetPaymentType: '收入方支付类型',
			sourceCompanyType: '支出方公司类型',
			sourcePaymentType: '支出方支付类型',
			targetBankName: '收入方开户行',
			sourceBankName: '支出方开户行',
			remarks: '备注',
			accountType: '账户类型',
			selfBankCardType: '己方银行卡类型',
			otherBankCardType: '对方银行卡类型',
			addtime: '添加时间',
			createTime: '创建时间',
			updateTime: '更新时间',
			remark: '备注'
		},
		params: [{ name: 'amount', label: '金额' }],
		options(key, value) {
			switch (key) {
				case 'type': {
					if (value === 'transfer') {
						return '内部转账';
					}
					if (value === 'cash_record' || value === TableName.CASH_RECORD) {
						return '冲抵货款';
					}
					return value;
				}
				case 'accountType': {
					// 账户类型格式化逻辑（仅在内部转账时显示）
					// 注意：这个格式化需要在组件中根据 row.type 和 row.selfBankCardType/otherBankCardType 来判断
					// 这里只做基础处理，复杂逻辑在组件中处理
					return value;
				}
				case 'delFlag': {
					if (value === 0) {
						return '正常';
					}
					if (value === 1) {
						return '已删除';
					}
					return value;
				}
				default: {
					return value;
				}
			}
		}
	},

	// 出库
	[TableName.EX_WAREHOUSE]: {
		mappers: {
			storeHouseName: '仓库名称',
			outDirection: '出库方向',
			outDate: '出库日期',
			outAmount: '出库量',
			ordersNo: '订单编号',
			storeID: '库存ID',
			storeHouseid: '仓库ID',
			delFlag: '删除标志',
			addtime: '添加时间',
			userId: '用户ID',
			UserName: '用户名'
		},
		params: [{ name: 'outAmount', label: '出库量' }],
		extraParams: [],
		options(key, value) {
			switch (key) {
				case 'outDirection': {
					if (value && value !== '二次加工' && value !== '破损出库') {
						return `${value}[客户]`;
					}
					if (value === '二次加工') {
						return '二次入库出库';
					}
					if (value === '破损出库') {
						return '存货毁损';
					}
					return value;
				}
				case 'delFlag': {
					if (value === 0) {
						return '正常';
					}
					if (value === 1) {
						return '已删除';
					}
					return value;
				}
				default: {
					return value;
				}
			}
		}
	}
};
