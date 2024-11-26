import request from '@/utils/request';

// 查询唱单制列表
// todo 唱台和台阶的接口互换
export function listSalessingorderincentivedetails(query) {
	return request({
		url: '/system/salesstepincentivedetails/list',
		method: 'get',
		params: query
	});
}

// 查询唱单制详细
export function getSalessingorderincentivedetails(id) {
	return request({
		url: '/system/salesstepincentivedetails/' + id,
		method: 'get'
	});
}

// 新增唱单制
export function addSalessingorderincentivedetails(data) {
	return request({
		url: '/system/salesstepincentivedetails',
		method: 'post',
		data: data
	});
}

// 修改唱单制
export function updateSalessingorderincentivedetails(data) {
	return request({
		url: '/system/salesstepincentivedetails',
		method: 'put',
		data: data
	});
}

// 删除唱单制
export function delSalessingorderincentivedetails(id) {
	return request({
		url: '/system/salesstepincentivedetails/' + id,
		method: 'delete'
	});
}

/**
 * import request from '@/utils/request'
 *
 * // 查询台阶制列表
 * export function listSalesstepincentivedetails(query) {
 *   return request({
 *     url: '/system/salesstepincentivedetails/list',
 *     method: 'get',
 *     params: query
 *   })
 * }
 *
 * // 查询台阶制详细
 * export function getSalesstepincentivedetails(id) {
 *   return request({
 *     url: '/system/salesstepincentivedetails/' + id,
 *     method: 'get'
 *   })
 * }
 *
 * // 新增台阶制
 * export function addSalesstepincentivedetails(data) {
 *   return request({
 *     url: '/system/salesstepincentivedetails',
 *     method: 'post',
 *     data: data
 *   })
 * }
 *
 * // 修改台阶制
 * export function updateSalesstepincentivedetails(data) {
 *   return request({
 *     url: '/system/salesstepincentivedetails',
 *     method: 'put',
 *     data: data
 *   })
 * }
 *
 * // 删除台阶制
 * export function delSalesstepincentivedetails(id) {
 *   return request({
 *     url: '/system/salesstepincentivedetails/' + id,
 *     method: 'delete'
 *   })
 * }
 */
