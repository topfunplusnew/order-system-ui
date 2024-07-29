import request from '@/utils/request'

// 查询订单备份信息列表
export function listBack(query) {
  return request({
    url: '/system/inventoryBack/list',
    method: 'get',
    params: query
  })
}

// 查询订单备份信息详细
export function getBack(id) {
  return request({
    url: '/system/inventoryBack/' + id,
    method: 'get'
  })
}

// 新增订单备份信息
export function addBack(data) {
  return request({
    url: '/system/inventoryBack',
    method: 'post',
    data: data
  })
}

// 修改订单备份信息
export function updateBack(data) {
  return request({
    url: '/system/inventoryBack',
    method: 'put',
    data: data
  })
}

// 删除订单备份信息
export function delBack(id) {
  return request({
    url: '/system/inventoryBack/' + id,
    method: 'delete'
  })
}
