<!--付款审核流程页面 需求:渲染需要付款的信息列表，付款信息中有多个审核流程 提供按钮筛选仅
当前账号需要审核的流程 审核的过程调用修改接口-->
<script>
import { getPaymentApply, listPaymentApply } from '@/api/system/paymentApply';
import { listAuditInfoGroup } from '@/api/system/auditInfo';
import StepInfo from '@/views/dashboard/components/applyProcess/StepInfo.vue';
import { mapGetters } from 'vuex';
import { listAuditInfo } from '../../../api/system/auditInfo';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import SearchOption from '@/components/SearchOption.vue';
import BankType from '@/views/dashboard/components/common/BankType.vue';
import { mixin_payment_subject } from '@/views/dashboard/mixins/payment/payment_subject';
import { mixin_bankType } from '@/views/dashboard/mixins/common/common_bankType';
import { mixin_paymentindex_fill } from '@/views/system/payment/paymentFill';
import { mixin_payment_select, PAYMENT_TYPES } from '@/views/dashboard/mixins/payment/payment_select';
import { listCompany } from '@/api/system/company';
import { listBankAccount } from '@/api/system/bankAccount';
import { excludeParams } from '@/api/tool/exclude';
import { addPayment, updatePayment } from '@/api/system/payment';

export default {
	name: 'Index',
	components: { BankType, SearchOption, StepInfo },
	mixins: [mixin_printHTML, mixin_payment_subject, mixin_bankType, mixin_paymentindex_fill, mixin_payment_select],
	data() {
		return {
			loading: false,
			columns: [
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `支付类型`, visible: true },
				{ key: 2, label: `金额`, visible: true },
				{ key: 3, label: `对方账号`, visible: true },
				{ key: 4, label: `对方公司`, visible: true },
				{ key: 5, label: `付款原因`, visible: true },
				{ key: 6, label: `附件`, visible: true },
				{ key: 7, label: `申请人`, visible: true },
				{ key: 8, label: `备注`, visible: true },
				{ key: 9, label: `审核流程`, visible: true }
			],
			// 查看付款信息的
			checkInfoDialogVisible: false,
			// 查看审核流程
			checkApplyInfoDialogVisible: false,
			// 筛选项
			options: [
				{
					value: '1',
					label: '所有审核信息'
				},
				{
					value: '2',
					label: '仅我需要审核'
				}
			],
			// 筛选限制值
			select: '',
			// 折叠面板默认打开
			activeNames: '1',
			// 付款信息列表
			paymentList: [],
			// 查看付款信息的描述表
			checkPaymentInfo: {},
			auditInfoList: [],
			auditItemList: [],
			// 所有的审核流程列表 后期需要筛选这里面的审核流程
			allAuditInfoList: [],
			// 分页信息
			pageNum: 1,
			pageSize: 10,
			total: 0,
			// 付款审核
			addCheckApplyProcessVisible: false,

			// 2025-2-17 新增付款新增功能
			open: false,
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				fundsDate: [{ required: true, message: '请选择日期', trigger: 'blur' }],
				payType: [
					{
						required: true,
						message: '请选择付款类型',
						trigger: 'blur'
					}
				],
				moneyAmount: [
					{ required: true, message: '请输入金额', trigger: 'blur' },
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('金额只能为数字且小数点后最多两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				selfAcountsName: [
					{
						required: true,
						message: '请输入我方户名',
						trigger: 'blur'
					}
				],
				selfBankNo: [
					{
						required: true,
						message: '请输入我方账号',
						trigger: 'blur'
					}
				],
				selfBankName: [
					{
						required: true,
						message: '请输入我方开户行',
						trigger: 'blur'
					}
				],
				otherAcountsName: [
					{
						required: true,
						message: '请输入对方户名',
						trigger: 'blur'
					}
				],
				otherBankNo: [
					{
						required: true,
						message: '请输入对方账号',
						trigger: 'blur'
					}
				],
				otherBankName: [
					{
						required: true,
						message: '请输入对方开户行',
						trigger: 'blur'
					}
				]
			}
		};
	},
	watch: {
		// 监听刷新标记
		checked: {
			columns: {
				handler: function (newVal) {
					localStorage.setItem('applyprocess-columns', JSON.stringify(newVal));
				},
				deep: true
			},
			handler(val) {
				if (val !== '') {
					setTimeout(() => {
						this.refreshApplyCheckInfo(val);
						this.$store.dispatch('apply/clearChecked');
					}, 500);
				}
			}
		}
	},
	created() {
		if (localStorage.getItem('applyprocess-columns') === 'null' || !localStorage.getItem('applyprocess-columns')) {
			// 设置localStorage
			localStorage.setItem('applyprocess-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('applyprocess-columns'));
		}
		// 获取付款信息
		listPaymentApply({
			pageNum: this.pageNum,
			pageSize: this.pageSize
		}).then(res => {
			this.paymentList = res.rows;
			this.total = res.total;
		});
		// 获取所有的审核流程
		listAuditInfo().then(res => {
			this.allAuditInfoList = res.rows;
		});
	},
	computed: {
		PAYMENT_TYPES() {
			return PAYMENT_TYPES;
		},
		...mapGetters(['checked'])
	},
	methods: {
		listBankAccount,
		listCompany,
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加付款信息';
		},
		refresh() {
			this.loading = true;
			listPaymentApply({
				pageNum: this.pageNum,
				pageSize: this.pageSize
			}).then(res => {
				this.paymentList = res.rows;
				this.total = res.total;
				this.loading = false;
			});
		},
		// 重新刷新审核树
		refreshApplyCheckInfo(applyID) {
			// 获取所有的审核流程
			listAuditInfoGroup({ applyID: applyID }).then(res => {
				this.auditInfoList = res.rows;
			});
		},
		// 分页获取列表
		getPaymentList() {
			this.$wait();
			listPaymentApply({ pageNum: this.pageNum, pageSize: this.pageSize })
				.then(res => {
					this.paymentList = res.rows;
					this.$close();
				})
				.catch(() => {
					this.$close();
				});
		},
		checkFile(row) {
			window.open(row.attachment);
		},
		// 查看某一个行的信息
		handleCheckInfo(row) {
			this.checkInfoDialogVisible = true;
			// 获取该行付款信息的详细信息 赋值到弹出框的描述表中
			getPaymentApply(row.id).then(res => {
				this.checkPaymentInfo = res.data;
			});
		},
		// 查看某一行的审核流程信息
		handleCheckApplyInfo(row) {
			listAuditInfoGroup({ applyID: row.id }).then(res => {
				this.auditInfoList = res.rows;
				this.checkApplyInfoDialogVisible = true;
			});
		},
		// 审核完毕后点击确定
		onSubmitApply() {
			this.checkApplyInfoDialogVisible = false;
			this.refresh();
		},
		// 折叠面板打开某一个的回调
		handleChangeApplyItem(e) {
			console.log(e);
		},
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						this.form.paymentState = '已支付';
						// 修改支付状态
						updatePayment(this.form).then(() => {
							this.$modal.msgSuccess('支付成功~');
							this.open = false;
							this.getList();
						});

						// 新增操作
					} else {
						// 去除参数
						this.form = excludeParams(this.form, this.$exclude);
						// 需要拼凑支付类型  但是不能修改响应式的payType 这是一个数组
						let paymentType = null;
						if (this.form.payType) {
							paymentType = this.form.payType.join('-');
						} else {
							this.$message.warning('请选择付款类型');
							return;
						}
						// 填充公司类型
						this.form.companyType = this.value;
						// 拼凑body
						const body = { ...this.form, payType: paymentType };
						// 添加付款信息
						addPayment(body).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getList();
						});
					}
				}
			});
		},
		cancel() {
			this.open = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				payNO: null,
				fundsDate: null,
				payType: null,
				tableName: null,
				tID: null,
				moneyAmount: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				paymentState: null,
				companyName: null,
				companyId: null,
				companyType: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};
			this.resetForm('form');
		}
	}
};
</script>

