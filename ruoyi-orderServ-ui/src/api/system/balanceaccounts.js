import request from '@/utils/request'

// 查询余额账户列表
export function listBalanceaccounts(query) {
  return request({
    url: '/system/balanceaccounts/list',
    method: 'get',
    params: query
  })
}

// 查询余额账户详细
export function getBalanceaccounts(id) {
  return request({
    url: '/system/balanceaccounts/' + id,
    method: 'get'
  })
}

// 新增余额账户
export function addBalanceaccounts(data) {
  return request({
    url: '/system/balanceaccounts',
    method: 'post',
    data: data
  })
}

// 修改余额账户
export function updateBalanceaccounts(data) {
  return request({
    url: '/system/balanceaccounts',
    method: 'put',
    data: data
  })
}

// 删除余额账户
export function delBalanceaccounts(id) {
  return request({
    url: '/system/balanceaccounts/' + id,
    method: 'delete'
  })
}
