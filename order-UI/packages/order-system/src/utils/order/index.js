// ==================== 价格处理相关函数 ====================

/**
 * 解析用户输入值，转换为Number类型并保持完整精度
 * @param {string} inputValue - 用户输入的字符串值
 * @returns {number|string} 解析后的数值（Number类型，保持完整精度）或空字符串
 */
export function parseInputValue(inputValue) {
	if (inputValue === null || inputValue === undefined || inputValue === '') {
		return '';
	}
	// 移除所有非数字和小数点的字符（保留负号如果需要）
	const cleanValue = String(inputValue).replace(/[^\d.]/g, '');
	if (cleanValue === '' || cleanValue === '.') {
		return '';
	}
	const num = Number(cleanValue);
	if (isNaN(num)) {
		return '';
	}
	// 返回Number类型，保持用户输入的完整精度（不截断）
	return num;
}

/**
 * 格式化数值用于显示，但不影响存储值
 * @param {number|string} value - 需要格式化的值
 * @param {number} precision - 小数位数（用于显示）
 * @returns {string} 格式化后的字符串（仅用于显示）
 */
export function formatValueForDisplay(value, precision = 2) {
	if (value === null || value === undefined || value === '') {
		return '';
	}
	const num = Number(value);
	if (isNaN(num)) {
		return '';
	}
	// 仅用于显示，不修改原始值
	return num.toFixed(precision);
}

/**
 * 获取数字的小数位数
 * @param {number} num - 需要检查的数字
 * @returns {number} 小数位数
 */
export function getDecimalPlaces(num) {
	// 将数字转换为字符串
	const strNum = num.toString();
	// 查找小数点的位置
	const dotIndex = strNum.indexOf('.');
	// 如果没有小数点，返回 0
	if (dotIndex === -1) {
		return 0;
	}
	// 返回小数点后的字符长度
	return strNum.length - dotIndex - 1;
}

/**
 * 特殊字段列表：这些字段需要保持用户输入的完整精度（不截断）
 * - price: 出厂单价
 * - paymentUnload: 卸货价/存货价
 */
const SPECIAL_PRECISION_FIELDS = ['price', 'paymentUnload'];

/**
 * 处理价格字段输入，保存完整精度值用于计算
 * 特殊字段：保持用户输入的完整精度
 * 其他字段：输入时保持完整精度，失去焦点时截断为两位
 * @param {Object} row - 当前行数据
 * @param {String} field - 字段名
 * @param {String} inputValue - 用户输入的值
 * @param {Function} callback - 输入后的回调函数（如重新计算）
 */
export function handlePriceInput(row, field, inputValue, callback) {
	// 解析输入值，保持完整精度存储
	const parsedValue = parseInputValue(inputValue);
	// 判断是否为特殊字段
	const isSpecialField = SPECIAL_PRECISION_FIELDS.includes(field);

	if (isSpecialField) {
		// 特殊字段：保持完整精度，同时保存原始输入字符串用于恢复显示精度
		row[`_${field}_raw`] = parsedValue;
		row[field] = inputValue;
		// 保存用户输入的小数位数（用于后续恢复显示）
		if (parsedValue !== '' && parsedValue !== null && parsedValue !== undefined) {
			const numValue = Number(parsedValue);
			if (!isNaN(numValue)) {
				row[`_${field}_decimalPlaces`] = getDecimalPlaces(numValue);
			}
		}
	} else {
		// 其他字段：输入时保持完整精度（允许用户继续输入），失去焦点时会截断
		row[`_${field}_raw`] = parsedValue;
		row[field] = inputValue;
	}

	// 如果有回调，执行回调（通常是重新计算）
	if (callback) {
		callback();
	}
}

/**
 * 获取用于计算的数值（非特殊字段先保留两位小数）
 * @param {Object} row - 当前行数据
 * @param {String} field - 字段名
 * @returns {number} 用于计算的数值
 */
export function getValueForCalculation(row, field) {
	const isSpecialField = SPECIAL_PRECISION_FIELDS.includes(field);
	// 优先使用_raw字段（完整精度），如果没有则使用原字段
	const rawValue = row[`_${field}_raw`] !== undefined ? row[`_${field}_raw`] : row[field];
	const numValue = Number(rawValue) || 0;

	if (isSpecialField) {
		// 特殊字段：使用完整精度
		return numValue;
	} else {
		// 其他字段：先保留两位小数再计算
		return Math.round(numValue * 100) / 100;
	}
}

