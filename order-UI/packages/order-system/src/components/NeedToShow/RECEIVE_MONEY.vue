<script>
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
	name: 'RECEIVEMONEY',
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
				<span>收款信息</span>
				<el-button type="text" @click="handleCheck" style="float: right">查看详细</el-button>
			</div>
			<el-descriptions>
				<el-descriptions-item label="所属公司">{{ needToShowInfo.companyName }}</el-descriptions-item>
				<el-descriptions-item label="收款编号">{{ needToShowInfo.receiveNO }}</el-descriptions-item>
				<el-descriptions-item label="资金日期">{{ needToShowInfo.fundsDate }}</el-descriptions-item>
				<el-descriptions-item label="收款类型">{{ needToShowInfo.receiveType }}</el-descriptions-item>
				<el-descriptions-item label="金额">{{ needToShowInfo.moneyAmount }} 元</el-descriptions-item>
				<el-descriptions-item label="付款账户名称">{{ needToShowInfo.selfAcountsName }}</el-descriptions-item>
				<el-descriptions-item label="付款银行账号">{{ needToShowInfo.selfBankNo }}</el-descriptions-item>
				<el-descriptions-item label="付款银行名称">{{ needToShowInfo.selfBankName }}</el-descriptions-item>
				<el-descriptions-item label="付款银行类型">{{ needToShowInfo.selfBankCardType }}</el-descriptions-item>
				<el-descriptions-item label="收款账户名称">{{ needToShowInfo.otherAcountsName }}</el-descriptions-item>
				<el-descriptions-item label="收款银行账号">{{ needToShowInfo.otherBankNo }}</el-descriptions-item>
				<el-descriptions-item label="收款银行名称">{{ needToShowInfo.otherBankName }}</el-descriptions-item>
				<el-descriptions-item label="收款银行类型">{{ needToShowInfo.otherBankCardType }}</el-descriptions-item>
				<el-descriptions-item label="备注">
					<el-tag size="small">{{ needToShowInfo.comments }}</el-tag>
				</el-descriptions-item>
			</el-descriptions>
		</el-card>
		<!--    对应信息的弹窗-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  title="信息" :visible.sync="infoVisible" width="900px" append-to-body>
			<component :is="Components" :need-to-show-info="needToShowInfo" />
		</el-dialog>
	</div>
</template>

<style scoped lang="scss"></style>
