<script>
export default {
	name: 'CarApply',
	props: {
		needToShowInfo: {
			type: Object
		}
	}
};
</script>

<template>
	<div>
		<el-descriptions title="车辆使用申请信息">
			<el-descriptions-item label="申请时间">
				{{ needToShowInfo.applyDate }}
			</el-descriptions-item>
			<el-descriptions-item label="申请人">
				{{ needToShowInfo.applyUser }}
			</el-descriptions-item>
			<el-descriptions-item label="部门">
				{{ needToShowInfo.department }}
			</el-descriptions-item>
			<el-descriptions-item label="车牌">
				{{ needToShowInfo.carNo }}
			</el-descriptions-item>
			<el-descriptions-item label="是否携带油卡">
				{{ needToShowInfo.isUseOilCard === 1 ? '是' : '否' }}
			</el-descriptions-item>
			<el-descriptions-item label="随同乘车人员">
				{{ needToShowInfo.peers }}
			</el-descriptions-item>
			<el-descriptions-item label="用车时间">
				{{ needToShowInfo.startTime }}
			</el-descriptions-item>
			<el-descriptions-item label="还车时间">
				{{ needToShowInfo.endTime }}
			</el-descriptions-item>
			<el-descriptions-item label="用车事由">
				{{ needToShowInfo.ApplyPurpose }}
			</el-descriptions-item>
			<el-descriptions-item label="出车前里程">
				{{ needToShowInfo.startMile }}
			</el-descriptions-item>
			<el-descriptions-item label="出车前车况">
				{{ needToShowInfo.startCarState }}
			</el-descriptions-item>
			<el-descriptions-item label="回来后里程">
				{{ needToShowInfo.endMile }}
			</el-descriptions-item>
			<el-descriptions-item label="回来后车况">
				{{ needToShowInfo.endCarState }}
			</el-descriptions-item>
			<el-descriptions-item label="用车里程数">
				{{ needToShowInfo.miles }}
			</el-descriptions-item>
			<el-descriptions-item label="回程停靠位置">
				{{ needToShowInfo.backStopPlace }}
			</el-descriptions-item>
			<el-descriptions-item label="行程中违法次数">
				{{ needToShowInfo.violationsCount }}
			</el-descriptions-item>
			<el-descriptions-item label="违章罚款金额">
				{{ needToShowInfo.fine }}
			</el-descriptions-item>
			<el-descriptions-item label="行程中是否维修/保养">
				{{ needToShowInfo.isMaintenance }}
			</el-descriptions-item>
			<el-descriptions-item label="维修金额">
				{{ needToShowInfo.repairMoney }}
			</el-descriptions-item>
			<el-descriptions-item label="保养金额">
				{{ needToShowInfo.maintenanceMoney }}
			</el-descriptions-item>
			<el-descriptions-item label="行程中使用加油卡加油次数">
				{{ needToShowInfo.refuelingFrequency }}
			</el-descriptions-item>
			<el-descriptions-item label="派车人">
				{{ needToShowInfo.dispatchPerson }}
			</el-descriptions-item>
			<el-descriptions-item label="备注">
				{{ needToShowInfo.comments }}
			</el-descriptions-item>
			<el-descriptions-item label="现金加油次数">
				{{ needToShowInfo.cashRefuelingFrequency }}
			</el-descriptions-item>
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
