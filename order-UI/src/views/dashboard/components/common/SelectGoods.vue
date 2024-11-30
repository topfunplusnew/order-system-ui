<script>
import { listGoodsOrder } from '@/api/system/goodsOrder';
import QuerySearchBar from '@/views/dashboard/components/goodsOrder/QuerySearchBar.vue';
import {
	OptionInvent,
	Options
} from '@/views/dashboard/mixins/order/order_Invoice';
import { mapGetters } from 'vuex';
import { PUBLIC_DICT_TYPE } from '@/utils/order';

export default {
	name: 'SelectGoods',
	components: { QuerySearchBar },
	computed: {
		...mapGetters(['ticketPoint', 'comment'])
	},
	watch: {
		// 监听两个值的变化 取消禁用多选框
		ticketPoint: {
			handler(value) {
				if (value) this.isBaned = false;
			},
			immediate: true
		}
	},
	data() {
		return {
			// 查询参数
			queryParams: {},
			// 订单列表
			goodsOrderList: [],
			total: 0,
			loading: false,
			options: Options,
			optionsInvoice: OptionInvent,
			// 多选框是否禁用
			isBaned: false,
			// 是否点击了检索
			hasClicked: false,

			// 判断是供应商还是客户
			type: null,

			// 订单选择的时候保存选中的行，方便取消选中后计算钱
			preOrderList: []
		};
	},
	created() {
		this.resetParams();
		this.getList();
	},
	mounted() {
		// 接受事件总线传递来的该组件的更新操作 并且传入回调函数
		this.$bus.$on('select-goods:update', () => this.refresh());
		// 监听重置筛选的事件 将是否检索设置为未检索
		this.$bus.$on('select-goods-row:update', () => (this.hasClicked = false));
		// 接受分配剩余金额传入的关于客户或者供应商的筛选
		this.$bus.$on('update-goods-order-company', value => {
			this.handleFilterOrders(value);
			// 赋值类型
			this.type = value.type;
			// 取消禁用多选框
			this.isBaned = false;
		});

		// 监听清除事件 要清除选择的订单
		this.$bus.$on('invoice-clear', () => {
			this.$store.dispatch('excel/clearSelectedOrders');
		});
	},
	beforeDestroy() {
		// 清除事件监听 防止内存泄漏
		this.$bus.$off('select-goods:update'); // 清理事件监听
		this.$bus.$off('update-goods-order-company');
	},
	methods: {
		// 获取订单列表
		async getList() {
			// 先禁用多选框
			this.isBaned = true;
			// 打开加载
			this.loading = true;
			try {
				const res = await listGoodsOrder(this.queryParams);
				this.goodsOrderList = res.rows; // 更新数据
				this.total = res.total;
			} catch (error) {
				console.error('Failed to fetch goods order list:', error);
			} finally {
				this.loading = false;
			}
		},

		// 多选 这边需要通过vuex进行管理状态 因为跨越组件了
		handleSelectionChange(selection) {
			// 如果还没有输入票点 先提醒用户输入票点
			if (!this.$store.getters.ticketPoint) {
				this.$message.warning('请先输入票点!');
				// 清除勾选
				this.$refs.goodsTable.clearSelection();
				// 禁用多选框 只有输入了票点后才能解禁
				this.isBaned = true;
				return;
			}

			// 判断是否点击了检索
			if (!this.hasClicked) {
				this.$message.warning('请先检索一个公司!');
				this.$refs.goodsTable.clearSelection();
				this.isBaned = true;
				return;
			}
			// 由vuex维护选中的订单列表 以便于其他组件使用
			this.$store.dispatch('excel/setSelectedOrders', selection);

			// 扣除金额 这里要判断一下 如果是客户 扣除的是总货款 如果是供应商 扣除的出厂货款之和
			this.multipleMoney(selection);
		},
		// 筛选订单列表 主要是用于当左侧选择某个公司后要选择对应公司的订单
		handleFilterOrders(value) {
			// 不合法
			if (value.id < 0) this.refresh();
			// 什么都不选 就只getList
			if (!value.id) this.refresh();

			value.type === PUBLIC_DICT_TYPE.CUSTOMER
				? this.handleCustomerFilter(value.id)
				: this.handleSupplierFilter(value.id);
		},
		// 对客户的筛选
		async handleCustomerFilter(companyId) {
			if (!companyId) {
				this.$message.warning('非法id!');
			}
			try {
				this.queryParams.customerID = companyId;
				await this.getList();
				// 设置点击了检索标记
				this.hasClicked = true;
				// 查询完订单列表后清除搜索条件
				this.resetParams();
			} catch (err) {
				console.error('Error fetching list:', err);
			}
		},
		// 处理选择的订单
		multipleMoney(orders) {
			const addedRows = orders.filter(row => !this.preOrderList.includes(row));
			const removedRows = this.preOrderList.filter(
				row => !orders.includes(row)
			);

			// 更新选择的订单
			this.preOrderList = orders;

			// 计算要扣除的钱
			let money = 0;
			try {
				// 如果取消选中的行不为空，扣除对应的金额
				if (removedRows.length !== 0) {
					money = this.calculateMoney(removedRows, this.type);
					if (money > 0) {
						this.$store.commit('excel/ADD_INVOICE_AMOUNT', money);
					}
				}

				// 如果选中的行不为空，增加对应的金额
				if (addedRows.length !== 0) {
					money = this.calculateMoney(addedRows, this.type);
					if (money > 0) {
						this.$store.commit('excel/MULTI_INVOICE_AMOUNT', money);
					}
				}
			} catch (err) {
				this.$message.warning('操作失败: ' + err.message || err);
				// 取消勾选
				this.$refs.goodsTable.clearSelection();
				// 重置金额
				this.$store.dispatch(
					'excel/setInvoiceAmount',
					sessionStorage.getItem('invoiceAmount')
				);
			}
		},
		// 计算操作金额的函数
		calculateMoney(rows, type) {
			let money = 0;
			if (rows.length === 0) return money;

			rows.forEach(row => {
				if (type === PUBLIC_DICT_TYPE.CUSTOMER) {
					money += row.allPayments; // 客户操作金额
				} else if (type === PUBLIC_DICT_TYPE.SUPPLIER) {
					row.smailOrderDetails.forEach(detail => {
						money += detail.paymentFactory; // 供应商操作金额
					});
				}
			});

			return money;
		},

		// 对供应商的筛选
		async handleSupplierFilter(companyId) {
			if (!companyId) {
				this.$message.warning('非法id!');
			}
			try {
				this.queryParams.params[`supplierId`] = companyId;
				await this.getList();
				// 设置点击了检索标记
				this.hasClicked = true;
				this.resetParams();
			} catch (err) {
				console.error('Error fetching list:', err);
			}
		},
		handleQuery(value) {
			this.queryParams = value;
			this.getList();
		},
		// 多选框是否禁用
		selectable() {
			return !this.isBaned;
		},
		// 重新拉取数据
		refresh() {
			this.resetParams();
			this.getList();
		},
		// 重置搜索条件
		resetParams() {
			// 只选择未开票的订单
			this.queryParams = {
				orderDateStart: null,
				orderDateEnd: null,
				pageNum: 1,
				pageSize: 20,
				ordersNo: null,
				orderDate: null,
				customer: null,
				customerID: null,
				landCarID: null,
				landCarNo: null,
				landDriverTel: null,
				landDriverName: null,
				seaCarID: null,
				seaCarNo: null,
				seaDriverTel: null,
				seaDriverName: null,
				checkUserId: null,
				checkState: null,
				invoiceState: '未开票',
				path: null,
				PaymentState: null,
				landBankName: null,
				landBankNo: null,
				seaBankName: null,
				seaBankNo: null,
				receiveProof: null,
				saleManager: null,
				fleet: null,
				isAdjusted: null,
				adjustDate: null,
				isAdjust: '否',
				adjustOrderid: null,
				isedit: null,
				customerIsInvoice: null,
				isSupplierInvoice: null,
				params: {
					supplierId: null
				}
			};
		}
	}
};
</script>

