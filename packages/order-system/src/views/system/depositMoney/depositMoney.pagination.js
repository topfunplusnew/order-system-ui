export function createDepositMoneyQueryParams() {
	return {
		pageNum: 1,
		pageSize: 20,
		depositCompany: null,
		type: null,
		targetType: null,
		target: null,
		reason: null,
		comments: null,
		params: {
			beginTime: null,
			endTime: null
		}
	};
}

export function syncDepositMoneyPagination(queryParams, pagination) {
	const pageNum = pagination?.page || queryParams.pageNum;
	const pageSize = pagination?.limit || queryParams.pageSize;

	queryParams.pageNum = pageNum;
	queryParams.pageSize = pageSize;

	return {
		pageNum,
		pageSize
	};
}
