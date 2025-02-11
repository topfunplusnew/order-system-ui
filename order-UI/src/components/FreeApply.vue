<!--运费申请 根据字段判断海运陆运-->
<script>
import { addOrderFreight } from '@/api/system/orderFreight';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { listBankAccount } from '@/api/system/bankAccount';
import { getCars } from '@/api/system/cars';
import { parseTime } from '@/utils/ruoyi';
import { mapGetters } from 'vuex';

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
					{ required: true, message: '请输入对方户名', trigger: 'blur' }
				],
				otherBankNo: [
					{ required: true, message: '请输入对方账号', trigger: 'blur' }
				],
				otherBankName: [
					{ required: true, message: '请输入对方开户行', trigger: 'blur' }
				],
				payDate: [
					{ required: true, message: '请选择支付日期', trigger: 'blur' }
				]
			}
		};
	},
	computed: {
		...mapGetters(['trueName'])
	},
	watch: {
		'orderInfo.driverId': {
			handler(val) {
				getCars(val).then(res => {
					// 自动填充司机信息
					this.$nextTick(() => {
						this.form.otherAcountsName = res.data.acountsName;
						this.form.otherBankNo = res.data.bankNo;
						this.form.otherBankName = res.data.bankName;
					});
				});
			},
			deep: true
		}
	},
	// 因为dialog的销毁机制 所以需要组件创建时发一次请求自动填充，还需要监听id的变化再次发请求改变
	created() {
		this.reset();
		// 获取车辆信息 填充司机相关信息
		getCars(this.orderInfo.driverId).then(res => {
			this.$nextTick(() => {
				// 自动填充司机信息
				this.form.otherAcountsName = res.data.acountsName;
				this.form.otherBankNo = res.data.bankNo;
				this.form.otherBankName = res.data.bankName;
			});
		});
	},

	methods: {
		listBankAccount,
		listCompany,
		// 提交运费信息
		handleProcess(that) {
			// this.orderInfo就是父组件传递过来的组装的运费信息
			Object.assign(this.form, this.orderInfo);
			// 发送请求 添加运费信息 applyDate为现在
			const query = {
				...this.form,
				applyDate: parseTime(new Date()),
				applyUserName: this.trueName
			};
			// 添加运费信息
			addOrderFreight(query).then(() => {
				this.$message.success('操作成功');
				this.reset();
				that.dialogVisible = false;
			});
		},
		// 选择银行卡 自动填充相关信息
		handleCommitBack(val) {
			this.form.otherAcountsName = val.acountsName;
			this.form.otherBankName = val.bankName;
			this.form.otherBankNo = val.bankNo;
		},
		// 搜索字段的自动填充
		handleChange(val) {
			this.queryAcountsName = val;
		},
		reset() {
			this.form = {
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				payDate: null,
				comments: null,
				content: null
			};
		},
		handleReject() {}
	}
};
</script>

<template>
	<div>
		<el-form ref="form" :model="form" label-width="80px" :rules="rules">
			<el-form-item label="对方户名" prop="otherAcountsName">
				<el-row>
					<el-col :span="10">
						<el-input
							disabled
							v-model="form.otherAcountsName"
							placeholder="请选择"
						/>
					</el-col>
					<el-col :span="4">
						<!--搜索银行卡信息-->
						<SearchOption
							:limit-info="{
								companyType: '司机',
								acountsName: this.orderInfo.otherAcountsName
							}"
							:get-data="listBankAccount"
							query-label="户名搜索"
							query-info="acountsName"
							:query-name="queryAcountsName"
							@commitBack="handleCommitBack"
							@update:queryName="handleChange"
						>
							<template #table-columns>
								<el-table-column
									label="开户行"
									align="center"
									prop="bankName"
								/>
								<el-table-column
									label="开户名"
									align="center"
									prop="acountsName"
								/>
								<el-table-column label="账号" align="center" prop="bankNo" />
								<el-table-column
									label="余额"
									align="center"
									prop="surplusMoney"
								/>
							</template>
						</SearchOption>
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
				<el-date-picker
					v-model="form.payDate"
					type="datetime"
					placeholder="选择日期"
					value-format="yyyy-MM-dd HH:mm:ss"
				/>
			</el-form-item>
			<el-form-item label="备注信息">
				<el-input v-model="form.content" placeholder="请输入备注信息" />
			</el-form-item>
			<el-form-item label="附加备注">
				<el-input v-model="form.comments" placeholder="请输入附加备注" />
			</el-form-item>
		</el-form>
	</div>
</template>

<style scoped lang="scss"></style>
