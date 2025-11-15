<template>
	<div>
		<el-row>
			<el-form ref="invoiceForm" :model="form" label-width="110px" :rules="CheckRules.updateOrderItemVisibleTitleRules">
				<el-form-item label="开票日期" prop="invoiceDate">
					<el-date-picker v-model="form.invoiceDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss" />
				</el-form-item>
				<el-form-item label="我方开票实体" prop="invoiceObject">
					<el-input v-model="form.invoiceObject" placeholder="请输入我方开票实体" />
				</el-form-item>
				<el-form-item label="开票金额" prop="invoiceAmount">
					<el-input v-model="form.invoiceAmount" placeholder="请输入开票金额" />
				</el-form-item>
				<el-form-item label="公司名称" prop="companyName">
					<el-row>
						<el-col :span="10">
							<el-input v-model="form.companyName" placeholder="请输入对方公司名称" />
						</el-col>
						<el-col :span="2">
							<SearchOption
								:limit-info="invoiceInfo.domain === 1 ? { companyType: '客户' } : { companyType: '供应商' }"
								:get-data="listCompany"
								query-info="companyName"
								query-label="公司名称"
								:query-name="queryCompanyName"
								@update:queryName="handleUpdateCompanyName"
								@commitBack="handleCommitBackCompany"
							>
								<template #table-columns>
									<el-table-column :label="invoiceInfo.domain === 1 ? '客户' : '供应商'" align="center" prop="relationName"></el-table-column>
									<el-table-column label="老板姓名" align="center" prop="leader" />
									<el-table-column label="老板电话" align="center" prop="leaderTel" />
									<el-table-column label="区域" align="center" prop="region" />
									<el-table-column label="公司名称" align="center" prop="companyName" />
									<el-table-column label="销售经理" align="center" prop="salesManager" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="票据单位名称" prop="invoiceCompanyName">
					<el-input v-model="form.invoiceCompanyName" placeholder="请输入票据单位名称" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
			</el-form>
		</el-row>
	</div>
</template>

<script>
import SearchOption from '@/components/SearchOption.vue';
import { addInvoiceIn } from '@/api/system/invoiceIn';
import { checkOrderAllinvoice } from '@/api/system/goodsOrder';
import { addInvoiceOut } from '@/api/system/invoiceOut';
import { excludeParams } from '@/api/tool/exclude';
import { listCompany } from '@/api/system/company';
import { fix } from '@/api/tool/format';
import { PUBLIC_DICT_TYPE } from '../../../../utils/order';

