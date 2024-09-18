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
