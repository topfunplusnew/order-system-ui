import request from "../../../utils/request.js";

// 查询订单运费信息列表
export function listOrderfreight(query) {
  return request({
    url: '/system/orderfreight/list',
    method: 'get',
    params: query
  })
}

// 查询订单运费信息详细
export function getOrderfreight(id) {
  return request({
    url: '/system/orderfreight/' + id,
    method: 'get'
  })
}

// 新增订单运费信息
export function addOrderfreight(data) {
  return request({
    url: '/system/orderfreight',
    method: 'post',
    data: data
  })
}

// 修改订单运费信息
export function updateOrderfreight(data) {
  return request({
    url: '/system/orderfreight',
    method: 'put',
    data: data
  })
}

// 删除订单运费信息
export function delOrderfreight(id) {
  return request({
    url: '/system/orderfreight/' + id,
    method: 'delete'
  })
}
