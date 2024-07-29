import request from '@/utils/request'

// 查询商业票据、银行承兑列表
export function listBankAcceptance(query) {
  return request({
    url: '/system/bankAcceptance/list',
    method: 'get',
    params: query
  })
}

// 查询商业票据、银行承兑详细
export function getBankAcceptance(id) {
  return request({
    url: '/system/bankAcceptance/' + id,
    method: 'get'
  })
}

// 新增商业票据、银行承兑
export function addBankAcceptance(data) {
  return request({
    url: '/system/bankAcceptance',
    method: 'post',
    data: data
  })
}

// 修改商业票据、银行承兑
export function updateBankAcceptance(data) {
  return request({
    url: '/system/bankAcceptance',
    method: 'put',
    data: data
  })
}

// 删除商业票据、银行承兑
export function delBankAcceptance(id) {
  return request({
    url: '/system/bankAcceptance/' + id,
    method: 'delete'
  })
}
