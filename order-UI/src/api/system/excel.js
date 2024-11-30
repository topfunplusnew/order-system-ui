// excel批量开发票接口

import request from '@/utils/request';

/**
 * 批量开发票 可以混合卖出和买入
 * [
 *   {
 *     "invoiceDate": "2024-07-27",
 *     "invoiceObject": "山东省某科技有限公司",
 *     "invoiceAmount": 250000.00,
 *     "companyType": "客户",
 *     "companyName": "青岛某机械设备有限公司",
 *     "companyID": 4,
 *     "invoiceCompanyName": "青岛某机械设备有限公司",
 *     "ticketPoint": 0.08,
 *     "ticketPointAmount": 20000.00,
 *     "isOrderTax": 1,
 *     "comments": "本次发票用于机械设备销售",
 *     "params": {
 *       "uuid": "e8f7c620-9f9e-4bcf-9b5f-5978a99cc905",
 *       "tableName": "invoicein"
 *     }
 *   },
 *   {
 *     "invoiceDate": "2024-07-30",
 *     "invoiceObject": "山东省某电子科技有限公司",
 *     "invoiceAmount": 189654.32,
 *     "companyType": "客户",
 *     "companyName": "济南某信息技术有限公司",
 *     "companyID": 5,
 *     "invoiceCompanyName": "济南某信息技术有限公司",
 *     "ticketPoint": 0.07,
 *     "ticketPointAmount": 13275.80,
 *     "isOrderTax": 1,
 *     "comments": "本次发票用于电子设备销售",
 *     "params": {
 *       "uuid": "bc36e013-34cd-4e02-b5b0-31c66067e02d",
 *       "tableName": "invoiceout"
 *     }
 *   },
 * ]
 * @returns {*}
 * @param data
 */
export function batchInvoice(data) {
	return request({
		url: '/system/allinvoice/batch',
		method: 'post',
		data: data
	});
}
