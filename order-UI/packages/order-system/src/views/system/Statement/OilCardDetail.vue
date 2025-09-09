<template>
	<div class="oil-card-details">
		<!-- 类型筛选 -->
		<div class="filters" style="margin-bottom: 20px">
			<el-radio-group v-model="recordType" @change="filterRecords">
				<el-radio-button label="all">全部</el-radio-button>
				<el-radio-button label="oilrecharge">充值记录</el-radio-button>
				<el-radio-button label="oilcardconsume">消费记录</el-radio-button>
			</el-radio-group>
		</div>

		<!-- 表格展示 -->
		<el-table :data="filteredRecords" border stripe size="mini" style="width: 100%">
			<!-- 序号列 -->
			<el-table-column label="序号" align="center" width="60">
				<template #default="scope">
					{{ scope.$index + 1 }}
				</template>
			</el-table-column>

			<!-- 类型 -->
			<el-table-column label="类型" align="center" width="120">
				<template #default="scope">
					{{ scope.row.tableName === 'oilrecharge' ? '充值' : '消费' }}
				</template>
			</el-table-column>

			<!-- 油卡编号 -->
			<el-table-column prop="oilCardNo" label="油卡编号" align="center" />

			<!-- 日期 -->
			<el-table-column prop="changeDate" label="变动日期" align="center" />

			<!-- 变动金额 -->
			<el-table-column prop="changeAmount" label="变动金额 (元)" align="center">
				<template #default="scope">
					<span
						:class="{
							'positive-amount': scope.row.changeAmount > 0,
							'negative-amount': scope.row.changeAmount < 0
						}"
					>
						{{ scope.row.changeAmount.toFixed(2) }}
					</span>
				</template>
			</el-table-column>

			<!-- 当前余额 -->
			<el-table-column prop="runningBalance" label="余额 (元)" align="center">
				<template #default="scope">
					{{ scope.row.runningBalance.toFixed(2) }}
				</template>
			</el-table-column>
		</el-table>

		<!-- 汇总信息 -->
		<div class="summary" style="margin-top: 20px; text-align: right">
			<p>
				总充值金额:
				<b>{{ totalRecharge.toFixed(2) }}</b>
				元
			</p>
			<p>
				总消费金额:
				<b>{{ totalConsume.toFixed(2) }}</b>
				元
			</p>
			<p>
				当前余额:
				<b>{{ currentBalance.toFixed(2) }}</b>
				元
			</p>
		</div>
	</div>
</template>

<script>
export default {
	name: 'OilCardDetails',
	props: {
		// 接收父组件提供的油卡记录数据
		records: {
			type: Array,
			required: true
		}
	},
	data() {
		return {
			filteredRecords: [], // 筛选后的数据
			recordType: 'all', // 筛选类型：all, oilrecharge, oilcardconsume
			totalRecharge: 0, // 总充值金额
			totalConsume: 0, // 总消费金额
			currentBalance: 0 // 当前余额
		};
	},
	watch: {
		// 当父组件数据更新时重新计算
		records: {
			handler(newRecords) {
				this.initializeData(newRecords);
			},
			immediate: true,
			deep: true
		}
	},
	methods: {
		handleProcess() {
			return Promise.resolve();
		},
		handleReject() {
			return Promise.resolve();
		},
		// 初始化数据和计算汇总信息
		initializeData(records) {
			this.filteredRecords = [...records];

			this.totalRecharge = records.filter(item => item.tableName === 'oilrecharge').reduce((sum, item) => sum + item.changeAmount, 0);

			this.totalConsume = records.filter(item => item.tableName === 'oilcardconsume').reduce((sum, item) => sum + Math.abs(item.changeAmount), 0);

			this.currentBalance = records.length > 0 ? records[records.length - 1].runningBalance : 0;
		},
		// 筛选记录
		filterRecords() {
			if (this.recordType === 'all') {
				this.filteredRecords = [...this.records];
			} else {
				this.filteredRecords = this.records.filter(record => record.tableName === this.recordType);
			}
		}
	}
};
</script>

<style scoped>
.positive-amount {
	color: green;
}

.negative-amount {
	color: red;
}

.summary {
	margin-top: 20px;
	font-size: 14px;
}
</style>
