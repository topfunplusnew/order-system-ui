import request from '@/utils/request'

// 查询加油卡信息列表
export function listOilcard(query) {
  return request({
    url: '/system/oilcard/list',
    method: 'get',
    params: query
  })
}

// 查询加油卡信息详细
export function getOilcard(id) {
  return request({
    url: '/system/oilcard/' + id,
    method: 'get'
  })
}

// 新增加油卡信息
export function addOilcard(data) {
  return request({
    url: '/system/oilcard',
    method: 'post',
    data: data
  })
}

// 修改加油卡信息
export function updateOilcard(data) {
  return request({
    url: '/system/oilcard',
    method: 'put',
    data: data
  })
}

// 删除加油卡信息
export function delOilcard(id) {
  return request({
    url: '/system/oilcard/' + id,
    method: 'delete'
  })
}
