import request from '@/utils/request'

// 查询走访记录列表
export function listCustomerVisit(query) {
  return request({
    url: '/system/CustomerVisit/list',
    method: 'get',
    params: query
  })
}

// 查询走访记录详细
export function getCustomerVisit(id) {
  return request({
    url: '/system/CustomerVisit/' + id,
    method: 'get'
  })
}

// 新增走访记录
export function addCustomerVisit(data) {
  return request({
    url: '/system/CustomerVisit',
    method: 'post',
    data: data
  })
}

// 修改走访记录
export function updateCustomerVisit(data) {
  return request({
    url: '/system/CustomerVisit',
    method: 'put',
    data: data
  })
}

// 删除走访记录
export function delCustomerVisit(id) {
  return request({
    url: '/system/CustomerVisit/' + id,
    method: 'delete'
  })
}

//审核走访记录
export function auditCustomerVisit(query) {
  return request({
    url: '/system/CustomerVisit/audit',
    method: 'put',
    params: query
  })
}
