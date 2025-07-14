<script>
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
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
	components: { DialogWrapper },
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
		handleCheck(row) {
			// 拿到表名和id
			const { tableName, payNo } = this.needToShowInfo;
			if (!tableName || !payNo) {
				this.$message.warning('该行数据有误:模块名或者凭证号不存在');
				return;
			}
			// 根据tableName动态获取某个JS模块
			getFunction(tableName)(payNo).then(res => {
				if (!res.data) {
					this.$message.warning('查询该模块条件下，暂无详细数据');
					return;
				}
				// 填充数据
				this.needToShowInfo = res.data;
				// 根据对应表名渲染对应的展示组件
				this.Components = this.getComponents(tableName);
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
				[TableName.OFFSETTING]: OFFSETTING,
				[TableName.REBATE]: REBATE,
				[TableName.INVENTORMAIN]: INVENTORY,
				[TableName.BANK_ACCEPTANCE]: BANK_ACCEPTANCE,
				[TableName.ORDER_FREIGHT]: ORDER_FREIGHTVue
			};
			return components[tableName] || null; // 默认返回 null，如果没有匹配的 tableName
		},
		handleProcess() {},
		handleReject() {}
	}
};
</script>

<template>
	<div>
		<el-card>
			<!--      插槽 按钮-->
			<div slot="header" class="clearfix">
				<span>付款信息</span>
				<el-button type="text" @click="handleCheck" style="float: right">查看详细</el-button>
			</div>
			<el-descriptions>
				<el-descriptions-item label="所属公司">{{ needToShowInfo.companyName }}</el-descriptions-item>
				<el-descriptions-item label="资金日期">{{ needToShowInfo.fundsDate }}</el-descriptions-item>
				<el-descriptions-item label="付款类型">{{ needToShowInfo.payType }}</el-descriptions-item>
				<el-descriptions-item label="金额">{{ needToShowInfo.moneyAmount }} 元</el-descriptions-item>
				<el-descriptions-item label="付款状态">{{ needToShowInfo.paymentState }}</el-descriptions-item>
				<el-descriptions-item label="审核状态">{{ needToShowInfo.auditState }}</el-descriptions-item>
				<el-descriptions-item label="备注">
					<el-tag size="small">{{ needToShowInfo.comments }}</el-tag>
				</el-descriptions-item>
			</el-descriptions>
		</el-card>

		<div v-if="currentComponent">
			<DialogWrapper :current-component="currentComponent" :dialog-visible="dialogVisible" />
		</div>

		<!--    对应信息的弹窗-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="信息" :visible.sync="infoVisible" width="900px" append-to-body>
			<component :is="Components" :need-to-show-info="needToShowInfo" />
		</el-dialog>
	</div>
</template>

<style scoped lang="scss"></style>
