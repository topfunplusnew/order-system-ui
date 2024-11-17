import request from '@/utils/request'

// 查询订单详情列表
export function listOrderDetail(query) {
  return request({
    url: '/system/orderDetail/list',
    method: 'get',
    params: query
  })
}

// 查询订单详情详细
export function getOrderDetail(id) {
  return request({
    url: '/system/orderDetail/' + id,
    method: 'get'
  })
}

// 新增订单详情
export function addOrderDetail(data) {
  return request({
    url: '/system/orderDetail',
    method: 'post',
    data: data
  })
}

// 修改订单详情
export function updateOrderDetail(data) {
  return request({
    url: '/system/orderDetail',
    method: 'put',
    data: data
  })
}

// 删除订单详情
export function delOrderDetail(id) {
  return request({
    url: '/system/orderDetail/' + id,
    method: 'delete'
  })
}

// 不分页查询订单详情列表
export function listOrderDetailNoPage(query) {
  return request({
    url: '/system/orderDetail/nopage/list',
    method: 'get',
    params: query
  })
}

// 批量查询订单详情
export function listOrderDetailByIds(query) {
  return request({
    url: '/system/orderDetail/batchList',
    method: 'get',
    params: query
  })
}
