import request from "../../utils/request";


// 检查类型
export const INFO_TYPE = Object.freeze({
  // 客户 供应商 司机
  CUSTOMER: 'customer',
  SUPPLIER: 'supplier',
  DRIVER: 'driver'
})

/**
 * type id
 * @param query
 * @returns {*}
 */
export function isUsed(query) {
  return request({
    url: '/isused',
    method: 'get',
    params: query
  })
}
