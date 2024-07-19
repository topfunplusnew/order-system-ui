import request from "../../../utils/request.js";

// 查询银行承兑列表
export function listBankacceptance(query) {
  return request({
    url: '/system/bankacceptance/list',
    method: 'get',
    params: query
  })
}

// 查询银行承兑详细
export function getBankacceptance(id) {
  return request({
    url: '/system/bankacceptance/' + id,
    method: 'get'
  })
}

// 新增银行承兑
export function addBankacceptance(data) {
  return request({
    url: '/system/bankacceptance',
    method: 'post',
    data: data
  })
}

// 修改银行承兑
export function updateBankacceptance(data) {
  return request({
    url: '/system/bankacceptance',
    method: 'put',
    data: data
  })
}

// 删除银行承兑
export function delBankacceptance(id) {
  return request({
    url: '/system/bankacceptance/' + id,
    method: 'delete'
  })
}
