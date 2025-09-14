<template>
	<div class="offset-payment-dialog">
		<div class="offset-payment-body">
			<!-- 左侧：司机信息 -->
			<div class="offset-payment-info">
				<el-card class="box-card">
					<div slot="header" class="card-header">
						<span>冲抵款分组信息（按司机+银行卡分组）</span>
						<span class="total-amount-badge">总金额：{{ formatAmount(totalAmount) }}元</span>
					</div>
					<el-collapse v-model="activeNames">
						<el-collapse-item v-for="(group, groupKey) in groupedByDriverAndBank" :key="groupKey" :name="groupKey">
							<template slot="title">
								<div class="collapse-title">
									<span class="driver-info">司机：{{ group.driverName }} | 银行卡：{{ group.bankNo }}</span>
									<span class="amount-badge">{{ formatAmount(group.totalAmount) }}元</span>
								</div>
							</template>
							<el-descriptions :column="2" size="mini" border>
								<el-descriptions-item label="司机姓名">{{ group.driverName }}</el-descriptions-item>
								<el-descriptions-item label="司机ID">{{ group.driverId }}</el-descriptions-item>
								<el-descriptions-item label="账户名称">{{ group.accountName || '-' }}</el-descriptions-item>
								<el-descriptions-item label="银行账号">{{ group.bankNo || '-' }}</el-descriptions-item>
								<el-descriptions-item label="开户行">{{ group.bankName || '-' }}</el-descriptions-item>
								<el-descriptions-item label="分组金额">{{ formatAmount(group.totalAmount) }}</el-descriptions-item>
								<el-descriptions-item label="运费条数">{{ group.freights.length }}</el-descriptions-item>
							</el-descriptions>

							<el-divider content-position="left">运费明细</el-divider>
							<el-table :data="group.freights" size="mini" border>
								<el-table-column prop="carNo" label="车牌号" />
								<el-table-column prop="moneyAmount" label="金额" />
								<el-table-column prop="payDate" label="付款日期" />
								<el-table-column prop="freightType" label="运费类型" />
							</el-table>
						</el-collapse-item>
					</el-collapse>
				</el-card>
			</div>

			<!-- 右侧：冲抵款表单 -->
			<div class="offset-payment-form">
				<el-form ref="offsetForm" :model="offsetForm" :rules="offsetRules" label-width="120px" size="mini">
					<el-form-item label="交易时间" prop="transactionTime">
						<el-date-picker v-model="offsetForm.transactionTime" type="datetime" placeholder="选择交易时间" value-format="yyyy-MM-dd HH:mm:ss" style="width: 100%"></el-date-picker>
					</el-form-item>

					<el-form-item label="收入方类型">
						<el-radio v-model="offsetForm.targetCompanyType" label="司机">司机</el-radio>
					</el-form-item>

					<el-form-item label="支出方类型" prop="sourceCompanyType">
						<el-radio v-model="offsetForm.sourceCompanyType" label="客户">客户</el-radio>
						<el-radio v-model="offsetForm.sourceCompanyType" label="供应商">供应商</el-radio>
					</el-form-item>

					<el-form-item label="支出方" prop="sourceId">
						<el-row>
							<el-col :span="16">
								<el-input v-model="sourceCompanyName" placeholder="请选择支出方" disabled />
							</el-col>
							<el-col :span="8">
								<SearchOption
									:limit-info="{
										companyType: offsetForm.sourceCompanyType
									}"
									:get-data="listCompany"
									query-info="companyName"
									query-label="公司名称"
									:query-name="querySourceCompanyName"
									@update:queryName="handleUpdateSourceCompanyName"
									@commitBack="handleCommitBackSourceCompany"
								>
									<template #table-columns>
										<el-table-column label="公司名称" align="center" prop="companyName" />
										<el-table-column label="公司类型" align="center" prop="companyType" />
										<el-table-column label="老板姓名" align="center" prop="leader" />
										<el-table-column label="老板电话" align="center" prop="leaderTel" />
										<el-table-column label="区域" align="center" prop="region" />
										<el-table-column label="销售经理" align="center" prop="salesManager" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="支出方户名" prop="sourceAccountName">
						<el-row>
							<el-col :span="16">
								<el-input v-model="offsetForm.sourceAccountName" placeholder="请输入支出方户名" disabled />
							</el-col>
							<el-col :span="8">
								<SearchOption
									:limit-info="{
										acountsType: offsetForm.sourceCompanyType,
										companyId: offsetForm.sourceId
									}"
									:get-data="listBankAccount"
									query-info="acountsName"
									query-label="户名查找"
									:query-name="querySourceBankAccount"
									@update:queryName="handleUpdateQuerySourceBankAccount"
									@commitBack="handleCommitBackSourceBankAccount"
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
						</el-row>
					</el-form-item>
					<el-form-item label="支出方账号" prop="sourceBankNo">
						<el-input v-model="offsetForm.sourceBankNo" placeholder="请输入支出方账号" disabled />
					</el-form-item>
					<el-form-item label="支出方开户行" prop="sourceBankName">
						<el-input v-model="offsetForm.sourceBankName" placeholder="请输入支出方开户行" disabled />
					</el-form-item>
					<el-form-item label="备注" prop="remarks">
						<el-input v-model="offsetForm.remarks" type="textarea" :rows="3" placeholder="请输入备注"></el-input>
					</el-form-item>
				</el-form>
			</div>
		</div>
	</div>
