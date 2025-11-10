// 认证相关的通用工具函数
// 从 order-system/src/utils/auth.js 提取通用部分

// 这里可以放置通用的认证工具函数
// 注意：如果原文件有业务逻辑，需要保留在原位置

export const getToken = () => {
	// 通用实现
	return localStorage.getItem('token') || sessionStorage.getItem('token');
};

export const setToken = (token) => {
	localStorage.setItem('token', token);
};

export const removeToken = () => {
	localStorage.removeItem('token');
	sessionStorage.removeItem('token');
};

