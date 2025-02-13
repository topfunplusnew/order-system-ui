<script>
import { getGoodsOrder } from '@/api/system/goodsOrder';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { batchInvoice } from '@/api/system/excel';
import INVOICE_OUT from '@/components/NeedToShow/INVOICE_OUT.vue';
import { TableName } from '@/api/tool/enums';
import INVOICE_IN from '@/components/NeedToShow/INVOICE_IN.vue';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';

export default {
	name: 'ReadyList',
	components: { DialogWrapper },
	mixins: [common_dialog],
	props: {
		list: {
			type: Array,
			default: () => []
		}
	},
	data() {
		return {
			orderInfo: null,
			// 错误的信息
			errorInfo: null
		};
	},
	methods: {
		// 查看订单的信息
		checkOrderInfo(row) {
			getGoodsOrder(row.isOrderTax).then(res => {
				this.orderInfo = res.data;
				// 打开弹窗
				this.openDialog(
					GOODS_ORDER,
					'订单信息',
					'1000px',
					{
						needToShowInfo: this.orderInfo
					},
					true
				);
			});
		},
		// 业务逻辑方法
		async handleProcess(that) {
			const invoices = this.list.filter(item => item !== null);
			const res = await batchInvoice(invoices);
			const target = this.checkInvoice(res.data);
			// 如果成功
			return new Promise((resolve, reject) => {
				if (target.flag) {
					// 发送时间 告诉订单列表重新加载
					that.dialogVisible = false;
					this.$bus.$emit('select-goods:update');
					this.$message.success('本批开票成功');
					resolve();
				} else {
					reject();
					this.$message.error('本批开票有误，请检查');
					const uuid = target.uuid;
					// 查找该出错的信息
					invoices.forEach(item => {
						if (item.uuid === uuid) {
							// 判断一下tableName
							switch (item.tableName) {
								case TableName.INVOICE_OUT: {
									// 打开弹窗 让用户知道 并且去修改
									this.openDialog(
										INVOICE_OUT,
										'发票信息',
										'900px',
										{
											needToShowInfo: item
										},
										false
									);
									break;
								}
								case TableName.INVOICE_IN: {
									// 打开弹窗 让用户知道 并且去修改
									this.openDialog(
										INVOICE_IN,
										'发票信息',
										'900px',
										{
											needToShowInfo: item
										},
										false
									);
								}
							}
						}
					});
				}
			});
		},
		handleReject() {},
		// 检查是否开成功了
		checkInvoice(data) {
			let result = {};
			for (let item of data) {
				if (item.result !== 'success') {
					result.message = item.result;
					result.uuid = item.uuid;
					result.flag = false;
				} else {
					result.flag = true;
				}
			}
			return result;
		}
	}
};
</script>

<template>
	<div>
		<!--    通用弹窗 配合common_dialogs 使用-->
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
		<el-table
			:data="list"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
		>
			<el-table-column
				label="开票日期"
				align="center"
				prop="invoiceDate"
				show-overflow-tooltip
			/>
			<el-table-column
				label="我方开票实体"
				align="center"
				prop="invoiceObject"
				show-overflow-tooltip
			/>
			<el-table-column
				label="开票金额"
				align="center"
				prop="invoiceAmount"
				show-overflow-tooltip
			/>
			<el-table-column
				label="公司类别"
				align="center"
				prop="companyType"
				show-overflow-tooltip
			/>
			<el-table-column
				label="公司名称"
				align="center"
				prop="companyName"
				show-overflow-tooltip
			/>
			<el-table-column
				label="票据单位名称"
				align="center"
				prop="invoiceCompanyName"
				show-overflow-tooltip
			/>
			<el-table-column
				label="票点"
				align="center"
				prop="ticketPoint"
				show-overflow-tooltip
			/>
			<el-table-column
				label="票点金额"
				align="center"
				prop="ticketPointAmount"
				show-overflow-tooltip
			/>
			<el-table-column
				label="备注"
				align="center"
				prop="comments"
				show-overflow-tooltip
			/>
			<el-table-column
				label="订单信息"
				align="center"
				prop="isOrderTax"
				width="180"
			>
				<template slot-scope="scope">
					<el-row v-if="scope.row.isOrderTax === 0">无关联订单</el-row>
					<el-row v-else>
						<el-button
							size="mini"
							type="text"
							@click="checkOrderInfo(scope.row)"
							>查看订单信息
						</el-button>
					</el-row>
				</template>
			</el-table-column>
			<!--			<el-table-column-->
			<!--				label="操作"-->
			<!--				align="center"-->
			<!--				class-name="small-padding fixed-width"-->
			<!--				width="150px"-->
			<!--			>-->
			<!--				<template slot-scope="scope">-->
			<!--					<el-button size="mini" type="primary" @click="handleUpdate(scope.row)"-->
			<!--						>修改-->
			<!--					</el-button>-->
			<!--					<el-button size="mini" type="danger" @click="handleDelete(scope.row)"-->
			<!--						>删除-->
			<!--					</el-button>-->
			<!--				</template>-->
			<!--			</el-table-column>-->
		</el-table>
	</div>
</template>

<style scoped lang="scss"></style>
