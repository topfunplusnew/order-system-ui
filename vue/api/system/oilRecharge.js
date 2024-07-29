import request from '@/utils/request'

// 查询加油卡充值信息列表
export function listOilRecharge(query) {
  return request({
    url: '/system/oilRecharge/list',
    method: 'get',
    params: query
  })
}

// 查询加油卡充值信息详细
export function getOilRecharge(id) {
  return request({
    url: '/system/oilRecharge/' + id,
    method: 'get'
  })
}

// 新增加油卡充值信息
export function addOilRecharge(data) {
  return request({
    url: '/system/oilRecharge',
    method: 'post',
    data: data
  })
}

// 修改加油卡充值信息
export function updateOilRecharge(data) {
  return request({
    url: '/system/oilRecharge',
    method: 'put',
    data: data
  })
}

// 删除加油卡充值信息
export function delOilRecharge(id) {
  return request({
    url: '/system/oilRecharge/' + id,
    method: 'delete'
  })
}
