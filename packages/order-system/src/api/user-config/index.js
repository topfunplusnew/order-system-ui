import request from '@/utils/request';

// 查询用户配置列表
export function getUserConfig(configKey) {
	return request({
		url: `/system/user-config/${configKey}`,
		method: 'get'
	});
}

// 批量查询用户配置
export function batchGetUserConfig(keys) {
	return request({
		url: '/system/user-config/batch',
		method: 'post',
		data: {
			keys: keys
		}
	});
}

// 新增或更新用户配置
export function saveUserConfig(key, value) {
	return request({
		url: '/system/user-config',
		method: 'post',
		data: {
			key: key,
			value: value
		}
	});
}

// 批量删除用户配置
export function batchDeleteUserConfig(keys) {
	return request({
		url: '/system/user-config',
		method: 'delete',
		data: {
			keys: keys
		}
	});
}
