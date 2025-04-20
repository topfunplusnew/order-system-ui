<template>
	<div>
		<el-row style="margin: 35px 0" :gutter="40">
			<!-- 标记1 -->
			<el-col :span="12">
				<el-row :gutter="10">
					<el-col :span="24">
						<div style="font-weight: bold; font-size: 24px; color: #156fb2; line-height: 60px">今日发货列表</div>
					</el-col>
					<el-form :inline="true" :model="queryParams">
						<el-form-item label="开始时间">
							<el-date-picker
								v-model="queryParams.startTime"
								type="datetime"
								size="mini"
								value-format="yyyy-MM-dd HH:mm:ss"
								placeholder="开始日期"
								class="responsive-date-picker"
							></el-date-picker>
						</el-form-item>
						<el-form-item label="结束时间">
							<el-date-picker
								v-model="queryParams.endTime"
								type="datetime"
								size="mini"
								value-format="yyyy-MM-dd HH:mm:ss"
								placeholder="结束日期"
								class="responsive-date-picker"
							></el-date-picker>
						</el-form-item>
						<el-form-item>
							<el-button type="primary" size="mini" @click="handleSearch">搜索</el-button>
						</el-form-item>
					</el-form>
				</el-row>
				<el-row :gutter="50">
					<el-col>
						<right-toolbar :columns="columns" @queryTable="getList">
							<template #print>
								<el-col :span="1.5">
									<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
								</el-col>
							</template>
							<!--        导出-->
							<template #export>
								<el-col :span="1.5">
									<el-button v-hasPermi="['system:bankaccount:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
								</el-col>
							</template>
						</right-toolbar>
						<!--        发货列表-->
						<el-table
							id="printBox"
							size="mini"
							:data="tableData"
							max-height="500"
							show-summary
							border
							style="width: 100%"
							:loading="loading"
							:header-cell-style="{
								background: '#f0f0f0',
								color: '#333'
							}"
							:cell-style="
								() => {
									return { padding: '2px' };
								}
							"
						>
							<el-table-column prop="index" label="序号" width="50" align="center" type="index"></el-table-column>
							<el-table-column v-if="columns[0].visible" prop="orderDate" label="日期" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[1].visible" prop="companyName" label="客户" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[2].visible" prop="salesman" label="业务员" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[3].visible" prop="arrears" label="欠款" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[4].visible" prop="profit" label="含税利润" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[5].visible" prop="profitNoTax" label="不含税利润" width="110" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[6].visible" prop="payments" label="总货款" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[7].visible" prop="paymentFactory" label="出厂货款" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[8].visible" prop="tonnage" label="吨位" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[9].visible" prop="clerk" label="内勤" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[10].visible" prop="landCarNo" label="陆运车牌" show-overflow-tooltip>
								<template #default="scope">
									<span v-if="scope.row.landCarNo !== null">
										{{ scope.row.landCarNo }}
									</span>
									<span v-else>无</span>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[11].visible" prop="seaCarNo" label="柜号" show-overflow-tooltip>
								<template #default="scope">
									<span v-if="scope.row.seaCarNo !== null">
										{{ scope.row.seaCarNo }}
									</span>
									<span v-else>无</span>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[12].visible" prop="fleet" label="车队" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[13].visible" prop="freight" label="运费" show-overflow-tooltip></el-table-column>
						</el-table>
						<pagination
							v-show="total > 0"
							:total="total"
							:page.sync="queryParams.pageNum"
							:limit.sync="queryParams.pageSize"
							@pagination="getList"
							style="width: 100%; text-align: center"
						/>
					</el-col>
				</el-row>
			</el-col>

			<!-- 标记2 -->
			<el-col :span="12">
				<el-row :gutter="10">
					<el-col :span="24">
						<div style="font-weight: bold; font-size: 24px; color: #156fb2; line-height: 60px">利润</div>
					</el-col>
					<el-form :inline="true" :model="queryParamsHome">
						<el-form-item label="开始日期">
							<el-date-picker
								v-model="queryParamsHome.startTime"
								type="date"
								size="mini"
								value-format="yyyy-MM-dd"
								placeholder="开始日期"
								class="responsive-date-picker"
							></el-date-picker>
						</el-form-item>
						<el-form-item label="时间">
							<el-date-picker v-model="queryParamsHome.endTime" type="date" size="mini" value-format="yyyy-MM-dd" placeholder="结束日期" class="responsive-date-picker"></el-date-picker>
						</el-form-item>
						<el-form-item>
							<el-button type="primary" size="mini" @click="handleProfitSearch">搜索</el-button>
						</el-form-item>
					</el-form>
				</el-row>
				<el-row>
					<el-table height="130" :empty-text="' '" :data="dailyProfit">
						<el-table-column :label="`￥${moneyAmount}`" align="center">
							<el-table-column prop="dailyProfit" label="利润总额">
								<el-table-column prop="dailyExpense" label="费用合计"></el-table-column>
							</el-table-column>
							<el-table-column :label="`￥${dailyProfit}`">
								<el-table-column :label="`￥${dailyExpense}`"></el-table-column>
							</el-table-column>
						</el-table-column>
					</el-table>
				</el-row>
			</el-col>
		</el-row>
		<div class="fixed-footer">
			<div v-if="downloadProgress !== 0">
				<el-progress :percentage="downloadProgress"></el-progress>
			</div>
			<div>
				<el-button type="primary" icon="el-icon-download" size="mini" @click="handleDownload">一键下载</el-button>
				<!-- 修改这里，添加 el-popover -->
				<el-popover placement="top" width="600" trigger="hover" popper-class="preview-popover">
					<div class="preview-content">
						<a-list :data-source="fileList.slice(0, 3)" class="preview-list">
							<a-list-item v-for="(item, index) in fileList.slice(0, 3)" :key="index">
								<a-row type="flex" justify="space-between" align="middle" style="width: 100%">
									<a-col :span="14">
										<a-space>
											<a-icon :type="getIconType(item.fileName)" :style="getIconStyle(item.fileName)" />
											<span class="filename">{{ item.fileName }}</span>
										</a-space>
									</a-col>
									<a-col :span="6">{{ formatDate(item.lastModifiedTime) }}</a-col>
									<a-col :span="4">{{ formatSize(item.size) }}</a-col>
								</a-row>
							</a-list-item>
						</a-list>
						<div v-if="fileList.length > 3" class="preview-footer">还有 {{ fileList.length - 3 }} 个文件，点击查看更多</div>
					</div>
					<el-button slot="reference" type="success" icon="el-icon-folder" size="mini" @click="showFileList">查看下载列表</el-button>
				</el-popover>
			</div>
		</div>

		<!-- 添加文件列表弹窗 -->
		<a-modal title="可下载文件列表" :visible="fileListVisible" @cancel="fileListVisible = false" :footer="null" :width="1000" :destroyOnClose="true" class="file-list-modal">
			<a-list :data-source="fileList" class="file-list">
				<a-list-item v-for="(item, index) in fileList" :key="index">
					<a-row type="flex" justify="space-between" align="middle" style="width: 100%">
						<a-col :span="12">
							<a-space>
								<a-icon :type="getIconType(item.fileName)" :style="getIconStyle(item.fileName)" />
								<span class="filename">{{ item.fileName }}</span>
							</a-space>
						</a-col>
						<a-col :span="6" class="date">{{ formatDate(item.lastModifiedTime) }}</a-col>
						<a-col :span="3" class="size">{{ formatSize(item.size) }}</a-col>
						<a-col :span="3" class="actions">
							<a-space>
								<a-button type="link" @click="downloadFile(item)" style="padding: 4px">
									<a-icon type="download" style="color: #1890ff" />
								</a-button>
								<a-button type="link" @click="deleteFile(item)" style="padding: 4px">
									<a-icon type="delete" style="color: #ff4d4f" />
								</a-button>
							</a-space>
						</a-col>
					</a-row>
				</a-list-item>
			</a-list>
		</a-modal>
		<el-dialog title="一键下载" :visible.sync="dialogVisible" width="30%" :before-close="handleClose">
			<span>这是一段信息</span>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="dialogVisible = false">确 定</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import { getDailyProfit, getDeliveryList } from '../api/system/statement';
