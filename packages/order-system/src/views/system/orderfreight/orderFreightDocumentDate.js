/**
 * 提取运费记录对应业务单据的日期。
 * 订单运费使用订单日期，库存运费使用库存入库日期。
 *
 * @param {Object} row 运费列表或详情接口返回的行数据
 * @returns {string} 业务单据日期；旧数据缺少关联对象时返回空字符串
 */
export function getOrderFreightDocumentDate(row) {
	if (!row || typeof row !== 'object') return '';
	return row.goodsOrder?.orderDate || row.inventoryMain?.storeDate || '';
}
