// 获取UUID
import { fix_2 } from '@/api/tool/format';

export function getUuid() {
	return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
		var r = (Math.random() * 16) | 0,
			v = c == 'x' ? r : (r & 0x3) | 0x8;
		return v.toString(16);
	});
}

// 获取文件后缀
export function findFileExtension(filename) {
	// 如果filename为空 直接返回
	if (!filename) {
		return '';
	}
	// 使用lastIndexOf找到最后一个'.'的位置
	const index = filename.lastIndexOf('.');
	// 如果没有找到'.'，则没有后缀名
	if (index === -1) {
		return '';
	}
	// 返回'.'后面的字符串作为后缀名
	return filename.substring(index + 1);
}

// 防抖函数
export function debounce(func, delay) {
	let timeoutId;

	return function (...args) {
		const context = this;

		// 清除之前的定时器
		clearTimeout(timeoutId);

		// 设置一个新的定时器
		timeoutId = setTimeout(function () {
			// 在延迟时间后执行函数，并传递上下文和参数
			func.apply(context, args);
		}, delay);
	};
}

// 格式化余额显示 - 根据正负显示借贷
export function formatBalance(amount) {
	if (amount === 0) {
		return '0';
	}
	return amount > 0 ? '[借] ' + fix_2(Math.abs(amount)) : '[贷] ' + fix_2(Math.abs(amount));
}

// 如果是司机或者供应商 方向要取反
export function formatSupplierBalance(amount) {
	if (amount === 0) {
		return '0';
	}
	return amount < 0 ? '[借] ' + fix_2(Math.abs(amount)) : '[贷] ' + fix_2(Math.abs(amount));
}

/**
 * 根据 debitCredit 字段判断是否为借方
 * @param {string} debitCredit - 借贷标识：'d' 表示借方，'c' 表示贷方
 * @returns {boolean} 是否为借方
 */
export function isDebit(debitCredit) {
	return debitCredit === 'd' || debitCredit === 'D';
}

/**
 * 根据 debitCredit 字段判断是否为贷方
 * @param {string} debitCredit - 借贷标识：'d' 表示借方，'c' 表示贷方
 * @returns {boolean} 是否为贷方
 */
export function isCredit(debitCredit) {
	return debitCredit === 'c' || debitCredit === 'C';
}

/**
 * 根据 debitCredit 字段获取借贷标签
 * @param {string} debitCredit - 借贷标识：'d' 表示借方，'c' 表示贷方
 * @returns {string} 借贷标签：'借' 或 '贷'
 */
export function getDebitCreditLabel(debitCredit) {
	if (isDebit(debitCredit)) {
		return '借';
	}
	if (isCredit(debitCredit)) {
		return '贷';
	}
	return '';
}

/**
 * 根据 debitCredit 字段格式化余额显示
 * @param {number} amount - 金额
 * @param {string} debitCredit - 借贷标识：'d' 表示借方，'c' 表示贷方
 * @returns {string} 格式化后的余额显示
 */
export function formatBalanceByDebitCredit(amount, debitCredit) {
	if (amount === 0) {
		return '0';
	}
	const absAmount = Math.abs(amount);
	if (isDebit(debitCredit)) {
		return '[借] ' + fix_2(absAmount);
	}
	if (isCredit(debitCredit)) {
		return '[贷] ' + fix_2(absAmount);
	}
	return fix_2(amount);
}
