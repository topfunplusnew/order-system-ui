/**
 * 2026-06-25 票点管理：仅手动填写的票据单位名称粘贴时去除空格/括号（系统选择的供应商/客户不处理）
 */
/** 空格 */
const SPACE_REG = /\s/g;
/** 中英文括号 */
const BRACKET_REG = /[()（）\[\]【】{}｛｝<>《》「」『』]/g;

/**
 * 手动粘贴票据单位名称时清洗：去除空格和括号
 * @param {string|null|undefined} value - 原始文本
 * @returns {string} 清洗后的票据单位名称
 */
export function sanitizeInvoiceCompanyNamePasted(value) {
	if (value == null || value === '') return '';
	return String(value).replace(SPACE_REG, '').replace(BRACKET_REG, '');
}
