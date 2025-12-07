<script>
import { create, all } from 'mathjs';
import { getGoodsOrder } from '@/api/system/goodsOrder';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { batchInvoice } from '@/api/system/excel';
import INVOICE_OUT from '@/components/NeedToShow/INVOICE_OUT.vue';
import { TableName } from '@/api/tool/enums';
import INVOICE_IN from '@/components/NeedToShow/INVOICE_IN.vue';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';

const math = create(all, { number: 'BigNumber', precision: 64 });

export default {
	name: 'ReadyList',
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
			if (invoices.length === 0) {
				this.$message.error('开票信息为空');
				return;
			}
			if (!this.validateBatchAmounts(invoices)) {
				return;
			}
			const res = await batchInvoice(invoices);
			if (!res.data && !res.rows) {
				this.$message.error('批量开票出现问题：返回结果非法');
				return;
			}
			const target = this.checkInvoice(res.data);
			if (!target) {
				this.$message.error('批量开票出现问题：返回结果非法');
				return;
			}
			return new Promise((resolve, reject) => {
				// 如果成功
				if (target.flag) {
					// 发送时间 告诉订单列表重新加载
					that.dialogVisible = false;
					this.$bus.$emit('select-goods:update');
					// 清理发票相关状态：清空已生成的发票列表和开票金额
					if (this.$store && this.$store.dispatch) {
						this.$store.dispatch('excel/clearSelectedInvoiceList');
						this.$store.dispatch('excel/clearInvoiceAmount');
					}
					// 清理 sessionStorage 中可能的临时开票数据
					sessionStorage.removeItem('invoiceAmount');
					sessionStorage.removeItem('us');
					// 广播一个统一的清理事件，QueueInvoiceList 等组件会监听并做局部清理
					this.$bus.$emit('invoice-clear');
					this.$message.success('本批开票成功');
					resolve();
				} else {
					this.$message.error('本批开票有误 请检查错误信息后重新提交');
					reject();
					setTimeout(() => {
						const uuid = target.uuid;
						for (let i = 0; i < invoices.length; i++) {
							const item = invoices[i];
							const index = i;
							if (item.uuid === uuid) {
								// 查找该出错的信息 提示用户
								this.$message.error(`第${index}条信息发生错误:${item.result}`);
								// 判断一下tableName
								switch (item.tableName) {
									case TableName.INVOICE_OUT: {
										// 打开弹窗 让用户知道 并且去修改
										this.openDialog(
											INVOICE_OUT,
											'出错的发票信息',
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
											'出错的发票信息',
											'900px',
											{
												needToShowInfo: item
											},
											false
										);
									}
								}
								break;
							}
						}
					}, 1000);
				}
			});
		},
		handleReject() {
			return Promise.resolve();
		},
		validateBatchAmounts(invoices = []) {
			if (!invoices.length) {
				return true;
			}
			// 从 batchDetailRows 构建校验信息
			const batchDetailRows = this.$store?.getters?.batchDetailRows || [];
			if (!batchDetailRows.length) {
				return true;
			}

			// 构建每个批次记录ID的预期金额映射
			const expectedAmountMap = {};
			batchDetailRows.forEach(row => {
				if (row.id && !row.invoiced) {
					expectedAmountMap[row.id] = Number(row.total || 0);
				}
			});

			const sums = {};
			invoices.forEach(item => {
				const batchId = item?.batchInvoiceId;
				if (!batchId) return;
				if (!sums[batchId]) {
					sums[batchId] = math.bignumber(0);
				}
				sums[batchId] = math.add(sums[batchId], math.bignumber(item.invoiceAmount || 0));
			});

			for (const batchId of Object.keys(sums)) {
				const expectedAmount = expectedAmountMap[batchId];
				if (expectedAmount === undefined) {
					continue;
				}
				const expected = math.bignumber(expectedAmount);
				const diff = math.subtract(sums[batchId], expected);
				if (!math.equal(math.round(diff, 2), math.bignumber(0))) {
					const sumFormatted = Number(math.format(sums[batchId], { precision: 12, notation: 'fixed' })).toFixed(2);
					const expectedFormatted = Number(math.format(expected, { precision: 12, notation: 'fixed' })).toFixed(2);
					this.$message.error(`批次记录 ${batchId} 的开票金额 ${sumFormatted} 与导入金额 ${expectedFormatted} 不一致`);
					return false;
				}
			}
			return true;
		},
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
		<el-table
			:data="list"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
		>
			<el-table-column label="开票日期" align="center" prop="invoiceDate" show-overflow-tooltip />
			<el-table-column label="我方开票实体" align="center" prop="invoiceObject" show-overflow-tooltip />
			<el-table-column label="开票金额" align="center" prop="invoiceAmount" show-overflow-tooltip />
			<el-table-column label="公司类别" align="center" prop="companyType" show-overflow-tooltip />
			<el-table-column label="公司名称" align="center" prop="companyName" show-overflow-tooltip />
			<el-table-column label="票据单位名称" align="center" prop="invoiceCompanyName" show-overflow-tooltip />
			<el-table-column label="票点" align="center" prop="ticketPoint" show-overflow-tooltip />
			<el-table-column label="票点金额" align="center" prop="ticketPointAmount" show-overflow-tooltip />
			<el-table-column label="备注" align="center" prop="comments" show-overflow-tooltip />
			<el-table-column label="订单信息" align="center" prop="isOrderTax" width="180">
				<template slot-scope="scope">
					<el-row v-if="scope.row.isOrderTax === 0">无关联订单</el-row>
					<el-row v-else>
						<el-button size="mini" type="text" @click="checkOrderInfo(scope.row)">查看订单信息</el-button>
					</el-row>
				</template>
			</el-table-column>
		</el-table>
	</div>
</template>

<style scoped lang="scss"></style>
