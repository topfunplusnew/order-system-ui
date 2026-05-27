const fs = require('fs');
const path = require('path');
const { describe, expect, test } = require('@jest/globals');

const trailingAuditColumnProps = ['id', 'addtime', 'updateTime', 'userName', 'updateByUserName'];
const utilityLabels = new Set(['操作', '附件', '银行卡流水附件', '复核状态', '返利流水']);

const tableFiles = ['receiveMoney/index.vue', 'payment/index.vue', 'record/index.vue', 'rebate/index.vue', 'noneInvoice/InvoiceIn.vue', 'noneInvoice/InvoiceOut.vue', 'invoiceOther/invoicehave.vue', 'invoiceOther/index.vue'];

function getStaticAttr(attrs, name) {
	const match = attrs.match(new RegExp(`\\s${name}="([^"]+)"`));
	return match ? match[1] : '';
}

function getMainTableColumns(filePath) {
	const source = fs.readFileSync(filePath, 'utf8');
	const tableStart = source.indexOf('<el-table');
	const tableEnd = source.indexOf('</el-table>', tableStart);

	if (tableStart === -1 || tableEnd === -1) {
		throw new Error(`No main el-table found in ${filePath}`);
	}

	const tableSource = source.slice(tableStart, tableEnd);
	return Array.from(tableSource.matchAll(/<(?:el-table-column|VirtualColumn)\b([\s\S]*?)(?:\/>|>)/g)).map(match => {
		const attrs = match[1];
		return {
			label: getStaticAttr(attrs, 'label'),
			prop: getStaticAttr(attrs, 'prop')
		};
	});
}

describe('system list audit columns', () => {
	test.each(tableFiles)('%s keeps ID as the first of the last five audit columns', relativeFile => {
		const filePath = path.resolve(__dirname, relativeFile);
		const dataColumns = getMainTableColumns(filePath).filter(column => column.prop && !utilityLabels.has(column.label));
		const props = dataColumns.map(column => column.prop);

		for (const prop of trailingAuditColumnProps) {
			expect(props.filter(item => item === prop)).toHaveLength(1);
		}

		expect(props.slice(-trailingAuditColumnProps.length)).toEqual(trailingAuditColumnProps);
	});
});
