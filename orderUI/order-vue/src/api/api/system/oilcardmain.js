import request from "../../../utils/request.js";

// 查询加油卡主卡登记信息列表
export function listOilcardmain(query) {
  return request({
    url: '/system/oilcardmain/list',
    method: 'get',
    params: query
  })
}

// 查询加油卡主卡登记信息详细
export function getOilcardmain(id) {
  return request({
    url: '/system/oilcardmain/' + id,
    method: 'get'
  })
}

// 新增加油卡主卡登记信息
export function addOilcardmain(data) {
  return request({
    url: '/system/oilcardmain',
    method: 'post',
    data: data
  })
}

// 修改加油卡主卡登记信息
export function updateOilcardmain(data) {
  return request({
    url: '/system/oilcardmain',
    method: 'put',
    data: data
  })
}

// 删除加油卡主卡登记信息
export function delOilcardmain(id) {
  return request({
    url: '/system/oilcardmain/' + id,
    method: 'delete'
  })
}
