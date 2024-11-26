/**
 * 通用js方法封装处理
 * Copyright (c) 2019 ruoyi
 */

// 日期格式化
export function parseTime(time, pattern) {
	if (arguments.length === 0 || !time) {
		return null;
	}
	const format = pattern || '{y}-{m}-{d} {h}:{i}:{s}';
	let date;
	if (typeof time === 'object') {
		date = time;
	} else {
		if (typeof time === 'string' && /^[0-9]+$/.test(time)) {
			time = parseInt(time);
		} else if (typeof time === 'string') {
			time = time
				.replace(new RegExp(/-/gm), '/')
				.replace('T', ' ')
				.replace(new RegExp(/\.[\d]{3}/gm), '');
		}
		if (typeof time === 'number' && time.toString().length === 10) {
			time = time * 1000;
		}
		date = new Date(time);
	}
	const formatObj = {
		y: date.getFullYear(),
		m: date.getMonth() + 1,
		d: date.getDate(),
		h: date.getHours(),
		i: date.getMinutes(),
		s: date.getSeconds(),
		a: date.getDay()
	};
	const time_str = format.replace(/{(y|m|d|h|i|s|a)+}/g, (result, key) => {
		let value = formatObj[key];
		// Note: getDay() returns 0 on Sunday
		if (key === 'a') {
			return ['日', '一', '二', '三', '四', '五', '六'][value];
		}
		if (result.length > 0 && value < 10) {
			value = '0' + value;
		}
		return value || 0;
	});
	return time_str;
}

// 表单重置
export function resetForm(refName) {
	if (this.$refs[refName]) {
		this.$refs[refName].resetFields();
	}
}

// 添加日期范围
// propName 可以添加一个字符串
export function addDateRange(params, dateRange, propName, otherParams) {
	// 如果是走访记录的时间查询
	const search = params;
	search.params =
		typeof search.params === 'object' &&
		search.params !== null &&
		!Array.isArray(search.params)
			? search.params
			: {};
	dateRange = Array.isArray(dateRange) ? dateRange : [];
	// 需要格式化什么 加if就行了
	if (propName === 'visit') {
		search.params['visitDateStartTime'] = dateRange[0];
		search.params['visitDateEndTime'] = dateRange[1];
		search.params['region'] = otherParams;
	} else if (propName === 'payment') {
		search.params['fundsDateStartTime'] = dateRange[0];
		search.params['fundsDateEndTime'] = dateRange[1];
	} else if (propName === 'invoiceout') {
		// invoiceDateStartTime
		search.params['invoiceDateStartTime'] = dateRange[0];
		search.params['invoiceDateEndTime'] = dateRange[1];
	} else if (propName === 'orderfreight') {
		// applyDateStartTime
		search.params['applyDateStartTime'] = dateRange[0];
		search.params['applyDateEndTime'] = dateRange[1];
	} else if (propName === 'fixedassets') {
		// buyDateStartTime
		search.params['buyDateStartTime'] = dateRange[0];
		search.params['buyDateEndTime'] = dateRange[1];

		// operate特殊
	} else if (propName === 'voucher') {
		search.params['voucherNoPrefix'] = otherParams;
	} else if (propName === 'operate') {
		search.params['operateDateStartTime'] = dateRange[0];
		search.params['operateDateEndTime'] = dateRange[1];
	} else {
		if (typeof propName === 'undefined') {
			search.params['beginTime'] = dateRange[0];
			search.params['endTime'] = dateRange[1];
		} else {
			search.params['begin' + propName] = dateRange[0];
			search.params['end' + propName] = dateRange[1];
		}
	}
	return search;
}

// export function adDateRange(params, dateRange, propName) {
//   let search = params;
//   search.params = typeof (search.params) === 'object' && search.params !== null && !Array.isArray(search.params) ? search.params : {};
//   dateRange = Array.isArray(dateRange) ? dateRange : [];
//   if (typeof (propName) === 'undefined') {
//     search.params['beginTime'] = dateRange[0];
//     search.params['endTime'] = dateRange[1];
//   } else {
//     search.params['begin' + propName] = dateRange[0];
//     search.params['end' + propName] = dateRange[1];
//   }
//   return search;
// }
// 回显数据字典
export function selectDictLabel(datas, value) {
	if (value === undefined) {
		return '';
	}
	var actions = [];
	Object.keys(datas).some(key => {
		if (datas[key].value == '' + value) {
			actions.push(datas[key].label);
			return true;
		}
	});
	if (actions.length === 0) {
		actions.push(value);
	}
	return actions.join('');
}

