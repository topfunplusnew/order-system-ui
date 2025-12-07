/**
 * 低代码系统 API
 */
import request from '@/utils/request';

const BASE_URL = 'http://localhost:3100/api/codeless';

// 页面管理 API
export const pageApi = {
	// 获取页面列表
	getList(params) {
		return request({
			url: `${BASE_URL}/pages`,
			method: 'get',
			params
		});
	},

	// 获取单个页面
	getById(id) {
		return request({
			url: `${BASE_URL}/pages/${id}`,
			method: 'get'
		});
	},

	// 创建页面
	create(data) {
		return request({
			url: `${BASE_URL}/pages`,
			method: 'post',
			data
		});
	},

	// 更新页面
	update(id, data) {
		return request({
			url: `${BASE_URL}/pages/${id}`,
			method: 'put',
			data
		});
	},

	// 删除页面
	delete(id) {
		return request({
			url: `${BASE_URL}/pages/${id}`,
			method: 'delete'
		});
	},

	// 复制页面
	copy(id) {
		return request({
			url: `${BASE_URL}/pages/${id}/copy`,
			method: 'post'
		});
	}
};

// 组件管理 API
export const componentApi = {
	// 获取组件列表
	getList(params) {
		return request({
			url: `${BASE_URL}/components`,
			method: 'get',
			params
		});
	},

	// 获取组件分类
	getCategories() {
		return request({
			url: `${BASE_URL}/components/categories`,
			method: 'get'
		});
	},

	// 获取单个组件
	getById(id) {
		return request({
			url: `${BASE_URL}/components/${id}`,
			method: 'get'
		});
	}
};

export default { pageApi, componentApi };
