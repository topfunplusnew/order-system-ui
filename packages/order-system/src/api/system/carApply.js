import request from '@/utils/request';

/**
 * 查询车辆使用申请列表
 * @param {Object} query - 查询参数
 * @param {number} [query.pageNum=1] - 页码，默认1
 * @param {number} [query.pageSize=10] - 每页条数，默认10
 * @param {boolean} [query.noPage] - 是否不分页，true时返回全部
 * @param {string} [query.applyUser] - 申请人（模糊匹配）
 * @param {string} [query.department] - 部门（模糊匹配）
 * @param {string} [query.carNo] - 车牌号（模糊匹配）
 * @param {string} [query.auditState] - 审核状态：已审核、未审核
 * @param {boolean} [query['params[bTripIdIsNull]']] - 仅查询未绑定出差的申请
 * @param {string} [query['params[applyDateStartTime]']] - 申请时间起始，格式：yyyy-MM-dd HH:mm:ss
 * @param {string} [query['params[applyDateEndTime]']] - 申请时间截止，格式：yyyy-MM-dd HH:mm:ss
 * @param {string} [query.dispatchPerson] - 派车人（模糊匹配）
 * @returns {Promise} 返回分页数据，包含 total（总记录数）和 rows（数据列表），每项包含 id、bTripIds（关联的出差单ID列表）、applyDate、applyUser、department、carNo、isUseOilCard、peers、startTime、endTime、applyPurpose、auditState、dispatchPerson 等字段
 */
export function listCarApply(query) {
	return request({
		url: '/system/carApply/list',
		method: 'get',
		params: query
	});
}

/**
 * 获取车辆使用申请详细信息
 * @param {number} id - 车辆申请主键ID
 * @returns {Promise} 返回车辆申请详情，包含关联的出差单ID列表（bTripIds）、油卡绑定等完整信息
 * @description 根据ID查询车辆使用申请的详细信息，包含关联的出差单ID列表、油卡绑定等完整信息
 */
export function getCarApply(id) {
	return request({
		url: '/system/carApply/' + id,
		method: 'get'
	});
}

/**
 * 新增车辆使用申请
 * @param {Object} data - 车辆申请数据
 * @param {string} data.applyDate - 申请时间（必填），格式：yyyy-MM-dd HH:mm:ss
 * @param {string} data.applyUser - 申请人姓名（必填），最大长度25
 * @param {string} data.department - 申请部门（必填），最大长度25
 * @param {string} data.carNo - 车牌号（必填），最大长度200
 * @param {string} data.startTime - 用车开始时间（必填），格式：yyyy-MM-dd HH:mm:ss
 * @param {string} data.dispatchPerson - 派车人（必填），最大长度25
 * @param {number} [data.isUseOilCard] - 是否携带油卡：0-否，1-是。携带油卡时oilCardBindings必填
 * @param {string} [data.peers] - 随同乘车人员，多人用逗号分隔，最大长度155
 * @param {string} [data.endTime] - 预计还车时间，格式：yyyy-MM-dd HH:mm:ss
 * @param {string} [data.applyPurpose] - 用车事由，最大长度255
 * @param {string} [data.startMile] - 出车前里程（公里），最大长度55
 * @param {string} [data.startCarState] - 出车前车况描述（外观、车胎等），最大长度2000
 * @param {string} [data.comments] - 备注说明，最大长度200
 * @param {Array<Object>} [data.oilCardBindings] - 携带的油卡列表（isUseOilCard=1时必填）
 * @param {number} data.oilCardBindings[].oilCardId - 油卡主键ID
 * @param {string} data.oilCardBindings[].oilCardNo - 油卡卡号
 * @returns {Promise} 返回操作结果
 * @description 新增一条车辆使用申请记录。注意事项：必填字段：applyDate, applyUser, department, carNo, startTime, dispatchPerson。携带油卡时必须选择油卡信息（oilCardBindings不能为空）。与出差单的关联关系由出差单侧维护，此接口不处理关联
 */
export function addCarApply(data) {
	return request({
		url: '/system/carApply',
		method: 'post',
		data: data
	});
}

/**
 * 修改车辆使用申请
 * @param {Object} data - 车辆申请数据
 * @param {number} data.id - 车辆申请主键ID（必填）
 * @param {string} [data.applyDate] - 申请时间，格式：yyyy-MM-dd HH:mm:ss
 * @param {string} [data.applyUser] - 申请人姓名
 * @param {string} [data.department] - 申请部门
 * @param {string} [data.carNo] - 车牌号
 * @param {number} [data.isUseOilCard] - 是否携带油卡：0-否，1-是
 * @param {string} [data.peers] - 随同乘车人员
 * @param {string} [data.startTime] - 用车开始时间，格式：yyyy-MM-dd HH:mm:ss
 * @param {string} [data.applyPurpose] - 用车事由
 * @param {string} [data.startMile] - 出车前里程
 * @param {string} [data.startCarState] - 出车前车况
 * @param {string} [data.dispatchPerson] - 派车人
 * @param {string} [data.comments] - 备注
 * @param {Array<Object>} [data.oilCardBindings] - 携带的油卡列表
 * @param {number} [data.oilCardBindings[].oilCardId] - 油卡主键ID
 * @param {string} [data.oilCardBindings[].oilCardNo] - 油卡卡号
 * @returns {Promise} 返回操作结果
 * @description 修改车辆使用申请的基础信息。注意事项：已审核的申请不允许修改基础信息。审核状态通过专门的审核接口修改。补充信息（还车信息）通过 /supplement 接口修改。与出差单的关联关系由出差单侧维护，此接口不处理
 */
