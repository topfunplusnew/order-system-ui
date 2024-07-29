import request from '@/utils/request'

// 查询从外部借入款、贷款列表
export function listBorrowedmoney(query) {
  return request({
    url: '/system/borrowedmoney/list',
    method: 'get',
    params: query
  })
}

// 查询从外部借入款、贷款详细
export function getBorrowedmoney(id) {
  return request({
    url: '/system/borrowedmoney/' + id,
    method: 'get'
  })
}

// 新增从外部借入款、贷款
export function addBorrowedmoney(data) {
  return request({
    url: '/system/borrowedmoney',
    method: 'post',
    data: data
  })
}

// 修改从外部借入款、贷款
export function updateBorrowedmoney(data) {
  return request({
    url: '/system/borrowedmoney',
    method: 'put',
    data: data
  })
}

// 删除从外部借入款、贷款
export function delBorrowedmoney(id) {
  return request({
    url: '/system/borrowedmoney/' + id,
    method: 'delete'
  })
}
