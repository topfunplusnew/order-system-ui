<template>
	<div>
		<el-card class="box-card">
			<div slot="header" class="clearfix">
				<span>申请列表</span>
				<div style="float: right">
					<el-button size="small" type="primary" @click="handleApprove">统一填写申请</el-button>
				</div>
			</div>

			<el-table :data="localApplications" style="width: 100%" size="mini">
				<el-table-column fixed prop="fundsDate" label="日期" width="150" show-overflow-tooltip></el-table-column>
				<el-table-column prop="payType" label="支付类型" width="150" show-overflow-tooltip></el-table-column>
				<el-table-column prop="moneyAmount" label="金额" width="120" show-overflow-tooltip></el-table-column>
				<el-table-column prop="otherBankNo" label="对方账号" width="300" show-overflow-tooltip></el-table-column>
				<el-table-column prop="companyName" label="对方公司" width="120" show-overflow-tooltip></el-table-column>
				<el-table-column prop="reason" label="付款原因" width="120" show-overflow-tooltip></el-table-column>
				<el-table-column prop="comments" label="备注" width="120" show-overflow-tooltip></el-table-column>
			</el-table>
		</el-card>

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false"
			:show-close="false" title="付款申请" :visible.sync="applyDialogVisible" width="45%" append-to-body>
			<keep-alive>
				<ApplyPayment :money-input-disabled="false" :table-name="TableName.ORDERCOMMISION" :t-i-d="tid"
					:need-money="needMoney" :need-info="needInfo" @changeOpen="() => (applyDialogVisible = false)"
					:is-multi="true" @getApplyPayment="handleCommitApplyInfo" />
			</keep-alive>
		</el-dialog>
	</div>
</template>

<script>
// 审核个体
import { TableName } from '@/api/tool/enums';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import { mixin_checkfile } from '@/views/dashboard/mixins/checkfiles/mixin_checkfile';
import { addPaymentApply } from '@/api/system/paymentApply';
import DynamicField from '../../../../components/DynamicField.vue';
import { mapGetters } from 'vuex/dist/vuex.common.js';

export default {
	name: 'OncePaymentApply',
	mixins: [mixin_checkfile],
	computed: {
		TableName() {
			return TableName;
		},
		...mapGetters(['id', 'trueName'])
	},
	props: {
		applications: {
			type: Array,
			default: () => [
				{
					fundsDate: '2024-08-01',
					payType: '测试银行转账',
					moneyAmount: 5000.0,
					otherBankNo: '6222 8888 1234 5678',
					companyName: '油卡充钱',
					reason: '加油费用',
					applyPerson: '李明',
					comments: '无',
					attachments: 'invoice_001.pdf'
				}
			]
		}
	},
	components: { ApplyPayment, DynamicField },
	data() {
		return {
			applyDialogVisible: false,
			tid: null,
			needMoney: 0,
			needInfo: {},
			currentId: null,
			localApplications: [] // 添加本地数据副本
		};
	},
	watch: {
		applications: {
			handler(newVal) {
				this.localApplications = JSON.parse(JSON.stringify(newVal)); // 深拷贝
			},
			immediate: true,
			deep: true
		}
	},
	methods: {
		handleApprove() {
			this.applyDialogVisible = true;
		},
		// 这里需要把审核组件的信息提交到列表里
		handleCommitApplyInfo(value) {
			console.log(`付款申请审核信息`, value);
			this.$nextTick(() => {
				this.localApplications.forEach(item => {
					Object.assign(item, value);
				});
				this.$message.success('申请信息已更新');
			});
		},
		handleProcess(that) {
			if (this.localApplications.length === 0) {
				this.$message.error('申请列表为空!');
				return;
			}

			try {
				// 处理payType数组转字符串
				this.localApplications.forEach(item => {
					if (Array.isArray(item.payType)) {
						item.payType = item.payType.join('-');
					}
				});
			} catch (err) {
				this.$message.error('请先填写申请信息!');
				return;
			}

			this.$antdconfirm({
				title: '提示',
				content: '确定批量申请吗？',
				okText: '确定',
				cancelText: '取消',
				type: 'warning',
				zIndex: 2600,
				onOk: async () => {
					try {
						// 使用优化后的数据转换逻辑
						const firstApplication = this.localApplications[0];
						const currentTime = new Date().toISOString().slice(0, 19).replace('T', ' ');

						// 构建新的数据结构
						const data = {
							fundsDate: firstApplication.fundsDate || currentTime,
							payType: firstApplication.payType || '',
							moneyAmount: parseFloat(firstApplication.moneyAmount) || 0,
							otherAccountsName: firstApplication.otherAcountsName || '', // 注意字段名变化
							otherBankNo: firstApplication.otherBankNo || '',
							otherBankName: firstApplication.otherBankName || '',
							companyName: firstApplication.companyName || '',
							companyId: firstApplication.companyId || null,
							companyType: firstApplication.companyType || '',
							reason: firstApplication.reason || '',
							applyPerson: firstApplication.applyPerson || '',
							applyPersonId: firstApplication.applyPersonID || null, // 注意字段名变化
							comments: firstApplication.comments || '',
							addTime: currentTime,
							userId: this.id || '',
							userName: this.trueName || '',
							// 转换extraInfo为tableReferences
							tableReferences: firstApplication.extraInfo && firstApplication.extraInfo.sourceInfos
								? firstApplication.extraInfo.sourceInfos.map(source => ({
									refTableName: source.tableName,
									refTableId: source.tableId,
									amount: parseFloat(firstApplication.moneyAmount) || 0
								}))
								: []
						};

						// 数据验证
						if (!data.fundsDate || !data.moneyAmount || data.moneyAmount <= 0) {
							this.$message.error('请完善申请信息！');
							return;
						}

						if (data.tableReferences.length === 0) {
							this.$message.error('申请数据异常，请重试！');
							return;
						}

						await addPaymentApply(data);
						this.$message.success('一键申请成功');
						this.dialogVisible = false;
					} catch (error) {
						console.error('申请失败:', error);
						this.$message.error('申请失败，请重试');
					}
				},
				onCancel: () => {
					this.$message.info('已取消批量申请');
				}
			});
		},
		handleReject() { }
	}
};
</script>
