<!-- 用户需求：FundChangeTemplates 内所有模板增加导出表格数据功能。实际改动：提供统一导出按钮，按模板当前明细、汇总及 summaryOnly 状态生成 XLSX，并处理空数据、加载和错误状态。 -->
<template>
	<div class="fund-change-export">
		<el-button type="primary" plain size="mini" icon="el-icon-download" :disabled="disabled" :loading="exporting" @click="handleExport">导出表格</el-button>
	</div>
</template>

<script>
import { buildFundChangeExportFileName, buildFundChangeExportSheets, writeFundChangeWorkbook } from './fundChangeExport';

export default {
	name: 'FundChangeExportButton',
	props: {
		columns: { type: Array, default: () => [] },
		rows: { type: Array, default: () => [] },
		summaryRows: { type: Array, default: () => [] },
		moduleLabel: { type: String, default: '资金变动' },
		summaryOnly: { type: Boolean, default: false }
	},
	data() {
		return { exporting: false };
	},
	computed: {
		exportSheets() {
			return buildFundChangeExportSheets({ columns: this.columns, rows: this.rows, summaryRows: this.summaryRows, moduleLabel: this.moduleLabel, summaryOnly: this.summaryOnly });
		},
		disabled() {
			return this.exportSheets.length === 0;
		}
	},
	methods: {
		handleExport() {
			if (this.disabled || this.exporting) return;
			this.exporting = true;
			try {
				writeFundChangeWorkbook(this.exportSheets, buildFundChangeExportFileName(this.moduleLabel));
				this.$message.success('导出成功');
			} catch (error) {
				this.$message.error('导出失败，请稍后重试');
			} finally {
				this.exporting = false;
			}
		}
	}
};
</script>

<style scoped>
.fund-change-export {
	display: flex;
	justify-content: flex-end;
	margin-bottom: 10px;
}
</style>
