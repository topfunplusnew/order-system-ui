import request from '@/utils/request';

// 查询商业票据、银行承兑列表
export function listBankAcceptance(query) {
	return request({
		url: '/system/bankAcceptance/list',
		method: 'get',
		params: query
	});
}

export function listBankAcceptanceAll(query) {
	return request({
		// url: '/system/bankAcceptance/list',
		url: '/system/bankAcceptance/listAll',
		method: 'get',
		params: query
	});
}

// 查询商业票据、银行承兑详细
export function getBankAcceptance(id) {
	return request({
		url: '/system/bankAcceptance/' + id,
		method: 'get'
	});
}

// 新增商业票据、银行承兑
export function addBankAcceptance(data) {
	return request({
		url: '/system/bankAcceptance',
		method: 'post',
		data: data
	});
}

// 修改商业票据、银行承兑
export function updateBankAcceptance(data) {
	return request({
		url: '/system/bankAcceptance',
		method: 'put',
		data: data
	});
}

// 删除商业票据、银行承兑
export function delBankAcceptance(id) {
	return request({
		url: '/system/bankAcceptance/' + id,
		method: 'delete'
	});
}

// 带有票据余额的list
export function listBankAcceptanceBalanceMoney(query) {
	return request({
		url: '/system/bankAcceptance/listDetail',
		method: 'get',
		params: query
	});
}

// 根据票据号码查询最小id记录
export function getMinIdByBillNo(billNo) {
	return request({
		url: '/system/bankAcceptance/getMinIdByBillNo',
		method: 'get',
		params: {
			billNo: billNo
		}
	});
}

// 查询商业票据、银行承兑汇总信息
export function getBankAcceptanceSummary(id) {
	return request({
		url: '/system/bankAcceptance/summary/' + id,
		method: 'get'
	});
}
