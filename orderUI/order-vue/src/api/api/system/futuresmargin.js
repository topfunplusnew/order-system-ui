import request from "../../../utils/request.js";

// 查询期货保证金信息列表
export function listFuturesmargin(query) {
  return request({
    url: '/system/futuresmargin/list',
    method: 'get',
    params: query
  })
}

// 查询期货保证金信息详细
export function getFuturesmargin(id) {
  return request({
    url: '/system/futuresmargin/' + id,
    method: 'get'
  })
}

// 新增期货保证金信息
export function addFuturesmargin(data) {
  return request({
    url: '/system/futuresmargin',
    method: 'post',
    data: data
  })
}

// 修改期货保证金信息
export function updateFuturesmargin(data) {
  return request({
    url: '/system/futuresmargin',
    method: 'put',
    data: data
  })
}

// 删除期货保证金信息
export function delFuturesmargin(id) {
  return request({
    url: '/system/futuresmargin/' + id,
    method: 'delete'
  })
}
