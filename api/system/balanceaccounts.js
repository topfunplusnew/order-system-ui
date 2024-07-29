import request from '@/utils/request'

// 查询平账列表
export function listBalanceaccounts(query) {
  return request({
    url: '/system/balanceaccounts/list',
    method: 'get',
    params: query
  })
}

// 查询平账详细
export function getBalanceaccounts(id) {
  return request({
    url: '/system/balanceaccounts/' + id,
    method: 'get'
  })
}

// 新增平账
export function addBalanceaccounts(data) {
  return request({
    url: '/system/balanceaccounts',
    method: 'post',
    data: data
  })
}

// 修改平账
export function updateBalanceaccounts(data) {
  return request({
    url: '/system/balanceaccounts',
    method: 'put',
    data: data
  })
}

// 删除平账
export function delBalanceaccounts(id) {
  return request({
    url: '/system/balanceaccounts/' + id,
    method: 'delete'
  })
}
