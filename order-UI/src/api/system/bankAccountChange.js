import request from '@/utils/request'

// 查询银行账号变动流水列表
export function listBankAccountChange(query) {
  return request({
    url: '/system/bankAccountChange/list',
    method: 'get',
    params: query
  })
}

// 查询银行账号变动流水详细
export function getBankAccountChange(id) {
  return request({
    url: '/system/bankAccountChange/' + id,
    method: 'get'
  })
}

// 新增银行账号变动流水
export function addBankAccountChange(data) {
  return request({
    url: '/system/bankAccountChange',
    method: 'post',
    data: data
  })
}

// 修改银行账号变动流水
export function updateBankAccountChange(data) {
  return request({
    url: '/system/bankAccountChange',
    method: 'put',
    data: data
  })
}

// 删除银行账号变动流水
export function delBankAccountChange(id) {
  return request({
    url: '/system/bankAccountChange/' + id,
    method: 'delete'
  })
}
