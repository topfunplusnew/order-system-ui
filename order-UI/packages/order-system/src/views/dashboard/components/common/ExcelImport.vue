<!--excel导入组件 对外展示为一个按钮-->

<script>
import SheetList from '@/views/dashboard/components/common/SheetList.vue';
import { mixin_excel_server } from '@/views/dashboard/components/common/utils/excelServer';
import { read, utils, writeFile } from 'xlsx';

export default {
	name: 'ExcelImport',
	components: { SheetList },
	mixins: [mixin_excel_server],
	data() {
		return {
			// 是否显示excel 展示框
			dialogVisible: false,
			fileList: [], // 上传文件列表
			tableHead: [], // 表头
			tableData: [], // 表数据
			// 要读取哪一个sheet 默认是读取第一个sheet
			sheetIndex: 1,
			// sheet列表
			sheetList: [],
			// 批量开票的弹窗
			invoiceAllVisible: false,
			// 当前的操作步骤
			currentStep: 1
		};
	},
	methods: {
		// 点击后上传 通过主动调用ref
		handleUpload() {
			// 清空状态
			this.clearState();
			// 清空上次上传的文件
			this.$refs.fileInput.value = '';
			// 触发input的点击事件
			this.$refs.fileInput.click();
		},
		/**
		 * excel的读写操作 如果后期excel大小过于大在这里优化
		 * @param e Event
		 */
		onChange(e) {
			// 清除状态
			this.handleClearExcel();

			if (e.target.files.length === 0) {
				this.$message.warning('请选择文件,当前没有选择任何文件!!');
				return false;
			}
			// 获取上传的第一个文件
			const file = e.target.files[0];

			if (!this.checkFileType(file)) {
				this.$message.warning(`文件格式不正确, 请上传xls/xlsx格式文件!`);
				return false;
			}

			// fileReader读取文件
			const fileReader = new FileReader();

			// FileReader 接口的 load 事件在成功读取文件时触发。
			fileReader.onload = ev => {
				try {
					// data是文件读取的二进制数据
					const data = ev.target.result;
					// read是xlsx库提供的一个方法 返回一个workbook工作铺对象 里面包含sheets对象，sheet对象中包含表名，表数据等
					const workbook = read(data, { type: 'binary' });
					// 取对应表生成json表格内容  SheetNames 是所有的 Sheet item就是每一个Sheet
					workbook.SheetNames.forEach(item => {
						// 填充到sheetList中
						this.sheetList.push(item);
						// 放入tableData中 el-table中tableData的数据结构为 [{},{},{}] 对象中每一个属性对应一个column 的prop
						this.tableData.push(utils.sheet_to_json(workbook.Sheets[item]));
					});
					// 存储vuex中 供给子组件使用
					this.handleStoreExcel(this.tableData);
					// 打开选择sheet的弹窗
					this.dialogVisible = true;
					return true;
					// 重写数据
				} catch (e) {
					console.log('读取excel发生异常:' + e);
					return false;
				}
			};
			fileReader.readAsBinaryString(file);
		},
		// 校验一下文件类型
		checkFileType(file) {
			const fileName = file.name.split('.');
			const fileExt = fileName[fileName.length - 1];
			return ['xls', 'xlsx'].indexOf(fileExt) >= 0;
		},
		// 清除状态
		clearState() {
			this.sheetList = [];
			this.tableData = [];
		},
		// 下载模板
		downloadTemplate() {
			// 模板数据
			const templateData = [
				{
					销方ID: 0,
					销方类型: '己方公司',
					销方名称: '我方科技有限公司',
					购买方ID: 1001,
					购买方类型: '客户',
					购买方名称: '客户公司A',
					价税合计: 10000.0,
					票点: 0.03
				},
				{
					销方ID: 2001,
					销方类型: '客户',
					销方名称: '客户公司B',
					购买方ID: 0,
					购买方类型: '己方公司',
					购买方名称: '我方科技有限公司',
					价税合计: 10000.0,
					票点: 0.05
				},
				{
					销方ID: 2002,
					销方类型: '供应商',
					销方名称: '供应商公司B',
					购买方ID: 0,
					购买方类型: '己方公司',
					购买方名称: '我方科技有限公司',
					价税合计: 10000.0,
					票点: 0.02
				}
			];

			// 创建工作簿
			const wb = utils.book_new();

			// 将数据转换为工作表
			const ws = utils.json_to_sheet(templateData);

			// 在数据下方添加说明信息
			const notes = [
				['注：请将此段说明删除整段删除后再进行导入开票的操作！'],
				['数据填写规范说明：'],
				['1. ID规则：'],
				['   - 当类型为"己方公司"时，对应的ID必须为0'],
				['   - 其他类型的ID必须为非0的数字'],
				['2. 类型规则：'],
				['   - 类型只能为：己方公司、客户、供应商'],
				['   - 销方和购买方不能同时为己方公司'],
				['   - 销方和购买方不能同时为除己方公司外的其他类型'],
				['3. 金额规则：'],
				['   - 价税合计必须保留两位小数'],
				['4. 票点规则：'],
				['   - 票点为小数格式，例如：0.03表示3%'],
				['   - 票点金额将自动计算：票点金额 = 开票金额 / (1 + 票点) * 票点'],
				['   - 如不需要票点，可填写0'],
				['']
			];

			// 计算数据的行数
			const dataRowCount = templateData.length;

			// 在数据下方添加说明
			utils.sheet_add_aoa(ws, notes, { origin: `A${dataRowCount + 3}` });

			// 设置列宽
			const colWidth = [
				{ wch: 12 }, // 销方ID
				{ wch: 12 }, // 销方类型
				{ wch: 25 }, // 销方名称
				{ wch: 12 }, // 购买方ID
				{ wch: 12 }, // 购买方类型
				{ wch: 25 }, // 购买方名称
				{ wch: 15 }, // 价税合计
				{ wch: 10 }  // 票点
			];
			ws['!cols'] = colWidth;

			// 将工作表添加到工作簿
			utils.book_append_sheet(wb, ws, '开票模板');
			// 下载文件
			writeFile(wb, '批量开票模板.xlsx');
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
					<el-step title="填写信息" icon="el-icon-edit-outline"></el-step>
					<el-step title="批量开票" icon="el-icon-s-order"></el-step>
				</el-steps>
			</div>

			<!-- 右侧操作按钮 -->
			<div class="right-section">
				<div class="action-buttons">
					<el-button class="compact-btn download-btn" type="primary" icon="el-icon-download" size="small"
						@click="downloadTemplate">
						下载模板
					</el-button>
					<el-button class="compact-btn upload-btn" type="success" icon="el-icon-upload" size="small"
						@click="handleUpload">
						批量开票
					</el-button>
					<input ref="fileInput" type="file" class="file-input-hidden" multiple @change="onChange" />
				</div>
			</div>
		</div>

		<!-- 批量开票弹窗 -->
		<div>
			<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="请选择该excel中的一个工作表后进行批量开票"
				:visible.sync="dialogVisible" width="500px" class="sheet-select-dialog">
				<div class="dialog-content">
					<div class="dialog-tip">
						<i class="el-icon-info"></i>
						<span>检测到Excel文件中包含多个工作表，请选择需要处理的工作表</span>
					</div>
					<el-card class="sheet-card">
						<SheetList :sheet-list="sheetList" />
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
		background: rgba(64, 158, 255, 0.1);
		border: 1px solid #c6e2ff;
		border-radius: 4px;
		margin-bottom: 12px;
		font-size: 12px;
		color: #409eff;

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
