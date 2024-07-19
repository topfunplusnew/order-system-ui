import request from "../../../utils/request.js";

// 查询借入金钱列表
export function listBorrowedmoney(query) {
  return request({
    url: '/system/borrowedmoney/list',
    method: 'get',
    params: query
  })
}

// 查询借入金钱详细
export function getBorrowedmoney(id) {
  return request({
    url: '/system/borrowedmoney/' + id,
    method: 'get'
  })
}

// 新增借入金钱
export function addBorrowedmoney(data) {
  return request({
    url: '/system/borrowedmoney',
    method: 'post',
    data: data
  })
}

// 修改借入金钱
export function updateBorrowedmoney(data) {
  return request({
    url: '/system/borrowedmoney',
    method: 'put',
    data: data
  })
}

// 删除借入金钱
export function delBorrowedmoney(id) {
  return request({
    url: '/system/borrowedmoney/' + id,
    method: 'delete'
  })
}
