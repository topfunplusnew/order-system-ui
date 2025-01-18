<template>
	<div class="oil-card-balance-detail">
		<h2>油卡余额详情报表</h2>
		<!-- 表格展示 -->
		<el-table
			:data="oilCardDetails"
			border
			stripe
			size="mini"
			style="width: 100%"
		>
			<!-- 序号列 -->
			<el-table-column label="序号" align="center">
				<template #default="scope">
					{{ scope.$index + 1 }}
				</template>
			</el-table-column>

			<!-- 油卡编号 -->
			<el-table-column prop="oilCardNo" label="油卡编号" align="center" />

			<!-- 变动日期 -->
			<el-table-column prop="changeDate" label="变动日期" align="center" />

			<!-- 变动金额 -->
			<el-table-column prop="changeAmount" label="变动金额 (元)" align="center">
				<template #default="scope">
					{{ scope.row.changeAmount.toFixed(2) }}
				</template>
			</el-table-column>

			<!-- 运行余额 -->
			<el-table-column
				prop="runningBalance"
				label="运行余额 (元)"
				align="center"
			>
				<template #default="scope">
					{{ scope.row.runningBalance.toFixed(2) }}
				</template>
			</el-table-column>

			<!-- 操作列 -->
			<el-table-column label="操作" align="center" width="120">
				<template #default="scope">
					<el-button type="text" size="mini" @click="viewDetail(scope.row)">
						查看明细
					</el-button>
				</template>
			</el-table-column>
		</el-table>

		<!-- 汇总信息 -->
		<div class="summary" style="margin-top: 20px; text-align: right">
			<div>
				总变动金额: <b>{{ totalChangeAmount.toFixed(2) }}</b> 元
			</div>
			<div>
				最新运行余额: <b>{{ latestBalance.toFixed(2) }}</b> 元
			</div>
		</div>

		<!-- 弹窗展示 -->
		<el-dialog
			title="明细信息"
			:visible.sync="detailDialogVisible"
			width="600px"
		>
			<el-table
				:data="detailInfo"
				border
				stripe
				size="mini"
				style="width: 100%"
			>
				<el-table-column prop="key" label="字段名" align="center" />
				<el-table-column prop="value" label="字段值" align="center" />
			</el-table>
			<span slot="footer" class="dialog-footer">
				<el-button @click="detailDialogVisible = false">关闭</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import {
	getOilCardDetailSummary,
	fetchDetailById
} from '../../../api/system/statement';

export default {
	name: 'OilCardBalanceDetail',
	data() {
		return {
			oilCardDetails: [], // 存储油卡数据
			totalChangeAmount: 0, // 总变动金额
			latestBalance: 0, // 最新运行余额
			detailDialogVisible: false, // 控制明细弹窗显示
			detailInfo: [] // 存储明细信息
		};
	},
	created() {
		this.fetchOilCardDetails();
	},
	methods: {
		async fetchOilCardDetails() {
			try {
				const response = await getOilCardDetailSummary();
				if (response.code === 200) {
					this.oilCardDetails = response.data;

					// 计算总变动金额
					this.totalChangeAmount = this.oilCardDetails.reduce(
						(sum, item) => sum + item.changeAmount,
						0
					);

					// 获取最新运行余额（最后一条记录的 runningBalance）
					if (this.oilCardDetails.length > 0) {
						this.latestBalance =
							this.oilCardDetails[
								this.oilCardDetails.length - 1
							].runningBalance;
					}
				} else {
					this.$message.error(response.msg || '获取油卡详情失败');
				}
			} catch (error) {
				console.error('获取油卡详情失败:', error);
				this.$message.error('获取油卡详情失败');
			}
		},

		// 查看明细逻辑
		async viewDetail(row) {
			try {
				const { tableName, tableId } = row;
				const response = await fetchDetailById({ tableName, tableId });

				if (response.code === 200) {
					// 将明细数据格式化为键值对
					this.detailInfo = Object.entries(response.data).map(
						([key, value]) => ({
							key,
							value
						})
					);
					this.detailDialogVisible = true;
				} else {
					this.$message.error(response.msg || '获取明细失败');
				}
			} catch (error) {
				console.error('获取明细失败:', error);
				this.$message.error('获取明细失败');
			}
		}
	}
};
</script>

<style scoped lang="scss">
.oil-card-balance-detail {
	padding: 20px;
	background: #fff;
	border-radius: 8px;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.summary {
	font-size: 14px;
	line-height: 1.8;
}

.dialog-footer {
	text-align: right;
}
</style>
