/**
 * 批量开票【公司列表】：开票时间（invoiceDate）拆分与搜索相关工具
 * 需求：公司列表增加时间列，数据按 invoiceDate 再拆分，并支持按 invoiceDate 搜索。
 */

/**
 * 归一化开票时间为日期（yyyy-MM-dd）
 * invoiceDate 可能带时分秒（如 2024-07-27 10:23:45），统一按天拆分与展示
 * @param {*} value - 原始开票时间
 * @returns {string} yyyy-MM-dd，无值时返回空字符串
 */
export function normalizeInvoiceDate(value) {
	if (value === null || value === undefined || value === '') {
		return '';
	}
	const text = String(value).trim();
	if (!text) {
		return '';
	}
	const matched = text.match(/^(\d{4})[-/](\d{1,2})[-/](\d{1,2})/);
	if (!matched) {
		return text;
	}
	const [, year, month, day] = matched;
	return `${year}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
}

/**
 * 公司列表聚合唯一键：对方公司ID + 我方公司 + 开票日期
 * 同一公司同一我方公司，不同开票日期（含未开票的空日期）拆分为多行
 * @param {string|number} companyId - 对方公司ID
 * @param {string} us - 我方公司名称
 * @param {*} invoiceDate - 开票时间
 * @returns {string} 聚合唯一键
 */
export function buildCompanyRowKey(companyId, us, invoiceDate) {
	return [companyId, us || '', normalizeInvoiceDate(invoiceDate)].join('::');
}

/**
 * 判断开票时间是否落在搜索日期范围内（含边界）
 * @param {*} invoiceDate - 开票时间
 * @param {Array<string>} range - [开始日期, 结束日期]，未选择时返回 true
 * @returns {boolean} 是否属于该范围；范围有效但没有开票时间的记录返回 false
 */
export function isInvoiceDateInRange(invoiceDate, range) {
	if (!Array.isArray(range) || range.length < 2 || !range[0] || !range[1]) {
		return true;
	}
	const date = normalizeInvoiceDate(invoiceDate);
	if (!date) {
		return false;
	}
	const start = normalizeInvoiceDate(range[0]);
	const end = normalizeInvoiceDate(range[1]);
	if (start && date < start) {
		return false;
	}
	if (end && date > end) {
		return false;
	}
	return true;
}