</template>

<script>
import { addRecordBatch } from '@/api/system/record';
import { listBankAccount, getBankAccount } from '@/api/system/bankAccount';
import { listCompany } from '@/api/system/company';
import SearchOption from '@/components/SearchOption.vue';
import { mapGetters } from 'vuex';
import { TableName, PayType } from '../../../../api/tool/enums';
import _ from 'lodash';
import { add, bignumber } from 'mathjs';

export default {
	name: 'OffsetPaymentDialog',
	components: {
		SearchOption
	},
	props: {
		selectedFreights: {
			type: Array,
			required: true,
			default: () => []
		}
	},
	data() {
		return {
			activeNames: [],
			submitting: false,
			// 冲抵款表单数据
			offsetForm: {
				transactionTime: null,
				sourceCompanyType: '客户',
				targetCompanyType: '司机',
				sourceId: null,
				targetId: null,
				sourceAccountName: '',
				sourceBankNo: '',
				sourceBankName: '',
				targetAccountName: '',
				targetBankNo: '',
				targetBankName: '',
				amount: 0,
				remarks: '',
				referenceTableName: 'offsetting',
				userId: null,
				userName: '',
				params: {
					attachmentIds: []
				}
			},
			// 表单验证规则
			offsetRules: {
				transactionTime: [{ required: true, message: '请选择交易时间', trigger: 'change' }],
				sourceCompanyType: [{ required: true, message: '请选择支出方类型', trigger: 'change' }],
				sourceId: [{ required: true, message: '请选择支出方', trigger: 'change' }],
				sourceAccountName: [{ required: true, message: '请选择支出方户名', trigger: 'blur' }]
			},
			// 临时存储的公司名称
			sourceCompanyName: '',
			// 查询变量
			querySourceCompanyName: null,
			querySourceBankAccount: null
		};
	},
	computed: {
		...mapGetters(['id', 'trueName']),
		// 支付类型枚举
		PayType() {
			return PayType;
		},
		// 按司机分组的数据
		groupedDriverData() {
			return _.groupBy(this.selectedFreights, freight => freight.driverName || '未知司机');
		},
		// 总金额 - 使用高精度计算
		totalAmount() {
			const amounts = this.selectedFreights.map(freight => bignumber(freight.moneyAmount || 0));
			return Number(amounts.reduce((sum, amount) => add(sum, amount), bignumber(0)));
		},
		// 按司机ID和银行卡号分组的数据（用于批量新增冲抵款）
		groupedByDriverAndBank() {
			// 使用 lodash 按组合键分组
			const grouped = _.groupBy(this.selectedFreights, freight => {
				const driverId = freight.driverId || freight.otherDriverId;
				const bankNo = freight.otherBankNo;
				return `${driverId}_${bankNo}`;
			});

			// 转换分组数据结构，添加汇总信息
			return _.mapValues(grouped, (freights, groupKey) => {
				const firstFreight = freights[0];
				// 使用 mathjs 计算分组总金额
				const amounts = freights.map(freight => bignumber(freight.moneyAmount || 0));
				const totalAmount = Number(amounts.reduce((sum, amount) => add(sum, amount), bignumber(0)));

				return {
					driverId: firstFreight.driverId || firstFreight.otherDriverId,
					driverName: firstFreight.driverName || '未知司机',
					bankNo: firstFreight.otherBankNo,
					accountName: firstFreight.otherAcountsName,
					bankName: firstFreight.otherBankName,
					freights: freights,
					totalAmount: totalAmount
				};
			});
		}
	},
	created() {
		this.initData();
	},
	methods: {
		listBankAccount,
		getBankAccount,
		listCompany,
		// 支出方公司查询相关方法
		handleUpdateSourceCompanyName(value) {
			this.querySourceCompanyName = value;
		},
		handleCommitBackSourceCompany(value) {
			this.sourceCompanyName = value.companyName;
			this.offsetForm.sourceId = value.id;
		},
		// 支出方银行账户查询相关方法
		handleUpdateQuerySourceBankAccount(value) {
			this.querySourceBankAccount = value;
		},
		handleCommitBackSourceBankAccount(value) {
			// 使用 lodash 批量设置银行账户信息
			_.assign(this.offsetForm, {
				sourceAccountName: value.acountsName,
				sourceBankNo: value.bankNo,
				sourceBankName: value.bankName
			});
		},
		// 初始化数据
		async initData() {
			// 使用 lodash 批量设置表单数据
			_.assign(this.offsetForm, {
				transactionTime: this.$moment().format('YYYY-MM-DD HH:mm:ss'),
				userId: this.id,
				userName: this.trueName,
				amount: this.totalAmount
			});

			// 默认展开所有分组 - 使用 lodash 获取键
			this.activeNames = _.keys(this.groupedByDriverAndBank);
		},

		// 自动填充司机信息
		autoFillDriverInfo() {
			// 如果只有一个司机，自动填充该司机的信息
			const driverNames = Object.keys(this.groupedDriverData);
			if (driverNames.length === 1) {
				const driverName = driverNames[0];
				const driverGroup = this.groupedDriverData[driverName];

				// 如果司机数据中包含银行信息，自动填充
				if (driverGroup.length > 0) {
					const firstFreight = driverGroup[0];

					// 填充收入方基本信息
					this.offsetForm.targetId = firstFreight.driverId || null;
					this.offsetForm.targetAccountName = firstFreight.otherAcountsName || '';
					this.offsetForm.targetBankNo = firstFreight.otherBankNo || '';
					this.offsetForm.targetBankName = firstFreight.otherBankName || '';
				}
			}
		},

		// 计算司机总金额 - 使用高精度计算
		calculateDriverTotal(driverGroup) {
			const amounts = driverGroup.map(freight => bignumber(freight.moneyAmount || 0));
			const total = Number(amounts.reduce((sum, amount) => add(sum, amount), bignumber(0)));
			return total.toFixed(2);
		},

		// 格式化金额显示
		formatAmount(value) {
			if (!value && value !== 0) return '0.00';
			return Number(value).toFixed(2);
		},

		// 处理取消
		handleReject() {
			return Promise.resolve();
		},

		// 处理确认提交
		async handleProcess() {
			try {
				// 表单验证
				await this.$refs.offsetForm.validate();

				this.submitting = true;

				// 构造批量提交数据
				const batchSubmitData = this.buildBatchSubmitData();

				// 检查是否有数据需要提交
				if (batchSubmitData.length === 0) {
					this.$message.warning('没有可提交的冲抵款数据');
					return Promise.reject(new Error('没有可提交的冲抵款数据'));
				}

				// 批量提交到后端
				await addRecordBatch(batchSubmitData);

				this.$message.success(`成功提交 ${batchSubmitData.length} 条冲抵款记录`);

				return Promise.resolve();
			} catch (error) {
				console.error('提交失败:', error);
				this.$message.error(error.message || '提交失败，请重试');
				return Promise.reject(error);
			} finally {
				this.submitting = false;
			}
		},

		// 构造批量提交数据
		buildBatchSubmitData() {
			// 使用 lodash 的 map 方法遍历分组数据
			return _.map(this.groupedByDriverAndBank, group => {
				// 构建基础表单数据模板
				const baseFormData = _.pick(this.offsetForm, [
					'sourceBankNo',
					'sourceAccountName',
					'sourceBankName',
					'sourceCompanyType',
					'sourceId',
					'targetCompanyType',
					'transactionTime',
					'remarks',
					'userId',
					'userName'
				]);

				// 合并分组特定数据
				return _.assign(baseFormData, {
					amount: group.totalAmount,
					params: {
						attachmentIds: []
					},
					referenceTableId: 0,
					referenceTableName: TableName.CASH_RECORD,
					// 收入方信息（来自运费数据）
					targetBankNo: group.bankNo,
					targetAccountName: group.accountName,
					targetBankName: group.bankName,
					targetId: group.driverId,
					// 关联的运费信息
					tableReferences: _.map(group.freights, freight => ({
						refTableName: TableName.ORDER_FREIGHT,
						refTableId: freight.id,
						amount: Number(freight.moneyAmount || 0)
					}))
				});
			});
		}
	}
};
</script>

