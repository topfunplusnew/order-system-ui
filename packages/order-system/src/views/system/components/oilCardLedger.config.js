/* 用户需求：创建主卡登记与副卡登记页面并严格区分字段和提交规则。实际改动：集中定义主副卡列、查询导出参数、请求白名单和删除ID序列化逻辑。 */
const SHARED_COLUMNS = [
	{ label: '加油卡卡号', prop: 'oilCardNo', path: ['oilCard', 'oilCardNo'], minWidth: 150 },
	{ label: '使用加油卡时间', prop: 'useDate', minWidth: 170 },
	{ label: '使用加油卡车辆车牌号', prop: 'licensePlate', path: ['vehicle', 'licensePlate'], minWidth: 180 },
	{ label: '地点、事由', prop: 'locationReason', minWidth: 180 },
	{ label: '期初余额', prop: 'openingBalance', minWidth: 110 },
	{ label: 'transferAmount', prop: 'transferAmount', minWidth: 190 },
	{ label: '加油量（升）', prop: 'refuelingVolume', minWidth: 120 },
	{ label: '单价', prop: 'unitPrice', minWidth: 90 },
	{ label: 'refuelingAmount', prop: 'refuelingAmount', minWidth: 130 },
	{ label: '是否有小票', prop: 'hasReceipt', minWidth: 110 },
	{ label: '加油卡余额', prop: 'closingBalance', minWidth: 120 },
	{ label: '备注', prop: 'comments', minWidth: 160 }
];

const PAYLOAD_FIELDS = ['oilCardId', 'useDate', 'vehicleId', 'locationReason', 'rechargeAmount', 'openingBalance', 'transferAmount', 'refuelingVolume', 'unitPrice', 'refuelingAmount', 'hasReceipt', 'closingBalance', 'comments'];

const trimValue = value => (typeof value === 'string' ? value.trim() : value);
const hasValue = value => value !== undefined && value !== null && value !== '';

export function buildLedgerColumns(cardType) {
	const columns = SHARED_COLUMNS.map(column => ({ ...column }));
	columns.find(column => column.prop === 'transferAmount').label = cardType === '主卡' ? '主卡转副卡充值金额' : '主卡转副卡圈存金额';
	columns.find(column => column.prop === 'refuelingAmount').label = cardType === '主卡' ? '金额(元）' : '加油金额(元）';

	if (cardType === '主卡') {
		columns.splice(4, 0, { label: '充值金额', prop: 'rechargeAmount', minWidth: 110 });
	}

	return columns;
}

export function buildLedgerQuery(queryParams, cardType, dateRange = []) {
	const params = {
		cardType,
		pageNum: queryParams.pageNum,
		pageSize: queryParams.pageSize
	};
	const fieldMap = {
		oilCardNo: 'params[oilCardNo]',
		licensePlate: 'params[licensePlate]',
		hasReceipt: 'hasReceipt',
		locationReason: 'locationReason'
	};

	Object.keys(fieldMap).forEach(field => {
		const value = trimValue(queryParams[field]);
		if (hasValue(value)) params[fieldMap[field]] = value;
	});

	if (dateRange[0]) params['params[beginTime]'] = dateRange[0];
	if (dateRange[1]) params['params[endTime]'] = dateRange[1];

	return params;
}

export function buildLedgerExportParams(queryParams, cardType, dateRange = []) {
	const params = buildLedgerQuery(queryParams, cardType, dateRange);
	delete params.pageNum;
	delete params.pageSize;
	return params;
}

export function buildLedgerPayload(form, cardType, includeId) {
	const payload = {};
	if (includeId && hasValue(form.id)) payload.id = form.id;

	PAYLOAD_FIELDS.forEach(field => {
		if (field === 'rechargeAmount' && cardType !== '主卡') return;
		if (form[field] !== undefined) payload[field] = form[field];
	});

	return payload;
}

export function serializeLedgerIds(ids) {
	return (Array.isArray(ids) ? ids : [ids]).join(',');
}

export function getLedgerCellValue(row, column) {
	if (!column.path) return row[column.prop];
	return column.path.reduce((value, key) => (value == null ? value : value[key]), row);
}
