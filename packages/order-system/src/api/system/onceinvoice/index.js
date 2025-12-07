import request from '@/utils/request';

const BASE_IN = '/system/batchInvoiceIn';
const BASE_OUT = '/system/batchInvoiceOut';

function encode(value) {
	return encodeURIComponent(value);
}

// -------- 进项批量开票 --------

/**
 * 查询批量进项票导入记录列表
 * @param {Object} query - 查询参数
 * @param {string} query.voucher - 凭证号模糊查询，支持多批次同号的集中管理
 * @param {string} query.sellerName - 销方名称模糊查询
 * @param {string} query.buyerName - 购买方名称模糊查询
 * @param {boolean} query.invoiced - 是否已被业务单据引用，true 表示已经使用 也就是说被开票了，不传入则不筛选
 * @param {string} query.pageSize - 每页数量
 * @returns {Promise} 返回查询结果
 */
export function listBatchInvoiceIn(query) {
	return request({
		url: `${BASE_IN}/list`,
		method: 'get',
		params: query
	});
}

/**
 * 导入批量进项票数据
 * @param {FormData} data - 表单数据，包含 file 字段（批量进项票导入模板，格式支持 .xlsx/.xls）
 * @returns {Promise} 返回导入结果，包含 success、voucher、successCount、failedCount、message
 */
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

/**
 * 下载批量进项票导入模板
 * @returns {Promise} 返回 Excel 文件流
 */
export function downloadBatchInvoiceInTemplate() {
	return request({
		url: `${BASE_IN}/importTemplate`,
		method: 'post',
		responseType: 'blob'
	});
}

/**
 * 根据凭证号整批删除临时导入的进项票记录
 * @param {string} voucher - 批量导入生成的凭证号，会自动删除已经开票的invocicexx的记录
 * @returns {Promise} 返回删除结果
 */
export function deleteBatchInvoiceInByVoucher(voucher) {
	return request({
		url: `${BASE_IN}/${encode(voucher)}`,
		method: 'delete'
	});
}

/**
 * 根据ID删除进项票导入记录
 * @param {number} id - 记录ID
 * @returns {Promise} 返回删除结果
 */
export function deleteBatchInvoiceInById(id) {
	return request({
		url: `${BASE_IN}/id/${encode(id)}`,
		method: 'delete'
	});
}

/**
 * 删除对应的invoice票，不删除导入的信息
 * @param {number} invoiceId - 发票ID
 * @returns {Promise} 返回删除结果
 */
export function deleteBatchInvoiceInInvoice(invoiceId) {
	return request({
		url: `${BASE_IN}/invoice/${encode(invoiceId)}`,
		method: 'delete'
	});
}

// -------- 销项批量开票 --------

/**
 * 查询批量销项票导入记录列表
 * @param {Object} query - 查询参数
 * @param {string} query.voucher - 凭证号模糊查询，支持定位批量导入记录
 * @param {string} query.sellerName - 销方名称模糊查询
 * @param {string} query.buyerName - 购买方名称模糊查询
 * @param {boolean} query.invoiced - 是否已被业务单据引用，true 表示已经使用 也就是说被开票了，不传入则不筛选
 * @param {string} query.pageSize - 每页数量
 * @returns {Promise} 返回查询结果
 */
export function listBatchInvoiceOut(query) {
	return request({
		url: `${BASE_OUT}/list`,
		method: 'get',
		params: query
	});
}

/**
 * 导入批量销项票数据
 * @param {FormData} data - 表单数据，包含 file 字段（批量销项票导入模板，格式支持 .xlsx/.xls）
 * @returns {Promise} 返回导入结果，包含 success、voucher、successCount、failedCount、message
 */
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

/**
 * 下载批量销项票导入模板
 * @returns {Promise} 返回 Excel 文件流
 */
export function downloadBatchInvoiceOutTemplate() {
	return request({
		url: `${BASE_OUT}/importTemplate`,
		method: 'post',
		responseType: 'blob'
	});
}

/**
 * 根据凭证号整批删除临时导入的销项票记录
 * @param {string} voucher - 批量导入生成的凭证号
 * @returns {Promise} 返回删除结果
 */
export function deleteBatchInvoiceOutByVoucher(voucher) {
	return request({
		url: `${BASE_OUT}/${encode(voucher)}`,
		method: 'delete'
	});
}

/**
 * 根据ID删除销项票导入记录
 * @param {number} id - 记录ID
 * @returns {Promise} 返回删除结果
 */
export function deleteBatchInvoiceOutById(id) {
	return request({
		url: `${BASE_OUT}/id/${encode(id)}`,
		method: 'delete'
	});
}

/**
 * 删除对应的invoice票，不删除导入的信息
 * @param {number} invoiceId - 发票ID
 * @returns {Promise} 返回删除结果
 */
export function deleteBatchInvoiceOutInvoice(invoiceId) {
	return request({
		url: `${BASE_OUT}/invoice/${encode(invoiceId)}`,
		method: 'delete'
	});
}

