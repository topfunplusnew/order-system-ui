import request from '@/utils/request'

// 查询订单列表
export function listGoodsOrder(query) {
  return request({
    url: '/system/goodsOrder/list',
    method: 'get',
    params: query
  })
}

// 查询订单详细
export function getGoodsOrder(id) {
  return request({
    url: '/system/goodsOrder/' + id,
    method: 'get'
  })
}

// 新增订单
export function addGoodsOrder(data) {
  return request({
    url: '/system/goodsOrder',
    method: 'post',
    data: data
  })
}

// 修改订单
export function updateGoodsOrder(data) {
  return request({
    url: '/system/goodsOrder',
    method: 'put',
    data: data
  })
}

// 删除订单
export function delGoodsOrder(id) {
  return request({
    url: '/system/goodsOrder/' + id,
    method: 'delete'
  })
}

//根据uuid查询订单详细信息
export function getGoodsByUUID(uuid) {
  return request({
    url: '/system/goodsOrder/' + uuid,
    method: 'delete'
  })
}

//调整单
export function adjustGoodsOrder(data) {
  return request({
    url: '/system/goodsOrder/adjust',
    method: 'put',
    data: data
  })
}

//审核订单
export function auditGoodsOrder(data) {
  return request({
    url: '/system/goodsOrder/audit',
    method: 'put',
    params: {
      id: data.id,
      isaudit: data.isaudit
    }
  })
}

//查询订单历史信息
export function getHistoryGoodsOrder(query) {
  return request({
    url: '/system/goodsOrderBack/list',
    method: 'get',
    params: query
  })
}


// 根据订单id检查
export function checkOrderAllinvoice(id) {
  return request({
    url: '/system/allinvoice/checkInvoiceAmount/?id=' + id,
    method: 'get'
  })
}

// 根据orderNo获取订单详细信息
export function checkOrderByOrderNo(orderNo) {
  return request({
    url: '/system/goodsOrder/orderNo/' + orderNo,
    method: 'get'
  })
}
