import request from '@/utils/request'

// 查询商业票据、银行承兑列表
export function listBankacceptance(query) {
  return request({
    url: '/system/bankacceptance/list',
    method: 'get',
    params: query
  })
}

// 查询商业票据、银行承兑详细
export function getBankacceptance(id) {
  return request({
    url: '/system/bankacceptance/' + id,
    method: 'get'
  })
}

// 新增商业票据、银行承兑
export function addBankacceptance(data) {
  return request({
    url: '/system/bankacceptance',
    method: 'post',
    data: data
  })
}

// 修改商业票据、银行承兑
export function updateBankacceptance(data) {
  return request({
    url: '/system/bankacceptance',
    method: 'put',
    data: data
  })
}

// 删除商业票据、银行承兑
export function delBankacceptance(id) {
  return request({
    url: '/system/bankacceptance/' + id,
    method: 'delete'
  })
}