<style scoped>
.offset-payment-dialog {
	height: 100%;
}

.offset-payment-body {
	display: grid;
	grid-template-columns: 1.1fr 0.9fr;
	gap: 16px;
	height: 68vh;
	overflow: auto;
	padding-right: 4px;
}

.offset-payment-info,
.offset-payment-form {
	min-width: 0;
}

.offset-payment-info {
	height: 100%;
	overflow: auto;
	padding-right: 4px;
}

.offset-payment-form {
	height: 100%;
	display: flex;
	flex-direction: column;
	background: #fafafa;
	border-left: 1px solid #f0f0f0;
	padding-left: 12px;
}

.offset-payment-form .el-form {
	flex: 1;
	overflow: auto;
}

.offset-payment-submit {
	margin-top: auto;
	display: flex;
	justify-content: center;
	align-items: center;
	position: sticky;
	bottom: 0;
	background: linear-gradient(to top, rgba(250, 250, 250, 1), rgba(250, 250, 250, 0.92));
	padding: 10px 0 6px;
	border-top: 1px solid #eee;
}

.offset-payment-info ::v-deep .el-collapse-item__header {
	padding: 0 10px;
	font-size: 13px;
}

.offset-payment-info ::v-deep .collapse-title {
	display: flex;
	justify-content: space-between;
	align-items: center;
	width: 100%;
	padding-right: 8px;
}

