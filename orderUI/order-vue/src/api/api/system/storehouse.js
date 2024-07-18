import request from "../../../utils/request.js";

// 查询仓库信息列表
export function listStorehouse(query) {
  return request({
    url: '/system/storehouse/list',
    method: 'get',
    params: query
  })
}

// 查询仓库信息详细
export function getStorehouse(id) {
  return request({
    url: '/system/storehouse/' + id,
    method: 'get'
  })
}

// 新增仓库信息
export function addStorehouse(data) {
  return request({
    url: '/system/storehouse',
    method: 'post',
    data: data
  })
}

// 修改仓库信息
export function updateStorehouse(data) {
  return request({
    url: '/system/storehouse',
    method: 'put',
    data: data
  })
}

// 删除仓库信息
export function delStorehouse(id) {
  return request({
    url: '/system/storehouse/' + id,
    method: 'delete'
  })
}
