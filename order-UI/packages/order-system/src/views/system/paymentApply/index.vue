<template>
	<div class="app-container">
		<!-- 搜索模块 -->
		<el-form id="top-search-form-item" v-show="showSearch" v-fixed="{ position: 'top', zIndex: 1001, offset: 0 }" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="日期" prop="fundsDate">
				<el-input v-model="queryParams.fundsDate" placeholder="请输入日期" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方户名" prop="otherAcountsName">
				<el-input v-model="queryParams.otherAcountsName" placeholder="请输入对方户名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方账号" prop="otherBankNo">
				<el-input v-model="queryParams.otherBankNo" placeholder="请输入对方账号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方开户行" prop="otherBankName">
				<el-input v-model="queryParams.otherBankName" placeholder="请输入对方开户行" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方公司" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入对方公司" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<!-- 右侧工具栏 -->
		<div class="toolbar-wrapper">
			<right-toolbar :show-search.sync="showSearch" :columns="columns" @queryTable="getList">
				<!-- 左侧操作按钮 -->
				<template #left>
					<div class="toolbar-left">
						<el-row :gutter="10" class="mb8">
							<el-col :span="1.5">
								<el-button v-hasPermi="['system:paymentapply:add']" type="danger" size="mini" @click="handleAdd">新增付款信息</el-button>
							</el-col>
							<el-col :span="1.5">
								<el-button v-hasPermi="['system:paymentapply:remove']" type="danger" size="mini" :disabled="multiple" @click="handleDelete">删除</el-button>
							</el-col>
						</el-row>
					</div>
				</template>

				<!-- 打印按钮 -->
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" :disabled="paymentApplyList.length === 0" />
					</el-col>
				</template>

				<!-- 导出按钮 -->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:paymentapply:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" :disabled="paymentApplyList.length === 0">导出付款申请</el-button>
					</el-col>
				</template>
			</right-toolbar>
		</div>

		<!-- 付款申请表格 -->
		<div class="table-container" v-loading="loading">
			<!-- 渲染进度提示 -->
			<div v-if="isRendering" class="rendering-progress">
				<el-progress :percentage="renderProgress" :status="renderProgress === 100 ? 'success' : null" :stroke-width="6"></el-progress>
				<span class="progress-text">正在渲染数据: {{ renderedData.length }} / {{ paginatedData.length }}</span>
			</div>

			<div class="table-wrapper" id="printBox">
				<table class="native-table">
					<thead>
						<tr>
							<!-- 日期 -->
							<th v-if="columns[0] && columns[0].visible" class="fixed-left col-date" :style="{ width: columnWidths.date }">日期</th>
							<!-- 支付类型 -->
							<th v-if="columns[1] && columns[1].visible" class="fixed-left col-payType" :style="{ width: columnWidths.payType }">支付类型</th>
							<!-- 金额 -->
							<th v-if="columns[2] && columns[2].visible" :style="{ width: columnWidths.moneyAmount }">金额</th>
							<!-- 对方户名 -->
							<th v-if="columns[3] && columns[3].visible" :style="{ width: columnWidths.otherAcountsName }">对方户名</th>
							<!-- 对方账号 -->
							<th v-if="columns[4] && columns[4].visible" :style="{ width: columnWidths.otherBankNo }">对方账号</th>
							<!-- 对方开户行 -->
							<th v-if="columns[5] && columns[5].visible" :style="{ width: columnWidths.otherBankName }">对方开户行</th>
							<!-- 对方公司 -->
							<th v-if="columns[6] && columns[6].visible" :style="{ width: columnWidths.companyName }">对方公司</th>
							<!-- 对方公司类型 -->
							<th v-if="columns[7] && columns[7].visible" :style="{ width: columnWidths.companyType }">对方公司类型</th>
							<!-- 付款原因 -->
							<th v-if="columns[8] && columns[8].visible" :style="{ width: columnWidths.reason }">付款原因</th>
							<!-- 附件 -->
							<th v-if="columns[9] && columns[9].visible" :style="{ width: columnWidths.attachment }">附件</th>
							<!-- 申请人 -->
							<th v-if="columns[10] && columns[10].visible" :style="{ width: columnWidths.applyPerson }">申请人</th>
							<!-- 审核状态 -->
							<th v-if="columns[11] && columns[11].visible" :style="{ width: columnWidths.checkState }">审核状态</th>
							<!-- 备注 -->
							<th v-if="columns[12] && columns[12].visible" :style="{ width: columnWidths.comments }">备注</th>
							<!-- 右侧操作栏 -->
							<th class="fixed-right col-action" :style="{ width: columnWidths.action }">操作</th>
						</tr>
					</thead>
					<tbody>
						<tr v-for="(row, index) in renderedData" :key="row.id" :style="getRowStyle(row)" :class="{ 'stripe-row': index % 2 === 1 }">
							<!-- 日期 -->
							<td v-if="columns[0] && columns[0].visible" class="fixed-left col-date">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ row.fundsDate || '-' }}</div>
									<span>{{ row.fundsDate || '-' }}</span>
								</el-tooltip>
							</td>
							<!-- 支付类型 -->
							<td v-if="columns[1] && columns[1].visible" class="fixed-left col-payType">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ row.payType || '-' }}</div>
									<span>{{ row.payType || '-' }}</span>
								</el-tooltip>
							</td>
							<!-- 金额 -->
							<td v-if="columns[2] && columns[2].visible">{{ row.moneyAmount || '-' }}</td>
							<!-- 对方户名 -->
							<td v-if="columns[3] && columns[3].visible">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ row.otherAcountsName || '-' }}</div>
									<span>{{ row.otherAcountsName || '-' }}</span>
								</el-tooltip>
							</td>
							<!-- 对方账号 -->
							<td v-if="columns[4] && columns[4].visible">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ row.otherBankNo || '-' }}</div>
									<span>{{ row.otherBankNo || '-' }}</span>
								</el-tooltip>
							</td>
							<!-- 对方开户行 -->
							<td v-if="columns[5] && columns[5].visible">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ row.otherBankName || '-' }}</div>
									<span>{{ row.otherBankName || '-' }}</span>
								</el-tooltip>
							</td>
							<!-- 对方公司 -->
							<td v-if="columns[6] && columns[6].visible">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ row.companyName || '-' }}</div>
									<span>{{ row.companyName || '-' }}</span>
								</el-tooltip>
							</td>
							<!-- 对方公司类型 -->
							<td v-if="columns[7] && columns[7].visible">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ row.companyType || '-' }}</div>
									<span>{{ row.companyType || '-' }}</span>
								</el-tooltip>
							</td>
							<!-- 付款原因 -->
							<td v-if="columns[8] && columns[8].visible" class="text-ellipsis">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ row.reason || '-' }}</div>
									<span>{{ row.reason || '-' }}</span>
								</el-tooltip>
							</td>
							<!-- 附件 -->
							<td v-if="columns[9] && columns[9].visible">
								<div v-if="Array.isArray(row.attachmentList)">
									<el-tooltip effect="light" placement="top" enterable :open-delay="1000" :hide-after="0" popper-class="interactive-tooltip">
										<div slot="content" @click.stop>
											<CheckFiles
												:attachmentList="row.attachmentList"
												@needToUpdate="value => handleUpdateFilePath(value, row, getPaymentApply, updatePaymentApply)"
												:is-upload="false"
												flag="attachments"
											/>
										</div>
										<CheckFiles
											:attachmentList="row.attachmentList"
											@needToUpdate="value => handleUpdateFilePath(value, row, getPaymentApply, updatePaymentApply)"
											:is-upload="false"
											flag="attachments"
										/>
									</el-tooltip>
								</div>
								<div v-else>
									<el-tag type="danger">加载错误</el-tag>
								</div>
							</td>
							<!-- 申请人 -->
							<td v-if="columns[10] && columns[10].visible">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ row.applyPerson || '-' }}</div>
									<span>{{ row.applyPerson || '-' }}</span>
								</el-tooltip>
							</td>
							<!-- 审核状态 -->
							<td v-if="columns[11] && columns[11].visible">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ row.checkState || '-' }}</div>
									<el-tag :type="row.checkState === '通过' ? 'success' : row.checkState === '驳回' ? 'danger' : 'info'" disable-transitions>
										{{ row.checkState || '-' }}
									</el-tag>
								</el-tooltip>
							</td>
							<!-- 备注 -->
							<td v-if="columns[12] && columns[12].visible" class="text-ellipsis">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ row.comments || '-' }}</div>
									<span>{{ row.comments || '-' }}</span>
								</el-tooltip>
							</td>
							<!-- 右侧操作栏 -->
							<td class="fixed-right col-action">
								<el-button v-hasPermi="['system:paymentapply:edit']" size="mini" type="primary" @click="handleUpdate(row)">修改</el-button>
								<el-button v-hasPermi="['system:paymentapply:remove']" size="mini" type="danger" :disabled="!['待提交', '驳回'].includes(row.checkState)" @click="handleDelete(row)">
									删除
								</el-button>
								<el-button v-hasPermi="['system:paymentapply:remove']" size="mini" @click="checkPaymentApplyInfo(row)">查看信息</el-button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

		<!-- 分页组件 -->
		<div class="pagination-wrapper">
			<pagination
				:total="total"
				:page.sync="queryParams.pageNum"
				:limit.sync="queryParams.pageSize"
				:page-sizes="[10, 20, 50, 100, 200, 500]"
				layout="total, sizes, prev, pager, next, jumper"
				background
				@pagination="getList"
			/>
		</div>

		<!-- 2.添加或修改付款信息对话框 -->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="付款申请"
			:visible.sync="open"
			width="500px"
			append-to-body
		>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="日期" prop="fundsDate">
					<el-date-picker v-model="form.fundsDate" type="datetime" placeholder="选择日期"></el-date-picker>
				</el-form-item>
				<el-form-item label="支付类型" prop="payType">
					<el-row :gutter="5">
						<el-col :span="8">
							<el-select v-model="currentSort.levelOne" placeholder="请选择一级分类" @change="handleSelectOneLevel">
								<el-option v-for="item in OneLevelOption" :key="item.id" :label="item.title" :value="item.title"></el-option>
							</el-select>
						</el-col>
						<el-col :span="8">
							<el-select v-model="currentSort.levelTwo" placeholder="请选择二级分类" @change="handleSelectTwoLevel">
								<el-option v-for="item in TwoLevelOption" :key="item.id" :label="item.title" :value="item.title"></el-option>
							</el-select>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="金额" prop="moneyAmount">
					<el-input v-model="form.moneyAmount" placeholder="请输入金额" />
				</el-form-item>

				<!--        对方信息-->
				<el-form-item label="对方户名" prop="otherAcountsName">
					<el-row>
						<el-col :span="10">
							<el-input v-model="form.otherAcountsName" placeholder="请输入对方户名" />
						</el-col>
						<el-col :span="3">
							<SearchOption :get-data="listCompany" icon="el-icon-search" @commitBack="handleCommitBack">
								<template #table-columns>
									<el-table-column label="公司名称" align="center" prop="companyName" />
									<el-table-column label="公司类型" align="center" prop="companyType" />
									<el-table-column label="开户行" align="center" prop="bankName" />
									<el-table-column label="开户名" align="center" prop="acountsName" />
									<el-table-column label="账号" align="center" prop="bankNo" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="对方账号" prop="otherBankNo">
					<el-input v-model="form.otherBankNo" placeholder="请输入对方账号" />
				</el-form-item>
				<el-form-item label="对方开户行" prop="otherBankName">
					<el-input v-model="form.otherBankName" placeholder="请输入对方开户行" />
				</el-form-item>
				<el-form-item label="对方公司" prop="companyName">
					<el-input v-model="form.companyName" placeholder="请输入对方公司" />
				</el-form-item>
				<el-form-item label="付款原因" prop="reason">
					<el-input v-model="form.reason" type="textarea" placeholder="请输入内容" />
				</el-form-item>
				<el-form-item label="附件" prop="attachmentList">
					<UploadFilesButton flag="attachmentList" :initial-attachments="(form.params && form.params.attachments) || []" @files-updated="handleAttachmentFilesUpdated" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    查看-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="查看信息" :visible.sync="checkVisible" width="30%">
			<NeedToShowInfo :need-to-show-info="needToShowInfo" :table-name-to-prop="tableName" />
			<span slot="footer" class="dialog-footer">
				<el-button @click="checkVisible = false">取 消</el-button>
				<el-button type="primary" @click="checkVisible = false">确 定</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import { listPaymentApply, getPaymentApply, delPaymentApply, addPaymentApply, updatePaymentApply } from '@/api/system/paymentApply';