import { mixin_printHTML } from './dashboard/mixins/print';
import { parseTime } from '@/utils/ruoyi';
import { mapGetters, mapState } from 'vuex';

export default {
	name: 'Index',
	mixins: [mixin_printHTML],
	data() {
		// 获取今天零点
		const startTime = new Date();
		startTime.setHours(0, 0, 0, 0); // 设置为今天零点

		// 获取今天晚上十二点
		const endTime = new Date();
		endTime.setHours(23, 59, 59, 999); // 设置为今天晚上12点

		// 格式化函数
		function formatDate(date) {
			const y = date.getFullYear();
			const m = String(date.getMonth() + 1).padStart(2, '0');
			const d = String(date.getDate()).padStart(2, '0');
			const h = String(date.getHours()).padStart(2, '0');
			const i = String(date.getMinutes()).padStart(2, '0');
			const s = String(date.getSeconds()).padStart(2, '0');
			return `${y}-${m}-${d} ${h}:${i}:${s}`;
		}

		return {
			loading: false,
			queryParams: {
				startTime: formatDate(startTime),
				endTime: formatDate(endTime),
				pageNum: 1,
				pageSize: 10
			},
			queryParamsHome: {
				startTime: parseTime(new Date(), '{y}-{m}-{d}'),
				endTime: parseTime(new Date(), '{y}-{m}-{d}')
			},
			tableData: [],
			total: 0,
			columns: [
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `客户`, visible: true },
				{ key: 2, label: `录入员`, visible: true },
				{ key: 3, label: `欠款`, visible: true },
				{ key: 4, label: `含税利润`, visible: true },
				{ key: 5, label: `不含税利润`, visible: true },
				{ key: 6, label: `总货款`, visible: true },
				{ key: 7, label: `出厂货款`, visible: true },
				{ key: 8, label: `吨位`, visible: true },
				{ key: 9, label: `内勤`, visible: true },
				{ key: 10, label: `陆运车牌`, visible: true },
				{ key: 11, label: `柜号`, visible: true },
				{ key: 12, label: `车队`, visible: true },
				{ key: 13, label: `运费`, visible: true }
			],
			dailyProfit: null,
			dailyExpense: null,
			moneyAmount: null,
			dialogVisible: false,
			fileListVisible: false,
			fileList: [
				{
					fileName: '2023年11月报表.xlsx',
					lastModifiedTime: '2023-11-20 15:30:00',
					size: 1024576 // 1MB in bytes
				},
				{
					fileName: '2023年10月报表.xlsx',
					lastModifiedTime: '2023-10-31 18:20:00',
					size: 2048576 // 2MB in bytes
				},
				{
					fileName: '2023年9月报表.xlsx',
					lastModifiedTime: '2023-09-30 12:00:00',
					size: 3145728 // 3MB in bytes
				}
			]
		};
	},
	created() {
		this.getList();
		this.handleProfitSearch();
	},
	computed: {
		...mapGetters(['downloadProgress'])
	},
	methods: {
		// 一键下载
		handleDownload() {
			this.$confirm('是否导出空表(若不导出空表导出速率会更快)?', '提示', {
				confirmButtonText: '是',
				cancelButtonText: '否',
				type: 'warning'
			})
				.then(() => {
					this.handleOption(true);
				})
				.catch(() => {
					this.handleOption();
				});
		},
		handleOption(exportEmptyData = false) {
			this.$prompt('请选择导出日期', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				inputType: 'date'
			}).then(res => {
				this.downLoadOnce(
					'/system/allExport/export',
					{
						date: res.value,
						exportEmptyData: exportEmptyData
					},
					`FullReport_${new Date().getTime()}.xlsx`
				);
			});
		},
		handleSearch() {
			this.getList();
		},
		handleProfitSearch() {
			this.dailyProfit = [];
			getDailyProfit(this.queryParamsHome).then(res => {
				this.dailyProfit = res.data.dailyProfit;
				this.dailyExpense = res.data.dailyExpense;
				this.moneyAmount = res.data.dailyProfit - res.data.dailyExpense;
			});
		},
		getList() {
			this.loading = true;
			getDeliveryList(this.queryParams).then(res => {
				this.tableData = res.rows;
				this.total = res.total;
				this.loading = false;
			});
		},
		handleExport() {
			this.download(
				'statistics/export/todayOrderList',
				{
					startTime: this.queryParams.startTime,
					endTime: this.queryParams.endTime
				},
				`todayOrderList${new Date().getTime()}.xlsx`
			);
		},
		handleClose() {
			this.dialogVisible = false;
		},
		showFileList() {
			this.fileListVisible = true;
		},
		formatSize(bytes) {
			if (bytes === 0) return '0 B';
			const k = 1024;
			const sizes = ['B', 'KB', 'MB', 'GB'];
			const i = Math.floor(Math.log(bytes) / Math.log(k));
			return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
		},
		formatDate(date) {
			return date.split(' ')[0];
		},
		downloadFile(file) {
			// 这里添加实际的文件下载逻辑
			this.$message.success(`开始下载: ${file.fileName}`);
		},
		getFileIcon(fileName) {
			const extension = fileName.split('.').pop().toLowerCase();
			switch (extension) {
				case 'xlsx':
				case 'xls':
					return 'excel';
				case 'doc':
				case 'docx':
					return 'word';
				case 'pdf':
					return 'pdf';
				default:
					return 'file';
			}
		},
		deleteFile(file) {
			this.$confirm({
				title: '确认删除',
				content: `是否确认删除文件 "${file.fileName}"？`,
				okText: '确认',
				okType: 'danger',
				cancelText: '取消',
				onOk: () => {
					// 这里添加实际的删除逻辑
					const index = this.fileList.indexOf(file);
					if (index > -1) {
						this.fileList.splice(index, 1);
					}
					this.$message.success(`删除成功: ${file.fileName}`);
				}
			});
		},
		getIconType(fileName) {
			const extension = fileName.split('.').pop().toLowerCase();
			switch (extension) {
				case 'xlsx':
				case 'xls':
					return 'file-excel';
				case 'doc':
				case 'docx':
					return 'file-word';
				case 'pdf':
					return 'file-pdf';
				default:
					return 'file';
			}
		},
		getIconStyle(fileName) {
			const type = this.getFileIcon(fileName);
			const color = {
				excel: '#52c41a',
				word: '#1890ff',
				pdf: '#f5222d',
				file: '#595959'
			}[type];

			return {
				color,
				fontSize: '20px'
			};
		}
	}
};
</script>

