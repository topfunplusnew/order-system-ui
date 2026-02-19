/**
 * 资金变动模板组件的测试 mock 数据
 * 每个 compareData 项格式：{ originalInfo, changedInfo, tableName? }
 */

const mkRecord = (orig, chg, tableName) => ({ originalInfo: orig, changedInfo: chg, tableName });

/** 入库管理 inventory_main */
export const inventoryMainMock = [
	// 入库单(1)：3 条明细
	mkRecord(
		{
			storeDate: '2026-01-28',
			storeHouseName: '刘彦波仓库',
			landCarNo: '冀EV2968',
			allLandFreight: 3700,
			allSeaFreight: 0,
			allTonnage: 7.72,
			userName: '张璐鑫',
			fleet: '客户自提',
			comments: '多明细备注',
			inventoryDetailList: [
				{
					supplier: '卓航玻璃',
					levelName: '玻超白汽车',
					countingUnit: '片',
					height: 7,
					length: 3660,
					width: 2250,
					stockNumber: 24,
					paymentUnload: 24.8,
					piecesPerPack: 36,
					packs: 1,
					price: 24.8,
					paymentFactory: 4493.02,
					isIncludeTaxFactory: 0,
					isIncludeTaxSale: 0,
					sundryCost: 0,
					landFreightPrice: 50
				},
				{
					supplier: '立强/武世古玉晶',
					levelName: '玉晶',
					countingUnit: '片',
					height: 6,
					length: 3660,
					width: 2440,
					stockNumber: 36,
					paymentUnload: 18.5,
					piecesPerPack: 36,
					packs: 1,
					price: 18.5,
					paymentFactory: 2664,
					isIncludeTaxFactory: 0,
					isIncludeTaxSale: 0,
					sundryCost: 0,
					landFreightPrice: 50
				},
				{ supplier: '威海中玻', levelName: 'Low-E', countingUnit: '片', height: 6, length: 3660, width: 2440, stockNumber: 40, paymentUnload: 28, piecesPerPack: 40, packs: 1, price: 28, paymentFactory: 4480, isIncludeTaxFactory: 0, isIncludeTaxSale: 0, sundryCost: 0, landFreightPrice: 50 }
			]
		},
		{
			storeDate: '2026-01-28',
			storeHouseName: '刘彦波仓库',
			landCarNo: '冀EV2968',
			allLandFreight: 3800,
			allSeaFreight: 0,
			allTonnage: 7.72,
			userName: '张璐鑫',
			fleet: '客户自提',
			comments: '多明细备注修改',
			inventoryDetailList: [
				{
					supplier: '卓航玻璃',
					levelName: '玻超白汽车',
					countingUnit: '片',
					height: 7,
					length: 3660,
					width: 2250,
					stockNumber: 24,
					paymentUnload: 24.6,
					piecesPerPack: 36,
					packs: 1,
					price: 24.6,
					paymentFactory: 4417.02,
					isIncludeTaxFactory: 0,
					isIncludeTaxSale: 0,
					sundryCost: 0,
					landFreightPrice: 50
				},
				{
					supplier: '立强/武世古玉晶',
					levelName: '玉晶',
					countingUnit: '片',
					height: 6,
					length: 3660,
					width: 2440,
					stockNumber: 36,
					paymentUnload: 18.8,
					piecesPerPack: 36,
					packs: 1,
					price: 18.8,
					paymentFactory: 2707.2,
					isIncludeTaxFactory: 0,
					isIncludeTaxSale: 0,
					sundryCost: 0,
					landFreightPrice: 50
				},
				{
					supplier: '威海中玻',
					levelName: 'Low-E',
					countingUnit: '片',
					height: 6,
					length: 3660,
					width: 2440,
					stockNumber: 38,
					paymentUnload: 27.5,
					piecesPerPack: 40,
					packs: 1,
					price: 27.5,
					paymentFactory: 4180,
					isIncludeTaxFactory: 0,
					isIncludeTaxSale: 0,
					sundryCost: 0,
					landFreightPrice: 50
				}
			]
		}
	),
	// 入库单(2)：2 条明细
	mkRecord(
		{
			storeDate: '2026-01-29',
			storeHouseName: '于双成仓库',
			landCarNo: '冀ER7906',
			allLandFreight: 2500,
			allSeaFreight: 0,
			allTonnage: 5.2,
			userName: '李四',
			fleet: '自运',
			comments: '双明细',
			inventoryDetailList: [
				{ supplier: '沙河某厂', levelName: '普通白玻', countingUnit: '片', height: 6, length: 2440, width: 1830, stockNumber: 100, paymentUnload: 12, piecesPerPack: 30, packs: 3, price: 12, paymentFactory: 3600, isIncludeTaxFactory: 1, isIncludeTaxSale: 1 },
				{ supplier: '德州金晶', levelName: '超白', countingUnit: '片', height: 5, length: 3660, width: 2440, stockNumber: 60, paymentUnload: 15, piecesPerPack: 36, packs: 2, price: 15, paymentFactory: 2700, isIncludeTaxFactory: 0, isIncludeTaxSale: 0 }
			]
		},
		{
			storeDate: '2026-01-29',
			storeHouseName: '于双成仓库',
			landCarNo: '冀ER7906',
			allLandFreight: 2600,
			allSeaFreight: 0,
			allTonnage: 5.2,
			userName: '李四',
			fleet: '自运',
			comments: '双明细修改',
			inventoryDetailList: [
				{ supplier: '沙河某厂', levelName: '普通白玻', countingUnit: '片', height: 6, length: 2440, width: 1830, stockNumber: 100, paymentUnload: 12.2, piecesPerPack: 30, packs: 3, price: 12.2, paymentFactory: 3660, isIncludeTaxFactory: 1, isIncludeTaxSale: 1 },
				{ supplier: '德州金晶', levelName: '超白', countingUnit: '片', height: 5, length: 3660, width: 2440, stockNumber: 58, paymentUnload: 15.2, piecesPerPack: 36, packs: 2, price: 15.2, paymentFactory: 2643.6, isIncludeTaxFactory: 0, isIncludeTaxSale: 0 }
			]
		}
	),
	// 入库单(3)：单明细
	mkRecord(
		{
			storeDate: '2026-01-15',
			storeHouseName: '刘彦波仓库',
			landCarNo: '冀EV2968',
			allLandFreight: 3700,
			allSeaFreight: 0,
			allTonnage: 7.72,
			userName: '张璐鑫',
			fleet: '客户自提',
			comments: '备注A',
			inventoryDetailList: [
				{
					supplier: '周口项城苏豫',
					levelName: '北玻Lowe160',
					countingUnit: '片',
					height: 5,
					length: 3660,
					width: 2440,
					stockNumber: 72,
					paymentUnload: 16.4,
					piecesPerPack: 36,
					packs: 2,
					paymentFactory: 6745.02,
					isIncludeTaxFactory: 0,
					isIncludeTaxSale: 0,
					sundryCost: -3800,
					landFreightPrice: 50
				}
			]
		},
		{
			storeDate: '2026-01-15',
			storeHouseName: '刘彦波仓库',
			landCarNo: '冀EV2968',
			allLandFreight: 3800,
			allSeaFreight: 0,
			allTonnage: 7.72,
			userName: '张璐鑫',
			fleet: '客户自提',
			comments: '备注A修改',
			inventoryDetailList: [
				{
					supplier: '周口项城苏豫',
					levelName: '北玻Lowe160',
					countingUnit: '片',
					height: 5,
					length: 3660,
					width: 2440,
					stockNumber: 72,
					paymentUnload: 16.5,
					piecesPerPack: 36,
					packs: 2,
					paymentFactory: 6800,
					isIncludeTaxFactory: 0,
					isIncludeTaxSale: 0,
					sundryCost: -3800,
					landFreightPrice: 50
				}
			]
		}
	),
	mkRecord(
		{
			storeDate: '2026-01-16',
			storeHouseName: '于双成仓库',
			landCarNo: '冀ER7906',
			allLandFreight: 2500,
			allSeaFreight: 0,
			allTonnage: 5.2,
			userName: '李四',
			fleet: '自运',
			comments: '',
			inventoryDetailList: [{ supplier: '沙河某厂', levelName: '普通白玻', countingUnit: '片', height: 6, length: 2440, width: 1830, stockNumber: 100, paymentUnload: 12, piecesPerPack: 30, packs: 3, paymentFactory: 3600, isIncludeTaxFactory: 1, isIncludeTaxSale: 1 }]
		},
		{
			storeDate: '2026-01-16',
			storeHouseName: '于双成仓库',
			landCarNo: '冀ER7906',
			allLandFreight: 2600,
			allSeaFreight: 0,
			allTonnage: 5.2,
			userName: '李四',
			fleet: '自运',
			comments: '运费调整',
			inventoryDetailList: [{ supplier: '沙河某厂', levelName: '普通白玻', countingUnit: '片', height: 6, length: 2440, width: 1830, stockNumber: 100, paymentUnload: 12.2, piecesPerPack: 30, packs: 3, paymentFactory: 3660, isIncludeTaxFactory: 1, isIncludeTaxSale: 1 }]
		}
	),
	mkRecord(
		{
			storeDate: '2026-01-17',
			storeHouseName: '临西仓库',
			landCarNo: '冀A12345',
			allLandFreight: 4500,
			allSeaFreight: 1200,
			allTonnage: 12,
			userName: '王五',
			fleet: '物流',
			comments: '海运单',
			inventoryDetailList: [{ supplier: '威海中玻', levelName: 'Low-E', countingUnit: '片', height: 6, length: 3660, width: 2440, stockNumber: 150, paymentUnload: 28, piecesPerPack: 40, packs: 4, paymentFactory: 16800, isIncludeTaxFactory: 0, isIncludeTaxSale: 0 }]
		},
		{
			storeDate: '2026-01-17',
			storeHouseName: '临西仓库',
			landCarNo: '冀A12345',
			allLandFreight: 4500,
			allSeaFreight: 1500,
			allTonnage: 12,
			userName: '王五',
			fleet: '物流',
			comments: '海运费涨',
			inventoryDetailList: [{ supplier: '威海中玻', levelName: 'Low-E', countingUnit: '片', height: 6, length: 3660, width: 2440, stockNumber: 140, paymentUnload: 28, piecesPerPack: 40, packs: 4, paymentFactory: 15680, isIncludeTaxFactory: 0, isIncludeTaxSale: 0 }]
		}
	),
	mkRecord(
		{
			storeDate: '2026-01-18',
			storeHouseName: '德州仓库',
			landCarNo: '鲁N88888',
			allLandFreight: 3200,
			allSeaFreight: 0,
			allTonnage: 8.5,
			userName: '赵六',
			fleet: '客户自提',
			comments: null,
			inventoryDetailList: [{ supplier: '德州金晶', levelName: '超白', countingUnit: '其他', height: 1, length: 1, width: 1, stockNumber: 50, paymentUnload: 18, piecesPerPack: 1, packs: 50, paymentFactory: 900, isIncludeTaxFactory: 0, isIncludeTaxSale: 0 }]
		},
		{
			storeDate: '2026-01-18',
			storeHouseName: '德州仓库',
			landCarNo: '鲁N88888',
			allLandFreight: 3200,
			allSeaFreight: 0,
			allTonnage: 8.5,
			userName: '赵六',
			fleet: '客户自提',
			comments: null,
			inventoryDetailList: [{ supplier: '德州金晶', levelName: '超白', countingUnit: '其他', height: 1, length: 1, width: 1, stockNumber: 48, paymentUnload: 18.5, piecesPerPack: 1, packs: 48, paymentFactory: 888, isIncludeTaxFactory: 0, isIncludeTaxSale: 0 }]
		}
	)
];

