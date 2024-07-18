import request from '@/utils/request'

// 查询恢复期货保证金？列表
export function listRecoverfuturesmargin(query) {
  return request({
    url: '/system/recoverfuturesmargin/list',
    method: 'get',
    params: query
  })
}

// 查询恢复期货保证金？详细
export function getRecoverfuturesmargin(id) {
  return request({
    url: '/system/recoverfuturesmargin/' + id,
    method: 'get'
  })
}

// 新增恢复期货保证金？
export function addRecoverfuturesmargin(data) {
  return request({
    url: '/system/recoverfuturesmargin',
    method: 'post',
    data: data
  })
}

// 修改恢复期货保证金？
export function updateRecoverfuturesmargin(data) {
  return request({
    url: '/system/recoverfuturesmargin',
    method: 'put',
    data: data
  })
}

// 删除恢复期货保证金？
export function delRecoverfuturesmargin(id) {
  return request({
    url: '/system/recoverfuturesmargin/' + id,
    method: 'delete'
  })
}
