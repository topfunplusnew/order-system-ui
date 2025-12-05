// 通用日期工具函数
// 从 order-system/src/utils/Date.js 提取通用部分

export const formatDate = (date, format = 'YYYY-MM-DD') => {
	if (!date) return '';
	const d = new Date(date);
	const year = d.getFullYear();
	const month = String(d.getMonth() + 1).padStart(2, '0');
	const day = String(d.getDate()).padStart(2, '0');

	return format.replace('YYYY', year).replace('MM', month).replace('DD', day);
};
