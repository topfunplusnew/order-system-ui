<script>
import { mixin_credentials_generation_orderlist } from '../../dashboard/mixins/credentials/credentials_generation_orderlist';
import InfoDialog from '../../../components/InfoDialog.vue';
import { DocumentNumber, TableName } from '../../../api/tool/enums';
import CrendentMake from '../../dashboard/components/voucher/CrendentMake.vue';
import OrderList from '../../dashboard/components/voucher/OrderList.vue';
import InvoiceList from '../../dashboard/components/voucher/InvoiceList.vue';
import InventoryList from '../../dashboard/components/voucher/InventoryList.vue';

export default {
	name: 'Generation',
	components: {
		InventoryList,
		InvoiceList,
		OrderList,
		CrendentMake,
		InfoDialog
	},
	mixins: [mixin_credentials_generation_orderlist],
	data() {
		return {
			credentialInfo: {},
			credentialList: [],
			rules: {},
			// 单据类型
			type: '',
			// 类型选项
			options: [
				{
					value: DocumentNumber.GOODS_ORDER,
					label: DocumentNumber.GOODS_ORDER
				},
				{
					value: DocumentNumber.INVOICE_IN,
					label: DocumentNumber.INVOICE_IN
				},
				{
					value: DocumentNumber.INVOICE_OUT,
					label: DocumentNumber.INVOICE_OUT
				},
				{
					value: DocumentNumber.INVOICE_OTHER,
					label: DocumentNumber.INVOICE_OTHER
				},
				{
					value: DocumentNumber.INVENTORY,
					label: DocumentNumber.INVENTORY
				}
			]
		};
	},
	computed: {
		TableName() {
			return TableName;
		},
		DocumentNumber() {
			return DocumentNumber;
		}
	},
	methods: {
		// 拿到选中的订单列表
		handleEmitGoodsOrderList(values) {
			this.selectedNeedOrderList = values;
		}
	}
};
</script>

