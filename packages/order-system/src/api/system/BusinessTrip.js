import request from '@/utils/request';

/**
 * 查询出差列表
 * @param {Object} query - 查询参数
 * @param {number} [query.pageNum=1] - 页码，默认1
 * @param {number} [query.pageSize=10] - 每页条数，默认10
 * @param {string} [query.employee] - 报销人姓名（模糊匹配）
 * @param {string} [query.deptName] - 部门名称（模糊匹配）
 * @param {number} [query.isReimburse] - 是否已报销：0-未报销，1-已报销
 * @param {string} [query['params[starttimeStart]']] - 出差开始时间起始，格式：yyyy-MM-dd HH:mm:ss
 * @param {string} [query['params[starttimeEnd]']] - 出差开始时间截止，格式：yyyy-MM-dd HH:mm:ss
 * @returns {Promise} 返回分页数据，包含 total（总记录数）和 rows（数据列表）
 */
export function listBusinessTrip(query) {
	return request({
		url: '/system/BusinessTrip/list',
		method: 'get',
		params: query
	});
}

/**
 * 获取出差详细信息
 * @param {number} id - 出差记录主键ID
 * @returns {Promise} 返回出差详情，包含报销明细列表（tripReimbursementList）
 */
export function getBusinessTrip(id) {
	return request({
		url: '/system/BusinessTrip/' + id,
		method: 'get'
	});
}

/**
 * 新增出差
 * @param {Object} data - 出差数据
 * @param {string} data.UUID - 前端生成的唯一标识（必填），用于区分新增和修改操作。后端通过Redis缓存1小时进行去重判断
 * @param {number} [data.employeeID] - 报销人员工ID，关联员工表主键
 * @param {string} [data.employee] - 报销人姓名，最大长度150
 * @param {string} data.deptName - 所属部门名称（必填），最大长度255
 * @param {string} [data.personnel] - 共同出差人员，多人用逗号分隔，最大长度150
 * @param {string} [data.starttime] - 出差开始时间，格式：yyyy-MM-dd HH:mm:ss
 * @param {string} [data.endtime] - 出差结束时间，格式：yyyy-MM-dd HH:mm:ss
 * @param {number} [data.isReimburse] - 是否已报销：0-未报销，1-已报销
 * @param {string} [data.comments] - 备注说明，最大长度550
 * @param {Array<Object>} [data.tripReimbursementList] - 出差报销明细列表
 * @param {string} data.tripReimbursementList[].item - 报销项目名称（必填）
 * @param {number} data.tripReimbursementList[].itemCost - 费用金额（必填）
 * @param {string} [data.tripReimbursementList[].comments] - 报销项备注
 * @param {Object} [data.params] - 扩展参数对象
 * @param {Array<number>} [data.params.carApplyIds] - 要关联的车辆申请ID列表。传入后会自动创建出差与车辆申请的关联关系
 * @param {Array<Object>} [data.attachmentList] - 附件列表（发票、行程单等）
 * @param {string} [data.attachmentList[].fileName] - 文件原始名称
 * @param {string} [data.attachmentList[].filePath] - 文件存储路径
 * @param {string} [data.attachmentList[].fileSuffix] - 文件扩展名
 * @param {string} [data.attachmentList[].flag] - 附件标识
 * @returns {Promise} 返回包含ID的出差对象
 * @description UUID去重机制：前端必须传入UUID字段，后端通过Redis缓存1小时进行去重判断。如果UUID已存在，会先删除原记录再新增（实现幂等性）
 */
export function addBusinessTrip(data) {
	return request({
		url: '/system/BusinessTrip',
		method: 'post',
		data: data
	});
}

/**
 * 修改出差
 * @param {Object} data - 出差数据
 * @param {number} data.id - 出差记录主键ID（必填）
 * @param {number} [data.employeeID] - 报销人员工ID
 * @param {string} [data.employee] - 报销人姓名
 * @param {string} [data.deptName] - 所属部门
 * @param {string} [data.personnel] - 共同出差人员
 * @param {string} [data.starttime] - 出差开始时间
 * @param {string} [data.endtime] - 出差结束时间
 * @param {number} [data.isReimburse] - 是否已报销
 * @param {string} [data.comments] - 备注
 * @param {Array<Object>} [data.tripReimbursementList] - 报销明细列表（会替换原有明细）
 * @param {string} [data.tripReimbursementList[].item] - 报销项目名称
 * @param {number} [data.tripReimbursementList[].itemCost] - 费用金额
 * @param {string} [data.tripReimbursementList[].comments] - 报销项备注
 * @param {Object} [data.params] - 扩展参数对象
 * @param {Array<number>} [data.params.carApplyIds] - 更新关联的车辆申请ID列表。传入会替换原有关联，不传则保持不变
 * @returns {Promise} 返回操作结果
 * @description 注意事项：已有付款申请的出差记录不允许修改。会先删除原报销明细，再重新插入。关联车辆申请：传入新的ID列表会替换原有关联（先清空再建立新关联），不传此参数则保持原有关联不变
 */
export function updateBusinessTrip(data) {
	return request({
		url: '/system/BusinessTrip',
		method: 'put',
		data: data
	});
}

/**
 * 删除出差
 * @param {string} ids - 要删除的出差ID，多个用逗号分隔（如："1,2,3"）
 * @returns {Promise} 返回操作结果
 * @description 删除校验：已有付款申请的出差记录不允许删除。删除时会自动删除关联的报销明细，并自动清理与车辆申请的关联关系
 */
export function delBusinessTrip(ids) {
	return request({
		url: '/system/BusinessTrip/' + ids,
		method: 'delete'
	});
}

/**
 * 导出出差列表
 * @param {Object} query - 查询参数（与列表查询接口相同）
 * @param {string} [query.employee] - 报销人姓名
 * @param {string} [query.deptName] - 部门名称
 * @param {number} [query.isReimburse] - 是否已报销
 * @returns {Promise} 返回Excel文件流
 */
export function exportBusinessTrip(query) {
	return request({
		url: '/system/BusinessTrip/export',
		method: 'post',
		params: query,
		responseType: 'blob'
	});
}

/**
 * 获取出差关联的车辆申请审核状态
 * @param {string} bTripId - 出差记录ID（字符串类型，用于关联车辆申请表的bTripId字段）
 * @returns {Promise} 返回车辆申请审核状态信息，包含 hasNotPassedAudit（是否存在审核不通过的车辆申请）和 notPassedCarApplyList（审核不通过的车辆申请列表）
 * @description 查询指定出差关联的车辆申请审核状态。返回审核不通过的车辆申请列表。用于前端展示出差相关的车辆使用情况
 */
export function getCarApplyAuditStatus(bTripId) {
	return request({
		url: '/system/BusinessTrip/carApplyAuditStatus/' + bTripId,
		method: 'get'
	});
}
