import request from "../../../utils/request.js";

// 查询汽车信息列表
export function listCars(query) {
  return request({
    url: '/system/cars/list',
    method: 'get',
    params: query
  })
}

// 查询汽车信息详细
export function getCars(id) {
  return request({
    url: '/system/cars/' + id,
    method: 'get'
  })
}

// 新增汽车信息
export function addCars(data) {
  return request({
    url: '/system/cars',
    method: 'post',
    data: data
  })
}

// 修改汽车信息
export function updateCars(data) {
  return request({
    url: '/system/cars',
    method: 'put',
    data: data
  })
}

// 删除汽车信息
export function delCars(id) {
  return request({
    url: '/system/cars/' + id,
    method: 'delete'
  })
}