.offset-payment-info ::v-deep .driver-info {
	flex: 1;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}

.offset-payment-info ::v-deep .amount-badge {
	color: rgb(255, 48, 48);
	padding: 2px 8px;
	border-radius: 12px;
	font-size: 12px;
	font-weight: 600;
	margin-left: 8px;
	flex-shrink: 0;
}

.offset-payment-info ::v-deep .el-card {
	border: 1px solid #f0f0f0;
	box-shadow: none;
}

.offset-payment-info ::v-deep .card-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	width: 100%;
}

.offset-payment-info ::v-deep .total-amount-badge {
	color: red;
	padding: 4px 12px;
	border-radius: 14px;
	font-size: 13px;
	font-weight: 600;
	flex-shrink: 0;
}

.offset-payment-info ::v-deep .el-card__body {
	padding: 10px 12px;
}

.offset-payment-info ::v-deep .el-descriptions__title {
	font-size: 14px;
}

.offset-payment-info ::v-deep .el-descriptions__label {
	color: #888;
	width: 88px;
}

@media (max-width: 1366px) {
	.offset-payment-body {
		grid-template-columns: 1fr;
		height: 75vh;
	}

	.offset-payment-form {
		border-left: none;
		border-top: 1px solid #f0f0f0;
		padding-top: 12px;
	}
}
</style>
