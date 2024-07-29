import request from '@/utils/request'

// 查询加油卡信息列表
export function listOilCard(query) {
  return request({
    url: '/system/oilCard/list',
    method: 'get',
    params: query
  })
}

// 查询加油卡信息详细
export function getOilCard(id) {
  return request({
    url: '/system/oilCard/' + id,
    method: 'get'
  })
}

// 新增加油卡信息
export function addOilCard(data) {
  return request({
    url: '/system/oilCard',
    method: 'post',
    data: data
  })
}

// 修改加油卡信息
export function updateOilCard(data) {
  return request({
    url: '/system/oilCard',
    method: 'put',
    data: data
  })
}

// 删除加油卡信息
export function delOilCard(id) {
  return request({
    url: '/system/oilCard/' + id,
    method: 'delete'
  })
}
