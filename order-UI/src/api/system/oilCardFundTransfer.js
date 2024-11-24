import request from '@/utils/request';

// 查询加油卡圈存列表
export function listOilCardFundTransfer(query) {
  return request({
    url: '/system/oilCardFundTransfer/list',
    method: 'get',
    params: query,
  });
}

// 查询加油卡圈存详细
export function getOilCardFundTransfer(id) {
  return request({
    url: '/system/oilCardFundTransfer/' + id,
    method: 'get',
  });
}

// 新增加油卡圈存
export function addOilCardFundTransfer(data) {
  return request({
    url: '/system/oilCardFundTransfer',
    method: 'post',
    data: data,
  });
}

// 修改加油卡圈存
export function updateOilCardFundTransfer(data) {
  return request({
    url: '/system/oilCardFundTransfer',
    method: 'put',
    data: data,
  });
}

// 删除加油卡圈存
export function delOilCardFundTransfer(id) {
  return request({
    url: '/system/oilCardFundTransfer/' + id,
    method: 'delete',
  });
}
