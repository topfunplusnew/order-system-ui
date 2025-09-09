<script>
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { getFunction } from '@/utils/order/mapper';
import { TableName } from '@/api/tool/enums';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';
import INVOICE_IN from '@/components/NeedToShow/INVOICE_IN.vue';
import INVOICE_OUT from '@/components/NeedToShow/INVOICE_OUT.vue';
import INVOICE_ORTHER from '@/components/NeedToShow/INVOICE_ORTHER.vue';
import OFFSETTING from '@/components/NeedToShow/OFFSETTING.vue';
import REBATE from '@/components/NeedToShow/REBATE.vue';
import INVENTORY from '@/components/NeedToShow/INVENTORY.vue';
import BANK_ACCEPTANCE from '@/components/NeedToShow/BANK_ACCEPTANCE.vue';
import ORDER_FREIGHTVue from '@/components/NeedToShow/ORDER_FREIGHT.vue';

export default {
	name: 'PAYMENT',
	mixins: [common_dialog],
	props: {
		needToShowInfo: {
			type: Object,
			default: () => {
				return {};
			}
		}
	},
	data() {
		return {
			infoVisible: false,
			Components: null
		};
	},
	methods: {
		handleCheck() {
			let fillTableName = TableName.PAYMENT;
			let tid = this.needToShowInfo.id;
			const { tableName, tID } = this.needToShowInfo;
			if (!tableName && !tID) {
				this.$message.warning('当前付款信息不牵扯任何其他模块，无详细信息');
				return;
			}
			if (tableName) {
				fillTableName = tableName;
			}
			if (tID) {
				tid = tID;
			}
			// 根据tableName动态获取某个JS模块
			getFunction(fillTableName)(tid).then(res => {
				if (!res.data) {
					this.$message.warning('查询该模块条件下，暂无详细数据');
					return;
				}
				// 填充数据
				this.needToShowInfo = res.data;
				// 根据对应表名渲染对应的展示组件
				this.Components = this.getComponents(fillTableName);
				if (this.Components == null) {
					this.$message.warning('组件渲染有误');
					return;
				}
				this.$nextTick(() => {
					this.infoVisible = true;
				});
			});
		},
		// 根据对应的表名渲染对应的组件
		getComponents(tableName) {
			const components = {
				[TableName.GOODS_ORDER]: GOODS_ORDER,
				[TableName.INVOICE_IN]: INVOICE_IN,
				[TableName.INVOICE_OUT]: INVOICE_OUT,
				[TableName.INVOICE_OTHER]: INVOICE_ORTHER,
				[TableName.CASH_RECORD]: OFFSETTING,
				[TableName.REBATE]: REBATE,
				[TableName.INVENTORMAIN]: INVENTORY,
				[TableName.BANK_ACCEPTANCE]: BANK_ACCEPTANCE,
				[TableName.ORDER_FREIGHT]: ORDER_FREIGHTVue
			};
			return components[tableName] || null; // 默认返回 null，如果没有匹配的 tableName
		},
		handleProcess() {
			return Promise.resolve();
		},
		handleReject() {
			return Promise.resolve();
		}
	}
};
</script>

<template>
	<div>
		<el-card size="mini" shadow="hover">
			<!--      插槽 按钮-->
			<div slot="header" class="clearfix">
				<span>付款信息</span>
				<el-button type="text" @click="handleCheck" style="float: right">查看详细</el-button>
			</div>
			<el-descriptions :column="3" border size="mini">
				<el-descriptions-item label="公司类型">{{ needToShowInfo.companyType }}</el-descriptions-item>
				<el-descriptions-item label="日期">{{ needToShowInfo.fundsDate }}</el-descriptions-item>
				<el-descriptions-item label="金额" label-class-name="money-label">
					<span style="color: #e6a23c; font-weight: bold">{{ needToShowInfo.moneyAmount }} 元</span>
				</el-descriptions-item>
				<el-descriptions-item label="付款状态">
					<el-tag :type="needToShowInfo.paymentState === '已支付' ? 'success' : 'warning'">
						{{ needToShowInfo.paymentState }}
					</el-tag>
				</el-descriptions-item>
				<el-descriptions-item label="审核状态">
					<el-tag v-if="needToShowInfo.auditState" :type="needToShowInfo.auditState === '已审核' ? 'success' : 'info'">
						{{ needToShowInfo.auditState }}
					</el-tag>
					<span v-else>暂无</span>
				</el-descriptions-item>
				<el-descriptions-item label="对方户名">{{ needToShowInfo.otherAcountsName || '暂无' }}</el-descriptions-item>
				<el-descriptions-item label="对方银行账号">{{ needToShowInfo.otherBankNo || '暂无' }}</el-descriptions-item>
				<el-descriptions-item label="对方开户行">{{ needToShowInfo.otherBankName || '暂无' }}</el-descriptions-item>
				<el-descriptions-item label="操作人员">{{ needToShowInfo.userName }}</el-descriptions-item>
				<el-descriptions-item label="备注" :span="3">
					<el-tag v-if="needToShowInfo.comments" size="small" type="info">{{ needToShowInfo.comments }}</el-tag>
					<span v-else>暂无备注</span>
				</el-descriptions-item>
			</el-descriptions>
		</el-card>
		<!--    对应信息的弹窗-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="信息" :visible.sync="infoVisible" width="900px" append-to-body>
			<component :is="Components" :need-to-show-info="needToShowInfo" />
		</el-dialog>
	</div>
</template>

<style scoped lang="scss">
.money-label {
	font-weight: bold;
}

:deep(.el-descriptions__label) {
	font-weight: 600;
	color: #606266;
}

:deep(.el-descriptions__content) {
	color: #303133;
}

.el-card {
	margin-bottom: 20px;
}

.clearfix:before,
.clearfix:after {
	display: table;
	content: '';
}

.clearfix:after {
	clear: both;
}
</style>
