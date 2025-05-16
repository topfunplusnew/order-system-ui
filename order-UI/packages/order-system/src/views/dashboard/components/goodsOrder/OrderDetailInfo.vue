<!--订单详情列表-->

<script>
import { addRebate } from '@/api/system/Rebate';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { listBankAccount } from '@/api/system/bankAccount';
import { getDicts } from '../../../../api/system/dict/data';
import { fix_2 } from '../../../../api/tool/format';
export default {
	name: 'OrderDetailInfo',
	components: { SearchOption },
	props: {
		orderDetailInfoList: {
			type: Array
		},
		ban: {
			type: Boolean,
			default: false
		}
	},
	data() {
		return {
			addMoneyBackVisible: false,
			// 返利回扣信息
			moneyBackInfo: {
				orderDetailID: '',
				rebateDate: '',
				rebate: '',
				rebateMethod: '',
				inAcountsName: '',
				inBankNo: '',
				supplier: '',
				outAcountsName: '',
				outBankNo: '',
				rebateReason: '',
				comments: ''
			},
			// 从字典中拿
			rebateMethods: [],
			loading: false
		};
	},
	created() {
		// 拿取返利方式
		this.listRebateMethods();
	},
	methods: {
		listBankAccount,
		listCompany,
		getSummaries(param) {
			const { columns, data } = param;
			const sums = [];
			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '合计';
					return;
				}
				const includes = [14, 19, 21, 24, 26, 28];
				if (!data || data.length === 0) return;
				const values = data.map(item => Number(item[column.property]));
				if (!values.every(value => isNaN(value))) {
					// 包含的计算
					if (includes.includes(index)) {
						sums[index] = values.reduce((prev, curr) => {
							const value = Number(curr);
							if (!isNaN(value)) {
								return prev + curr;
							} else {
								return prev;
							}
						}, 0);
						sums[index] = fix_2(sums[index]);
						sums[index] += '';
					}
				}
			});

			return sums;
		},
		// 返利方式
		listRebateMethods() {
			getDicts('order_rebate_type').then(res => {
				this.rebateMethods = res.data;
			});
		},
		// 每一个组件必须要实现的方法
		handleProcess(that) {
			that.dialogVisible = false;
		},
		handleReject() {
			console.log('order-detail-reject');
		},
		// 点击确认
		handleCommitBankAccount(val) {
			this.moneyBackInfo.inAcountsName = val.acountsName;
			this.moneyBackInfo.inBankNo = val.bankNo;
		},
		handleCommitCompany(val) {
			this.moneyBackInfo.supplierID = val.id;
			this.moneyBackInfo.supplier = val.companyName;
		},
		// 返利回扣
		handleMoneyBack(row) {
			this.reset();
			this.moneyBackInfo.orderDetailIds.push(row.id);
			this.addMoneyBackVisible = true;
		},
		// 添加返利回扣信息
		addMoneyBackInfo() {
			addRebate(this.moneyBackInfo).then(res => {
				this.$message.success('添加成功~');
				this.addMoneyBackVisible = false;
			});
		},
		// 重置moneyBackInfo
		reset() {
			this.moneyBackInfo = {
				orderDetailIds: [],
				rebateDate: '',
				rebate: '',
				rebateMethod: '',
				inAcountsName: '',
				inBankNo: '',
				supplier: '',
				outAcountsName: '',
				outBankNo: '',
				rebateReason: '',
				comments: ''
			};
		}
	}
};
</script>