import { excludeParams } from '@/api/tool/exclude';
import { listSubject } from '@/api/system/subject';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import NeedToShowInfo from '@/components/NeedToShowInfo.vue';
import { TableName } from '@/api/tool/enums';
import { getOrderFreight } from '@/api/system/orderFreight';
import { getBorrowedMoney } from '@/api/system/borrowedMoney';
import { findFileExtension } from '@/utils/trash/utils';
import CheckFiles from '@/components/CheckFiles.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import { mixin_checkfile } from '@/views/dashboard/mixins/checkfiles/mixin_checkfile';

export default {
	name: 'PaymentApply',
	components: { CheckFiles, UploadFilesButton, NeedToShowInfo, SearchOption },
	mixins: [mixin_checkfile],
	data() {
		return {
			// 遮罩层
			loading: true,
			defaultCompanyType: '供应商', // 添加默认公司类型
			// 选中数组
			ids: [],
			// 非单个禁用
			single: true,
			// 非多个禁用
			multiple: true,
			// 显示搜索条件
			showSearch: true,
			// 总条数
			total: 0,
			// 付款信息表格数据
			paymentApplyList: [],
			// 分片渲染相关
			renderedData: [],
			isRendering: false,
			renderProgress: 0,
			renderChunkSize: 50,
			renderTimer: null,
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				tableName: null,
				tID: null,
				fundsDate: null,
				payType: null,
				moneyAmount: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				reason: null,
				attachmentList: [],
				applyPerson: null,
				applyPersonID: null,
				checkState: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null,
				submitflag: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {},
			columns: [
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `支付类型`, visible: true },
				{ key: 2, label: `金额`, visible: true },
				{ key: 3, label: `对方户名`, visible: true },
				{ key: 4, label: `对方账号`, visible: true },
				{ key: 5, label: `对方开户行`, visible: true },
				{ key: 6, label: `对方公司`, visible: true },
				{ key: 7, label: `对方公司类型`, visible: true },
				{ key: 8, label: `付款原因`, visible: true },
				{ key: 9, label: `附件`, visible: true },
				{ key: 10, label: `申请人`, visible: true },
				{ key: 11, label: `审核状态`, visible: true },
				{ key: 12, label: `备注`, visible: true }
			],
			// 列宽度配置
			columnWidths: {
				date: '120px',
				payType: '150px',
				moneyAmount: '120px',
				otherAcountsName: '120px',
				otherBankNo: '150px',
				otherBankName: '150px',
				companyName: '150px',
				companyType: '120px',
				reason: '200px',
				attachment: '150px',
				applyPerson: '100px',
				checkState: '120px',
				comments: '200px',
				action: '280px'
			},
			// 付款分类信息
			subjectTree: [],
			// 分类信息
			currentSort: {
				levelOne: '',
				levelTwo: ''
			},
			// 一级分类列表
			OneLevelOption: [],
			// 二级分类
			TwoLevelOption: [],

			checkVisible: false,
			needToShowInfo: {},
			tableName: ''
		};
	},
	computed: {
		TableName() {
			return TableName;
		},
		fullLevel() {
			return this.currentSort.levelOne + '-' + this.currentSort.levelTwo;
		},
		// 分页后的数据（API已分页，直接使用返回的数据）
		paginatedData() {
			return this.paymentApplyList || [];
		}
	},
	// 展示与隐藏
	// 在现有的 watch 对象中添加新的监听器
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('paymentapply-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		// 监听公司ID变化，当选择了客户时自动切换为供应商类型
		'form.companyId'(newVal) {
			// 只有在当前是客户类型且选择了公司时才自动切换
			if (this.form.companyType === '客户' && newVal) {
				this.form.companyType = '供应商';
			}
		},
		// 监听分页数据变化，触发分片渲染
		paginatedData: {
			handler(newData) {
				if (newData && newData.length > 0) {
					this.renderDataInChunks(newData);
				} else {
					this.renderedData = [];
					this.isRendering = false;
					this.renderProgress = 0;
				}
			},
			immediate: true
		}
	},

	created() {
		this.getList();
		// 获取本地显示隐藏列的存储，以便于下一次用户打开的时候读取喜好
		const savedColumns = localStorage.getItem('paymentapply-columns');
		if (savedColumns && savedColumns !== 'null') {
			try {
				const parsedColumns = JSON.parse(savedColumns);
				// 确保 columns 数组完整且每个元素都有 visible 属性
				if (Array.isArray(parsedColumns) && parsedColumns.length >= 13) {
					// 确保所有必需的列都存在
					this.columns = parsedColumns.map((col, index) => {
						if (!col || typeof col.visible === 'undefined') {
							// 如果列配置缺失，使用默认配置
							const defaultColumns = [
								{ key: 0, label: `日期`, visible: true },
								{ key: 1, label: `支付类型`, visible: true },
								{ key: 2, label: `金额`, visible: true },
								{ key: 3, label: `对方户名`, visible: true },
								{ key: 4, label: `对方账号`, visible: true },
								{ key: 5, label: `对方开户行`, visible: true },
								{ key: 6, label: `对方公司`, visible: true },
								{ key: 7, label: `对方公司类型`, visible: true },
								{ key: 8, label: `付款原因`, visible: true },
								{ key: 9, label: `附件`, visible: true },
								{ key: 10, label: `申请人`, visible: true },
								{ key: 11, label: `审核状态`, visible: true },
								{ key: 12, label: `备注`, visible: true }
							];
							return defaultColumns[index] || col;
						}
						return col;
					});
				} else {
					// 如果解析的列配置不完整，使用默认配置
					localStorage.setItem('paymentapply-columns', JSON.stringify(this.columns));
				}
			} catch (error) {
				console.error('解析列配置失败:', error);
				localStorage.setItem('paymentapply-columns', JSON.stringify(this.columns));
			}
		} else {
			localStorage.setItem('paymentapply-columns', JSON.stringify(this.columns));
		}
		listSubject({}, true).then(res => {
			this.subjectTree = this.handleTree(res.data, 'id', 'parentId');
			this.OneLevelOption = this.subjectTree;
		});
	},
	beforeDestroy() {
		// 清理渲染定时器
		if (this.renderTimer) {
			cancelAnimationFrame(this.renderTimer);
			this.renderTimer = null;
		}
	},
	methods: {
		updatePaymentApply,
		getPaymentApply,
		listCompany,
		// 统一行样式
		getRowStyle(row) {
			return { height: '28px', lineHeight: '28px' };
		},
		// 分片渲染数据
		renderDataInChunks(data) {
			// 如果正在渲染，先取消
			if (this.renderTimer) {
				cancelAnimationFrame(this.renderTimer);
				this.renderTimer = null;
			}

			const total = data.length;

			// 如果数据量很小，直接一次性渲染
			if (total <= this.renderChunkSize) {
				this.renderedData = [...data];
				this.isRendering = false;
				this.renderProgress = 0;
				return;
			}

			// 重置状态
			this.renderedData = [];
			this.isRendering = true;
			this.renderProgress = 0;

			let currentIndex = 0;

			const renderChunk = () => {
				// 计算本次要渲染的数据范围
				const endIndex = Math.min(currentIndex + this.renderChunkSize, total);
				const chunk = data.slice(currentIndex, endIndex);

				// 添加到已渲染数据
				this.renderedData = [...this.renderedData, ...chunk];

				// 更新进度
				currentIndex = endIndex;
				this.renderProgress = Math.round((currentIndex / total) * 100);

				// 如果还有数据未渲染，继续下一批
				if (currentIndex < total) {
					this.renderTimer = requestAnimationFrame(renderChunk);
				} else {
					// 渲染完成
					this.isRendering = false;
					this.renderProgress = 100;
					this.renderTimer = null;

					// 延迟隐藏进度条，让用户看到完成状态
					setTimeout(() => {
						this.renderProgress = 0;
					}, 500);
				}
			};

			// 开始渲染
			this.renderTimer = requestAnimationFrame(renderChunk);
		},
		// 附件
		isPic(url) {
			console.log(url);
			return this.$imgs.includes(findFileExtension(url));
		},
		// 点击一级分类后的回调
		handleSelectOneLevel(value) {
			this.currentSort.levelOne = value;
			for (var i = 0; i < this.OneLevelOption.length; i++) {
				// 每个一级分类
				var oneSubject = this.OneLevelOption[i];
				// 判断：所有一级分类id和点击一级分类id是否一样
				if (value === oneSubject.title) {
					// ===即比较值 还要比较类型
					// 从一级分类中获取所有的二级分类
					this.TwoLevelOption = oneSubject.children;
					// 把二级分类Id值清空
					this.currentSort.levelTwo = '';
				}
			}
		},
		// 点击二级
		handleSelectTwoLevel(value) {
			this.currentSort.levelTwo = value;
		},

		// 对方信息 - 点击确认后自动填充
		handleCommitBack(val) {
			this.form.otherBankNo = val.bankNo;
			this.form.otherBankName = val.bankName;
			this.form.companyName = val.companyName;
			this.form.companyId = val.id;
			this.form.otherAcountsName = val.acountsName;
			this.form.companyType = val.companyType;
		},
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
		},
		checkPaymentApplyInfo(row) {
			console.log(row);
			// 根据TableId发请求
			switch (row.tableName) {
				// 订单运费
				case TableName.ORDER_FREIGHT: {
					// 发请求 获取订单运费信息
					getOrderFreight(row.tID).then(res => {
						console.log('运费信息', res);
						this.needToShowInfo = res.data;
						this.tableName = TableName.ORDER_FREIGHT;
					});
					break;
				}
				case TableName.BORROWED_MONEY:
					getBorrowedMoney(row.tID).then(res => {
						console.log('借款信息', res);
						this.needToShowInfo = res.data;
						this.tableName = TableName.BORROWED_MONEY;
					});
					break;

				// todo 这里继续加表名 然后发请求获取数据 赋值给需要展示的needToShowInfo 然后创建组件
				case 'paymentApplyDetailItem':
					// this.needToShowInfo = item.paymentApplyDetailItem;
					break;
				default:
					break;
			}
			// 查询信息
			this.checkVisible = true;
		},
		/** 查询付款信息列表 */
		getList() {
			this.loading = true;
			listPaymentApply(this.queryParams)
				.then(response => {
					this.paymentApplyList = response.rows || [];
					this.total = Number(response.total) || 0;
				})
				.catch(error => {
					console.error('查询付款信息列表失败:', error);
					this.$message.error('查询失败，请重试');
					this.paymentApplyList = [];
					this.total = 0;
				})
				.finally(() => {
					this.loading = false;
				});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				tableName: null,
				tID: null,
				fundsDate: null,
				payType: null,
				moneyAmount: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: this.defaultCompanyType, // 设置默认公司类型为客户				reason: null,
				attachmentList: [],
				applyPerson: null,
				applyPersonID: null,
				checkState: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				submitflag: null,
				params: {
					attachmentIds: []
				}
			};
			this.resetForm('form');
		},
		// 附件更新处理
		handleAttachmentFilesUpdated(files) {
			if (this.form && this.form.params) {
				this.form.params.attachmentIds = files.map(file => file.id);
			}
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加付款信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getPaymentApply(id).then(response => {
				this.form = response.data;
				// 确保 params 对象存在
				if (!this.form.params) {
					this.form.params = {};
				}
				// 确保 attachmentIds 是数组
				if (!Array.isArray(this.form.params.attachmentIds)) {
					this.form.params.attachmentIds = [];
				}
				// 处理附件列表
				if (this.form.attachmentList && Array.isArray(this.form.attachmentList)) {
					this.form.params.attachments = this.form.attachmentList;
					this.form.params.attachmentIds = this.form.attachmentList.map(item => item.id);
				} else {
					this.form.params.attachments = [];
				}
				this.open = true;
				this.title = '修改付款信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 保存当前附件ID用于错误回滚
					const originalAttachmentIds = this.$store.getters.attachmentIds ? [...this.$store.getters.attachmentIds] : [];

					// 去重附件ID
					const uniqueAttachmentIds = [...new Set(originalAttachmentIds)];
					if (uniqueAttachmentIds.length !== originalAttachmentIds.length) {
						// 清空并重新添加去重后的ID
						this.$store.commit('CLEAR_ATTACHMENT_IDS');
						uniqueAttachmentIds.forEach(id => {
							this.$store.commit('ADD_ATTACHMENT_ID', id);
						});
					}

					if (this.form.id != null) {
						// 排除不必要字段
						excludeParams(this, this.$exclude);
						updatePaymentApply(this.form)
							.then(response => {
								this.$modal.msgSuccess('修改成功');
								this.open = false;
								this.getList();
							})
							.catch(error => {
								console.error('修改付款申请失败:', error);
								// 回滚附件ID到原始状态
								this.$store.commit('CLEAR_ATTACHMENT_IDS');
								originalAttachmentIds.forEach(id => {
									this.$store.commit('ADD_ATTACHMENT_ID', id);
								});
								this.$message.error('修改失败，请重试');
							});
					} else {
						excludeParams(this, this.$exclude);
						this.form.payType = this.fullLevel;
						addPaymentApply(this.form)
							.then(response => {
								this.$modal.msgSuccess('新增成功');
								this.open = false;
								this.getList();
							})
							.catch(error => {
								console.error('新增付款申请失败:', error);
								// 回滚附件ID到原始状态
								this.$store.commit('CLEAR_ATTACHMENT_IDS');
								originalAttachmentIds.forEach(id => {
									this.$store.commit('ADD_ATTACHMENT_ID', id);
								});
								this.$message.error('新增失败，请重试');
							});
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row?.id || this.ids;
			if (!ids || (Array.isArray(ids) && ids.length === 0)) {
				this.$message.warning('请选择要删除的数据');
				return;
			}
			this.$modal
				.confirm(`是否确认删除付款信息编号为"${Array.isArray(ids) ? ids.join(',') : ids}"的数据项？`)
				.then(() => {
					return delPaymentApply(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {
					this.$message.info('已取消删除');
				});
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/paymentApply/export',
				{
					...this.queryParams
				},
				`paymentApply_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>

<style scoped lang="scss">
.app-container {
	position: relative;
	overflow: visible;
	min-height: 100vh;
}

/* 固定搜索表单（如果显示） */
#top-search-form-item {
	position: sticky;
	top: 0;
	z-index: 102;
	background-color: #fff;
	padding: 10px 0;
	margin-bottom: 10px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.toolbar-wrapper {
	margin-bottom: 15px;

	.toolbar-left {
		padding: 10px 0;
	}
}

.text-ellipsis {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	max-width: 200px;
}

// 表格容器样式
.table-container {
	position: relative;

	.rendering-progress {
		position: absolute;
		top: 0;
		left: 0;
		right: 0;
		z-index: 1000;
		background: rgba(255, 255, 255, 0.95);
		padding: 10px 20px;
		border-bottom: 1px solid #ebeef5;
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

		.progress-text {
			display: block;
			margin-top: 8px;
			text-align: center;
			font-size: 12px;
			color: #606266;
		}
	}

	.table-wrapper {
		position: relative;
		width: 100%;
		max-height: 750px;
		overflow-x: auto;
		overflow-y: auto;
		border: 1px solid #ebeef5;
		border-radius: 4px;
		background: #fff;

		.native-table {
			width: 100%;
			min-width: max-content;
			table-layout: auto;
			border-collapse: collapse;
			font-size: 12px;
			color: #606266;
			background: #fff;

			thead {
				background: #f5f7fa;
				position: sticky;
				top: 0;
				z-index: 10;

				th {
					padding: 8px 10px;
					text-align: center;
					font-weight: 500;
					color: #909399;
					border: 1px solid #ebeef5;
					border-top: none;
					background: #f5f7fa;
					white-space: nowrap;
					position: relative;

					&.fixed-left {
						position: sticky;
						z-index: 11;
						background: #f5f7fa;
						box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);

						&.col-date {
							left: 0;
						}

						&.col-payType {
							left: 120px;
						}
					}

					&.fixed-right {
						position: sticky;
						right: 0;
						z-index: 11;
						background: #f5f7fa;
						box-shadow: -2px 0 4px rgba(0, 0, 0, 0.1);
					}
				}
			}

			tbody {
				tr {
					transition: background-color 0.25s ease;

					&:hover {
						background: #f5f7fa;
					}

					&.stripe-row {
						background: #fafafa;
					}

					&.stripe-row:hover {
						background: #f5f7fa;
					}

					td {
						padding: 8px 10px;
						border: 1px solid #ebeef5;
						border-top: none;
						white-space: nowrap;
						text-align: center;
						position: relative;

						&.fixed-left {
							position: sticky;
							z-index: 9;
							background: inherit;
							box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);

							&.col-date {
								left: 0;
							}

							&.col-payType {
								left: 120px;
							}
						}

						&.fixed-right {
							position: sticky;
							right: 0;
							z-index: 9;
							background: inherit;
							box-shadow: -2px 0 4px rgba(0, 0, 0, 0.1);
						}
					}
				}
			}

			// 启用硬件加速
			transform: translateZ(0);
			-webkit-transform: translateZ(0);
		}
	}
}

.pagination-wrapper {
	position: relative;
	margin-top: 20px; /* 调整与表格的间距 */
	padding: 10px 20px;
	background-color: #fff;
	border-top: 1px solid #ebeef5;
	text-align: right;
	min-height: 40px; /* 确保有足够的高度 */
}

.pagination-wrapper ::v-deep .pagination-container {
	margin: 0;
	padding: 0;
}

.pagination-wrapper ::v-deep .el-pagination {
	display: inline-flex;
	align-items: center;
	justify-content: flex-end;
}

// 响应式优化
@media screen and (max-width: 768px) {
	.table-wrapper {
		max-height: 500px;
	}

	.column-hidden-mobile {
		display: none;
	}
}
</style>
