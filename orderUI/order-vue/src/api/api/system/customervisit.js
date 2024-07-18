import request from "../../../utils/request.js";

// 查询走访记录列表
export function listCustomervisit(query) {
  return request({
    url: '/system/customervisit/list',
    method: 'get',
    params: query
  })
}

// 查询走访记录详细
export function getCustomervisit(id) {
  return request({
    url: '/system/customervisit/' + id,
    method: 'get'
  })
}

// 新增走访记录
export function addCustomervisit(data) {
  return request({
    url: '/system/customervisit',
    method: 'post',
    data: data
  })
}

// 修改走访记录
export function updateCustomervisit(data) {
  return request({
    url: '/system/customervisit',
    method: 'put',
    data: data
  })
}

// 删除走访记录
export function delCustomervisit(id) {
  return request({
    url: '/system/customervisit/' + id,
    method: 'delete'
  })
}
