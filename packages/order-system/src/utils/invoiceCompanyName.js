/**
 * 需求：票点管理粘贴公司名称时去除空白，只保留小括号和英文连字符 -，清除其他标点符号。
 * 改动：将允许字符收窄为中英文小括号和 -，统一清除其余括号、标点、符号和空白。
 * 仅处理手动粘贴的票据单位名称，系统选择的供应商/客户名称不处理。
 */
/** 允许保留的中英文小括号和英文连字符 */
const ALLOWED_PUNCTUATION = new Set('()（）-');
/** Unicode 标点、符号及空白，覆盖中英文及全角字符 */
const PUNCTUATION_OR_SPACE_REG = /[\p{P}\p{S}\s]/gu;

/**
 * 手动粘贴票据单位名称时清洗：去除空白和其他标点，保留小括号和 -
 * @param {string|null|undefined} value - 原始文本
 * @returns {string} 清洗后的票据单位名称
 */
export function sanitizeInvoiceCompanyNamePasted(value) {
	if (value == null || value === '') return '';
	return String(value).replace(PUNCTUATION_OR_SPACE_REG, character => (ALLOWED_PUNCTUATION.has(character) ? character : ''));
}
