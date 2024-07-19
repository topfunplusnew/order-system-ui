import request from "../../../utils/request.js";

// 查询社会保险信息列表
export function listSocialinsurance(query) {
  return request({
    url: '/system/socialinsurance/list',
    method: 'get',
    params: query
  })
}

// 查询社会保险信息详细
export function getSocialinsurance(id) {
  return request({
    url: '/system/socialinsurance/' + id,
    method: 'get'
  })
}

// 新增社会保险信息
export function addSocialinsurance(data) {
  return request({
    url: '/system/socialinsurance',
    method: 'post',
    data: data
  })
}

// 修改社会保险信息
export function updateSocialinsurance(data) {
  return request({
    url: '/system/socialinsurance',
    method: 'put',
    data: data
  })
}

// 删除社会保险信息
export function delSocialinsurance(id) {
  return request({
    url: '/system/socialinsurance/' + id,
    method: 'delete'
  })
}
