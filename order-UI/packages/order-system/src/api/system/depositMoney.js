import request from '@/utils/request';

/**
 * 查询保证金收取信息列表（包含完整的主子表数据）
 * @param {Object} query 查询参数
 * @param {string} [query.depositCompany] 保证金公司
 * @param {string} [query.type] 保证金类型
 * @param {string} [query.targetType] 对象类型(员工、客户、供应商、其他)
 * @param {number} [query.targetBankNoId] 对象银行卡ID
 * @param {string} [query.target] 对象(员工姓名、公司名称)
 * @param {string} [query.moneyAmount] 保证金金额
 * @param {string} [query.unrefundedAmount] 未退款金额
 * @param {string} [query.targetAccountsName] 对方账户
 * @param {string} [query.targetBankNo] 对方账号
 * @param {string} [query.targetBankName] 对方开户行
 * @param {string} [query.selfAccountsName] 我方收款账户
 * @param {string} [query.selfBankNo] 我方账号
 * @param {string} [query.selfBankName] 我方开户行
 * @param {string} [query.depositDate] 收取保证金时间
 * @param {string} [query.reason] 事由
 * @param {string} [query.comments] 备注
 * @param {string} [query.addtime] 添加时间
 * @param {number} [query.userId] 操作人员ID
 * @param {string} [query.UserName] 操作人员姓名
 * @param {number} [query.delFlag] 删除标记
 * @param {string} [query.checkState] 额外字段
 * @returns {Promise} 返回保证金收取信息列表
 */
export function listDepositMoney(query) {
	return request({
		url: '/system/depositMoney/list',
		method: 'get',
		params: query
	});
}

/**
 * 获取保证金收取信息详细信息（包含完整的主子表数据）
 * @param {number|string} id 保证金收取信息ID
 * @returns {Promise} 返回保证金收取信息详细信息
 */
export function getDepositMoney(id) {
	return request({
		url: '/system/depositMoney/' + id,
		method: 'get'
	});
}

/**
 * 新增保证金收取信息
 * @param {Object} data 保证金收取信息数据
 * @param {string} [data.depositCompany] 保证金公司
 * @param {string} [data.type] 保证金类型
 * @param {string} [data.targetType] 对象类型(员工、客户、供应商、其他)
 * @param {number} [data.targetBankNoId] 对象银行卡ID
 * @param {string} [data.target] 对象(员工姓名、公司名称)
 * @param {string} [data.moneyAmount] 保证金金额
 * @param {string} [data.unrefundedAmount] 未退款金额
 * @param {string} [data.targetAccountsName] 对方账户
 * @param {string} [data.targetBankNo] 对方账号
 * @param {string} [data.targetBankName] 对方开户行
 * @param {string} [data.selfAccountsName] 我方收款账户
 * @param {string} [data.selfBankNo] 我方账号
 * @param {string} [data.selfBankName] 我方开户行
 * @param {string} [data.depositDate] 收取保证金时间
 * @param {string} [data.reason] 事由
 * @param {string} [data.comments] 备注
 * @param {Array} [data.depositRefundList] 保证金退款列表
 * @returns {Promise} 返回新增结果
 */
export function addDepositMoney(data) {
	return request({
		url: '/system/depositMoney',
		method: 'post',
		data: data
	});
}

/**
 * 修改保证金收取信息
 * @param {Object} data 保证金收取信息数据
 * @param {number} data.id 保证金收取信息ID
 * @param {string} [data.depositCompany] 保证金公司
 * @param {string} [data.type] 保证金类型
 * @param {string} [data.targetType] 对象类型(员工、客户、供应商、其他)
 * @param {number} [data.targetBankNoId] 对象银行卡ID
 * @param {string} [data.target] 对象(员工姓名、公司名称)
 * @param {string} [data.moneyAmount] 保证金金额
 * @param {string} [data.unrefundedAmount] 未退款金额
 * @param {string} [data.targetAccountsName] 对方账户
 * @param {string} [data.targetBankNo] 对方账号
 * @param {string} [data.targetBankName] 对方开户行
 * @param {string} [data.selfAccountsName] 我方收款账户
 * @param {string} [data.selfBankNo] 我方账号
 * @param {string} [data.selfBankName] 我方开户行
 * @param {string} [data.depositDate] 收取保证金时间
 * @param {string} [data.reason] 事由
 * @param {string} [data.comments] 备注
 * @param {Array} [data.depositRefundList] 保证金退款列表
 * @returns {Promise} 返回修改结果
 */
