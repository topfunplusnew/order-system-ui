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
