import request from '@/utils/request';

// ==================== 基础CRUD操作 ====================

/**
 * 查询销售奖励列表
 * 分页查询销售奖励，可按奖励类型、人员身份、客户名称、审核状态、支付状态，以及订单/奖励日期区间等条件过滤
 * @param {Object} query - 查询参数
 * @param {number} [query.pageNum=1] - 页码，从 1 开始，默认 1
 * @param {number} [query.pageSize=10] - 每页数量，默认 10，最大 200
 * @param {string} query.incentiveType - 奖励类型过滤，可选：铁匠 / 台阶 / 唱单
 * @param {number} [query.orderId] - 指定来源订单ID
 * @param {string} [query.rewardReceiver] - 接受奖励人员，模糊匹配
 * @param {string} [query.auditState] - 审核状态，可选：未审核 / 已审核
 * @param {string} [query.paymentStatus] - 支付状态：PAID=已支付（存在支付金额），UNPAID=未支付
 * @param {string} [query.orderDateBegin] - 订单日期开始（yyyy-MM-dd），服务端自动补足 00:00:00
 * @param {string} [query.orderDateEnd] - 订单日期结束（yyyy-MM-dd），服务端自动补足 23:59:59
 * @param {string} [query.rewardDateBegin] - 奖励日期开始（yyyy-MM-dd）
 * @param {string} [query.rewardDateEnd] - 奖励日期结束（yyyy-MM-dd）
 * @returns {Promise<Object>} 返回表格分页数据对象
 * @returns {number} returns.total - 总记录数
 * @returns {Array<Object>} returns.rows - 销售奖励列表数据
 * @returns {number} returns.rows[].id - 奖励主键ID
 * @returns {string} returns.rows[].incentiveType - 奖励类型（铁匠/台阶/唱单）
 * @returns {string} returns.rows[].personnelIdentity - 人员身份（销售经理/录入员）
 * @returns {number} returns.rows[].orderId - 关联订单ID
 * @returns {string} returns.rows[].orderDate - 订单日期
 * @returns {string} returns.rows[].customerName - 客户名称
 * @returns {string} returns.rows[].rewardReceiver - 奖励接收人
 * @returns {string} [returns.rows[].rewardReason] - 奖励原因
 * @returns {number} returns.rows[].orderProfit - 订单利润
 * @returns {number} [returns.rows[].manufacturerRebateDiscountAmount] - 厂家返利折扣金额
 * @returns {number} [returns.rows[].acceptanceDiscountProfit] - 承兑折扣利润
 * @returns {number} [returns.rows[].customerManufacturerCommissionAmount] - 客户厂家佣金金额
 * @returns {number} returns.rows[].comprehensiveProfit - 综合利润
 * @returns {number} [returns.rows[].paymentAmount] - 支付金额
 * @returns {number} returns.rows[].isTargetReached - 利润是否达标（0=未达标，1=达标）
 * @returns {number} returns.rows[].rewardAmount - 奖励金额
 * @returns {string} [returns.rows[].rewardDate] - 奖励日期
 * @returns {string} returns.rows[].auditState - 审核状态（未审核/已审核）
 * @returns {string} [returns.rows[].auditUserName] - 审核人姓名
 * @returns {string} returns.rows[].createBy - 创建人
 * @returns {string} returns.rows[].createTime - 创建时间
 * @returns {number} returns.code - 响应码（0表示成功）
 * @returns {string} returns.msg - 响应消息
 */
export function listSalesReward(query) {
	return request({
		url: '/system/salesReward/list',
		method: 'get',
		params: query
	});
}

/**
 * 获取奖励详情
 * 根据奖励主键ID查询完整详情，用于编辑或查看
 * @param {number|string} id - 奖励主键ID
 * @returns {Promise<Object>} 返回统一响应对象
 * @returns {number} returns.code - 响应码（200表示成功）
 * @returns {string} returns.msg - 响应消息
 * @returns {Object} returns.data - 销售奖励详情数据
 * @returns {number} returns.data.id - 奖励主键ID
 * @returns {string} returns.data.incentiveType - 奖励类型（铁匠/台阶/唱单）
 * @returns {string} returns.data.personnelIdentity - 人员身份（销售经理/录入员）
 * @returns {number} returns.data.orderId - 关联订单ID
 * @returns {string} returns.data.orderDate - 订单日期
 * @returns {string} returns.data.customerName - 客户名称
 * @returns {string} returns.data.rewardReceiver - 奖励接收人
 * @returns {string} [returns.data.rewardReason] - 奖励原因
 * @returns {number} returns.data.orderProfit - 订单利润
 * @returns {number} [returns.data.manufacturerRebateDiscountAmount] - 厂家返利折扣金额
 * @returns {number} [returns.data.acceptanceDiscountProfit] - 承兑折扣利润
 * @returns {number} [returns.data.customerManufacturerCommissionAmount] - 客户厂家佣金金额
 * @returns {number} returns.data.comprehensiveProfit - 综合利润
 * @returns {number} [returns.data.paymentAmount] - 支付金额
 * @returns {number} returns.data.isTargetReached - 利润是否达标（0=未达标，1=达标）
 * @returns {number} returns.data.rewardAmount - 奖励金额
 * @returns {string} [returns.data.rewardDate] - 奖励日期
 * @returns {string} returns.data.auditState - 审核状态（未审核/已审核）
 * @returns {string} [returns.data.auditUserName] - 审核人姓名
 * @returns {string} returns.data.createBy - 创建人
 * @returns {string} returns.data.createTime - 创建时间
 */
