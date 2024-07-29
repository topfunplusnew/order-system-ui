import request from '@/utils/request'

// 查询车辆派出管理列表
export function listCarapply(query) {
  return request({
    url: '/system/carapply/list',
    method: 'get',
    params: query
  })
}

// 查询车辆派出管理详细
export function getCarapply(id) {
  return request({
    url: '/system/carapply/' + id,
    method: 'get'
  })
}

// 新增车辆派出管理
export function addCarapply(data) {
  return request({
    url: '/system/carapply',
    method: 'post',
    data: data
  })
}

// 修改车辆派出管理
export function updateCarapply(data) {
  return request({
    url: '/system/carapply',
    method: 'put',
    data: data
  })
}

// 删除车辆派出管理
export function delCarapply(id) {
  return request({
    url: '/system/carapply/' + id,
    method: 'delete'
  })
}
