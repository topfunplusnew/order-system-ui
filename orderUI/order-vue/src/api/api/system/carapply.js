import request from "../../../utils/request.js";

// 查询汽车申请列表
export function listCarapply(query) {
  return request({
    url: '/system/carapply/list',
    method: 'get',
    params: query
  })
}

// 查询汽车申请详细
export function getCarapply(id) {
  return request({
    url: '/system/carapply/' + id,
    method: 'get'
  })
}

// 新增汽车申请
export function addCarapply(data) {
  return request({
    url: '/system/carapply',
    method: 'post',
    data: data
  })
}

// 修改汽车申请
export function updateCarapply(data) {
  return request({
    url: '/system/carapply',
    method: 'put',
    data: data
  })
}

// 删除汽车申请
export function delCarapply(id) {
  return request({
    url: '/system/carapply/' + id,
    method: 'delete'
  })
}
