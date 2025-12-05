// 认证相关的通用工具函数
// 从 order-system/src/utils/auth.js 提取通用部分

// 这里可以放置通用的认证工具函数
// 注意：如果原文件有业务逻辑，需要保留在原位置

import Cookies from 'js-cookie';

const TokenKey = 'Admin-Token';

export function getToken() {
	return Cookies.get(TokenKey);
}

export function setToken(token) {
	return Cookies.set(TokenKey, token);
}

export function removeToken() {
	return Cookies.remove(TokenKey);
}
