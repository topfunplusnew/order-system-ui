/**
 * 变更记录（每次需求变更在此追加，最新在上；格式：日期 - 改了什么）：
 * - [2026-08-16] 修复：票点修改变动统计中「我方主体」与「开票单位名称」字段映射取反。
 *   - selfSubject(我方主体)：fallback 链由错误的 invoiceCompanyName 改为 invoiceObject（对照 allinvoice 页面：我方主体=invoiceObject）；
 *   - incomeInvoiceUnit(开票单位名称)：单主体候选去掉 invoiceObject，改为 invoiceCompanyName 优先（对照 allinvoice 页面：开票单位名称=invoiceCompanyName）。
 */
import { format, subtract, add } from 'mathjs';

export const UNIFIED_TICKET_POINT_MODULE_KEY = 'allinvoice';
export const UNIFIED_TICKET_POINT_MODULE_LABEL = '发票往来';
export const TICKET_POINT_TABLE_NAMES = Object.freeze(['invoicein', 'invoiceout', 'invoiceother', UNIFIED_TICKET_POINT_MODULE_KEY]);

function firstDefined(...values) {
	return values.find(value => value !== undefined && value !== null && value !== '');
}

export function isUnifiedTicketPointTableName(tableName = '') {
	return TICKET_POINT_TABLE_NAMES.includes(tableName);
}

export function resolveTicketPointSummaryLabel(moduleName = '', summaryModuleLabel = '') {
	if (isUnifiedTicketPointTableName(moduleName)) return UNIFIED_TICKET_POINT_MODULE_LABEL;
	return summaryModuleLabel || UNIFIED_TICKET_POINT_MODULE_LABEL;
}

export function hasDualPartyTicketPointFields(info = {}) {
	return ['customerPointAmount', 'supplierPointAmount', 'customerTicketPoint', 'supplierTicketPoint', 'customer', 'Customer', 'Supplier', 'supplier'].some(key => info[key] !== undefined && info[key] !== null && info[key] !== '');
}

export function getSinglePartyTicketPoint(info = {}) {
	return firstDefined(info.ticketPoint, info.pointRate, info.customerTicketPoint, info.supplierTicketPoint, info.supplierPointRate, '');
}

export function getSinglePartyTicketPointAmount(info = {}) {
	return Number(firstDefined(info.ticketPointAmount, info.customerPointAmount, info.supplierPointAmount, 0) || 0);
}

export function formatTicketPointDiff(afterVal, beforeVal) {
	return format(subtract(Number(afterVal || 0), Number(beforeVal || 0)), { notation: 'fixed', precision: 2 });
}

