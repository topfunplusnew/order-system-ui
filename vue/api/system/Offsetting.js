import request from '@/utils/request'

// 查询对冲账信息列表
export function listOffsetting(query) {
  return request({
    url: '/system/Offsetting/list',
    method: 'get',
    params: query
  })
}

// 查询对冲账信息详细
export function getOffsetting(id) {
  return request({
    url: '/system/Offsetting/' + id,
    method: 'get'
  })
}

// 新增对冲账信息
export function addOffsetting(data) {
  return request({
    url: '/system/Offsetting',
    method: 'post',
    data: data
  })
}

// 修改对冲账信息
export function updateOffsetting(data) {
  return request({
    url: '/system/Offsetting',
    method: 'put',
    data: data
  })
}

// 删除对冲账信息
export function delOffsetting(id) {
  return request({
    url: '/system/Offsetting/' + id,
    method: 'delete'
  })
}
