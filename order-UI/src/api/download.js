import request from "@/utils/request";

export function downloadFile(params) {
  return request({
    url: '/common/download',
    method: 'GET',
    params: params,
  })
}
