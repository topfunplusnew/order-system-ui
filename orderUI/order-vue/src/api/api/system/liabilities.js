import request from "../../../utils/request.js";

// 查询负债信息列表
export function listLiabilities(query) {
  return request({
    url: '/system/liabilities/list',
    method: 'get',
    params: query
  })
}

// 查询负债信息详细
export function getLiabilities(id) {
  return request({
    url: '/system/liabilities/' + id,
    method: 'get'
  })
}

// 新增负债信息
export function addLiabilities(data) {
  return request({
    url: '/system/liabilities',
    method: 'post',
    data: data
  })
}

// 修改负债信息
export function updateLiabilities(data) {
  return request({
    url: '/system/liabilities',
    method: 'put',
    data: data
  })
}

// 删除负债信息
export function delLiabilities(id) {
  return request({
    url: '/system/liabilities/' + id,
    method: 'delete'
  })
}