<template>
	<div>
		<QuerySearchBar :query-params="queryParams" @updateQuery="handleQuery" />

		<!--    显示选择的公司 如果是客户 那么就是批量卖出 如果是供应商 那么就是批量买入-->
		<!--    订单列表主体-->
		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			fit
			ref="goodsTable"
			border
			:data="goodsOrderList"
			virtual-scroll
			max-height="462px"
			size="mini"
			:cell-style="
				() => {
					return { padding: '2px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column
				type="selection"
				width="55"
				align="center"
				:selectable="selectable"
			/>
			<el-table-column
				show-overflow-tooltip
				label="日期"
				align="center"
				prop="orderDate"
			/>
			<el-table-column
				show-overflow-tooltip
				label="客户"
				align="center"
				prop="customer"
			/>
			<el-table-column
				show-overflow-tooltip
				label="供应商"
				align="center"
				prop="supplierNames"
				width="200"
			></el-table-column>
			<el-table-column
				show-overflow-tooltip
				label="陆运车牌"
				align="center"
				prop="landCarNo"
			/>
			<el-table-column
				show-overflow-tooltip
				label="陆运司机电话"
				align="center"
				prop="landDriverTel"
				width="100px"
			/>
			<el-table-column
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
			></el-table-column>
			<el-table-column
				show-overflow-tooltip
				label="陆运费"
				align="center"
				prop="landFreight"
				width="100px"
			/>
			<!--      原为海运车牌号-->
			<el-table-column
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
				show-overflow-tooltip
				label="海运费"
				align="center"
				prop="seaFreight"
				width="100px"
			/>
			<el-table-column
				show-overflow-tooltip
				label="销售经理"
				align="center"
				prop="saleManager"
			/>
			<el-table-column
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
				show-overflow-tooltip
				label="审核状态"
				align="center"
				prop="checkState"
				width="120"
			></el-table-column>
			<el-table-column
				show-overflow-tooltip
				label="开票状态"
				align="center"
				prop="invoiceState"
				width="120px"
			/>
			<el-table-column
				show-overflow-tooltip
				label="客户是否开票"
				align="center"
				prop="customerIsInvoice"
				width="150px"
			>
				<template #default="scope">
					{{ scope.row.customerIsInvoice === 1 ? '是' : '否' }}
				</template>
			</el-table-column>
			<el-table-column
				show-overflow-tooltip
				label="供应商是否开票"
				align="center"
				prop="isSupplierInvoice"
				width="120px"
			>
				<template #default="scope">
					{{ scope.row.isSupplierInvoice >= 1 ? '是' : '否' }}
				</template>
			</el-table-column>
			<el-table-column
				show-overflow-tooltip
				label="备注"
				align="center"
				prop="comments"
			/>
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
</template>

<style scoped lang="scss"></style>
