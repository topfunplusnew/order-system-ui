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

