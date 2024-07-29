import request from '@/utils/request'

// 查询平账信息列表
export function listBalanceAccounts(query) {
  return request({
    url: '/system/BalanceAccounts/list',
    method: 'get',
    params: query
  })
}

// 查询平账信息详细
export function getBalanceAccounts(id) {
  return request({
    url: '/system/BalanceAccounts/' + id,
    method: 'get'
  })
}

// 新增平账信息
export function addBalanceAccounts(data) {
  return request({
    url: '/system/BalanceAccounts',
    method: 'post',
    data: data
  })
}

// 修改平账信息
export function updateBalanceAccounts(data) {
  return request({
    url: '/system/BalanceAccounts',
    method: 'put',
    data: data
  })
}

// 删除平账信息
export function delBalanceAccounts(id) {
  return request({
    url: '/system/BalanceAccounts/' + id,
    method: 'delete'
  })
}
