export const normalizeCustomerPointAmountForSubmit = value => {
	if (value === null || value === undefined) {
		return 0;
	}

	if (typeof value === 'string' && value.trim() === '') {
		return 0;
	}

	return value;
};
