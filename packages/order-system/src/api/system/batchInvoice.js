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

export function importBatchInvoiceInData(data) {
	return request({
		url: `${BASE_IN}/importData`,
		method: 'post',
		data
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

export function importBatchInvoiceOutData(data) {
	return request({
		url: `${BASE_OUT}/importData`,
		method: 'post',
		data
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
