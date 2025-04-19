<template>
	<div class="app-container">
		<el-form ref="form" :model="form" :rules="rules" label-width="120px">
			<el-form-item label="日期" prop="fundsDate">
				<el-date-picker v-model="form.fundsDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="选择日期" />
			</el-form-item>
			<el-form-item label="支付类型" prop="payType">
				<el-row :gutter="5">
					<el-cascader v-model="form.payType" :options="paymentTypeTree" :props="props" />
				</el-row>
			</el-form-item>
			<el-form-item label="金额" prop="moneyAmount">
				<el-input v-model="form.moneyAmount" placeholder="请输入金额" :disabled="inputDisabled && moneyInputDisabled" />
			</el-form-item>
			<el-form-item label="对方类型(请确认)">
				<el-select v-model="value" placeholder="请选择" @change="handleOpponentTypeChange">
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
				</el-select>
				<span style="color: #1c84c6; font-size: 12px">请注意选择正确的对方公司类型!</span>
			</el-form-item>

			<el-form-item v-if="value !== '员工' && value !== '对外付款'" label="对方公司" prop="companyName">
				<el-row>
					<el-col :span="14">
						<el-input disabled v-model="form.companyName" placeholder="请选择" />
					</el-col>
					<el-col :span="4">
						<SearchOption
							:limit-info="{ companyType: value }"
							:get-data="listCompany"
							icon="el-icon-search"
							:query-label="value"
							query-info="companyName"
							:query-name="queryOther"
							@update:queryName="handleUpdateQueryNameOther"
							@commitBack="handleCommitBackOther"
						>
							<template #table-columns>
								<el-table-column :label="`${value}名称`" align="center" prop="companyName" width="180" show-overflow-tooltip />
								<el-table-column label="老板姓名" align="center" prop="leader" width="180" show-overflow-tooltip />
								<el-table-column label="老板电话" align="center" prop="leaderTel" width="180" show-overflow-tooltip />
								<el-table-column label="区域" align="center" prop="region" width="180" show-overflow-tooltip />
								<el-table-column label="联系人" align="center" prop="relationName" width="180" show-overflow-tooltip />
								<el-table-column label="销售经理" align="center" prop="salesManager" width="180" show-overflow-tooltip />
								<el-table-column label="地址" align="center" prop="address" width="150" show-overflow-tooltip />
								<el-table-column label="电话" align="center" prop="relationTel" width="180" show-overflow-tooltip />
							</template>
						</SearchOption>
					</el-col>
				</el-row>
			</el-form-item>

			<el-row v-if="value === '客户'">
				<el-form-item label="对方账号(客户)" prop="otherBankNo">
					<el-row>
						<el-col :span="14">
							<el-input v-model="form.otherBankNo" placeholder="请选择" disabled />
						</el-col>
						<el-col v-if="bankInputDisabled === false" :span="3">
							<SearchOption
								:get-data="listBankAccount"
								icon="el-icon-search"
								:limit-info="{ acountsType: '客户' }"
								query-label="银行卡查找"
								query-info="bankNo"
								:query-name="queryCompany"
								@commitBack="handleCommitBack"
								@update:queryName="handleUpdateQueryName"
							>
								<template #table-columns>
									<el-table-column label="公司名称" align="center" prop="companyName">
										<template #default="scope">
											{{ isNull(scope.row.companyName) }}
										</template>
									</el-table-column>
									<el-table-column label="开户行" align="center" prop="bankName">
										<template #default="scope">
											{{ isNull(scope.row.bankName) }}
										</template>
									</el-table-column>
									<el-table-column label="开户名" align="center" prop="acountsName">
										<template #default="scope">
											{{ isNull(scope.row.acountsName) }}
										</template>
									</el-table-column>
									<el-table-column label="账号" align="center" prop="bankNo">
										<template #default="scope">
											{{ isNull(scope.row.bankNo) }}
										</template>
									</el-table-column>
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="对方开户行" prop="otherBankName">
					<el-input v-model="form.otherBankName" placeholder="请输入对方开户行" disabled />
				</el-form-item>
			</el-row>
			<el-row v-if="value === '供应商'">
				<el-form-item label="对方账号(供应商)" prop="otherBankNo">
					<el-row>
						<el-col :span="14">
							<el-input v-model="form.otherBankNo" placeholder="请选择" disabled />
						</el-col>
						<el-col v-if="bankInputDisabled === false" :span="3">
							<SearchOption
								:get-data="listBankAccount"
								icon="el-icon-search"
								:limit-info="{ acountsType: '供应商' }"
								query-label="银行卡查找"
								query-info="bankNo"
								:query-name="queryCompany"
								@commitBack="handleCommitBack"
								@update:queryName="handleUpdateQueryName"
							>
								<template #table-columns>
									<el-table-column label="公司名称" align="center" prop="companyName">
										<template #default="scope">
											{{ isNull(scope.row.companyName) }}
										</template>
									</el-table-column>
									<el-table-column label="开户行" align="center" prop="bankName">
										<template #default="scope">
											{{ isNull(scope.row.bankName) }}
										</template>
									</el-table-column>
									<el-table-column label="开户名" align="center" prop="acountsName">
										<template #default="scope">
											{{ isNull(scope.row.acountsName) }}
										</template>
									</el-table-column>
									<el-table-column label="账号" align="center" prop="bankNo">
										<template #default="scope">
											{{ isNull(scope.row.bankNo) }}
										</template>
									</el-table-column>
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>

				<el-form-item label="对方开户行" prop="otherBankName">
					<el-input v-model="form.otherBankName" placeholder="请输入对方开户行" disabled />
				</el-form-item>
			</el-row>
			<el-row v-if="value === '司机'">
				<el-form-item label="对方账号(司机)" prop="otherBankNo">
					<el-row>
						<el-col :span="14">
							<el-input v-model="form.otherBankNo" placeholder="请选择" disabled />
						</el-col>
						<el-col v-if="bankInputDisabled === false" :span="3">
							<SearchOption
								:get-data="listBankAccount"
								icon="el-icon-search"
								:limit-info="{ acountsType: '司机' }"
								query-label="银行卡查找"
								query-info="bankNo"
								:query-name="queryCompany"
								@commitBack="handleCommitBack"
								@update:queryName="handleUpdateQueryName"
							>
								<template #table-columns>
									<el-table-column label="司机名称" align="center" prop="companyName">
										<template #default="scope">
											{{ isNull(scope.row.companyName) }}
										</template>
									</el-table-column>
									<el-table-column label="开户行" align="center" prop="bankName">
										<template #default="scope">
											{{ isNull(scope.row.bankName) }}
										</template>
									</el-table-column>
									<el-table-column label="开户名" align="center" prop="acountsName">
										<template #default="scope">
											{{ isNull(scope.row.acountsName) }}
										</template>
									</el-table-column>
									<el-table-column label="账号" align="center" prop="bankNo">
										<template #default="scope">
											{{ isNull(scope.row.bankNo) }}
										</template>
									</el-table-column>
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="对方开户行" prop="otherBankName">
					<el-input v-model="form.otherBankName" placeholder="请输入对方开户行" disabled />
				</el-form-item>
			</el-row>

			<el-row v-if="value === '员工'">
				<el-form-item label="对方账号(员工)" prop="otherBankNo">
					<el-row>
						<el-col :span="14">
							<el-input v-model="form.otherBankNo" placeholder="请选择" disabled />
						</el-col>
						<el-col v-if="bankInputDisabled === false" :span="3">
							<SearchOption
								:get-data="listBankAccount"
								icon="el-icon-search"
								:limit-info="{ acountsType: '员工' }"
								query-label="银行卡查找"
								query-info="bankNo"
								:query-name="queryCompany"
								@commitBack="handleCommitBack"
								@update:queryName="handleUpdateQueryName"
							>
								<template #table-columns>
									<el-table-column label="员工名称" align="center" prop="companyName">
										<template #default="scope">
											{{ isNull(scope.row.companyName) }}
										</template>
									</el-table-column>
									<el-table-column label="开户行" align="center" prop="bankName">
										<template #default="scope">
											{{ isNull(scope.row.bankName) }}
										</template>
									</el-table-column>
									<el-table-column label="开户名" align="center" prop="acountsName">
										<template #default="scope">
											{{ isNull(scope.row.acountsName) }}
										</template>
									</el-table-column>
									<el-table-column label="账号" align="center" prop="bankNo">
										<template #default="scope">
											{{ isNull(scope.row.bankNo) }}
										</template>
									</el-table-column>
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="对方开户行" prop="otherBankName">
					<el-input v-model="form.otherBankName" placeholder="请输入对方开户行" disabled />
				</el-form-item>
			</el-row>

			<el-form-item label="付款原因" prop="reason">
				<el-input v-model="form.reason" type="textarea" placeholder="请输入内容" />
			</el-form-item>
			<el-form-item label="附件" prop="attachment">
				<file-upload @input="handleCommitUpload" />
			</el-form-item>
			<el-form-item label="备注" prop="comments">
				<el-input v-model="form.comments" placeholder="请输入备注" />
			</el-form-item>
		</el-form>
		<div slot="footer" class="dialog-footer" style="text-align: center">
			<!--			<el-button @click="handleProcess" v-if="isOtherButtonDisabled">保存修改</el-button>-->
			<el-button type="primary" @click="submitForm" v-if="!isOtherButtonDisabled">提交申请</el-button>
			<el-button @click="close" v-if="!isOtherButtonDisabled">关闭并保存</el-button>
			<el-button @click="clear" v-if="!isOtherButtonDisabled">取消填写</el-button>
			<!--			<el-button @click="saveForm">保存</el-button>-->
		</div>
	</div>