/** 二次出库 exwarehouse */
const exwarehouseDetail = (levelName, outAmt, price, len, w, h) => ({
	sourceInventoryDetail: { levelName, countingUnit: '片', stockNumber: outAmt, paymentUnload: price, length: len, width: w, height: h },
	storeHouseName: '刘彦波仓库',
	outDirection: '二次加工',
	outDate: '2026-01-20',
	outAmount: outAmt,
	outState: 1
});
export const exwarehouseMock = [
	mkRecord(exwarehouseDetail('湖北三峡欧洲灰', 52, 20.97, 3660, 2250, 7.2), exwarehouseDetail('湖北三峡欧洲灰', 52, 21, 3660, 2250, 7.2)),
	mkRecord(exwarehouseDetail('北玻Lowe160', 36, 16.4, 3660, 2440, 5), exwarehouseDetail('北玻Lowe160', 40, 16.5, 3660, 2440, 5)),
	mkRecord(exwarehouseDetail('普通白玻', 100, 12, 2440, 1830, 6), exwarehouseDetail('普通白玻', 95, 12.2, 2440, 1830, 6)),
	mkRecord(exwarehouseDetail('Low-E', 80, 28, 3660, 2440, 6), exwarehouseDetail('Low-E', 80, 27.5, 3660, 2440, 6))
];

