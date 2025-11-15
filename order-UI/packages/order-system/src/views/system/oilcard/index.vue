<!-- 加油卡管理，要分开管理 分为加油卡主卡和加油卡副卡-->
<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="加油卡卡号" prop="oilCardNo">
				<el-input v-model="queryParams.oilCardNo" placeholder="请输入加油卡卡号" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'oilCardNo')" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:oilcard:add']" type="primary" size="mini" @click="handleAdd">新增加油卡信息</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="danger" size="mini" @click="handleMoney">加油卡充值</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button type="success" size="mini" @click="handleOption">加油卡操作</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:oilcard:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>
		<el-row>
			<el-tabs v-model="activeName" @tab-click="handleClick">
				<el-tab-pane lazy label="加油卡主卡管理" name="first">
					<el-table id="printBox" v-loading="loading" v-horizontal-scroll="'always'" size="mini" border :data="mainOilCardList" @selection-change="handleSelectionChange">
						<el-table-column v-if="columns[0].visible" label="加油卡卡号" align="center" prop="oilCardNo" show-overflow-tooltip>
							<template #default="scope">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ scope.row.oilCardNo }}</div>
									<span>{{ scope.row.oilCardNo }}</span>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column v-if="columns[1].visible" label="当前金额" align="center" prop="moneyAmount" show-overflow-tooltip>
							<template #default="scope">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ scope.row.moneyAmount }}</div>
									<span>{{ scope.row.moneyAmount }}</span>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column v-if="columns[2].visible" label="备注" align="center" prop="comments" show-overflow-tooltip>
							<template #default="scope">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ scope.row.comments }}</div>
									<span>{{ scope.row.comments }}</span>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
							<template slot-scope="scope">
								<el-button v-hasPermi="['system:oilcard:query']" size="mini" type="text" @click="handleCheck(scope.row)">查看明细</el-button>
								<el-button v-hasPermi="['system:oilcard:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">编辑</el-button>
								<el-button v-hasPermi="['system:oilcard:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
							</template>
						</el-table-column>
					</el-table>
					<pagination v-show="MainTotal > 0" :total="MainTotal" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList()" />
					<br />
				</el-tab-pane>
				<el-tab-pane lazy label="加油卡副卡管理" name="second">
					<el-table id="printBox" v-loading="loading" v-horizontal-scroll="'always'" border size="mini" :data="subCardList" @selection-change="handleSelectionChange">
						<el-table-column v-if="columns[0].visible" label="加油卡卡号" align="center" prop="oilCardNo" show-overflow-tooltip>
							<template #default="scope">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ scope.row.oilCardNo }}</div>
									<span>{{ scope.row.oilCardNo }}</span>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column v-if="columns[1].visible" label="可用金额" align="center" prop="moneyAmount" show-overflow-tooltip>
							<template #default="scope">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ scope.row.moneyAmount }}</div>
									<span>{{ scope.row.moneyAmount }}</span>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column label="待圈存金额" align="center" prop="virtualMoneyAmount" show-overflow-tooltip>
							<template #default="scope">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ scope.row.virtualMoneyAmount }}</div>
									<span>{{ scope.row.virtualMoneyAmount }}</span>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column v-if="columns[2].visible" label="备注" align="center" prop="comments">
							<template #default="scope">
								<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
									<div slot="content">{{ scope.row.comments }}</div>
									<span>{{ scope.row.comments }}</span>
								</el-tooltip>
							</template>
						</el-table-column>
						<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
							<template slot-scope="scope">
								<el-button v-hasPermi="['system:oilcard:query']" size="mini" type="text" @click="handleCheck(scope.row)">查看明细</el-button>
								<el-button v-hasPermi="['system:oilcard:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">编辑</el-button>
								<el-button v-hasPermi="['system:oilcard:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
							</template>
						</el-table-column>
					</el-table>
					<pagination v-show="SubTotal > 0" :total="SubTotal" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
					<br />
				</el-tab-pane>
			</el-tabs>
		</el-row>

		<!-- 添加或修改加油卡信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="200px" @keyup.enter.native="submitForm" size="mini" @submit.native.prevent="submitForm">
				<el-form-item label="加油卡卡号" prop="oilCardNo">
					<el-input v-model="form.oilCardNo" placeholder="请输入加油卡卡号" @input="handleInputTrim($event, 'form', 'oilCardNo')" />
				</el-form-item>
				<el-form-item label="加油卡类别" prop="oilType">
					<el-radio v-model="form.oilType" label="主卡">主卡</el-radio>
					<el-radio v-model="form.oilType" label="副卡">副卡</el-radio>
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入使用备注" @input="handleInputTrim($event, 'form', 'comments')" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    加油卡充值弹窗-->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="加油卡充值"
			:visible.sync="moneyDialogVisible"
			width="500px"
			append-to-body
		>
			<el-form :model="moneyInfo" :rules="moneyRules" label-width="200px" @keyup.enter.native="submitMoney" @submit.native.prevent="submitMoney" ref="moneyFormRef" size="mini">
				<el-form-item label="加油卡卡号" prop="oilCardNo">
					<el-row>
						<el-col :span="10">
							<el-input v-model="moneyInfo.oilCardNo" placeholder="请输入加油卡卡号" @input="handleInputTrim($event, 'moneyInfo', 'oilCardNo')" />
						</el-col>
						<el-col :span="3">
							<SearchOption
								:get-data="listOilCard"
								title="选择加油卡"
								icon="el-icon-search"
								:limit-info="{ oilType: '主卡' }"
								@commitBack="handleCommitBack"
								@update:queryName="handleUpdateQueryName"
								:query-name="queryCard"
								query-info="oilCardNo"
								query-label="加油卡卡号"
							>
								<template #table-columns>
									<el-table-column prop="oilCardNo" label="加油卡卡号" />
									<el-table-column prop="moneyAmount" label="加油卡余额" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="请选择充值方式" prop="rechargeType">
					<el-select v-model="moneyInfo.rechargeType" placeholder="请选择充值方式">
						<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="请输入充值金额" prop="rechargeMoney">
					<el-input v-model="moneyInfo.rechargeMoney" placeholder="请输入充值金额" @input="handleInputTrim($event, 'moneyInfo', 'rechargeMoney')" />
				</el-form-item>
				<el-form-item label="姓名" prop="rechargeName">
					<el-input v-model="moneyInfo.rechargeName" disabled placeholder="请输入姓名" />
				</el-form-item>
				<el-form-item v-if="moneyInfo.rechargeType === '银行卡'" label="银行开户名" prop="acountsName">
					<el-col :span="10">
						<el-input v-model="moneyInfo.acountsName" placeholder="请输入银行开户名" @input="handleInputTrim($event, 'moneyInfo', 'acountsName')" />
					</el-col>
					<el-col :span="4">
						<SearchOption
							:limit-info="{ acountsType: '己方公司' }"
							:get-data="listBankAccount"
							:query-name="queryBankAcount"
							query-label="户名查找"
							query-info="acountsName"
							@commitBack="handleCommitBackBankAcount"
							@update:queryName="handleUpdateQueryBankAcount"
						>
							<template #table-columns>
								<el-table-column label="账户类型" align="center" prop="acountsType" />
								<el-table-column label="己方公司" align="center" prop="displayName" />
								<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
								<el-table-column label="账号(银行账号)" align="center" prop="bankNo" />
								<el-table-column label="开户行" align="center" prop="bankName" />
								<el-table-column label="公司名称" align="center" prop="companyName" />
							</template>
						</SearchOption>
					</el-col>
				</el-form-item>
				<el-form-item v-if="moneyInfo.rechargeType === '银行卡'" label="银行账号" prop="bankNo">
					<el-input v-model="moneyInfo.bankNo" placeholder="请输入银行账号" @input="handleInputTrim($event, 'moneyInfo', 'bankNo')" />
				</el-form-item>
				<el-form-item label="附件" prop="bankName">
					<UploadFilesButton
						ref="attachmentUploader"
						:table-name="'oilcard'"
						:record-id="moneyInfo.id"
						:attachment-type="'附件'"
						:initial-attachments="(form.params && form.params.attachments) || []"
						@files-updated="handleAttachmentFilesUpdated"
					/>
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitMoney">确 定</el-button>
				<el-button @click="moneyDialogVisible = false">取 消</el-button>
			</div>
		</el-dialog>

		<!--    加油卡操作功能-->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="加油卡操作"
			:visible.sync="optionVisible"
			width="500px"
			append-to-body
		>
			<el-form
				ref="oilCardForm"
				:model="oilCardOption"
				:rules="optionRules"
				label-width="200px"
				size="mini"
				@keyup.enter.native="submitOilCardOption"
				@submit.native.prevent="submitOilCardOption"
			>
				<el-form-item label="消费类型" prop="type">
					<el-radio v-model="oilCardOption.type" :label="OilCardOptionType.MAIN_TO_SUB">主卡分配</el-radio>
					<el-radio v-model="oilCardOption.type" :label="OilCardOptionType.SUB_TO_SUB">副卡圈存</el-radio>
				</el-form-item>
				<el-form-item label="主加油卡卡号" prop="oilMainCardNo" v-if="oilCardOption.type === OilCardOptionType.MAIN_TO_SUB">
					<el-row>
						<el-col :span="10">
							<el-input disabled v-model="oilCardOption.oilMainCardNo" placeholder="请选择" />
						</el-col>
						<el-col :span="4">
							<SearchOption
								:get-data="listOilCard"
								query-info="oilCardNo"
								:query-name="queryOilCard"
								query-label="油卡账号查询"
								:limit-info="{ oilType: '主卡' }"
								@commitBack="handleCommitBackOilCard"
								@update:queryName="handleCommitBackQueryOilCard"
							>
								<template #table-columns>
									<el-table-column label="加油卡卡号" align="center" prop="oilCardNo" />
									<el-table-column label="当前金额" align="center" prop="moneyAmount" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="副加油卡卡号" prop="oilSecondCardNo">
					<el-row>
						<el-col :span="10">
							<el-input disabled v-model="oilCardOption.oilSecondCardNo" placeholder="请选择" />
						</el-col>
						<el-col :span="4">
							<SearchOption
								:get-data="listOilCard"
								query-info="oilCardNo"
								:query-name="queryOilCardOther"
								query-label="油卡账号查询"
								:limit-info="{ oilType: '副卡' }"
								@commitBack="handleCommitBackOilCardOther"
								@update:queryName="handleCommitBackQueryOilCardOther"
							>
								<template #table-columns>
									<el-table-column label="加油卡卡号" align="center" prop="oilCardNo" />
									<el-table-column label="当前金额" align="center" prop="moneyAmount" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>

				<el-form-item :label="oilCardOption.type === OilCardOptionType.MAIN_TO_SUB ? `分配金额` : `圈存金额`" prop="rechargeMoney">
					<el-input
						v-model="oilCardOption.rechargeMoney"
						:placeholder="oilCardOption.type === OilCardOptionType.MAIN_TO_SUB ? `请输入分配金额` : `请输入圈存金额`"
						@input="handleInputTrim($event, 'oilCardOption', 'rechargeMoney')"
					/>
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="oilCardOption.comments" placeholder="请输入备注" @input="handleInputTrim($event, 'oilCardOption', 'comments')" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitOilCardOption">确 定</el-button>
				<el-button @click="cancelOilCardOption">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { listOilCard, getOilCard, delOilCard, addOilCard, updateOilCard } from '@/api/system/oilCard';
