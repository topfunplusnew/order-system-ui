// 报表
import request from '@/utils/request';

// 运费报表
export function getOrderFreight(query) {
	return request({
		url: '/statistics/orderfreightsummary',
		method: 'get',
		params: query
	});
}

// 社保和公积金缴纳金额
export function getSocialInsuranceSummary(query) {
	return request({
		url: '/statistics/socialinsurancesummary',
		method: 'get',
		params: query
	});
}

// 员工或外面公司在我公司借款管理台账 / 期货保证金台账
export function getLendMoneySummary(query) {
	return request({
		url: '/statistics/lendMoneysummary',
		method: 'get',
		params: query
	});
}

export function getLendMoneySummary2(query) {
	return request({
		url: '/statistics/lendMoneysummary2',
		method: 'get',
		params: query
	});
}

// 客户报表
export function getCompanySummary(query) {
	return request({
		url: '/statistics/companysummary',
		method: 'get',
		params: query
	});
}

// 供应商报表
export function getSupplierSuymmary(query) {
	return request({
		url: '/statistics/suppliersuymmary',
		method: 'get',
		params: query
	});
}

// 贷款管理台账
export function getBorrowedMoneySummary(query) {
	return request({
		url: '/statistics/borrowedMoneySummary',
		method: 'get',
		params: query
	});
}

// 费用科目汇总
export function getSubjectSummary(query) {
	return request({
		url: '/statistics/subjectsummary',
		method: 'get',
		params: query
	});
}

// 获取发货列表
export function getDeliveryList(query) {
	return request({
		url: '/statistics/getTodayOrderList',
		method: 'get',
		params: query
	});
}

// 资金日报表
export function getBankAcountChange(query) {
	return request({
		url: '/statistics/bankAcountChangeSummary',
		method: 'get',
		params: query
	});
}

// 获取客户每日发货次数
export function getDailyOrderCount(query) {
	return request({
		url: 'statistics/dailyOrderCount',
		method: 'get',
		params: query
	});
}

// 获取车队运费报表
export function getFleetFreightSummary(query) {
	return request({
		url: '/statistics/fleetfreightsummary',
		method: 'get',
		params: query
	});
}

/**
 * 客户科目余额汇总表
 * @param {Object} query
 * @param {string} query.beginTime - 开始时间
 * @param {string} query.endTime - 结束时间
 * @param {string} query.companyName - 公司名称
 * @returns
 */
export function getCustomerSubjectSummary(query) {
	return request({
		url: '/statistics/companydetailsummary',
		method: 'get',
		params: query
	});
}

/**
 * 客户科目余额汇总表 明细表
 * @param {Object} query
 * @param {string} query.beginTime - 开始时间
 * @param {string} query.endTime - 结束时间
 * @param {number} query.companyId - 公司ID
 * @returns
 */
export function getCustomerSubjectDetailSummary(query) {
	return request({
		url: '/statistics/companydetail',
		method: 'get',
		params: query
	});
}

/**
 * 查询客户科目明细账指定时间结转
 * @param {Object} query
 * @param {string} query.beginTime - 开始时间
 * @param {number} query.companyId - 公司ID
 * @returns
 */
export function getCustomerSubjectDetailSomeDay(query) {
	return request({
		url: '/statistics/companydetailBalanceInLocalCurrencyAtDate',
		method: 'get',
		params: query
	});
}

/**
 * 查询客户五个字段
 * @param {number} companyId - 公司ID
 */
export function getCustomerFiveParams(companyId) {
	return request({
		url: '/statistics/companydetailfinancialsummary/' + companyId,
		method: 'get'
	});
}

/**
 * 查询供应商科目汇总账
 * @param {Object} query
 * @param {string} query.beginTime - 开始时间
 * @param {string} query.endTime - 结束时间
 * @param {string} query.companyName - 公司名称
 * @returns
 */
export function getSupplierSubjectSummary(query) {
	return request({
		url: '/statistics/supplierdetailsummary',
		method: 'get',
		params: query
	});
}

/**
 * 查询供应商明细账
 * @param {Object} query
 * @param {string} query.beginTime - 开始时间
 * @param {string} query.endTime - 结束时间
 * @param {number} query.companyId - 公司ID
 * @returns
 */
