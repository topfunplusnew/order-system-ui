import request from '@/utils/request'

// 查询虚拟银行账户变动信息列表
export function listVirtualbankaccountchange(query) {
  return request({
    url: '/system/virtualbankaccountchange/list',
    method: 'get',
    params: query
  })
}

// 查询虚拟银行账户变动信息详细
export function getVirtualbankaccountchange(id) {
  return request({
    url: '/system/virtualbankaccountchange/' + id,
    method: 'get'
  })
}

// 新增虚拟银行账户变动信息
export function addVirtualbankaccountchange(data) {
  return request({
    url: '/system/virtualbankaccountchange',
    method: 'post',
    data: data
  })
}

// 修改虚拟银行账户变动信息
export function updateVirtualbankaccountchange(data) {
  return request({
    url: '/system/virtualbankaccountchange',
    method: 'put',
    data: data
  })
}

// 删除虚拟银行账户变动信息
export function delVirtualbankaccountchange(id) {
  return request({
    url: '/system/virtualbankaccountchange/' + id,
    method: 'delete'
  })
}
