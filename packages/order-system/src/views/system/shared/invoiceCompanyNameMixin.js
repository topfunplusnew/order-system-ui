/**
 * 2026-06-25 票点管理：票据单位名称粘贴自动去除空格/括号，保存时校验不允许其他标点
 */
import { sanitizeInvoiceCompanyNamePasted, validateInvoiceCompanyNameForSave } from '@/utils/invoiceCompanyName';

/**
 * 票点管理模块：票据单位名称粘贴清洗与保存校验 mixin
 */
export default {
	methods: {
		/**
		 * 2026-06-25 票点管理：粘贴票据单位名称自动去除空格和括号
		 * @param {ClipboardEvent} event - 粘贴事件
		 * @param {'form'|'queryParams'} sourceKey - 数据源 key
		 * @param {string} fieldKey - 字段名
		 */
		handleInvoiceCompanyNamePaste(event, sourceKey, fieldKey) {
			event.preventDefault();
			const clipboardData = event.clipboardData || window.clipboardData;
			const pastedText = clipboardData ? clipboardData.getData('text') : '';
			const sanitized = sanitizeInvoiceCompanyNamePasted(pastedText);
			const target = this[sourceKey];
			if (!target) return;
			this.$set(target, fieldKey, sanitized);
		},

		/**
		 * 2026-06-25 票点管理：提交前校验并规范化票据单位名称
		 * @param {Object} form - 表单对象
		 * @param {Array<{ key: string, label: string }>} fields - 字段配置
		 * @returns {boolean} 是否通过校验
		 */
		normalizeInvoiceCompanyNamesBeforeSave(form, fields) {
			for (const { key, label } of fields || []) {
				const raw = form[key];
				if (raw == null || raw === '') continue;
				const result = validateInvoiceCompanyNameForSave(raw, label);
				if (!result.valid) {
					this.$message.error(result.message);
					return false;
				}
				form[key] = result.value;
			}
			return true;
		}
	}
};
