// 共享常量定义

export const API_BASE_URL = process.env.VUE_APP_BASE_API || '/dev-api';

export const HTTP_STATUS = {
	SUCCESS: 200,
	UNAUTHORIZED: 401,
	FORBIDDEN: 403,
	NOT_FOUND: 404,
	SERVER_ERROR: 500
};

export const STORAGE_KEYS = {
	TOKEN: 'token',
	USER_INFO: 'userInfo',
	SETTINGS: 'settings'
};
