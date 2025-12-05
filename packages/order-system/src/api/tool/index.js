/**
 * 表单校验工具类
 * 适用于 Element UI 的表单校验
 */

/**
 * 手机号校验
 * @param {Object} rule - 校验规则
 * @param {String} value - 输入值
 * @param {Function} callback - 回调函数
 */
export const validatePhone = (rule, value, callback) => {
	if (!value) {
		return callback(new Error('请输入手机号'));
	}
	const phoneReg = /^1[3-9]\d{9}$/;
	if (!phoneReg.test(value)) {
		return callback(new Error('请输入正确的手机号码'));
	}
	callback();
};

/**
 * 可选手机号校验（允许为空）
 * @param {Object} rule - 校验规则
 * @param {String} value - 输入值
 * @param {Function} callback - 回调函数
 */
export const validateOptionalPhone = (rule, value, callback) => {
	// 如果为空，直接通过验证
	if (!value) {
		return callback();
	}
	const phoneReg = /^1[3-9]\d{9}$/;
	if (!phoneReg.test(value)) {
		return callback(new Error('请输入正确的手机号码'));
	}
	callback();
};

/**
 * 金额校验
 * @param {Object} rule - 校验规则
 * @param {String|Number} value - 输入值
 * @param {Function} callback - 回调函数
 */
export const validateAmount = (rule, value, callback) => {
	if (!value && value !== 0) {
		return callback(new Error('请输入金额'));
	}
	const amountReg = /^(0|[1-9]\d*)(\.\d{1,2})?$/;
	if (!amountReg.test(value.toString())) {
		return callback(new Error('金额格式不正确，最多保留两位小数'));
	}
	if (parseFloat(value) < 0) {
		return callback(new Error('金额不能为负数'));
	}
	callback();
};

/**
 * 邮箱校验
 * @param {Object} rule - 校验规则
 * @param {String} value - 输入值
 * @param {Function} callback - 回调函数
 */
export const validateEmail = (rule, value, callback) => {
	if (!value) {
		return callback(new Error('请输入邮箱地址'));
	}
	const emailReg = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	if (!emailReg.test(value)) {
		return callback(new Error('请输入正确的邮箱地址'));
	}
	callback();
};

/**
 * 身份证号校验
 * @param {Object} rule - 校验规则
 * @param {String} value - 输入值
 * @param {Function} callback - 回调函数
 */
export const validateIdCard = (rule, value, callback) => {
	if (!value) {
		return callback(new Error('请输入身份证号'));
	}
	const idCardReg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
	if (!idCardReg.test(value)) {
		return callback(new Error('请输入正确的身份证号'));
	}
	callback();
};

/**
 * 银行卡号校验
 * @param {Object} rule - 校验规则
 * @param {String} value - 输入值
 * @param {Function} callback - 回调函数
 */
export const validateBankCard = (rule, value, callback) => {
	if (!value) {
		return callback(new Error('请输入银行卡号'));
	}
	const bankCardReg = /^[1-9]\d{15,18}$/;
	if (!bankCardReg.test(value)) {
		return callback(new Error('请输入正确的银行卡号'));
	}
	callback();
};

/**
 * 正整数校验
 * @param {Object} rule - 校验规则
 * @param {String|Number} value - 输入值
 * @param {Function} callback - 回调函数
 */
export const validatePositiveInteger = (rule, value, callback) => {
	if (!value && value !== 0) {
		return callback(new Error('请输入数字'));
	}
	const positiveIntReg = /^[1-9]\d*$/;
	if (!positiveIntReg.test(value.toString())) {
		return callback(new Error('请输入正整数'));
	}
	callback();
};

/**
 * 非负整数校验（包含0）
 * @param {Object} rule - 校验规则
 * @param {String|Number} value - 输入值
 * @param {Function} callback - 回调函数
 */
