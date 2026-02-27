import request from '@/utils/request';
// import { MessageBox } from 'element-ui';
import { BatchQueryTableName } from '@/api/tool/enums';
import _ from 'lodash';

// 查询订单列表
export function listGoodsOrder(query) {
	return request({
		url: '/system/goodsOrder/list',
		method: 'get',
		params: query
	});
}

// 查询订单列表(含完整子表)
export function listWithFullDetail(query) {
	return request({
		url: '/system/goodsOrder/listWithFullDetail',
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

// 查询订单的所有发货单
export function getSameDayOrders(id) {
	return request({
		url: '/system/goodsOrder/' + id + '/sameDayOrders',
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

// 更新订单附件 二次上传 审核后可以上传
export function updateGoodsOrderAttachments(data) {
	return request({
		url: '/system/goodsOrder/attachments',
		method: 'put',
		data: data
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

// 查看某个历史订单的详细信息
export function getHistoryGoodsOrderInfo(id) {
	return request({
		url: `/system/goodsOrderBack/${id}`,
		method: 'get',
		params: query
	});
}

// 查询订单今日原因
export function getGoodsOrderTodayReason(orderId) {
	return request({
		url: '/system/goodsOrderBack/todayReason',
		method: 'get',
		params: {
			orderId: orderId
		}
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
	// 处理ids参数 - 构建查询字符串
	const idsArray = Array.isArray(params.ids) ? params.ids : [params.ids];
	const queryString = `tableName=${params.tableName}&${idsArray.map(id => `ids=${id}`).join('&')}`;
	return request({
		url: `/system/batchQuery/queryByTableNameAndIds?${queryString}`,
		method: 'post'
	});
}

/**
 * 合并订单和库存的特殊表格数据
 * 将同一日期同一类型（订单/库存）的多条记录合并为一条，便于前端展示
 * @param {Array} sourceData - 原始数据数组
 * @returns {Array} 合并后的数据数组
 */
export function mergeSpecialTableData(sourceData) {
	// 使用 lodash 按条件分组数据
	const partitionResult = _.partition(sourceData, item => {
		const isSpecial = isGoodsOrderDisplay(item.tableName) || isInventoryDisplay(item.tableName);
		return isSpecial;
	});

	// 两组数据：一组是订单或者库存，一组是其他
	const specialData = partitionResult[0];
	const otherData = partitionResult[1];

	// 对订单或者库存的数据按日期和类型进行分组
	const groupedSpecialData = _.groupBy(specialData, item => {
		const date = item.operateDate.match(/^(\d{4}-\d{2}-\d{2})/)[1];
		const isOrder = isGoodsOrderDisplay(item.tableName);

		// 任务10：goodsorder 同日同时存在【订单/调整单】时，需要按 flag 拆分分组，避免被合并后无法区分
		if (isOrder) {
			const flag = item.flag || 'default';
			return `${date}_order_${flag}`;
		}

		return `${date}_inventory`;
	});

	const mergedData = _.flatMap(groupedSpecialData, items => {
		if (items.length === 1) {
			// 单条数据，将关键字段转为数组格式
			const singleItem = { ...items[0] };
			singleItem.payNo = [singleItem.payNo];
			singleItem.summary = [singleItem.summary];
			return [singleItem];
		}

		// 合并多条记录 - 收集不同字段到数组中
		const baseItem = _.head(items);
		const merged = {
			...baseItem,
			// 将不同的payNo收集到数组中
			payNo: _.uniq(_.map(items, item => item.payNo)),
			// 将不同的summary收集到数组中
			summary: _.uniq(_.map(items, 'summary')),
			// 计算总金额
			moneyAmount: _.sumBy(items, item => Number(item.moneyAmount))
		};

		return [merged];
	});

	// 对其他数据也进行相同处理，确保字段格式统一
	const processedOtherData = otherData.map(item => ({
		...item,
		payNo: [item.payNo],
		summary: [item.summary]
	}));

	// 返回合并后的数据和其他数据
	return _.concat(mergedData, processedOtherData).sort((a, b) => new Date(a.operateDate) - new Date(b.operateDate));
}

// 下载订单导入模板
export function downloadImportTemplate() {
	return request({
		url: '/system/goodsOrder/importTemplate',
		method: 'post',
		responseType: 'blob'
	});
}

// 导入订单数据
export function importOrderData(formData) {
	return request({
		url: '/system/goodsOrder/importData',
		method: 'post',
		data: formData,
		headers: {
			'Content-Type': 'multipart/form-data'
		}
	});
}
