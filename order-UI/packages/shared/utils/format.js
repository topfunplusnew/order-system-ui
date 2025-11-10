// 通用格式化工具函数

export const formatNumber = (num, decimals = 2) => {
	if (num === null || num === undefined) return '0.00';
	return Number(num).toFixed(decimals);
};

export const formatCurrency = (num) => {
	return `¥${formatNumber(num)}`;
};