export const validateNonNegativeInteger = (rule, value, callback) => {
	if (!value && value !== 0) {
		return callback(new Error('请输入数字'));
	}
	const nonNegativeIntReg = /^(0|[1-9]\d*)$/;
	if (!nonNegativeIntReg.test(value.toString())) {
		return callback(new Error('请输入非负整数'));
	}
	callback();
};

/**
 * 用户名校验（字母、数字、下划线，4-16位）
 * @param {Object} rule - 校验规则
 * @param {String} value - 输入值
 * @param {Function} callback - 回调函数
 */
export const validateUsername = (rule, value, callback) => {
	if (!value) {
		return callback(new Error('请输入用户名'));
	}
	const usernameReg = /^[a-zA-Z0-9_]{4,16}$/;
	if (!usernameReg.test(value)) {
		return callback(new Error('用户名由4-16位字母、数字、下划线组成'));
	}
	callback();
};

/**
 * 密码强度校验（至少包含大小写字母、数字，8-20位）
 * @param {Object} rule - 校验规则
 * @param {String} value - 输入值
 * @param {Function} callback - 回调函数
 */
export const validatePassword = (rule, value, callback) => {
	if (!value) {
		return callback(new Error('请输入密码'));
	}
	const passwordReg = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,20}$/;
	if (!passwordReg.test(value)) {
		return callback(new Error('密码必须包含大小写字母和数字，长度8-20位'));
	}
	callback();
};

/**
 * 中文姓名校验
 * @param {Object} rule - 校验规则
 * @param {String} value - 输入值
 * @param {Function} callback - 回调函数
 */
export const validateChineseName = (rule, value, callback) => {
	if (!value) {
		return callback(new Error('请输入姓名'));
	}
	const chineseNameReg = /^[\u4e00-\u9fa5]{2,10}$/;
	if (!chineseNameReg.test(value)) {
		return callback(new Error('请输入2-10位中文姓名'));
	}
	callback();
};

/**
 * URL地址校验
 * @param {Object} rule - 校验规则
 * @param {String} value - 输入值
 * @param {Function} callback - 回调函数
 */
export const validateUrl = (rule, value, callback) => {
	if (!value) {
		return callback(new Error('请输入URL地址'));
	}
	const urlReg = /^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$/;
	if (!urlReg.test(value)) {
		return callback(new Error('请输入正确的URL地址'));
	}
	callback();
};

/**
 * IP地址校验
 * @param {Object} rule - 校验规则
 * @param {String} value - 输入值
 * @param {Function} callback - 回调函数
 */