/** 订单调整单 goodsorder */
const orderDetail = (levelName, pay, supplier) => ({ levelName, paymentFactory: pay, supplier });
const orderRow = (customer, allPay, land, sea, details) => ({
	checkState: '已审核',
	addtime: '2026-01-15T10:00:00',
	customer,
	landCarNo: '冀EV2968',
	supplierNames: details.map(d => d.supplier).join(','),
	orderDetailList: details.map(d => orderDetail(d.levelName, d.pay, d.supplier)),
	allPayments: allPay,
	landFreight: land,
	seaFreight: sea,
	storeHouseName: '刘彦波仓库'
});
export const orderAdjustmentMock = [
	mkRecord(
		orderRow('山东兖州辰明', 105000, 3700, 0, [
			{ levelName: '北玻Lowe160', pay: 67450, supplier: '周口项城' },
			{ levelName: '装卸费', pay: 100, supplier: '于双成' }
		]),
		orderRow('山东兖州辰明', 106000, 3800, 0, [
			{ levelName: '北玻Lowe160', pay: 68100, supplier: '周口项城' },
			{ levelName: '装卸费', pay: 100, supplier: '于双成' }
		])
	),
	mkRecord(orderRow('临沭胜金玻璃', 50216, 2500, 0, [{ levelName: '普通白玻', pay: 48000, supplier: '沙河某厂' }]), orderRow('临沭胜金玻璃', 49800, 2600, 0, [{ levelName: '普通白玻', pay: 46500, supplier: '沙河某厂' }])),
	mkRecord(orderRow('贵阳中新玻璃', 501216, 0, 5000, [{ levelName: 'Low-E', pay: 495000, supplier: '威海中玻' }]), orderRow('贵阳中新玻璃', 510000, 0, 5500, [{ levelName: 'Low-E', pay: 503000, supplier: '威海中玻' }])),
	mkRecord(orderRow(' unknown客户', 2762, 0, 0, []), orderRow('未知客户', 3000, 0, 0, []))
];

