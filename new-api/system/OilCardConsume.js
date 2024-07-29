import request from '@/utils/request'

// 查询加油卡消费信息列表
export function listOilCardConsume(query) {
  return request({
    url: '/system/OilCardConsume/list',
    method: 'get',
    params: query
  })
}

// 查询加油卡消费信息详细
export function getOilCardConsume(id) {
  return request({
    url: '/system/OilCardConsume/' + id,
    method: 'get'
  })
}

// 新增加油卡消费信息
export function addOilCardConsume(data) {
  return request({
    url: '/system/OilCardConsume',
    method: 'post',
    data: data
  })
}

// 修改加油卡消费信息
export function updateOilCardConsume(data) {
  return request({
    url: '/system/OilCardConsume',
    method: 'put',
    data: data
  })
}

// 删除加油卡消费信息
export function delOilCardConsume(id) {
  return request({
    url: '/system/OilCardConsume/' + id,
    method: 'delete'
  })
}
