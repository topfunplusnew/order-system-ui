import request from '@/utils/request'

// 查询向外部借出款信息列表
export function listLendMoney(query) {
  return request({
    url: '/system/lendMoney/list',
    method: 'get',
    params: query
  })
}

// 查询向外部借出款信息详细
export function getLendMoney(id) {
  return request({
    url: '/system/lendMoney/' + id,
    method: 'get'
  })
}

// 新增向外部借出款信息
export function addLendMoney(data) {
  return request({
    url: '/system/lendMoney',
    method: 'post',
    data: data
  })
}

// 修改向外部借出款信息
export function updateLendMoney(data) {
  return request({
    url: '/system/lendMoney',
    method: 'put',
    data: data
  })
}

// 删除向外部借出款信息
export function delLendMoney(id) {
  return request({
    url: '/system/lendMoney/' + id,
    method: 'delete'
  })
}
