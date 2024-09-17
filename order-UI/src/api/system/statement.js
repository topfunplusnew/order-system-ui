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
