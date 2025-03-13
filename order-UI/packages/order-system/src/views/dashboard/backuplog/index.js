export const JsonUtils = {
	getJson(json) {
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
 * @param {Object} completeJson 完整的 JSON 数据（模板）
 * @param {Object} incompleteJson 不完整的 JSON 数据
 * @returns {Object} 补齐后的 JSON 数据
 */
export function completeJsonData(completeJson, incompleteJson) {
	// 创建一个新对象，避免直接修改原始数据
	const result = { ...incompleteJson };

	// 遍历完整 JSON 的所有属性
	for (const key in completeJson) {
		// 如果当前属性在不完整的 JSON 中不存在，则补齐
		if (!(key in result)) {
			result[key] = null; // 补齐为 null
		}
	}

	return result;
}
