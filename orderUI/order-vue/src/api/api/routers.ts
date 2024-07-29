import { instance } from '../http/http.ts'

// 获取路由
export const getRouters = () => {
  return instance({
    url: '/getRouters',
    method: 'get',
  })
}
