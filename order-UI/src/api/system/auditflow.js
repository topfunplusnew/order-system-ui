import request from '@/utils/request'

// 查询审核流程列表
export function listAuditflow(query) {
  return request({
    url: '/system/auditflow/list',
    method: 'get',
    params: query
  })
}

// 查询审核流程详细
export function getAuditflow(id) {
  return request({
    url: '/system/auditflow/' + id,
    method: 'get'
  })
}

// 新增审核流程
export function addAuditflow(data) {
  return request({
    url: '/system/auditflow',
    method: 'post',
    data: data
  })
}

// 修改审核流程
export function updateAuditflow(data) {
  return request({
    url: '/system/auditflow',
    method: 'put',
    data: data
  })
}

// 删除审核流程
export function delAuditflow(id) {
  return request({
    url: '/system/auditflow/' + id,
    method: 'delete'
  })
}