export function mapTicketPointRecordToRow(info = {}) {
	const actualInvoiceDate = firstDefined(info.actualInvoiceDate, info.extraInfo?.actualInvoiceTime, '');
	const actualInvoiceAmount = firstDefined(info.actualInvoiceAmount, info.extraInfo?.actualInvoiceAmount, '');
	const monthlyDebt = firstDefined(info.monthlyDebt, info.currentMonthOweInvoiceAmount, info.extraInfo?.currentMonthOweInvoiceAmount, '');
	const remark = firstDefined(info.comments, info.remark, info.extraInfo?.comment, '');
	const selfSubject = firstDefined(info.selfSubject, info.selfCompanyName, info.invoiceObject, '');

	if (hasDualPartyTicketPointFields(info)) {
		const hasCustomerParty = Boolean(info.incomeCompanyType || info.customer || info.Customer || info.customerPointAmount != null || info.customerTicketPoint != null);
		const hasSupplierParty = Boolean(info.costCompanyType || info.Supplier || info.supplier || info.supplierPointAmount != null || info.supplierTicketPoint != null);
		const customerCompanyType = hasCustomerParty ? '客户' : '';
		const supplierCompanyType = hasSupplierParty ? '供应商' : '';
		return {
			status: '已开票',
			invoiceDate: info.invoiceDate ? String(info.invoiceDate).slice(0, 10) : '',
			selfSubject,
			invoiceAmount: info.invoiceAmount,
			incomeCompanyType: firstDefined(info.incomeCompanyType, customerCompanyType, ''),
			incomeCompanyName: firstDefined(info.customer, info.Customer, info.companyName, ''),
			incomeInvoiceUnit: firstDefined(info.invoiceUnitName, info.invoiceCompanyName, ''),
			incomePoint: firstDefined(info.customerTicketPoint, info.pointRate, info.ticketPoint, ''),
			incomePointAmount: firstDefined(info.customerPointAmount, info.ticketPointAmount, ''),
			isOrderTax: info.isOrderTax,
			costCompanyType: firstDefined(info.costCompanyType, supplierCompanyType, ''),
			costCompanyName: firstDefined(info.Supplier, info.supplier, ''),
			costInvoiceUnit: firstDefined(info.costInvoiceUnitName, ''),
			costPoint: firstDefined(info.supplierTicketPoint, info.supplierPointRate, ''),
			costPointAmount: firstDefined(info.supplierPointAmount, ''),
			pointDiff: firstDefined(info.pointAmountDifference, ''),
			actualInvoiceAmount: actualInvoiceAmount ?? '',
			actualInvoiceDate: actualInvoiceDate ? String(actualInvoiceDate).slice(0, 10) : '',
			monthlyDebt: monthlyDebt ?? '',
			remark: remark ?? ''
		};
	}

	return {
		status: '已开票',
		invoiceDate: info.invoiceDate ? String(info.invoiceDate).slice(0, 10) : '',
		selfSubject,
		invoiceAmount: info.invoiceAmount,
		incomeCompanyType: firstDefined(info.companyType, info.incomeCompanyType, ''),
		incomeCompanyName: firstDefined(info.companyName, info.customer, info.Customer, info.Supplier, info.supplier, ''),
		incomeInvoiceUnit: firstDefined(info.invoiceCompanyName, info.invoiceUnitName, ''),
		incomePoint: getSinglePartyTicketPoint(info),
		incomePointAmount: getSinglePartyTicketPointAmount(info),
		isOrderTax: info.isOrderTax,
		costCompanyType: '',
		costCompanyName: '',
		costInvoiceUnit: '',
		costPoint: '',
		costPointAmount: '',
		pointDiff: '',
		actualInvoiceAmount: actualInvoiceAmount ?? '',
		actualInvoiceDate: actualInvoiceDate ? String(actualInvoiceDate).slice(0, 10) : '',
		monthlyDebt: monthlyDebt ?? '',
		remark: remark ?? ''
	};
}

export function buildTicketPointDiffFields(original = {}, changed = {}, tableName = '') {
	if (hasDualPartyTicketPointFields(original) || hasDualPartyTicketPointFields(changed)) {
		return {
			customerDiff: formatTicketPointDiff(changed.customerPointAmount, original.customerPointAmount),
			supplierDiff: formatTicketPointDiff(changed.supplierPointAmount, original.supplierPointAmount)
		};
	}

	const totalDiff = formatTicketPointDiff(getSinglePartyTicketPointAmount(changed), getSinglePartyTicketPointAmount(original));
	const companyType = firstDefined(changed.companyType, original.companyType, '');

	if (companyType === '供应商') {
		return { customerDiff: '0.00', supplierDiff: totalDiff };
	}
	if (companyType === '客户') {
		return { customerDiff: totalDiff, supplierDiff: '0.00' };
	}

	if (tableName === 'invoicein') {
		return { customerDiff: '0.00', supplierDiff: totalDiff };
	}

	return { customerDiff: totalDiff, supplierDiff: '0.00' };
}

export function sumTicketPointIncomeDiffRows(rows = []) {
	const total = rows.reduce((acc, row) => add(acc, Number(row.customerDiff || 0)), 0);
	return format(total, { notation: 'fixed', precision: 2 });
}
