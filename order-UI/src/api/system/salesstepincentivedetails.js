import request from '@/utils/request'

// 查询台阶制列表
export function listSalesstepincentivedetails(query) {
  return request({
    url: '/system/salesstepincentivedetails/list',
    method: 'get',
    params: query
  })
}

// 查询台阶制详细
export function getSalesstepincentivedetails(id) {
  return request({
    url: '/system/salesstepincentivedetails/' + id,
    method: 'get'
  })
}

// 新增台阶制
export function addSalesstepincentivedetails(data) {
  return request({
    url: '/system/salesstepincentivedetails',
    method: 'post',
    data: data
  })
}

// 修改台阶制
export function updateSalesstepincentivedetails(data) {
  return request({
    url: '/system/salesstepincentivedetails',
    method: 'put',
    data: data
  })
}

// 删除台阶制
export function delSalesstepincentivedetails(id) {
  return request({
    url: '/system/salesstepincentivedetails/' + id,
    method: 'delete'
  })
}
