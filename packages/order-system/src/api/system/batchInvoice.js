import request from '@/utils/request';

const BASE_IN = '/system/batchInvoiceIn';
const BASE_OUT = '/system/batchInvoiceOut';

function encode(value) {
	return encodeURIComponent(value);
}

// -------- 进项批量开票 --------

export function listBatchInvoiceIn(query) {
	return request({
		url: `${BASE_IN}/list`,
		method: 'get',
		params: query
	});
}

// 获取进项批量开票的公司聚合信息
export function getBatchInvoiceInCompanySummary(voucher) {
	return request({
		url: `${BASE_IN}/companySummary/${encode(voucher)}`,
		method: 'get'
	});
}

// 更新进项批量开票记录的开票状态
export function updateBatchInvoiceInInvoiced(id, invoiced, invoiceId = null) {
	return request({
		url: `${BASE_IN}/updateInvoiced`,
		method: 'put',
		data: { id, invoiced, invoiceId }
	});
}

// 批量更新进项开票记录的开票状态
export function batchUpdateBatchInvoiceInInvoiced(ids, invoiced, invoiceIds = []) {
	return request({
		url: `${BASE_IN}/batchUpdateInvoiced`,
		method: 'put',
		data: { ids, invoiced, invoiceIds }
	});
}

export function importBatchInvoiceInData(data) {
	return request({
		url: `${BASE_IN}/importData`,
		method: 'post',
		data,
		headers: {
			'Content-Type': 'multipart/form-data'
		}
	});
}

export function downloadBatchInvoiceInTemplate() {
	return request({
		url: `${BASE_IN}/importTemplate`,
		method: 'post',
		responseType: 'blob'
	});
}

export function deleteBatchInvoiceInByVoucher(voucher) {
	return request({
		url: `${BASE_IN}/${encode(voucher)}`,
		method: 'delete'
	});
}

export function deleteBatchInvoiceInById(id) {
	return request({
		url: `${BASE_IN}/id/${encode(id)}`,
		method: 'delete'
	});
}

export function deleteBatchInvoiceInInvoice(invoiceId) {
	return request({
		url: `${BASE_IN}/invoice/${encode(invoiceId)}`,
		method: 'delete'
	});
}

// -------- 销项批量开票 --------

export function listBatchInvoiceOut(query) {
	return request({
		url: `${BASE_OUT}/list`,
		method: 'get',
		params: query
	});
}

// 获取销项批量开票的公司聚合信息
export function getBatchInvoiceOutCompanySummary(voucher) {
	return request({
		url: `${BASE_OUT}/companySummary/${encode(voucher)}`,
		method: 'get'
	});
}

// 更新销项批量开票记录的开票状态
export function updateBatchInvoiceOutInvoiced(id, invoiced, invoiceId = null) {
	return request({
		url: `${BASE_OUT}/updateInvoiced`,
		method: 'put',
		data: { id, invoiced, invoiceId }
	});
}

// 批量更新销项开票记录的开票状态
export function batchUpdateBatchInvoiceOutInvoiced(ids, invoiced, invoiceIds = []) {
	return request({
		url: `${BASE_OUT}/batchUpdateInvoiced`,
		method: 'put',
		data: { ids, invoiced, invoiceIds }
	});
}

export function importBatchInvoiceOutData(data) {
	return request({
		url: `${BASE_OUT}/importData`,
		method: 'post',
		data,
		headers: {
			'Content-Type': 'multipart/form-data'
		}
	});
}

export function downloadBatchInvoiceOutTemplate() {
	return request({
		url: `${BASE_OUT}/importTemplate`,
		method: 'post',
		responseType: 'blob'
	});
}

export function deleteBatchInvoiceOutByVoucher(voucher) {
	return request({
		url: `${BASE_OUT}/${encode(voucher)}`,
		method: 'delete'
	});
}

export function deleteBatchInvoiceOutById(id) {
	return request({
		url: `${BASE_OUT}/id/${encode(id)}`,
		method: 'delete'
	});
}

export function deleteBatchInvoiceOutInvoice(invoiceId) {
	return request({
		url: `${BASE_OUT}/invoice/${encode(invoiceId)}`,
		method: 'delete'
	});
}
