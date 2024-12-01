<script>
import {
	delGoodsOrder,
	getGoodsOrder,
	updateGoodsOrder
} from '@/api/system/goodsOrder';
import CheckFiles from '@/components/CheckFiles.vue';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { mixin_checkfile } from '@/views/dashboard/mixins/checkfiles/mixin_checkfile';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { mixin_order_Invoice } from '@/views/dashboard/mixins/order/order_Invoice';
import { mixin_order_uploadFiles } from '@/views/dashboard/mixins/order/order_UploadFiles';
import { mixin_order_add } from '@/views/dashboard/mixins/order/order_addOrder';
import { mixin_order_adjustOrder } from '@/views/dashboard/mixins/order/order_adjustOrder';
import { mixin_order_audit } from '@/views/dashboard/mixins/order/order_audit';
import { mixin_order_base } from '@/views/dashboard/mixins/order/order_base';
import { mixin_order_checkOrder } from '@/views/dashboard/mixins/order/order_checkOrder';
import { mixin_order_deliverGoods } from '@/views/dashboard/mixins/order/order_deliverGoods';
import { mixin_order_freeApply } from '@/views/dashboard/mixins/order/order_freeApply';
import { mixin_order_goodsItemInfo } from '@/views/dashboard/mixins/order/order_goodsItemInfo';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import reLength from '@/views/dashboard/mixins/reLength';
import GOODS_ORDER from '../../../../components/NeedToShow/GOODS_ORDER.vue';
import QuerySearchBar from './QuerySearchBar.vue';
import { mixin_order_orderHistory } from '@/views/dashboard/mixins/order/order_history';
import OrderHistoryCheck from '@/views/dashboard/components/goodsOrder/OrderHistoryCheck.vue';
import { parseTime } from '@/utils/ruoyi';