/** 票点 invoicein/invoiceout/invoiceother */
const ticketRow = (amt, cust, sup, custPoint, supPoint) => ({
	invoiceAmount: amt,
	companyType: '客户',
	customer: cust,
	Supplier: sup,
	customerPointAmount: custPoint,
	supplierPointAmount: supPoint,
	invoiceDate: '2026-01-16',
	pointRate: 0.068,
	supplierPointRate: 0.068
});
export const ticketPointMock = [
	mkRecord(ticketRow(501216, '', '', null, 34082.69), ticketRow(501216, '', '', null, 34082.69), 'invoicein'),
	mkRecord(ticketRow(10000, '临沭胜金玻璃', '', 800, null), ticketRow(10000, '临沭胜金玻璃', '', 820, null), 'invoiceout'),
	mkRecord(ticketRow(250000, '某客户', '某供应商', 17000, 16500), ticketRow(250000, '某客户', '某供应商', 17200, 16800), 'invoiceother'),
	mkRecord(ticketRow(88000, '德州客户', '德州供应商', 5800, 5600), ticketRow(88000, '德州客户', '德州供应商', 6000, 5800), 'invoicein')
];

/** 收款 receivemoney */
const receiveRow = (amt, company, ctype, dt) => ({
	moneyAmount: amt,
	companyName: company,
	companyType: ctype,
	receiveTime: dt || '2026-01-28T09:13:18',
	addtime: dt,
	payType: '资产-应收账款-客户往来',
	bankName: '张娟娟-兴业银行',
	bankNo: '622908573152802617'
});
export const receiveMoneyMock = [
	mkRecord(receiveRow(null, '-', ''), receiveRow(45460, '山东兖州辰明玻璃科技公司', '客户')),
	mkRecord(receiveRow(2762, '未知客户', '客户', '2025-11-09T17:45:58'), receiveRow(2762, '未知客户', '客户')),
	mkRecord(receiveRow(100000, '沙河客户A', '客户'), receiveRow(95000, '沙河客户A', '客户')),
	mkRecord(receiveRow(50000, '天津森强', '供应商'), receiveRow(52000, '天津森强', '供应商'))
];

