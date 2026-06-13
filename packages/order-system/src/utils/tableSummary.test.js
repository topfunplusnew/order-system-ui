import { describe, expect, test } from '@jest/globals';
import { buildAmountSummaries, formatAmount, formatDebitCreditAmount } from './tableSummary';

describe('tableSummary', () => {
	test('builds fixed-precision summaries for amount columns', () => {
		const columns = [{ property: 'date' }, { property: 'amount' }, { property: 'name' }];
		const data = [{ amount: '10.235' }, { amount: 2 }, { amount: null }, { amount: 'bad' }];

		expect(buildAmountSummaries({ columns, data, amountProps: ['amount'] })).toEqual(['合计', '12.24', '']);
	});

	test('supports calculated amount columns by column label', () => {
		const columns = [{ property: 'index' }, { label: '当日欠款金额' }];
		const data = [
			{ previousDayCarryover: 10, dailyOrderPayments: 5, dailyInvoiceAmount: 1, dailyReceiveMoney: 2 },
			{ previousDayCarryover: 3, dailyOrderPayments: 2, dailyInvoiceAmount: 0, dailyReceiveMoney: 1 }
		];

		const summaries = buildAmountSummaries({
			columns,
			data,
			getColumnValue: (row, column) => {
				if (column.label === '当日欠款金额') {
					return Number(row.previousDayCarryover) + Number(row.dailyOrderPayments) + Number(row.dailyInvoiceAmount) - Number(row.dailyReceiveMoney);
				}
				return undefined;
			}
		});

		expect(summaries).toEqual(['合计', '18.00']);
	});

	test('formats debit and credit totals by sign', () => {
		expect(formatDebitCreditAmount(12)).toBe('[借] 12.00');
		expect(formatDebitCreditAmount(-3.5)).toBe('[贷] 3.50');
		expect(formatDebitCreditAmount(0)).toBe('0.00');
	});

	test('formats invalid amount as zero', () => {
		expect(formatAmount('not-number')).toBe('0.00');
	});
});
