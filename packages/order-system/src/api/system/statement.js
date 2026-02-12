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
export function getTodaySupplierSummary(query) {
	return request({
		url: '/statistics/todaysuppliersuymmary',
		method: 'get',
		params: query
	});
}

/**
 * 客户当日发生业务统计表
 * @param {Object} query
 * @param  {endTime} query.endTime - 结束日期
 * @returns
 */
export function getTodayCustomerSummary(query) {
	return request({
		url: '/statistics/todaycompanysummary',
		method: 'get',
		params: query
	});
}

/**
 * 运费当日发生业务统计表
 * @param {Object} query
 * @param  {endTime} query.endTime - 结束日期
 * @returns
 */
export function getTodayFreightSummary(query) {
	return request({
		url: '/statistics/todayorderfreightsummary',
		method: 'get',
		params: query
	});
}

/**
 * 银行卡资金变动情况
 * @param {Object} query
 * @returns
 */
export function getBankCardChangeSummary(query) {
	return request({
		url: '/system/bankAccountChange/list',
		method: 'get',
		params: query
	});
}

/**
 * 资金统计（获取指定日期的资金汇总数据）
 * @param {Object} query - 查询参数
 * @param {string} query.endTime - 统计日期，格式 yyyy-MM-dd
 * @returns {Promise<Object>} 响应结构 { msg, code, data }
 * @returns {string} return.msg - 提示信息
 * @returns {number} return.code - 状态码，200 表示成功
 * @returns {Object} return.data - 资金汇总数据
 * @returns {number} return.data.companyTotalBalance - 客户欠款合计数（①）
 * @returns {number} return.data.supplierTotalBalance - 欠厂家货款（③）
 * @returns {number} return.data.companyTotalInvoiceAmount - 客户票点合计
 * @returns {number} return.data.supplierTotalInvoiceAmount - 供应商票点合计
 * @returns {number} return.data.driverUnpaidAmount - 未支付运费合计（④）
 * @returns {number} return.data.selfCompanyTotalFunds - 所有银行卡资金合计（②）
 * @returns {number} return.data.loanBalance - 公司从外面借款合计（⑨）
 * @returns {number} return.data.futuresMarginBalance - 期货保证金（⑥）
 * @returns {number} return.data.loanFromCompany - 其他应收-个人/公司从公司借款（⑤）
 * @returns {number} return.data.paymentMarginBalance - 厂家保证金（⑦）
 * @returns {number} return.data.receiveMarginBalance - 收取保证金（⑧）
 * @returns {number} return.data.remainingInventoryAmount - 库存金额（⓪）
 */
export function getMoneySummary(query) {
	return request({
		url: '/statistics/getallmoney',
		method: 'get',
		params: query
	});
}

/**
 * 资金变动统计(数据截取版)
 * @param {Object} query
 * @param {string} query.startTime - 开始时间
 * @param {string} query.endTime - 结束时间
 * @returns
 */
export function getMoneyChangeSummary(query) {
	return request({
		url: '/statistics/getallmoneychange',
		method: 'get',
		params: query
	});
}

/**
 * 资金变动统计(数据变动版)
 * @param {Object} query
 * @param {string} query.startTime - 开始时间
 * @param {string} query.endTime - 结束时间
 * @returns
 */
export function getMoneyChangeSummaryByDate(query) {
	return request({
		url: '/system/allmoneybacklog/getInfoByDate/',
		method: 'get',
		params: query
	});
}

/**
 * 资金变动模块根据模块名获取数据
 * @param {Object} query
 * @param {string} query.variableName - 资金变动中的变量名
 * @param {string} query.backupDate - 年月日字符串，想要看的那一天（后端是实际上会返回制定日期+前N天的数据，N为数据固定时间）
 * @param {string} query.firstTargetDate - 第一个,页面上左侧的日期,示意图上的B
 * @param {string} query.secondTargetDate - 第二个,页面上右侧的日期,示意图上的C
 */
export function getBackupInfoV1(query) {
	return request({
		url: '/system/backuplog/getBackupInfoV1',
		method: 'get',
		params: query
	});
}

/**
 * 资金变动模块根据模块名获取数据
 * @param {Object} query
 * @param {string} query.variableName - 资金变动中的变量名
 * @param {string} query.backupDate - 年月日字符串，想要看的那一天（后端是实际上会返回制定日期+前N天的数据，N为数据固定时间）
 * @param {string} query.firstTargetDate - 第一个,页面上左侧的日期,示意图上的B
 * @param {string} query.secondTargetDate - 第二个,页面上右侧的日期,示意图上的C
 */
export function getBackupInfoV2(query) {
	return request({
		url: '/system/backuplog/getBackupInfoV2',
		method: 'get',
		params: query
	});
}

