// 一次修改的对象
const obj = {
	body: {
		// 是否是订单或库存 Object.keys(renderData[index]).length > 0 ? true : false
		isMulti: true,
		// 是否是调整单 isMulti ? (renderData[index].goodsOrder.length || renderData[index].inventory_main.length) > 0 ? true : false : false
		isAdjust: true,
		main_info: {
			// tableName !== TableName.GOODS_ORDER || tableName !== TableName.INVENTORY_MAIN
			data: {
				id: '1',
				backupTime: '2025-05-02',
				logicBackupType: 'insert',
				changedInfo: '{"id": null, "path": null}',
				originalInfo: null,
				uuid: '127c123c-1027-40c0-a0e2-3a022d3123d91c',
				tableName: 'payment'
			},
			// tableName === TableName.GOODS_ORDER || tableName === TableName.INVENTORY_MAIN
			items: [
				{
					id: '1',
					backupTime: '2025-05-02',
					logicBackupType: 'insert',
					changedInfo: '{"id": null, "path": null}',
					originalInfo: null,
					uuid: '5c2c6305-10d7-40b0-a0e2-3a02233ef91c',
					tableName: 'goodsorder'
				},
				{
					id: '2',
					backupTime: '2025-05-02',
					logicBackupType: 'insert',
					changedInfo: '{"id": null, "path": null}',
					originalInfo: null,
					uuid: '5c2c6305-10d7-40b0-a0e2-3a02233ef91c',
					tableName: 'goodsorder'
				}
			]
		},
		// isMulti === true
		sub_info: {
			items: [
				{
					createBy: null,
					createTime: null,
					updateBy: null,
					updateTime: null,
					remark: null,
					selfBankCardType: null,
					otherBankCardType: null,
					id: 4320,
					tableName: 'orderdetail',
					backupTime: '2025-03-27 12:10:56',
					backupType: 'insert',
					backupUserTruename: 'maolei',
					backupUserId: 1,
					originalInfo:
						'[{"id": null, "erro": 0.0, "fleet": null, "packs": 12, "price": -11.0, "width": 2440.0, "height": 5.0, "length": 3660.0, "params": {}, "pieces": 12, "profit": 1073.988, "remark": null, "userId": 1, "addtime": "2025-03-27 12:10:55", "freight": 2.34, "isAudit": null, "levelID": 5, "storeID": 20, "tonnage": -1.34, "comments": "5", "createBy": null, "customer": "张敏", "isAdjust": "-1", "ordersNo": "b48b256d-6c36-425f-9c9b-7450a07177c9", "payments": -108.165, "supplier": "", "updateBy": null, "userName": "maolei", "carNumber": null, "levelName": "本溪玉晶一等品", "orderDate": "2025-03-27 12:09:00", "otherCost": 1.0, "adjustDate": null, "cancelFlag": 0, "createTime": null, "customerID": 5, "isAdjusted": "否", "seaFreight": 0.0, "sundryCost": -1.0, "supplierID": null, "updateTime": null, "driverPhone": null, "landFreight": -2.34, "profitNoTax": 1074.988, "actualPieces": 12, "countingUnit": "片", "salesManager": null, "storeHouseID": 1, "adjustOrderNo": "null", "invoiceAmount": null, "paymentUnload": 1.0, "piecesPerPack": 1, "additionalFees": 1.0, "paymentFactory": -1179.813, "storeHouseName": "测试仓库", "exWarehouseDate": "2025-03-27 12:10:55", "logisticsProfit": 1.0, "isIncludeTaxSale": 0, "landFreightPrice": -1.0, "seaFreightNumber": null, "selfBankCardType": null, "factoryCommission": 2.0, "otherBankCardType": null, "customerCommission": -1.0, "paymentsWithSundry": 1.0, "customerInvoiceDate": null, "factoryRebateAmount": 3.0, "isIncludeTaxFactory": 0, "supplierInvoiceDate": null, "customerInvoiceAmount": null, "factoryDiscountAmount": 4.0, "seaFreightCompanyPhone": null, "customerInvoiceTaxEntity": null}, {"id": null, "erro": 0.0, "fleet": null, "packs": 12, "price": -21.0, "width": 2440.0, "height": 5.0, "length": 3660.0, "params": {}, "pieces": 144, "profit": 25736.627, "remark": null, "userId": 1, "addtime": "2025-03-27 12:10:55", "freight": 17.075, "isAudit": null, "levelID": 5, "storeID": 20, "tonnage": -16.075, "comments": "5", "createBy": null, "customer": "张敏", "isAdjust": "-1", "ordersNo": "b48b256d-6c36-425f-9c9b-7450a07177c9", "payments": -1286.978, "supplier": "", "updateBy": null, "userName": "maolei", "carNumber": null, "levelName": "本溪玉晶一等品", "orderDate": "2025-03-27 12:09:00", "otherCost": 1.0, "adjustDate": null, "cancelFlag": 0, "createTime": null, "customerID": 5, "isAdjusted": "否", "seaFreight": 0.0, "sundryCost": -1.0, "supplierID": null, "updateTime": null, "driverPhone": null, "landFreight": -17.075, "profitNoTax": 25737.627, "actualPieces": 144, "countingUnit": "片", "salesManager": null, "storeHouseID": 1, "adjustOrderNo": "null", "invoiceAmount": null, "paymentUnload": 1.0, "piecesPerPack": 12, "additionalFees": 1.0, "paymentFactory": -27006.53, "storeHouseName": "测试仓库", "exWarehouseDate": "2025-03-27 12:10:55", "logisticsProfit": 1.0, "isIncludeTaxSale": 0, "landFreightPrice": -1.0, "seaFreightNumber": null, "selfBankCardType": null, "factoryCommission": 2.0, "otherBankCardType": null, "customerCommission": -1.0, "paymentsWithSundry": 1.0, "customerInvoiceDate": null, "factoryRebateAmount": 3.0, "isIncludeTaxFactory": 0, "supplierInvoiceDate": null, "customerInvoiceAmount": null, "factoryDiscountAmount": 4.0, "seaFreightCompanyPhone": null, "customerInvoiceTaxEntity": null}]',
					originalInfoId: null,
					changedInfo:
						'[{"id": null, "erro": 0.0, "fleet": null, "packs": 12, "price": -11.0, "width": 2440.0, "height": 5.0, "length": 3660.0, "params": {}, "pieces": 12, "profit": 1073.988, "remark": null, "userId": 1, "addtime": "2025-03-27 12:10:55", "freight": 2.34, "isAudit": null, "levelID": 5, "storeID": 20, "tonnage": -1.34, "comments": "5", "createBy": null, "customer": "张敏", "isAdjust": "-1", "ordersNo": "b48b256d-6c36-425f-9c9b-7450a07177c9", "payments": -108.165, "supplier": "", "updateBy": null, "userName": "maolei", "carNumber": null, "levelName": "本溪玉晶一等品", "orderDate": "2025-03-27 12:09:00", "otherCost": 1.0, "adjustDate": null, "cancelFlag": 0, "createTime": null, "customerID": 5, "isAdjusted": "否", "seaFreight": 0.0, "sundryCost": -1.0, "supplierID": null, "updateTime": null, "driverPhone": null, "landFreight": -2.34, "profitNoTax": 1074.988, "actualPieces": 12, "countingUnit": "片", "salesManager": null, "storeHouseID": 1, "adjustOrderNo": "null", "invoiceAmount": null, "paymentUnload": 1.0, "piecesPerPack": 1, "additionalFees": 1.0, "paymentFactory": -1179.813, "storeHouseName": "测试仓库", "exWarehouseDate": "2025-03-27 12:10:55", "logisticsProfit": 1.0, "isIncludeTaxSale": 0, "landFreightPrice": -1.0, "seaFreightNumber": null, "selfBankCardType": null, "factoryCommission": 2.0, "otherBankCardType": null, "customerCommission": -1.0, "paymentsWithSundry": 1.0, "customerInvoiceDate": null, "factoryRebateAmount": 3.0, "isIncludeTaxFactory": 0, "supplierInvoiceDate": null, "customerInvoiceAmount": null, "factoryDiscountAmount": 4.0, "seaFreightCompanyPhone": null, "customerInvoiceTaxEntity": null}, {"id": null, "erro": 0.0, "fleet": null, "packs": 12, "price": -21.0, "width": 2440.0, "height": 5.0, "length": 3660.0, "params": {}, "pieces": 144, "profit": 25736.627, "remark": null, "userId": 1, "addtime": "2025-03-27 12:10:55", "freight": 17.075, "isAudit": null, "levelID": 5, "storeID": 20, "tonnage": -16.075, "comments": "5", "createBy": null, "customer": "张敏", "isAdjust": "-1", "ordersNo": "b48b256d-6c36-425f-9c9b-7450a07177c9", "payments": -1286.978, "supplier": "", "updateBy": null, "userName": "maolei", "carNumber": null, "levelName": "本溪玉晶一等品", "orderDate": "2025-03-27 12:09:00", "otherCost": 1.0, "adjustDate": null, "cancelFlag": 0, "createTime": null, "customerID": 5, "isAdjusted": "否", "seaFreight": 0.0, "sundryCost": -1.0, "supplierID": null, "updateTime": null, "driverPhone": null, "landFreight": -17.075, "profitNoTax": 25737.627, "actualPieces": 144, "countingUnit": "片", "salesManager": null, "storeHouseID": 1, "adjustOrderNo": "null", "invoiceAmount": null, "paymentUnload": 1.0, "piecesPerPack": 12, "additionalFees": 1.0, "paymentFactory": -27006.53, "storeHouseName": "测试仓库", "exWarehouseDate": "2025-03-27 12:10:55", "logisticsProfit": 1.0, "isIncludeTaxSale": 0, "landFreightPrice": -1.0, "seaFreightNumber": null, "selfBankCardType": null, "factoryCommission": 2.0, "otherBankCardType": null, "customerCommission": -1.0, "paymentsWithSundry": 1.0, "customerInvoiceDate": null, "factoryRebateAmount": 3.0, "isIncludeTaxFactory": 0, "supplierInvoiceDate": null, "customerInvoiceAmount": null, "factoryDiscountAmount": 4.0, "seaFreightCompanyPhone": null, "customerInvoiceTaxEntity": null}]',
					logicBackupType: 'insert',
					uuid: 'f99ede5d-646e-421b-ae9b-eeb850ef0f1e',
					version: 1
				},
				{
					createBy: null,
					createTime: null,
					updateBy: null,
					updateTime: null,
					remark: null,
					selfBankCardType: null,
					otherBankCardType: null,
					id: 4318,
					tableName: 'orderdetail',
					backupTime: '2025-03-27 12:10:56',
					backupType: 'insert',
					backupUserTruename: 'maolei',
					backupUserId: 1,
					originalInfo:
						'[{"id": null, "erro": 0.0, "fleet": null, "packs": 12, "price": 11.0, "width": 2440.0, "height": 5.0, "length": 3660.0, "params": {}, "pieces": 12, "profit": -1073.988, "remark": null, "userId": 1, "addtime": "2025-03-27 12:10:55", "freight": 2.34, "isAudit": null, "levelID": 5, "storeID": 20, "tonnage": 1.34, "comments": "5", "createBy": null, "customer": "张敏", "isAdjust": "1", "ordersNo": "75deb396-c91c-4933-955e-4d4c65dca7bf", "payments": 108.165, "supplier": "", "updateBy": null, "userName": "maolei", "carNumber": null, "levelName": "本溪玉晶一等品", "orderDate": "2025-03-27 12:09:00", "otherCost": 1.0, "adjustDate": null, "cancelFlag": 0, "createTime": null, "customerID": 5, "isAdjusted": "否", "seaFreight": null, "sundryCost": 1.0, "supplierID": null, "updateTime": null, "driverPhone": null, "landFreight": 2.34, "profitNoTax": -1074.988, "actualPieces": 12, "countingUnit": "片", "salesManager": null, "storeHouseID": 1, "adjustOrderNo": "116", "invoiceAmount": null, "paymentUnload": 1.0, "piecesPerPack": 1, "additionalFees": 1.0, "paymentFactory": 1179.813, "storeHouseName": "测试仓库", "exWarehouseDate": "2025-03-27 12:10:55", "logisticsProfit": 1.0, "isIncludeTaxSale": 0, "landFreightPrice": 1.0, "seaFreightNumber": null, "selfBankCardType": null, "factoryCommission": 2.0, "otherBankCardType": null, "customerCommission": 1.0, "paymentsWithSundry": 1.0, "customerInvoiceDate": null, "factoryRebateAmount": 3.0, "isIncludeTaxFactory": 0, "supplierInvoiceDate": null, "customerInvoiceAmount": null, "factoryDiscountAmount": 4.0, "seaFreightCompanyPhone": null, "customerInvoiceTaxEntity": null}, {"id": null, "erro": 0.0, "fleet": null, "packs": 12, "price": 21.0, "width": 2440.0, "height": 5.0, "length": 3660.0, "params": {}, "pieces": 144, "profit": -25736.627, "remark": null, "userId": 1, "addtime": "2025-03-27 12:10:55", "freight": 17.075, "isAudit": null, "levelID": 5, "storeID": 20, "tonnage": 16.075, "comments": "5", "createBy": null, "customer": "张敏", "isAdjust": "1", "ordersNo": "75deb396-c91c-4933-955e-4d4c65dca7bf", "payments": 1286.978, "supplier": "", "updateBy": null, "userName": "maolei", "carNumber": null, "levelName": "本溪玉晶一等品", "orderDate": "2025-03-27 12:09:00", "otherCost": 1.0, "adjustDate": null, "cancelFlag": 0, "createTime": null, "customerID": 5, "isAdjusted": "否", "seaFreight": null, "sundryCost": 1.0, "supplierID": null, "updateTime": null, "driverPhone": null, "landFreight": 17.075, "profitNoTax": -25737.627, "actualPieces": 144, "countingUnit": "片", "salesManager": null, "storeHouseID": 1, "adjustOrderNo": "117", "invoiceAmount": null, "paymentUnload": 1.0, "piecesPerPack": 12, "additionalFees": 1.0, "paymentFactory": 27006.53, "storeHouseName": "测试仓库", "exWarehouseDate": "2025-03-27 12:10:55", "logisticsProfit": 1.0, "isIncludeTaxSale": 0, "landFreightPrice": 1.0, "seaFreightNumber": null, "selfBankCardType": null, "factoryCommission": 2.0, "otherBankCardType": null, "customerCommission": 1.0, "paymentsWithSundry": 1.0, "customerInvoiceDate": null, "factoryRebateAmount": 3.0, "isIncludeTaxFactory": 0, "supplierInvoiceDate": null, "customerInvoiceAmount": null, "factoryDiscountAmount": 4.0, "seaFreightCompanyPhone": null, "customerInvoiceTaxEntity": null}]',
					originalInfoId: null,
					changedInfo:
						'[{"id": null, "erro": 0.0, "fleet": null, "packs": 12, "price": 11.0, "width": 2440.0, "height": 5.0, "length": 3660.0, "params": {}, "pieces": 12, "profit": -1073.988, "remark": null, "userId": 1, "addtime": "2025-03-27 12:10:55", "freight": 2.34, "isAudit": null, "levelID": 5, "storeID": 20, "tonnage": 1.34, "comments": "5", "createBy": null, "customer": "张敏", "isAdjust": "1", "ordersNo": "75deb396-c91c-4933-955e-4d4c65dca7bf", "payments": 108.165, "supplier": "", "updateBy": null, "userName": "maolei", "carNumber": null, "levelName": "本溪玉晶一等品", "orderDate": "2025-03-27 12:09:00", "otherCost": 1.0, "adjustDate": null, "cancelFlag": 0, "createTime": null, "customerID": 5, "isAdjusted": "否", "seaFreight": null, "sundryCost": 1.0, "supplierID": null, "updateTime": null, "driverPhone": null, "landFreight": 2.34, "profitNoTax": -1074.988, "actualPieces": 12, "countingUnit": "片", "salesManager": null, "storeHouseID": 1, "adjustOrderNo": "116", "invoiceAmount": null, "paymentUnload": 1.0, "piecesPerPack": 1, "additionalFees": 1.0, "paymentFactory": 1179.813, "storeHouseName": "测试仓库", "exWarehouseDate": "2025-03-27 12:10:55", "logisticsProfit": 1.0, "isIncludeTaxSale": 0, "landFreightPrice": 1.0, "seaFreightNumber": null, "selfBankCardType": null, "factoryCommission": 2.0, "otherBankCardType": null, "customerCommission": 1.0, "paymentsWithSundry": 1.0, "customerInvoiceDate": null, "factoryRebateAmount": 3.0, "isIncludeTaxFactory": 0, "supplierInvoiceDate": null, "customerInvoiceAmount": null, "factoryDiscountAmount": 4.0, "seaFreightCompanyPhone": null, "customerInvoiceTaxEntity": null}, {"id": null, "erro": 0.0, "fleet": null, "packs": 12, "price": 21.0, "width": 2440.0, "height": 5.0, "length": 3660.0, "params": {}, "pieces": 144, "profit": -25736.627, "remark": null, "userId": 1, "addtime": "2025-03-27 12:10:55", "freight": 17.075, "isAudit": null, "levelID": 5, "storeID": 20, "tonnage": 16.075, "comments": "5", "createBy": null, "customer": "张敏", "isAdjust": "1", "ordersNo": "75deb396-c91c-4933-955e-4d4c65dca7bf", "payments": 1286.978, "supplier": "", "updateBy": null, "userName": "maolei", "carNumber": null, "levelName": "本溪玉晶一等品", "orderDate": "2025-03-27 12:09:00", "otherCost": 1.0, "adjustDate": null, "cancelFlag": 0, "createTime": null, "customerID": 5, "isAdjusted": "否", "seaFreight": null, "sundryCost": 1.0, "supplierID": null, "updateTime": null, "driverPhone": null, "landFreight": 17.075, "profitNoTax": -25737.627, "actualPieces": 144, "countingUnit": "片", "salesManager": null, "storeHouseID": 1, "adjustOrderNo": "117", "invoiceAmount": null, "paymentUnload": 1.0, "piecesPerPack": 12, "additionalFees": 1.0, "paymentFactory": 27006.53, "storeHouseName": "测试仓库", "exWarehouseDate": "2025-03-27 12:10:55", "logisticsProfit": 1.0, "isIncludeTaxSale": 0, "landFreightPrice": 1.0, "seaFreightNumber": null, "selfBankCardType": null, "factoryCommission": 2.0, "otherBankCardType": null, "customerCommission": 1.0, "paymentsWithSundry": 1.0, "customerInvoiceDate": null, "factoryRebateAmount": 3.0, "isIncludeTaxFactory": 0, "supplierInvoiceDate": null, "customerInvoiceAmount": null, "factoryDiscountAmount": 4.0, "seaFreightCompanyPhone": null, "customerInvoiceTaxEntity": null}]',
					logicBackupType: 'insert',
					uuid: 'f99ede5d-646e-421b-ae9b-eeb850ef0f1e',
					version: 1
				}
			]
		},
		// 哪些字段需要算钱 仅仅高亮这些行 v-for row in rows  if row.key === 'payment'
		params: [
			{
				name: 'payment',
				label: '总货款',
				option: function (item, callback) {
					return callback(item);
				}
			},
			{
				name: 'paymentFactory',
				label: '出厂货款'
			}
		],
		// 额外需要处理的字段
		extraParams: [
			{
				name: 'otherBankCardType',
				label: '其他银行卡类型'
			}
		],
		extraInfo: {
			_: ''
		}
	}
};
