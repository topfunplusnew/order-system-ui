import request from '@/utils/request'

// 查询付款信息列表
export function listPayment(query) {
  return request({
    url: '/system/payment/list',
    method: 'get',
    params: query
  })
}

// 查询付款信息详细
export function getPayment(id) {
  return request({
    url: '/system/payment/' + id,
    method: 'get'
  })
}

// 新增付款信息
export function addPayment(data) {
  return request({
    url: '/system/payment',
    method: 'post',
    data: data
  })
}

// 修改付款信息
export function updatePayment(data) {
  return request({
    url: '/system/payment',
    method: 'put',
    data: data
  })
}

// 删除付款信息
export function delPayment(id) {
  return request({
    url: '/system/payment/' + id,
    method: 'delete'
  })
}

// 一键付款
export function batchPayment(data) {
  return request({
    url: '/system/payment/batch',
    method: 'post',
    data: data
  })
}