/** 付款 payment */
const paymentRow = (amt, company, ctype, dt) => ({
	moneyAmount: amt,
	companyName: company,
	companyType: ctype,
	payTime: dt || '2026-01-29',
	addtime: dt,
	payType: '负债-应付账款-供应商往来',
	bankName: '张长勇-德州银行',
	bankNo: '6229370100008135948',
	landFreight: null,
	seaFreight: null
});
export const paymentMock = [
	mkRecord(paymentRow(7793, '科耀/赵越', '供应商'), paymentRow(7693, '科耀/赵越', '供应商')),
	mkRecord(paymentRow(15000, '沙河供应商', '供应商'), paymentRow(14800, '沙河供应商', '供应商')),
	mkRecord(paymentRow(3000, '某司机', '司机', '2026-01-20'), paymentRow(3200, '某司机', '司机', '2026-01-20')),
	mkRecord(paymentRow(200000, '威海中玻', '供应商'), paymentRow(195000, '威海中玻', '供应商'))
];

/** 冲抵款 cash_record */
const offsetRow = (amt, srcType, tgtType, srcName, tgtName) => ({
	amount: amt,
	addtime: '2026-01-30',
	sourceCompanyType: srcType,
	targetCompanyType: tgtType,
	sourceCompanyName: srcName,
	targetCompanyName: tgtName,
	type: 'transfer',
	payAccountName: srcName,
	receiveAccountName: tgtName,
	payAccountNo: '20000087544500141500278',
	receiveAccountNo: '6229370100008440215',
	sourcePayType: '内部往来支出',
	targetPayType: '内部往来收入'
});
export const offsetPaymentMock = [
	mkRecord(offsetRow(380000, '己方公司', '己方公司', '青岛远必达-北京银行', '郭龙-德州银行'), offsetRow(280000, '己方公司', '己方公司', '青岛远必达-北京银行', '郭龙-德州银行')),
	mkRecord(offsetRow(50320, '客户', '供应商', '潍坊盛辉玻璃公司', '天津森强'), offsetRow(40320, '客户', '供应商', '潍坊盛辉玻璃公司', '天津森强')),
	mkRecord(offsetRow(100000, '客户', '供应商', '客户A', '供应商B'), offsetRow(98000, '客户', '供应商', '客户A', '供应商B')),
	mkRecord(offsetRow(25000, '供应商', '客户', '供应商C', '客户D'), offsetRow(26000, '供应商', '客户', '供应商C', '客户D'))
];

/** 平账 balanceaccounts */
const balanceRow = (amt, company, ctype, dt, remark) => ({
	moneyAmount: amt,
	companyName: company,
	companyType: ctype,
	addtime: dt,
	remark
});
export const balanceAccountsMock = [
	mkRecord(balanceRow(952.6, '胜芳恒昇源', '客户', '2026-01-24T11:37:16', '恒昇源承兑贴息952.6元已到账'), balanceRow(930, '胜芳恒昇源', '客户', '2026-01-24T11:37:16', '承兑贴息952.6元客户单独打还未打')),
	mkRecord(balanceRow(1200, '沙河客户', '客户', '2026-01-25T10:00:00', '平账1'), balanceRow(1180, '沙河客户', '客户', '2026-01-25T10:00:00', '平账1修正')),
	mkRecord(balanceRow(3500, '某供应商', '供应商', '2026-01-26T14:20:00', '供应商平账'), balanceRow(3480, '某供应商', '供应商', '2026-01-26T14:20:00', '供应商平账修正')),
	mkRecord(balanceRow(580, '德州客户', '客户', '2026-01-27T09:15:00', '尾款平账'), balanceRow(580, '德州客户', '客户', '2026-01-27T09:15:00', '尾款平账'))
];

/** 借入款 borrowedmoney */
const borrowRow = (principal, repaid, interest, lender) => ({
	moneyAmount: principal,
	lenderName: lender,
	repayments: repaid > 0 ? [{ moneyAmount: repaid, ratio: interest }] : [],
	grantDate: null,
	loanYears: 1,
	mortgage: '房产',
	intoAccountName: '张娟娟-兴业银行',
	bankNo: '0'
});
export const borrowedMoneyMock = [
	mkRecord(borrowRow(5000000, 0, 0, '德州银行'), borrowRow(5000000, 1000000, 10000, '德州银行')),
	mkRecord(borrowRow(2000000, 500000, 5000, '建设银行'), borrowRow(2000000, 600000, 6000, '建设银行')),
	mkRecord(borrowRow(1000000, 0, 0, '农业银行'), borrowRow(1000000, 200000, 2000, '农业银行')),
	mkRecord(borrowRow(3000000, 1500000, 15000, '工商银行'), borrowRow(3000000, 1600000, 16000, '工商银行'))
];

