function normalizeBoundary(value, defaultTime) {
	if (typeof value !== 'string') return value;
	return value.length === 10 ? `${value} ${defaultTime}` : value;
}

export function normalizeInvoiceOtherDateRange(dateRange) {
	if (!Array.isArray(dateRange) || dateRange.length !== 2) {
		return [];
	}

	const normalizedRange = [normalizeBoundary(dateRange[0], '00:00:00'), normalizeBoundary(dateRange[1], '23:59:59')];
	const [startTime, endTime] = normalizedRange;

	if (typeof startTime !== 'string' || typeof endTime !== 'string') {
		return normalizedRange;
	}

	const endDate = endTime.slice(0, 10);
	if (endTime.slice(11) === '00:00:00') {
		normalizedRange[1] = `${endDate} 23:59:59`;
	}

	return normalizedRange;
}
