<!--订单详情列表-->

<script>
import { addRebate } from '@/api/system/Rebate';
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { listBankAccount } from '@/api/system/bankAccount';
// 不再通过字典接口获取返利方式，使用硬编码选项
import { fix_2 } from '../../../../api/tool/format';
import { RebateType } from '@/api/tool/enums';

export default {
	name: 'OrderDetailInfo',
	components: { SearchOption },
	props: {
		orderDetailInfoList: {
			type: Array,
			default: () => []
		},
		ban: {
			type: Boolean,
			default: false
		}
	},
	computed: {
		RebateType() {
			return RebateType;
		}
	},
	data() {
		return {
			addMoneyBackVisible: false,
			// 返利回扣信息
			moneyBackInfo: {
				// 后端期望的是 orderDetailIds 数组
				orderDetailIds: [],
				rebateDate: '',
				// （返利/降价）单价
				unitPrice: null,
				// 最终金额
				rebate: '',
				// 使用 RebateType 常量（Weight / Square）
				rebateMethod: RebateType.Weight,
				// 供应商/账号信息
				inAcountsName: '',
				inBankNo: '',
				supplier: '',
				outAcountsName: '',
				outBankNo: '',
				rebateReason: '',
				comments: '',
				// 计算字段：面积 / 重箱
				area: 0,
				weightBox: 0
			},
			// 硬编码的返利方式：重箱(Weight)、面积(Square)，值使用 RebateType
			rebateMethods: [
				{ dictValue: RebateType.Weight, dictLabel: '重箱' },
				{ dictValue: RebateType.Square, dictLabel: '面积' }
			],
			loading: false
		};
	},
	// 不再需要在 created 中请求字典，返利方式已硬编码
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
				// 根据是否显示操作列来调整索引
				// ban=false时(有操作列): 杂费14, 总货款杂费19, 总货款21, 陆运费24, 总运费26, 利润28, 不含税利润29
				// ban=true时(无操作列): 杂费13, 总货款杂费18, 总货款20, 陆运费23, 总运费25, 利润27, 不含税利润28
				const includes = this.ban ? [13, 18, 20, 23, 25, 27, 28] : [14, 19, 21, 24, 26, 28, 29];
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

		// 每一个组件必须要实现的方法
		handleProcess(that) {
			that.dialogVisible = false;
			return Promise.resolve();
		},
		handleReject() {
			return Promise.resolve();
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
		// 返利回扣（从行创建）
		handleMoneyBack(row) {
			this.reset();
			// 通过行确定订单明细 id
			this.moneyBackInfo.orderDetailIds = [row.id];
			// 按照 rebate/index.vue 的公式计算该行的面积与重箱
			const area = (Number(row.length) * Number(row.width) * Number(row.pieces)) / 1000000 || 0;
			const weightBox = (Number(row.height) * Number(row.length) * Number(row.width) * Number(row.pieces)) / 1000000 / 20 || 0;
			this.moneyBackInfo.area = area;
			this.moneyBackInfo.weightBox = weightBox;
			// 默认选重箱（与主页面一致）
			this.moneyBackInfo.rebateMethod = RebateType.Weight;
			this.addMoneyBackVisible = true;
		},
		// 添加返利回扣信息（提交前计算金额并转换 rebateMethod）
		addMoneyBackInfo() {
			// 计算金额：根据选择的返利方式，使用面积或重箱乘以单价
			const base = this.moneyBackInfo.rebateMethod === RebateType.Weight ? this.moneyBackInfo.weightBox : this.moneyBackInfo.area;
			const unit = Number(this.moneyBackInfo.unitPrice) || 0;
			this.moneyBackInfo.rebate = fix_2((base || 0) * unit);
			// 不要直接修改组件使用的 rebateMethod（仍为 RebateType），为后端构造 payload 时转换为 1/2
			const payload = Object.assign({}, this.moneyBackInfo, {
				rebateMethod: this.moneyBackInfo.rebateMethod === RebateType.Weight ? 1 : 2
			});
			addRebate(payload).then(res => {
				this.$message.success('添加成功~');
				this.addMoneyBackVisible = false;
			});
		},
		// 重置moneyBackInfo
		reset() {
			this.moneyBackInfo = {
				orderDetailIds: [],
				rebateDate: '',
				unitPrice: null,
				rebate: '',
				rebateMethod: RebateType.Weight,
				inAcountsName: '',
				inBankNo: '',
				supplier: '',
				outAcountsName: '',
				outBankNo: '',
				rebateReason: '',
				comments: '',
				area: 0,
				weightBox: 0
			};
		}
	}
};
</script>

