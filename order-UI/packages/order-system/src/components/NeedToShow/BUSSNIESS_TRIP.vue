<script>
export default {
	name: 'BUSINESS_TRIP',
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
		handleReject() {
			return Promise.resolve();
		}
	}
};
</script>
<template>
	<div>
		<el-descriptions title="出差信息" :column="5" border size="mini">
			<el-descriptions-item label="员工姓名">
				{{ needToShowInfo.employee }}
			</el-descriptions-item>
			<el-descriptions-item label="部门名称">
				{{ needToShowInfo.deptName }}
			</el-descriptions-item>
			<el-descriptions-item label="负责人">
				{{ needToShowInfo.personnel }}
			</el-descriptions-item>
			<el-descriptions-item label="开始时间">
				{{ needToShowInfo.starttime }}
			</el-descriptions-item>
			<el-descriptions-item label="结束时间">
				{{ needToShowInfo.endtime }}
			</el-descriptions-item>
			<el-descriptions-item label="审核状态">
				{{ needToShowInfo.checkState }}
			</el-descriptions-item>
			<el-descriptions-item label="备注">
				{{ needToShowInfo.comments || '暂无备注' }}
			</el-descriptions-item>
			<el-descriptions-item label="操作人员">
				{{ needToShowInfo.userName || '暂无数据' }}
			</el-descriptions-item>
		</el-descriptions>
		<el-table :data="needToShowInfo.tripReimbursementList" style="width: 100%">
			<el-table-column prop="item" label="报销项目"></el-table-column>
			<el-table-column prop="itemCost" label="费用 (元)"></el-table-column>
		</el-table>
	</div>
</template>

<style scoped lang="scss"></style>
