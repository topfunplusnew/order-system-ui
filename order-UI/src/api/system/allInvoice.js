import request from '@/utils/request';

export function listInvoiceAll(query) {
  return request({
    url: '/system/allinvoice/list',
    method: 'get',
    params: query
  })
}