export function getSupplierSubjectDetailSummary(query) {
	return request({
		url: '/statistics/supplierdetail',
		method: 'get',
		params: query
	});
}

/**
 * 供应商供应商科目明细账指定时间结转
 * @param {Object} query
 * @param {string} query.beginTime - 开始时间
 * @param {number} query.companyId - 公司ID
 * @returns
 */
export function getSupplierSubjectDetailSomeDay(query) {
	return request({
		url: '/statistics/supplierdetailBalanceInLocalCurrencyAtDate',
		method: 'get',
		params: query
	});
}

/**
 * 获取运费科目总台账
 * @param {Object} query - 查询参数
 * @param {string} query.beginTime - 开始时间
 * @param {string} query.endTime - 结束时间
 * @param {string} query.carNo - 车牌号或车辆编号
 * @param {boolean} query.isSea - 是否为海运
 * @returns {Promise<Object>} - 返回一个包含账单数据的 Promise 对象
 */
export function getOrderFreightDetailSummary(query) {
	return request({
		url: '/statistics/freightDetailsummary',
		method: 'get',
		params: query
	});
}

/**
 * 某个车牌的运费科目汇总账
 * @param {Object} query
 * @param {id} query.carId - companyId
 * @param {string} query.beginTime - 开始时间
 * @param {string} query.endTime - 结束时间
 * @returns
 */
export function getFreightSubjectDetailSummary(query) {
	return request({
		url: '/statistics/freightDetail',
		method: 'get',
		params: query
	});
}

/**
 * 查询某个车牌指定日期结转的科目账
 * @param {Object} query
 * @param {id} query.carId - companyId
 * @param {string} query.beginTime - 结束时间
 * @returns
 */
export function getFreightSubjectDetailSummarySomeDay(query) {
	return request({
		url: '/statistics/freightdetailBalanceInLocalCurrencyAtDate',
		method: 'get',
		params: query
	});
}

/**
 * 油卡消费信息明细表
 * @param {Object} query
 * @param {startTime} query.startTime - 开始时间
 * @param {endTime} query.endTime - 结束时间
 * @returns
 */
export function getOilCardDetailSummary(query) {
	return request({
		url: '/system/oilCard/OilCardBalanceDetail',
		method: 'get',
		params: query
	});
}

/**
 * 油卡消费信息明细表
 * @param {Object} query
 * @param {startTime} query.carNo - 车牌号
 * @param  {startTime} query.applyUser - 申请人
 * @param {startTime} query.startTime - 开始时间
 * @param  {startTime} query.endTime - 结束时间
 * @param {startTime} query.cashRefuelingFrequency - 现金加油次数
 * @param {startTime} query.cashRefueling - 现金加油金额
 * @returns
 */
export function cashOilCardSummary(query) {
	return request({
		url: '/system/carApply/cashRefuelingLedger',
		method: 'get',
		params: query
	});
}

export function inventorySummary(query) {
	return request({
		url: '/system/inventoryMain/totalStock',
		method: 'get',
		params: query
	});
}

/**
 * 资金日报表
 * @param {Object} query
 * @param {beginTime} query.beginTime - 开始日期
 * @param  {endTime} query.endTime - 结束日期
 * @returns
 */
export function getTodaySelfCompanyMoneySummary(query) {
	return request({
		url: '/statistics/getTodaySelfCompanyMoneySummary',
		method: 'get',
		params: query
	});
}

/**
 * 供应商当日发生业务统计表
 * @param {Object} query
 * @param  {endTime} query.endTime - 结束日期
 * @returns
 */
export function getTodaySupplierSummary() {
	return request({
		url: '/statistics/todaysuppliersuymmary',
		method: 'get'
	});
}

/**
 * 客户当日发生业务统计表
 * @param {Object} query
 * @param  {endTime} query.endTime - 结束日期
 * @returns
 */
export function getTodayCustomerSummary() {
	return request({
		url: '/statistics/todaycompanysummary',
		method: 'get'
	});
}

/**
 * 运费当日发生业务统计表
 * @param {Object} query
 * @param  {endTime} query.endTime - 结束日期
 * @returns
 */
export function getTodayFreightSummary() {
	return request({
		url: '/statistics/todaycompanysummary',
		method: 'get'
	});
}
