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
		<!-- 编辑银行卡对话框 -->
		<el-dialog title="编辑银行卡信息" :visible.sync="editBankDialogVisible" width="500px" :modal="true" :close-on-click-modal="false" :show-close="true" append-to-body>
			<el-form ref="editBankForm" :model="editBankForm" label-width="100px" :rules="editBankRules">
				<el-form-item label="公司名称" prop="companyName">
					<el-input v-model="editBankForm.companyName" placeholder="请输入公司名称" d></el-input>
				</el-form-item>
				<el-form-item label="账户类型" prop="acountsType">
					<el-select v-model="editBankForm.acountsType" placeholder="请选择账户类型" style="width: 100%">
						<el-option label="己方公司" value="己方公司"></el-option>
						<el-option label="客户" value="客户"></el-option>
						<el-option label="供应商" value="供应商"></el-option>
						<el-option label="司机" value="司机"></el-option>
						<el-option label="其他" value="其他"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="账户名" prop="acountsName">
					<el-input v-model="editBankForm.acountsName" placeholder="请输入账户名"></el-input>
				</el-form-item>
				<el-form-item label="银行卡号" prop="bankNo">
					<el-input v-model="editBankForm.bankNo" placeholder="请输入银行卡号"></el-input>
				</el-form-item>
				<el-form-item label="开户行" prop="bankName">
					<el-input v-model="editBankForm.bankName" placeholder="请输入开户行"></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer">
				<el-button @click="editBankDialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="saveEditBank">保 存</el-button>
			</div>
		</el-dialog>

		<!-- 客户的银行卡列表 -->
		<el-row>
			<el-table v-loading="loading" :data="singleInfo" class="table-container">
				<!-- 为本公司绑定银行卡 -->
				<template #append>
					<AddBankAccounts :company-info="currentInfo" :company-type="PUBLIC_DICT_TYPE.CUSTOMER" @callGetList="handleRefresh" />
				</template>
				<el-table-column label="户名" align="center" prop="acountsName" />
				<el-table-column label="银行卡号" align="center" prop="bankNo" />
				<el-table-column label="开户行" align="center" prop="bankName" />
				<el-table-column label="公司名称" align="center" prop="companyName" />
				<!-- 在操作列中添加修改按钮 -->
				<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
					<template slot-scope="scope">
						<el-button size="mini" type="primary" @click="handleEditBank(scope.row)">修改</el-button>
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
import { delBankAccount, listBankAccount, updateBankAccount } from '@/api/system/bankAccount';
import { updateCompany } from '@/api/system/company';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import AddBankAccounts from '../../../dashboard/components/company/AddBankAccounts.vue';
import BankSearch from './BankSearch.vue';
import { PUBLIC_DICT_TYPE } from '../../../../api/tool/enums';

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
			bankPageNum: 1,
			editBankDialogVisible: false,
			editBankForm: {
				id: null,
				companyName: '',
				acountsType: '',
				acountsName: '',
				bankNo: '',
				bankName: ''
			},
			editBankRules: {
				companyName: [{ required: true, message: '公司名称不能为空', trigger: 'blur' }],
				acountsType: [{ required: true, message: '账户类型不能为空', trigger: 'blur' }],
				acountsName: [{ required: true, message: '账户名不能为空', trigger: 'blur' }],
				bankNo: [{ required: true, message: '银行卡号不能为空', trigger: 'blur' }],
				bankName: [{ required: true, message: '开户行不能为空', trigger: 'blur' }]
			}
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
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		}
	},
	methods: {
		handleProcess() {
			return Promise.resolve();
		},
		handleReject() {
			return Promise.resolve();
		},
		/**
		 * 查询已经绑定的银行卡信息
		 */
		// 修改 getBankList 方法，使用当前选中的账户类型进行查询
		getBankList() {
			if (!this.currentInfo.id) return;

			this.loading = true;
			listBankAccount({
				companyId: this.currentInfo.id,
				acountsType: this.currentAccountType || '客户', // 使用当前选中的账户类型
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
		 * 编辑银行卡信息
		 * @param {Object} row 银行卡信息
		 */
		handleEditBank(row) {
			this.editBankForm = {
				id: row.id,
				companyName: this.currentInfo.companyName,
				acountsType: row.acountsType || '客户', // 确保有默认值
				acountsName: row.acountsName,
				bankNo: row.bankNo,
				bankName: row.bankName
			};
			this.editBankDialogVisible = true;
		},

		/**
		 * 保存编辑的银行卡信息
		 */
		saveEditBank() {
			this.$refs.editBankForm.validate(valid => {
				if (valid) {
					updateBankAccount(this.editBankForm)
						.then(() => {
							this.$message.success('修改成功');
							this.editBankDialogVisible = false;
							this.getBankList(); // 刷新列表
							this.$emit('refresh'); // 触发父组件刷新
						})
						.catch(error => {
							console.error('修改失败:', error);
							this.$message.error('修改失败: ' + (error.message || '未知错误'));
						});
				}
			});
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
