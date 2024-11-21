import request from '@/utils/request'

// 查询订单详情列表
export function listOrderDetail(query) {
  return request({
    url: '/system/orderDetail/list',
    method: 'get',
    params: query
  })
}

// 查询订单详情详细
export function getOrderDetail(id) {
  return request({
    url: '/system/orderDetail/' + id,
    method: 'get'
  })
}

// 新增订单详情
export function addOrderDetail(data) {
  return request({
    url: '/system/orderDetail',
    method: 'post',
    data: data
  })
}

// 修改订单详情
export function updateOrderDetail(data) {
  return request({
    url: '/system/orderDetail',
    method: 'put',
    data: data
  })
}

// 删除订单详情
export function delOrderDetail(id) {
  return request({
    url: '/system/orderDetail/' + id,
    method: 'delete'
  })
}

// 不分页查询订单详情列表
export function listOrderDetailNoPage(query) {
  return request({
    url: '/system/orderDetail/nopage/list',
    method: 'get',
    params: query
  })
}

// 批量查询订单详情
export function listOrderDetailByIds(query) {
  return request({
    url: '/system/orderDetail/listByBatchIds',
    method: 'get',
    // 这里有个坑 如果后端用get 并且接受一个数组 那么我们需要手动在url拼接一下字符串
    params: {
      ids: query.join(',')
    }
  })
}

// 根据ordersNo批量查询订单详情

export function listOrderDetailByOrderNos(query) {
  return request({
    url: '/system/orderDetail/listByBatchOrderNo',
    method: 'get',
    // 这里有个坑 如果后端用get 并且接受一个数组 那么我们需要手动在url拼接一下字符串
    params: {
      orderNos: query.join(',')
    }
  })
}
