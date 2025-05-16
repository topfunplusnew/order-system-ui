<!--运费申请 根据字段判断海运陆运-->
<script>
import { addOrderFreight } from '@/api/system/orderFreight';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { listBankAccount, addBankAccount } from '@/api/system/bankAccount';
import { getCars, listCars } from '@/api/system/cars';
import { parseTime } from '@/utils/ruoyi';
import { mapGetters } from 'vuex';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { excludeParams } from '@/api/tool/exclude';

export default {
	name: 'FreeApply',
	components: { SearchOption },
	props: {
		orderInfo: {}
	},
	data() {
		return {
			queryAcountsName: '',
			form: {},
			rules: {
				otherAcountsName: [
					{
						required: true,
						message: '请选择或添加司机银行卡信息',
						trigger: 'blur'
					}
				],
				otherBankNo: [
					{
						required: true,
						message: '请选择或添加司机银行卡信息',
						trigger: 'blur'
					}
				],
				payDate: [
					{
						required: true,
						message: '请选择支付日期',
						trigger: 'blur'
					}
				]
			},
			addBankAccountDialogVisible: false,
			bankAccountForm: {},
			bankAccountRules: {
				bankNo: [
					{
						required: true,
						message: '银行账号不能为空',
						trigger: 'blur'
					}
				],
				acountsName: [
					{
						required: true,
						message: '账户名称不能为空',
						trigger: 'blur'
					}
				],
				companyName: [
					{
						required: true,
						message: '车牌号不能为空',
						trigger: 'blur'
					}
				]
			},
			queryBankAccount: ''
		};
	},
	computed: {
		...mapGetters(['trueName']),
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		}
	},
	watch: {
		orderInfo: {
			handler(val) {
				const query = {
					companyId: val.driverId
				};
				this.getDriverAccountInfo(query);
			},
			deep: true,
			immediate: true
		}
	},
	created() {
		this.reset();
		this.resetBankAccountForm();
		getCars(this.orderInfo.driverId).then(res => {
			this.$nextTick(() => {
				this.form.otherAcountsName = res.data.acountsName;
				this.form.otherBankNo = res.data.bankNo;
				this.form.otherBankName = res.data.bankName;
			});
		});
	},
	methods: {
		listBankAccount,
		listCompany,
		listCars,
		getDriverAccountInfo(query) {
			listBankAccount(query).then(res => {
				if (!res.rows || res.rows.length === 0) {
					this.$message.error('该司机未添加银行卡信息,请先为该司机添加银行卡');
					return;
				}
				this.$nextTick(() => {
					this.form.otherAcountsName = res.rows[0].acountsName;
					this.form.otherBankNo = res.rows[0].bankNo;
					this.form.otherBankName = res.rows[0].bankName;
				});
			});
		},
		handleProcess(that) {
			this.$refs['form'].validate(isValid => {
				if (isValid) {
					const query = {
						...this.form,
						...this.orderInfo,
						applyDate: parseTime(new Date()),
						applyUserName: this.trueName
					};
					return new Promise((resolve, reject) => {
						addOrderFreight(query).then(() => {
							this.$message.success('操作成功');
							this.reset();
							that.dialogVisible = false;
							resolve();
						});
					});
				}
			});
		},
		handleReject() {},
		handleCommitBack(val) {
			this.form.otherAcountsName = val.acountsName;
			this.form.otherBankName = val.bankName;
			this.form.otherBankNo = val.bankNo;
		},
		handleChange(val) {
			this.queryAcountsName = val;
		},
		reset() {
			this.form = {
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				payDate: parseTime(new Date()),
				comments: null,
				content: null
			};
		},
		openAddBankAccountDialog() {
			this.resetBankAccountForm();
			this.addBankAccountDialogVisible = true;
		},
		cancelBankAccountForm() {
			this.addBankAccountDialogVisible = false;
			this.resetBankAccountForm();
		},
		resetBankAccountForm() {
			this.bankAccountForm = {
				id: null,
				companyName: null,
				companyId: null,
				bankName: null,
				isPublicAccount: null,
				acountsName: null,
				bankNo: null,
				acountsType: PUBLIC_DICT_TYPE.DRIVER,
				amount: null,
				comments: null,
				delFlag: null
			};
			this.resetForm('bankAccountFormRef');
		},
		submitBankAccountForm() {
			this.$refs['bankAccountFormRef'].validate(valid => {
				if (valid) {
					if (!this.bankAccountForm.companyId) {
						this.$message.error('请通过搜索选择一个车辆来绑定银行卡');
						return;
					}
					const formData = excludeParams(this.bankAccountForm, this.$exclude);
					formData.companyType = PUBLIC_DICT_TYPE.DRIVER;

					addBankAccount(formData).then(() => {
						this.$modal.msgSuccess('新增司机银行卡成功');
						this.addBankAccountDialogVisible = false;
						this.getDriverAccountInfo({ companyId: this.orderInfo.driverId });
					});
				}
			});
		},
		handleCommitBackBankAccount(val) {
			this.bankAccountForm.companyId = val.id;
			this.bankAccountForm.companyName = val.carNo;
		},
		handleUpdateBankAccount(val) {
			this.queryBankAccount = val;
		}
	}
};
</script>