<template>
	<div>
		<el-row>
			<el-col :span="8">
				<span style="font-weight: bolder">单货物详情列表</span>
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
				<el-table-column v-if="!ban" label="操作" align="center" class-name="small-padding fixed-width" width="70px" fixed="left">
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
				<el-table-column label="供应商" align="center" prop="supplier" show-overflow-tooltip width="120" />
				<el-table-column label="级别名称" align="center" prop="levelName" min-width="120" />
				<el-table-column label="计量单位" align="center" prop="countingUnit" show-overflow-tooltip width="70" />
				<el-table-column label="厚度" align="center" prop="height" show-overflow-tooltip width="50" />
				<el-table-column label="长度" align="center" prop="length" show-overflow-tooltip width="50" />
				<el-table-column label="宽度" align="center" prop="width" show-overflow-tooltip width="50" />
				<el-table-column label="每包片数" align="center" prop="piecesPerPack" show-overflow-tooltip width="70" />
				<el-table-column label="包数" align="center" prop="packs" show-overflow-tooltip width="50" />
				<el-table-column label="出厂片数" align="center" prop="pieces" show-overflow-tooltip width="70" />
				<el-table-column label="出厂单价" align="center" prop="price" show-overflow-tooltip width="70" />

				<el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory" show-overflow-tooltip>
					<template slot-scope="scope">
						<el-tag disable-transitions>{{ scope.row.isIncludeTaxFactory == 0 ? '否' : '是' }}</el-tag>
					</template>
				</el-table-column>
				<el-table-column label="杂费" align="center" prop="sundryCost" show-overflow-tooltip />
				<el-table-column label="出厂货款" align="center" prop="paymentFactory" show-overflow-tooltip />
				<el-table-column label="卸货片数" align="center" prop="actualPieces" show-overflow-tooltip />
				<el-table-column label="卸货价" align="center" prop="paymentUnload" show-overflow-tooltip />
				<el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale" show-overflow-tooltip>
					<template slot-scope="scope">
						<el-tag disable-transitions>{{ scope.row.isIncludeTaxSale == 0 ? '否' : '是' }}</el-tag>
					</template>
				</el-table-column>
				<el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry" show-overflow-tooltip />
				<el-table-column label="总货款" align="center" prop="payments" show-overflow-tooltip width="100px" />
				<el-table-column label="误差" align="center" prop="erro" show-overflow-tooltip width="50px" />
				<el-table-column label="吨位" align="center" prop="tonnage" show-overflow-tooltip width="50px" />
				<el-table-column label="陆运费单价" align="center" prop="landFreightPrice" show-overflow-tooltip width="50px" />
				<el-table-column label="加费" align="center" prop="additionalFees" show-overflow-tooltip width="50px" />
				<el-table-column label="陆运费" align="center" prop="landFreight" show-overflow-tooltip width="50px" />
				<el-table-column label="海运费" align="center" prop="seaFreight" show-overflow-tooltip width="50px" />
				<el-table-column label="总运费" align="center" prop="freight" show-overflow-tooltip width="100px" />
				<el-table-column label="其他费用" align="center" prop="otherCost" show-overflow-tooltip width="50px" />
				<el-table-column label="利润" align="center" prop="profit" show-overflow-tooltip width="90px" />
				<el-table-column label="不含税利润" align="center" prop="profitNoTax" show-overflow-tooltip width="90px" />
				<el-table-column label="备注" align="center" prop="comments" show-overflow-tooltip width="50px" />
				<el-table-column label="物流利润" align="center" prop="logisticsProfit" show-overflow-tooltip width="100px" />
				<el-table-column label="客户佣金" align="center" prop="customerCommission" show-overflow-tooltip width="100px" />
				<el-table-column label="厂家佣金" align="center" prop="factoryCommission" show-overflow-tooltip width="100px" />
				<el-table-column label="计提厂家返利金额" align="center" prop="factoryRebateAmount" show-overflow-tooltip width="120px" />
				<el-table-column label="计提厂家降价金额" align="center" prop="factoryDiscountAmount" show-overflow-tooltip width="120px" />
			</el-table>
		</el-row>

		<!--    返利回扣-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" title="添加返利信息" :visible.sync="addMoneyBackVisible" width="40%" append-to-body>
			<el-form :model="moneyBackInfo" label-width="80px">
				<el-form-item label="日期" prop="rebateDate">
					<el-date-picker v-model="moneyBackInfo.rebateDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
				</el-form-item>
				<!-- （返利/降价）单价 -->
				<el-form-item label="（返利/降价）单价" prop="unitPrice">
					<el-input v-model="moneyBackInfo.unitPrice" placeholder="请输入（返利/降价）单价" />
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
						<el-option v-for="item in rebateMethods" :key="item.dictValue" :label="item.dictLabel" :value="item.dictValue"></el-option>
					</el-select>
				</el-form-item>
				<!-- 重箱值 -->
				<el-form-item label="重箱值" prop="weightBox" v-if="moneyBackInfo.rebateMethod === RebateType.Weight">
					<el-input v-model="moneyBackInfo.weightBox" placeholder="根据订单自动计算" disabled />
				</el-form-item>
				<!-- 面积值 -->
				<el-form-item label="面积值" prop="area" v-if="moneyBackInfo.rebateMethod === RebateType.Square">
					<el-input v-model="moneyBackInfo.area" placeholder="根据订单自动计算" disabled />
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

<style scoped lang="scss">
// 表格滚动条样式
::v-deep .el-table__body-wrapper {
	&::-webkit-scrollbar {
		width: 12px;
		height: 22px;
	}

	&::-webkit-scrollbar-thumb {
		background-color: #909399;
		border-radius: 2px;
		border: 2px solid #f2f6fc;

		&:hover {
			background-color: #606266;
		}
	}

	&::-webkit-scrollbar-track {
		background-color: #f2f6fc;
		border-radius: 6px;
	}
}

// 全局滚动条样式
::-webkit-scrollbar {
	width: 12px;
	height: 22px;
}

::-webkit-scrollbar-thumb {
	background-color: #909399;
	border-radius: 6px;
	border: 2px solid #f2f6fc;

	&:hover {
		background-color: #606266;
	}
}

::-webkit-scrollbar-track {
	background-color: #f2f6fc;
	border-radius: 6px;
}
</style>
