/*
 * 用户需求：选完订单开票后，列表里的时间（开票时间 / 公司列表的时间列）要填充上。
 * 实际改动：开票成功广播 batch-invoice:succeeded（携带发票的 batchInvoiceId、invoiceDate），
 *          批次面板据此把开票时间回填到批次明细、顶部列表、公司列表，并记住映射以便后端刷新后继续回填。
 */
/* global describe, test, expect */
import fs from 'fs';
import path from 'path';

const readSource = relativePath => fs.readFileSync(path.resolve(__dirname, relativePath), 'utf8');

describe('开票成功后回填开票时间', () => {
	const panelSource = readSource('./BatchInvoicePanel.vue');
	const queueSource = readSource('./QueueInvoiceList.vue');
	const storeSource = readSource('../../../../store/modules/excel.js');

	test('开票成功时广播本批发票，且发生在清理开票列表之前', () => {
		const emitIndex = queueSource.indexOf("this.$bus.$emit('batch-invoice:succeeded', filteredInvoices.slice());");
		expect(emitIndex).toBeGreaterThan(-1);
		// 必须在清空 selectedInvoiceList 之前广播，否则拿不到发票的 batchInvoiceId 与 invoiceDate
		expect(emitIndex).toBeLessThan(queueSource.indexOf('excel/clearSelectedInvoiceList'));
	});

	test('批次面板监听并正确处理回填（明细 + 顶部列表 + 公司列表 + Vuex）', () => {
		expect(panelSource).toContain("this.$bus.$on('batch-invoice:succeeded', this.handleBatchInvoiceSucceeded)");
		expect(panelSource).toContain("this.$bus.$off('batch-invoice:succeeded', this.handleBatchInvoiceSucceeded)");

		const handlerStart = panelSource.indexOf('handleBatchInvoiceSucceeded(invoices) {');
		expect(handlerStart).toBeGreaterThan(-1);
		const handlerSource = panelSource.slice(handlerStart, panelSource.indexOf('\n\t\t},', handlerStart));

		expect(handlerSource).toContain('buildInvoiceDateByBatchRowId(invoices)');
		expect(handlerSource).toContain('this.invoiceDateFallback.set(id, invoiceDate)');
		// 本地明细、顶部列表写入开票时间
		expect(handlerSource).toContain('this.batchDetailRows = this.batchDetailRows.map(stampRow)');
		expect(handlerSource).toContain('this.batchList = this.batchList.map(stampRow)');
		// 同步 Vuex 并重新聚合公司列表（时间列由此填充/拆分）
		expect(handlerSource).toContain("this.$store.dispatch('excel/updateBatchRowInvoiced'");
		expect(handlerSource).toContain('this.processAndAggregateData(this.batchDetailRows)');
	});

	test('后端刷新后仍能回填（批次明细映射 + 顶部列表）', () => {
		expect(panelSource).toContain('invoiceDate: item.invoiceDate || (item.invoiced ? this.invoiceDateFallback.get(item.id) : null) || null');
		expect(panelSource).toContain('withFallbackInvoiceDate(row, this.invoiceDateFallback)');
	});

	test('Vuex 批次行更新支持写入开票时间', () => {
		expect(storeSource).toContain('UPDATE_BATCH_ROW_INVOICED: (state, { id, invoiced, invoiceId, invoiceDate })');
		expect(storeSource).toContain('row.invoiceDate = invoiceDate;');
	});
});
