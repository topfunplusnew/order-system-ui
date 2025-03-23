import { describe, expect, test } from '@jest/globals';
import { keyOptioner, paramFieldFilter, typeFilter } from '@/views/dashboard/backuplog/goodsorder/index';

// 测试JSON的key转换
describe('keyOptioner module', () => {
	const json = {
		name: 'zhangsan',
		age: 18,
		id: 1,
		order_id: 100,
		pay_id: 1,
		id_index: 1
	};

	const json1 = {
		name: 'zhangsan',
		age: 18,
		pay_id: 1,
		id_index: 1,
		order_id_id: 100
	};

	test('json', () => {
		expect(paramFieldFilter([json, json1])).toEqual([
			{
				name: 'zhangsan',
				age: 18
			},
			{
				name: 'zhangsan',
				age: 18
			}
		]);
	});
});

// 测试typeFilter
describe('typeFilter module', () => {
	const obj = {
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3432,
		tableName: 'inventory_detail',
		backupTime: '2025-03-23 16:32:56',
		backupType: 'insert',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo: 'null',
		originalInfoId: null,
		changedInfo:
			'[{"id": null, "erro": 0, "packs": 10, "price": 12, "width": 2740, "height": 5, "length": 3660, "mainId": 10, "params": {}, "pieces": 100, "profit": -1128.15, "remark": null, "addtime": "2025-03-23 16:32:56", "delFlag": 0, "freight": 1128.15, "levelID": 7, "tonnage": 12.535, "comments": "4", "createBy": null, "payments": "12034.080", "supplier": "测试供应商", "updateBy": null, "levelName": "本溪玉晶一等品", "otherCost": 0, "storeDate": "2025-03-19 16:32:06", "createTime": null, "seaFreight": null, "sundryCost": 0, "supplierId": 1, "updateTime": null, "landFreight": 1128.15, "profitNoTax": -1338.116, "stockNumber": 100, "actualPieces": 100, "countingUnit": "片", "storeHouseid": null, "exWareHoustId": null, "paymentUnload": 12, "piecesPerPack": 10, "additionalFees": 0, "paymentFactory": 12034.08, "storeHouseName": null, "isIncludeTaxSale": 1, "landFreightPrice": 90, "selfBankCardType": null, "factoryCommission": 1, "otherBankCardType": null, "customerCommission": null, "paymentsWithSundry": 0, "factoryRebateAmount": 2, "isIncludeTaxFactory": 1, "factoryDiscountAmount": 3}]',
		logicBackupType: 'insert',
		uuid: '4f6a6b04-d613-4bc4-8b51-17d5229c8f68',
		version: 1
	};
	test('typeFilter', () => {
		expect(typeFilter(obj)).toEqual({
			createBy: null,
			createTime: null,
			updateBy: null,
			updateTime: null,
			remark: null,
			selfBankCardType: null,
			otherBankCardType: null,
			id: 3432,
			tableName: 'inventory_detail',
			backupTime: '2025-03-23 16:32:56',
			backupType: 'insert',
			backupUserTruename: 'maolei',
			backupUserId: 1,
			originalInfo:
				'[{"id": null, "erro": 0, "packs": 10, "price": 12, "width": 2740, "height": 5, "length": 3660, "mainId": 10, "params": {}, "pieces": 100, "profit": -1128.15, "remark": null, "addtime": "2025-03-23 16:32:56", "delFlag": 0, "freight": 1128.15, "levelID": 7, "tonnage": 12.535, "comments": "4", "createBy": null, "payments": "12034.080", "supplier": "测试供应商", "updateBy": null, "levelName": "本溪玉晶一等品", "otherCost": 0, "storeDate": "2025-03-19 16:32:06", "createTime": null, "seaFreight": null, "sundryCost": 0, "supplierId": 1, "updateTime": null, "landFreight": 1128.15, "profitNoTax": -1338.116, "stockNumber": 100, "actualPieces": 100, "countingUnit": "片", "storeHouseid": null, "exWareHoustId": null, "paymentUnload": 12, "piecesPerPack": 10, "additionalFees": 0, "paymentFactory": 12034.08, "storeHouseName": null, "isIncludeTaxSale": 1, "landFreightPrice": 90, "selfBankCardType": null, "factoryCommission": 1, "otherBankCardType": null, "customerCommission": null, "paymentsWithSundry": 0, "factoryRebateAmount": 2, "isIncludeTaxFactory": 1, "factoryDiscountAmount": 3}]',
			originalInfoId: null,
			changedInfo:
				'[{"id": null, "erro": 0, "packs": 10, "price": 12, "width": 2740, "height": 5, "length": 3660, "mainId": 10, "params": {}, "pieces": 100, "profit": -1128.15, "remark": null, "addtime": "2025-03-23 16:32:56", "delFlag": 0, "freight": 1128.15, "levelID": 7, "tonnage": 12.535, "comments": "4", "createBy": null, "payments": "12034.080", "supplier": "测试供应商", "updateBy": null, "levelName": "本溪玉晶一等品", "otherCost": 0, "storeDate": "2025-03-19 16:32:06", "createTime": null, "seaFreight": null, "sundryCost": 0, "supplierId": 1, "updateTime": null, "landFreight": 1128.15, "profitNoTax": -1338.116, "stockNumber": 100, "actualPieces": 100, "countingUnit": "片", "storeHouseid": null, "exWareHoustId": null, "paymentUnload": 12, "piecesPerPack": 10, "additionalFees": 0, "paymentFactory": 12034.08, "storeHouseName": null, "isIncludeTaxSale": 1, "landFreightPrice": 90, "selfBankCardType": null, "factoryCommission": 1, "otherBankCardType": null, "customerCommission": null, "paymentsWithSundry": 0, "factoryRebateAmount": 2, "isIncludeTaxFactory": 1, "factoryDiscountAmount": 3}]',
			logicBackupType: 'insert',
			uuid: '4f6a6b04-d613-4bc4-8b51-17d5229c8f68',
			version: 1
		});
	});
});
