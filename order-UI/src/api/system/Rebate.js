import request from '@/utils/request'

// 查询返利回扣列表
export function listRebate(query) {
  return request({
    url: '/system/Rebate/list',
    method: 'get',
    params: query
  })
}

// 查询返利回扣详细
export function getRebate(id) {
  return request({
    url: '/system/Rebate/' + id,
    method: 'get'
  })
}

// 新增返利回扣
export function addRebate(data) {
  return request({
    url: '/system/Rebate',
    method: 'post',
    data: data
  })
}

// 修改返利回扣
export function updateRebate(data) {
  return request({
    url: '/system/Rebate',
    method: 'put',
    data: data
  })
}

// 删除返利回扣
export function delRebate(id) {
  return request({
    url: '/system/Rebate/' + id,
    method: 'delete'
  })
}
