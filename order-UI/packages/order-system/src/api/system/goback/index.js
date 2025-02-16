import service from '@/utils/request';

// 往来管理的客户的相关查询
export class QueryCustomer {
	prefix = '/statistics/';

	/**
	 * 查询参数对象
	 * @typedef {Object} QueryParams
	 * @property {string} endTime - 日期字符串，格式为 "年月日"（例如：2025-02-16）。
	 * @property {string} companyId - 客户ID。
	 * @property {string} balanceCompare - 比较符号，支持 "eq"（等于）、"lt"（小于）、"gt"（大于）。
	 * @property {number} balanceValue - 账户余额金额。
	 * @return {Promise<any>} - 返回一个 Promise 对象，用于处理异步请求结果。
	 */
	getCompanySummaryAndLastOrderTime(QueryParams) {
		return service({
			url: this.prefix + 'companysummaryandlastordertime',
			method: 'get',
			params: QueryParams
		});
	}
}