/**
 * 初始化特殊字段的小数位数（用于从后端加载数据时）
 * @param {Object} row - 当前行数据
 */
export function initSpecialFieldDecimalPlaces(row) {
	SPECIAL_PRECISION_FIELDS.forEach(field => {
		if (row[field] !== null && row[field] !== undefined && row[field] !== '') {
			const numValue = Number(row[field]);
			if (!isNaN(numValue)) {
				// 保存原始值到 _raw 字段
				row[`_${field}_raw`] = numValue;
				// 保存小数位数
				row[`_${field}_decimalPlaces`] = getDecimalPlaces(numValue);
			}
		}
	});
}

/**
 * 规范化价格输入，确保为有效的Number类型
 * 特殊字段（price, paymentUnload）：保持用户输入的完整精度，显示和计算都使用完整精度
 * 其他字段：统一保留两位小数，计算时先保留两位再计算
 * @param {Object} row - 当前行数据
 * @param {String} field - 字段名
 * @param {Number} precision - 显示精度（2或4位小数，对于特殊字段会被忽略）
 * @param {boolean} isSpecialFieldFlag - 是否强制作为特殊字段处理（false表示根据字段名自动判断，true表示强制特殊字段）
 */
export function formatPriceInput(row, field, precision, isSpecialFieldFlag = false) {
	// 获取完整精度的原始值（优先使用_raw字段）
	const rawValue = row[`_${field}_raw`] !== undefined ? row[`_${field}_raw`] : row[field];

	// 判断是否为特殊字段（优先使用参数，否则根据字段名判断）
	const isSpecialField = isSpecialFieldFlag || SPECIAL_PRECISION_FIELDS.includes(field);

	if (rawValue !== null && rawValue !== undefined && rawValue !== '') {
		const numValue = Number(rawValue);
		if (!isNaN(numValue)) {
			if (isSpecialField) {
				// 特殊字段：保持完整精度，显示用户输入的精度
				row[`_${field}_raw`] = numValue;
				// 优先使用保存的小数位数，否则从数值中计算
				let decimalPlaces = row[`_${field}_decimalPlaces`];
				if (decimalPlaces === undefined || decimalPlaces === null) {
					decimalPlaces = getDecimalPlaces(numValue);
				}
				// 如果用户输入了小数，保持原样显示；否则显示整数
				row[field] = decimalPlaces > 0 ? numValue.toFixed(decimalPlaces) : numValue.toString();
			} else {
				// 其他字段：先保留两位小数，再存储和显示
				const roundedValue = Math.round(numValue * 100) / 100; // 保留两位小数
				row[`_${field}_raw`] = roundedValue;
				row[field] = formatValueForDisplay(roundedValue, 2);
			}
		} else {
			// 无效数值时清空
			row[field] = '';
			row[`_${field}_raw`] = '';
		}
	}
}

/**
 * 处理价格字段聚焦事件，恢复完整精度显示以便编辑
 * @param {Object} row - 当前行数据
 * @param {String} field - 字段名
 */
export function handlePriceFocus(row, field) {
	// 如果存在原始值，恢复显示原始完整精度
	if (row[`_${field}_raw`] !== undefined && row[`_${field}_raw`] !== null && row[`_${field}_raw`] !== '') {
		row[field] = row[`_${field}_raw`].toString();
	} else if (row[field] !== null && row[field] !== undefined && row[field] !== '') {
		// 如果没有原始值，保存当前值为原始值
		const numValue = Number(row[field]);
		if (!isNaN(numValue)) {
			row[`_${field}_raw`] = numValue;
			row[field] = numValue.toString();
		}
	}
}

// ==================== 片数处理相关函数 ====================

/**
 * 规范化片数值，确保为有效的Number类型，保持完整精度
 * 注意：此方法只做数值规范化，不格式化显示（不截断小数位）
 * 格式化显示由输入框的 formatter 或显示层处理
 * @param {number} value 需要规范化的数值
 * @returns {number|string} 规范化后的数值（Number类型）或空字符串
 */
