<template>
	<div class="oil-card-balance-detail">
		<h2>油卡消费充值明细表</h2>

		<el-row>
			<el-form ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="100px">
				<el-form-item label="油卡号">
					<el-input v-model="queryParams.oilCardNo" placeholder="请输入油卡号" clearable size="mini" />
				</el-form-item>
				<el-form-item label="时间" prop="beginTime">
					<el-date-picker v-model="queryParams.beginTime" type="date" size="mini" value-format="yyyy-MM-dd" placeholder="选择日期"></el-date-picker>
				</el-form-item>
				<el-form-item prop="endTime">
					<el-date-picker v-model="queryParams.endTime" type="date" size="mini" value-format="yyyy-MM-dd" placeholder="选择日期"></el-date-picker>
				</el-form-item>

				<el-form-item>
					<el-button type="primary" icon="el-icon-search" size="mini" @click="fetchOilCardDetails">搜索</el-button>
				</el-form-item>
			</el-form>
		</el-row>

		<el-row :gutter="10" class="mb8">
			<right-toolbar :columns="columns" @queryTable="fetchOilCardDetails">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>
		<!-- 表格展示 -->
		<el-table id="printBox" :data="oilCardDetails" border stripe size="mini" style="width: 100%">
			<!-- 序号列 -->
			<el-table-column v-if="columns[0].visible" label="序号" align="center">
				<template #default="scope">
					{{ scope.$index + 1 }}
				</template>
			</el-table-column>

			<!-- 油卡编号 -->
			<el-table-column v-if="columns[1].visible" prop="oilCardNo" label="油卡编号" align="center" />

			<!-- 变动日期 -->
			<el-table-column v-if="columns[2].visible" prop="changeDate" label="变动日期" align="center" />

			<!-- 变动金额 -->
			<el-table-column v-if="columns[3].visible" prop="changeAmount" label="变动金额 (元)" align="center">
				<template #default="scope">
					{{ scope.row.changeAmount }}
				</template>
			</el-table-column>

			<el-table-column prop="tableName" label="业务名称" align="center">
				<template #default="scope">
					{{ scope.row.tableName === 'oilrecharge' ? '充值' : scope.row.tableName === 'oilcardfundtransfer' ? '分配或圈存' : '消费' }}
				</template>
			</el-table-column>
			<!-- 余额 -->
			<el-table-column v-if="columns[4].visible" prop="runningBalance" label="余额 (元)" align="center">
				<template #default="scope">
					{{ scope.row.runningBalance || 0 }}
				</template>
			</el-table-column>

			<!--      这里可能需要动态展示，因为只有副卡用得到这一列-->
			<el-table-column v-if="oilFundType === OilCardType.SUB" prop="runningVirtualBalance" label="累计待圈存金额 (元)" align="center">
				<template #default="scope">
					{{ scope.row.runningVirtualBalance || `无` }}
				</template>
			</el-table-column>

			<!--      这里也需要动态展示，如果是tableName = oilcardfundtransfer需要展示类型-->
			<el-table-column prop="type" label="消费类型" align="center">
				<template slot-scope="scope">
					<el-tag v-if="scope.row.tableName === TableName.OIL_CARD_FUND_TRANSFER" size="mini" :type="scope.row.type | typeFilter">{{ scope.row.type | statusFilter }}</el-tag>
					<el-tag v-else>无</el-tag>
				</template>
			</el-table-column>

			<el-table-column label="车辆申请信息" align="center">
				<template #default="scope">
					<div v-if="scope.row.carApplyId">
						<el-button type="text" size="mini" @click="viewCarDetail(scope.row.carApplyId)">查看明细</el-button>
					</div>
					<div v-else>暂无车辆申请信息</div>
				</template>
			</el-table-column>

			<!-- 操作列 -->
			<el-table-column label="操作" align="center" width="120">
				<template #default="scope">
					<el-button type="text" size="mini" @click="viewDetail(scope.row)">查看明细</el-button>
				</template>
			</el-table-column>
		</el-table>

		<!-- 汇总信息 -->
		<div class="summary" style="margin-top: 20px; text-align: right">
			<div>
				总变动金额:
				<b>{{ totalChangeAmount.toFixed(2) }}</b>
				元
			</div>
			<div>
				最新余额:
				<b>{{ latestBalance.toFixed(2) }}</b>
				元
			</div>
		</div>

		<!-- 弹窗展示 -->
		<el-dialog title="明细信息" :visible.sync="detailDialogVisible" width="900px">
			<component :is="component" :need-to-show-info="needToShowInfo" />
			<span slot="footer" class="dialog-footer">
				<el-button @click="detailDialogVisible = false">关闭</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import { getOilCardDetailSummary } from '../../../api/system/statement';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { getOilRecharge } from '@/api/system/oilRecharge';
