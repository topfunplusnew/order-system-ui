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
		// 点击上传按钮
		handleUpload() {
			this.clearState();
			if (this.$refs.fileInput) {
				this.$refs.fileInput.value = '';
				this.$refs.fileInput.click();
			}
		},
		// 打开管理记录弹窗
		handleManage() {
			this.initialVoucher = '';
			this.dialogVisible = true;
		},
		// 获取API配置
		getApiConfig() {
			return API_CONFIG[this.mode] || API_CONFIG.in;
		},
		// 判断是否为Excel文件
		isExcelFile(file) {
			if (!file || !file.name) return false;
			const parts = file.name.split('.');
			const ext = parts.length > 1 ? parts[parts.length - 1].toLowerCase() : '';
			return ['xls', 'xlsx'].includes(ext);
		},
		// 文件选择变化处理
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
			await this.uploadFile(file);
			// 清空文件输入框
			if (e && e.target) {
				e.target.value = '';
			}
		},
		// 上传文件
		async uploadFile(file) {
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

			<!-- 右侧操作按钮 - 水平布局 -->
			<div class="right-section">
				<el-button class="action-btn download-btn" type="primary" icon="el-icon-download" size="small" @click="downloadTemplate">下载模板</el-button>
				<el-button class="action-btn upload-btn" type="success" icon="el-icon-upload2" size="small" :loading="uploadLoading" @click="handleUpload">导入Excel</el-button>
				<el-button class="action-btn manage-btn" type="warning" icon="el-icon-folder-opened" size="small" @click="handleManage">管理记录</el-button>
				<input ref="fileInput" type="file" class="file-input-hidden" @change="onChange" />
			</div>
		</div>

		<!-- 批量开票弹窗 -->
		<div>
			<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="`批量${modeLabel}开票导入记录`" :visible.sync="dialogVisible" width="80%" class="sheet-select-dialog batch-import-dialog">
				<div class="dialog-content">
					<div class="dialog-tip">
						<i class="el-icon-info"></i>
						<span>批量导入记录已改为后端分页存储，可在下方列表中查询、删除或发起开票。</span>
					</div>
					<!-- 直接放置 SheetList，不再套 el-card -->
					<SheetList :mode="mode" :initial-voucher="initialVoucher" />
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

/* 主容器样式 */
.excel-import-container {
	height: 72px;
	background: linear-gradient(135deg, #fff 0%, #f8fbff 100%);
	border: 1px solid #d9ecff;
	border-radius: 10px;
	box-shadow: 0 2px 12px rgba(67, 158, 253, 0.08);
	transition: all 0.3s ease;
	position: relative;
	overflow: hidden;
	display: flex;
	align-items: center;
	padding: 0 24px;

	&::before {
		content: '';
		position: absolute;
		top: 0;
		left: 0;
		right: 0;
		height: 3px;
		background: linear-gradient(90deg, #439efd 0%, #67c8ff 50%, #5dade2 100%);
	}

	&:hover {
		box-shadow: 0 4px 16px rgba(67, 158, 253, 0.15);
		border-color: #b3d8ff;
	}
}

/* 左侧区域 - 标题 */
.left-section {
	flex: 0 0 160px;

	.header-content {
		display: flex;
		align-items: center;
		gap: 10px;

		.header-icon {
			font-size: 24px;
			color: #439efd;
			flex-shrink: 0;
		}

		.header-text {
			.header-title {
				margin: 0;
				font-size: 15px;
				font-weight: 600;
				color: #303133;
				line-height: 1.4;
			}
		}
	}
}

/* 中间区域 - 步骤展示 */
.middle-section {
	flex: 1;
	padding: 0 24px;
	display: flex;
	align-items: center;
	justify-content: center;
	min-width: 0;
}

.compact-steps {
	width: 100%;
	max-width: none;

	::v-deep .el-steps--simple {
		display: flex;
		justify-content: space-between;
	}

	::v-deep .el-step {
		flex: 1;
		display: flex;
		justify-content: center;
	}

	::v-deep .el-step__head {
		width: 22px;
		height: 22px;

		.el-step__icon {
			width: 22px;
			height: 22px;
			font-size: 12px;

			&.is-process {
				background: #439efd;
				border-color: #439efd;
			}

			&.is-finish {
				background: #67c23a;
				border-color: #67c23a;
			}
		}
	}

	::v-deep .el-step__main {
		margin-left: 6px;

		.el-step__title {
			font-size: 12px;
			font-weight: 500;
			color: #606266;
			line-height: 1.2;
			white-space: nowrap;
		}
	}

	::v-deep .el-step__line {
		background: #e4e7ed;
		height: 1px;
		top: 11px;
	}

	::v-deep .el-step.is-process .el-step__line {
		background: #439efd;
	}

	::v-deep .el-step.is-finish .el-step__line {
		background: #67c23a;
	}
}

/* 右侧区域 - 水平按钮布局 */
.right-section {
	flex: 0 0 auto;
	display: flex;
	align-items: center;
	gap: 10px;
}

/* 操作按钮样式 */
.action-btn {
	height: 34px;
	padding: 0 14px;
	font-size: 13px;
	font-weight: 500;
	border-radius: 6px;
	transition: all 0.25s ease;
	border: none;
	white-space: nowrap;

	&:not(:disabled):hover {
		transform: translateY(-2px);
	}

	&.download-btn {
		background: linear-gradient(135deg, #439efd 0%, #5dade2 100%);
		box-shadow: 0 3px 8px rgba(67, 158, 253, 0.3);

		&:hover {
			background: linear-gradient(135deg, #5dade2 0%, #3498db 100%);
			box-shadow: 0 5px 14px rgba(67, 158, 253, 0.4);
		}
	}

	&.upload-btn {
		background: linear-gradient(135deg, #67c23a 0%, #5cb85c 100%);
		box-shadow: 0 3px 8px rgba(103, 194, 58, 0.3);

		&:hover:not(:disabled) {
			background: linear-gradient(135deg, #5cb85c 0%, #4cae4c 100%);
			box-shadow: 0 5px 14px rgba(103, 194, 58, 0.4);
		}

		&:disabled {
			background: #c0c4cc;
			box-shadow: none;
			cursor: not-allowed;
			transform: none;
		}
	}

	&.manage-btn {
		background: linear-gradient(135deg, #e6a23c 0%, #f5a623 100%);
		box-shadow: 0 3px 8px rgba(230, 162, 60, 0.3);

		&:hover {
			background: linear-gradient(135deg, #f5a623 0%, #e09520 100%);
			box-shadow: 0 5px 14px rgba(230, 162, 60, 0.4);
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

/* 批量导入弹窗样式优化 */
.batch-import-dialog {
	::v-deep .el-dialog {
		border-radius: 8px;
		overflow: hidden;
		box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
	}

	::v-deep .el-dialog__header {
		background: linear-gradient(135deg, #439efd 0%, #5dade2 100%);
		padding: 16px 24px;
		border-bottom: none;
	}

	::v-deep .el-dialog__title {
		font-weight: 600;
		color: #fff;
		font-size: 16px;
	}

	::v-deep .el-dialog__headerbtn .el-dialog__close {
		color: #fff;

		&:hover {
			color: #f0f0f0;
		}
	}

	::v-deep .el-dialog__body {
		padding: 20px 24px;
		background: #fafbfc;
	}

	::v-deep .el-dialog__footer {
		border-top: 1px solid #ebeef5;
		padding: 14px 24px;
		background: #fff;
		text-align: center;
	}
}

.dialog-content {
	.dialog-tip {
		display: flex;
		align-items: center;
		gap: 8px;
		padding: 10px 14px;
		border-radius: 6px;
		margin-bottom: 16px;
		font-size: 13px;
		background: linear-gradient(135deg, #e8f4fd 0%, #d6eaff 100%);
		border: none;
		color: #0066cc;
		box-shadow: 0 1px 3px rgba(0, 102, 204, 0.1);

		i {
			font-size: 16px;
			color: #409eff;
		}
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