export function formatPiecesValue(value) {
	if (value === null || value === undefined || value === '') {
		return '';
	}

	const num = Number(value);
	if (isNaN(num)) {
		return '';
	}

	// 返回Number类型，保持完整精度，不截断小数位
	// 这样计算时可以使用完整数值，保证计算精度
	return num;
}

/**
 * 处理片数输入，限制最多两位小数
 * @param {object} row 当前行数据
 * @param {string} field 字段名
 * @param {string} value 输入值
 * @param {function} callback 回调函数
 */
export function handlePiecesInput(row, field, value, callback) {
	// 允许输入数字和小数点
	let sanitizedValue = value.replace(/[^\d.]/g, '');

	// 只允许一个小数点
	const parts = sanitizedValue.split('.');
	if (parts.length > 2) {
		sanitizedValue = parts[0] + '.' + parts.slice(1).join('');
	}

	// 限制小数点后最多2位
	if (parts.length === 2 && parts[1].length > 2) {
		sanitizedValue = parts[0] + '.' + parts[1].slice(0, 2);
	}

	// 更新行数据
	row[field] = sanitizedValue;

	// 执行回调函数
	if (callback) {
		callback();
	}
}

// ==================== 行操作相关函数 ====================

/**
 * 获取表格行的类名，用于标记错误行或编辑中的行
 * @param {object} param - Element UI 表格传递的参数，包含当前行数据 { row }
 * @returns {string} 行的 CSS 类名 ('error-row', 'editing-row', 'readonly-row', 或空字符串)
 */
export function getRowClassName({ row }) {
	if (row.hasError) {
		return 'error-row';
	} else if (row.isEditing) {
		return 'editing-row';
	} else if (row.isReadOnly || row.shouldDel) {
		return 'readonly-row';
	}
	return '';
}

/**
 * 复制指定行数据（深拷贝并清除ID）
 * @param {Object} row - 要复制的行数据
 * @param {number} newIndex - 新的索引值
 * @returns {Object} 复制后的行数据
 */
export function copyRowData(row, newIndex) {
	// 需要导入 lodash 的 cloneDeep，这里返回一个函数供组件调用
	// 组件需要自己处理 lodash 的导入
	return {
		...row,
		id: undefined,
		index: newIndex,
		isEditing: true,
		isAdd: true,
		isDeleted: false,
		hasError: false
	};
}

// 工具库
// 防抖函数
export const debounce = (fn, delay = 500) => {
	// 定义一个计时器
	let timer = null;

	// 返回一个新的函数
	return function (...args) {
		// 如果有计时器，就清除计时器
		if (timer) {
			clearTimeout(timer);
		}
		// 重新设置计时器
		timer = setTimeout(() => {
			fn.apply(this, args);
		}, delay);
	};
};

// 日期往前推一年
export function getTimeOffset(format = '{y}-{m}-{d} {h}:{i}:{s}', yearsOffset = 0) {
	// 格式化时间
	function parseTime(date, format) {
		const formatObj = {
			y: date.getFullYear(),
			m: date.getMonth() + 1, // 月份从 0 开始，需要加 1
			d: date.getDate(),
			h: date.getHours(),
			i: date.getMinutes(),
			s: date.getSeconds()
		};

		return format.replace(/{(y|m|d|h|i|s)+}/g, (match, key) => {
			const value = formatObj[key];
			return value.toString().padStart(2, '0');
		});
	}

	// 获取当前时间并进行偏移
	const now = new Date();
	now.setFullYear(now.getFullYear() - yearsOffset);

	// 格式化返回结果
	return parseTime(now, format);
}

export const OTHER_TYPE = [
	{
		value: '客户',
		label: '客户'
	},
	{
		value: '供应商',
		label: '供应商'
	}
];

// 客户 供应商 司机 员工 其他 己方公司 公共字典
export const PUBLIC_DICT_TYPE = {
	// 客户
	CUSTOMER: '客户',
	// 供应商
	SUPPLIER: '供应商',
	// 司机
	DRIVER: '司机',
	// 员工
	EMPLOYEE: '员工',
	// 其他
	OTHER: '其他',
	// 己方公司
	SELF_COMPANY: '己方公司'
};
