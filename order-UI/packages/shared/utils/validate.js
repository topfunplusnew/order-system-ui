// 通用验证工具函数
// 从 order-system/src/utils/validate.js 提取通用部分

// 这里可以放置通用的验证函数
// 注意：如果原文件有业务逻辑，需要保留在原位置

export const isEmail = (str) => {
	const reg = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;
	return reg.test(str);
};

export const isPhone = (str) => {
	const reg = /^1[3-9]\d{9}$/;
	return reg.test(str);
};

