import request from '@/utils/request'

// 查询资金借出（期货）列表
export function listLendmoney(query) {
  return request({
    url: '/system/lendmoney/list',
    method: 'get',
    params: query
  })
}

// 查询资金借出（期货）详细
export function getLendmoney(id) {
  return request({
    url: '/system/lendmoney/' + id,
    method: 'get'
  })
}

// 新增资金借出（期货）
export function addLendmoney(data) {
  return request({
    url: '/system/lendmoney',
    method: 'post',
    data: data
  })
}

// 修改资金借出（期货）
export function updateLendmoney(data) {
  return request({
    url: '/system/lendmoney',
    method: 'put',
    data: data
  })
}

// 删除资金借出（期货）
export function delLendmoney(id) {
  return request({
    url: '/system/lendmoney/' + id,
    method: 'delete'
  })
}