export function updateDepositMoney(data) {
	return request({
		url: '/system/depositMoney',
		method: 'put',
		data: data
	});
}

/**
 * 批量删除保证金收取信息
 * @param {string} ids 要删除的保证金收取信息ID，多个ID用逗号分隔
 * @returns {Promise} 返回删除结果
 */
export function delDepositMoney(ids) {
	return request({
		url: '/system/depositMoney/' + ids,
		method: 'delete'
	});
}

/**
 * 导出保证金收取信息列表
 * @param {Object} query 查询参数（与查询列表的参数相同）
 * @returns {Promise} 返回导出结果
 */
export function exportDepositMoney(query) {
	return request({
		url: '/system/depositMoney/export',
		method: 'post',
		params: query
	});
}

/**
 * 新增保证金退款信息
 * @param {Object} data 保证金退款信息数据
 * @param {number} data.depositMoneyId 保证金主表ID（必填）
 * @param {string} data.refundDate 退款日期（必填）
 * @param {string} [data.accountsName] 账户名称
 * @param {string} [data.bankNo] 银行账号
 * @param {string} [data.moneyAmount] 退款金额
 * @param {string} [data.comments] 备注
 * @param {string} [data.badDebtFlag] 坏账标记
 * @returns {Promise} 返回新增结果
 */
export function addDepositRefund(data) {
	return request({
		url: '/system/depositMoney/detail',
		method: 'post',
		data: data
	});
}

/**
 * 修改保证金退款信息
 * @param {Object} data 保证金退款信息数据
 * @param {number} data.id 退款记录ID
 * @param {number} data.depositMoneyId 保证金主表ID（必填）
 * @param {string} data.refundDate 退款日期（必填）
 * @param {string} [data.accountsName] 账户名称
 * @param {string} [data.bankNo] 银行账号
 * @param {string} [data.moneyAmount] 退款金额
 * @param {string} [data.comments] 备注
 * @param {string} [data.badDebtFlag] 坏账标记
 * @returns {Promise} 返回修改结果
 */
export function updateDepositRefund(data) {
	return request({
		url: '/system/depositMoney/detail',
		method: 'put',
		data: data
	});
}

/**
 * 批量删除保证金退款信息
 * @param {string} ids 要删除的退款记录ID，多个ID用逗号分隔
 * @returns {Promise} 返回删除结果
 */
export function delDepositRefund(ids) {
	return request({
		url: '/system/depositMoney/detail/' + ids,
		method: 'delete'
	});
}

/**
 * 获取保证金退款信息详细信息
 * @param {number|string} id 退款记录ID
 * @returns {Promise} 返回退款信息详细信息
 */
export function getDepositRefund(id) {
	return request({
		url: '/system/depositMoney/detail/' + id,
		method: 'get'
	});
}

/**
 * 根据子表ID获取完整的主子表信息（返回值和根据主表ID获取的一致）
 * @param {number|string} detailId 子表（退款记录）ID
 * @returns {Promise} 返回完整的主子表信息
 */
export function getDepositMoneyByDetailId(detailId) {
	return request({
		url: '/system/depositMoney/byDetailId/' + detailId,
		method: 'get'
	});
}

/**
 * 查询保证金退款信息列表
 * @param {Object} query 查询参数
 * @param {number} [query.depositMoneyId] 保证金主表ID
 * @param {string} [query.refundDate] 退款日期
 * @param {string} [query.accountsName] 账户名称
 * @param {string} [query.bankNo] 银行账号
 * @param {string} [query.moneyAmount] 退款金额
 * @param {string} [query.comments] 备注
 * @param {string} [query.badDebtFlag] 坏账标记
 * @param {string} [query.startTime] 开始时间
 * @param {string} [query.endTime] 结束时间
 * @returns {Promise} 返回保证金退款信息列表
 */
export function listDepositRefund(query) {
	return request({
		url: '/system/depositMoney/detail/list',
		method: 'get',
		params: query
	});
}

/**
 * 根据保证金主表ID查询退款列表
 * @param {number|string} depositMoneyId 保证金主表ID
 * @returns {Promise} 返回该保证金对应的退款列表
 */
export function getDepositRefundByMainId(depositMoneyId) {
	return request({
		url: '/system/depositMoney/detail/byMainId/' + depositMoneyId,
		method: 'get'
	});
}
