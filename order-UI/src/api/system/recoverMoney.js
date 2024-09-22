import request from '@/utils/request'

// 查询借出款收回信息列表
export function listRecoverMoney(query) {
  return request({
    url: '/system/recoverMoney/list',
    method: 'get',
    params: query
  })
}

// 查询借出款收回信息详细
export function getRecoverMoney(id) {
  return request({
    url: '/system/recoverMoney/' + id,
    method: 'get'
  })
}

// 新增借出款收回信息
export function addRecoverMoney(data) {
  return request({
    url: '/system/recoverMoney',
    method: 'post',
    data: data
  })
}

// 修改借出款收回信息
export function updateRecoverMoney(data) {
  return request({
    url: '/system/recoverMoney',
    method: 'put',
    data: data
  })
}

// 删除借出款收回信息
export function delRecoverMoney(id) {
  return request({
    url: '/system/recoverMoney/' + id,
    method: 'delete'
  })
}

//根据uuid查询借出款详细信息
export function getRecoverMoneyByUuid(uuid) {
  return request({
    url: '/system/recoverMoney/futuresNO/' + uuid,
    method: 'get'
  })
}


// 台账的查询还款记录
export function getRecoverMoneyNoPage(query) {
  return request({
    url: '/system/recoverMoney/noPage/list',
    method: 'get',
    params: query
  })
}
