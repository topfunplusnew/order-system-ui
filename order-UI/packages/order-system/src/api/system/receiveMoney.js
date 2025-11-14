import request from '@/utils/request';

// 查询收款信息列表
export function listReceiveMoney(query) {
	return request({
		url: '/system/receiveMoney/list',
		method: 'get',
		params: query
	});
}

// 查询收款信息详细
export function getReceiveMoney(id) {
	return request({
		url: '/system/receiveMoney/' + id,
		method: 'get'
	});
}

// 新增收款信息
export function addReceiveMoney(data) {
	return request({
		url: '/system/receiveMoney',
		method: 'post',
		data: data
	});
}

// 修改收款信息
export function updateReceiveMoney(data) {
	return request({
		url: '/system/receiveMoney',
		method: 'put',
		data: data
	});
}

// 删除收款信息
export function delReceiveMoney(id) {
	return request({
		url: '/system/receiveMoney/' + id,
		method: 'delete'
	});
}

///system/receiveMoney/receiveNO/8dac7bfd-218a-4040-a0f5-af5172a87222
export function getReceiveMoneyByReceiveNO(receiveNO) {
	return request({
		url: '/system/receiveMoney/receiveNO/' + receiveNO,
		method: 'get'
	});
}

/**
 * 这个与上面接口有区别 需要改一下 只给报表使用
 * @param {*} receiveNO
 * @returns
 */
export function getReceiveMoneyByPayNo(receiveNO) {
	return request({
		url: '/system/receiveMoney/' + receiveNO,
		method: 'get'
	});
}

// 下载导入模板
export function downloadReceiveMoneyTemplate() {
	return request({
		url: '/system/receiveMoney/importTemplate',
		method: 'post',
		responseType: 'blob'
	});
}

// 导入收款数据
export function importReceiveMoneyData(formData) {
	return request({
		url: '/system/receiveMoney/importData',
		method: 'post',
		data: formData,
		headers: {
			'Content-Type': 'multipart/form-data'
		}
	});
}