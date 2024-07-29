import request from '@/utils/request'

// 查询供应商返利列表
export function listRebate(query) {
  return request({
    url: '/system/rebate/list',
    method: 'get',
    params: query
  })
}

// 查询供应商返利详细
export function getRebate(id) {
  return request({
    url: '/system/rebate/' + id,
    method: 'get'
  })
}

// 新增供应商返利
export function addRebate(data) {
  return request({
    url: '/system/rebate',
    method: 'post',
    data: data
  })
}

// 修改供应商返利
export function updateRebate(data) {
  return request({
    url: '/system/rebate',
    method: 'put',
    data: data
  })
}

// 删除供应商返利
export function delRebate(id) {
  return request({
    url: '/system/rebate/' + id,
    method: 'delete'
  })
}