import { getOilCardFundTransfer } from '@/api/system/oilCardFundTransfer';
import { getOilCardConsume } from '@/api/system/OilCardConsume';
import OIL_RECHARGE from '@/components/NeedToShow/OIL_RECHARGE.vue';
import OIL_TRANSFOR from '@/components/NeedToShow/OIL_TRANSFOR.vue';
import OIL_CONSUME from '@/components/NeedToShow/OIL_CONSUME.vue';
import { getCarApply } from '@/api/system/carApply';
import CAR_APPLY from '@/components/NeedToShow/CAR_APPLY.vue';
import { listOilCard } from '@/api/system/oilCard';
import { OilCardOptionType, OilCardType, TableName } from '@/api/tool/enums';

export default {
	name: 'OilCardBalanceDetail',
	computed: {
		TableName() {
			return TableName;
		},
		OilCardType() {
			return OilCardType;
		}
	},
	mixins: [mixin_printHTML],
	data() {
		return {
			oilCardDetails: [], // 存储油卡数据
			totalChangeAmount: 0, // 总变动金额
			latestBalance: 0, // 最新余额
			detailDialogVisible: false, // 控制明细弹窗显示
			detailInfo: [], // 存储明细信息
			queryParams: {
				oilCardNo: '', // 油卡号
				beginTime: '', // 开始时间
				endTime: '' // 结束时间
			},
			columns: [
				{ key: 0, label: '序号', visible: true },
				{ key: 1, label: '油卡编号', visible: true },
				{ key: 2, label: '变动日期', visible: true },
				{ key: 3, label: '变动金额 (元)', visible: true },
				{ key: 4, label: '余额 (元)', visible: true }
			],
			component: null,
			needToShowInfo: null,

			// 操作类型 只用作区分
			oilFundType: null
		};
	},
	created() {
		// this.fetchOilCardDetails();
	},
	filters: {
		statusFilter(type) {
			switch (type) {
				case OilCardOptionType.MAIN_TO_SUB:
					return '主卡分配';
				case OilCardOptionType.SUB_TO_SUB:
					return '副卡圈存';
				default:
					return '无';
			}
		},
		typeFilter(type) {
			switch (type) {
				case OilCardOptionType.MAIN_TO_SUB:
					return 'success';
				case OilCardOptionType.SUB_TO_SUB:
					return 'warning';
				default:
					return 'info';
			}
		}
	},
	methods: {
		async fetchOilCardDetails() {
			// 先获取一下油卡的类型
			const query = { oilCardNo: this.queryParams.oilCardNo };
			listOilCard(query).then(res => {
				if (!res.data && !res.rows) {
					this.$message.error('获取油卡信息失败');
					return;
				}
				if (res.rows && res.rows.length === 0) {
					this.$message.error('未查询到油卡信息');
					return;
				}
				this.oilFundType = res.rows[0].oilType;

				// 获取该张油卡的消费明细
				getOilCardDetailSummary(this.queryParams).then(response => {
					if (!response.data && !response.rows) {
						this.$message.error(response.msg || '获取后端油卡详情失败');
						return;
					}
					if (response.rows && response.rows.length === 0) {
						this.$message.error('未查询到油卡详情信息');
						return;
					}
					this.oilCardDetails = response.data;

					console.log(this.oilCardDetails, response.data);
					// 计算总变动金额
					this.totalChangeAmount = this.oilCardDetails.reduce((sum, item) => sum + item.changeAmount, 0);
					// 获取最新余额（最后一条记录的 runningBalance）
					if (this.oilCardDetails.length > 0) {
						this.latestBalance = this.oilCardDetails[this.oilCardDetails.length - 1].runningBalance;
					}
				});
			});
		},
		async fetchDetailById(query) {
			switch (query.tableName) {
				case 'oilrecharge':
					return getOilRecharge(query.tableId);
				case 'oilcardfundtransfer':
					return getOilCardFundTransfer(query.tableId);
				default:
					return getOilCardConsume(query.tableId);
			}
		},
		// 查看明细逻辑
		async viewDetail(row) {
			const { tableName, tableId } = row;
			const response = await this.fetchDetailById({ tableName, tableId });
			if (!response.data) {
				this.$message.warning('无相关数据');
				return;
			}
			// 根据表名展示不同信息
			switch (tableName) {
				case 'oilrecharge': {
					this.needToShowInfo = response.data;
					this.component = OIL_RECHARGE;
					break;
				}
				case 'oilcardfundtransfer': {
					this.needToShowInfo = response.data;
					this.component = OIL_TRANSFOR;
					break;
				}
				case 'oilcardconsume': {
					this.needToShowInfo = response.data;
					this.component = OIL_CONSUME;
					break;
				}
			}
			this.detailDialogVisible = true;
		},
		viewCarDetail(id) {
			getCarApply(id).then(res => {
				if (!res.data) {
					this.$message.warning('无相关数据');
				}
				this.needToShowInfo = res.data;
				this.component = CAR_APPLY;
				this.detailDialogVisible = true;
			});
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
