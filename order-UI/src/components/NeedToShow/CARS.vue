<script>
export default {
	name: 'CARS',
	props: {
		needToShowInfo: {
			type: Object,
			default: () => {}
		}
	},
	methods: {
		handleProcess(that) {
			return new Promise((resolve, reject) => {
				that.dialogVisible = false;
				resolve();
			});
		},
		handleReject() {}
	}
};
</script>

<template>
	<div>
		<el-descriptions title="车辆信息">
			<el-descriptions-item label="车牌号/柜号">
				{{ needToShowInfo.carNo }}
			</el-descriptions-item>
			<el-descriptions-item label="司机姓名">
				{{ needToShowInfo.driver }}
			</el-descriptions-item>
			<el-descriptions-item label="联系电话">
				{{ needToShowInfo.tel }}
			</el-descriptions-item>
			<el-descriptions-item label="开户银行">
				{{ needToShowInfo.bankName }}
			</el-descriptions-item>
			<el-descriptions-item label="账户名">
				{{ needToShowInfo.acountsName }}
			</el-descriptions-item>
			<el-descriptions-item label="银行账号">
				{{ needToShowInfo.bankNo }}
			</el-descriptions-item>
			<el-descriptions-item label="账户类型">
				<el-tag size="small">
					{{ needToShowInfo.acountsType === 1 ? '收款' : '付款' }}
				</el-tag>
			</el-descriptions-item>
			<el-descriptions-item label="备注">
				{{ needToShowInfo.remark || '暂无备注' }}
			</el-descriptions-item>
			<el-descriptions-item label="运输类型">
				{{ needToShowInfo.carType }}
			</el-descriptions-item>
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