export function updateCarApply(data) {
	return request({
		url: '/system/carApply',
		method: 'put',
		data: data
	});
}

/**
 * 删除车辆使用申请
 * @param {string} ids - 要删除的ID，多个用逗号分隔（如："1,2,3"）
 * @returns {Promise} 返回操作结果
 * @description 批量删除车辆使用申请。删除校验：已审核的申请不允许删除。存在油卡消费记录的不允许删除。被出差单引用的不允许删除（会提示被哪些出差ID引用）
 */
export function delCarApply(ids) {
	return request({
		url: '/system/carApply/' + ids,
		method: 'delete'
	});
}

/**
 * 确定出差和车辆申请的关系
 * @param {Object} data - 关联关系数据
 * @param {string} data.bTripId - 出差单ID
 * @param {Array<string>} data.carApplyIds - 车辆申请ID数组
 * @returns {Promise} 返回操作结果，data字段为关联的车辆申请数量
 * @description 批量确定出差单与车辆申请的关联关系。业务逻辑：先清除该出差单的所有现有关联，再建立与指定车辆申请的新关联。注意：推荐使用出差单的新增/修改接口通过params.carApplyIds来维护关联关系
 */
export function updateCarApplyBatch(data) {
	return request({
		url: '/system/carApply/confirmTripRelation',
		method: 'post',
		params: {
			bTripId: data.bTripId,
			carApplyIds: data.carApplyIds
		}
	});
}

/**
 * 修改车辆使用申请审核状态
 * @param {number} id - 车辆申请主键ID
 * @param {string} auditState - 审核状态：已审核（审核通过）、未审核（审核不通过/撤销审核）
 * @returns {Promise} 返回操作结果
 * @description 修改车辆使用申请的审核状态。状态值：已审核-审核通过，未审核-审核不通过/撤销审核
 */
export function auditCarApply(id, auditState) {
	return request({
		url: '/system/carApply/auditState',
		method: 'put',
		params: {
			id,
			auditState
		}
	});
}

/**
 * 更新车辆使用申请补充信息
 * @param {Object} data - 补充信息数据
 * @param {number} data.id - 车辆申请主键ID（必填）
 * @param {string} [data.endTime] - 实际还车时间，格式：yyyy-MM-dd HH:mm:ss
 * @param {string} [data.endMile] - 还车后里程（公里）
 * @param {string} [data.miles] - 本次行驶里程数（公里）
 * @param {string} [data.endCarState] - 还车后车况描述
 * @param {string} [data.backStopPlace] - 回程停靠位置
 * @param {string} [data.violationsCount] - 行程中违法次数
 * @param {string} [data.fine] - 违章罚款金额（元）
 * @param {string} [data.isMaintenance] - 行程中是否维修/保养：是、否
 * @param {string} [data.repairMoney] - 维修金额（元）
 * @param {string} [data.maintenanceMoney] - 保养金额（元）
 * @param {number} [data.cashRefuelingFrequency] - 现金加油次数
 * @param {number} [data.cashRefueling] - 现金加油金额（元）
 * @returns {Promise} 返回操作结果
 * @description 更新车辆使用申请的补充信息（还车后填写）。可更新字段：还车时间、还车后里程、还车后车况、回程停靠位置、行驶里程数、违章信息（次数、罚款）、维修保养信息、现金加油信息
 */
export function supplementCarApply(data) {
	return request({
		url: '/system/carApply/supplement',
		method: 'put',
		data: data
	});
}

/**
 * 导出车辆使用申请列表
 * @param {Object} query - 查询参数（与列表查询接口相同）
 * @param {string} [query.applyUser] - 申请人（模糊匹配）
 * @param {string} [query.department] - 部门（模糊匹配）
 * @param {string} [query.carNo] - 车牌号（模糊匹配）
 * @param {string} [query.auditState] - 审核状态
 * @returns {Promise} 返回Excel文件流
 */
export function exportCarApply(query) {
	return request({
		url: '/system/carApply/export',
		method: 'post',
		params: query,
		responseType: 'blob'
	});
}

/**
 * 查询现金加油台账
 * @param {Object} query - 查询参数
 * @param {number} [query.pageNum=1] - 分页页码，默认为1
 * @param {number} [query.pageSize=10] - 分页大小，默认为10
 * @param {boolean} [query.noPage] - 为true时不分页
 * @param {string} [query.carNo] - 车牌号模糊匹配
 * @param {string} [query.startTime] - 用车开始时间下限，格式：yyyy-MM-dd HH:mm:ss
 * @param {string} [query.endTime] - 用车结束时间上限，格式：yyyy-MM-dd HH:mm:ss
 * @returns {Promise} 返回表格分页数据对象
 */
export function getCashRefuelingLedger(query) {
	return request({
		url: '/system/carApply/cashRefuelingLedger',
		method: 'get',
		params: query
	});
}