<template>
	<div>
		<!--    借 主营业务成本-运费成本 - 68.25 运费 海运陆运之和-->
		<!--    贷 应付运费 - 陆运 应付运费 - 海运 分开写填运费-->
		<!--    凭证编号依据 模块 + 订单uuid-->
		<div style="margin: 19px 19px">
			<el-row>
				<el-select v-model="type" placeholder="单据类型" clearable>
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-row>
			<br />
			<!--      凭证生成组件-->
			<CrendentMake :need-to-make-list="needToMakeList" />
			<!--      选择单据类型后跳出的订单选择框-->
			<InfoDialog :title="'凭证生成'" :visible.sync="orderDialogVisible" @update:visible="orderDialogVisible = false">
				<!--        如果是订单-->
				<template #info>
					<!--    如果选择的是订单列表-->
					<OrderList v-if="DOC_TYPE === DocumentNumber.GOODS_ORDER" @update:selectedGoodsOrderList="handleEmitGoodsOrderList">
						<template #option>
							<!-- 生成订单中的运费 总货款 出厂货款的凭证-->
							<el-row>
								<el-button type="danger" @click="makeCredentials">生成凭证</el-button>
							</el-row>
						</template>
					</OrderList>
					<!--        如果是发票买入  -->
					<InvoiceList v-if="DOC_TYPE === DocumentNumber.INVOICE_IN" :invoice-type="TableName.INVOICE_IN" @update:selectedGoodsOrderList="handleEmitGoodsOrderList">
						<template #option>
							<!-- 生成订单中的运费 总货款 出厂货款的凭证-->
							<el-row>
								<el-button type="danger" @click="makeCredentials">生成凭证</el-button>
							</el-row>
						</template>
					</InvoiceList>
					<!--        如果是发票卖出 那么就传递卖出列表-->
					<InvoiceList v-if="DOC_TYPE === DocumentNumber.INVOICE_OUT" :invoice-type="TableName.INVOICE_OUT" @update:selectedGoodsOrderList="handleEmitGoodsOrderList">
						<template #option>
							<!-- 生成订单中的运费 总货款 出厂货款的凭证-->
							<el-row>
								<el-button type="danger" @click="makeCredentials">生成凭证</el-button>
							</el-row>
						</template>
					</InvoiceList>
					<!--        第三方-->
					<InvoiceList v-if="DOC_TYPE === DocumentNumber.INVOICE_OTHER" :invoice-type="TableName.INVOICE_OTHER" @update:selectedGoodsOrderList="handleEmitGoodsOrderList">
						<template #option>
							<!-- 生成订单中的运费 总货款 出厂货款的凭证-->
							<el-row>
								<el-button type="danger" @click="makeCredentials">生成凭证</el-button>
							</el-row>
						</template>
					</InvoiceList>

					<!--          如果是库存列表-->
					<InventoryList v-if="DOC_TYPE === DocumentNumber.INVENTORY" @update:selectedGoodsOrderList="handleEmitGoodsOrderList">
						<template #option>
							<!-- 生成订单中的运费 总货款 出厂货款的凭证-->
							<el-row>
								<el-button type="danger" @click="makeCredentials">生成凭证</el-button>
							</el-row>
						</template>
					</InventoryList>
				</template>
			</InfoDialog>

			<!--       确认选择订单页面-->
			<InfoDialog :title="'确认选择信息'" :visible.sync="CheckDialogVisible" @update:visible="CheckDialogVisible = false">
				<template #info>
					<!-- 订单确认生成票据-->
					<el-row v-if="DOC_TYPE === DocumentNumber.GOODS_ORDER">
						<!-- 订单的列表-->
						<el-table
							v-horizontal-scroll="'always'"
							fit
							border
							:data="selectedNeedOrderList"
							max-height="750"
							size="mini"
							:cell-style="
								() => {
									return { padding: '2px' };
								}
							"
						>
							<el-table-column show-overflow-tooltip label="ID" align="center" prop="id" fixed="left" />
							<el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left" />
							<el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left" />
							<el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" fixed="left" width="200">
								<template #default="scope">
									<el-row v-if="scope.row.smailOrderDetails">
										<el-row>
											<span v-for="(item, index) in getSupplierNames(scope.row.smailOrderDetails)" :key="index">
												{{ item.supplier }}
											</span>
										</el-row>
									</el-row>
									<el-row><span v-if="scope.row.supplierNames === null">无</span></el-row>
								</template>
							</el-table-column>
							<el-table-column show-overflow-tooltip label="总货款" align="center" prop="allPayments" width="100px" />
							<el-table-column show-overflow-tooltip label="出厂货款" align="center" width="100px">
								<template #default="scope">{{ getPaymentFactory(scope.row) }}</template>
							</el-table-column>
							<el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo" />
							<el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel" width="100px" />
							<el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName" width="100px" />
							<el-table-column show-overflow-tooltip label="陆运费" align="center" prop="landFreight" width="100px" />
							<el-table-column show-overflow-tooltip label="柜号" align="center" prop="seaCarNo">
								<template #default="scope">{{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}</template>
							</el-table-column>
							<el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel" width="100px">
								<template #default="scope">{{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}</template>
							</el-table-column>
							<el-table-column show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName" width="100px">
								<template #default="scope">{{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverName }}</template>
							</el-table-column>
							<el-table-column show-overflow-tooltip label="海运费" align="center" prop="seaFreight" width="100px" />
							<el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager" />
							<el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet" />
							<el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState" width="120" />
							<el-table-column show-overflow-tooltip label="开票状态" align="center" prop="invoiceState" width="120px" />
							<!--							<el-table-column show-overflow-tooltip label="打款状态" align="center" prop="paymentState" width="120px" />-->
							<el-table-column show-overflow-tooltip label="是否可编辑" align="center" prop="isedit" width="100px">
								<template slot-scope="scope">
									<el-tag :type="scope.row.isedit === 0 ? 'danger' : 'success'">
										{{ scope.row.isedit === 0 ? '否' : '是' }}
									</el-tag>
								</template>
							</el-table-column>
							<el-table-column show-overflow-tooltip label="备注" align="center" prop="comments" />
						</el-table>
					</el-row>
					<!-- 发票的列表 对第三方特殊处理-->
					<el-row v-if="DOC_TYPE === DocumentNumber.INVOICE_OTHER">
						<el-table
							id="printBox"
							v-horizontal-scroll="'always'"
							border
							:data="selectedNeedOrderList"
							fit
							size="mini"
							:cell-style="
								() => {
									return { padding: '.5px' };
								}
							"
						>
							<el-table-column label="开票日期" align="center" prop="invoiceDate" show-overflow-tooltip />
							<el-table-column label="开票金额" align="center" prop="invoiceAmount" show-overflow-tooltip />
							<el-table-column label="供应商票点" align="center" prop="supplierTicketPoint" show-overflow-tooltip />
							<el-table-column label="供应商票点金额" align="center" prop="supplierPointAmount" show-overflow-tooltip />
							<el-table-column label="供应商公司名称" align="center" prop="Supplier" show-overflow-tooltip />
							<el-table-column label="客户公司名称" align="center" prop="customer" show-overflow-tooltip />
							<el-table-column label="票据单位名称" align="center" prop="invoiceCompanyName" show-overflow-tooltip />
							<el-table-column label="客户票点" align="center" prop="customerTicketPoint" show-overflow-tooltip />
							<el-table-column label="票点金额" align="center" prop="customerPointAmount" show-overflow-tooltip />
						</el-table>
					</el-row>
					<el-row v-if="DOC_TYPE === DocumentNumber.INVOICE_IN || DOC_TYPE === DocumentNumber.INVOICE_OUT">
						<el-table
							id="printBox"
							v-horizontal-scroll="'always'"
							border
							:data="selectedNeedOrderList"
							fit
							size="mini"
							:cell-style="
								() => {
									return { padding: '.5px' };
								}
							"
						>
							<el-table-column label="开票日期" align="center" prop="invoiceDate" show-overflow-tooltip />
							<el-table-column label="我方收票主体" align="center" prop="invoiceObject" show-overflow-tooltip width="100px" />
							<el-table-column label="开票金额" align="center" prop="invoiceAmount" show-overflow-tooltip />
							<el-table-column label="对方公司类别" align="center" prop="companyType" width="100px" show-overflow-tooltip />
							<el-table-column label="对方公司名称" align="center" prop="companyName" width="100px" show-overflow-tooltip />
							<el-table-column label="票据单位名称" align="center" prop="invoiceCompanyName" show-overflow-tooltip width="100px" />
							<el-table-column label="票点" align="center" prop="ticketPoint" show-overflow-tooltip />
							<el-table-column label="票点金额" align="center" prop="ticketPointAmount" show-overflow-tooltip />
							<el-table-column label="审核状态" align="center" prop="checkState" width="240">
								<template #default="scope">
									<el-row>
										{{ scope.row.checkState }}
									</el-row>
								</template>
							</el-table-column>
						</el-table>
					</el-row>

					<el-row v-if="DOC_TYPE === DocumentNumber.INVENTORY">
						<el-table
							v-horizontal-scroll="'always'"
							border
							:data="selectedNeedOrderList"
							:cell-style="
								() => {
									return { padding: '2px' };
								}
							"
							size="mini"
						>
							<el-table-column label="仓库名称" align="center" prop="storeHouseName" width="150" />
							<el-table-column label="入库日期" align="center" prop="storeDate" width="150" />
							<el-table-column label="库存量" align="center" prop="stockNumber" width="150" />
							<el-table-column label="供应商" align="center" prop="supplier" width="150" />
							<el-table-column label="级别编码" align="center" prop="levelID" width="150" />
							<el-table-column label="级别名称" align="center" prop="levelName" width="150" />
							<el-table-column label="计量单位" align="center" prop="countingUnit" width="150" />
							<el-table-column label="厚度" align="center" prop="height" width="150" />
							<el-table-column label="长度" align="center" prop="length" width="150" />
							<el-table-column label="宽度" align="center" prop="width" width="150" />
							<el-table-column label="出厂片数" align="center" prop="pieces" width="150" />
							<el-table-column label="每包片数" align="center" prop="piecesPerPack" width="150" />
							<el-table-column label="包数" align="center" prop="packs" width="150" />
							<el-table-column label="出厂单价" align="center" prop="price" width="150" />
							<el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory" width="150">
								<template slot-scope="scope">
									{{ scope.row.isIncludeTaxFactory === 0 ? '否' : '是' }}
								</template>
							</el-table-column>
							<el-table-column label="杂费" align="center" prop="sundryCost" width="150" />
							<el-table-column label="出厂货款" align="center" prop="paymentFactory" width="150" />
							<el-table-column label="卸货价" align="center" prop="paymentUnload" width="150" />
							<el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale" width="150">
								<template slot-scope="scope">
									{{ scope.row.isIncludeTaxSale === 0 ? '否' : '是' }}
								</template>
							</el-table-column>
							<el-table-column label="总货款" align="center" prop="payments" width="150" />
							<el-table-column label="陆运车牌" align="center" prop="landCarNo" width="150" />
							<el-table-column label="陆运司机电话" align="center" prop="landDriverTel" width="150" />
							<el-table-column label="陆地司机姓名" align="center" prop="landDriverName" width="150" />
							<el-table-column label="误差" align="center" prop="erro" width="150" />
							<el-table-column label="吨位" align="center" prop="tonnage" width="150" />
							<el-table-column label="陆运费单价" align="center" prop="landFreightPrice" width="150" />
							<el-table-column label="陆运费" align="center" prop="landFreight" width="150" />
							<el-table-column label="其他费用" align="center" prop="otherCost" width="150" />
							<el-table-column label="利润" align="center" prop="profit" width="150" />
							<el-table-column label="不含税利润" align="center" prop="profitNoTax" width="150" />
							<el-table-column label="卸货片数" align="center" prop="actualPieces" width="150" />
							<el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry" width="150" />
							<el-table-column label="加费" align="center" prop="additionalFees" width="150" />
							<el-table-column label="返利金额" align="center" prop="rebate" width="150" />
							<el-table-column label="客户佣金" align="center" prop="customerCommission" width="150" />
							<el-table-column label="备注" align="center" prop="comments" width="150" />
						</el-table>
					</el-row>
					<div style="text-align: center">
						<el-button type="primary" @click="submitMakeCredentials">确定生成</el-button>
					</div>
				</template>
			</InfoDialog>
		</div>
	</div>
</template>

<style scoped lang="scss"></style>
