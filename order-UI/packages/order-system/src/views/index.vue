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
				<el-button type="info" icon="el-icon-question" size="mini" @click="handleLearn">查看教程</el-button>
        <el-button id="step1" icon="el-icon-download" size="mini" type="warning" @click="handleBackgroundDownload">
          预先导出
        </el-button>
				<el-button id="step2" type="primary" icon="el-icon-download" size="mini" @click="handleDownload">一键下载</el-button>
				<!-- 修改这里，添加 el-popover -->
				<el-popover placement="top" width="900" trigger="hover" popper-class="preview-popover">
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
          <el-button id="step3" slot="reference" icon="el-icon-folder" size="mini" type="success" @click="showFileList">
            下载列表
          </el-button>
				</el-popover>
			</div>
		</div>

		<!-- 添加文件列表弹窗 -->
		<a-modal title="可下载文件列表" :visible="fileListVisible" @cancel="fileListVisible = false" :footer="null" :width="1000" :destroyOnClose="true" class="file-list-modal">
			<div class="file-search-wrapper">
				<div class="search-tip">
					<a-alert type="warning" show-icon>
						<div slot="message">如果搜索的时间范围过大，可能会有卡顿，视机器配置决定</div>
					</a-alert>
				</div>
				<div class="search-form">
					<a-form layout="inline">
						<a-form-item label="开始时间">
							<el-date-picker v-model="fileSearchForm.startTime" type="datetime" size="small" value-format="yyyy-MM-dd HH:mm:ss" placeholder="开始时间"></el-date-picker>
						</a-form-item>
						<a-form-item label="结束时间">
							<el-date-picker v-model="fileSearchForm.endTime" type="datetime" size="small" value-format="yyyy-MM-dd HH:mm:ss" placeholder="结束时间"></el-date-picker>
						</a-form-item>
						<a-form-item>
							<a-button type="primary" :loading="fileListLoading" @click="handleFileSearch">搜索</a-button>
						</a-form-item>
					</a-form>
				</div>
			</div>
			<div class="file-list-header">
				<span class="title">共 {{ fileList.length }} 个文件</span>
			</div>
			<a-list :data-source="fileList" class="file-list" :loading="fileListLoading" style="max-height: 450px; overflow-y: scroll">
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
		<!-- 添加漫游组件 -->
		<v-tour name="downloadListTour" :steps="tourSteps" :options="tourOptions" :callbacks="tourCallBacks"></v-tour>
	</div>
</template>

<script>
import {getDailyProfit, getDeliveryList} from '../api/system/statement';
import {mixin_printHTML} from './dashboard/mixins/print';
import {parseTime} from '@/utils/ruoyi';
import {mapGetters} from 'vuex';
import {deleteExport, downloadFileByName, getAllExportList, startExportAll} from '../api/system/oncedownload/index';

