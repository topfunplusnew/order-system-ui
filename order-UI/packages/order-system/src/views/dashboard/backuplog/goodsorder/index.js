import { TypeUtils } from '@/views/dashboard/backuplog';

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
 * @param jsonList 需要处理的json数组
 */
export function paramFieldFilter(jsonList) {
	const typeUtil = new TypeUtils();
	const operateJson = json => {
		const newJson = { ...json }; // 创建一个新对象
		for (const key in newJson) {
			const exclude = ['id', 'ID', 'Id'];
			exclude.forEach(item => {
				if (key === item || key.indexOf(item) !== -1) {
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
