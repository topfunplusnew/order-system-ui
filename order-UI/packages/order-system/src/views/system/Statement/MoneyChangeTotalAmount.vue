<script>
import { getBackupInfoV1, getMoneyChangeSummaryByDate } from '@/api/system/statement';
import { fix } from 'order-system/src/api/tool/format';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import ChooseModule from '@/views/dashboard/backuplog/ChooseModule.vue';
import { TableName } from '@/api/tool/enums';
import { isToday } from '@/views/dashboard/backuplog';
import { getFundChangeDetail } from '@/api/system/sql';

export default {
	name: 'MoneyChangeTotalAmount',
	components: { DialogWrapper },
	mixins: [common_dialog],
	data() {
		return {
			changeForm: {
				startTime: '',
				endTime: ''
			},
			// 数据固定后的数组
			fixedMoneyTableData: [],
			// 变动
			changeMoneyTableData: [],
			spanArr: [], // 存储合并信息的数组
			DataTypes: Object.freeze({
				FIXED: 0,
				CHANGE: 1
			}),

			diffRows: [],
			diffModules: [],

			// 表格上方查询日期
			targetLeftDate: null,
			targetRightDate: null
		};
	},
	computed: {
		columnHeaderFix() {
			return `日期:` + (this.targetRightDate ? this.targetRightDate : this.changeForm.endTime ? this.changeForm.endTime : '未选择日期') + `(数据固定后截取)`;
		},
		columnHeaderChange() {
			return `日期:` + (this.targetLeftDate ? this.targetLeftDate : this.changeForm.endTime ? this.changeForm.endTime : '未选择日期') + `(当日截取)`;
		}
	},
	methods: {
		fix,
		// 对左侧时间的校验逻辑
		changeLeftDate(value) {
			if (!this.changeForm.endTime) {
				this.$message.error('请先选择顶部搜索时间！');
				this.targetLeftDate = null;
				return;
			}
			// 这里选择的时候 如果顶部的时间没选择的话 不允许选择 如果顶部选择了 那么不能小于顶部时间
			if (value && value < this.changeForm.endTime) {
				this.$message({
					message: '左侧时间不能小于顶部搜索框时间',
					type: 'error'
				});
				this.targetLeftDate = null;
				return;
			}
			// 不能选择今天
			if (isToday(value)) {
				this.$message({
					message: '不能选择今天',
					type: 'error'
				});
				this.targetLeftDate = null;
			}
		},
		// 表格右侧时间的校验逻辑
		changeRightDate(value) {
			// 如果没有选择左侧时间  那么就提示不行
			if (!this.targetLeftDate) {
				this.$message.error('请先选择左侧搜索时间！');
				this.targetRightDate = null;
				return;
			}
			// 如果选择的时间小于左侧的时间 那么就提示不行
			if (value && value < this.targetLeftDate) {
				this.$message({
					message: '右侧时间不能小于左侧时间',
					type: 'error'
				});
				this.targetRightDate = null;
				return;
			}
			// 不能选择今天
			if (isToday(value)) {
				this.$message({
					message: '不能选择今天',
					type: 'error'
				});
				this.targetRightDate = null;
			}
		},
		// 搜索
		async handleChangeSearch() {
			// 获取左侧的
			const left = await this.getChangeData(this.changeForm.endTime, this.targetLeftDate);
			this.fixedMoneyTableData = this.formatTableData(left);
			// 获取右侧的
			const right = await this.getChangeData(this.changeForm.endTime, this.targetRightDate);
			this.changeMoneyTableData = this.formatTableData(right);
			// 计算差异
			this.calculateDiff();
		},
		// 计算差异行 在图表中显示高亮
		calculateDiff(leftTableData, rightTableData) {
			// 计算差异行
			this.$nextTick(() => {
				this.diffRows = [];
				let leftData = leftTableData || this.fixedMoneyTableData;
				let rightData = rightTableData || this.changeMoneyTableData;
				if (!leftData || !rightData) {
					throw new Error('左右侧数据为空,函数calculateDiff发生计算错误');
				}

				// 进行计算差异
				const minLength = Math.max(leftData.length, rightData.length);
				for (let i = 0; i < minLength; i++) {
					const fixed = Number(leftData[i].anotherValue).toFixed(2);
					const change = Number(rightData[i].anotherValue).toFixed(2);
					if (fixed !== change) {
						this.diffRows.push(i);
						this.diffModules.push(rightData[i].moduleName);
					}
				}
			});
		},
		// 对第一行 以及 calculateDiff 计算出的差异列进行高亮显示
		tableRowClassName({ rowIndex }) {
			if (rowIndex === 0) {
				return {
					color: 'red !important',
					fontWeight: 'bold !important',
					fontSize: '16px !important'
				};
			}
			if (this.diffRows.includes(rowIndex)) {
				return {
					color: '#ffdc00 !important',
					fontSize: '16px !important',
					fontWeight: 'bold !important'
				};
			}
			return {};
		},
		/**
		 * 获取变动数据 23号修改的数据，现在给B为23,C为24,A给19现在能搜索出来
		 * @param backupDate 顶部搜索框的时间
		 * @param targetDate  下表中左侧的时间或者右侧的时间 不传则默认顶部搜索框的时间
		 * @returns {Promise<void>}
		 */
		async getChangeData(backupDate, targetDate) {
			// 查询变动数据
			const query = {
				backupDate: backupDate || this.changeForm.endTime,
				targetDate: targetDate || this.changeForm.endTime
			};
			const changeMoney = await getMoneyChangeSummaryByDate(query);
			return changeMoney.data.originalData;
		},
		// 对数据进行精确
		formatValue(row, column, cellValue) {
			return Number(cellValue).toFixed(2);
		},
		// 计算总资产
		calculateTotalBalance(data) {
			return (
				data.companyTotalBalance + // ①应收账款---客户欠款合计数
				data.selfCompanyTotalFunds + // ②银行存款---公司所有银行资金合计
				data.futuresMarginBalance + // ③保证金----期货保证金
				data.loanFromCompany + // ④其他应收---个人或公司从我公司借款
				data.remainingInventoryAmount - // ⑤库存
				data.driverUnpaidAmount - // ⑥应付账款---运费合计
				data.supplierTotalBalance - // ⑦应付账款---欠厂家货款
				data.loanBalance
			) // ⑧其他应付款---公司从外面借款合计
				.toFixed(2);
		},
		// 对数据进行格式化处理
		formatTableData(list) {
			console.log(list);
			// 根据type进行判断 然后存入一个数组 进行对比 然后高亮相关列
			const { startTimeMoney, endTimeMoney } = list;

			// 计算数据差异的函数
			const calculateDifference = field => startTimeMoney[field] - endTimeMoney[field];
			// 创建表格数据的函数
			const createRow = (label, value, anotherLabel, anotherValue, moduleName) => ({
				label,
				value,
				anotherLabel,
				anotherValue,
				moduleName
			});
			// 计算各个字段的差异
			const data = {
				companyTotalBalance: calculateDifference('companyTotalBalance'),
				supplierTotalBalance: calculateDifference('supplierTotalBalance'),
				driverUnpaidAmount: calculateDifference('driverUnpaidAmount'),
				selfCompanyTotalFunds: calculateDifference('selfCompanyTotalFunds'),
				loanBalance: calculateDifference('loanBalance'),
				futuresMarginBalance: calculateDifference('futuresMarginBalance'),
				loanFromCompany: calculateDifference('loanFromCompany'),
				remainingInventoryAmount: calculateDifference('remainingInventoryAmount')
			};
			return [
				createRow('资金总额（即股东权益）=①+②+③+④+⑤-⑥-⑦-⑧', this.calculateTotalBalance(startTimeMoney), this.calculateTotalBalance(endTimeMoney), this.calculateTotalBalance(data), null),
				createRow('①应收账款---客户欠款合计数', startTimeMoney.companyTotalBalance, endTimeMoney.companyTotalBalance, data.companyTotalBalance, `companyTotalBalance`),
				createRow('②银行存款---公司所有银行资金合计', startTimeMoney.selfCompanyTotalFunds, endTimeMoney.selfCompanyTotalFunds, data.selfCompanyTotalFunds, `selfCompanyTotalFunds`),
				createRow('③保证金----期货保证金', startTimeMoney.futuresMarginBalance, endTimeMoney.futuresMarginBalance, data.futuresMarginBalance, `futuresMarginBalance`),
				createRow('④其他应收---个人或公司从我公司借款', startTimeMoney.loanFromCompany, endTimeMoney.loanFromCompany, data.loanFromCompany, `loanFromCompany`),
				createRow('⑤库存', startTimeMoney.remainingInventoryAmount, endTimeMoney.remainingInventoryAmount, data.remainingInventoryAmount, `remainingInventoryAmount`),
				createRow('⑥应付账款---运费合计', startTimeMoney.driverUnpaidAmount, endTimeMoney.driverUnpaidAmount, data.driverUnpaidAmount, `driverUnpaidAmount`),
				createRow('⑦应付账款---欠厂家货款', startTimeMoney.supplierTotalBalance, endTimeMoney.supplierTotalBalance, data.supplierTotalBalance, `supplierTotalBalance`),
				createRow('⑧其他应付款---公司从外面借款合计', startTimeMoney.loanBalance, endTimeMoney.loanBalance, data.loanBalance, `loanBalance`)
			];
		},
		// 点击行的逻辑 点击后将对应的模块名传给后端
		handleRowClick(row, column, event) {
			if (this.diffModules.includes(row.moduleName)) {
				// 在这里 把moduleName传给后端
				// const variableName = row.moduleName;
				// const query = {
				// 	variableName,
				// 	backupDate: this.changeForm.endTime,
				// 	firstTargetDate: this.targetLeftDate,
				// 	secondTargetDate: this.targetRightDate
				// };
				// // 需要把订单详情从展示的表模块列表中去除
				// const filter = tableName => tableName !== TableName.ORDER_DETAIL;
				// 根据模块名查询具体的变动信息
				// getBackupInfoV1(query).then(res => {
				// 	if (!res.rows) {
				// 		this.$message.warning('该模块没有变动信息');
				// 		return;
				// 	}
				// 	if (res.rows.length === 0) {
				// 		this.$message.warning('该模块没有变动信息');
				// 		return;
				// 	}
				// 	let moduleList = Array.from(new Set(res.rows.map(item => item.tableName)));
				// 	moduleList = moduleList.filter(filter);
				// 	// 对res.rows的数据
				// 	this.openDialog(
				// 		ChooseModule,
				// 		'请选择模块查看其详细资金变动',
				// 		'700px',
				// 		{
				// 			moduleList,
				// 			result: res.rows
				// 		},
				// 		false
				// 	);
				// });
				const qs = {
					pageNum: 2,
					pageSize: 30,
					params: {
						startTime: null,
						endTime: null,
						tableNames: [
							'payment',
							'receivemoney',
							'invoiceother',
							'invoicein',
							'invoiceout',
							'bankacceptance',
							'orderDetail',
							'goodsorder',
							'orderfreight',
							'inventory_detail',
							'inventory_main',
							'bankaccountchange',
							'borrowedmoney',
							'repayment',
							'lendmoney',
							'recovermoney'
						],
						targetDate: null
					}
				};
				// todo 测试接口 信息更全 测试完毕后换回V1接口
				getFundChangeDetail(qs).then(res => {
					if (!res.rows) {
						this.$message.warning('该模块没有变动信息');
						return;
					}
					if (res.rows.length === 0) {
						this.$message.warning('该模块没有变动信息');
						return;
					}
					let moduleList = Array.from(new Set(res.rows.map(item => item.tableName)));
					moduleList = moduleList.filter(tableName => tableName !== TableName.ORDER_DETAIL);
					moduleList = moduleList.filter(tableName => tableName !== TableName.INVENTORDETAIL);
					// 对res.rows的数据
					this.openDialog(
						ChooseModule,
						'请选择模块查看其详细资金变动',
						'700px',
						{
							moduleList,
							result: res.rows
						},
						false
					);
				});
			}
		},
		// 修改单元格样式方法
		cellStyle({ row, column, rowIndex }) {
			if (column.property === 'value' && this.diffRows.includes(rowIndex)) {
				return {
					cursor: 'pointer'
				};
			}
			return {
				cursor: 'default'
			};
		},
		// 合并行和列的方法
		objectSpanMethod({ row, column, rowIndex, columnIndex }) {
			// 合并“科目名称”列
			if (columnIndex === 0) {
				if (rowIndex === 0) {
					// 第一行显示“股东权益”，不合并
					return {
						rowspan: 1,
						colspan: 1
					};
				} else if (rowIndex === 1) {
					// 合并“资产类”行
					return {
						rowspan: 5, // 合并 5 行
						colspan: 1
					};
				} else if (rowIndex === 6) {
					// 合并“负债类”行
					return {
						rowspan: 3, // 合并 3 行
						colspan: 1
					};
				} else {
					// 其他行不显示
					return {
						rowspan: 0,
						colspan: 0
					};
				}
			}
			// 合并“对比日资金流变动”列
			else if (columnIndex === 3) {
				if (rowIndex === 0) {
					// 第一行显示差值，合并所有行
					return {
						rowspan: this.fixedMoneyTableData.length,
						colspan: 1
					};
				} else {
					// 其他行不显示
					return {
						rowspan: 0,
						colspan: 0
					};
				}
			}
			// 其他列不合并
			else {
				return {
					rowspan: 1,
					colspan: 1
				};
			}
		}
	}
};
</script>

