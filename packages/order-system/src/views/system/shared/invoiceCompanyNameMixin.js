/**
 * 需求：票点管理粘贴公司名称时去除空白，只保留小括号和英文连字符 -，清除其他标点符号。
 * 改动：沿用共用清洗函数回填表单，更新粘贴规则说明为仅保留小括号和 -。
 * 系统通过 SearchOption 选择的供应商/客户名称不做任何限制
 */
import { sanitizeInvoiceCompanyNamePasted } from '@/utils/invoiceCompanyName';

export default {
	methods: {
		/**
		 * 手动填写票据单位名称时粘贴清洗（仅用于 form 内可编辑输入框）
		 * @param {ClipboardEvent} event - 粘贴事件
		 * @param {string} fieldKey - form 字段名，如 invoiceCompanyName
		 */
		handleManualInvoiceCompanyNamePaste(event, fieldKey) {
			event.preventDefault();
			const clipboardData = event.clipboardData || window.clipboardData;
			const pastedText = clipboardData ? clipboardData.getData('text') : '';
			const sanitized = sanitizeInvoiceCompanyNamePasted(pastedText);
			if (!this.form) return;
			this.$set(this.form, fieldKey, sanitized);
		}
	}
};
