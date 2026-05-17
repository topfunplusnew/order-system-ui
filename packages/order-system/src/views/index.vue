<template>
	<div class="page-container">
		<el-row style="margin: 35px 0" :gutter="40">
			<!-- 标记1 -->
			<el-col :span="12">
				<el-row :gutter="10">
					<el-col :span="24">
						<div style="font-weight: bold; font-size: 24px; color: #156fb2; line-height: 60px">今日发货列表</div>
					</el-col>
					<el-form :inline="true" :model="queryParams">
						<el-form-item label="开始时间">
							<el-date-picker v-model="queryParams.startTime" type="datetime" size="mini" value-format="yyyy-MM-dd HH:mm:ss" placeholder="开始日期" class="responsive-date-picker"></el-date-picker>
						</el-form-item>
						<el-form-item label="结束时间">
							<el-date-picker v-model="queryParams.endTime" type="datetime" size="mini" value-format="yyyy-MM-dd HH:mm:ss" placeholder="结束日期" class="responsive-date-picker"></el-date-picker>
						</el-form-item>
						<el-form-item>
							<el-button type="primary" size="mini" @click="handleSearch">搜索</el-button>
						</el-form-item>
					</el-form>
				</el-row>
				<el-row :gutter="50">
					<el-col>
						<right-toolbar :columns="columns" @queryTable="getList" table-name="views-index-columns">
							<template #print>
								<el-col :span="1.5">
									<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
								</el-col>
							</template>
							<!--        导出-->
							<template #export>
								<el-col :span="1.5">
									<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
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
							:summary-method="getSummaries"
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
							<el-table-column label="ID" width="50" align="center" prop="id">
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.id }}</div>
										<span>{{ scope.row.id }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[0].visible" prop="orderSource" label="订单来源" width="90" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.orderSource }}</div>
										<span>{{ scope.row.orderSource }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[1].visible" prop="orderDate" label="日期" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.orderDate }}</div>
										<span>{{ scope.row.orderDate }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[2].visible" prop="companyName" label="客户" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.companyName }}</div>
										<span>{{ scope.row.companyName }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[3].visible" prop="salesman" label="业务员" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.salesman }}</div>
										<span>{{ scope.row.salesman }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[4].visible" prop="arrears" label="欠款" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.arrears }}</div>
										<span>{{ scope.row.arrears }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[5].visible" prop="profit" label="含税利润" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.profit }}</div>
										<span>{{ scope.row.profit }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[6].visible" prop="profitNoTax" label="不含税利润" width="110" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.profitNoTax }}</div>
										<span>{{ scope.row.profitNoTax }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[7].visible" prop="payments" label="总货款" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.payments }}</div>
										<span>{{ scope.row.payments }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[8].visible" prop="paymentFactory" label="出厂货款" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.paymentFactory }}</div>
										<span>{{ scope.row.paymentFactory }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[9].visible" prop="tonnage" label="吨位" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.tonnage }}</div>
										<span>{{ scope.row.tonnage }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[10].visible" prop="clerk" label="内勤" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.clerk }}</div>
										<span>{{ scope.row.clerk }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[11].visible" prop="landCarNo" label="陆运车牌" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.landCarNo !== null ? scope.row.landCarNo : '无' }}</div>
										<span v-if="scope.row.landCarNo !== null">
											{{ scope.row.landCarNo }}
										</span>
										<span v-else>无</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[12].visible" prop="seaCarNo" label="柜号" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.seaCarNo !== null ? scope.row.seaCarNo : '无' }}</div>
										<span v-if="scope.row.seaCarNo !== null">
											{{ scope.row.seaCarNo }}
										</span>
										<span v-else>无</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[13].visible" prop="fleet" label="车队" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.fleet }}</div>
										<span>{{ scope.row.fleet }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[14].visible" prop="freight" label="运费" show-overflow-tooltip>
								<template #default="scope">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
										<div slot="content">{{ scope.row.freight }}</div>
										<span>{{ scope.row.freight }}</span>
									</el-tooltip>
								</template>
							</el-table-column>
						</el-table>
						<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" style="width: 100%; text-align: center" />
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
							<el-date-picker v-model="queryParamsHome.startTime" type="date" size="mini" value-format="yyyy-MM-dd" placeholder="开始日期" class="responsive-date-picker"></el-date-picker>
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
					<el-table :empty-text="' '" :data="[]" :show-header="true" class="header-only-table">
						<el-table-column :label="`￥${moneyAmount}`" align="center">
							<el-table-column prop="dailyProfit" label="利润总额">
								<el-table-column prop="dailyExpense" label="费用合计"></el-table-column>
							</el-table-column>
							<el-table-column :label="`￥${dailyProfit && dailyProfit.dailyProfit ? dailyProfit.dailyProfit : 0}`">
								<el-table-column :label="`￥${dailyExpense || 0}`"></el-table-column>
							</el-table-column>
						</el-table-column>
					</el-table>
				</el-row>
			</el-col>
		</el-row>
		<div class="fixed-footer">
			<div class="progress-container" :class="{ 'hide-progress': downloadProgress <= 0 }">
				<div class="progress-message" v-if="downloadMessage">{{ downloadMessage }}</div>
				<el-progress
					:percentage="downloadProgress"
					:stroke-width="20"
					:status="downloadProgress === 100 ? 'success' : 'warning'"
					class="wave-progress"
					:class="{
						'is-downloading': downloadProgress > 0 && downloadProgress < 100,
						'is-finished': downloadProgress === 100
					}"
				></el-progress>
			</div>
			<div>
				<el-button type="primary" size="mini" icon="el-icon-document" @click="logDialogVisible = true">下载日志</el-button>
				<el-button type="info" icon="el-icon-question" size="mini" @click="handleLearn">查看教程</el-button>
				<el-button id="step1" icon="el-icon-download" size="mini" type="warning" @click="handleBackgroundDownload" v-hasPermi="['system:exportfile:export']">预先导出</el-button>
				<el-button id="step2" type="primary" icon="el-icon-download" size="mini" @click="handleDownload" v-hasPermi="['system:exportfile:export']">一键下载</el-button>
				<el-button id="step3" icon="el-icon-folder" size="mini" type="success" @click="showFileList">下载列表</el-button>
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
							<a-button
								type="danger"
								:loading="clearAllExportLoading"
								:disabled="!fileList.length"
								v-hasPermi="['system:exportfile:remove']"
								style="margin-left: 8px"
								@click="handleClearAllExportFiles"
							>
								一键清空
							</a-button>
						</a-form-item>
					</a-form>
				</div>
			</div>
			<div class="file-list-header">
				<span class="title">共 {{ fileList.length }} 个文件</span>
			</div>
			<a-list :data-source="fileList" class="file-list" :loading="fileListLoading" style="max-height: 450px; overflow-y: scroll">
				<a-list-item v-for="item in fileList" :key="item.id || item.fileName">
					<a-row type="flex" justify="space-between" align="middle" style="width: 100%">
						<a-col :span="12">
							<a-space>
								<a-icon :type="getIconType(item.fileName)" :style="getIconStyle(item.fileName)" />
								<span class="filename">{{ item.fileName }}</span>
							</a-space>
						</a-col>
						<a-col :span="6" class="date">{{ formatDate(item.createTime) }}</a-col>
						<a-col :span="3" class="size">{{ formatSize(item.size) }}</a-col>
						<a-col :span="3" class="actions">
							<a-space>
								<a-button type="link" v-hasPermi="['system:exportfile:download']" @click="downloadFile(item)" style="padding: 4px">
									<a-icon type="download" style="color: #1890ff" />
								</a-button>
								<a-button type="link" v-hasPermi="['system:exportfile:remove']" @click="deleteFile(item)" style="padding: 4px">
									<a-icon type="delete" style="color: #ff4d4f" />
								</a-button>
							</a-space>
						</a-col>
					</a-row>
				</a-list-item>
			</a-list>
		</a-modal>
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="一键下载" :visible.sync="dialogVisible" width="30%" :before-close="handleClose">
			<span>这是一段信息</span>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="dialogVisible = false">确 定</el-button>
			</span>
		</el-dialog>
		<!-- 添加漫游组件 -->
		<v-tour name="downloadListTour" :steps="tourSteps" :options="tourOptions" :callbacks="tourCallBacks"></v-tour>

		<!-- 下载日志弹窗 -->
		<el-dialog title="下载日志(该日志信息为实时日志并非后台下载)" :visible.sync="logDialogVisible" width="600px" :modal="false" class="download-log-dialog" :close-on-click-modal="false">
			<div class="log-scroll-area">
				<ul>
					<li v-for="(msg, idx) in downloadLogList" :key="idx">{{ msg }}</li>
				</ul>
			</div>
			<span slot="footer" class="dialog-footer">
				<el-button @click="logDialogVisible = false">关闭</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import { getDailyProfit, getDeliveryList } from '../api/system/statement';
import { mixin_printHTML } from './dashboard/mixins/print';
import { parseTime } from '@/utils/ruoyi';
import { mapGetters } from 'vuex';
import { batchDeleteExport, deleteExport, downloadFileByName, getAllExportList, startExportAll, syncExportAll } from '../api/system/oncedownload/index';
import { compact, map } from 'lodash';
import webSocketManager from '@/utils/websocket';
import { subtract, add, sum, round, number, log, divide, pow } from 'mathjs';

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

		// WebSocket相关变量移到data中管理，不在初始化时立即连接
		return {
			socket: null,
			stompClient: null,
			isWebSocketConnected: false,
			reconnectTimer: null,
			loading: false,
			queryParams: {
				startTime: formatDate(startTime),
				endTime: formatDate(endTime),
				pageNum: 1,
				pageSize: 20
			},
			queryParamsHome: {
				startTime: parseTime(new Date(), '{y}-{m}-{d}'),
				endTime: parseTime(new Date(), '{y}-{m}-{d}')
			},
			tableData: [],
			total: 0,
			columns: [
				{ key: 0, label: `订单来源`, visible: true },
				{ key: 1, label: `日期`, visible: true },
				{ key: 2, label: `客户`, visible: true },
				{ key: 3, label: `录入员`, visible: true },
				{ key: 4, label: `欠款`, visible: true },
				{ key: 5, label: `含税利润`, visible: true },
				{ key: 6, label: `不含税利润`, visible: true },
				{ key: 7, label: `总货款`, visible: true },
				{ key: 8, label: `出厂货款`, visible: true },
				{ key: 9, label: `吨位`, visible: true },
				{ key: 10, label: `内勤`, visible: true },
				{ key: 11, label: `陆运车牌`, visible: true },
				{ key: 12, label: `柜号`, visible: true },
				{ key: 13, label: `车队`, visible: true },
				{ key: 14, label: `运费`, visible: true }
			],
			dailyProfit: null,
			dailyExpense: null,
			moneyAmount: null,
			dialogVisible: false,
			fileListVisible: false,
			fileListLoading: false, // 添加文件列表加载状态
			clearAllExportLoading: false,
			fileList: [], // 修改为空数组，由接口获取
			fileSearchForm: {
				startTime: formatDateTime(weekAgo),
				endTime: formatDateTime(
					(() => {
						const tomorrow = new Date();
						tomorrow.setDate(tomorrow.getDate() + 1);
						return tomorrow;
					})()
				)
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
			},
			logDialogVisible: false, // 新增日志弹窗可见性
			downloadLogList: [] // 新增：日志数组
		};
	},
	created() {
		this.getList();
		this.handleProfitSearch();
		// this.getFileList();
	},
	mounted() {
		if (!localStorage.getItem('download-list-tour')) {
			this.$tours['downloadListTour'].start();
		}
		// 移除自动初始化WebSocket连接，只在需要时连接
	},
	beforeDestroy() {
		// 页面销毁前清理WebSocket连接（如果存在的话）
		this.disconnectWebSocket();
	},
	watch: {
		// 监听下载进度，当进度为0或100时清除消息
		downloadProgress(val) {
			if (val === 0 || val === 100) {
				// 延迟清除消息，让用户有时间看到100%的状态
				setTimeout(() => {
					this.downloadMessage = '';
				}, 3000);
			}
		},
		downloadMessage(val) {
			console.log('监听数据', val);
			// 新增：追加日志到数组
			if (val) {
				this.downloadLogList.push(val);
			}
			// 自动滚动到底部
			this.$nextTick(() => {
				const logScrollArea = this.$el.querySelector('.log-scroll-area');
				if (logScrollArea) {
					logScrollArea.scrollTop = logScrollArea.scrollHeight;
				}
			});
		},
		logDialogVisible(val) {
			// 打开弹窗时自动滚动到底部
			if (val) {
				this.$nextTick(() => {
					const logScrollArea = this.$el.querySelector('.log-scroll-area');
					if (logScrollArea) {
						logScrollArea.scrollTop = logScrollArea.scrollHeight;
					}
				});
			}
		}
	},
	computed: {
		...mapGetters(['downloadProgress', 'downloadMessage'])
	},
	methods: {
		/**
		 * 一键下载压缩包文件名：xx年x月x日一键下载数据留档.zip
		 * @param {string} dateStr - yyyy-MM-dd
		 * @returns {string}
		 */
		buildOneClickArchiveZipName(dateStr) {
			const parts = (dateStr || '').split('-');
			if (parts.length !== 3) {
				return `一键下载数据留档_${Date.now()}.zip`;
			}
			const y = parts[0];
			const m = parseInt(parts[1], 10);
			const d = parseInt(parts[2], 10);
			return `${y}年${m}月${d}日一键下载数据留档.zip`;
		},
		// 自定义汇总方法，排除柜号列的求和
		getSummaries(param) {
			const { columns, data } = param;
			const sums = [];

			// 需要合计的数字列（根据 prop 属性判断）
			const summaryColumns = ['arrears', 'profit', 'profitNoTax', 'payments', 'paymentFactory', 'tonnage', 'freight'];

			// 排除合计的列（非数字列）
			const excludeColumns = ['id', 'orderSource', 'orderDate', 'companyName', 'salesman', 'clerk', 'landCarNo', 'seaCarNo', 'fleet'];

			// 确保 sums 数组长度与 columns 数组长度一致，先初始化为空字符串
			for (let i = 0; i < columns.length; i++) {
				sums[i] = '';
			}

			// 如果没有数据，直接返回
			if (!data || data.length === 0) {
				sums[0] = '合计';
				return sums;
			}

			columns.forEach((column, index) => {
				// 第一列显示"合计"
				if (index === 0) {
					sums[index] = '合计';
					return;
				}

				// 如果没有 property，跳过
				if (!column.property) {
					sums[index] = '';
					return;
				}

				// 排除柜号列（seaCarNo）和其他非数字列
				if (excludeColumns.includes(column.property)) {
					sums[index] = '';
					return;
				}

				// 只对需要合计的数字列进行计算
				if (summaryColumns.includes(column.property)) {
					const values = data.map(item => {
						const value = item[column.property];
						// 转换为数字，如果转换失败则返回0
						const numValue = number(value);
						return isNaN(numValue) ? 0 : numValue;
					});

					// 计算总和
					if (values.length > 0) {
						const total = sum(values);
						sums[index] = round(total, 2);
					} else {
						sums[index] = '';
					}
				} else {
					sums[index] = '';
				}
			});

			return sums;
		},
		// 一键下载
		handleDownload() {
			this.$antdconfirm({
				title: '提示',
				content: '是否导出空表(若不导出空表导出速率会更快)?',
				okText: '否',
				cancelText: '是',
				onOk: () => {
					this.handleOption();
				},
				onCancel: () => {
					this.handleOption(true);
				}
			});
		},

		// 一键下载
		handleOption(exportEmptyData = false) {
			const now = new Date();
			const yyyy = now.getFullYear();
			const mm = String(now.getMonth() + 1).padStart(2, '0');
			const dd = String(now.getDate()).padStart(2, '0');
			const defaultDate = `${yyyy}-${mm}-${dd}`;
			this.$prompt('请选择导出日期', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				inputType: 'date',
				inputValue: defaultDate
			})
				.then(res => {
					// 添加校验
					const date = res && res.value ? res.value : defaultDate;
					this.downLoadOnce(
						'system/allExport/export',
						{
							date: date,
							exportEmptyData: exportEmptyData
						},
						this.buildOneClickArchiveZipName(date)
					);
				})
				.catch(() => {
					// 用户取消输入时，避免控制台报错
					this.$message.info('已取消导出');
				});
		},
		// 添加后台下载方法
		handleBackgroundDownload() {
			const now = new Date();
			const yyyy = now.getFullYear();
			const mm = String(now.getMonth() + 1).padStart(2, '0');
			const dd = String(now.getDate()).padStart(2, '0');
			const defaultDate = `${yyyy}-${mm}-${dd}`;
			this.$prompt('请选择导出日期', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				inputType: 'date',
				inputValue: defaultDate
			})
				.then(res => {
					// 添加校验
					const exportDate = res && res.value ? res.value : defaultDate;
					this.$antdconfirm({
						title: '提示',
						content: '是否导出空表(若不导出空表导出速率会更快)?',
						okText: '否',
						cancelText: '是',
						onOk: () => {
							this.startBackgroundExport(exportDate, false);
						},
						onCancel: () => {
							this.startBackgroundExport(exportDate, true);
						}
					});
				})
				.catch(() => {
					// 用户取消输入时，避免控制台报错
					this.$message.info('已取消预先导出');
				});
		},

		async startBackgroundExport(date, exportEmptyData) {
			try {
				const res = await syncExportAll(date, exportEmptyData);
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
				const profit = round(number(res.data.dailyProfit) || 0, 2);
				const expense = round(number(res.data.dailyExpense) || 0, 2);
				this.dailyProfit = {
					dailyProfit: profit,
					dailyExpense: expense
				};
				this.dailyExpense = expense;
				this.moneyAmount = round(subtract(profit, expense), 2);
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
				`今日订单列表${new Date().getTime()}.xlsx`
			);
		},
		handleClose() {
			this.dialogVisible = false;
		},
		showFileList() {
			this.fileListVisible = true;
			// 打开弹窗时获取文件列表
			this.getFileList();
		},
		formatSize(bytes) {
			if (bytes === 0) return '0 B';
			const k = number(1024);
			const sizes = ['B', 'KB', 'MB', 'GB'];
			const logValue = divide(log(number(bytes)), log(k));
			const i = Math.floor(logValue);
			const size = divide(number(bytes), pow(k, i));
			return round(size, 2) + ' ' + sizes[i];
		},
		formatDate(date) {
			return date.split(' ')[0];
		},
		async downloadFile(file) {
			try {
				const res = await downloadFileByName(file.fileName);
				// 处理文件下载响应，确保contentType为application/octet-stream
				const blob = new Blob([res], { type: 'application/octet-stream' });
				const url = window.URL.createObjectURL(blob);
				const link = document.createElement('a');
				link.href = url;
				link.download = file.fileName;
				document.body.appendChild(link);
				link.click();
				document.body.removeChild(link);
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
			const self = this;
			this.$antdconfirm({
				title: '确认删除',
				content: `是否确认删除文件 "${file.fileName}"？`,
				okText: '确认',
				okType: 'danger',
				cancelText: '取消',
				async onOk() {
					try {
						const res = await deleteExport(file.fileName);
						if (res.code === 200) {
							self.$message.success(`删除成功: ${file.fileName}`);
							await self.getFileList(); // 重新加载文件列表
						} else {
							self.$message.error(`删除失败: ${file.fileName}`);
						}
					} catch (error) {
						console.error('删除文件失败:', error);
						self.$message.error(`删除失败: ${file.fileName}`);
					}
				}
			});
		},
		/**
		 * 从当前列表提取导出文件 id
		 * @returns {Array<number|string>}
		 */
		collectExportFileIds() {
			return compact(map(this.fileList || [], item => item && item.id));
		},
		/**
		 * 一键清空当前可下载文件列表
		 */
		handleClearAllExportFiles() {
			const ids = this.collectExportFileIds();
			if (!ids.length) {
				this.$message.warning('当前没有可删除的文件');
				return;
			}
			const self = this;
			this.$antdconfirm({
				title: '确认一键清空',
				content: `是否确认删除当前列表中的 ${ids.length} 个文件？此操作不可恢复。`,
				okText: '确认清空',
				okType: 'danger',
				cancelText: '取消',
				async onOk() {
					self.clearAllExportLoading = true;
					try {
						const res = await batchDeleteExport(ids);
						if (res.code === 200) {
							self.$message.success(`已清空 ${ids.length} 个文件`);
							await self.getFileList();
						} else {
							self.$message.error(res.msg || '一键清空失败');
						}
					} catch (error) {
						console.error('一键清空失败:', error);
						self.$message.error('一键清空失败');
					} finally {
						self.clearAllExportLoading = false;
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
				const res = await getAllExportList(this.fileSearchForm);
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
		},

		// 只在需要时初始化WebSocket连接（用于一键下载）
		initWebSocketForDownload() {
			return webSocketManager
				.connect()
				.then(() => {
					console.log('WebSocket连接成功，准备开始下载');
					this.isWebSocketConnected = true;
					return true;
				})
				.catch(error => {
					console.error('WebSocket连接失败:', error);
					this.isWebSocketConnected = false;
					this.$store.dispatch('downloadOnce/setPercent', 0);
					throw error;
				});
		},

		disconnectWebSocket() {
			// 使用WebSocket管理器断开连接
			webSocketManager.disconnect();
			this.isWebSocketConnected = false;
		}
	}
};
</script>

<style scoped lang="scss">
@import './index.vue.style.scss';

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
	border-radius: 10px 10px 0 0;
	position: fixed;
	bottom: 0;
	left: 0;
	width: 100%;
	background: rgba(255, 255, 255, 0.95);
	backdrop-filter: blur(10px);
	border-top: 1px solid rgba(221, 221, 221, 0.5);
	padding: 10px 10px;
	text-align: right;
	z-index: 1000;
	transition: all 0.3s ease;
	box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);

	.el-button {
		margin-left: 10px;
	}

	@media screen and (max-width: 768px) {
		padding: 8px 8px;
		text-align: center;

		.el-button {
			margin: 4px;
			padding: 6px 10px;
			font-size: 12px;
		}
	}

	// 为底部工具栏上方的内容添加边距
	& + * {
		margin-bottom: 50px;
	}
}

// 添加一个占位符来防止内容被footer遮挡
.page-container {
	padding-bottom: 80px;
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

// 进度条样式优化
.progress-container {
	margin-bottom: 12px;
	opacity: 1;
	transition: opacity 0.4s ease, height 0.4s ease, margin 0.4s ease;
	border-radius: 12px;
	padding: 10px;
	background-color: rgba(245, 247, 250, 0.8);
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);

	&.hide-progress {
		opacity: 0;
		height: 0;
		margin: 0;
		overflow: hidden;
	}

	.progress-message {
		margin-bottom: 8px;
		font-size: 14px;
		color: #409eff;
		text-align: center;
		font-weight: 500;
		text-shadow: 0 0 2px rgba(64, 158, 255, 0.1);
		transition: all 0.3s;
	}
}

// 添加进度条波纹动画
.wave-progress {
	position: relative;
	overflow: hidden;
	margin: 0 5px;

	&.is-downloading {
		&::before {
			content: '';
			position: absolute;
			top: 0;
			left: -100%;
			width: 100%;
			height: 100%;
			background: linear-gradient(90deg, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.6) 50%, rgba(255, 255, 255, 0) 100%);
			z-index: 1;
			animation: wave 1.5s infinite cubic-bezier(0.45, 0.05, 0.55, 0.95);
			box-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
		}
	}

	// 添加完成动画
	&.is-finished {
		.el-progress-bar__inner {
			animation: pulse 0.6s ease-out;
		}
	}
}

@keyframes wave {
	0% {
		left: -100%;
	}

	100% {
		left: 150%;
	}
}

@keyframes pulse {
	0% {
		transform: scale(1);
		opacity: 1;
	}

	50% {
		transform: scale(1.02);
		opacity: 0.8;
	}

	100% {
		transform: scale(1);
		opacity: 1;
	}
}

// 让波纹效果更明显
:deep(.el-progress-bar__inner) {
	transition: all 0.3s cubic-bezier(0.34, 1.61, 0.7, 1);
	position: relative;
	overflow: hidden;
	background: linear-gradient(90deg, #409eff, #67c23a);
	box-shadow: 0 0 6px rgba(64, 158, 255, 0.4);

	&.is-success {
		background: linear-gradient(90deg, #67c23a, #87d068);
		box-shadow: 0 0 8px rgba(103, 194, 58, 0.5);
	}

	&.is-warning {
		background: linear-gradient(90deg, #e6a23c, #f5cb23);
	}

	&.is-exception {
		background: linear-gradient(90deg, #f56c6c, #ff9b9b);
	}
}

:deep(.el-progress-bar__outer) {
	border-radius: 10px;
	background-color: #ebeef5;
	box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
	overflow: hidden;
	height: 16px !important;
	/* 设置更高的进度条 */
}

:deep(.el-progress-bar__inner) {
	border-radius: 10px;
}

:deep(.el-progress__text) {
	font-size: 14px !important;
	font-weight: 600;
	color: #606266;
}

/* 利润表格只显示表头样式 */
.header-only-table {
	::v-deep .el-table__body-wrapper {
		display: none;
	}

	::v-deep .el-table__header-wrapper {
		border-bottom: 1px solid #ebeef5;
	}
}

/* 下载日志弹窗样式 */
.download-log-dialog {
	.log-scroll-area {
		background: #111;
		color: #b7e1ff;
		font-family: 'Fira Mono', 'Consolas', 'Menlo', monospace;
		font-size: 13px;
		padding: 12px;
		border-radius: 6px;
		height: 320px;
		overflow-y: auto;
		white-space: pre-wrap;
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);

		ul {
			list-style: none;
			padding: 0;
			margin: 0;
		}

		li {
			white-space: pre-wrap;
			word-break: break-all;
			margin-bottom: 2px;
		}
	}
}

/* 可选：让pre标签自动滚动到底部 */
.download-log-dialog .log-scroll-area pre {
	margin: 0;
	white-space: pre-wrap;
	word-break: break-all;
}
</style>
