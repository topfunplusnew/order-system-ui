import request from '@/utils/request'

// 查询出差记录列表
export function listBusinesstrip(query) {
  return request({
    url: '/system/businesstrip/list',
    method: 'get',
    params: query
  })
}

// 查询出差记录详细
export function getBusinesstrip(id) {
  return request({
    url: '/system/businesstrip/' + id,
    method: 'get'
  })
}

// 新增出差记录
export function addBusinesstrip(data) {
  return request({
    url: '/system/businesstrip',
    method: 'post',
    data: data
  })
}

// 修改出差记录
export function updateBusinesstrip(data) {
  return request({
    url: '/system/businesstrip',
    method: 'put',
    data: data
  })
}

// 删除出差记录
export function delBusinesstrip(id) {
  return request({
    url: '/system/businesstrip/' + id,
    method: 'delete'
  })
}