export function getSalesReward(id) {
	return request({
		url: `/system/salesReward/${id}`,
		method: 'get'
	});
}

/**
 * 新增奖励
 * 创建新的销售奖励记录，需提供奖励类型、人员身份、关联订单及奖励金额等信息
 * @param {Object} data - 销售奖励数据
 * @param {string} data.incentiveType - 奖励类型，必填：铁匠 / 台阶 / 唱单
 * @param {string} data.personnelIdentity - 人员身份，必填：销售经理 / 录入员
 * @param {number} data.orderId - 关联订单ID，必填
 * @param {string} data.rewardReceiver - 奖励接收人，必填
 * @param {number} data.rewardAmount - 奖励金额，必填
 * @param {string} [data.orderDate] - 订单日期
 * @param {string} [data.customerName] - 客户名称
 * @param {string} [data.rewardReason] - 奖励原因
 * @param {number} [data.orderProfit] - 订单利润
 * @param {number} [data.manufacturerRebateDiscountAmount] - 厂家返利折扣金额
 * @param {number} [data.acceptanceDiscountProfit] - 承兑折扣利润
 * @param {number} [data.customerManufacturerCommissionAmount] - 客户厂家佣金金额
 * @param {number} [data.comprehensiveProfit] - 综合利润
 * @param {number} [data.paymentAmount] - 支付金额
 * @param {number} [data.isTargetReached] - 利润是否达标（0=未达标，1=达标）
 * @param {string} [data.rewardDate] - 奖励日期（yyyy-MM-dd）
 * @param {string} [data.auditState] - 审核状态（未审核/已审核）
 * @param {string} [data.auditTime] - 审核时间
 * @param {number} [data.auditUserId] - 审核人ID
 * @param {string} [data.auditUserName] - 审核人姓名
 * @param {number} [data.delFlag] - 删除标志（0=正常，1=删除）
 * @param {string} [data.remark] - 备注
 * @returns {Promise<Object>} 返回统一响应对象
 * @returns {number} returns.code - 响应码（200表示成功）
 * @returns {string} returns.msg - 响应消息
 * @returns {number} returns.data - 新增成功的记录数（>0表示成功）
 */
export function addSalesReward(data) {
	return request({
		url: '/system/salesReward',
		method: 'post',
		data: data
	});
}

/**
 * 修改奖励
 * 根据主键更新销售奖励信息，提交完整的 SalesReward 对象
 * @param {Object} data - 销售奖励数据
 * @param {number} data.id - 奖励主键ID，必填
 * @param {string} [data.incentiveType] - 奖励类型：铁匠 / 台阶 / 唱单
 * @param {string} [data.personnelIdentity] - 人员身份：销售经理 / 录入员
 * @param {number} [data.orderId] - 关联订单ID
 * @param {string} [data.rewardReceiver] - 奖励接收人
 * @param {number} [data.rewardAmount] - 奖励金额
 * @param {string} [data.orderDate] - 订单日期
 * @param {string} [data.customerName] - 客户名称
 * @param {string} [data.rewardReason] - 奖励原因
 * @param {number} [data.orderProfit] - 订单利润
 * @param {number} [data.manufacturerRebateDiscountAmount] - 厂家返利折扣金额
 * @param {number} [data.acceptanceDiscountProfit] - 承兑折扣利润
 * @param {number} [data.customerManufacturerCommissionAmount] - 客户厂家佣金金额
 * @param {number} [data.comprehensiveProfit] - 综合利润
 * @param {number} [data.paymentAmount] - 支付金额
 * @param {number} [data.isTargetReached] - 利润是否达标（0=未达标，1=达标）
 * @param {string} [data.rewardDate] - 奖励日期（yyyy-MM-dd）
 * @param {string} [data.auditState] - 审核状态（未审核/已审核）
 * @param {string} [data.auditTime] - 审核时间
 * @param {number} [data.auditUserId] - 审核人ID
 * @param {string} [data.auditUserName] - 审核人姓名
 * @param {number} [data.delFlag] - 删除标志（0=正常，1=删除）
 * @param {string} [data.remark] - 备注
 * @param {string} [data.createBy] - 创建人
 * @param {string} [data.createTime] - 创建时间
 * @param {string} [data.updateBy] - 更新人
 * @param {string} [data.updateTime] - 更新时间
 * @returns {Promise<Object>} 返回统一响应对象
 * @returns {number} returns.code - 响应码（200表示成功）
 * @returns {string} returns.msg - 响应消息
 * @returns {number} returns.data - 更新成功的记录数（>0表示成功）
 */
