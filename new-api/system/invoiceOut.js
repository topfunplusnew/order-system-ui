import request from '@/utils/request'

// 查询发票卖出信息列表
export function listInvoiceOut(query) {
  return request({
    url: '/system/invoiceOut/list',
    method: 'get',
    params: query
  })
}

// 查询发票卖出信息详细
export function getInvoiceOut(id) {
  return request({
    url: '/system/invoiceOut/' + id,
    method: 'get'
  })
}

// 新增发票卖出信息
export function addInvoiceOut(data) {
  return request({
    url: '/system/invoiceOut',
    method: 'post',
    data: data
  })
}

// 修改发票卖出信息
export function updateInvoiceOut(data) {
  return request({
    url: '/system/invoiceOut',
    method: 'put',
    data: data
  })
}

// 删除发票卖出信息
export function delInvoiceOut(id) {
  return request({
    url: '/system/invoiceOut/' + id,
    method: 'delete'
  })
}
