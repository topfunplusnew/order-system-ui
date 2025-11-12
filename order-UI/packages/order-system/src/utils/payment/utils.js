import { TableName } from '@/api/tool/enums';

/**
 * 判断对象中的 tableReferences 是否包含指定的表名引用
 * @param {Object} data - 包含 tableReferences 属性的对象
 * @param {string} tableName - TableName 枚举值，要查找的表名
 * @returns {boolean} - 如果 tableReferences 中存在匹配的 refTableName，返回 true，否则返回 false
 */
export function hasTableReference(data, tableName) {
	// 判断传入的对象是否有 tableReferences 属性
	if (!data || !data.tableReferences) {
		return false;
	}

	// 判断 tableReferences 是否为数组
	if (!Array.isArray(data.tableReferences)) {
		return false;
	}

	// 判断 tableReferences 数组中是否有任何一个对象的 refTableName 等于传入的 tableName
	return data.tableReferences.some(item => {
		return item && item.refTableName === tableName;
	});
}

