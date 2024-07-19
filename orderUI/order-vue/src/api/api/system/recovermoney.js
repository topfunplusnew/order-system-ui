import request from '@/utils/request'

// 查询资金回收列表
export function listRecovermoney(query) {
  return request({
    url: '/system/recovermoney/list',
    method: 'get',
    params: query
  })
}

// 查询资金回收详细
export function getRecovermoney(id) {
  return request({
    url: '/system/recovermoney/' + id,
    method: 'get'
  })
}

// 新增资金回收
export function addRecovermoney(data) {
  return request({
    url: '/system/recovermoney',
    method: 'post',
    data: data
  })
}

// 修改资金回收
export function updateRecovermoney(data) {
  return request({
    url: '/system/recovermoney',
    method: 'put',
    data: data
  })
}

// 删除资金回收
export function delRecovermoney(id) {
  return request({
    url: '/system/recovermoney/' + id,
    method: 'delete'
  })
}
