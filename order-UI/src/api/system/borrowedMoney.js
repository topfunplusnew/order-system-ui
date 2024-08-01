import request from '@/utils/request'

// 查询从外部借款信息列表
export function listBorrowedMoney(query) {
  return request({
    url: '/system/borrowedMoney/list',
    method: 'get',
    params: query
  })
}

// 查询从外部借款信息详细
export function getBorrowedMoney(id) {
  return request({
    url: '/system/borrowedMoney/' + id,
    method: 'get'
  })
}

// 新增从外部借款信息
export function addBorrowedMoney(data) {
  return request({
    url: '/system/borrowedMoney',
    method: 'post',
    data: data
  })
}

// 修改从外部借款信息
export function updateBorrowedMoney(data) {
  return request({
    url: '/system/borrowedMoney',
    method: 'put',
    data: data
  })
}

// 删除从外部借款信息
export function delBorrowedMoney(id) {
  return request({
    url: '/system/borrowedMoney/' + id,
    method: 'delete'
  })
}

//根据uuid查询借款详细信息
export function getBorrowedMoneyByUuid(uuid) {
  return new Promise(() => {
    return request({
      url: '/system/repayment/loanNo/' + uuid,
      method: 'GET'
    })
  })
}
