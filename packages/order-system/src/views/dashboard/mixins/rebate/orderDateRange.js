/**
 * 「根据供应商选择订单 / 根据供应商所选货物列表」两个弹窗之间的时间范围处理
 *
 * 背景：货物列表弹窗（OrderDetailList）里的时间选择器绑定的是 queryParams.orderDateRange（daterange 数组），
 *      而 listOrderDetail 接口适配的时间筛选参数与选择器字段并不一致，需要在发请求前做处理。
 *
 * ============================ ⚠️ 接口限制标记（重要） ============================
 * listOrderDetail 目前【只支持 orderDate 一个时间字段】，
 * params.beginTime / params.endTime 后端尚未支持：传了也不会生效，属于无效参数。
 * 因此现在【刻意不发送 params[beginTime] / params[endTime]】（详见下方 stripOrderDateRange）。
 *
 * 待后端明确说支持以后，再把 orderDateRange 转成 params.beginTime / params.endTime：
 *   1) 在 getDetailBySupper / getDirectOrderDetailList 中把 stripOrderDateRange 换成 convertOrderDateRangeToParams；
 *   2) 把 convertOrderDateRangeToParams 的 @deprecated 标记去掉。
 * 在此之前请勿启用，避免又出现 orderDate + params[beginTime] + params[endTime] 三个时间字段混传。
 * ==============================================================================
 */

/**
 * 请求前清理（当前唯一启用的处理）
 * - orderDateRange 只是前端时间选择器的载体，不作为请求参数发给后端；
 * - 后端支持前，顺手剔除 params 里可能残留的 beginTime / endTime，避免混传多个时间字段。
 * @param {Object} query - 子组件（或供应商筛选弹窗）给出的查询对象
 * @returns {{query: Object, hasOrderDateRange: boolean, orderDateRange: Array|null}}
 *          可直接用于请求的查询对象；是否由货物列表弹窗的时间选择器提供；选择器的起止日期
 */
export function stripOrderDateRange(query) {
	const normalized = { ...(query || {}) };
	// 只有调用方（货物列表弹窗）自己带了这个字段，才认为时间以它为准：传数组 → 用数组；传 null → 已清空
	const hasOrderDateRange = Object.prototype.hasOwnProperty.call(normalized, 'orderDateRange');
	const orderDateRange = Array.isArray(normalized.orderDateRange) ? normalized.orderDateRange : null;
	delete normalized.orderDateRange;
	if (normalized.params) {
		const params = { ...normalized.params };
		delete params.beginTime;
		delete params.endTime;
		normalized.params = params;
	}
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
 * 把时间选择器的 orderDateRange 转换成后端约定的 params.beginTime / params.endTime
 *
 * @deprecated 后端 listOrderDetail 暂不支持 params.beginTime / params.endTime（只有 orderDate 可用），
 * 现在不要调用；后端确认支持后按本文件顶部标记接入。
 * @param {Object} query - 含 orderDateRange 的查询对象
 * @returns {{query: Object, hasOrderDateRange: boolean}} 转换后的查询对象；是否由选择器提供了范围
 */
export function convertOrderDateRangeToParams(query) {
	const normalized = { ...(query || {}) };
	const hasOrderDateRange = Object.prototype.hasOwnProperty.call(normalized, 'orderDateRange');
	if (hasOrderDateRange) {
		const range = Array.isArray(normalized.orderDateRange) ? normalized.orderDateRange : null;
		normalized.params = {
			...(normalized.params || {}),
			beginTime: (range && range[0]) || null,
			endTime: (range && range[1]) || null
		};
	}
	delete normalized.orderDateRange;
	return { query: normalized, hasOrderDateRange };
}
