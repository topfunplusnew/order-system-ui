<!-- 银行卡管理组件 -->
<template>
	<div class="bank-manage-container">
		<el-form :model="currentInfo">
			<el-row :gutter="4" style="text-align: center">
				<span style="font-weight: bolder; font-size: 18px">
					{{ currentInfo.companyName }}
				</span>
			</el-row>
		</el-form>
		<br />
		<el-divider>已绑定银行卡</el-divider>

		<!-- 客户的银行卡列表 -->
		<el-row>
			<el-table v-loading="loading" :data="singleInfo" class="table-container">
				<!-- 为本公司绑定银行卡 -->
				<template #append>
					<AddBankAccounts :company-info="currentInfo" @callGetList="handleRefresh" />
				</template>
				<el-table-column label="户名" align="center" prop="acountsName" />
				<el-table-column label="银行卡号" align="center" prop="bankNo" />
				<el-table-column label="银行卡余额" align="center" prop="amount" />
				<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
					<template slot-scope="scope">
						<el-button v-hasPermi="['system:company:remove']" size="mini" type="danger" @click="handleDeleteBank(scope.row)">
							<i class="el-icon-delete"></i>
							删除
						</el-button>
						<el-button size="mini" type="primary" @click="handleSearchBank">搜索银行卡</el-button>
					</template>
				</el-table-column>
			</el-table>
		</el-row>

		<pagination v-show="bankTotal > 0" :total="bankTotal" :page.sync="bankPageNum" :limit.sync="bankPageSize" @pagination="getBankList" />
	</div>
</template>

<script>
import { delBankAccount, listBankAccount } from '@/api/system/bankAccount';
import { updateCompany } from '@/api/system/company';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import AddBankAccounts from '../../../dashboard/components/company/AddBankAccounts.vue';
import BankSearch from './BankSearch.vue';

export default {
	name: 'BankManage',
	components: { AddBankAccounts },
	mixins: [common_dialog],
	props: {
		// 当前公司信息
		companyInfo: {
			type: Object,
			default: () => ({})
		}
	},
	data() {
		return {
			loading: false,
			currentInfo: {},
			singleInfo: [],
			bankTotal: 0,
			bankPageSize: 20,
			bankPageNum: 1
		};
	},
	watch: {
		companyInfo: {
			handler(newVal) {
				if (newVal && newVal.id) {
					this.currentInfo = { ...newVal };
					this.getBankList();
				}
			},
			immediate: true,
			deep: true
		}
	},
	methods: {
		handleProcess() {},
		handleReject() {},
		/**
		 * 查询已经绑定的银行卡信息
		 */
		getBankList() {
			if (!this.currentInfo.id) return;

			this.loading = true;
			listBankAccount({
				companyId: this.currentInfo.id,
				acountsType: '客户',
				pageNum: this.bankPageNum,
				pageSize: this.bankPageSize
			})
				.then(res => {
					this.singleInfo = res.rows;
					this.bankTotal = res.total;
					this.loading = false;
				})
				.catch(() => {
					this.loading = false;
				});
		},

		/**
		 * 删除银行卡
		 * @param {Object} row 银行卡信息
		 */
		handleDeleteBank(row) {
			this.$modal
				.confirm('是否确认删除该银行卡？')
				.then(() => {
					return delBankAccount(row.id);
				})
				.then(() => {
					this.$message.success('删除成功');
					this.getBankList();
					this.$emit('refresh');
				})
				.catch(() => {});
		},

		/**
		 * 打开银行卡搜索弹窗
		 */
		handleSearchBank() {
			this.openDialog(
				BankSearch,
				'搜索银行卡',
				'60%',
				{
					companyInfo: this.currentInfo
				},
				false
			).then(() => {
				// 弹窗关闭后刷新数据
				this.getBankList();
			});
		},

		/**
		 * 刷新数据
		 */
		handleRefresh() {
			this.getBankList();
			this.$emit('refresh');
		},

		/**
		 * 处理银行卡添加
		 * @param {Object} bankData 银行卡数据
		 */
		handleAddBank(bankData) {
			this.currentInfo.bankNo = bankData.bankNo;
			this.currentInfo.bankName = bankData.bankName;
			this.currentInfo.acountsName = bankData.acountsName;

			updateCompany(this.currentInfo)
				.then(() => {
					this.$message.success('添加成功');
					this.getBankList();
					this.$emit('refresh');
				})
				.catch(() => {
					this.$message.error('添加失败');
				});
		}
	},

	created() {
		// 注册全局事件监听
		this.$on('add-bank', this.handleAddBank);
	},

	beforeDestroy() {
		// 清理事件监听
		this.$off('add-bank', this.handleAddBank);
	}
};
</script>

<style scoped>
.bank-manage-container {
	padding: 10px;
}

.table-container {
	background-color: #fff;
	border-radius: 5px;
	padding: 10px;
	margin-top: 15px;
}
</style>