export default {
	name: 'Index',
	mixins: [mixin_printHTML], // 添加漫游混入
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

		// 获取今天和一周前的日期
		const today = new Date();
		const weekAgo = new Date();
		weekAgo.setDate(weekAgo.getDate() - 7);

		// 格式化日期函数
		function formatDateTime(date) {
			const y = date.getFullYear();
			const m = String(date.getMonth() + 1).padStart(2, '0');
			const d = String(date.getDate()).padStart(2, '0');
			return `${y}-${m}-${d} 00:00:00`;
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
			fileListLoading: false, // 添加文件列表加载状态
			fileList: [], // 修改为空数组，由接口获取
			fileListQuery: {
				pageNum: 1,
				pageSize: 10
			},
			fileSearchForm: {
				startTime: formatDateTime(weekAgo),
				endTime: formatDateTime(today)
			},
			tourSteps: [
				{
					target: '#step1',
					header: {
            title: '预先导出'
					},
          content: `点击这个按钮,服务器会立刻开始导出数据并打包成excel,但不会下载到本地,稍后你可以在文件列表中查看到文件并下载,这样可以减少等待时间,推荐使用`
				},
				{
					target: '#step2',
					header: {
						title: '一键下载'
					},
          content: `点击这个按钮,服务器会立刻准备导出数据,并直接写入到当前电脑,稍后,你可以在浏览器的下载列表中查看到文件`
				},
				{
					target: '#step3',
					header: {
						title: '文件列表'
					},
          content: `鼠标悬浮在按钮上可以查看最近的文件列表,点击按钮可以查看所有的文件列表,你可以在这里下载服务器预先导出的文件`
				}
			],
			tourCallBacks: {
				onFinish: () => {
					localStorage.setItem('download-list-tour', 'true');
				}
			},
			tourOptions: {
				labels: {
					buttonSkip: '跳过教程',
					buttonPrevious: '上一步',
					buttonNext: '下一步',
					buttonStop: '完成'
				}
			}
		};
	},
	created() {
		this.getList();
		this.handleProfitSearch();
		this.getFileList();
	},
	mounted() {
		if (!localStorage.getItem('download-list-tour')) {
			this.$tours['downloadListTour'].start();
		}
	},
	computed: {
		...mapGetters(['downloadProgress'])
	},
	methods: {
		// 一键下载
		handleDownload() {
			this.$confirm({
				title: '提示',
				content: '是否导出空表(若不导出空表导出速率会更快)?',
				okText: '是',
				cancelText: '否',
				onOk: () => {
					this.handleOption(true);
				},
				onCancel: () => {
					this.handleOption();
				}
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
		// 添加后台下载方法
		handleBackgroundDownload() {
			this.$prompt('请选择导出日期', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				inputType: 'date'
			}).then(res => {
				this.$confirm({
					title: '提示',
					content: '是否导出空表(若不导出空表导出速率会更快)?',
					okText: '是',
					cancelText: '否',
					onOk: () => {
						this.startBackgroundExport(res.value, true);
					},
					onCancel: () => {
						this.startBackgroundExport(res.value, false);
					}
				});
			});
		},

		async startBackgroundExport(date, exportEmptyData) {
			try {
				const res = await startExportAll({ date, exportEmptyData });
				if (res.code === 200) {
					this.$message.success('后台导出任务已开始，请稍后在文件列表中查看');
					// 3秒后刷新文件列表
					setTimeout(() => {
						this.getFileList();
					}, 3000);
				}
			} catch (error) {
				this.$message.error('启动后台导出失败');
				console.error('启动后台导出失败:', error);
			}
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
		async downloadFile(file) {
			try {
				const res = await downloadFileByName(file.fileName);
				// 处理文件下载响应
				const blob = new Blob([res]);
				const url = window.URL.createObjectURL(blob);
				const link = document.createElement('a');
				link.href = url;
				link.download = file.fileName;
				link.click();
				window.URL.revokeObjectURL(url);
				this.$message.success(`下载成功: ${file.fileName}`);
			} catch (error) {
				console.error('下载文件失败:', error);
				this.$message.error(`下载失败: ${file.fileName}`);
			}
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
		async deleteFile(file) {
			this.$confirm({
				title: '确认删除',
				content: `是否确认删除文件 "${file.fileName}"？`,
				okText: '确认',
				okType: 'danger',
				cancelText: '取消',
				async onOk() {
					try {
						const res = await deleteExport(file.fileName);
						if (res.code === 200) {
							this.$message.success(`删除成功: ${file.fileName}`);
							await this.getFileList(); // 重新加载文件列表
						}
					} catch (error) {
						console.error('删除文件失败:', error);
						this.$message.error(`删除失败: ${file.fileName}`);
					}
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
		},
		async getFileList() {
			this.fileListLoading = true;
			try {
				const res = await getAllExportList(this.fileListQuery);
				if (res.code === 200) {
					this.fileList = res.data;
				}
			} catch (error) {
				console.error('获取文件列表失败:', error);
				this.$message.error('获取文件列表失败');
			} finally {
				this.fileListLoading = false;
			}
		},
		async handleFileSearch() {
			this.fileListLoading = true;
			try {
				const res = await getAllExportList({
					startTime: this.fileSearchForm.startTime,
					endTime: this.fileSearchForm.endTime
				});
				if (res.code === 200) {
					this.fileList = res.data;
				}
			} catch (error) {
				console.error('搜索文件列表失败:', error);
				this.$message.error('搜索文件列表失败');
			} finally {
				this.fileListLoading = false;
			}
		},
		handleLearn() {
			this.$tours['downloadListTour'].start();
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
	> .ant-modal-body {
		height: 500px;
		padding: 0;
	}

	> .ant-modal-content .ant-modal-body {
		display: flex;
		flex-direction: column;
	}

	.file-list-header {
		padding: 12px 24px;
		border-bottom: 1px solid #f0f0f0;
		background: #fff;
		position: sticky;
		top: 0;
		z-index: 1;

		.title {
			font-size: 14px;
			color: rgba(0, 0, 0, 0.85);
		}
	}

	.file-list {
		height: calc(100% - 45px); // 减去header的高度
		overflow-y: auto;
		padding: 0 24px;

		.ant-list-item {
			padding: 12px 0;
			border-bottom: 1px solid #f0f0f0;

			&:last-child {
				border-bottom: none; // 最后一项移除底部边框
			}

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

	.file-search-wrapper {
		padding: 16px 24px 0;

		.search-tip {
			margin-bottom: 16px;
		}

		.search-form {
			margin-bottom: 16px;

			.el-date-editor {
				width: 190px;
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
