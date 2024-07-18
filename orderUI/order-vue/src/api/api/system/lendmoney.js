import request from "../../../utils/request.js";

// 查询借贷列表
export function listLendmoney(query) {
  return request({
    url: '/system/lendmoney/list',
    method: 'get',
    params: query
  })
}

// 查询借贷详细
export function getLendmoney(id) {
  return request({
    url: '/system/lendmoney/' + id,
    method: 'get'
  })
}

// 新增借贷
export function addLendmoney(data) {
  return request({
    url: '/system/lendmoney',
    method: 'post',
    data: data
  })
}

// 修改借贷
export function updateLendmoney(data) {
  return request({
    url: '/system/lendmoney',
    method: 'put',
    data: data
  })
}

// 删除借贷
export function delLendmoney(id) {
  return request({
    url: '/system/lendmoney/' + id,
    method: 'delete'
  })
}
