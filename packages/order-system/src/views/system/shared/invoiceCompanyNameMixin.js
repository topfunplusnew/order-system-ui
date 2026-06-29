/**
 * 2026-06-25 票点管理：仅手动填写的票据单位名称粘贴时去除空格/括号
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