<template>
	<div>
		<el-form ref="form" :model="form" label-width="80px" :rules="rules">
			<el-form-item label="对方户名" prop="otherAcountsName">
				<el-row>
					<el-col :span="10">
						<el-input disabled v-model="form.otherAcountsName" placeholder="请选择或添加" />
					</el-col>
					<el-col :span="4">
						<SearchOption
							:limit-info="{
								acountsType: '司机',
								companyId: this.orderInfo.driverId
							}"
							:get-data="listBankAccount"
							query-label="户名搜索"
							query-info="acountsName"
							:query-name="queryAcountsName"
							@commitBack="handleCommitBack"
							@update:queryName="handleChange"
						>
							<template #table-columns>
								<el-table-column label="车牌号" align="center" prop="companyName" />
								<el-table-column label="开户行" align="center" prop="bankName" />
								<el-table-column label="开户名" align="center" prop="acountsName" />
								<el-table-column label="账号" align="center" prop="bankNo" />
							</template>
						</SearchOption>
					</el-col>
					<el-col :span="4">
						<el-button type="primary" size="mini" @click="openAddBankAccountDialog">添加司机银行卡</el-button>
					</el-col>
				</el-row>
			</el-form-item>
			<el-form-item label="对方账号" prop="otherBankNo">
				<el-input disabled v-model="form.otherBankNo" placeholder="请选择" />
			</el-form-item>
			<el-form-item label="对方开户行" prop="otherBankName">
				<el-input disabled v-model="form.otherBankName" placeholder="请选择" />
			</el-form-item>
			<el-form-item label="支付日期" prop="payDate">
				<el-date-picker v-model="form.payDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss" />
			</el-form-item>
			<el-form-item label="备注信息">
				<el-input v-model="form.content" placeholder="请输入备注信息" />
			</el-form-item>
			<el-form-item label="附加备注">
				<el-input v-model="form.comments" placeholder="请输入附加备注" />
			</el-form-item>
		</el-form>

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  title="快速添加司机银行卡信息" :visible.sync="addBankAccountDialogVisible" width="500px" append-to-body :close-on-click-modal="false">
			<el-form ref="bankAccountFormRef" :model="bankAccountForm" :rules="bankAccountRules" label-width="120px">
				<el-form-item label="车牌" prop="acountsName">
					<el-row>
						<el-col :span="20">
							<el-input disabled v-model="bankAccountForm.companyName" placeholder="选择车辆后自动填充" />
						</el-col>
						<el-col :span="4">
							<el-tooltip content="选择车辆" placement="top">
								<SearchOption
									:limit-info="{}"
									:get-data="listCars"
									query-info="carNo"
									query-label="车牌查找"
									:query-name="queryBankAccount"
									@update:queryName="handleUpdateBankAccount"
									@commitBack="handleCommitBackBankAccount"
								>
									<template #table-columns>
										<el-table-column label="司机" align="center" prop="driver" />
										<el-table-column label="车牌号" align="center" prop="carNo" />
										<el-table-column label="司机电话" align="center" prop="tel" />
										<el-table-column label="开户名" align="center" prop="acountsName" />
										<el-table-column label="账号" align="center" prop="bankNo" />
										<el-table-column label="开户行" align="center" prop="bankName" />
										<el-table-column label="运输方式" align="center" prop="carType" />
									</template>
								</SearchOption>
							</el-tooltip>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="户名" prop="companyName">
					<el-input v-model="bankAccountForm.acountsName" placeholder="请输入户名" />
				</el-form-item>
				<el-form-item label="银行账号" prop="bankNo">
					<el-input v-model="bankAccountForm.bankNo" placeholder="请输入银行账号" />
				</el-form-item>
				<el-form-item label="开户行" prop="bankName">
					<el-input v-model="bankAccountForm.bankName" placeholder="请输入开户行" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitBankAccountForm">确 定</el-button>
				<el-button @click="cancelBankAccountForm">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss"></style>
