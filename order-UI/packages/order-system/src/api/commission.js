// 厂家佣金和客户佣金
import service from '@/utils/request';
import { Message } from 'element-ui';
/**
 * 查询佣金信息列表
 * @description 返回的结果中 id是空的数据说明没有佣金信息 可以新增，否则不可以 只能付款
 * @param {Object} query - 查询参数对象
 * @param {string|number} type - 佣金类型 (0: 厂家佣金, 1: 客户佣金)
 * @returns {Promise} 返回佣金列表的Promise对象
 */
export function listCommission(query, type) {
	if (!query || !query.params.startTime || !query.params.endTime) {
		Message.warning('选择时间后可加速查询');
	}
	return service.request({
		url: '/system/ordercommission/list',
		method: 'get',
		params: {
			...query,
			type
		}
	});
}

/**
 * 根据ID获取单个佣金信息
 * @param {string|number} id - 佣金记录的ID
 * @returns {Promise} 返回佣金详情的Promise对象
 */
export function getCommission(id) {
	return service.request({
		url: '/system/ordercommission/' + id,
		method: 'get'
	});
}

/**
 * 新增佣金信息
 * @param {Object} data - 佣金数据对象
 * @param {number} data.type - 佣金类型
 * @param {number} data.orderDetailId - 订单详情ID
 * @param {number} data.commissionUnitPrice - 佣金单价
 * @param {number} [data.otherPaymentAmount] - 其他付款金额
 * @param {string} [data.difference_reason] - 差异原因
 * @param {Object} [data.extraInfo] - 额外信息对象
 * @returns {Promise} 返回新增结果的Promise对象
 */
export function addCommission(data) {
	return service.request({
		url: '/system/ordercommission',
		method: 'post',
		data: data
	});
}

/**
 * 更新佣金信息
 * @param {Object} data - 佣金数据对象，必须包含id字段
 * @param {string|number} data.id - 佣金记录的ID
 * @param {number} [data.type] - 佣金类型
 * @param {number} [data.orderDetailId] - 订单详情ID
 * @param {number} [data.commissionUnitPrice] - 佣金单价
 * @param {number} [data.otherPaymentAmount] - 其他付款金额
 * @param {string} [data.difference_reason] - 差异原因
 * @param {Object} [data.extraInfo] - 额外信息对象
 * @returns {Promise} 返回更新结果的Promise对象
 */
export function updateCommission(data) {
	return service.request({
		url: '/system/ordercommission',
		method: 'put',
		data: data
	});
}

/**
 * 批量填写佣金信息
 * @param {Array<Object>} data - 佣金数据数组
 * @param {number} data[].type - 佣金类型 (0: 厂家佣金, 1: 客户佣金)
 * @param {number} data[].orderDetailId - 订单详情ID
 * @param {number} data[].commissionUnitPrice - 佣金单价
 * @param {number} data[].otherPaymentAmount - 其他付款金额
 * @param {string} data[].difference_reason - 差异原因
 * @param {Object} data[].extraInfo - 额外信息对象
 * @param {string} data[].extraInfo.var - 变量
 * @param {string} data[].extraInfo.rebate - 折扣百分比
 * @param {string} data[].extraInfo.period - 周期
 * @returns {Promise} 返回批量添加结果的Promise对象
 * @example
 * // 批量添加佣金信息
 * const commissionData = [
 *   {
 *     type: 0,
 *     orderDetailId: 2,
 *     commissionUnitPrice: 1.200,
 *     otherPaymentAmount: 200.000,
 *     difference_reason: "计算错误已修正",
 *     extraInfo: {
 *       var: "var1",
 *       rebate: "2%",
 *       period: "monthly"
 *     }
 *   }
 * ];
 * batchAddCommission(commissionData);
 */
export function batchAddCommission(data) {
	return service.request({
		url: '/system/ordercommission/batch',
		method: 'post',
		data: data
	});
}

export function deleteCommission(id) {
	return service.request({
		url: '/system/ordercommission/' + id,
		method: 'delete'
	});
}

// 填写差异原因
export function updateDifferenceReason(id, differenceReason) {
	return service.request({
		url: `/system/ordercommission/reason/${id}`,
		method: 'put',
		params: {
			differenceReason
		}
	});
}
