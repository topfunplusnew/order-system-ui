import { parseTime } from '@/utils/ruoyi';

export function createBalanceListQueryParams() {
	return {
		pageNum: 1,
		pageSize: 20,
		operateDate: parseTime(new Date(), '{y}-{m}-{d}'),
		balanceOperator: '',
		balanceValue: ''
	};
}
