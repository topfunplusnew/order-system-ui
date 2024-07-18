import request from "../../../utils/request.js";

// 查询信息列表
export function listTableeditmessage(query) {
  return request({
    url: '/system/tableeditmessage/list',
    method: 'get',
    params: query
  })
}

// 查询信息详细
export function getTableeditmessage(id) {
  return request({
    url: '/system/tableeditmessage/' + id,
    method: 'get'
  })
}

// 新增信息
export function addTableeditmessage(data) {
  return request({
    url: '/system/tableeditmessage',
    method: 'post',
    data: data
  })
}

// 修改信息
export function updateTableeditmessage(data) {
  return request({
    url: '/system/tableeditmessage',
    method: 'put',
    data: data
  })
}

// 删除信息
export function delTableeditmessage(id) {
  return request({
    url: '/system/tableeditmessage/' + id,
    method: 'delete'
  })
}
