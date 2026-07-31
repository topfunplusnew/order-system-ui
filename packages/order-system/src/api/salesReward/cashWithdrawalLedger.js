/* 用户需求：访问 Apifox 中转 、支现金台账 Controller 的相关接口。实际改动：封装列表、详情、新增、修改、附件完整替换、删除、审核及 XLSX 导出请求。 */
import request from '@/utils/request';

export function listCashWithdrawalLedger(query) {
	return request({ url: '/system/cashWithdrawalLedger/list', method: 'get', params: query });
}

export function getCashWithdrawalLedger(id) {
	return request({ url: `/system/cashWithdrawalLedger/${id}`, method: 'get' });
}

export function addCashWithdrawalLedger(data) {
	return request({ url: '/system/cashWithdrawalLedger', method: 'post', data });
}

export function updateCashWithdrawalLedger(data) {
	return request({ url: '/system/cashWithdrawalLedger', method: 'put', data });
}

export function replaceCashWithdrawalLedgerAttachments(data) {
	return request({ url: '/system/cashWithdrawalLedger/attachments', method: 'put', data });
}

export function delCashWithdrawalLedger(ids) {
	const serializedIds = Array.isArray(ids) ? ids.join(',') : ids;
	return request({ url: `/system/cashWithdrawalLedger/${serializedIds}`, method: 'delete' });
}

export function auditCashWithdrawalLedger(id, approved) {
	return request({ url: `/system/cashWithdrawalLedger/audit/${id}`, method: 'put', params: { approved } });
}

export function exportCashWithdrawalLedger(query) {
	return request({ url: '/system/cashWithdrawalLedger/export', method: 'post', params: query, responseType: 'blob' });
}
