<!--司机科目明细表-->

<script>
import {
	getFreightSubjectDetailSummary,
	getFreightSubjectDetailSummarySomeDay
} from '@/api/system/statement';
import { TableName } from '@/api/tool/enums';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';
import INVENTORY from '@/components/NeedToShow/INVENTORY.vue';
import INVOICE_IN from '@/components/NeedToShow/INVOICE_IN.vue';
import INVOICE_ORTHER from '@/components/NeedToShow/INVOICE_ORTHER.vue';
import INVOICE_OUT from '@/components/NeedToShow/INVOICE_OUT.vue';
import OFFSETTING from '@/components/NeedToShow/OFFSETTING.vue';
import ORDER_DETAIL from '@/components/NeedToShow/ORDER_DETAIL.vue';
import PAYMENT from '@/components/NeedToShow/PAYMENT.vue';
import REBATE from '@/components/NeedToShow/REBATE.vue';
import { getFunction } from '@/utils/order/mapper';
import TotalTag from '@/views/system/Statement/components/TotalTag.vue';
import { ReportType } from '../../../../api/tool/enums';
import { fix } from '../../../../api/tool/format';
import { getConfigValue } from '../data/config_get';
import ORDER_FREIGHTVue from '../../../../components/NeedToShow/ORDER_FREIGHT.vue';

export default {
	name: 'FreightDetail',
	components: { TotalTag },
	props: {
		// 需要查看的那一行司机的信息
		detail: {
			type: Object,
			default: () => {}
		}
	},
	data() {
		return {
			loading: false,
			// 弹窗
			dialogVisible: false,
			tableData: [],

			// 查询对应信息的弹窗
			infoVisible: false,

			// 对应渲染的组件和信息
			Components: null,
			needToShowInfo: null,

			// 五个字段 tags
			tags: null
		};
	},
	computed: {
		driverId() {
			return this.detail.companyId;
		}
	},

	methods: {
		// 查看明细 点击的时候 先让用户输入时间 然后拿该行数据的companyId查询该司机的明细账
		handleCheck() {
			// 打开时间选择框
			this.$datePicker().then(res => {
				// 清除一下状态
				this.tableData = [];
				// 组装查询条件 分别为开始时间 结束时间 司机id
				const query = {
					companyId: this.driverId,
					beginTime: res.beginTime,
					endTime: res.endTime
				};
				// 查询科目信息
				const key = { configKey: 'order.freightDetailSummary.subjectNo' };
				getConfigValue(key).then(({ configValue, subjectName }) => {
					// 查询明细账之前 要先查询上年结转的余额本币填充
					const body = {
						beginTime: query.beginTime,
						companyId: query.companyId
					};
					// 查询司机账户指定时间结转
					getFreightSubjectDetailSummarySomeDay(body).then(res => {
						// 校验一下
						if (!res.data) {
							this.$message.warning('上年结转数据不存在');
							return;
						}
						// 拿到上年的数据
						const lastYearDetail = res.data;
						// 把上年结转的数据放在最前面 并且摘要为上年结转
						this.tableData.push({
							...lastYearDetail,
							summary: '上年结转',
							moneyAmountLocal: lastYearDetail.moneyAmount,
							subjectNo: configValue,
							subjectName: subjectName
						});
						// 查询明细账
						const config = {
							configValue,
							subjectName
						};
						this.checkFreightDetail(query, lastYearDetail, config);
					});
				});
			});
		},
		/**
		 * 查询司机的明细账
		 * @param {any} query
		 * @param {any} lastYearDetail
		 * @param {any} config
		 * @returns {any}
		 */
		checkFreightDetail(query, lastYearDetail, config) {
			// 查询司机明细账
			getFreightSubjectDetailSummary(query).then(res => {
				if (!res.rows && !res.data) {
					this.$message.warning('未查询到相关数据');
					return;
				}
				try {
					// 上年结转的余额
					let lastMoney = Number(lastYearDetail.moneyAmount);
					// 累计金额
					let nowMoney = Number(0);
					// 拿到汇总账
					const append = res.rows.map(item => {
						// 金额累计计算
						nowMoney = lastMoney + Number(item.moneyAmount);
						// 更新
						lastMoney = nowMoney;
						// 如果有了摘要 不做处理
						if (item.summary) {
							return {
								...item,
								moneyAmountLocal: fix(nowMoney),
								subjectNo: config.configValue,
								subjectName: config.subjectName
							};
						} else {
							return {
								...item,
								// 如果没有摘要 就加上对应的摘要
								summary: ReportType.FREIGHT[item.tableName],
								moneyAmountLocal: fix(nowMoney),
								subjectNo: config.configValue,
								subjectName: config.subjectName
							};
						}
					});
					// 添加到上年结转数据的后面
					this.tableData = this.tableData.concat(append);
					// 打开弹窗
					this.dialogVisible = true;
				} catch (err) {
					this.$message.warning('查询失败');
					return;
				}
			});
		},
		// 查询对应的信息 通过拿表名和id  对应两个字段为tableName payNo
		handleSearch(row) {
			// 拿到表名和id
			const { tableName, payNo } = row;
			if (!tableName || !payNo) {
				this.$message.warning('该行数据有误:模块名或者凭证号不存在');
				return;
			}
			// 根据tableName动态获取某个JS模块
			if (tableName && payNo) {
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
					// 确保赋值完毕后再打开弹窗
					this.$nextTick(() => {
						this.infoVisible = true;
					});
				});
			}
		},
		// 根据对应的表名渲染对应的组件
		getComponents(tableName) {
			const components = {
				[TableName.GOODS_ORDER]: GOODS_ORDER,
				[TableName.PAYMENT]: PAYMENT,
				[TableName.INVOICE_IN]: INVOICE_IN,
				[TableName.INVOICE_OUT]: INVOICE_OUT,
				[TableName.INVOICE_OTHER]: INVOICE_ORTHER,
				[TableName.OFFSETTING]: OFFSETTING,
				[TableName.REBATE]: REBATE,
				[TableName.INVENTORMAIN]: INVENTORY,
				[TableName.ORDER_DETAIL]: ORDER_DETAIL,
				[TableName.ORDER_FREIGHT]: ORDER_FREIGHTVue
			};
			return components[tableName] || null; // 默认返回 null，如果没有匹配的 tableName
		}
	}
};
</script>

