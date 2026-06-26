/**
 * 2026-06-25 票点管理：公司名称粘贴清洗与保存校验工具（去除空格/括号，禁止其他标点）
 */
/** 空格 */
const SPACE_REG = /\s/g;
/** 中英文括号 */
const BRACKET_REG = /[()（）\[\]【】{}｛｝<>《》「」『』]/g;
/** 不允许的字符：非中文、字母、数字 */
const INVALID_CHAR_REG = /[^\u4e00-\u9fa5a-zA-Z0-9]/;

/**
 * 粘贴时清洗公司名称：去除空格和括号
 * @param {string|null|undefined} value - 原始文本
 * @returns {string} 清洗后的公司名称
 */
export function sanitizeCompanyNamePasted(value) {
	if (value == null || value === '') return '';
	return String(value).replace(SPACE_REG, '').replace(BRACKET_REG, '');
}

/**
 * 校验公司名称是否可保存（先清洗再检查是否含其他标点）
 * @param {string|null|undefined} value - 公司名称
 * @param {string} [fieldLabel='公司名称'] - 字段标签，用于错误提示
 * @returns {{ valid: boolean, value: string, message: string }}
 */
export function validateCompanyNameForSave(value, fieldLabel = '公司名称') {
	const sanitized = sanitizeCompanyNamePasted(value);
	if (!sanitized) {
		return { valid: false, value: sanitized, message: `${fieldLabel}不能为空` };
	}
	if (INVALID_CHAR_REG.test(sanitized)) {
		return { valid: false, value: sanitized, message: `${fieldLabel}不能包含标点符号` };
	}
	return { valid: true, value: sanitized, message: '' };
}

/**
 * 生成 Element UI 公司名称校验规则
 * @param {string} [fieldLabel='公司名称'] - 字段标签
 * @returns {Object} validator rule
 */
export function createCompanyNameValidatorRule(fieldLabel = '公司名称') {
	return {
		validator: (rule, value, callback) => {
			if (value == null || value === '') {
				callback();
				return;
			}
			const result = validateCompanyNameForSave(value, fieldLabel);
			if (!result.valid) {
				callback(new Error(result.message));
				return;
			}
			callback();
		},
		trigger: 'blur'
	};
}
