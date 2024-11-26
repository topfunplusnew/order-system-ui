<script>
export default {
	name: 'CheckBankMoney',
	props: {},
	data() {
		return {
			drawer: false,
			dialogVisible: false
		};
	},
	methods: {
		// 查看银行卡余额
		handleCheckBankAccountMoney() {
			this.dialogVisible = true;
		}
	}
};
</script>

<template>
	<div>
		<el-button type="text" size="mini" @click="handleCheckBankAccountMoney"
			>己方银行卡余额
		</el-button>

		<el-dialog title="提示" :visible.sync="dialogVisible" width="880px">
			<span>这是一段信息</span>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="dialogVisible = false"
					>确 定</el-button
				>
			</span>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss"></style>
