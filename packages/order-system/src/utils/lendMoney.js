import { bignumber, add } from 'mathjs';

/**
 * 计算累计坏账（仅统计 badDebtFlag 为 1 的收回记录金额）
 * @param {Object} row 借出款行数据，需包含 recoverMoneyList
 * @param {Array} row.recoverMoneyList 收回记录列表，每项含 moneyAmount、badDebtFlag
 * @returns {string} 累计坏账金额，保留两位小数
 */
export function calculateTotalBadDebt(row) {
	if (!row.recoverMoneyList || !Array.isArray(row.recoverMoneyList) || row.recoverMoneyList.length === 0) {
		return '0.00';
	}
	const amounts = row.recoverMoneyList.map(item => {
		if (item.badDebtFlag !== 1 && item.badDebtFlag !== '1') {
			return bignumber(0);
		}
		return bignumber(item.moneyAmount || 0);
	});
	const total = amounts.reduce((sum, amount) => add(sum, amount), bignumber(0));
	return total.toFixed(2);
}