/**
 * 获取每日利润
 * @param {Object} query
 * @param {string} query.endTime - 结束时间
 * @returns
 */
export function getDailyProfit(query) {
	return request({
		url: '/statistics/getHomeProfitExpenseTotal',
		method: 'get',
		params: query
	});
}

/**
 * 获取原系统日常申请费用付款表
 * @param {Object} query
 * @param {string} query.endTime - 结束时间
 * @returns
 */
export function getDailyExpenseReports(query) {
	return request({
		url: '/statistics/selectDailyExpenseReportsByDate',
		method: 'get',
		params: query
	});
}

/**
 * 费用支出单据列表（按日期）
 * @param {Object} query
 * @returns
 */
export function getExpensePaymentFormsByDate(query) {
	return request({
		url: '/statistics/selectExpensePaymentFormsByDate',
		method: 'get',
		params: query
	});
}

/**
 * 原系统数据统计模块的数据统计页面
 * @param {Object} query
 * @param {string} query.date - 结束时间
 * @returns
 */
export function getOrderSystemData(query) {
	return request({
		url: '/statistics/getSystemMultiDimensionData',
		method: 'get',
		params: query
	});
}

/**
 * 额外报表，本日应当利润
 * @param {Object} query
 * @param {string} query.date - 结束时间
 * @returns
 */
export function getDailyProfitStatistics(query) {
	return request({
		url: '/statistics/getDailyProfitStatistics',
		method: 'get',
		params: query
	});
}

export function getFundFlowDetailList(query) {
	return request({
		url: 'statistics/getFundFlowDetailList',
		method: 'get',
		params: query
	});
}

// /statistics/findFundFlowBalanceInLocalCurrencyAtDate
export function findFundFlowBalanceInLocalCurrencyAtDate(query) {
	return request({
		url: 'statistics/findFundFlowBalanceInLocalCurrencyAtDate',
		method: 'get',
		params: query
	});
}

/**
 * 内部资金往来统计
 * @param {Object} query
 * @param {string} query.payerCompanyAccount - 付款方公司账户
 * @param {string} query.beneficiaryCompanyAccount - 收款方公司账户
 * @param {number} query.pageNum - 分页页码
 * @returns
 */
export function getInternalFundsSummary(query) {
	return request({
		url: '/statistics/InternalFundsSummary',
		method: 'get',
		params: query
	});
}

/**
 * 获取可选择的时间下拉列表
 * @param {string} backupDate - 备份日期
 * @returns
 */
export function getTargetDates(backupDate) {
	return request({
		url: `/system/allmoneybacklog/targetDates/${backupDate}`,
		method: 'get'
	});
}

// ========== 资金变动统计 v3 接口 ==========

/**
 * 计算时间段内资金变动（三层Map）
 * @param {Object} query
 * @param {string} query.backupDate - 备份目标日期
 * @param {string} query.firstTargetDate - 查询起始日期
 * @param {string} query.secondTargetDate - 查询结束日期
 * @returns {Promise<{data: Object}>} data 结构为 Map<outputKey, Map<tableName, Map<category, amount>>>
 */
export function calculateAmountsV3(query) {
	return request({
		url: '/system/backuplog/v3/calculateAmounts',
		method: 'get',
		params: query
	});
}

/**
 * 根据三层分类筛选日志ID
 * @param {Object} query
 * @param {string} query.outputKey - 一级分类（如 remainingInventoryAmount）
 * @param {string} query.tableName - 二级分类（如 inventory_main）
 * @param {string} query.category - 三级分类（如 default）
 * @param {string} query.backupDate - 备份目标日期
 * @param {string} query.firstTargetDate - 查询起始日期
 * @param {string} query.secondTargetDate - 查询结束日期
 * @returns {Promise<{data: number[]}>}
 */
export function filterIdsByCategoryV3(query) {
	return request({
		url: '/system/backuplog/v3/filterIdsByCategory',
		method: 'get',
		params: query
	});
}

/**
 * 根据ID列表查询日志详情
 * @param {Object} body
 * @param {number[]} body.ids - 备份日志ID列表
 * @returns {Promise<{data: Array}>} 每条含 originalInfo、changedInfo、tableName 等
 */
export function getBackuplogByIdsV3(body) {
	return request({
		url: '/system/backuplog/v3/getByIds',
		method: 'post',
		data: body
	});
}

/**
 * 根据ID列表计算资金变动（底部小表格）
 * @param {Object} body
 * @param {number[]} body.ids - 备份日志ID列表
 * @returns {Promise<{data: Object}>}
 */
export function calculateByIdsV3(body) {
	return request({
		url: '/system/backuplog/v3/calculateByIds',
		method: 'post',
		data: body
	});
}
