import request from '@/utils/request'

// 查询社保基金列表
export function listSocialinsurance(query) {
  return request({
    url: '/system/socialinsurance/list',
    method: 'get',
    params: query
  })
}

// 查询社保基金详细
export function getSocialinsurance(id) {
  return request({
    url: '/system/socialinsurance/' + id,
    method: 'get'
  })
}

// 新增社保基金
export function addSocialinsurance(data) {
  return request({
    url: '/system/socialinsurance',
    method: 'post',
    data: data
  })
}

// 修改社保基金
export function updateSocialinsurance(data) {
  return request({
    url: '/system/socialinsurance',
    method: 'put',
    data: data
  })
}

// 删除社保基金
export function delSocialinsurance(id) {
  return request({
    url: '/system/socialinsurance/' + id,
    method: 'delete'
  })
}
