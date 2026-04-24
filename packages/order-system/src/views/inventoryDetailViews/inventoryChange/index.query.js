import { parseTime } from '@/utils/ruoyi';

export function createInventoryChangeSearchForm() {
	return {
		startDate: '2025-11-01',
		endDate: parseTime(new Date(), '{y}-{m}-{d}'),
		warehouseName: '',
		pageNum: 1,
		pageSize: 20
	};
}
