// 需求：票据余额表切换页面后保留搜索条件，日期查询参数使用 billDate。
// 实际改动：查询工厂提供单值 billDate，供余额表列表和导出请求使用。
export function createBalanceListQueryParams() {
	return {
		pageNum: 1,
		pageSize: 20,
		billNo: '',
		billAccount: '',
		billDate: '',
		dueDateRange: [],
		balanceOperator: '',
		balanceValue: ''
	};
}