<template>
	<div>
		<!--    司机明细表的按钮-->
		<el-button type="primary" size="mini" @click="handleCheck"
			>查看明细</el-button
		>

		<!--    司机明细表的弹窗-->
		<el-dialog
			title="提示"
			:visible.sync="dialogVisible"
			width="900px"
			fullscreen
			append-to-body
		>
			<br />
			<br />
			<!--      司机的结转数据-->
			<el-card class="box-card">
				<el-table
					id="printBox"
					v-loading="loading"
					v-horizontal-scroll="'always'"
					border
					:data="tableData"
					max-height="600px"
					size="mini"
					:cell-style="
						() => {
							return { padding: '2px' };
						}
					"
				>
					<el-table-column
						show-overflow-tooltip
						label="时间"
						align="center"
						prop="operateDate"
						width="140"
					/>
					<!--      操作列-->
					<el-table-column
						label="凭证号"
						align="center"
						class-name="small-padding fixed-width"
						width="140"
						prop="payNo"
					>
						<template slot-scope="scope">
							<el-button
								v-if="scope.row.payNo"
								type="text"
								size="mini"
								@click="handleSearch(scope.row)"
							>
								点击查询对应信息
							</el-button>
						</template>
					</el-table-column>
					<el-table-column
						show-overflow-tooltip
						label="科目编码"
						align="center"
						prop="subjectNo"
						width="140"
					/>
					<el-table-column
						show-overflow-tooltip
						label="科目名称"
						align="center"
						prop="subjectName"
						width="140"
					/>
					<el-table-column
						show-overflow-tooltip
						label="司机编号"
						align="center"
						prop="companyId"
						width="140"
					/>
					<el-table-column
						show-overflow-tooltip
						label="司机名称"
						align="center"
						prop="companyName"
						width="140"
					/>
					<el-table-column
						show-overflow-tooltip
						label="司机银行户名（对方真实收付款名称）"
						align="center"
						prop="otherAccountsName"
						width="140"
					/>
					<el-table-column
						show-overflow-tooltip
						label="司机银行卡号"
						align="center"
						prop="otherBankNo"
						width="140"
					/>

					<el-table-column
						show-overflow-tooltip
						label="摘要"
						align="center"
						prop="summary"
						width="140"
					/>

					<!--        这两列应该是根据moneyAmount字段的正负进行判断-->
					<el-table-column
						show-overflow-tooltip
						label="借方发生额"
						align="center"
						width="140"
					>
						<template slot-scope="scope">
							{{
								scope.row.moneyAmount > 0
									? '-'
									: Math.abs(scope.row.moneyAmount)
							}}
						</template>
					</el-table-column>
					<el-table-column
						show-overflow-tooltip
						label="贷方发生额"
						align="center"
						width="140"
					>
						<template slot-scope="scope">
							{{ scope.row.moneyAmount > 0 ? scope.row.moneyAmount : '-' }}
						</template>
					</el-table-column>

					<!--        方向根据余额本币的正负进行判断 这个要先查询上年结转的余额本币 进行填充-->
					<el-table-column
						show-overflow-tooltip
						label="方向"
						align="center"
						width="140"
					>
						<template slot-scope="scope">
							{{ scope.row.moneyAmountLocal > 0 ? '贷方' : '借方' }}
						</template>
					</el-table-column>

					<el-table-column
						show-overflow-tooltip
						label="余额本币"
						align="center"
						prop="moneyAmountLocal"
						width="140"
					/>
					<el-table-column
						show-overflow-tooltip
						label="我方收款户名"
						align="center"
						prop="selfAccountsName"
						width="140"
					/>
					<el-table-column
						show-overflow-tooltip
						label="我方银行账号"
						align="center"
						prop="selfBankNo"
						width="140"
					/>
					<el-table-column
						show-overflow-tooltip
						label="我方开户行地址"
						align="center"
						prop="selfBankName"
						width="140"
					/>
				</el-table>
			</el-card>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="dialogVisible = false"
					>确 定</el-button
				>
			</span>
		</el-dialog>

		<!--    对应信息的弹窗-->
		<el-dialog
			title="信息"
			:visible.sync="infoVisible"
			width="900px"
			append-to-body
		>
			<component :is="Components" :need-to-show-info="needToShowInfo" />
		</el-dialog>
	</div>
</template>

<style scoped lang="scss"></style>
