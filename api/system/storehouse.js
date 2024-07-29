import request from '@/utils/request'

// 查询仓库管理列表
export function listStorehouse(query) {
  return request({
    url: '/system/storehouse/list',
    method: 'get',
    params: query
  })
}

// 查询仓库管理详细
export function getStorehouse(id) {
  return request({
    url: '/system/storehouse/' + id,
    method: 'get'
  })
}

// 新增仓库管理
export function addStorehouse(data) {
  return request({
    url: '/system/storehouse',
    method: 'post',
    data: data
  })
}

// 修改仓库管理
export function updateStorehouse(data) {
  return request({
    url: '/system/storehouse',
    method: 'put',
    data: data
  })
}

// 删除仓库管理
export function delStorehouse(id) {
  return request({
    url: '/system/storehouse/' + id,
    method: 'delete'
  })
}
