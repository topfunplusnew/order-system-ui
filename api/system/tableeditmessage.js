import request from '@/utils/request'

// 查询变动日志信息列表
export function listTableeditmessage(query) {
  return request({
    url: '/system/tableeditmessage/list',
    method: 'get',
    params: query
  })
}

// 查询变动日志信息详细
export function getTableeditmessage(id) {
  return request({
    url: '/system/tableeditmessage/' + id,
    method: 'get'
  })
}

// 新增变动日志信息
export function addTableeditmessage(data) {
  return request({
    url: '/system/tableeditmessage',
    method: 'post',
    data: data
  })
}

// 修改变动日志信息
export function updateTableeditmessage(data) {
  return request({
    url: '/system/tableeditmessage',
    method: 'put',
    data: data
  })
}

// 删除变动日志信息
export function delTableeditmessage(id) {
  return request({
    url: '/system/tableeditmessage/' + id,
    method: 'delete'
  })
}
