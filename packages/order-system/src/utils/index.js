import { parseTime } from './ruoyi';
import { getConfigKey } from '@/api/system/config';

// 从共享包重新导出通用工具函数
export { getQueryObject, byteLength, cleanArray, param, param2Obj, html2Text, objectMerge, toggleClass, debounce, deepClone, uniqueArr, createUniqueString, hasClass, addClass, removeClass, titleCase, camelCase, isNumberStr, isEmpty as isEmptyValue, makeMap } from '@order-system/shared';

/**
 * 表格时间格式化
 */
export function formatDate(cellValue) {
	if (cellValue == null || cellValue == '') return '';
	var date = new Date(cellValue);
	var year = date.getFullYear();
	var month = date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1;
	var day = date.getDate() < 10 ? '0' + date.getDate() : date.getDate();
	var hours = date.getHours() < 10 ? '0' + date.getHours() : date.getHours();
	var minutes = date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes();
	var seconds = date.getSeconds() < 10 ? '0' + date.getSeconds() : date.getSeconds();
	return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
}

/**
 * @param {number} time
 * @param {string} option
 * @returns {string}
 */
export function formatTime(time, option) {
	if (('' + time).length === 10) {
		time = parseInt(time) * 1000;
	} else {
		time = +time;
	}
	const d = new Date(time);
	const now = Date.now();

	const diff = (now - d) / 1000;

	if (diff < 30) {
		return '刚刚';
	} else if (diff < 3600) {
		// less 1 hour
		return Math.ceil(diff / 60) + '分钟前';
	} else if (diff < 3600 * 24) {
		return Math.ceil(diff / 3600) + '小时前';
	} else if (diff < 3600 * 24 * 2) {
		return '1天前';
	}
	if (option) {
		return parseTime(time, option);
	} else {
		return d.getMonth() + 1 + '月' + d.getDate() + '日' + d.getHours() + '时' + d.getMinutes() + '分';
	}
}

/**
 * @param {string} type
 * @returns {Date}
 */
export function getTime(type) {
	if (type === 'start') {
		return new Date().getTime() - 3600 * 1000 * 24 * 90;
	} else {
		return new Date(new Date().toDateString());
	}
}

/**
 * 根据天数计算时间区间（结束时间为当前日期，精确到天）
 * @param {number} days 从当前时间往前推多少天（非负整数）
 * @returns {{startTime: string, endTime: string}} 返回开始时间和结束时间，格式为 "YYYY-MM-DD HH:mm:ss"
 */
export async function getDateRangeDays(days) {
	const makeRange = d => {
		const now = new Date();
		const end = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59);
		const startDate = new Date(end);
		startDate.setDate(end.getDate() - d);
		const start = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate(), 0, 0, 0);
		return {
			startTime: formatDate(start),
			endTime: formatDate(end)
		};
	};

	// 1) 优先使用显式传入的 days
	if (days !== undefined && days !== null && String(days).trim() !== '') {
		let d = Number(days);
		if (!Number.isFinite(d) || isNaN(d) || d < 0) d = 0;
		return makeRange(d);
	}

	// 2) 未传入 days：依赖系统配置决定
	let res;
	try {
		res = await getConfigKey('order.time_default_write');
	} catch (e) {
		throw new Error('读取配置 order.time_default_write 失败: ' + (e && e.message ? e.message : e));
	}

	const val = res && (res.msg !== undefined ? res.msg : res);

	// 禁用默认时间填写
	if (val === 'N' || val === 'n' || val === false) {
		return { startTime: null, endTime: null };
	}

	// 非法值直接抛错
	if (!(val === 'Y' || val === 'y' || val === true)) {
		throw new Error(`配置项 order.time_default_write 值非法，期望 'Y' 或 'N'，当前值：${val}`);
	}

	// 值为 Y，读取范围并校验
	let rangeRes;
	try {
		rangeRes = await getConfigKey('order.time_default_write_range');
	} catch (e) {
		throw new Error('读取配置 order.time_default_write_range 失败: ' + (e && e.message ? e.message : e));
	}

	const rangeVal = rangeRes && (rangeRes.msg !== undefined ? rangeRes.msg : rangeRes);
	const rn = Number(rangeVal);
	if (!Number.isFinite(rn) || isNaN(rn)) {
		throw new Error(`配置项 order.time_default_write_range 非法，期望为数字，当前值：${rangeVal}`);
	}
	if (rn < 0) {
		throw new Error(`配置项 order.time_default_write_range 不能为负数，当前值：${rn}`);
	}

	return makeRange(rn);
}

export const exportDefault = 'export default ';

export const beautifierConf = {
	html: {
		indent_size: '2',
		indent_char: ' ',
		max_preserve_newlines: '-1',
		preserve_newlines: false,
		keep_array_indentation: false,
		break_chained_methods: false,
		indent_scripts: 'separate',
		brace_style: 'end-expand',
		space_before_conditional: true,
		unescape_strings: false,
		jslint_happy: false,
		end_with_newline: true,
		wrap_line_length: '110',
		indent_inner_html: true,
		comma_first: false,
		e4x: true,
		indent_empty_lines: true
	},
	js: {
		indent_size: '2',
		indent_char: ' ',
		max_preserve_newlines: '-1',
		preserve_newlines: false,
		keep_array_indentation: false,
		break_chained_methods: false,
		indent_scripts: 'normal',
		brace_style: 'end-expand',
		space_before_conditional: true,
		unescape_strings: false,
		jslint_happy: true,
		end_with_newline: true,
		wrap_line_length: '110',
		indent_inner_html: true,
		comma_first: false,
		e4x: true,
		indent_empty_lines: true
	}
};

// 保留本地的 isEmpty 函数以保持向后兼容
// 注意：共享包中的 isEmpty 已经用别名 isEmptyValue 导出
export function isEmpty(value) {
	if (value === null || value === undefined || value === '') {
		return '-';
	} else {
		return value;
	}
}