</template>

<script>
import { listPaymentApply, addPaymentApply, updatePaymentApply } from '@/api/system/paymentApply';
import { excludeParams } from '@/api/tool/exclude';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import { mixin_payment_apply } from '../../mixins/apply_payment/payment_apply';
import { mixin_payment_level } from '../../mixins/apply_payment/payment_level';
import { mixin_payment_watcher } from '../../mixins/apply_payment/payment_watcher';

import { listCompany } from '../../../../api/system/company';
import { mixin_payment_fill } from '../../mixins/apply_payment/payment_fill';
import { isNull } from '../../../../main';
import { mixin_receive_money_subject } from '../../mixins/receivemoney/receive_money_subject';

export default {
	name: 'ApplyPayment',
	components: { SearchOption },
	mixins: [mixin_payment_apply, mixin_payment_level, mixin_payment_watcher, mixin_payment_fill, mixin_receive_money_subject],
	data() {
		return {
			// 遮罩层
			loading: true,
			// 总条数
			total: 0,
			// 付款信息表格数据
			paymentApplyList: [],
			// 表单参数
			form: {
				tID: null,
				tableName: null,
				fundsDate: new Date(),
				payType: null,
				moneyAmount: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				reason: null,
				attachment: null,
				applyPerson: null,
				applyPersonID: null,
				checkState: null,
				comments: null
			},
			// 表单校验
			rules: {
				fundsDate: [{ required: true, message: '付款日期不能为空', trigger: 'blur' }],
				moneyAmount: [{ required: true, message: '付款金额不能为空', trigger: 'blur' }],
				reason: [{ required: true, message: '付款事由不能为空', trigger: 'blur' }]
			},
			// 禁用输入框
			inputDisabled: false,
			// 禁用银行卡输入 因为现金支付不需要银行卡信息
			bankInputDisabled: false,
			// 本地存储的 key
			localStorageKey: 'paymentApplyForm',
			// 下拉框选项
			options: [
				{ value: '客户', label: '客户' },
				{ value: '供应商', label: '供应商' },
				{ value: '司机', label: '司机' },
				{ value: '员工', label: '员工' },
				{ value: '对外付款', label: '对外付款' }
			],
			value: '', // 对方类型
			queryOther: '', // 其他搜索参数
			queryCompany: '' // 公司搜索参数
		};
	},
	watch: {
		value(newValue) {
			// 当对方类型改变时，清空之前选择的公司和银行卡信息
			if (this.form.companyType !== newValue) {
				this.form.companyName = null;
				this.form.companyId = null;
				this.form.otherBankNo = null;
				this.form.otherBankName = null;
			}
		}
	},
	mounted() {
		this.loadForm();
	},
	beforeUnmount() {
		this.saveForm();
	},
	methods: {
		isNull,
		listCompany,
		listBankAccount,
		// 上传的回调函数
		handleCommitUpload(val) {
			this.form.attachment = val;
		},
		getList() {
			this.loading = true;
			listPaymentApply(this.queryParams).then(response => {
				this.paymentApplyList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		handleOpponentTypeChange(value) {
			// 当对方类型改变时，触发相应的逻辑，例如清空某些字段
			console.log('对方类型 changed to:', value);
		},
		handleUpdateQueryNameOther(val) {
			this.queryOther = val;
		},
		handleCommitBackOther(row) {
			this.form.companyName = row.companyName;
			this.form.companyId = row.id;
		},
		handleUpdateQueryName(val) {
			this.queryCompany = val;
		},
		handleCommitBack(row) {
			this.form.otherBankNo = row.bankNo;
			this.form.otherBankName = row.bankName;
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 如果是多个付款审核 需要把信息返回给父组件进行使用 这种情况只有不在弹窗中才会使用其他情况没有
					if (this.isMulti) {
						this.$message.success('付款申请提交成功');
						this.$emit('getApplyPayment', this.form);
						this.$emit('changeOpen');
						return;
					}
					// 填充对应表名和主键
					if (!this.tableName || !this.tID) {
						this.$message.error('系统错误:付款时没有表名和表对应ID');
						return;
					}
					// 添加付款类型
					if (!this.form.payType) {
						this.$modal.msgError('请选择付款类型');
						return;
					}
					excludeParams(this, this.$exclude);
					this.form.tableName = this.tableName;
					this.form.tID = this.tID;
					this.form.checkState = ''; // 审核状态赋空
					this.form.companyType = this.value;
					const payType = this.form.payType.join('-');
					const body = { ...this.form, payType: payType };
					addPaymentApply(body).then(() => {
						this.$modal.msgSuccess('付款申请添加成功');
						this.reset();
						// 提交成功后删除本地的缓存
						this.clearForm();
						this.$emit('changeOpen');
					});
				}
			});
		},
		// 提交到数据库 但是状态是待提交
		submitAndUpdate() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						if (!this.tableName || !this.tID) {
							this.$message.error('系统错误:付款时没有表名和表对应ID');
							return;
						}
						// 填充公司类型
						if (!this.extraInformation.__companyType) {
							this.$message.error('请选择公司类型!');
							return;
						}
						// 添加付款类型
						if (!this.form.payType) {
							this.$modal.msgError('请选择付款类型');
							return;
						}
						this.form.companyType = this.extraInformation.__companyType;
						// 填充对应表名和主键
						this.form.tableName = this.tableName;
						this.form.tID = this.tID;
						const payType = this.form.payType.join('-');
						const body = { ...this.form, payType: payType };
						updatePaymentApply(body).then(() => {
							this.$modal.msgSuccess('付款申请保存成功,点击提交并审核可提交信息至审核流程');
							this.reset();
						});
					} else {
						this.$message.error('系统错误:付款时没有主键');
					}
				}
			});
		},
		close() {
			this.$emit('changeOpen');
			this.saveForm();
			this.reset();
		},
		clear() {
			this.$emit('changeOpen');
			this.clearForm();
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				tableName: null,
				tID: null,
				fundsDate: new Date(),
				payType: null,
				moneyAmount: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				reason: null,
				attachment: null,
				applyPerson: null,
				applyPersonID: null,
				checkState: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				submitflag: null
			};
			this.value = ''; // 重置对方类型
			this.currentSort = { levelOne: '', levelTwo: '' };
			this.resetForm('form');
		},
		// 保存表单数据到 localStorage
		saveForm() {
			try {
				localStorage.setItem(this.localStorageKey, JSON.stringify(this.form));
				localStorage.setItem('paymentApplyFormOpponentType', this.value); // 保存对方类型
				this.$message.success('表单信息已保存');
			} catch (error) {
				console.error('保存表单信息失败', error);
				this.$message.error('保存表单信息失败');
			}
		},
		// 清除本地保存的数据
		clearForm() {
			try {
				localStorage.removeItem(this.localStorageKey);
				localStorage.removeItem('paymentApplyFormOpponentType');
				this.$message.success('已清除上次填写的数据');
			} catch (error) {
				console.error('清除表单信息失败', error);
				this.$message.error('清除表单信息失败');
			}
		},
		// 从 localStorage 加载表单数据
		loadForm() {
			try {
				const savedForm = localStorage.getItem(this.localStorageKey);
				const savedOpponentType = localStorage.getItem('paymentApplyFormOpponentType');
				if (savedForm) {
					this.form = JSON.parse(savedForm);
					this.$message.success('已读取上次填写的数据');
				}
				if (savedOpponentType) {
					this.value = savedOpponentType;
				}
			} catch (error) {
				console.error('加载表单信息失败', error);
			}
		},
		handleProcess() {
			this.submitAndUpdate();
		},
		handleReject() {}
	}
};
</script>
