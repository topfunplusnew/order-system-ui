<template>
	<div class="cash-oil-card-summary">
		<h2 class="title">现金加油台账</h2>

		<!-- 查询条件 -->
		<el-form :model="query" label-width="80px" class="filter-form">
			<div class="form-row">
				<el-form-item label="车牌号">
					<el-input
						v-model="query.carNo"
						placeholder="请输入车牌号"
						size="small"
						clearable
					/>
				</el-form-item>
				<el-form-item label="开始时间">
					<el-date-picker
						v-model="query.startTime"
						type="datetime"
						placeholder="选择开始时间"
						class="filter-item"
						clearable
						size="small"
					/>
				</el-form-item>
				<el-form-item label="结束时间">
					<el-date-picker
						v-model="query.endTime"
						type="datetime"
						placeholder="选择结束时间"
						class="filter-item"
						clearable
						size="small"
					/>
				</el-form-item>
				<el-form-item>
					<el-button
						type="primary"
						@click="fetchData"
						class="query-button"
						size="small"
						>查询
					</el-button>
					<el-button @click="resetForm" class="reset-button" size="small"
						>重置
					</el-button>
				</el-form-item>
			</div>
		</el-form>

		<!-- 数据表格 -->
		<el-table
			:data="tableData"
			border
			stripe
			size="medium"
			style="width: 100%; margin-top: 20px"
		>
			<el-table-column label="序号" align="center" width="60">
				<template #default="scope">
					{{ scope.$index + 1 }}
				</template>
			</el-table-column>

			<el-table-column label="车牌号" prop="carNo" align="center" />
			<el-table-column label="申请人" prop="applyUser" align="center" />
			<el-table-column label="开始时间" prop="startTime" align="center" />
			<el-table-column label="结束时间" prop="endTime" align="center" />
			<el-table-column
				label="现金加油次数"
				prop="cashRefuelingFrequency"
				align="center"
			/>
			<el-table-column label="现金加油金额" prop="cashRefueling" align="center">
				<template #default="scope">
					<span class="amount">{{ scope.row.cashRefueling.toFixed(2) }}</span>
				</template>
			</el-table-column>

			<!-- 操作列：查看车辆详情 -->
			<el-table-column label="操作" align="center" width="120">
				<template #default="scope">
					<el-button
						size="small"
						type="text"
						@click="viewCarDetails(scope.row.carNo)"
					>
						查看详情
					</el-button>
				</template>
			</el-table-column>
		</el-table>

		<!-- 汇总信息 -->
		<div class="summary">
			<div class="summary-item">
				<span>总现金加油次数: </span><b>{{ totalFrequency }}</b>
			</div>
			<div class="summary-item">
				<span>总现金加油金额: </span><b>{{ totalAmount.toFixed(2) }} 元</b>
			</div>
		</div>

		<div v-if="currentComponent">
			<DialogWrapper
				:current-component="currentComponent"
				:dialog-visible="dialogVisible"
				:dialog-props="dialogProps"
				:dialog-title="dialogTitle"
				:dialog-width="dialogWidth"
				@update:dialogVisible="args => (dialogVisible = false)"
				@close="handleCloseDialog"
				@confirm="handleDialogConfirm"
			/>
		</div>
	</div>
</template>

<script>
import { cashOilCardSummary } from '../../../api/system/statement';
import DialogWrapper from '../../dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '../../dashboard/mixins/common/common_dialog';
import { listVehicles } from '../../../api/system/vehicles';
import COMPANY_CAR from '../../../components/NeedToShow/COMPANY_CAR.vue'; // 假设 API 函数路径

export default {
	name: 'CashOilCardSummary',
	components: { DialogWrapper },
	mixins: [common_dialog],
	data() {
		return {
			query: {
				carNo: '',
				applyUser: '',
				startTime: '',
				endTime: ''
			},
			tableData: [], // 存储表格数据
			totalFrequency: 0, // 总现金加油次数
			totalAmount: 0 // 总现金加油金额
		};
	},
	created() {
		this.fetchData();
	},
	methods: {
		async fetchData() {
			try {
				const response = await cashOilCardSummary(this.query);
				if (response.code === 200) {
					this.tableData = response.rows;

					// 计算总现金加油次数和总金额
					this.totalFrequency = this.tableData.reduce(
						(sum, row) => sum + row.cashRefuelingFrequency,
						0
					);
					this.totalAmount = this.tableData.reduce(
						(sum, row) => sum + row.cashRefueling,
						0
					);
				} else {
					this.$message.error(response.msg || '查询失败');
				}
			} catch (error) {
				console.error('获取数据失败:', error);
				this.$message.error('获取数据失败');
			}
		},
		resetForm() {
			// 重置查询表单数据
			this.query = {
				carNo: '',
				applyUser: '',
				startTime: '',
				endTime: ''
			};
			// 调用查询方法，获取重置后的数据
			this.fetchData();
		},
		viewCarDetails(licensePlate) {
			listVehicles({ licensePlate: licensePlate }).then(res => {
				this.openDialog(
					COMPANY_CAR,
					'车辆详情',
					'800px',
					{
						needToShowInfo: res.rows[0]
					},
					true
				);
			});
		}
	}
};
</script>

<style scoped lang="scss">
.cash-oil-card-summary {
	padding: 30px;
	background-color: #f9fafb;
	border-radius: 8px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.title {
	font-size: 24px;
	color: #333;
	font-weight: bold;
}

.filter-form {
	margin-bottom: 30px;
	background-color: #fff;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.form-row {
	display: flex;
	flex-wrap: wrap;
	gap: 20px; /* 控制各项之间的间距 */
	justify-content: flex-start;
}

.el-form-item {
	margin-bottom: 0;
	flex: 1 1 200px; /* 每个项至少占据 200px 宽度，宽度不足时自动换行 */
}

.query-button {
	background-color: #409eff;
	color: white;
	border: none;
	height: 32px;
}

.reset-button {
	background-color: #f56c6c;
	color: white;
	border: none;
	height: 32px;
	margin-left: 10px;
}

.el-table th {
	background-color: #f4f4f4;
	color: #333;
	font-weight: bold;
}

.el-table .amount {
	color: #f56c6c;
}

.summary {
	margin-top: 20px;
	background-color: #fff;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
	font-size: 16px;
	color: #333;
}

.summary-item {
	margin-bottom: 10px;
}

.summary-item b {
	color: #409eff;
}

.el-button {
	font-size: 14px;
}

.reset-button {
	margin-left: 10px;
}

/* 调整输入框和按钮的大小 */
.el-input,
.el-button,
.el-date-picker {
	font-size: 14px;
}

.el-input .el-input__inner,
.el-button {
	height: 32px;
}
</style>
