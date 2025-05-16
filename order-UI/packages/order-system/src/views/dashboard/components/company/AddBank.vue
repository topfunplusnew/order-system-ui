<!--为公司绑定银行卡 本质是银行卡修改 通用组件-->

<script>
import { listBankAccount, updateBankAccount } from '../../../../api/system/bankAccount';

export default {
	name: 'AddBank',
	props: {
		// 需要companyName companyId
		companyInfo: {
			type: Object,
			default() {
				return {};
			}
		}
	},
	data() {
		return {
			// 银行卡信息
			bankAccount: {},
			// 选择银行卡的弹窗
			dialogFormVisible: false,
			// 银行卡列表
			tableData: [],
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				acountsName: null
			},
			total: 0
		};
	},
	computed: {},
	created() {
		this.getList();
	},
	methods: {
		getList() {
			// 未被绑定的卡为-1 己方公司为0
			listBankAccount({ companyId: -1, ...this.queryParams }).then(res => {
				this.tableData = res.rows;
				this.total = res.total;
			});
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		handleAdd() {
			this.dialogFormVisible = true;
		},
		// 选择某张银行卡
		chooseThisBankAccount(row) {
			console.log('银行卡信息', row);
			this.$confirm({
				title: '提示',
				content: '确定要绑定这张银行卡吗?',
				okText: '确定',
				cancelText: '取消',
				type: 'warning',
				zIndex: 2600,
				onOk: () => {
					this.updateBankAccount(row);
				},
				onCancel: () => {
					this.$message.info('已取消绑定操作');
				}
			});
		},
		// 为某个公司绑定银行卡 本质上是修改银行卡中的信息 修改companyId和companyName
		updateBankAccount(info) {
			const body = {
				...info,
				companyId: this.companyInfo.id,
				companyName: this.companyInfo.companyName
			};
			updateBankAccount(body).then(res => {
				this.$message.success('绑定成功');
				this.dialogFormVisible = false;
				this.$emit('changeBankOpen');
			});
		}
	}
};
</script>

<template>
	<div>
		<div style="text-align: center">
			<!--  添加银行卡的操作 搜索未绑定的银行卡,修改银行卡 -->
			<el-button size="mini" type="primary" @click="handleAdd">添加银行卡</el-button>
		</div>

		<el-dialog v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="选择需要绑定的银行卡" :visible.sync="dialogFormVisible" append-to-body width="58%">
			<div slot="title">
				<div style="display: flex; justify-content: space-between">
					<div>
						<el-input
							v-model="queryParams.acountsName"
							placeholder="请输入账户名称"
							clearable
							size="mini"
							prefix-icon="el-icon-search"
							style="width: 200px; margin-right: 10px"
							@keyup.enter.native="handleQuery"
						/>
						<el-button type="primary" size="mini" @click="handleQuery">
							<i class="el-icon-search" />
							搜索
						</el-button>
					</div>
				</div>
			</div>
			<el-table :data="tableData" size="mini" stripe style="width: 100%">
				<el-table-column label="账户类型" align="center" prop="acountsType" />
				<el-table-column label="开户名称" align="center" prop="acountsName" />
				<el-table-column label="银行账号" align="center" prop="bankNo" />
				<el-table-column label="开户行" align="center" prop="bankName" />
				<el-table-column label="余额" align="center" prop="amount" />
				<el-table-column label="银行卡操作" align="center" class-name="small-padding fixed-width" fixed="right">
					<template slot-scope="scope">
						<el-button size="mini" type="text" @click="chooseThisBankAccount(scope.row)">选择</el-button>
					</template>
				</el-table-column>
			</el-table>
			<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogFormVisible = false">取 消</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss"></style>
