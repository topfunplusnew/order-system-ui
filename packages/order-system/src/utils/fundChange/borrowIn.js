import { format, subtract, add } from 'mathjs';
import _ from 'lodash';

function firstDefined(...values) {
	const value = values.find(item => item !== undefined && item !== null && item !== '');
	return value === undefined ? '' : value;
}

export function calcBorrowInRepaymentFields(info = {}) {
	const principal = Number(info.moneyAmount || 0);
	const repaidFromDetails = _.sumBy(info.repayments || [], r => Number(r.moneyAmount || 0));
	const repaidInterest = _.sumBy(info.repayments || [], r => Number(r.ratio || 0));
	const hasUnrepaidAmount = info.unrepaidAmount !== undefined && info.unrepaidAmount !== null && info.unrepaidAmount !== '';
	const unrepaid = hasUnrepaidAmount ? Number(info.unrepaidAmount || 0) : subtract(principal, repaidFromDetails);
	const repaid = hasUnrepaidAmount ? subtract(principal, unrepaid) : repaidFromDetails;
	return {
		repaidAmount: format(repaid, { notation: 'fixed', precision: 2 }),
		unrepaidAmount: format(unrepaid, { notation: 'fixed', precision: 2 }),
		repaidInterest: format(repaidInterest, { notation: 'fixed', precision: 2 })
	};
}

export function mapBorrowInRecordToRow(info = {}) {
	const { repaidAmount, unrepaidAmount, repaidInterest } = calcBorrowInRepaymentFields(info);
	const loanDate = firstDefined(info.loanDate, info.grantDate, '');
	return {
		id: info.id,
		origin: firstDefined(info.origin, info.lenderName, info.companyName, ''),
		moneyAmount: info.moneyAmount,
		ratio: firstDefined(info.ratio, info.interestRate, ''),
		loanDate: loanDate ? (loanDate + '').slice(0, 10) : '',
		loanDuring: firstDefined(info.loanDuring, info.loanYears, ''),
		mortgageGuarantee: firstDefined(info.mortgageGuarantee, info.mortgage, ''),
		acountsName: firstDefined(info.acountsName, info.intoAccountName, info.bankName, ''),
		bankNo: firstDefined(info.bankNo, info.intoAccountNo, ''),
		repaidAmount,
		unrepaidAmount,
		repaidInterest,
		comments: firstDefined(info.comments, info.remark, '')
	};
}

export function buildBorrowInDiffFields(original = {}, changed = {}) {
	const origPrincipal = Number(original.moneyAmount || 0);
	const chgPrincipal = Number(changed.moneyAmount || 0);
	const origRepayP = _.sumBy(original.repayments || [], r => Number(r.moneyAmount || 0));
	const chgRepayP = _.sumBy(changed.repayments || [], r => Number(r.moneyAmount || 0));
	const origRepayI = _.sumBy(original.repayments || [], r => Number(r.ratio || 0));
	const chgRepayI = _.sumBy(changed.repayments || [], r => Number(r.ratio || 0));
	const diff = add(subtract(chgPrincipal, origPrincipal), add(subtract(origRepayP, chgRepayP), subtract(origRepayI, chgRepayI)));
	return { moneyAmount: format(diff, { notation: 'fixed', precision: 2 }) };
}

export function sumBorrowInDiffRows(rows = []) {
	const total = rows.reduce((acc, row) => add(acc, Number(row.moneyAmount) || 0), 0);
	return format(total, { notation: 'fixed', precision: 2 });
}
