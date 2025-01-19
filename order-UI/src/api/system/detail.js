import request from '@/utils/request'

// 查询库存子列表
export function listDetail(query) {
  return request({
    url: '/system/detail/list',
    method: 'get',
    params: query
  })
}

// 查询库存子详细
export function getDetail(id) {
  return request({
    url: '/system/detail/' + id,
    method: 'get'
  })
}

// 新增库存子
export function addDetail(data) {
  return request({
    url: '/system/detail',
    method: 'post',
    data: data
  })
}

// 修改库存子
export function updateDetail(data) {
  return request({
    url: '/system/detail',
    method: 'put',
    data: data
  })
}

// 删除库存子
export function delDetail(id) {
  return request({
    url: '/system/detail/' + id,
    method: 'delete'
  })
}