/** 从我司借款 lendmoney */
const lendRow = (amt, recover, badDebt, name, otype) => ({
	moneyAmount: amt,
	borrowerName: name,
	objectType: otype,
	companyName: name,
	recoverMoneyList: recover > 0 ? [{ moneyAmount: recover, badDebtFlag: 0 }] : [],
	addtime: '2026-01-20',
	bankNo: '6229370100008630000',
	bankName: '张成龙-德州银行'
});
export const lendMoneyMock = [
	mkRecord(lendRow(96800, 0, 0, '李强借款', '供应商'), lendRow(96800, 5000, 5000, '李强借款', '供应商')),
	mkRecord(lendRow(20000, 0, 0, '张付利', '员工'), lendRow(20000, 0, 0, '张付利', '员工')),
	mkRecord(lendRow(50000, 10000, 0, '某公司', '供应商'), lendRow(50000, 15000, 0, '某公司', '供应商')),
	mkRecord(lendRow(30000, 0, 0, '王某', '员工'), lendRow(30000, 5000, 0, '王某', '员工'))
];

/** 收取保证金 deposit_money */
const depositRow = (amt, refund, company) => ({
	moneyAmount: amt,
	companyName: company,
	depositRefundList: refund > 0 ? [{ moneyAmount: refund, badDebtFlag: 0 }] : [],
	addtime: '2022-02-11',
	depositType: '司机保证金',
	bankName: '孙梅-农行'
});
export const depositMoneyMock = [
	mkRecord(depositRow(80000, 0, '王逊强'), depositRow(80000, 40000, '王逊强')),
	mkRecord(depositRow(50000, 0, '司机A'), depositRow(50000, 20000, '司机A')),
	mkRecord(depositRow(100000, 30000, '客户保证金'), depositRow(100000, 50000, '客户保证金')),
	mkRecord(depositRow(60000, 10000, '李四'), depositRow(60000, 15000, '李四'))
];

/** 期货保证金 FuturesDepositTemplate - 使用 lendmoney type=期货 */
const futuresRow = (amt, recover, badDebt) => ({
	moneyAmount: amt,
	companyName: '方正中期期货有限公司',
	borrowerName: '方正中期期货有限公司',
	recoverMoneyList: [...(recover > 0 ? [{ moneyAmount: recover, badDebtFlag: 0 }] : []), ...(badDebt > 0 ? [{ moneyAmount: badDebt, badDebtFlag: 1 }] : [])],
	addtime: '2026-01-20',
	bankNo: '6228451810019150000',
	bankName: '孙克鹏-农行9919'
});
export const futuresDepositMock = [
	mkRecord(futuresRow(5200000, 0, 0), futuresRow(5200000, 700000, 500000)),
	mkRecord(futuresRow(3000000, 500000, 0), futuresRow(3000000, 600000, 100000)),
	mkRecord(futuresRow(2000000, 0, 0), futuresRow(2000000, 300000, 0)),
	mkRecord(futuresRow(4500000, 200000, 50000), futuresRow(4500000, 400000, 100000))
];

/** 厂家保证金 SupplierDepositTemplate */
const factoryDepositRow = (amt, recover, badDebt) => ({
	moneyAmount: amt,
	companyName: '威海中玻',
	borrowerName: '威海中玻玻璃',
	recoverMoneyList: [...(recover > 0 ? [{ moneyAmount: recover, badDebtFlag: 0 }] : []), ...(badDebt > 0 ? [{ moneyAmount: badDebt, badDebtFlag: 1 }] : [])],
	addtime: '2026-01-20',
	bankNo: '6228481259193020000',
	bankName: '孙梅-农行'
});
export const supplierDepositMock = [
	mkRecord(factoryDepositRow(100000, 0, 0), factoryDepositRow(100000, 20000, 10000)),
	mkRecord(factoryDepositRow(80000, 10000, 0), factoryDepositRow(80000, 15000, 5000)),
	mkRecord(factoryDepositRow(150000, 30000, 0), factoryDepositRow(150000, 50000, 10000)),
	mkRecord(factoryDepositRow(50000, 0, 0), factoryDepositRow(50000, 10000, 0))
];
