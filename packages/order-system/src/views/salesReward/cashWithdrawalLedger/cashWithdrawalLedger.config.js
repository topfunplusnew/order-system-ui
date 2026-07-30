/* 用户需求：日期仅到年月日、账户手动输入，并严格遵循台账金额、附件和审核接口约定。实际改动：集中实现查询映射、导出过滤、金额校验、载荷白名单和附件 ID 处理。 */
const TEXT_QUERY_FIELDS = ['accountInfo', 'handlerName', 'purpose', 'auditState'];
const ATTACHMENT_FLAGS = ['withdrawalProof', 'otherAttachment'];

const trimOrUndefined = value => {
	if (value === null || value === undefined) return undefined;
	const trimmed = String(value).trim();
	return trimmed || undefined;
};

export function buildCashWithdrawalQuery(queryParams = {}, dateRange = []) {
	const query = {
		pageNum: queryParams.pageNum || 1,
		pageSize: queryParams.pageSize || 10
	};
	if (Array.isArray(dateRange) && dateRange.length === 2) {
		query.beginWithdrawalDate = dateRange[0];
		query.endWithdrawalDate = dateRange[1];
	}
	TEXT_QUERY_FIELDS.forEach(field => {
		const value = trimOrUndefined(queryParams[field]);
		if (value !== undefined) query[field] = value;
	});
	return query;
}

export function buildCashWithdrawalExportParams(queryParams = {}, dateRange = []) {
	const query = buildCashWithdrawalQuery(queryParams, dateRange);
	delete query.pageNum;
	delete query.pageSize;
	return query;
}

export function isValidCashWithdrawalAmount(value) {
	const text = String(value === null || value === undefined ? '' : value).trim();
	if (!/^(?:0|[1-9]\d{0,19})(?:\.\d{1,8})?$/.test(text)) return false;
	return !/^0(?:\.0{1,8})?$/.test(text);
}

export function buildCashWithdrawalPayload(form = {}, isEdit = false) {
	const payload = {
		withdrawalDate: form.withdrawalDate,
		amount: Number(String(form.amount).trim()),
		accountInfo: String(form.accountInfo || '').trim(),
		handlerName: String(form.handlerName || '').trim(),
		purpose: String(form.purpose || '').trim(),
		remark: trimOrUndefined(form.remark) || null
	};
	if (isEdit) {
		payload.id = form.id;
	} else {
		const ids = form.params && Array.isArray(form.params.attachmentIds) ? [...new Set(form.params.attachmentIds)] : [];
		payload.params = { attachmentIds: ids };
	}
	return isEdit ? { id: payload.id, withdrawalDate: payload.withdrawalDate, amount: payload.amount, accountInfo: payload.accountInfo, handlerName: payload.handlerName, purpose: payload.purpose, remark: payload.remark } : payload;
}

export function groupCashWithdrawalAttachments(attachmentList = []) {
	return {
		withdrawalProof: attachmentList.filter(item => item && item.flag === 'withdrawalProof'),
		otherAttachment: attachmentList.filter(item => item && item.flag === 'otherAttachment')
	};
}

export function mergeCashWithdrawalAttachmentIds(attachmentList = []) {
	return [
		...new Set(
			attachmentList
				.filter(item => item && ATTACHMENT_FLAGS.includes(item.flag))
				.map(item => item.id)
				.filter(id => id !== null && id !== undefined)
		)
	];
}

export function serializeCashWithdrawalIds(ids) {
	return Array.isArray(ids) ? ids.join(',') : String(ids);
}
