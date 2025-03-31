export const JsonUtils = {
	getJson(json) {
		// console.log(json);
		try {
			if (typeof json !== 'string') {
				console.log('输入的数据不是有效的 JSON 字符串'); // 替换为 console.log
				return null;
			}
			return JSON.parse(json);
		} catch (error) {
			console.log('JSON 解析失败'); // 替换为 console.log
			return null;
		}
	},

	getJsonString(json) {
		try {
			if (typeof json !== 'object' || json === null) {
				console.log('输入的数据不是有效的对象'); // 替换为 console.log
				return '';
			}
			return JSON.stringify(json);
		} catch (error) {
			console.log('对象序列化失败'); // 替换为 console.log
			return '';
		}
	}
};

/**
 * 补齐 JSON 数据
 * @param {Object} template 完整的 JSON 数据（模板）
 * @param {Object} incomplete 不完整的 JSON 数据
 * @returns {Object} 补齐后的 JSON 数据
 */
export function completeJsonData(template, incomplete) {
	return Object.keys(template).reduce((result, key) => {
		result[key] = key in incomplete ? incomplete[key] : template[key];
		return result;
	}, {});
}

export class TypeUtils {
	checkType(variable) {
		if (typeof variable === 'object' && variable !== null) {
			if (Array.isArray(variable)) {
				return 'Array';
			} else {
				return 'Object';
			}
		} else {
			return 'Not an object or array';
		}
	}
}

/**
 * 判断是否为今天
 * @param dateStr
 * @returns {boolean}
 */
export function isToday(dateStr) {
	const inputDate = new Date(dateStr); // 将 yyyy-MM-dd 转换为 Date 对象
	if (isNaN(inputDate)) return false; // 如果日期无效，直接返回 false

	const today = new Date();

	return inputDate.getFullYear() === today.getFullYear() && inputDate.getMonth() === today.getMonth() && inputDate.getDate() === today.getDate();
}
