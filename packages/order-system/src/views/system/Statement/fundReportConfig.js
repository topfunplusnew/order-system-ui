// 用户需求：收款报表和付款报表的日期改为时间段搜索，并通过 startDate、endDate 以 yyyy-MM-dd 格式传给后端。实际改动：查询模型改用起止日期字段，并提供日期范围同步与完整性校验方法。
import { getPaymentReport, getReceiveReport } from '@/api/system/statement';

export const FUND_REPORT_COLUMNS = [
	{ prop: 'source', label: '来源', width: 120 },
	{ prop: 'operateDate', label: '日期', width: 120 },
	{ prop: 'businessType', label: '', width: 120 },
	{ prop: 'otherCompanyName', label: '对方公司名称', width: 180 },
	{ prop: 'otherCompanyType', label: '对方公司类型', width: 130 },
	{ prop: 'amount', label: '金额', width: 120, amount: true },
	{ prop: 'selfAccountName', label: '我方户名', width: 160 },
	{ prop: 'selfBankNo', label: '我方账号', width: 180 },
	{ prop: 'selfBankName', label: '我方开户行', width: 180 },
	{ prop: 'selfBankCardType', label: '我方账户类型', width: 130 },
	{ prop: 'otherAccountName', label: '对方户名', width: 160 },
	{ prop: 'otherBankNo', label: '对方账号', width: 180 },
	{ prop: 'otherBankName', label: '对方开户行', width: 180 },
	{ prop: 'comments', label: '备注', width: 180 },
	{ prop: 'bankFlowNo', label: '银行卡流水编号', width: 180 },
	{ prop: 'createByName', label: '录入人员', width: 120 },
	{ prop: 'addtime', label: '新增时间', width: 160 },
	{ prop: 'updateTime', label: '最后修改时间', width: 160 },
	{ prop: 'updateByName', label: '最后修改人员', width: 130 }
];

export const FUND_REPORT_CONFIG = {
	receive: {
		title: '收款报表',
		businessTypeLabel: '收入类型',
		listApi: getReceiveReport,
		exportPath: '/statistics/export/receiveReport',
		exportFileName: '收款报表',
		tableName: 'views-system-statement-receive-report-columns'
	},
	payment: {
		title: '付款报表',
		businessTypeLabel: '支出类型',
		listApi: getPaymentReport,
		exportPath: '/statistics/export/paymentReport',
		exportFileName: '付款报表',
		tableName: 'views-system-statement-payment-report-columns'
	}
};

export function createFundReportQuery(date) {
	return {
		pageNum: 1,
		pageSize: 20,
		startDate: date,
		endDate: date,
		selfAccountName: '',
		otherCompanyName: '',
		otherAccountName: ''
	};
}

export function applyFundReportDateRange(queryParams, dateRange) {
	const hasRange = Array.isArray(dateRange) && dateRange.length === 2;
	queryParams.startDate = hasRange ? dateRange[0] : null;
	queryParams.endDate = hasRange ? dateRange[1] : null;
}

export function hasRequiredReportDateRange(query) {
	return Boolean(query && query.startDate && query.endDate);
}