import SearchOption from '@/components/SearchOption.vue';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import { excludeParams } from '@/api/tool/exclude';
import { listBankAccount } from '@/api/system/bankAccount';
import { addOilRecharge } from '@/api/system/oilRecharge';
import { mapGetters } from 'vuex';
import { parseTime } from '@/utils/ruoyi';
import { getOilCardDetailSummary } from '../../../api/system/statement';
import OilCardDetail from '../Statement/OilCardDetail.vue';
import { common_dialog } from '../../dashboard/mixins/common/common_dialog';
import { OilCardOptionType } from '@/api/tool/enums';
import { addOilCardFundTransfer } from '@/api/system/oilCardFundTransfer';

export default {
	name: 'OilCard',
	components: { SearchOption, UploadFilesButton },
	mixins: [common_dialog],
	data() {
		return {
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			MainTotal: 0,
			SubTotal: 0,
			mainOilCardList: [],
			subCardList: [],
			title: '',
			open: false,
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				oilCardNo: null,
				useDate: null,
				carNo: null,
				destination: null,
				rechargeMoney: null,
				startCardSurplus: null,
				toPlusCardMoney: null,
				refuelingNumber: null,
				unitPrice: null,
				refuelingMoney: null,
				isTicket: null,
				endCarState: null,
				oilType: null,
				moneyAmount: null,
				comments: null,
				submittime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			form: {
				rechargeName: ''
			},
			rules: {
				oilCardNo: [
					{
						required: true,
						message: '加油卡卡号不能为空',
						trigger: 'blur'
					}
				],
				oilType: [
					{
						required: true,
						message: '加油卡类别不能为空',
						trigger: 'blur'
					}
				],
				moneyAmount: [
					{
						required: true,
						message: '加油金额不能为空',
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `加油卡卡号`, visible: true },
				{ key: 1, label: `当前金额`, visible: true },
				{ key: 2, label: `备注`, visible: true }
			],
			queryCard: null,
			moneyDialogVisible: false,
			moneyInfo: {
				oilCardNo: '',
				rechargeType: '',
				rechargeMoney: '',
				rechargeDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
				rechargeName: '',
				acountsName: '',
				bankNo: '',
				attachment: '',
				comments: ''
			},
			activeName: 'first',
			options: [
				{
					value: '现金',
					label: '现金'
				},
				{
					value: '银行卡',
					label: '银行卡'
				}
			],
			queryBankAcount: '',
			oilCardOption: {},
			optionVisible: false,
			queryOilCard: '',
			queryOilCardOther: '',
			optionRules: {
				oilMainCardNo: [
					{
						required: true,
						message: '请输入主加油卡卡号',
						trigger: 'blur'
					}
				],
				oilSecondCardNo: [
					{
						required: true,
						message: '请输入副加油卡卡号',
						trigger: 'blur'
					}
				],
				type: [
					{
						required: true,
						message: '请选择消费类型',
						trigger: 'blur'
					}
				],
				rechargeMoney: [
					{
						required: true,
						message: '请输入充值金额',
						trigger: 'blur'
					},
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('请输入正确的金额'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				]
			},
			moneyRules: {
				oilCardNo: [
					{
						required: true,
						message: '加油卡卡号不能为空',
						trigger: 'blur'
					}
				],
				rechargeType: [
					{
						required: true,
						message: '请选择充值方式',
						trigger: 'blur'
					}
				],
				rechargeMoney: [
					{
						required: true,
						message: '请输入充值金额',
						trigger: 'blur'
					},
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('请输入正确的金额'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				]
			}
		};
	},
	computed: {
		OilCardOptionType() {
			return OilCardOptionType;
		},
		change: {
			set() {
				this.isMain = !this.isMain;
			},
			get() {
				return this.isMain;
			}
		},
		...mapGetters(['trueName'])
	},
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('oilcard-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		isMain(val) {
			console.log(val);
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('oilcard-columns') === 'null' || !localStorage.getItem('oilcard-columns')) {
			localStorage.setItem('oilcard-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('oilcard-columns'));
		}
	},
	methods: {
		// 附件更新处理
		handleAttachmentFilesUpdated(uploadParams) {
			// uploadParams 结构: { params: { attachmentIds: [1, 2, 3] } }
			if (!this.moneyInfo.params) {
				this.$set(this.moneyInfo, 'params', {});
			}

			// 直接设置 attachmentIds
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				this.$set(this.moneyInfo.params, 'attachmentIds', uploadParams.params.attachmentIds);
			} else {
				this.$set(this.moneyInfo.params, 'attachmentIds', []);
			}
		},
		handleInputTrim(val, obj, prop) {
			if (val.indexOf(' ') !== -1) {
				this[obj][prop] = val.replace(/\s+/g, '');
			}
		},
		listBankAccount,
		listOilCard,
		handleCommitBackBankAcount(val) {
			this.moneyInfo.acountsName = val.acountsName;
			this.moneyInfo.bankNo = val.bankNo;
		},
		handleUpdateQueryBankAcount(val) {
			this.queryBankAcount = val;
		},
		handleUpdateQueryName(val) {
			this.queryCard = val;
		},
		handleCommitBackOilCard(val) {
			this.oilCardOption.oilMainCardNo = val.oilCardNo;
		},
		handleCommitBackQueryOilCard(val) {
			this.queryOilCard = val;
		},
		handleCommitBackOilCardOther(val) {
			this.oilCardOption.oilSecondCardNo = val.oilCardNo;
		},
		handleCommitBackQueryOilCardOther(val) {
			this.queryOilCardOther = val;
		},
		handleUpload(val) {
			this.moneyInfo.attachment = val;
		},
		handleClick(tab, event) {
			console.log(tab.name, event);
			if (tab.name === 'first') {
			} else {
			}
		},
		handleMoney() {
			this.moneyInfo.rechargeName = this.trueName;
			this.moneyDialogVisible = true;
		},
		handleOption() {
			this.resetOption();
			this.optionVisible = true;
		},
		submitOilCardOption() {
			this.$refs['oilCardForm'].validate(valid => {
				if (valid) {
					if (!this.oilCardOption.oilMainCardNo && this.oilCardOption.type === OilCardOptionType.SUB_TO_SUB) {
						this.oilCardOption.oilMainCardNo = this.oilCardOption.oilSecondCardNo;
					}
					if (this.oilCardOption.oilMainCardNo == null && this.oilCardOption.type === OilCardOptionType.MAIN_TO_SUB) {
						this.$modal.msgError('主卡卡号不能为空');
						return;
					}
					if (this.oilCardOption.id != null) {
						this.$message.error('暂不支持修改');
					}
					this.oilCardOption = excludeParams(this.oilCardOption, this.$exclude);
					addOilCardFundTransfer(this.oilCardOption).then(() => {
						this.$modal.msgSuccess('新增成功,请前往加油卡操作记录查看');
						this.optionVisible = false;
						this.getList();
					});
				}
			});
		},
		cancelOilCardOption() {
			this.optionVisible = false;
			this.resetOption();
		},
		submitMoney() {
			this.$refs['moneyFormRef'].validate(valid => {
				if (valid) {
					addOilRecharge({
						...this.moneyInfo,
						params: {
							attachmentIds: this.moneyInfo.params?.attachmentIds || []
						}
					}).then(() => {
						this.$message.success('油卡充值信息新增成功，请前往出差管理/加油卡充值记录查看');
						this.moneyDialogVisible = false;
						// 清空附件上传组件
						if (this.$refs.attachmentUploader) {
							this.$refs.attachmentUploader.clearUploadedFiles();
						}
					});
				}
			});
		},
		handleCommitBack(val) {
			this.moneyInfo.oilCardNo = val.oilCardNo;
		},
		getList() {
			this.loading = true;
			this.queryParams.oilType = '主卡';
			listOilCard(this.queryParams).then(response => {
				this.mainOilCardList = response.rows;
				this.MainTotal = response.total;
				this.loading = false;
			});
			this.queryParams.oilType = '副卡';
			listOilCard(this.queryParams).then(response => {
				this.subCardList = response.rows;
				this.SubTotal = response.total;
				this.loading = false;
			});
		},
		cancel() {
			this.open = false;
			this.reset();
		},
		reset() {
			this.form = {
				id: null,
				oilCardNo: null,
				useDate: null,
				carNo: null,
				destination: null,
				rechargeMoney: null,
				startCardSurplus: null,
				toPlusCardMoney: null,
				refuelingNumber: null,
				unitPrice: null,
				refuelingMoney: null,
				isTicket: null,
				endCarState: null,
				oilType: null,
				moneyAmount: null,
				comments: null,
				submittime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};
			this.resetForm('form');
		},
		resetOption() {
			this.oilCardOption = {
				id: null,
				oilMainCardNo: null,
				oilSecondCardNo: null,
				rechargeMoney: null,
				rechargeDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
				rechargeName: null,
				type: OilCardOptionType.MAIN_TO_SUB,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};
			this.resetForm('oilCardOption');
		},
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*']
			});
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加加油卡信息';
		},
		handleCheck(row) {
			this.$datePicker().then(({ beginTime, endTime }) => {
				const body = {
					beginTime,
					endTime,
					oilCardNo: row.oilCardNo
				};
				getOilCardDetailSummary(body).then(res => {
					const body = res.data;
					this.openDialog(
						OilCardDetail,
						'油卡明细',
						'900px',
						{
							records: body
						},
						true
					);
				});
			});
		},
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getOilCard(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改加油卡信息';
			});
		},
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						updateOilCard(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form = excludeParams(this.form, this.$exclude);
						addOilCard(this.form).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getList();
						});
					}
				}
			});
		},
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除加油卡信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delOilCard(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		handleExport() {
			this.download(
				'system/oilCard/export',
				{
					...this.queryParams
				},
				`oilCard_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
