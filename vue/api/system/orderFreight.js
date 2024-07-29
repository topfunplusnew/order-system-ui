import request from '@/utils/request'

// 查询订单运费列表
export function listOrderFreight(query) {
  return request({
    url: '/system/orderFreight/list',
    method: 'get',
    params: query
  })
}

// 查询订单运费详细
export function getOrderFreight(id) {
  return request({
    url: '/system/orderFreight/' + id,
    method: 'get'
  })
}

// 新增订单运费
export function addOrderFreight(data) {
  return request({
    url: '/system/orderFreight',
    method: 'post',
    data: data
  })
}

// 修改订单运费
export function updateOrderFreight(data) {
  return request({
    url: '/system/orderFreight',
    method: 'put',
    data: data
  })
}

// 删除订单运费
export function delOrderFreight(id) {
  return request({
    url: '/system/orderFreight/' + id,
    method: 'delete'
  })
}
