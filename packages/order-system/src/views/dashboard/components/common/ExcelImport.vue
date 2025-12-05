<!--excel导入组件 对外展示为一个按钮-->

<script>
import SheetList from '@/views/dashboard/components/common/SheetList.vue';
import { importBatchInvoiceInData, importBatchInvoiceOutData } from '@/api/system/batchInvoice';

const API_CONFIG = {
	in: {
		importData: importBatchInvoiceInData,
		templatePath: 'system/batchInvoiceIn/importTemplate'
	},
	out: {
		importData: importBatchInvoiceOutData,
		templatePath: 'system/batchInvoiceOut/importTemplate'
	}
};

export default {
	name: 'ExcelImport',
	components: { SheetList },
	props: {
		mode: {
			type: String,
			default: 'in',
			validator: value => ['in', 'out'].includes(value)
		}
	},
	data() {
		return {
			dialogVisible: false,
			uploadLoading: false,
			currentStep: 1,
			initialVoucher: ''
		};
	},
	computed: {
		modeLabel() {
			return this.mode === 'out' ? '销项' : '进项';
		}
	},
	methods: {
		// 恢复上次开票流程，直接打开批量开票全屏弹窗
		resumeLast() {
			const raw = localStorage.getItem('batch-invoice-session');
			if (!raw) {
				this.$message.info('暂无上次开票会话');
				return;
			}
			this.$bus.$emit('excel:resume');
			this.dialogVisible = true;
		},
		// 点击后上传
		handleUpload() {
			this.clearState();
			if (this.$refs.fileInput) {
				this.$refs.fileInput.value = '';
				this.$refs.fileInput.click();
			}
		},
		handleManage() {
			this.initialVoucher = '';
			this.dialogVisible = true;
		},
		getApiConfig() {
			return API_CONFIG[this.mode] || API_CONFIG.in;
		},
		isExcelFile(file) {
			if (!file || !file.name) return false;
			const parts = file.name.split('.');
			const ext = parts.length > 1 ? parts[parts.length - 1].toLowerCase() : '';
			return ['xls', 'xlsx'].includes(ext);
		},
		async onChange(e) {
			const files = (e && e.target && e.target.files) || [];
			if (!files.length) {
				this.$message.warning('请选择文件,当前没有选择任何文件!!');
				return;
			}
			const file = files[0];
			if (!this.isExcelFile(file)) {
				this.$message.warning('文件格式不正确, 请上传xls/xlsx格式文件!');
				return;
			}
			const formData = new FormData();
			formData.append('file', file);
			const { importData } = this.getApiConfig();
			this.uploadLoading = true;
			try {
				const res = await importData(formData);
				const voucher = res?.data?.voucher || '';
				this.initialVoucher = voucher;
				this.$message.success(res?.msg || '导入成功');
				this.dialogVisible = true;
			} catch (error) {
				const msg = (error && error.msg) || '导入失败，请稍后再试';
				this.$message.error(msg);
			} finally {
				this.uploadLoading = false;
				if (e && e.target) {
					e.target.value = '';
				}
			}
		},
		// 下载模板
		downloadTemplate() {
			const { templatePath } = this.getApiConfig();
			const filename = `批量${this.modeLabel}开票模板_${Date.now()}.xlsx`;
			this.download(templatePath, {}, filename);
		},
		clearState() {
			this.initialVoucher = '';
		}
	}
};
</script>

<template>
	<div class="excel-import-wrapper">
		<!-- Excel导入组件主体 -->
		<div class="excel-import-container">
			<!-- 左侧标题和描述 -->
			<div class="left-section">
				<div class="header-content">
					<i class="el-icon-s-promotion header-icon"></i>
					<div class="header-text">
						<h4 class="header-title">Excel批量开票</h4>
					</div>
				</div>
			</div>

			<!-- 中间步骤区域 -->
			<div class="middle-section">
				<el-steps :active="currentStep" simple class="compact-steps">
					<el-step title="下载模板" icon="el-icon-download"></el-step>
					<el-step title="填写信息" icon="el-icon-edit-outline" @click.native="resumeLast"></el-step>
					<el-step title="批量开票" icon="el-icon-s-order"></el-step>
				</el-steps>
			</div>

			<!-- 右侧操作按钮 -->
			<div class="right-section">
				<div class="action-buttons">
					<el-button class="compact-btn download-btn" type="primary" icon="el-icon-download" size="small" @click="downloadTemplate">下载模板</el-button>
				<el-button class="compact-btn upload-btn" type="success" icon="el-icon-upload" size="small" :loading="uploadLoading" @click="handleUpload">导入Excel</el-button>
				<el-button class="compact-btn manage-btn" type="info" icon="el-icon-document" size="small" @click="handleManage">管理导入记录</el-button>
				<input ref="fileInput" type="file" class="file-input-hidden" @change="onChange" />
				</div>
			</div>
		</div>

		<!-- 批量开票弹窗 -->
		<div>
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="`批量${modeLabel}开票导入记录`" :visible.sync="dialogVisible" width="80%" class="sheet-select-dialog">
				<div class="dialog-content">
				<div class="dialog-tip">
					<i class="el-icon-info"></i>
					<span>批量导入记录已经改为后端分页存储，可在下方列表中查询、删除或发起开票。</span>
					</div>
					<el-card class="sheet-card">
					<SheetList :mode="mode" :initial-voucher="initialVoucher" />
					</el-card>
				</div>
				<span slot="footer" class="dialog-footer">
					<el-button @click="dialogVisible = false">关 闭</el-button>
				</span>
			</el-dialog>
		</div>
	</div>
