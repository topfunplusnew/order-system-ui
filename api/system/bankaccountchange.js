import request from '@/utils/request'

// 查询银行卡资金变动列表
export function listBankaccountchange(query) {
  return request({
    url: '/system/bankaccountchange/list',
    method: 'get',
    params: query
  })
}

// 查询银行卡资金变动详细
export function getBankaccountchange(id) {
  return request({
    url: '/system/bankaccountchange/' + id,
    method: 'get'
  })
}

// 新增银行卡资金变动
export function addBankaccountchange(data) {
  return request({
    url: '/system/bankaccountchange',
    method: 'post',
    data: data
  })
}

// 修改银行卡资金变动
export function updateBankaccountchange(data) {
  return request({
    url: '/system/bankaccountchange',
    method: 'put',
    data: data
  })
}

// 删除银行卡资金变动
export function delBankaccountchange(id) {
  return request({
    url: '/system/bankaccountchange/' + id,
    method: 'delete'
  })
}
