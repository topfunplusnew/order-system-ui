import { TypeUtils } from '@/views/dashboard/backuplog';
import { TableName } from '@/api/tool/enums';

/**
 * 键值对过滤器 对json的键进行特殊处理 操作为 先把字母大写 再去除下划线
 * @param json 需要处理的json对象
 */
export function keyOptioner(json) {
	return Object.keys(json).reduce((acc, key) => {
		const newKey = key.toUpperCase(); // 将键转换为大写
		acc[newKey] = json[key];
		return acc;
	}, {});
}

/**
 * 参数过滤器 需要对json中的属性键值和值进行过滤 比如订单编号，还有各种带id后端用来绑定用的字段等
 * @param {*} jsonList 需要处理的json数组
 * @param {Function[]} callbackList 回调函数数组 需要进行补充操作的函数数组
 * @param {String[]} excludeParams 需要排除的参数数组
 * @returns {*}
 */
export function paramFieldFilter(jsonList, callbackList = [], excludeParams = []) {
	const typeUtil = new TypeUtils();
	const operateJson = json => {
		const newJson = { ...json };
		for (const key in newJson) {
			// 产出包含id的
			const exclude = ['id', 'ID', 'Id'];
			exclude.forEach(item => {
				if (key === item || key.indexOf(item) !== -1) {
					delete newJson[key];
				}
			});

			if (!excludeParams) continue;
			// 删除包含创建时间和更新时间的
			excludeParams.forEach(item => {
				const is = key === item || key.indexOf(item) !== -1 || key.indexOf(item.toUpperCase()) !== -1 || key.indexOf(item.toLowerCase()) !== -1;
				if (is) {
					delete newJson[key];
				}
			});

			if (callbackList.length === 0) continue;

			callbackList.forEach(func => {
				if (!func) {
					throw new Error('paramFieldFilter函数出现问题，传入函数数组有错误:函数数组中有函数为空');
				}
				if (typeof func !== 'function') {
					throw new Error('paramFieldFilter函数出现问题，传入函数数组有错误:回调函数必须为函数类型');
				}
				if (func(key)) {
					delete newJson[key];
				}
			});
		}
		return newJson;
	};

	if (typeUtil.checkType(jsonList) === 'Object') {
		return operateJson(jsonList);
	}

	if (typeUtil.checkType(jsonList) === 'Array') {
		return jsonList.map(json => operateJson(json));
	}
}

/**
 * 类型过滤器 根据备份数据行的backupType进行处理
 * @param backupRow 备份数据行的对象
 */
export function typeFilter(backupRow) {
	if (backupRow.originalInfo === 'null' && backupRow.changedInfo === 'null') {
		console.error('备份数据行originalInfo和changedInfo为null,索引为:', backupRow.id);
	}
	if (backupRow.backupType === 'insert') {
		backupRow.originalInfo = backupRow.changedInfo;
		return backupRow;
	}
	if (backupRow.backupType === 'delete' || backupRow.backupType === 'update') {
		backupRow.changedInfo = backupRow.originalInfo;
		return backupRow;
	}
}

// 将订单详情的数据归类到订单主表信息
export function filtersFunc(tableName) {
	switch (tableName) {
		case TableName.ORDER_DETAIL:
			return TableName.GOODS_ORDER;
		case TableName.INVENTORDETAIL:
			return TableName.INVENTORMAIN;
		default:
			return tableName;
	}
}

export function transFuc(tableName) {
	switch (tableName) {
		case TableName.GOODS_ORDER:
			return TableName.ORDER_DETAIL;
		case TableName.INVENTORMAIN:
			return TableName.INVENTORDETAIL;
		default:
			return tableName;
	}
}
