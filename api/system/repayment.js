import request from '@/utils/request'

// 查询还款记录列表
export function listRepayment(query) {
  return request({
    url: '/system/repayment/list',
    method: 'get',
    params: query
  })
}

// 查询还款记录详细
export function getRepayment(id) {
  return request({
    url: '/system/repayment/' + id,
    method: 'get'
  })
}

// 新增还款记录
export function addRepayment(data) {
  return request({
    url: '/system/repayment',
    method: 'post',
    data: data
  })
}

// 修改还款记录
export function updateRepayment(data) {
  return request({
    url: '/system/repayment',
    method: 'put',
    data: data
  })
}

// 删除还款记录
export function delRepayment(id) {
  return request({
    url: '/system/repayment/' + id,
    method: 'delete'
  })
}
