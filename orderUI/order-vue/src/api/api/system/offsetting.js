import request from '@/utils/request'

// 查询资金调整单信息列表
export function listOffsetting(query) {
  return request({
    url: '/system/offsetting/list',
    method: 'get',
    params: query
  })
}

// 查询资金调整单信息详细
export function getOffsetting(id) {
  return request({
    url: '/system/offsetting/' + id,
    method: 'get'
  })
}

// 新增资金调整单信息
export function addOffsetting(data) {
  return request({
    url: '/system/offsetting',
    method: 'post',
    data: data
  })
}

// 修改资金调整单信息
export function updateOffsetting(data) {
  return request({
    url: '/system/offsetting',
    method: 'put',
    data: data
  })
}

// 删除资金调整单信息
export function delOffsetting(id) {
  return request({
    url: '/system/offsetting/' + id,
    method: 'delete'
  })
}
