import request from '@/utils/request'

// 查询银行账号列表
export function listBankAccount(query) {
  return request({
    url: '/system/bankAccount/list',
    method: 'get',
    params: query
  })
}

// 查询银行账号详细
export function getBankAccount(id) {
  return request({
    url: '/system/bankAccount/' + id,
    method: 'get'
  })
}

// 新增银行账号
export function addBankAccount(data) {
  return request({
    url: '/system/bankAccount',
    method: 'post',
    data: data
  })
}

// 修改银行账号
export function updateBankAccount(data) {
  return request({
    url: '/system/bankAccount',
    method: 'put',
    data: data
  })
}

// 删除银行账号
export function delBankAccount(id) {
  return request({
    url: '/system/bankAccount/' + id,
    method: 'delete'
  })
}

//银行卡转账
export function transfer(data) {
  return request({
    url: '/system/bankAccount/transfer',
    method: 'post',
    data: data
  })
}
