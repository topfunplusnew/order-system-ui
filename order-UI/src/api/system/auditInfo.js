import request from '@/utils/request'

// 查询审核流程列表
export function listAuditInfo(query) {
  return request({
    url: '/system/auditInfo/list',
    method: 'get',
    params: query
  })
}

// 查询审核流程详细
export function getAuditInfo(id) {
  return request({
    url: '/system/auditInfo/' + id,
    method: 'get'
  })
}

// 新增审核流程
export function addAuditInfo(data) {
  return request({
    url: '/system/auditInfo',
    method: 'post',
    data: data
  })
}

// 修改审核流程
export function updateAuditInfo(data) {
  return request({
    url: '/system/auditInfo',
    method: 'put',
    data: data
  })
}

// 删除审核流程
export function delAuditInfo(id) {
  return request({
    url: '/system/auditInfo/' + id,
    method: 'delete'
  })
}

// 查询分组审核列表
export function listAuditInfoGroup(query) {
  return request({
    url: '/system/auditInfo/group',
    method: 'get',
    params: query
  })
}
