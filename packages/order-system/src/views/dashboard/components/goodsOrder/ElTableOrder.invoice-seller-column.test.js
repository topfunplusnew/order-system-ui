/*
 * 用户需求：客户开票记录、供应商开票记录弹窗各增加一个“销方”列。
 * 实际改动：客户开票记录取开票方 invoiceObject，供应商开票记录取票据单位名称 invoiceCompanyName（缺失回退供应商名称）。
 */
/* global describe, test, expect */
import fs from 'fs';
import path from 'path';

describe('ElTableOrder 开票记录弹窗销方列', () => {
	const componentPath = path.resolve(__dirname, './ElTableOrder.vue');
	const source = fs.readFileSync(componentPath, 'utf8');

	/**
	 * 截取指定弹窗模板片段，避免两个弹窗的同名列互相干扰
	 * @param {string} startMark - 弹窗起始标记
	 * @param {string} endMark - 弹窗结束标记
	 * @returns {string} 弹窗模板片段
	 */
	const sliceDialog = (startMark, endMark) => {
		const start = source.indexOf(startMark);
		const end = source.indexOf(endMark, start);
		expect(start).toBeGreaterThan(-1);
		expect(end).toBeGreaterThan(start);
		return source.slice(start, end);
	};

	/**
	 * 截取“销方”列整段模板（含开标签属性）
	 * @param {string} dialogSource - 弹窗模板片段
	 * @returns {string} 销方列模板片段
	 */
	const sliceSellerColumn = dialogSource => {
		const labelIndex = dialogSource.indexOf('label="销方"');
		expect(labelIndex).toBeGreaterThan(-1);
		const columnStart = dialogSource.lastIndexOf('<el-table-column', labelIndex);
		expect(columnStart).toBeGreaterThan(-1);
		return dialogSource.slice(columnStart, dialogSource.indexOf('</el-table-column>', columnStart));
	};

	test('客户开票记录弹窗的销方取 invoiceObject', () => {
		const dialogSource = sliceDialog('title="客户开票记录"', 'title="供应商开票记录"');
		const columnSource = sliceSellerColumn(dialogSource);

		expect(columnSource).toContain('prop="invoiceObject"');
		expect(columnSource).toContain('scope.row.invoiceObject');
	});

	test('供应商开票记录弹窗的销方取 invoiceCompanyName，缺失时回退供应商名称', () => {
		const dialogSource = sliceDialog('title="供应商开票记录"', 'title="导入结果"');
		const columnSource = sliceSellerColumn(dialogSource);

		expect(columnSource).toContain('prop="invoiceCompanyName"');
		expect(columnSource).toContain('scope.row.invoiceCompanyName || scope.row.companyName ||');
	});

	test('两个弹窗的销方列都排在对方公司名称列之后，且不影响既有列', () => {
		const customerDialog = sliceDialog('title="客户开票记录"', 'title="供应商开票记录"');
		const supplierDialog = sliceDialog('title="供应商开票记录"', 'title="导入结果"');

		// 销方列紧随客户名称/供应商名称列
		expect(customerDialog.indexOf('label="客户名称"')).toBeLessThan(customerDialog.indexOf('label="销方"'));
		expect(supplierDialog.indexOf('label="供应商名称"')).toBeLessThan(supplierDialog.indexOf('label="销方"'));

		// 既有列保持不变
		['需开票金额', '开票时间', '开票金额', '累计开票金额'].forEach(label => {
			expect(customerDialog).toContain(`label="${label}"`);
			expect(supplierDialog).toContain(`label="${label}"`);
		});
	});
});
