import request from '@/utils/request'

// 查询银行卡管理列表
export function listBankaccount(query) {
  return request({
    url: '/system/bankaccount/list',
    method: 'get',
    params: query
  })
}

// 查询银行卡管理详细
export function getBankaccount(id) {
  return request({
    url: '/system/bankaccount/' + id,
    method: 'get'
  })
}

// 新增银行卡管理
export function addBankaccount(data) {
  return request({
    url: '/system/bankaccount',
    method: 'post',
    data: data
  })
}

// 修改银行卡管理
export function updateBankaccount(data) {
  return request({
    url: '/system/bankaccount',
    method: 'put',
    data: data
  })
}

// 删除银行卡管理
export function delBankaccount(id) {
  return request({
    url: '/system/bankaccount/' + id,
    method: 'delete'
  })
}
