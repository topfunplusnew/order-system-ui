import request from "../../../utils/request.js";

// 查询银行账户列表
export function listBankaccount(query) {
  return request({
    url: '/system/bankaccount/list',
    method: 'get',
    params: query
  })
}

// 查询银行账户详细
export function getBankaccount(id) {
  return request({
    url: '/system/bankaccount/' + id,
    method: 'get'
  })
}

// 新增银行账户
export function addBankaccount(data) {
  return request({
    url: '/system/bankaccount',
    method: 'post',
    data: data
  })
}

// 修改银行账户
export function updateBankaccount(data) {
  return request({
    url: '/system/bankaccount',
    method: 'put',
    data: data
  })
}

// 删除银行账户
export function delBankaccount(id) {
  return request({
    url: '/system/bankaccount/' + id,
    method: 'delete'
  })
}
