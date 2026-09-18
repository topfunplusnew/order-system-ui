/**
 * 「根据供应商选择订单 / 根据供应商所选货物列表」两个弹窗之间的时间范围处理
 *
 * 背景：货物列表弹窗（OrderDetailList）里的时间选择器绑定的是 queryParams.orderDateRange（daterange 数组），
 *      而 listOrderDetail 接口的时间筛选参数是 params.beginTime / params.endTime，需要在发请求前转换。
 *
 * 接口状态（apifox 已更新）：listOrderDetail 的 params.beginTime / params.endTime 已支持范围查找，
 * 因此时间条件统一走这两个字段（convertOrderDateRangeToParams）。
 * 注意：不要再发送 orderDate —— 范围查找已覆盖它，同时传单个日期会与范围叠加导致结果被多筛一次。
 */

/**
 * 把时间选择器的 orderDateRange 转换成后端约定的 params.beginTime / params.endTime
 * @param {Object} query - 查询对象（货物列表弹窗给出的对象里带 orderDateRange）
 * @returns {{query: Object, hasOrderDateRange: boolean, orderDateRange: Array|null}}
 *          可直接用于请求的查询对象；是否由货物列表弹窗的时间选择器提供；选择器的起止日期
 */
export function convertOrderDateRangeToParams(query) {
	const normalized = { ...(query || {}) };
	// 只有调用方（货物列表弹窗）自己带了这个字段，才认为时间以它为准：传数组 → 用数组；传 null → 已清空
	const hasOrderDateRange = Object.prototype.hasOwnProperty.call(normalized, 'orderDateRange');
	const orderDateRange = Array.isArray(normalized.orderDateRange) ? normalized.orderDateRange : null;
	if (hasOrderDateRange) {
		normalized.params = {
			...(normalized.params || {}),
			beginTime: (orderDateRange && orderDateRange[0]) || null,
			endTime: (orderDateRange && orderDateRange[1]) || null
		};
	}
	// orderDateRange 只是前端选择器的载体，不作为请求参数发给后端
	delete normalized.orderDateRange;
	return { query: normalized, hasOrderDateRange, orderDateRange };
}

/**
 * 取筛选字段的值：以「根据供应商所选货物列表」弹窗表单里的值为准。
 * - 表单里有这个字段（包括被清空成的 '' / null）→ 用表单的值，保证"清空后不再带旧条件"；
 * - 表单里完全没有这个字段（还没参与过筛选）→ 才回退到「根据供应商选择订单」弹窗里的值。
 * @param {Object} query - 货物列表弹窗给出的查询对象
 * @param {string} key - 字段名
 * @param {*} fallback - 回退值（上级弹窗的值）
 * @returns {*} 最终用于请求的值
 */
export function pickFilterValue(query, key, fallback) {
	if (query && Object.prototype.hasOwnProperty.call(query, key)) {
		return query[key] ?? null;
	}
	return fallback ?? null;
}

/**
 * 解析时间范围：货物列表弹窗的时间选择器优先，没有则由上级（根据供应商选择订单）的开始/结束时间兜底
 * @param {Object} params - 货物列表弹窗查询对象中的 params（已由 convertOrderDateRangeToParams 转换）
 * @param {Object} supplierParams - 「根据供应商选择订单」弹窗的 params（含 beginTime / endTime）
 * @param {boolean} hasOrderDateRange - 是否由货物列表弹窗的时间选择器提供范围
 * @returns {{beginTime: *, endTime: *}} 最终用于请求的时间范围（null 表示不带该条件）
 */
export function resolveBeginEndTime(params, supplierParams, hasOrderDateRange) {
	if (hasOrderDateRange) {
		return {
			beginTime: params?.beginTime ?? null,
			endTime: params?.endTime ?? null
		};
	}
	return {
		beginTime: supplierParams?.beginTime ?? params?.beginTime ?? null,
		endTime: supplierParams?.endTime ?? params?.endTime ?? null
	};
}
