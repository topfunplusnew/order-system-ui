import request from "../../../utils/request.js";

// 查询货物订单列表
export function listGoodsorder(query) {
  return request({
    url: '/system/goodsorder/list',
    method: 'get',
    params: query
  })
}

// 查询货物订单详细
export function getGoodsorder(id) {
  return request({
    url: '/system/goodsorder/' + id,
    method: 'get'
  })
}

// 新增货物订单
export function addGoodsorder(data) {
  return request({
    url: '/system/goodsorder',
    method: 'post',
    data: data
  })
}

// 修改货物订单
export function updateGoodsorder(data) {
  return request({
    url: '/system/goodsorder',
    method: 'put',
    data: data
  })
}

// 删除货物订单
export function delGoodsorder(id) {
  return request({
    url: '/system/goodsorder/' + id,
    method: 'delete'
  })
}