<style scoped lang="scss">
@import '~element-ui/lib/theme-chalk/index.css';

.button-search {
	line-height: 60px;
}

.el-row {
	margin-bottom: 20px;
}

.el-col {
	border-radius: 4px;
}

.el-date-editor.el-input,
.el-date-editor.el-input__inner {
	width: 150px;
}

.responsive-date-picker {
	width: 150px;
}

.el-button--mini {
	padding: 6px 12px;
}

.el-table th {
	font-weight: bold;
}

.el-table td,
.el-table th {
	padding: 8px;
}

.el-table .cell {
	font-size: 14px;
}

.el-table thead {
	font-weight: bold;
}

// Media Queries for responsiveness
@media (max-width: 960px) {
	.el-row {
		margin: 20px 0;
	}

	.el-col {
		margin-bottom: 10px;
	}

	.el-date-editor.el-input,
	.el-date-editor.el-input__inner,
	.responsive-date-picker {
		width: 100%;
	}

	.el-button--mini {
		width: 100%;
		margin-top: 10px;
	}

	.el-table {
		overflow-x: auto;
	}
}

.el-button--mini {
	border-radius: 4px;
	font-weight: 500;
}

.fixed-footer {
	border-radius: 10px;
	position: fixed;
	bottom: 0;
	left: 20%;
	width: 80%;
	background: #fff;
	border-top: 1px solid #ddd;
	padding: 10px 20px;
	text-align: right;
	z-index: 1000;

	.el-button {
		margin-left: 10px;
	}
}