export default {
	name: 'ElTableOrder',
	components: { OrderHistoryCheck, DialogWrapper, CheckFiles, QuerySearchBar },
	// 引入打印的混入、拖动表头宽度引起的变化、订单的基本信息的混入
	mixins: [
		// 打印功能
		mixin_printHTML,
		// 通用的弹窗组件配套的混入
		common_dialog,
		// 表头拖动功能
		reLength,
		// 订单基本功能
		mixin_order_base,
		// 订单审核功能
		mixin_order_audit,
		// 文件查看功能
		mixin_checkfile,
		// 订单开票的功能
		mixin_order_Invoice,
		// 订单查看的功能
		mixin_order_checkOrder,
		// 查看订单的货物
		mixin_order_goodsItemInfo,
		// 订单的添加或者修改
		mixin_order_add,
		// 调整单功能
		mixin_order_adjustOrder,
		// 上传附件
		mixin_order_uploadFiles,
		// 发货单
		mixin_order_deliverGoods,
		// 运费申请
		mixin_order_freeApply,
		// 订单历史记录查看
		mixin_order_orderHistory
	],
	props: {
		// 是否为调整单
		isAdjustOrder: {
			type: Boolean,
			default: false
		}
	},
	data() {
		return {
			// 订单表格中的数据
			goodsOrderList: [],
			// 加载中的效果
			loading: true,
			// 订单总数 用于分页
			total: 0
		};
	},
	watch: {
		// 监听显示隐藏列的改变
		columns: {
			handler: function (newVal) {
				localStorage.setItem('goodsorder-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},

	created() {
		// 获取订单列表
		this.getList();
		// 设置显示隐藏列的本地存储
		if (
			localStorage.getItem('goodsorder-columns') === 'null' ||
			!localStorage.getItem('goodsorder-columns')
		) {
			localStorage.setItem('goodsorder-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('goodsorder-columns'));
		}
	},
	methods: {
		parseTime,
		updateGoodsOrder,
		getGoodsOrder,

		// 给特定的某些行高亮颜色
		tableRowClassName({ row }) {
			// 如果row.isAdjusted 的值为是，并且 isAdjust 的值也为是，那么就显示背景颜色为红色
			if (row.isAdjusted === '是' && this.isAdjustOrder) {
				return {
					background: '#c6ffe6 !important'
				};
			}
			return '';
		},
		// 处理下拉菜单  使用的是事件委托
		handleCommand(command, row) {
			// 根据不同操作委派不同的方法
			switch (command) {
				// 查看订单详情
				case 'checkOrderItemInfo':
					this.checkOrderItemInfo(row);
					break;
				// 修改订单
				case 'handleUpdate':
					this.handleUpdate(row);
					break;
				// 查看货物
				case 'handleCheckOrderDetailInfo':
					this.handleCheckOrderDetailInfo(row);
					break;
				// 删除订单
				case 'handleDelete':
					this.handleDelete(row);
					break;
				default:
					break;
			}
		},
		// 处理顶部搜索框
		handleGetQueryParams(value) {
			this.queryParams = value;
			this.getList();
		},
		// 删除某一个订单
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除订单ID为"' + ids + '"的订单？')
				.then(function () {
					return delGoodsOrder(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				});
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		// 查看原订单的信息
		handleCheckPrevious(row) {
			const { id } = row;
			getGoodsOrder(id).then(res => {
				// todo
				this.openDialog(GOODS_ORDER, '查看原订单信息', '50%', {
					needToShowInfo: res.data
				});
			});
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		// 表格的导出
		handleExport() {
			this.download(
				'system/goodsOrder/export',
				{
					...this.queryParams
				},
				`goodsOrder_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>

<template>
	<div>
		<!--    这是框架自带的搜索模组，封装成了组件并且放在与index.vue同级目录下-->
		<div>
			<QuerySearchBar
				:query-items="queryParams"
				@updateQuery="handleGetQueryParams"
			/>
		</div>
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

		<!--    订单历史记录查看-->
		<div>
			<OrderHistoryCheck
				:active-names="activeNames"
				:check-history-order-visible="checkHistoryOrderVisible"
				:checkcurrent-order-item-info="checkcurrentOrderItemInfo"
				:order-history-info-list="orderHistoryInfoList"
				:parse-time="parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}')"
				@close="closeOrderHistoryCheck"
			/>
		</div>

		<!--    顶部按钮操作-->
		<div>
			<el-row :gutter="10" class="mb8">
				<el-col :span="1.5">
					<el-button icon="el-icon-refresh" size="mini" @click="resetQuery"
						>刷新
					</el-button>
				</el-col>
				<el-col v-if="!isAdjustOrder" :span="1.5">
					<el-button
						v-hasPermi="['system:goodsorder:add']"
						type="danger"
						size="mini"
						@click="handleAdd"
					>
						添加订单信息
					</el-button>
				</el-col>
			</el-row>
		</div>
		<!--      右侧的工具栏-->
		<div>
			<right-toolbar :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button
							plain
							icon="el-icon-printer"
							size="mini"
							@click="printHTML"
						/>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button
							v-hasPermi="['system:goodsorder:export']"
							plain
							icon="el-icon-folder-opened"
							size="mini"
							@click="handleExport"
						/>
					</el-col>
				</template>
			</right-toolbar>
		</div>

		<!--    订单表格 数据量较大-->
		<div>
			<el-table
				id="printBox"
				v-loading="loading"
				v-horizontal-scroll="'always'"
				:row-style="tableRowClassName"
				fit
				border
				size="mini"
				virtual-scroll
				max-height="750"
				:cell-style="
					() => {
						return { padding: '.7px' };
					}
				"
				:data="goodsOrderList"
				@header-dragend="changeColWidth"
			>
				<el-table-column
					label="行操作"
					align="center"
					class-name="small-padding fixed-width"
					width="142"
					fixed="left"
				>
					<template slot-scope="scope">
						<el-dropdown
							size="mini"
							@command="command => handleCommand(command, scope.row)"
						>
							<el-button size="mini" type="text">操作</el-button>
							<el-dropdown-menu slot="dropdown">
								<el-dropdown-item command="checkOrderItemInfo">
									<el-button size="mini">查 看</el-button>
								</el-dropdown-item>
								<el-dropdown-item
									v-hasPermi="['system:goodsorder:edit']"
									command="handleUpdate"
								>
									<el-button size="mini" type="primary">修 改</el-button>
								</el-dropdown-item>
								<el-dropdown-item command="handleCheckOrderDetailInfo">
									<el-button size="mini" type="warning">货 物</el-button>
								</el-dropdown-item>
								<el-dropdown-item
									v-hasPermi="['system:goodsorder:remove']"
									command="handleDelete"
								>
									<el-button size="mini" type="danger">删 除</el-button>
								</el-dropdown-item>
							</el-dropdown-menu>
						</el-dropdown>
						<!--          禁用-->
						<el-button
							style="margin-left: 5px"
							size="mini"
							type="text"
							@click="checkOrderHistory(scope.row)"
							>查看历史
						</el-button>
					</template>
				</el-table-column>
				<el-table-column
					show-overflow-tooltip
					label="ID"
					align="center"
					prop="id"
					fixed="left"
				/>
				<el-table-column
					v-show="columns[0].visible"
					show-overflow-tooltip
					label="日期"
					align="center"
					prop="orderDate"
					fixed="left"
				/>
				<el-table-column
					v-show="columns[1].visible"
					show-overflow-tooltip
					label="客户"
					align="center"
					prop="customer"
					fixed="left"
				/>
				<el-table-column
					v-show="columns[2].visible"
					show-overflow-tooltip
					label="供应商"
					align="center"
					prop="supplierNames"
					fixed="left"
					width="200"
				>
					<template #default="scope">
						<el-row v-if="scope.row.smailOrderDetails">
							<span
								v-for="(item, index) in getSupplierNames(
									scope.row.smailOrderDetails
								)"
								:key="index"
							>
								<span
									class="invoice"
									@click="
										updateOrderItemVisibleSupplierInvoice(
											scope.row,
											item.supplierID
										)
									"
								>
									{{ item.supplier }}
								</span>
							</span>
						</el-row>
						<template v-else>无</template>
					</template>
				</el-table-column>
				<el-table-column
					v-show="columns[3].visible"
					show-overflow-tooltip
					label="陆运车牌"
					align="center"
					prop="landCarNo"
				/>
				<el-table-column
					v-show="columns[4].visible"
					show-overflow-tooltip
					label="陆运司机电话"
					align="center"
					prop="landDriverTel"
					width="100px"
				/>
				<el-table-column
					v-show="columns[5].visible"
					show-overflow-tooltip
					label="陆地司机姓名"
					align="center"
					prop="landDriverName"
					width="100px"
				/>
				<el-table-column
					show-overflow-tooltip
					label="总货款"
					align="center"
					prop="allPayments"
					width="100px"
				>
					<template #default="scope">
						{{ scope.row.allPayments | changeNumber(changeLength) }}
					</template>
				</el-table-column>
				<el-table-column
					v-show="columns[6].visible"
					show-overflow-tooltip
					label="陆运费"
					align="center"
					prop="landFreight"
					width="100px"
				/>
				<!--      原为海运车牌号-->
				<el-table-column
					v-show="columns[7].visible"
					show-overflow-tooltip
					label="海运柜号"
					align="center"
					prop="seaCarNo"
				>
					<template #default="scope">
						{{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}
					</template>
				</el-table-column>
				<el-table-column
					v-show="columns[8].visible"
					show-overflow-tooltip
					label="海运司机电话"
					align="center"
					prop="seaDriverTel"
					width="100px"
				>
					<template #default="scope">
						{{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}
					</template>
				</el-table-column>
				<!--      原为海运司机姓名-->
				<el-table-column
					v-show="columns[9].visible"
					show-overflow-tooltip
					label="海运公司"
					align="center"
					prop="seaDriverName"
					width="100px"
				>
					<template #default="scope">
						{{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverTel }}
					</template>
				</el-table-column>
				<el-table-column
					v-show="columns[10].visible"
					show-overflow-tooltip
					label="海运费"
					align="center"
					prop="seaFreight"
					width="100px"
				/>
				<el-table-column
					v-show="columns[11].visible"
					show-overflow-tooltip
					label="销售经理"
					align="center"
					prop="saleManager"
				/>
				<el-table-column
					v-show="columns[12].visible"
					show-overflow-tooltip
					label="车队"
					align="center"
					prop="fleet"
				/>
				<el-table-column
					show-overflow-tooltip
					label="业务员"
					align="center"
					prop="userName"
					width="120px"
				/>
				<el-table-column
					v-show="columns[13].visible"
					show-overflow-tooltip
					label="审核状态"
					align="center"
					prop="checkState"
					width="120"
				>
					<template #default="scope">
						<el-row v-if="scope.row.checkState === '已审核'">
							{{ scope.row.checkState }}
						</el-row>
						<el-row v-else>
							<el-row>
								<el-button
									v-hasPermi="['system:goodsorder:audit']"
									type="text"
									size="mini"
									@click="handleCheck(scope.row)"
								>
									审核
								</el-button>
							</el-row>
						</el-row>
					</template>
				</el-table-column>
				<el-table-column
					v-show="columns[14].visible"
					show-overflow-tooltip
					label="开票状态"
					align="center"
					prop="invoiceState"
					width="120px"
				/>
				<el-table-column
					v-show="columns[15].visible"
					show-overflow-tooltip
					label="附件"
					align="center"
					prop="path"
					width="150px"
				>
					<template slot-scope="scope">
						<CheckFiles
							:path="scope.row.path"
							@needToUpdate="
								value =>
									handleUpdateFilePath(
										value,
										scope.row,
										'path',
										getGoodsOrder,
										updateGoodsOrder
									)
							"
						/>
					</template>
				</el-table-column>
				<el-table-column
					v-show="columns[17].visible"
					show-overflow-tooltip
					label="收到条附件路径"
					align="center"
					prop="receiveProof"
					width="150px"
				>
					<template #default="scope">
						<CheckFiles
							:path="scope.row.receiveProof"
							@needToUpdate="
								value =>
									handleUpdateFilePath(
										value,
										scope.row,
										'receiveProof',
										getGoodsOrder,
										updateGoodsOrder
									)
							"
						/>
					</template>
				</el-table-column>
				<el-table-column
					v-show="columns[19].visible"
					show-overflow-tooltip
					label="是否可编辑"
					align="center"
					prop="isedit"
					width="100px"
				>
					<template slot-scope="scope">
						{{ scope.row.isedit === 0 ? '否' : '是' }}
					</template>
				</el-table-column>
				<!--      客户供应商是否开票-->
				<el-table-column
					v-show="columns[20].visible"
					show-overflow-tooltip
					label="客户是否开票"
					align="center"
					prop="customerIsInvoice"
					width="150px"
				>
					<template #default="scope">
						<el-row v-if="hasOpen(scope.row, 1)">
							<el-row v-if="scope.row.customerIsInvoice > 0">
								<el-row>
									<el-button
										type="text"
										size="mini"
										@click="updateOrderItemVisibleCustomerInvoice(scope.row)"
									>
										继续开票
									</el-button>
								</el-row>
							</el-row>
							<el-row v-else>
								<el-row>
									<el-button
										type="text"
										size="mini"
										@click="updateOrderItemVisibleCustomerInvoice(scope.row)"
									>
										前去开票
									</el-button>
								</el-row>
							</el-row>
						</el-row>
						<el-row v-else>无开票</el-row>
					</template>
				</el-table-column>
				<el-table-column
					v-show="columns[21].visible"
					show-overflow-tooltip
					label="供应商是否开票"
					align="center"
					prop="isSupplierInvoice"
					width="120px"
				>
					<template #default="scope">
						<el-row v-if="hasOpen(scope.row, 0)">
							<el-row v-if="scope.row.isSupplierInvoice > 0">
								<el-row>
									<el-button
										type="text"
										size="mini"
										@click="updateOrderItemVisibleSupplierInvoice(scope.row)"
									>
										继续开票
									</el-button>
								</el-row>
							</el-row>
							<el-row v-else>
								<el-row>
									<el-button
										type="text"
										size="mini"
										@click="updateOrderItemVisibleSupplierInvoice(scope.row)"
									>
										前去开票
									</el-button>
								</el-row>
							</el-row>
						</el-row>
						<el-row v-else>无开票</el-row>
					</template>
				</el-table-column>
				<el-table-column
					v-show="columns[22].visible"
					show-overflow-tooltip
					label="备注"
					align="center"
					prop="comments"
				/>
				<!--      右侧操作栏-->
				<el-table-column
					show-overflow-tooltip
					label="订单操作"
					align="center"
					class-name="small-padding fixed-width"
					width="160px"
					fixed="right"
				>
					<template slot-scope="scope">
						<!--          调整单-->
						<el-button
							:disabled="scope.row.isAdjusted === '是'"
							size="mini"
							type="text"
							@click="handleOrderItemInfo(scope.row)"
						>
							调整单
						</el-button>
						<el-button
							v-if="isAdjustOrder"
							size="mini"
							type="text"
							@click="handleCheckPrevious(scope.row)"
						>
							查看原单据
						</el-button>
						<!--          发货单-->
						<el-dropdown size="mini" type="text">
							<el-button type="text" size="mini">
								发货单
								<i class="el-icon-arrow-down el-icon--right" />
							</el-button>
							<el-dropdown-menu slot="dropdown">
								<el-dropdown-item>
									<el-button
										size="mini"
										type="text"
										@click="handleOrder1(scope.row)"
									>
										发货单1
									</el-button>
								</el-dropdown-item>
								<el-dropdown-item>
									<el-button
										size="mini"
										type="text"
										@click="handleOrder2(scope.row)"
									>
										发货单2
									</el-button>
								</el-dropdown-item>
								<el-dropdown-item>
									<el-button
										size="mini"
										type="text"
										@click="handleOrder3(scope.row)"
									>
										发货单3
									</el-button>
								</el-dropdown-item>
							</el-dropdown-menu>
						</el-dropdown>
					</template>
				</el-table-column>
				<el-table-column
					show-overflow-tooltip
					label="运费申请"
					align="center"
					class-name="small-padding fixed-width"
					width="100px"
					fixed="right"
				>
					<template slot-scope="scope">
						<!--          如果有订单运费 那么就禁用按钮-->
						<el-dropdown size="mini" type="text">
							<el-button
								type="text"
								:disabled="
									!(scope.row.landFreight > 0 || scope.row.seaFreight > 0)
								"
							>
								操作
							</el-button>
							<el-dropdown-menu slot="dropdown">
								<el-dropdown-item>
									<el-row
										v-if="scope.row.landFreight > 0 || scope.row.seaFreight > 0"
									>
										<el-button
											v-if="scope.row.landFreight > 0"
											:key="scope.row.params.isHaveOrderLandfreight"
											v-hasPermi="['system:goodsorder:remove']"
											size="mini"
											type="warning"
											:disabled="
												scope.row.params.isHaveOrderLandfreight === 'true'
											"
											@click="handleApplyLandFree(scope.row)"
										>
											陆运费申请
										</el-button>
										<el-button
											v-if="scope.row.seaFreight > 0"
											:key="scope.row.params.isHaveOrderSeafreight"
											v-hasPermi="['system:goodsorder:remove']"
											:disabled="
												scope.row.params.isHaveOrderSeafreight === 'true'
											"
											size="mini"
											type="primary"
											@click="handleApplySeaFree(scope.row)"
										>
											海运费申请
										</el-button>
									</el-row>
									<el-row v-else>无运费信息</el-row>
								</el-dropdown-item>
							</el-dropdown-menu>
						</el-dropdown>
					</template>
				</el-table-column>
			</el-table>
			<!--    分页组件-->
			<pagination
				v-show="total > 0"
				:total="total"
				:page.sync="queryParams.pageNum"
				:limit.sync="queryParams.pageSize"
				@pagination="getList"
			/>
		</div>
	</div>
</template>

<style scoped lang="scss">
.invoice {
	width: 100%;
	height: 100%;

	&:hover {
		cursor: pointer;
		color: #df6565;
		font-weight: bold;
	}
}
</style>
