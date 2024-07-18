import request from '@/utils/request'

// 查询返利信息列表
export function listRebate(query) {
  return request({
    url: '/system/rebate/list',
    method: 'get',
    params: query
  })
}

// 查询返利信息详细
export function getRebate(id) {
  return request({
    url: '/system/rebate/' + id,
    method: 'get'
  })
}

// 新增返利信息
export function addRebate(data) {
  return request({
    url: '/system/rebate',
    method: 'post',
    data: data
  })
}

// 修改返利信息
export function updateRebate(data) {
  return request({
    url: '/system/rebate',
    method: 'put',
    data: data
  })
}

// 删除返利信息
export function delRebate(id) {
  return request({
    url: '/system/rebate/' + id,
    method: 'delete'
  })
}