export function updateSalesReward(data) {
	return request({
		url: '/system/salesReward',
		method: 'put',
		data: data
	});
}

/**
 * 删除奖励
 * 支持批量删除销售奖励，路径参数使用英文逗号分隔多个ID
 * @param {string|number|Array<string|number>} ids - 要删除的奖励ID，支持单个ID、逗号分隔的字符串或数组，示例：1,2,3
 * @returns {Promise<Object>} 返回统一响应对象
 * @returns {number} returns.code - 响应码（200表示成功）
 * @returns {string} returns.msg - 响应消息
 * @returns {number} returns.data - 成功删除的记录数
 */
export function delSalesReward(ids) {
	const idsStr = Array.isArray(ids) ? ids.join(',') : ids;
	return request({
		url: `/system/salesReward/${idsStr}`,
		method: 'delete'
	});
}

// ==================== 审核相关 ====================

/**
 * 审核或取消审核
 * 审核通过或取消审核指定的销售奖励
 * @param {number|string} id - 奖励主键ID
 * @param {boolean} approved - true 表示审核通过，false 表示取消审核
 * @returns {Promise<Object>} 返回统一响应对象
 * @returns {number} returns.code - 响应码（200表示成功）
 * @returns {string} returns.msg - 响应消息
 * @returns {number} returns.data - 操作成功的记录数（>0表示成功）
 */
export function auditSalesReward(id, approved) {
	return request({
		url: `/system/salesReward/audit/${id}`,
		method: 'put',
		params: { approved }
	});
}

// ==================== 订单奖励相关 ====================

/**
 * 获取订单奖励预览数据
 * 根据订单ID计算奖励指标，用于录入前预览建议数据
 * @param {number|string} orderId - 订单主键ID
 * @returns {Promise<Object>} 返回统一响应对象
 * @returns {number} returns.code - 响应码（200表示成功）
 * @returns {string} returns.msg - 响应消息
 * @returns {Object} returns.data - 订单奖励预览数据
 * @returns {number} returns.data.orderId - 订单ID
 * @returns {string} returns.data.orderDate - 订单日期
 * @returns {string} returns.data.customerName - 客户名称
 * @returns {number} returns.data.orderProfit - 订单利润
 * @returns {number} returns.data.paymentAmount - 支付金额
 * @returns {number} returns.data.manufacturerRebateDiscountAmount - 厂家返利折扣金额
 * @returns {number} returns.data.customerManufacturerCommissionAmount - 客户厂家佣金金额
 * @returns {number} returns.data.acceptanceDiscountProfit - 承兑折扣利润
 * @returns {number} returns.data.comprehensiveProfit - 综合利润
 */
export function getOrderRewardData(orderId) {
	return request({
		url: `/system/salesReward/getOrderRewardData/${orderId}`,
		method: 'get'
	});
}

// ==================== 支付相关 ====================

/**
 * 补充支付信息
 * 用于补录或调整奖励的支付金额与支付时间
 * @param {Object} data - 补充支付信息数据
 * @param {number} data.id - 奖励主键ID，必填
 * @param {number} [data.paymentAmount] - 支付金额，与 rewardDate 可二选一填写
 * @param {string} [data.rewardDate] - 奖励日期（yyyy-MM-dd），与 paymentAmount 可二选一填写
 * @returns {Promise<Object>} 返回统一响应对象
 * @returns {number} returns.code - 响应码（200表示成功）
 * @returns {string} returns.msg - 响应消息
 * @returns {number} returns.data - 补录成功的记录数（>0表示成功）
 */
export function supplementSalesReward(data) {
	return request({
		url: '/system/salesReward/supplement',
		method: 'put',
		data: data
	});
}

// ==================== 导入导出 ====================

/**
 * 导出销售奖励
 * 根据筛选条件导出销售奖励表格，返回 Excel 文件供下载
 * @param {Object} query - 导出查询参数
 * @param {string} [query.incentiveType] - 奖励类型过滤，可选：铁匠 / 台阶 / 唱单
 * @param {string} [query.personnelIdentity] - 人员身份过滤，可选：销售经理 / 录入员
 * @param {number} [query.orderId] - 订单ID，导出单个订单奖励时填写
 * @param {string} [query.customerName] - 客户名称，模糊查询
 * @param {string} [query.rewardReceiver] - 奖励接收人，支持模糊
 * @param {string} [query.auditState] - 审核状态，可选：未审核 / 已审核
 * @param {string} [query.rewardDateBegin] - 奖励开始日期（yyyy-MM-dd）
 * @param {string} [query.rewardDateEnd] - 奖励结束日期（yyyy-MM-dd）
 * @param {number} [query.isTargetReached] - 利润是否达标，0=未达标，1=达标
 * @returns {Promise<Blob>} 返回 Excel 二进制流，Content-Disposition 包含文件名 sales-reward.xlsx
 */
export function exportSalesReward(query) {
	return request({
		url: '/system/salesReward/export',
		method: 'get',
		params: query,
		responseType: 'blob'
	});
}