<template>
	<div class="app-container">
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button size="mini" @click="refresh">刷新</el-button>
			</el-col>

			<el-col :span="1.5">
				<el-button size="mini" type="danger" @click="handleAdd">新增付款信息</el-button>
			</el-col>

			<right-toolbar :columns="columns">
				<!--    打印    -->
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>
		<!--    放置付款信息列表-->
		<el-row>
			<el-table
				id="printBox"
				v-loading="loading"
				:data="paymentList"
				border
				:cell-style="
					() => {
						return { padding: '.5px' };
					}
				"
				style="width: 100%"
				size="mini"
				align="center"
			>
				<el-table-column v-if="columns[0].visible" fixed prop="fundsDate" label="日期" width="150" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[1].visible" prop="payType" label="支付类型" width="150" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[2].visible" prop="moneyAmount" label="金额" width="120" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[3].visible" prop="otherBankNo" label="对方账号" width="300" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[4].visible" prop="companyName" label="对方公司" width="120" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[5].visible" prop="reason" label="付款原因" width="120" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[6].visible" prop="attachment" label="附件" width="120" show-overflow-tooltip>
					<template #default="scope">
						<span v-if="scope.row.attachment === '' || scope.row.attachment === null">无附件</span>
						<span v-else>
							<el-button size="mini" type="text" @click="checkFile(scope.row)">查看附件</el-button>
						</span>
					</template>
				</el-table-column>
				<el-table-column v-if="columns[7].visible" prop="applyPerson" label="申请人" width="120" show-overflow-tooltip></el-table-column>
				<el-table-column v-if="columns[8].visible" prop="comments" label="备注" width="120" show-overflow-tooltip></el-table-column>
				<el-table-column label="操作" width="80">
					<template slot-scope="scope">
						<el-button type="text" size="mini" @click="handleCheckInfo(scope.row)">查看</el-button>
					</template>
				</el-table-column>
				<el-table-column label="审核状态" width="80" fixed="right" align="center">
					<template slot-scope="scope">
						<el-tag :type="scope.row.checkState === '通过' ? 'success' : scope.row.checkState === '未通过' ? 'danger' : 'primary'">
							{{ scope.row.checkState }}
						</el-tag>
					</template>
				</el-table-column>
				<el-table-column v-if="columns[9].visible" fixed="right" label="审核流程" width="200" show-overflow-tooltip>
					<template slot-scope="scope">
						<el-button type="warning" size="mini" @click="handleCheckApplyInfo(scope.row)">查看审核流程信息</el-button>
					</template>
				</el-table-column>
			</el-table>
			<!--      分页-->
			<pagination v-show="total > 0" :total="total" :page.sync="pageNum" :limit.sync="pageSize" @pagination="getPaymentList" />
		</el-row>

		<!--    查看付款信息的详细信息-->
		<el-dialog :close-on-click-modal="false" :show-close="false" title="付款信息详细" :visible.sync="checkInfoDialogVisible" width="50%">
			<el-descriptions title="付款信息明细">
				<el-descriptions-item label="申请人">
					{{ checkPaymentInfo.applyPerson }}
				</el-descriptions-item>
				<el-descriptions-item label="申请金额">
					{{ checkPaymentInfo.moneyAmount }}
				</el-descriptions-item>
				<el-descriptions-item label="备注">
					{{ checkPaymentInfo.comments }}
				</el-descriptions-item>
				<el-descriptions-item label="公司类型">
					{{ checkPaymentInfo.companyType }}
				</el-descriptions-item>
				<el-descriptions-item label="公司名称">
					{{ checkPaymentInfo.companyName }}
				</el-descriptions-item>
				<el-descriptions-item label="时间">
					{{ checkPaymentInfo.fundsDate }}
				</el-descriptions-item>
				<el-descriptions-item label="对方账户名称">
					{{ checkPaymentInfo.otherAcountsName }}
				</el-descriptions-item>
				<el-descriptions-item label="对方银行卡号">
					{{ checkPaymentInfo.otherBankNo }}
				</el-descriptions-item>
				<el-descriptions-item label="对方开户行">
					{{ checkPaymentInfo.otherBankName }}
				</el-descriptions-item>
				<el-descriptions-item label="申请原因">
					{{ checkPaymentInfo.reason }}
				</el-descriptions-item>
			</el-descriptions>
			<span slot="footer" class="dialog-footer">
				<el-button @click="checkInfoDialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="checkInfoDialogVisible = false">确 定</el-button>
			</span>
		</el-dialog>

		<!--      审核流程步骤图信息  -->
		<el-dialog :close-on-click-modal="false" :show-close="false" :visible.sync="checkApplyInfoDialogVisible" title="审核流程多项信息" width="58%">
			<el-row v-for="(item, index) in auditInfoList" :key="index">
				<el-collapse v-model="activeNames" @change="handleChangeApplyItem">
					<el-collapse-item name="1">
						<template #title>
							<el-row>
								<span class="text-bolder">审核流程</span>
							</el-row>
						</template>
						<el-row>
							<el-col :span="24">
								<StepInfo :processInfo="item.auditInfos" />
							</el-col>
						</el-row>
					</el-collapse-item>
				</el-collapse>
			</el-row>
			<span slot="footer" class="dialog-footer">
				<el-button @click="checkApplyInfoDialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="onSubmitApply">确 定</el-button>
			</span>
		</el-dialog>

		<!--   2025-2-17 新增付款功能-->
		<el-dialog :close-on-click-modal="false" :show-close="false" title="付款处理" :visible.sync="open" width="650px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="140px">
				<el-form-item label="日期" prop="fundsDate">
					<el-date-picker v-model="form.fundsDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
				</el-form-item>
				<!--        付款类型-->
				<el-form-item label="付款类型" prop="payType">
					<el-cascader v-model="form.payType" :options="paymentTypeTree" :props="props" @change="handleChange"></el-cascader>
				</el-form-item>
				<el-form-item label="金额" prop="moneyAmount">
					<el-input v-model="form.moneyAmount" placeholder="请输入金额" />
				</el-form-item>
				<el-form-item label="我方银行账户类型">
					<BankType :select-type="form.selfBankCardType" @updateSelectedType="changeSelfBankType" />
				</el-form-item>
				<!--        对方信息-->
				<el-form-item label="我方户名" prop="selfAcountsName">
					<el-row>
						<el-col :span="10">
							<el-input disabled v-model="form.selfAcountsName" placeholder="请选择" />
						</el-col>
						<el-col :span="3">
							<SearchOption
								:limit-info="{ acountsType: '己方公司' }"
								:get-data="listBankAccount"
								icon="el-icon-search"
								query-label="户名查找"
								query-info="acountsName"
								:query-name="queryBank"
								@commitBack="handleCommitBack"
								@update:queryName="handleUpdateQueryName"
							>
								<template #table-columns>
									<el-table-column label="账号类型" align="center" prop="acountsType" />
									<el-table-column label="显示名称" align="center" prop="displayName" />
									<el-table-column label="开户行" align="center" prop="bankName" />
									<el-table-column label="开户名" align="center" prop="acountsName" />
									<el-table-column label="账号" align="center" prop="bankNo" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="我方账号" prop="selfBankNo">
					<el-input disabled v-model="form.selfBankNo" placeholder="请选择" />
				</el-form-item>
				<el-form-item label="我方开户行" prop="selfBankName">
					<el-input disabled v-model="form.selfBankName" placeholder="请选择" />
				</el-form-item>
				<el-form-item label="对方类型">
					<el-select v-model="value" placeholder="请选择">
						<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
					</el-select>
				</el-form-item>

				<!--        下面的操作是 客户id  配合 银行卡信息进行付款.-->
				<!--      选择供应商-->
				<el-row v-if="value === PAYMENT_TYPES.SUPPLIER">
					<el-form-item label="供应商名称" prop="otherAcountsName">
						<el-row>
							<el-col :span="10">
								<!--                <el-input v-model="form.otherAcountsName" placeholder="请输入对方户名"/>-->
								<el-input disabled v-model="form.companyName" placeholder="请选择" />
							</el-col>
							<el-col :span="3">
								<SearchOption
									:limit-info="{
										companyType: PAYMENT_TYPES.SUPPLIER
									}"
									:get-data="listCompany"
									icon="el-icon-search"
									:query-label="'供应商'"
									query-info="companyName"
									:query-name="queryOtherSupplier"
									@update:queryName="handleUpdateQueryNameOtherSupplier"
									@commitBack="handleCommitBackOtherSupplier"
								>
									<template #table-columns>
										<el-table-column label="供应商" align="center" prop="companyName" width="180" show-overflow-tooltip />
										<el-table-column label="老板姓名" align="center" prop="leader" width="180" show-overflow-tooltip />
										<el-table-column label="老板电话" align="center" prop="leaderTel" width="180" show-overflow-tooltip />
										<el-table-column label="区域" align="center" prop="region" width="180" show-overflow-tooltip />
										<el-table-column label="联系人" align="center" prop="relationName" width="180" show-overflow-tooltip />
										<el-table-column label="销售经理" align="center" prop="salesManager" width="180" show-overflow-tooltip />
										<el-table-column label="地址" align="center" prop="address" width="150" show-overflow-tooltip />
										<el-table-column label="电话" align="center" prop="relationTel" width="180" show-overflow-tooltip />
										<el-table-column label="备注" align="center" prop="comments" width="180" show-overflow-tooltip />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
				</el-row>
				<!--      选择客户-->
				<el-row v-if="value === PAYMENT_TYPES.CUSTOMER">
					<el-form-item label="对方公司" prop="companyName">
						<el-row>
							<el-col :span="10">
								<!--                <el-input v-model="form.otherAcountsName" placeholder="请输入对方户名"/>-->
								<el-input disabled v-model="form.companyName" placeholder="请选择" />
							</el-col>
							<el-col :span="3">
								<SearchOption
									:limit-info="{
										companyType: PAYMENT_TYPES.CUSTOMER
									}"
									:get-data="listCompany"
									:query-label="'客户'"
									query-info="companyName"
									:query-name="queryOtherCustomer"
									icon="el-icon-search"
									@update:queryName="handleUpdateQueryNameOtherCustomer"
									@commitBack="handleCommitBackOther"
								>
									<template #table-columns>
										<el-table-column label="客户" align="center" prop="companyName" width="180" show-overflow-tooltip />
										<el-table-column label="老板姓名" align="center" prop="leader" width="180" show-overflow-tooltip />
										<el-table-column label="老板电话" align="center" prop="leaderTel" width="180" show-overflow-tooltip />
										<el-table-column label="区域" align="center" prop="region" width="180" show-overflow-tooltip />
										<el-table-column label="联系人" align="center" prop="relationName" width="180" show-overflow-tooltip />
										<el-table-column label="销售经理" align="center" prop="salesManager" width="180" show-overflow-tooltip />
										<el-table-column label="地址" align="center" prop="address" width="150" show-overflow-tooltip />
										<el-table-column label="电话" align="center" prop="relationTel" width="180" show-overflow-tooltip />
										<el-table-column label="备注" align="center" prop="comments" width="180" show-overflow-tooltip />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
				</el-row>
				<!--      选择司机-->
				<el-row v-if="value === PAYMENT_TYPES.DRIVER">
					<el-form-item label="司机名称" prop="companyName">
						<el-row>
							<el-col :span="10">
								<!--                <el-input v-model="form.otherAcountsName" placeholder="请输入对方户名"/>-->
								<el-input disabled v-model="form.companyName" placeholder="请选择" />
							</el-col>
							<el-col :span="3">
								<SearchOption
									:limit-info="{}"
									:get-data="listCars"
									icon="el-icon-search"
									:query-label="'司机'"
									query-info="driver"
									:query-name="queryOtherDriver"
									@update:queryName="handleUpdateQueryNameOtherDriver"
									@commitBack="handleCommitBackOtherCars"
								>
									<template #table-columns>
										<el-table-column label="车牌" align="center" prop="carNo" width="200" />
										<el-table-column label="司机姓名" align="center" prop="driver" width="200" />
										<el-table-column label="司机电话" align="center" prop="tel" width="200" />
										<el-table-column label="户名" align="center" prop="acountsName" width="200">
											<template slot-scope="scope">
												{{ isNull(scope.row.acountsName) }}
											</template>
										</el-table-column>
										<el-table-column label="银行账号" align="center" prop="bankNo" width="200">
											<template slot-scope="scope">
												{{ isNull(scope.row.bankNo) }}
											</template>
										</el-table-column>
										<el-table-column label="开户行" align="center" prop="bankName" width="200">
											<template slot-scope="scope">
												{{ isNull(scope.row.bankName) }}
											</template>
										</el-table-column>
										<el-table-column label="运输类型" align="center" prop="carType" width="200" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
				</el-row>
				<el-form-item label="对方银行账户类型" v-if="value !== '对外付款'">
					<BankType :select-type="form.otherBankCardType" @updateSelectedType="changeOtherBankType" />
				</el-form-item>
				<el-form-item label="对方账号" prop="otherBankNo" v-if="value !== '对外付款'">
					<el-row>
						<el-col :span="14">
							<el-input disabled v-model="form.otherBankNo" placeholder="请选择" />
						</el-col>
						<el-col :span="4">
							<SearchOption
								:limit-info="{ acountsType: value }"
								:get-data="listBankAccount"
								:query-name="queryBankAcount"
								query-label="户名查找"
								query-info="acountsName"
								@commitBack="handleCommitBackBankAcount"
								@update:queryName="handleUpdateQueryBankAcount"
							>
								<template #table-columns>
									<el-table-column label="账户类型" align="center" prop="acountsType" />
									<el-table-column label="显示名称" align="center" prop="displayName" />
									<el-table-column label="账号(银行账号)" align="center" prop="bankNo" />
									<el-table-column label="开户行" align="center" prop="bankName" />
									<el-table-column label="公司名称" align="center" prop="companyName" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="对方开户行" prop="otherBankName" v-if="value !== '对外付款'">
					<el-input disabled v-model="form.otherBankName" placeholder="请选择" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确认付款</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss">
.text-bolder {
	font-weight: bolder;
	line-height: 35px;
}
</style>
