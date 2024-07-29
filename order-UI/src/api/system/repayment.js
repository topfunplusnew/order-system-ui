import request from '@/utils/request'

// 查询贷款还款信息列表
export function listRepayment(query) {
  return request({
    url: '/system/repayment/list',
    method: 'get',
    params: query
  })
}

// 查询贷款还款信息详细
export function getRepayment(id) {
  return request({
    url: '/system/repayment/' + id,
    method: 'get'
  })
}

// 新增贷款还款信息
export function addRepayment(data) {
  return request({
    url: '/system/repayment',
    method: 'post',
    data: data
  })
}

// 修改贷款还款信息
export function updateRepayment(data) {
  return request({
    url: '/system/repayment',
    method: 'put',
    data: data
  })
}

// 删除贷款还款信息
export function delRepayment(id) {
  return request({
    url: '/system/repayment/' + id,
    method: 'delete'
  })
}
