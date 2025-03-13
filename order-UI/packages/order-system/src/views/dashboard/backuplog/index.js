export const JsonUtils = {
	getJson(json) {
		try {
			if (typeof json !== 'string') {
				this.$message.error('输入的数据不是有效的 JSON 字符串');
				return null;
			}
			return JSON.parse(json);
		} catch (error) {
			this.$message.error('JSON 解析失败');
			return null;
		}
	},

	getJsonString(json) {
		try {
			if (typeof json !== 'object' || json === null) {
				this.$message.error('输入的数据不是有效的对象');
				return '';
			}
			return JSON.stringify(json);
		} catch (error) {
			this.$message.error('对象序列化失败');
			return '';
		}
	}
};
