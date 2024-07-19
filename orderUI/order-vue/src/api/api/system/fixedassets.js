import request from "../../../utils/request.js";

// 查询固定资产信息列表
export function listFixedassets(query) {
  return request({
    url: '/system/fixedassets/list',
    method: 'get',
    params: query
  })
}

// 查询固定资产信息详细
export function getFixedassets(id) {
  return request({
    url: '/system/fixedassets/' + id,
    method: 'get'
  })
}

// 新增固定资产信息
export function addFixedassets(data) {
  return request({
    url: '/system/fixedassets',
    method: 'post',
    data: data
  })
}

// 修改固定资产信息
export function updateFixedassets(data) {
  return request({
    url: '/system/fixedassets',
    method: 'put',
    data: data
  })
}

// 删除固定资产信息
export function delFixedassets(id) {
  return request({
    url: '/system/fixedassets/' + id,
    method: 'delete'
  })
}
