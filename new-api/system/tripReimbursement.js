import request from '@/utils/request'

// 查询出差报销列表
export function listTripReimbursement(query) {
  return request({
    url: '/system/tripReimbursement/list',
    method: 'get',
    params: query
  })
}

// 查询出差报销详细
export function getTripReimbursement(id) {
  return request({
    url: '/system/tripReimbursement/' + id,
    method: 'get'
  })
}

// 新增出差报销
export function addTripReimbursement(data) {
  return request({
    url: '/system/tripReimbursement',
    method: 'post',
    data: data
  })
}

// 修改出差报销
export function updateTripReimbursement(data) {
  return request({
    url: '/system/tripReimbursement',
    method: 'put',
    data: data
  })
}

// 删除出差报销
export function delTripReimbursement(id) {
  return request({
    url: '/system/tripReimbursement/' + id,
    method: 'delete'
  })
}
