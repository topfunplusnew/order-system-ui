/* 用户需求：正常发货记录、入库记录、出库记录的日期搜索改为时间范围搜索。实际改动：提供共享方法，将时分秒范围同步到不同页面原有的开始、结束查询字段，并在范围清空时将字段置空。 */
export function applyInventoryRecordDateRange(queryParams, dateRange, startField, endField) {
	const hasRange = Array.isArray(dateRange) && dateRange.length === 2;
	queryParams[startField] = hasRange ? dateRange[0] : null;
	queryParams[endField] = hasRange ? dateRange[1] : null;
	return queryParams;
}