export default {
	name: 'Invoice',
	components: { SearchOption },
	props: {
		// 最大开票金额
		maxInvent: {
			type: Number,
			default: 0
		},
		invoiceInfo: {
			type: Object,
			default() {
				return {};
			}
		}
	},
	data() {
		return {
			form: {},
			CheckRules: {
				// 开票信息校验
				updateOrderItemVisibleTitleRules: {
					invoiceDate: [
						{
							required: true,
							message: '请选择开票日期',
							trigger: 'blur'
						}
					],
					invoiceObject: [
						{
							required: true,
							message: '请输入开票实体',
							trigger: 'blur'
						}
					],
					invoiceCompanyName: [
						{
							required: true,
							message: '请输入票据单位名称',
							trigger: 'blur'
						}
					],
					invoiceAmount: [
						{
							required: true,
							message: '请输入开票金额',
							trigger: 'blur'
						},
						{
							pattern: /^-?[0-9]+(\.[0-9]+)?$/,
							message: '只能输入数字和小数',
							trigger: 'blur'
						}
					],
					companyName: [
						{
							required: true,
							message: '请输入公司名称',
							trigger: 'blur'
						}
					],
					ticketPoint: [
						{
							required: true,
							message: '请输入开票点',
							trigger: 'blur'
						},
						{
							pattern: /^-?[0-9]+(\.[0-9]+)?$/,
							message: '只能输入数字',
							trigger: 'blur'
						}
					],
					ticketPointAmount: [
						{
							required: true,
							message: '请输入票点金额',
							trigger: 'blur'
						},
						{
							pattern: /^-?[0-9]+(\.[0-9]+)?$/,
							message: '只能输入数字',
							trigger: 'blur'
						}
					]
				}
			},
			queryCompanyName: ''
		};
	},
	computed: {
		companyName() {
			return this.invoiceInfo.companyName || this.form.companyName;
		},
		companyType() {
			return this.invoiceInfo.companyType || this.form.companyType;
		},
		companyID() {
			return this.invoiceInfo.companyID || this.form.companyID;
		},
		invoiceAmount() {
			return this.invoiceInfo.invoiceAmount || this.form.invoiceAmount;
		}
	},
	watch: {
		// 监听开票金额不能超过总货款
		form: {
			handler() {
				// 不能超越货款
				if (this.form.ticketPointAmount > this.maxInvent) {
					this.$modal.msgError('客户开票金额不能超过订单总货款');
					this.resetMoney();
				}
				// 填充票点金额
				this.form.ticketPointAmount = fix(Number(this.form.ticketPoint) * Number(this.form.invoiceAmount));
			},
			deep: true
		}
	},
	created() {
		this.resetOpenTitleInfo();
	},
	mounted() {
		// 填充表单的公司信息
		this.form.companyName = this.companyName;
	},
	methods: {
		listCompany,
		handleUpdateCompanyName(val) {
			this.queryCompanyName = val;
		},
		handleCommitBackCompany(val) {
			this.form.companyName = val.companyName;
			this.form.companyID = val.id;
			this.form.companyType = val.companyType;
		},
		// 作为表单的子元素必须要重写该方法
		handleProcess(that) {
			// 先进行表单验证
			return new Promise((resolve, reject) => {
				this.$refs.invoiceForm.validate(valid => {
					if (!valid) {
						this.$message.error('请完善表单信息');
						reject('表单验证失败');
						return;
					}
					// 去除参数
					this.form = excludeParams(this.form, this.$exclude);
					let total_out = 0,
						total_in = 0;
					// 客户开票 domain = 1
					if (this.invoiceInfo.domain === 1) {
						const query = {
							id: this.invoiceInfo.isOrderTax,
							companyType: PUBLIC_DICT_TYPE.CUSTOMER,
							// 后端需要传 companyId
							companyId: this.companyID
						};
						// 先检查一下可不可以开票 即检查是否超过钱
						checkOrderAllinvoice(query)
							.then(res => {
								if (!res.data) {
									this.$message.error('检查开票时发现暂无数据');
									reject('检查开票失败');
									return;
								}
								total_out = res.data.totalAmount || 0;
								if (Number(this.form.invoiceAmount) + total_out > this.maxInvent) {
									this.$message.error('累计开票金额超过总货款，请修改开票金额！');
									this.resetMoney();
									reject('开票金额超限');
									return;
								}
								// 组装开票实体
								const body = {
									...this.form,
									...this.invoiceInfo
								};
								// 添加发票卖出
								addInvoiceOut(body)
									.then(() => {
										this.resetOpenTitleInfo();
										that.dialogVisible = false;
										this.$message.success('客户开票成功~');
										resolve();
									})
									.catch(error => {
										reject(error);
									});
							})
							.catch(error => {
								reject(error);
							});
						// 供应商开票 domain = 2
					} else {
						const query = {
							id: this.invoiceInfo.isOrderTax,
							companyType: PUBLIC_DICT_TYPE.SUPPLIER,
							// 后端需要传 companyId
							companyId: this.companyID
						};
						checkOrderAllinvoice(query)
							.then(res => {
								if (!res.data) {
									this.$message.error('检查开票时发现暂无数据');
									reject('检查开票失败');
									return;
								}
								total_in = res.data.totalAmount || 0;
								if (Number(this.form.invoiceAmount) + total_in > this.maxInvent) {
									this.$message.error('累计开票金额超过出厂货款，请修改开票金额！');
									this.resetMoney();
									reject('开票金额超限');
									return;
								}
								const body = {
									...this.form,
									...this.invoiceInfo
								};
								// 添加发票买入
								addInvoiceIn(body)
									.then(() => {
										this.resetOpenTitleInfo();
										that.dialogVisible = false;
										this.$message.success('供应商开票成功~');
										resolve();
									})
									.catch(error => {
										reject(error);
									});
							})
							.catch(error => {
								reject(error);
							});
					}
				});
			});
		},
		// 重写关闭逻辑
		handleReject() {
			return Promise.resolve();
		},
		resetMoney() {
			this.form.invoiceAmount = 0;
			this.form.ticketPoint = 0;
			this.form.ticketPointAmount = 0;
		},
		resetOpenTitleInfo() {
			this.form = {
				id: null,
				invoiceDate: null,
				invoiceObject: null,
				invoiceAmount: 0,
				companyType: null,
				companyName: null,
				companyID: null,
				invoiceCompanyName: null,
				ticketPoint: 0,
				ticketPointAmount: 0,
				isOrderTax: 0,
				comments: null
			};
		}
	}
};
</script>