<template>
	<div>
		<div class="container">
			<el-form :inline="true" :model="changeForm" class="search-form">
				<el-form-item label="日期查询">
					<el-date-picker v-model="changeForm.endTime" type="date" value-format="yyyy-MM-dd" placeholder="选择日期"></el-date-picker>
				</el-form-item>
				<el-form-item>
					<el-button :disabled="!changeForm.endTime || !targetLeftDate || !targetRightDate" type="primary" @click="handleChangeSearch">搜索</el-button>
				</el-form-item>
			</el-form>

			<el-row>
				<el-alert title="标记为黄色的数据代表有差异，可点击查看模块详细数据变动" type="warning"></el-alert>
			</el-row>
			<br />
			<!-- 表格 -->
			<el-row :gutter="30">
				<el-col :span="12">
					<!--          日期选择框-->
					<el-row>
						<el-col :span="20">
							<el-date-picker
								size="mini"
								v-model="targetLeftDate"
								type="date"
								value-format="yyyy-MM-dd"
								placeholder="选择当日截取查询日期,默认为顶部搜索框的时间"
								style="width: 100%"
								@change="changeLeftDate"
							></el-date-picker>
						</el-col>
					</el-row>
					<br />
					<el-table
						@row-click="handleRowClick"
						:cell-style="cellStyle"
						size="mini"
						:data="changeMoneyTableData"
						border
						class="money-table"
						:row-style="tableRowClassName"
						:span-method="objectSpanMethod"
					>
						<el-table-column :label="columnHeaderChange" align="center">
							<el-table-column label="科目名称">
								<template slot-scope="scope">
									<!-- 只在第一行显示“股东权益” -->
									<div v-if="scope.$index === 0">股东权益</div>
									<!-- 合并“资产类” -->
									<div v-if="scope.$index === 1">资产类</div>
									<!-- 合并“负债类” -->
									<div v-if="scope.$index === 6">负债类</div>
								</template>
							</el-table-column>
							<el-table-column prop="label" label="项目"></el-table-column>
							<el-table-column prop="value" label="上日资金总额" :formatter="formatValue"></el-table-column>
							<el-table-column label="当日利润变动">
								<template slot-scope="scope">
									<!-- 只在第一行显示差值 -->
									<div v-if="scope.$index === 0">
										{{ fix(scope.row.anotherLabel - scope.row.value) }}
									</div>
								</template>
							</el-table-column>
							<el-table-column prop="anotherLabel" label="本日资金总额" :formatter="formatValue"></el-table-column>
							<el-table-column prop="anotherValue" label="当日资金总额变动情况" :formatter="formatValue"></el-table-column>
						</el-table-column>
					</el-table>
				</el-col>
				<el-col :span="12">
					<el-row>
						<el-col :span="20">
							<el-date-picker
								size="mini"
								v-model="targetRightDate"
								type="date"
								value-format="yyyy-MM-dd"
								placeholder="选择数据固定后日期,默认为顶部搜索框的时间"
								style="width: 100%"
								@change="changeRightDate"
							></el-date-picker>
						</el-col>
					</el-row>
					<br />
					<el-table
						@row-click="handleRowClick"
						:cell-style="cellStyle"
						size="mini"
						:data="fixedMoneyTableData"
						border
						class="money-table"
						:row-style="tableRowClassName"
						:span-method="objectSpanMethod"
					>
						<el-table-column :label="columnHeaderFix" align="center">
							<el-table-column label="科目名称">
								<template slot-scope="scope">
									<!-- 只在第一行显示“股东权益” -->
									<div v-if="scope.$index === 0">股东权益</div>
									<!-- 合并“资产类” -->
									<div v-if="scope.$index === 1">资产类</div>
									<!-- 合并“负债类” -->
									<div v-if="scope.$index === 6">负债类</div>
								</template>
							</el-table-column>
							<el-table-column prop="label" label="项目"></el-table-column>
							<el-table-column prop="value" label="上日资金总额" :formatter="formatValue"></el-table-column>
							<el-table-column label="当日利润变动">
								<template slot-scope="scope">
									<!-- 只在第一行显示差值 -->
									<div v-if="scope.$index === 0">
										{{ fix(scope.row.anotherLabel - scope.row.value) }}
									</div>
								</template>
							</el-table-column>
							<el-table-column prop="anotherLabel" label="本日资金总额" :formatter="formatValue"></el-table-column>
							<el-table-column prop="anotherValue" label="当日资金总额变动情况" :formatter="formatValue"></el-table-column>
						</el-table-column>
					</el-table>
				</el-col>
			</el-row>
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

<style scoped lang="scss">
.container {
	margin: 30px;
}
</style>
