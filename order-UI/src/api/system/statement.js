// 报表
import request from "@/utils/request";

// 运费报表
export function getOrderFreight(query) {
  return request({
    url: '/statistics/orderfreightsummary',
    method: 'get',
    params: query
  })
}

// 社保和公积金缴纳金额
export function getSocialInsuranceSummary(query) {
  return request({
    url: '/statistics/socialinsurancesummary',
    method: 'get',
    params: query
  })
}

// 员工或外面公司在我公司借款管理台账 / 期货保证金台账
export function getLendMoneySummary(query) {
  return request({
    url: '/statistics/lendMoneysummary',
    method: 'get',
    params: query
  })
}

export function getLendMoneySummary2(query) {
  return request({
    url: '/statistics/lendMoneysummary2',
    method: 'get',
    params: query
  })
}

// 运费科目总台账
export function getOrderFreightDetailSummary(query) {
  return request({
    url: '/statistics/orderfreightDetailsummary',
    method: 'get',
    params: query
  })
}

// 客户报表
export function getCompanySummary(query) {
  return request({
    url: '/statistics/companysummary',
    method: 'get',
    params: query
  })
}

// 供应商报表
export function getSupplierSuymmary(query) {
  return request({
    url: '/statistics/suppliersuymmary',
    method: 'get',
    params: query
  })
}

// 贷款管理台账
export function getBorrowedMoneySummary(query) {
  return request({
    url: '/statistics/borrowedMoneySummary',
    method: 'get',
    params: query
  })
}


// 费用科目汇总
export function getSubjectSummary(query) {
  return request({
    url: '/statistics/subjectsummary',
    method: 'get',
    params: query
  })
}

// 获取发货列表
export function getDeliveryList(query) {
  return request({
    url: '/statistics/getTodayOrderList',
    method: 'get',
    params: query
  })
}

// 资金日报表
export function getBankAcountChange(query) {
  return request({
    url: '/statistics/bankAcountChangeSummary',
    method: 'get',
    params: query
  })
}

// 获取客户每日发货次数
export function getDailyOrderCount(query) {
  return request({
    url: 'statistics/dailyOrderCount',
    method: 'get',
    params: query
  })
}


// 获取车队运费报表
export function getFleetFreightSummary(query) {
  return request({
    url: '/statistics/fleetfreightsummary',
    method: 'get',
    params: query
  })
}

// 获取运费报表明细表
export function getFreightSubjectDetailSummary(query) {
  return request({
    url: '/statistics/orderfreightDetail',
    method: 'get',
    params: query
  })
}

// 客户科目余额汇总表
export function getCustomerSubjectSummary(query) {
  return request({
    url: '/statistics/companydetailsummary',
    method: 'get',
    params: query
  })
}

//客户科目余额汇总表 明细表
export function getCustomerSubjectDetailSummary(query) {
  return request({
    url: '/statistics/companydetail',
    method: 'get',
    params: query
  })
}

// 查询客户科目明细账指定时间结转
export function getCustomerSubjectDetailSomeDay(query) {
  return request({
    url: '/statistics/companydetailBalanceInLocalCurrencyAtDate',
    method: 'get',
    params: query
  })
}