</template>

<style scoped lang="scss">
/* 组件外层包装 */
.excel-import-wrapper {
	width: 100%;
	margin: 8px 0;
	display: block;
	/* 确保占用一整行 */
}

/* 主容器样式 - 固定高度120px */
.excel-import-container {
	height: 120px;
	background: linear-gradient(135deg, #f8fbff 0%, #f0f7ff 100%);
	border: 1px solid #e1ecf4;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
	transition: all 0.3s ease;
	position: relative;
	overflow: hidden;
	display: flex;
	align-items: center;
	padding: 0 20px;

	&::before {
		content: '';
		position: absolute;
		top: 0;
		left: 0;
		right: 0;
		height: 2px;
		background: linear-gradient(90deg, #409eff 0%, #67c23a 50%, #e6a23c 100%);
	}

	&:hover {
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
		border-color: #c6e2ff;
	}
}

/* 左侧区域 - 标题和描述 */
.left-section {
	flex: 0 0 180px;
	/* 从200px减少到180px */

	.header-content {
		display: flex;
		align-items: center;
		gap: 12px;

		.header-icon {
			font-size: 28px;
			color: #409eff;
			animation: pulse 2s infinite;
			flex-shrink: 0;
		}

		.header-text {
			.header-title {
				margin: 0;
				font-size: 16px;
				font-weight: 600;
				color: #2c3e50;
				line-height: 1.2;
				background: linear-gradient(45deg, #409eff, #67c23a);
				-webkit-background-clip: text;
				-webkit-text-fill-color: transparent;
				background-clip: text;
			}

			.header-description {
				color: #606266;
				font-size: 12px;
				line-height: 1.3;
				margin-top: 2px;
				display: block;
			}
		}
	}
}

/* 中间区域 - 步骤展示 */
.middle-section {
	flex: 1;
	padding: 0 30px;
	display: flex;
	align-items: center;
	justify-content: center;
	min-width: 0;
	/* 确保flex能够正确收缩 */
}

.compact-steps {
	width: 100%;
	max-width: none;
	/* 移除最大宽度限制，让步骤条占满可用空间 */

	::v-deep .el-steps--simple {
		display: flex;
		justify-content: space-between;
		/* 让步骤均匀分布 */
	}

	::v-deep .el-step {
		flex: 1;
		/* 让每个步骤占用相等空间 */
		display: flex;
		justify-content: center;
	}

	::v-deep .el-step__head {
		width: 24px;
		/* 稍微增大图标尺寸 */
		height: 24px;

		.el-step__icon {
			width: 24px;
			height: 24px;
			font-size: 13px;
			/* 相应增大字体 */

			&.is-process {
				background: #409eff;
				border-color: #409eff;
			}

			&.is-finish {
				background: #67c23a;
				border-color: #67c23a;
			}
		}
	}

	::v-deep .el-step__main {
		margin-left: 8px;
		/* 增加间距 */

		.el-step__title {
			font-size: 13px;
			/* 稍微增大字体 */
			font-weight: 500;
			color: #303133;
			line-height: 1.2;
			margin-top: 2px;
			white-space: nowrap;
			/* 防止文字换行 */
		}
	}

	::v-deep .el-step__line {
		background: #e4e7ed;
		height: 1px;
		top: 12px;
		/* 调整线条位置 */
	}

	::v-deep .el-step.is-process .el-step__line {
		background: #409eff;
	}

	::v-deep .el-step.is-finish .el-step__line {
		background: #67c23a;
	}
}

/* 右侧区域 - 操作按钮 */
.right-section {
	flex: 0 0 160px;
	/* 从180px减少到160px */
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 8px;
}

.action-buttons {
	display: flex;
	gap: 8px;
	flex-wrap: wrap;
	justify-content: center;
}

.compact-btn {
	min-width: 80px;
	height: 32px;
	font-size: 12px;
	font-weight: 500;
	border-radius: 4px;
	transition: all 0.3s ease;
	position: relative;
	overflow: hidden;

	&::before {
		content: '';
		position: absolute;
		top: 0;
		left: -100%;
		width: 100%;
		height: 100%;
		background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
		transition: left 0.4s ease;
	}

	&:hover::before {
		left: 100%;
	}

	&:not(:disabled):hover {
		transform: translateY(-1px);
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
	}

	&.download-btn {
		background: linear-gradient(135deg, #409eff 0%, #36a3f7 100%);
		border: none;

		&:hover {
			background: linear-gradient(135deg, #36a3f7 0%, #2a91e0 100%);
		}
	}

	&.upload-btn {
		background: linear-gradient(135deg, #67c23a 0%, #5cb030 100%);
		border: none;

		&:hover:not(:disabled) {
			background: linear-gradient(135deg, #5cb030 0%, #529b2e 100%);
		}

		&:disabled {
			background: #c0c4cc;
			cursor: not-allowed;
			transform: none;

			&::before {
				display: none;
			}
		}
	}

	&.manage-btn {
		background: linear-gradient(135deg, #909399 0%, #606266 100%);
		border: none;

		&:hover {
			background: linear-gradient(135deg, #7f8287 0%, #505257 100%);
		}
	}
}

/* 隐藏文件输入框 */
.file-input-hidden {
	display: none;
}

/* 状态指示器 */
.status-indicator {
	.status-text {
		font-size: 11px;
		color: #909399;
		padding: 2px 8px;
		border-radius: 10px;
		background: rgba(144, 147, 153, 0.1);
		border: 1px solid #e4e7ed;
		transition: all 0.3s ease;

		&.active {
			color: #67c23a;
			background: rgba(103, 194, 58, 0.1);
			border-color: #b3d8a0;
		}
	}
}

/* 弹窗样式保持不变 */
.sheet-select-dialog {
	::v-deep .el-dialog {
		border-radius: 8px;
		overflow: hidden;
	}

	::v-deep .el-dialog__header {
		background: linear-gradient(135deg, #f8fbff 0%, #f0f7ff 100%);
		border-bottom: 1px solid #e1ecf4;
		padding: 16px 20px;
	}

	::v-deep .el-dialog__title {
		font-weight: 600;
		color: #2c3e50;
		font-size: 14px;
	}

	::v-deep .el-dialog__body {
		padding: 20px;
	}

	::v-deep .el-dialog__footer {
		border-top: 1px solid #e4e7ed;
		padding: 12px 20px;
		text-align: center;
	}
}

.dialog-content {
	.dialog-tip {
		display: flex;
		align-items: center;
		gap: 6px;
		padding: 8px 12px;
		border-radius: 4px;
		margin-bottom: 12px;
		font-size: 12px;
		transition: all 0.3s ease;

		&:not(.large-file-tip) {
			background: rgba(64, 158, 255, 0.1);
			border: 1px solid #c6e2ff;
			color: #409eff;
		}

		&.large-file-tip {
			background: rgba(230, 162, 60, 0.1);
			border: 1px solid #f0c78a;
			color: #e6a23c;
		}

		i {
			font-size: 14px;
			flex-shrink: 0;
		}
	}
}

.sheet-card {
	border-radius: 6px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);

	::v-deep .el-card__body {
		padding: 12px;
	}
}

/* 动画效果 */
@keyframes pulse {
	0%,
	100% {
		opacity: 1;
		transform: scale(1);
	}

	50% {
		opacity: 0.8;
		transform: scale(1.05);
	}
}

/* 响应式设计 */
@media screen and (max-width: 1200px) {
	.middle-section {
		padding: 0 12px;
	}

	.compact-steps {
		max-width: 250px;
	}
}

@media screen and (max-width: 992px) {
	.excel-import-container {
		padding: 0 16px;
	}

	.left-section {
		flex: 0 0 160px;

		.header-content {
			gap: 8px;

			.header-icon {
				font-size: 24px;
			}

			.header-text .header-title {
				font-size: 14px;
			}
		}
	}

	.right-section {
		flex: 0 0 140px;
	}

	.compact-btn {
		min-width: 65px;
		font-size: 11px;
	}
}

@media screen and (max-width: 768px) {
	.excel-import-container {
		height: auto;
		min-height: 100px;
		flex-direction: column;
		padding: 12px;
		gap: 8px;
	}

	.left-section,
	.middle-section,
	.right-section {
		flex: none;
		width: 100%;
		padding: 0;
	}

	.left-section .header-content {
		justify-content: center;
	}

	.middle-section {
		display: flex;
		justify-content: center;
	}

	.compact-steps {
		max-width: 280px;
	}

	.action-buttons {
		gap: 6px;
	}

	.compact-btn {
		min-width: 70px;
		height: 28px;
	}
}

@media screen and (max-width: 480px) {
	.excel-import-container {
		padding: 10px;
		margin: 6px 0;
	}

	.left-section .header-content {
		gap: 6px;

		.header-icon {
			font-size: 20px;
		}

		.header-text {
			.header-title {
				font-size: 13px;
			}

			.header-description {
				font-size: 11px;
			}
		}
	}

	.compact-steps {
		max-width: 240px;

		::v-deep .el-step__title {
			font-size: 11px;
		}
	}

	.compact-btn {
		min-width: 60px;
		font-size: 10px;
	}
}
</style>
