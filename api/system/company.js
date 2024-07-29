import request from '@/utils/request'

// 查询客户管理列表
export function listCompany(query) {
  return request({
    url: '/system/company/list',
    method: 'get',
    params: query
  })
}

// 查询客户管理详细
export function getCompany(id) {
  return request({
    url: '/system/company/' + id,
    method: 'get'
  })
}

// 新增客户管理
export function addCompany(data) {
  return request({
    url: '/system/company',
    method: 'post',
    data: data
  })
}

// 修改客户管理
export function updateCompany(data) {
  return request({
    url: '/system/company',
    method: 'put',
    data: data
  })
}

// 删除客户管理
export function delCompany(id) {
  return request({
    url: '/system/company/' + id,
    method: 'delete'
  })
}
