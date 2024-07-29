import request from '@/utils/request'

// 查询出库列表
export function listExwarehouse(query) {
  return request({
    url: '/system/exwarehouse/list',
    method: 'get',
    params: query
  })
}

// 查询出库详细
export function getExwarehouse(id) {
  return request({
    url: '/system/exwarehouse/' + id,
    method: 'get'
  })
}

// 新增出库
export function addExwarehouse(data) {
  return request({
    url: '/system/exwarehouse',
    method: 'post',
    data: data
  })
}

// 修改出库
export function updateExwarehouse(data) {
  return request({
    url: '/system/exwarehouse',
    method: 'put',
    data: data
  })
}

// 删除出库
export function delExwarehouse(id) {
  return request({
    url: '/system/exwarehouse/' + id,
    method: 'delete'
  })
}
