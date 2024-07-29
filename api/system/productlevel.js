import request from '@/utils/request'

// 查询产品级别管理列表
export function listProductlevel(query) {
  return request({
    url: '/system/productlevel/list',
    method: 'get',
    params: query
  })
}

// 查询产品级别管理详细
export function getProductlevel(id) {
  return request({
    url: '/system/productlevel/' + id,
    method: 'get'
  })
}

// 新增产品级别管理
export function addProductlevel(data) {
  return request({
    url: '/system/productlevel',
    method: 'post',
    data: data
  })
}

// 修改产品级别管理
export function updateProductlevel(data) {
  return request({
    url: '/system/productlevel',
    method: 'put',
    data: data
  })
}

// 删除产品级别管理
export function delProductlevel(id) {
  return request({
    url: '/system/productlevel/' + id,
    method: 'delete'
  })
}
