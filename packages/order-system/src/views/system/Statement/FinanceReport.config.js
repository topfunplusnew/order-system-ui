import { parseTime } from '@/utils/ruoyi';
import { isNil, omitBy } from 'lodash';

/** @typedef {'receive' | 'payment'} FinanceReportType */

/**
 * 创建报表查询初始参数
 * @returns {Object}
 */
export function createFinanceReportQueryParams() {
	const today = parseTime(new Date(), '{y}-{m}-{d}');
	return {
		dateRange: [today, today],
		startTime: today,
		endTime: today,
		selfAccountName: '',
		otherCompanyName: '',
		otherAccountName: '',
		pageNum: 1,
		pageSize: 50
	};
}

/**
 * 同步日期范围到 startTime / endTime
 * @param {Object} queryParams
 * @returns {Object}
 */
export function syncFinanceReportDateRange(queryParams) {
	const nextParams = { ...queryParams };
	const dateRange = nextParams.dateRange || [];
	if (dateRange.length === 2) {
		nextParams.startTime = dateRange[0];
		nextParams.endTime = dateRange[1];
	} else {
		nextParams.startTime = '';
		nextParams.endTime = '';
	}
	return nextParams;
}

/**
 * 构建报表查询参数
 * @param {Object} queryParams
 * @returns {Object}
 */
export function buildFinanceReportQuery(queryParams) {
	const syncedParams = syncFinanceReportDateRange(queryParams);
	return omitBy(
		{
			startTime: syncedParams.startTime,
			endTime: syncedParams.endTime,
			selfAccountName: syncedParams.selfAccountName,
			otherCompanyName: syncedParams.otherCompanyName,
			otherAccountName: syncedParams.otherAccountName,
			pageNum: syncedParams.pageNum,
			pageSize: syncedParams.pageSize
		},
		value => isNil(value) || value === ''
	);
}

/**
 * 创建收款报表列配置
 * @returns {Array<{key: number, label: string, visible: boolean}>}
 */
export function createReceiveReportColumns() {
	return [
		{ key: 0, label: '日期', visible: true },
		{ key: 1, label: '收入类型', visible: true },
		{ key: 2, label: '对方公司名称', visible: true },
		{ key: 3, label: '对方公司类型', visible: true },
		{ key: 4, label: '金额', visible: true },
		{ key: 5, label: '我方户名', visible: true },
		{ key: 6, label: '我方账号', visible: true },
		{ key: 7, label: '我方开户行', visible: true },
		{ key: 8, label: '我方账户类型', visible: true },
		{ key: 9, label: '对方户名', visible: true },
		{ key: 10, label: '对方账号', visible: true },
		{ key: 11, label: '对方开户行', visible: true },
		{ key: 12, label: '备注', visible: true },
		{ key: 13, label: '银行卡流水编号', visible: true },
		{ key: 14, label: '录入人员', visible: true },
		{ key: 15, label: '新增时间', visible: true },
		{ key: 16, label: '最后修改时间', visible: true },
		{ key: 17, label: '最后修改人员', visible: true }
	];
}

/**
 * 创建付款报表列配置
 * @returns {Array<{key: number, label: string, visible: boolean}>}
 */
export function createPaymentReportColumns() {
	return [
		{ key: 0, label: '来源', visible: true },
		{ key: 1, label: '日期', visible: true },
		{ key: 2, label: '支出类型', visible: true },
		{ key: 3, label: '对方公司名称', visible: true },
		{ key: 4, label: '对方公司类型', visible: true },
		{ key: 5, label: '金额', visible: true },
		{ key: 6, label: '我方户名', visible: true },
		{ key: 7, label: '我方账号', visible: true },
		{ key: 8, label: '我方开户行', visible: true },
		{ key: 9, label: '我方账户类型', visible: true },
		{ key: 10, label: '对方户名', visible: true },
		{ key: 11, label: '对方账号', visible: true },
		{ key: 12, label: '对方开户行', visible: true },
		{ key: 13, label: '备注', visible: true },
		{ key: 14, label: '银行卡流水编号', visible: true },
		{ key: 15, label: '录入人员', visible: true },
		{ key: 16, label: '新增时间', visible: true },
		{ key: 17, label: '最后修改时间', visible: true },
		{ key: 18, label: '最后修改人员', visible: true }
	];
}

/**
 * 获取报表日期展示值
 * @param {Object} row
 * @returns {string}
 */
export function resolveFinanceReportDate(row) {
	return row?.date || row?.fundsDate || '';
}

/**
 * 获取报表导出路径
 * @param {FinanceReportType} reportType
 * @returns {string}
 */
export function getFinanceReportExportPath(reportType) {
	return reportType === 'payment' ? 'statistics/export/paymentReport' : 'statistics/export/receiveReport';
}

/**
 * 获取报表导出文件名
 * @param {FinanceReportType} reportType
 * @returns {string}
 */
export function getFinanceReportExportFileName(reportType) {
	const prefix = reportType === 'payment' ? '付款报表' : '收款报表';
	return `${prefix}_${parseTime(new Date().getTime())}.xlsx`;
}
