<script>
export default {
	props: {
		tags: {
			type: Object,
			default: () => {}
		}
	},
	data() {
		return {};
	},
	computed: {
		// 含税货款
		totalIncludingTax() {
			return this.tags?.totalIncludingTax || 0;
		},
		// 不含税货款
		totalExcludingTax() {
			return this.tags?.totalExcludingTax || 0;
		},
		// 公户收款
		publicAccountInCome() {
			return this.tags?.publicAccountInCome || 0;
		},
		// 私户收款
		noPublicAccountInCome() {
			return this.tags?.noPublicAccountInCome || 0;
		},
		// 票点收入
		totalTicketPoints() {
			return this.tags?.totalTicketPoints || 0;
		}
	}
};
</script>

<template>
	<div>
		<el-row :gutter="20">
			<el-col :span="4">
				<div>
					<el-statistic group-separator="," :precision="2" :value="totalIncludingTax">
						<template #title>
							<span style="color: red; font-size: 16px; font-weight: bold">含税货款</span>
						</template>
					</el-statistic>
				</div>
			</el-col>
			<el-col :span="4">
				<div>
					<el-statistic group-separator="," :precision="2" :value="totalExcludingTax">
						<template #title>
							<span style="color: red; font-size: 16px; font-weight: bold">不含税货款</span>
						</template>
					</el-statistic>
				</div>
			</el-col>
			<el-col :span="4">
				<div>
					<el-statistic group-separator="," :precision="2" :value="publicAccountInCome">
						<template #title>
							<span style="color: red; font-size: 16px; font-weight: bold">公户收款</span>
						</template>
					</el-statistic>
				</div>
			</el-col>
			<el-col :span="4">
				<div>
					<el-statistic group-separator="," :precision="2" :value="noPublicAccountInCome">
						<template #title>
							<span style="color: red; font-size: 16px; font-weight: bold">私户收款</span>
						</template>
					</el-statistic>
				</div>
			</el-col>
			<el-col :span="4">
				<div>
					<el-statistic group-separator="," :precision="2" :value="totalTicketPoints">
						<template #title>
							<span style="color: red; font-size: 16px; font-weight: bold">票点收入</span>
						</template>
					</el-statistic>
				</div>
			</el-col>
		</el-row>
	</div>
</template>

<style scoped lang="scss">
.like {
	cursor: pointer;
	font-size: 25px;
	display: inline-block;
}

.el-statistic__head {
	display: block;
	color: #000; /* 根据需求设置颜色 */
	font-weight: bold;
}
</style>