export const validateIp = (rule, value, callback) => {
	if (!value) {
		return callback(new Error('请输入IP地址'));
	}
	const ipReg = /^((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)$/;
	if (!ipReg.test(value)) {
		return callback(new Error('请输入正确的IP地址'));
	}
	callback();
};

/**
 * 自定义长度校验
 * @param {Number} min - 最小长度
 * @param {Number} max - 最大长度
 * @returns {Function} 校验函数
 */
export const validateLength = (min, max) => {
	return (rule, value, callback) => {
		if (!value) {
			return callback(new Error('请输入内容'));
		}
		if (value.length < min || value.length > max) {
			return callback(new Error(`长度应在${min}-${max}个字符之间`));
		}
		callback();
	};
};

/**
 * 自定义数值范围校验
 * @param {Number} min - 最小值
 * @param {Number} max - 最大值
 * @returns {Function} 校验函数
 */
export const validateRange = (min, max) => {
	return (rule, value, callback) => {
		if (!value && value !== 0) {
			return callback(new Error('请输入数值'));
		}
		const num = parseFloat(value);
		if (isNaN(num)) {
			return callback(new Error('请输入有效数值'));
		}
		if (num < min || num > max) {
			return callback(new Error(`数值应在${min}-${max}之间`));
		}
		callback();
	};
};

/**
 * 常用校验规则集合
 */
export const validationRules = {
	// 必填校验
	required: { required: true, message: '此项为必填项', trigger: 'blur' },

	// 手机号校验规则
	phone: [
		{ required: true, message: '请输入手机号', trigger: 'blur' },
		{ validator: validatePhone, trigger: 'blur' }
	],

	// 金额校验规则
	amount: [
		{ required: true, message: '请输入金额', trigger: 'blur' },
		{ validator: validateAmount, trigger: 'blur' }
	],

	// 邮箱校验规则
	email: [
		{ required: true, message: '请输入邮箱', trigger: 'blur' },
		{ validator: validateEmail, trigger: 'blur' }
	],

	// 身份证校验规则
	idCard: [
		{ required: true, message: '请输入身份证号', trigger: 'blur' },
		{ validator: validateIdCard, trigger: 'blur' }
	],

	// 用户名校验规则
	username: [
		{ required: true, message: '请输入用户名', trigger: 'blur' },
		{ validator: validateUsername, trigger: 'blur' }
	],

	// 密码校验规则
	password: [
		{ required: true, message: '请输入密码', trigger: 'blur' },
		{ validator: validatePassword, trigger: 'blur' }
	]
};

// ================================
// 新增：配置化表单验证规则生成器
// ================================

/**
 * 生成必填规则
 * @param {string} fieldName 字段名称
 * @returns {Object} 验证规则对象
 */
export const requiredRule = (fieldName = '此项') => ({
	required: true,
	message: `请输入${fieldName}`,
	trigger: 'blur'
});

/**
 * 生成字符串规则
 * @returns {Object} 验证规则对象
 */
export const stringRule = () => ({
	type: 'string',
	message: '请输入有效字符',
	trigger: 'blur'
});

/**
 * 生成数字规则
 * @returns {Object} 验证规则对象
 */
export const numberRule = () => ({
	type: 'number',
	message: '请输入有效数字',
	trigger: 'blur',
	transform: value => Number(value)
});

/**
 * 生成正数规则
 * @returns {Object} 验证规则对象
 */
export const positiveNumberRule = () => ({
	validator: validateAmount,
	trigger: 'blur'
});

/**
 * 生成手机号规则
 * @returns {Object} 验证规则对象
 */
export const phoneRule = () => ({
	validator: validatePhone,
	trigger: 'blur'
});

/**
 * 生成可选手机号规则（允许为空）
 * @returns {Object} 验证规则对象
 */
export const optionalPhoneRule = () => ({
	validator: validateOptionalPhone,
	trigger: 'blur'
});

/**
 * 生成编码规则（字母数字下划线）
 * @returns {Object} 验证规则对象
 */
export const codeRule = () => ({
	pattern: /^[a-zA-Z0-9_]+$/,
	message: '只能包含字母、数字、下划线',
	trigger: 'blur'
});

/**
 * 生成邮箱规则
 * @returns {Object} 验证规则对象
 */
export const emailRule = () => ({
	validator: validateEmail,
	trigger: 'blur'
});

/**
 * 生成最小长度规则
 * @param {number} min 最小长度
 * @returns {Object} 验证规则对象
 */
export const minLengthRule = min => ({
	min,
	message: `最少输入${min}个字符`,
	trigger: 'blur'
});

/**
 * 生成最大长度规则
 * @param {number} max 最大长度
 * @returns {Object} 验证规则对象
 */
export const maxLengthRule = max => ({
	max,
	message: `最多输入${max}个字符`,
	trigger: 'blur'
});

/**
 * 生成数值范围规则
 * @param {number} min 最小值
 * @param {number} max 最大值
 * @returns {Object} 验证规则对象
 */
export const rangeRule = (min, max) => ({
	validator: validateRange(min, max),
	trigger: 'blur'
});

/**
 * 生成自定义验证规则
 * @param {Function} validator 验证函数
 * @param {string} message 错误消息
 * @returns {Object} 验证规则对象
 */
export const customValidation = (validator, message) => ({
	validator: async (rule, value, callback) => {
		try {
			const result = await validator(value);
			if (result === true) {
				callback();
			} else {
				callback(new Error(message || '验证失败'));
			}
		} catch (error) {
			callback(new Error(message || '验证出错'));
		}
	},
	trigger: 'blur'
});
