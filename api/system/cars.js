import request from '@/utils/request'

// 查询车辆管理列表
export function listCars(query) {
  return request({
    url: '/system/cars/list',
    method: 'get',
    params: query
  })
}

// 查询车辆管理详细
export function getCars(id) {
  return request({
    url: '/system/cars/' + id,
    method: 'get'
  })
}

// 新增车辆管理
export function addCars(data) {
  return request({
    url: '/system/cars',
    method: 'post',
    data: data
  })
}

// 修改车辆管理
export function updateCars(data) {
  return request({
    url: '/system/cars',
    method: 'put',
    data: data
  })
}

// 删除车辆管理
export function delCars(id) {
  return request({
    url: '/system/cars/' + id,
    method: 'delete'
  })
}