.ant-list-item {
	padding: 12px !important;

	&:hover {
		background-color: #fafafa;
	}
}

.file-list-modal {
	:deep(.ant-modal-body) {
		padding: 12px 24px;
		max-height: 600px;
		overflow-y: auto;
	}

	.file-list {
		width: 100%;

		.ant-list-item {
			padding: 12px 0;
			border-bottom: 1px solid #f0f0f0;

			&:hover {
				background-color: #fafafa;
			}

			.filename {
				font-size: 14px;
			}

			.date,
			.size {
				color: rgba(0, 0, 0, 0.45);
				font-size: 14px;
			}

			.actions {
				text-align: right;

				.ant-btn {
					&:hover {
						background-color: #f0f0f0;
					}
				}
			}
		}
	}
}

// 添加预览相关样式
.preview-content {
	padding: 8px 0;

	.preview-list {
		.ant-list-item {
			padding: 8px 12px;

			&:hover {
				background-color: #f5f5f5;
			}

			.filename {
				font-size: 13px;
			}
		}
	}

	.preview-footer {
		text-align: center;
		color: #666;
		font-size: 13px;
		padding: 8px;
		border-top: 1px solid #f0f0f0;
	}
}

:deep(.preview-popover) {
	padding: 0;

	.el-popover__title {
		margin: 0;
		padding: 8px 12px;
		border-bottom: 1px solid #f0f0f0;
	}
}
</style>
