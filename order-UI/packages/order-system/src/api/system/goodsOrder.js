import request from '@/utils/request';
// import { MessageBox } from 'element-ui';
import { BatchQueryTableName } from '@/api/tool/enums';

// 查询订单列表
export function listGoodsOrder(query) {
	// if (!query || !query.orderDateStart || !query.orderDateEnd) {
	// 	const KEY = 'HINT_GOODS_ORDER_DATE_ONCE';
	// 	if (!sessionStorage.getItem(KEY)) {
	// 		// 仅在本次会话首次提示，且不阻塞请求
	// 		MessageBox.alert('选择时间后可加速查询', '提示', {
	// 			confirmButtonText: '我知道了',
	// 			type: 'warning',
	// 			callback: () => sessionStorage.setItem(KEY, 'true')
	// 		});
	// 	}
	// }
	return request({
		url: '/system/goodsOrder/list',
		method: 'get',
		params: query
	});
}

// 查询订单详细
export function getGoodsOrder(id) {
	return request({
		url: '/system/goodsOrder/' + id,
		method: 'get'
	});
}

// 新增订单
export function addGoodsOrder(data) {
	return request({
		url: '/system/goodsOrder',
		method: 'post',
		data: data
	});
}

// 修改订单
export function updateGoodsOrder(data) {
	return request({
		url: '/system/goodsOrder',
		method: 'put',
		data: data
	});
}

// 删除订单
export function delGoodsOrder(id) {
	return request({
		url: '/system/goodsOrder/' + id,
		method: 'delete'
	});
}

// 调整单
export function adjustGoodsOrder(data) {
	return request({
		url: '/system/goodsOrder/adjust',
		method: 'put',
		data: data
	});
}

// 审核订单
export function auditGoodsOrder(data) {
	return request({
		url: '/system/goodsOrder/audit',
		method: 'put',
		params: {
			id: data.id,
			isaudit: data.isaudit
		}
	});
}

// 查询订单历史信息
export function getHistoryGoodsOrder(query) {
	return request({
		url: '/system/goodsOrderBack/list',
		method: 'get',
		params: query
	});
}

// 根据订单id检查
export function checkOrderAllinvoice(params) {
	return request({
		url: '/system/allinvoice/checkInvoiceAmount',
		method: 'get',
		params: params
	});
}

// 根据orderNo获取订单详细信息
export function checkOrderByOrderNo(orderNo) {
	return request({
		url: '/system/goodsOrder/orderNo/' + orderNo,
		method: 'get'
	});
}

/**
 * 检查是否为订单的表名
 * @param {string} tableName
 * @returns {boolean}
 */
export function isGoodsOrderDisplay(tableName) {
	return [BatchQueryTableName.GOODS_ORDER, BatchQueryTableName.ORDER_DETAIL].includes(tableName);
}
/**
 * 检查是否为库存的表名
 * @param {string} tableName
 * @returns {boolean}
 */
export function isInventoryDisplay(tableName) {
	return [BatchQueryTableName.INVENTORY_MAIN, BatchQueryTableName.INVENTORY_DETAIL].includes(tableName);
}
/**
 * 根据表名和ID列表批量查询数据
 * 通用的批量查询接口，支持查询任意表的指定ID记录
 *
 * @param {Object} params - 查询参数对象
 * @param {string} params.tableName - 要查询的表名，如 'inventory_detail', 'goodsOrder' 等
 * @param {Array<number|string>|number|string} params.ids - 要查询的ID列表，支持数组或单个值
 * @param {Object} [params.otherParams] - 其他可选的查询参数
 */
export function getBussinessInfoTodayList(params) {
	if (!params) {
		console.warn('请求参数非法');
		return Promise.reject(new Error('请求参数不能为空'));
	}

	// 验证必要参数
	if (!params.tableName) {
		console.warn('tableName参数不能为空');
		return Promise.reject(new Error('tableName参数不能为空'));
	}

	// 验证tableName是否为有效的枚举值
	const validTableNames = Object.values(BatchQueryTableName);
	if (!validTableNames.includes(params.tableName)) {
		const errorMsg = `tableName参数值无效: ${params.tableName}，有效值为: ${validTableNames.join(', ')}`;
		console.warn(errorMsg);
		return Promise.reject(new Error(errorMsg));
	}

	if (!params.ids || (!Array.isArray(params.ids) && !params.ids)) {
		console.warn('ids参数不能为空');
		return Promise.reject(new Error('ids参数不能为空'));
	}

	return request({
		url: '/system/batchQuery/queryByTableNameAndIds',
		method: 'post',
		params: params
	});
}
