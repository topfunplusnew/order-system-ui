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
import { mixin_order_goodsItemInfo } from '@/views/dashboard/mixins/order/order_goodsItemInfo';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import reLength from '@/views/dashboard/mixins/reLength';
import GOODS_ORDER from '../../../../components/NeedToShow/GOODS_ORDER.vue';
import QuerySearchBar from './QuerySearchBar.vue';
import { mixin_order_orderHistory } from '@/views/dashboard/mixins/order/order_history';
import OrderHistoryCheck from '@/views/dashboard/components/goodsOrder/OrderHistoryCheck.vue';
import { parseTime } from '@/utils/ruoyi';
import HistoryList from '@/views/dashboard/components/goodsOrder/HistoryList.vue';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import StateTag from '@/views/dashboard/components/common/StateTag.vue';
import {
	auditGoodsOrder,
	listGoodsOrder
} from '../../../../api/system/goodsOrder';

export default {
	name: 'ElTableOrder',
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		}
	},
	components: {
		StateTag,
		HistoryList,
		OrderHistoryCheck,
		DialogWrapper,
		CheckFiles,
		QuerySearchBar
	},
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
		// mixin_order_freeApply,
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
			total: 0,
			// 本地维护的查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 50
			},
			columns: [
				{ key: 0, label: 'ID', visible: true },
				{ key: 1, label: '日期', visible: true },
				{ key: 2, label: '客户', visible: true },
				{ key: 3, label: '供应商', visible: true },
				{ key: 4, label: '审核状态', visible: true },
				{ key: 5, label: '陆运车牌', visible: true },
				{ key: 6, label: '陆运司机电话', visible: true },
				{ key: 7, label: '陆地司机姓名', visible: true },
				{ key: 8, label: '总货款', visible: true },
				{ key: 9, label: '陆运费', visible: true },
				{ key: 10, label: '海运柜号', visible: true },
				{ key: 11, label: '海运司机电话', visible: true },
				{ key: 12, label: '海运公司', visible: true },
				{ key: 13, label: '海运费', visible: true },
				{ key: 14, label: '销售经理', visible: true },
				{ key: 15, label: '车队', visible: true },
				{ key: 16, label: '录入员', visible: true },
				{ key: 17, label: '附件', visible: true },
				{ key: 18, label: '收到条附件', visible: true },
				{ key: 19, label: '是否可编辑', visible: true },
				{ key: 20, label: '客户是否开票', visible: true },
				{ key: 21, label: '供应商是否开票', visible: true },
				{ key: 22, label: '备注', visible: true }
			]
		};
	},
	watch: {
		// 监听显示隐藏列的改变
		columns: {
			handler: function (newVal) {
				localStorage.setItem(
					'goodsorder-columns',
					JSON.stringify(newVal)
				);
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
			localStorage.setItem(
				'goodsorder-columns',
				JSON.stringify(this.columns)
			);
		} else {
			this.columns = JSON.parse(
				localStorage.getItem('goodsorder-columns')
			);
		}
	},
	methods: {
		parseTime,
		updateGoodsOrder,
		getGoodsOrder,
		// 给特定的某些行高亮颜色
		tableRowClassName({ row }) {
			if (row.isAdjust > 0 && this.isAdjustOrder) {
				if (row.isAdjust === 1) {
					return {
						background: '#f0f0f0 !important'
					};
				} else if (row.isAdjust === 2) {
					return {
						background: '#f0f9eb !important'
					};
				} else if (row.isAdjust === 3) {
					return {
						background: '#fdf6ec !important'
					};
				} else {
					return {
						background: '#ffcccc !important'
					};
				}
			} else {
				return '';
			}
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
		// 查看调整单信息
		handleCheckAdjust(row) {
			const query = {
				adjustOrderid: row.id
			};
			listGoodsOrder(query).then(res => {
				if (res.rows.length === 0) {
					this.$modal.msgError('该订单没有调整单');
					return;
				}
				const data = res.rows.filter(item => item.isAdjust > 0)[0];
				this.openDialog(
					GOODS_ORDER,
					'查看调整单信息',
					'650px',
					{
						needToShowInfo: data
					},
					true
				);
			});
		},
		// 查看原订单的信息
		handleCheckPrevious(row) {
			const { adjustOrderid } = row;
			getGoodsOrder(adjustOrderid).then(res => {
				this.openDialog(
					GOODS_ORDER,
					'查看原订单信息',
					'650px',
					{
						needToShowInfo: res.data
					},
					true
				);
			});
		},
		handleReCheck(row) {
			this.$modal.confirm('是否取消审核').then(() => {
				auditGoodsOrder({
					id: row.id,
					isaudit: false
				}).then(() => {
					this.$modal.msgSuccess('取消审核成功');
					this.getList();
				});
			});
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
			<el-card class="box-card">
				<QuerySearchBar
					@updateQuery="handleGetQueryParams"
					:is-adjust="isAdjustOrder"
				/>
			</el-card>
		</div>
		<br />
		<div v-if="isAdjustOrder">
			<el-row>
				<el-card class="box-card">
					<div slot="header" class="clearfix">
						<span style="font-weight: bold; font-size: 16px"
							>调整次数示意</span
						>

						<el-tooltip
							content="负数单，表示该订单为调整订单A后，A订单产生的负数订单，数值与A订单为相反数调整一次意为订单A调整一次,产生的调整单B,记录此时该调整单B为一次调整;调整两次为，对调整单B进行调整，生成调整单C,记录该调整单C为二次调整,以此类推"
							placement="bottom"
							effect="light"
						>
							<el-button
								style="float: right; padding: 3px 0"
								type="text"
								>解释?</el-button
							>
						</el-tooltip>
					</div>
					<el-alert
						title="注意：不能对负数单进行调整，且负数单不可修改!"
						type="warning"
						style="margin-bottom: 10px"
						show-icon
						effect="light"
					/>
					<el-tag class="custom-tag">负数单</el-tag>
					<el-tag type="info" class="tag-spacing">调整一次</el-tag>
					<el-tag type="success" class="tag-spacing">调整两次</el-tag>
					<el-tag type="warning" class="tag-spacing">调整三次</el-tag>
					<el-tag
						style="background-color: #ed5b3a; color: white"
						class="tag-spacing"
						>三次以上
					</el-tag>
				</el-card>
			</el-row>
		</div>
		<!--    通用弹窗 配合common_dialogs 使用-->
		<div v-if="currentComponent">
			<DialogWrapper
				:current-component="currentComponent"
				:dialog-visible="dialogVisible"
				:dialog-props="dialogProps"
				:dialog-title="dialogTitle"
				:dialog-width="dialogWidth"
				:close-confirm="closeConfirm"
				@update:dialogVisible="args => (dialogVisible = false)"
				@close="handleCloseDialog"
				@confirm="handleDialogConfirm"
			/>
		</div>

		<!--    订单历史记录查看-->
		<div>
			<OrderHistoryCheck
				:check-history-order-visible="checkHistoryOrderVisible"
				:order-history-info-list="orderHistoryInfoList"
				:current-info="currentOrderItemInfo"
				@close="closeOrderHistoryCheck"
			/>
		</div>

		<!--    顶部按钮操作-->
		<div style="padding: 10px">
			<el-row :gutter="10" class="mb8">
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
							@command="
								command => handleCommand(command, scope.row)
							"
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
									<el-button
										size="mini"
										type="primary"
										:disabled="
											!scope.row.isedit ||
											scope.row.isAdjust < 0
										"
										>修 改
									</el-button>
								</el-dropdown-item>
								<el-dropdown-item
									command="handleCheckOrderDetailInfo"
								>
									<el-button size="mini" type="warning"
										>货 物</el-button
									>
								</el-dropdown-item>
								<el-dropdown-item
									v-hasPermi="['system:goodsorder:remove']"
									command="handleDelete"
								>
									<el-button size="mini" type="danger"
										>删 除</el-button
									>
								</el-dropdown-item>
							</el-dropdown-menu>
						</el-dropdown>
						<!--          禁用-->

						<el-dropdown size="mini">
							<el-button size="mini" type="text"
								>历史记录</el-button
							>
							<el-dropdown-menu slot="dropdown">
								<el-dropdown-item>
									<HistoryList :row="scope.row" />
								</el-dropdown-item>
								<el-dropdown-item>
									<el-button
										style="margin-left: 5px"
										size="mini"
										type="text"
										@click="checkOrderHistory(scope.row)"
										>历史对比
									</el-button>
								</el-dropdown-item>
							</el-dropdown-menu>
						</el-dropdown>
					</template>
				</el-table-column>
				<el-table-column
					v-if="columns[0].visible"
					show-overflow-tooltip
					label="ID"
					align="center"
					prop="id"
					fixed="left"
				/>
				<el-table-column
					v-if="columns[1].visible"
					show-overflow-tooltip
					label="日期"
					align="center"
					prop="orderDate"
					fixed="left"
				/>
				<el-table-column
					v-if="columns[2].visible"
					show-overflow-tooltip
					label="客户"
					align="center"
					prop="customer"
					fixed="left"
				/>
				<el-table-column
					v-if="columns[3].visible"
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
					v-if="columns[4].visible"
					show-overflow-tooltip
					label="审核状态"
					align="center"
					prop="checkState"
					width="120"
				>
					<template #default="scope">
						<el-row v-if="scope.row.checkState === '已审核'">
							<StateTag
								:state-title="scope.row.checkState"
								:state-mapper="{ 2: '已审核' }"
								@click.native="handleReCheck(scope.row)"
								style="cursor: pointer"
							/>
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
					v-if="columns[5].visible"
					show-overflow-tooltip
					label="陆运车牌"
					align="center"
					prop="landCarNo"
				/>
				<el-table-column
					v-if="columns[6].visible"
					show-overflow-tooltip
					label="陆运司机电话"
					align="center"
					prop="landDriverTel"
					width="100px"
				/>
				<el-table-column
					v-if="columns[7].visible"
					show-overflow-tooltip
					label="陆地司机姓名"
					align="center"
					prop="landDriverName"
					width="100px"
				/>
				<el-table-column
					v-if="columns[8].visible"
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
					v-if="columns[9].visible"
					show-overflow-tooltip
					label="陆运费"
					align="center"
					prop="landFreight"
					width="100px"
				/>
				<!--      原为海运车牌号-->
				<el-table-column
					v-if="columns[10].visible"
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
					v-if="columns[11].visible"
					show-overflow-tooltip
					label="海运司机电话"
					align="center"
					prop="seaDriverTel"
					width="100px"
				>
					<template #default="scope">
						{{
							!scope.row.seaDriverTel
								? '无'
								: scope.row.seaDriverTel
						}}
					</template>
				</el-table-column>
				<!--      原为海运司机姓名-->
				<el-table-column
					v-if="columns[12].visible"
					show-overflow-tooltip
					label="海运公司"
					align="center"
					prop="seaDriverName"
					width="100px"
				>
					<template #default="scope">
						{{
							!scope.row.seaDriverName
								? '无'
								: scope.row.seaDriverTel
						}}
					</template>
				</el-table-column>
				<el-table-column
					v-if="columns[13].visible"
					show-overflow-tooltip
					label="海运费"
					align="center"
					prop="seaFreight"
					width="100px"
				/>
				<el-table-column
					v-if="columns[14].visible"
					show-overflow-tooltip
					label="销售经理"
					align="center"
					prop="saleManager"
				/>
				<el-table-column
					v-if="columns[15].visible"
					show-overflow-tooltip
					label="车队"
					align="center"
					prop="fleet"
				/>
				<el-table-column
					v-if="columns[16].visible"
					show-overflow-tooltip
					label="录入员"
					align="center"
					prop="userName"
					width="120px"
				/>
				<el-table-column
					v-if="columns[17].visible"
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
					v-if="columns[18].visible"
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
					v-if="columns[19].visible"
					show-overflow-tooltip
					label="是否可编辑"
					align="center"
					prop="isedit"
					width="100px"
				>
					<template slot-scope="scope">
						<StateTag
							:state-title="scope.row.isedit === 0 ? '否' : '是'"
							:state-mapper="{ 0: '否', 2: '是' }"
						/>
					</template>
				</el-table-column>
				<!--      客户供应商是否开票-->
				<el-table-column
					v-if="columns[20].visible"
					show-overflow-tooltip
					label="客户是否开票"
					align="center"
					width="150px"
				>
					<template #default="scope">
						<el-row>
							<el-row
								v-if="
									hasInvoice(
										scope.row,
										PUBLIC_DICT_TYPE.CUSTOMER
									)
								"
							>
								<el-row>
									<el-button
										type="text"
										size="mini"
										@click="
											updateOrderItemVisibleCustomerInvoice(
												scope.row
											)
										"
									>
										开票
									</el-button>
								</el-row>
							</el-row>
							<el-row v-else>
								<StateTag
									:state-title="`无开票`"
									:state-mapper="{ 3: '无开票' }"
								/>
							</el-row>
						</el-row>
					</template>
				</el-table-column>
				<el-table-column
					v-if="columns[21].visible"
					show-overflow-tooltip
					label="供应商是否开票"
					align="center"
					width="120px"
				>
					<template #default="scope">
						<el-row>
							<el-row
								v-if="
									hasInvoice(
										scope.row,
										PUBLIC_DICT_TYPE.SUPPLIER
									)
								"
							>
								<el-row>
									<el-button
										type="text"
										size="mini"
										@click="
											updateOrderItemVisibleSupplierInvoice(
												scope.row
											)
										"
									>
										开票
									</el-button>
								</el-row>
							</el-row>
							<el-row v-else>
								<StateTag
									:state-title="`无开票`"
									:state-mapper="{ 3: '无开票' }"
								/>
							</el-row>
						</el-row>
					</template>
				</el-table-column>
				<el-table-column
					v-if="columns[22].visible"
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
					width="200px"
					fixed="right"
				>
					<template slot-scope="scope">
						<el-button
							size="mini"
							type="text"
							v-if="!isAdjustOrder"
							@click="handleCheckAdjust(scope.row)"
						>
							查看调整单
						</el-button>
						<el-button
							size="mini"
							type="text"
							:disabled="scope.row.isAdjust < 0"
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
			</el-table>
			<!--    分页组件-->
			<pagination
				v-if="total > 0"
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

.tag-spacing {
	margin-right: 8px;
}

.custom-tag {
	background-color: #ffffff !important; /* 背景颜色设为白色 */
	border: 0.4px solid #aed3fa !important; /* 边框颜色自定义（这里用了蓝色） */
	color: #a6a5a5 !important; /* 文本颜色与边框一致 */
	font-weight: bold; /* 字体加粗 */
	margin-right: 8px;
}
</style>
