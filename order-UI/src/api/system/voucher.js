import request from '@/utils/request';

// 查询凭证列表
export function listVoucher(query) {
	return request({
		url: '/system/voucher/list',
		method: 'get',
		params: query
	});
}

// 查询凭证详细
export function getVoucher(id) {
	return request({
		url: '/system/voucher/' + id,
		method: 'get'
	});
}

// 新增凭证
export function addVoucher(data) {
	return request({
		url: '/system/voucher',
		method: 'post',
		data: data
	});
}

// 修改凭证
export function updateVoucher(data) {
	return request({
		url: '/system/voucher',
		method: 'put',
		data: data
	});
}

// 删除凭证
export function delVoucher(id) {
	return request({
		url: '/system/voucher/' + id,
		method: 'delete'
	});
}

// 批量新增凭证
export function addVoucherBatch(data) {
	return request({
		url: '/system/voucher/batch',
		method: 'post',
		data: data
	});
}