<template>
	<div>
		<el-row>
			<el-col :span="8">
				<span style="font-weight: bolder">订单货物详情列表</span>
			</el-col>
		</el-row>
		<el-row>
			<el-table
				id="printBox"
				border
				:data="orderDetailInfoList"
				max-height="700"
				:cell-style="
					() => {
						return { padding: '.5px' };
					}
				"
				size="mini"
				show-summary
				:summary-method="getSummaries"
			>
				<el-table-column v-if="!ban" label="操作" align="center" class-name="small-padding fixed-width" width="170px" fixed="left">
					<template slot-scope="scope">
						<el-button size="mini" type="warning" @click="handleMoneyBack(scope.row)">货物返利</el-button>
					</template>
				</el-table-column>
				<el-table-column label="仓库名称" align="center" prop="storeHouseName" show-overflow-tooltip>
					<!--          如果有 显示 如果没有 显示- -->
					<template slot-scope="scope">
						{{ scope.row.storeHouseName ? scope.row.storeHouseName : '-' }}
					</template>
				</el-table-column>
				<el-table-column label="供应商" align="center" prop="supplier" show-overflow-tooltip />
				<el-table-column label="级别名称" align="center" prop="levelName" show-overflow-tooltip />
				<el-table-column label="计量单位" align="center" prop="countingUnit" show-overflow-tooltip />
				<el-table-column label="厚度" align="center" prop="height" show-overflow-tooltip />
				<el-table-column label="长度" align="center" prop="length" show-overflow-tooltip />
				<el-table-column label="宽度" align="center" prop="width" show-overflow-tooltip />
				<el-table-column label="每包片数" align="center" prop="piecesPerPack" show-overflow-tooltip />
				<el-table-column label="包数" align="center" prop="packs" show-overflow-tooltip />
				<el-table-column label="出厂片数" align="center" prop="pieces" show-overflow-tooltip />

				<el-table-column label="出厂单价" align="center" prop="price" show-overflow-tooltip />
				<el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory" show-overflow-tooltip>
					<template slot-scope="scope">
						<el-tag disable-transitions>{{ scope.row.isIncludeTaxFactory === 0 ? '否' : '是' }}</el-tag>
					</template>
				</el-table-column>
				<el-table-column label="杂费" align="center" prop="sundryCost" show-overflow-tooltip />
				<el-table-column label="出厂货款" align="center" prop="paymentFactory" show-overflow-tooltip />
				<el-table-column label="卸货片数" align="center" prop="actualPieces" show-overflow-tooltip />
				<el-table-column label="卸货价" align="center" prop="paymentUnload" show-overflow-tooltip />
				<el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale" show-overflow-tooltip>
					<template slot-scope="scope">
						<el-tag disable-transitions>{{ scope.row.isIncludeTaxSale === 0 ? '否' : '是' }}</el-tag>
					</template>
				</el-table-column>
				<el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry" show-overflow-tooltip />
				<el-table-column label="总货款" align="center" prop="payments" show-overflow-tooltip />
				<el-table-column label="误差" align="center" prop="erro" show-overflow-tooltip />
				<el-table-column label="吨位" align="center" prop="tonnage" show-overflow-tooltip />
				<el-table-column label="陆运费单价" align="center" prop="landFreightPrice" show-overflow-tooltip />
				<el-table-column label="加费" align="center" prop="additionalFees" show-overflow-tooltip />
				<el-table-column label="陆运费" align="center" prop="landFreight" show-overflow-tooltip />
				<el-table-column label="海运费" align="center" prop="seaFreight" show-overflow-tooltip />
				<el-table-column label="总运费" align="center" prop="freight" show-overflow-tooltip />
				<el-table-column label="其他费用" align="center" prop="otherCost" show-overflow-tooltip />
				<el-table-column label="利润" align="center" prop="profit" show-overflow-tooltip />
				<el-table-column label="不含税利润" align="center" prop="profitNoTax" show-overflow-tooltip />
				<el-table-column label="备注" align="center" prop="comments" show-overflow-tooltip />
				<el-table-column label="物流利润" align="center" prop="logisticsProfit" show-overflow-tooltip />
				<el-table-column label="客户佣金" align="center" prop="customerCommission" show-overflow-tooltip />
				<el-table-column label="厂家佣金" align="center" prop="factoryCommission" show-overflow-tooltip />
				<el-table-column label="计提厂家返利金额" align="center" prop="factoryRebateAmount" show-overflow-tooltip />
				<el-table-column label="计提厂家降价金额" align="center" prop="factoryDiscountAmount" show-overflow-tooltip />
			</el-table>
		</el-row>

		<!--    返利回扣-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" title="添加返利信息" :visible.sync="addMoneyBackVisible" width="40%" append-to-body>
			<el-form :model="moneyBackInfo" label-width="80px">
				<el-form-item label="日期" prop="rebateDate">
					<el-date-picker v-model="moneyBackInfo.rebateDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
				</el-form-item>
				<el-form-item label="金额" prop="rebate">
					<el-input v-model="moneyBackInfo.rebate" placeholder="请输入金额" />
				</el-form-item>
				<el-form-item label="供应商" prop="supplier">
					<el-row>
						<el-col :span="10">
							<el-input v-model="moneyBackInfo.supplier" placeholder="请输入供应商" />
						</el-col>
						<el-col :span="3">
							<SearchOption :get-data="listCompany" :limit-info="{ companyType: '供应商' }" @commitBack="handleCommitCompany">
								<template #table-columns>
									<el-table-column label="公司名称" align="center" prop="companyName" />
									<el-table-column label="老板姓名" align="center" prop="leader" />
									<el-table-column label="老板电话" align="center" prop="leaderTel" />
									<el-table-column label="开户行" align="center" prop="bankName" />
									<el-table-column label="开户名" align="center" prop="acountsName" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="返利方式" prop="rebateMethod">
					<el-select v-model="moneyBackInfo.rebateMethod" default-first-option placeholder="请选择返利方式">
						<el-option v-for="item in rebateMethods" :key="item.dictValue" :label="item.dictLabel" :value="item.dictLabel"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="返利原因" prop="rebateReason">
					<el-input v-model="moneyBackInfo.rebateReason" placeholder="请输入返利原因" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="moneyBackInfo.comments" placeholder="请输入备注" />
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button @click="addMoneyBackVisible = false">取 消</el-button>
				<el-button type="primary" @click="addMoneyBackInfo">添加</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss"></style>
