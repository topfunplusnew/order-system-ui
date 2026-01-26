// 通用工具函数
// 从 order-system/src/utils/index.js 提取的通用部分

/**
 * 获取 URL 查询参数对象
 * @param {string} url
 * @returns {Object}
 */
export function getQueryObject(url) {
	url = url == null ? window.location.href : url;
	const search = url.substring(url.lastIndexOf('?') + 1);
	const obj = {};
	const reg = /([^?&=]+)=([^?&=]*)/g;
	search.replace(reg, (rs, $1, $2) => {
		const name = decodeURIComponent($1);
		let val = decodeURIComponent($2);
		val = String(val);
		obj[name] = val;
		return rs;
	});
	return obj;
}

/**
 * 计算字符串字节长度
 * @param {string} str
 * @returns {number}
 */
export function byteLength(str) {
	let s = str.length;
	for (var i = str.length - 1; i >= 0; i--) {
		const code = str.charCodeAt(i);
		if (code > 0x7f && code <= 0x7ff) s++;
		else if (code > 0x7ff && code <= 0xffff) s += 2;
		if (code >= 0xdc00 && code <= 0xdfff) i--;
	}
	return s;
}

/**
 * 清理数组中的假值
 * @param {Array} actual
 * @returns {Array}
 */
export function cleanArray(actual) {
	const newArray = [];
	for (let i = 0; i < actual.length; i++) {
		if (actual[i]) {
			newArray.push(actual[i]);
		}
	}
	return newArray;
}

/**
 * 对象转 URL 参数
 * @param {Object} json
 * @returns {string}
 */
export function param(json) {
	if (!json) return '';
	return cleanArray(
		Object.keys(json).map(key => {
			if (json[key] === undefined) return '';
			return encodeURIComponent(key) + '=' + encodeURIComponent(json[key]);
		})
	).join('&');
}

/**
 * URL 参数转对象
 * @param {string} url
 * @returns {Object}
 */
export function param2Obj(url) {
	const search = decodeURIComponent(url.split('?')[1]).replace(/\+/g, ' ');
	if (!search) {
		return {};
	}
	const obj = {};
	const searchArr = search.split('&');
	searchArr.forEach(v => {
		const index = v.indexOf('=');
		if (index !== -1) {
			const name = v.substring(0, index);
			const val = v.substring(index + 1, v.length);
			obj[name] = val;
		}
	});
	return obj;
}

/**
 * HTML 转纯文本
 * @param {string} val
 * @returns {string}
 */
export function html2Text(val) {
	const div = document.createElement('div');
	div.innerHTML = val;
	return div.textContent || div.innerText;
}

/**
 * 对象深度合并
 * @param {Object} target
 * @param {Object|Array} source
 * @returns {Object}
 */
export function objectMerge(target, source) {
	if (typeof target !== 'object') {
		target = {};
	}
	if (Array.isArray(source)) {
		return source.slice();
	}
	Object.keys(source).forEach(property => {
		const sourceProperty = source[property];
		if (typeof sourceProperty === 'object') {
			target[property] = objectMerge(target[property], sourceProperty);
		} else {
			target[property] = sourceProperty;
		}
	});
	return target;
}

/**
 * 切换元素的 class
 * @param {HTMLElement} element
 * @param {string} className
 */
export function toggleClass(element, className) {
	if (!element || !className) {
		return;
	}
	let classString = element.className;
	const nameIndex = classString.indexOf(className);
	if (nameIndex === -1) {
		classString += '' + className;
	} else {
		classString = classString.substr(0, nameIndex) + classString.substr(nameIndex + className.length);
	}
	element.className = classString;
}

/**
 * 防抖函数
 * @param {Function} func
 * @param {number} wait
 * @param {boolean} immediate
 * @returns {Function}
 */
export function debounce(func, wait, immediate) {
	let timeout, args, context, timestamp, result;

	const later = function () {
		const last = +new Date() - timestamp;

		if (last < wait && last > 0) {
			timeout = setTimeout(later, wait - last);
		} else {
			timeout = null;
			if (!immediate) {
				result = func.apply(context, args);
				if (!timeout) context = args = null;
			}
		}
	};

	return function (...args) {
		context = this;
		timestamp = +new Date();
		const callNow = immediate && !timeout;
		if (!timeout) timeout = setTimeout(later, wait);
		if (callNow) {
			result = func.apply(context, args);
			context = args = null;
		}

		return result;
	};
}

/**
 * 简单深拷贝
 * @param {Object} source
 * @returns {Object}
 */
export function deepClone(source) {
	if (!source && typeof source !== 'object') {
		throw new Error('error arguments', 'deepClone');
	}
	const targetObj = source.constructor === Array ? [] : {};
	Object.keys(source).forEach(keys => {
		if (source[keys] && typeof source[keys] === 'object') {
			targetObj[keys] = deepClone(source[keys]);
		} else {
			targetObj[keys] = source[keys];
		}
	});
	return targetObj;
}

/**
 * 数组去重
 * @param {Array} arr
 * @returns {Array}
 */
export function uniqueArr(arr) {
	return Array.from(new Set(arr));
}

/**
 * 生成唯一字符串
 * @returns {string}
 */
export function createUniqueString() {
	const timestamp = +new Date() + '';
	const randomNum = parseInt((1 + Math.random()) * 65536) + '';
	return (+(randomNum + timestamp)).toString(32);
}

/**
 * 检查元素是否有指定 class
 * @param {HTMLElement} ele
 * @param {string} cls
 * @returns {boolean}
 */
export function hasClass(ele, cls) {
	return !!ele.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'));
}

/**
 * 添加 class
 * @param {HTMLElement} ele
 * @param {string} cls
 */
export function addClass(ele, cls) {
	if (!hasClass(ele, cls)) ele.className += ' ' + cls;
}

/**
 * 移除 class
 * @param {HTMLElement} ele
 * @param {string} cls
 */
export function removeClass(ele, cls) {
	if (hasClass(ele, cls)) {
		const reg = new RegExp('(\\s|^)' + cls + '(\\s|$)');
		ele.className = ele.className.replace(reg, ' ');
	}
}

/**
 * 首字母大写
 * @param {string} str
 * @returns {string}
 */
export function titleCase(str) {
	return str.replace(/( |^)[a-z]/g, L => L.toUpperCase());
}

/**
 * 下划线转驼峰
 * @param {string} str
 * @returns {string}
 */
export function camelCase(str) {
	return str.replace(/_[a-z]/g, str1 => str1.substr(-1).toUpperCase());
}

/**
 * 判断是否为数字字符串
 * @param {string} str
 * @returns {boolean}
 */
export function isNumberStr(str) {
	return /^[+-]?(0|([1-9]\d*))(\.\d+)?$/g.test(str);
}

/**
 * 判空，空值返回 '-'
 * @param {*} value
 * @returns {*}
 */
export function isEmpty(value) {
	if (value === null || value === undefined || value === '') {
		return '-';
	} else {
		return value;
	}
}

/**
 * 创建 Map 对象
 * @param {string} str
 * @param {boolean} expectsLowerCase
 * @returns {Function}
 */
export function makeMap(str, expectsLowerCase) {
	const map = Object.create(null);
	const list = str.split(',');
	for (let i = 0; i < list.length; i++) {
		map[list[i]] = true;
	}
	return expectsLowerCase ? val => map[val.toLowerCase()] : val => map[val];
}
