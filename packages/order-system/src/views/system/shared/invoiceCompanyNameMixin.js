/**
 * 2026-06-25 票点管理：公司名称粘贴自动去除空格/括号，保存时校验不允许其他标点
 */
import { sanitizeCompanyNamePasted, validateCompanyNameForSave } from '@/utils/companyName';

/**
 * 票点管理模块：公司名称粘贴清洗与保存校验 mixin
 */
export default {
	methods: {
		/**
		 * 2026-06-25 票点管理：粘贴公司名称自动去除空格和括号
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
		 * 2026-06-25 票点管理：提交前校验并规范化公司名称
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
		 * 2026-06-25 票点管理：SearchOption 选中公司时清洗名称
		 * @param {string|null|undefined} companyName - 公司名称
		 * @returns {string}
		 */
		sanitizeSelectedCompanyName(companyName) {
			return sanitizeCompanyNamePasted(companyName || '');
		}
	}
};
