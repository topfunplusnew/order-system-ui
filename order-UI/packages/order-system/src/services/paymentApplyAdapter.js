/**
 * 付款申请API适配器
 * 用于处理新旧数据结构的转换，确保向后兼容性
 */

/**
 * 将旧的extraInfo结构转换为新的tableReferences结构
 * @param {Object} oldData - 旧数据结构
 * @returns {Object} - 新数据结构
 */
export function transformPaymentApplyData(oldData) {
	// 数据验证
	if (!oldData) {
		throw new Error('付款申请数据不能为空');
	}

	// 处理payType数组转字符串
	let payType = oldData.payType;
	if (Array.isArray(payType)) {
		payType = payType.join('-');
	}

	// 转换extraInfo为tableReferences
	let tableReferences = [];
	if (oldData.extraInfo && oldData.extraInfo.sourceInfos && Array.isArray(oldData.extraInfo.sourceInfos)) {
		tableReferences = oldData.extraInfo.sourceInfos.map(source => ({
			refTableName: source.tableName,
			refTableId: source.tableId,
			amount: calculateAmountForReference(oldData.moneyAmount, oldData.extraInfo.sourceInfos.length)
		}));
	}

	// 获取当前时间
	const currentTime = new Date().toISOString().slice(0, 19).replace('T', ' ');

	// 构建新的数据结构
	const newData = {
		fundsDate: oldData.fundsDate || currentTime,
		payType: payType || '',
		moneyAmount: parseFloat(oldData.moneyAmount) || 0,
		otherAccountsName: oldData.otherAcountsName || '', // 注意字段名变化
		otherBankNo: oldData.otherBankNo || '',
		otherBankName: oldData.otherBankName || '',
		companyName: oldData.companyName || '',
		companyId: oldData.companyId || null,
		companyType: oldData.companyType || '',
		reason: oldData.reason || '',
		applyPerson: oldData.applyPerson || '',
		applyPersonId: oldData.applyPersonID || null, // 注意字段名变化
		comments: oldData.comments || '',
		addTime: currentTime,
		userId: oldData.applyPersonID || 1,
		userName: oldData.applyPerson || '系统用户',
		tableReferences: tableReferences
	};

	return newData;
}

/**
 * 计算单个引用记录的金额
 * @param {number} totalAmount - 总金额
 * @param {number} referenceCount - 引用记录数量
 * @returns {number} - 单个记录的金额
 */
function calculateAmountForReference(totalAmount, referenceCount) {
	if (!totalAmount || !referenceCount || referenceCount <= 0) {
		return 0;
	}
	
	// 平均分配金额，保留两位小数
	return Math.round((totalAmount / referenceCount) * 100) / 100;
}

/**
 * 验证付款申请数据的完整性
 * @param {Object} data - 待验证的数据
 * @returns {Object} - 验证结果
 */
export function validatePaymentApplyData(data) {
	const errors = [];

	// 必填字段验证
	if (!data.fundsDate) {
		errors.push('资金日期不能为空');
	}
	
	if (!data.moneyAmount || data.moneyAmount <= 0) {
		errors.push('申请金额必须大于0');
	}

	if (!data.reason) {
		errors.push('付款原因不能为空');
	}

	if (!data.applyPerson) {
		errors.push('申请人不能为空');
	}

	// tableReferences验证
	if (!data.tableReferences || !Array.isArray(data.tableReferences) || data.tableReferences.length === 0) {
		errors.push('必须至少包含一个关联记录');
	}

	return {
		isValid: errors.length === 0,
		errors: errors
	};
}

/**
 * 批量处理付款申请数据
 * @param {Array} applicationList - 应用列表
 * @returns {Object} - 处理后的数据
 */
export function processBatchPaymentApply(applicationList) {
	if (!Array.isArray(applicationList) || applicationList.length === 0) {
		throw new Error('申请列表不能为空');
	}

	// 使用第一条记录作为模板，合并所有记录的关联信息
	const firstApp = applicationList[0];
	const allTableReferences = [];
	let totalAmount = 0;

	// 收集所有的tableReferences和计算总金额
	applicationList.forEach(app => {
		if (app.extraInfo && app.extraInfo.sourceInfos) {
			app.extraInfo.sourceInfos.forEach(source => {
				allTableReferences.push({
					refTableName: source.tableName,
					refTableId: source.tableId,
					amount: parseFloat(app.moneyAmount) || 0
				});
			});
		}
		totalAmount += parseFloat(app.moneyAmount) || 0;
	});

	// 创建合并后的申请数据
	const mergedApplication = {
		...firstApp,
		moneyAmount: totalAmount,
		extraInfo: {
			sourceInfos: allTableReferences.map(ref => ({
				tableName: ref.refTableName,
				tableId: ref.refTableId
			}))
		}
	};

	return transformPaymentApplyData(mergedApplication);
}
