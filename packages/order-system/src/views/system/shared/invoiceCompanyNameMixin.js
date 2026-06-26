import { sanitizeCompanyNamePasted, validateCompanyNameForSave } from '@/utils/companyName';

/**
 * 票点管理模块：公司名称粘贴清洗与保存校验
 */
export default {
	methods: {
		/**
		 * 粘贴公司名称：自动去除空格和括号
		 * @param {ClipboardEvent} event - 粘贴事件
		 * @param {'form'|'queryParams'} sourceKey - 数据源 key
		 * @param {string} fieldKey - 字段名
		 */
		handleInvoiceCompanyNamePaste(event, sourceKey, fieldKey) {
			event.preventDefault();
			const clipboardData = event.clipboardData || window.clipboardData;
			const pastedText = clipboardData ? clipboardData.getData('text') : '';
			const sanitized = sanitizeCompanyNamePasted(pastedText);
			const target = this[sourceKey];
			if (!target) return;
			this.$set(target, fieldKey, sanitized);
		},

		/**
		 * 提交前规范化表单中的公司名称字段
		 * @param {Object} form - 表单对象
		 * @param {Array<{ key: string, label: string }>} fields - 字段配置
		 * @returns {boolean} 是否通过校验
		 */
		normalizeInvoiceCompanyNamesBeforeSave(form, fields) {
			for (const { key, label } of fields || []) {
				const raw = form[key];
				if (raw == null || raw === '') continue;
				const result = validateCompanyNameForSave(raw, label);
				if (!result.valid) {
					this.$message.error(result.message);
					return false;
				}
				form[key] = result.value;
			}
			return true;
		},

		/**
		 * SearchOption 选中公司时清洗公司名称
		 * @param {string|null|undefined} companyName - 公司名称
		 * @returns {string}
		 */
		sanitizeSelectedCompanyName(companyName) {
			return sanitizeCompanyNamePasted(companyName || '');
		}
	}
};