// 回显数据字典（字符串、数组）
export function selectDictLabels(datas, value, separator) {
	if (value === undefined || value.length === 0) {
		return '';
	}
	if (Array.isArray(value)) {
		value = value.join(',');
	}
	var actions = [];
	var currentSeparator = undefined === separator ? ',' : separator;
	var temp = value.split(currentSeparator);
	Object.keys(value.split(currentSeparator)).some(val => {
		var match = false;
		Object.keys(datas).some(key => {
			if (datas[key].value == '' + temp[val]) {
				actions.push(datas[key].label + currentSeparator);
				match = true;
			}
		});
		if (!match) {
			actions.push(temp[val] + currentSeparator);
		}
	});
	return actions.join('').substring(0, actions.join('').length - 1);
}

// 字符串格式化(%s )
export function sprintf(str) {
	var args = arguments,
		flag = true,
		i = 1;
	str = str.replace(/%s/g, function () {
		var arg = args[i++];
		if (typeof arg === 'undefined') {
			flag = false;
			return '';
		}
		return arg;
	});
	return flag ? str : '';
}

// 转换字符串，undefined,null等转化为""
export function parseStrEmpty(str) {
	if (!str || str == 'undefined' || str == 'null') {
		return '';
	}
	return str;
}

// 数据合并
export function mergeRecursive(source, target) {
	for (var p in target) {
		try {
			if (target[p].constructor == Object) {
				source[p] = mergeRecursive(source[p], target[p]);
			} else {
				source[p] = target[p];
			}
		} catch (e) {
			source[p] = target[p];
		}
	}
	return source;
}

/**
 * 构造树型结构数据
 * @param {*} data 数据源
 * @param {*} id id字段 默认 'id'
 * @param {*} parentId 父节点字段 默认 'parentId'
 * @param {*} children 孩子节点字段 默认 'children'
 */
export function handleTree(data, id, parentId, children) {
	// 预处理
	const config = {
		id: id || 'id',
		parentId: parentId || 'parentId',
		childrenList: children || 'children'
	};

	var childrenListMap = {};
	var nodeIds = {};
	var tree = [];

	// 遍历传来的数组的每一个对象 d是每一个item
	for (const d of data) {
		const parentId = d[config.parentId]; // 拿到每一个item的父节点id

		// 父节点=null
		if (childrenListMap[parentId] == null) {
			childrenListMap[parentId] = [];
		}

		// d[config.id] => d.id
		nodeIds[d[config.id]] = d;
		childrenListMap[parentId].push(d);
	}

	for (const d of data) {
		const parentId = d[config.parentId]; // 拿到父id
		if (nodeIds[parentId] == null) {
			tree.push(d);
		}
	}

	for (const t of tree) {
		adaptToChildrenList(t);
	}

	// 递归
	function adaptToChildrenList(o) {
		if (childrenListMap[o[config.id]] !== null) {
			o[config.childrenList] = childrenListMap[o[config.id]];
		}
		if (o[config.childrenList]) {
			for (const c of o[config.childrenList]) {
				adaptToChildrenList(c);
			}
		}
	}

	return tree;
}

/**
 * 参数处理
 * @param {*} params  参数
 */
export function tansParams(params) {
	let result = '';
	for (const propName of Object.keys(params)) {
		const value = params[propName];
		var part = encodeURIComponent(propName) + '=';
		if (value !== null && value !== '' && typeof value !== 'undefined') {
			if (typeof value === 'object') {
				for (const key of Object.keys(value)) {
					if (
						value[key] !== null &&
						value[key] !== '' &&
						typeof value[key] !== 'undefined'
					) {
						const params = propName + '[' + key + ']';
						var subPart = encodeURIComponent(params) + '=';
						result += subPart + encodeURIComponent(value[key]) + '&';
					}
				}
			} else {
				result += part + encodeURIComponent(value) + '&';
			}
		}
	}
	return result;
}

// 验证是否为blob格式
export function blobValidate(data) {
	return data.type !== 'application/json';
}
