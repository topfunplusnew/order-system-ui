<script>
import { listGoodsOrder, getGoodsOrder } from '@/api/system/goodsOrder';
import QuerySearchBar from '@/views/dashboard/components/goodsOrder/QuerySearchBar.vue';
import { OptionInvent, Options } from '@/views/dashboard/mixins/order/order_Invoice';
import { mapGetters } from 'vuex';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import OrderDisplay from '@/components/OrderDisplay/index.vue';
import { create, all } from 'mathjs';

export default {
	name: 'SelectGoods',
	components: { QuerySearchBar },
	mixins: [common_dialog],
	computed: {
		// 拿出需要的
		...mapGetters(['ticketPoint', 'comment']),
		// 计算剩余开票金额的方法
		calculateRemainingAmount() {
			return row => {
				const allPayments = this.math.bignumber(row.allPayments || 0);
				const totalInvoiceAmount = this.math.bignumber(row.params.totalInvoiceAmount || 0);
				const remaining = this.math.subtract(allPayments, totalInvoiceAmount);
				return Number(this.math.format(remaining, { precision: 2, notation: 'fixed' }));
			};
		}
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
			queryParams: {
				params: {}
			},
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
			id: null,
			// 订单选择的时候保存选中的行，方便取消选中后计算钱
			preOrderList: [],

			// 左下角检索的信号量
			checkFlag: null,

			// 定义 QuerySearchBar 显示的字段 - 只显示选择订单时常用的搜索条件
			searchBarFields: [
				'dateRange', // 时间范围
				'customer', // 客户名称
				'supplierNames', // 供应商
				'landDriverName', // 司机名称
				'landCarNo', // 车牌
				'checkState' // 审核状态
			]
		};
	},
	created() {
		this.math = create(all, { number: 'BigNumber', precision: 64 });
		this.resetParams();
		this.getList();
	},
	mounted() {
		// 清除一下状态
		this.checkFlag = null;

		// 接受事件总线传递来的该组件的更新操作 并且传入回调函数
		this.$bus.$on('select-goods:update', () => this.refresh());
		// 监听重置筛选的事件 将是否检索设置为未检索 信号量为空
		this.$bus.$on('select-goods-row:update', () => {
			this.hasClicked = false;
			this.checkFlag = null;
			// 重置搜索条件
			this.resetParams();
		});
		// 接受分配剩余金额传入的关于客户或者供应商的筛选
		this.$bus.$on('update-goods-order-company', value => {
			// 筛选订单列表
			this.handleFilterOrders(value);
			// 赋值
			this.checkFlag = value;
			// 赋值类型
			this.type = value.type;
			// 赋值id 用于查找供应商
			this.id = value.id;
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
		// 查看订单详情（表头 + 明细）
		async handleViewOrder(row) {
			try {
				if (!row || !row.id) {
					this.$message.warning('无效的订单行');
					return;
				}
				const res = await getGoodsOrder(row.id);
				const orderInfo = (res && (res.data || res)) || {};
				let details = [];
				if (Array.isArray(orderInfo.orderDetailList)) details = orderInfo.orderDetailList;
				this.openDialog(
					OrderDisplay,
					`订单信息查看`,
					'90%',
					{
						orderInfo: orderInfo || {},
						orderDetailInfoList: details || [],
						ban: true
					},
					false,
					false
				);
			} catch (err) {
				console.error('查看订单失败:', err);
				this.$message.error('获取订单详情失败，请稍后重试');
			}
		},
		// 获取订单列表
		async getList() {
			// 如果信号量有值
			if (this.checkFlag) {
				try {
					// 判断一下类型 赋值
					this.checkFlag.type === PUBLIC_DICT_TYPE.CUSTOMER ? (this.queryParams.customerID = this.checkFlag.id) : (this.queryParams.params[`supplierId`] = this.checkFlag.id);
				} catch (err) {
					console.log('Error parsing checkFlag:', err);
				}
			}

			// 搜索
			try {
				const res = await listGoodsOrder(this.queryParams);
				// 筛选出未开完的订单
				this.goodsOrderList = res.rows
					.map(row => {
						// 计算剩余开票金额 - 使用 mathjs 进行精确计算
						const allPayments = this.math.bignumber(row.allPayments || 0);
						const totalInvoiceAmount = this.math.bignumber(row.params.totalInvoiceAmount || 0);
						const remainingInvoiceAmount = this.math.subtract(allPayments, totalInvoiceAmount);
						// 只返回剩余开票金额大于0的订单
						if (this.math.larger(remainingInvoiceAmount, this.math.bignumber(0))) {
							return row;
						}
						return null;
					})
					.filter(row => row !== null);
				this.total = res.total;
			} catch (error) {
				console.log('Failed to fetch goods order list:', error);
			} finally {
				this.loading = false;
			}
		},

		// 多选 这边需要通过vuex进行管理状态 因为跨越组件了
		handleSelectionChange(selection) {
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
			value.type === PUBLIC_DICT_TYPE.CUSTOMER ? this.handleCustomerFilter(value.id) : this.handleSupplierFilter(value.id);
		},
		// 对客户的筛选
		async handleCustomerFilter(companyId) {
			if (!companyId) {
				this.$message.warning('非法id!');
			}
			try {
				// 赋值搜索条件
				this.queryParams.customerID = companyId;
				// 2025-2-13 订单搜索需要传入companyType
				this.queryParams.params.BatchInsertInvoiceCompanyType = PUBLIC_DICT_TYPE.CUSTOMER;
				// 强制更新vue 在更新数据后依赖于 DOM 的最新状态，比如获取某个元素的大小、位置等
				await this.$nextTick();
				// 获取订单列表
				await this.getList();
				// 设置点击了检索标记
				this.hasClicked = true;
				// 查询完订单列表后清除搜索条件
				this.resetParams();
			} catch (err) {
				console.error('Error fetching list:', err);
			}
		},
		// 对供应商的筛选
		async handleSupplierFilter(companyId) {
			if (!companyId) {
				this.$message.warning('非法id!');
			}
			try {
				// 赋值数据
				this.queryParams.params.supplierId = companyId;
				// 2025-2-13 订单搜索需要传入companyType
				this.queryParams.params.BatchInsertInvoiceCompanyType = PUBLIC_DICT_TYPE.SUPPLIER;
				// 强制更新vue
				await this.$nextTick();
				// 获取列表
				await this.getList();
				// 设置点击了检索标记
				this.hasClicked = true;
				this.resetParams();
			} catch (err) {
				console.error('Error fetching list:', err);
			}
		},
		// 处理选择的订单
		multipleMoney(orders) {
			// 查找出新增的行和取消勾选的行
			const addedRows = orders.filter(row => !this.preOrderList.includes(row));
			const removedRows = this.preOrderList.filter(row => !orders.includes(row));

			// 非法参数校验
			const _row = addedRows[0] || removedRows[0];
			if (_row.params.totalInvoiceAmount == null || _row.params.totalInvoiceAmount === undefined) {
				this.$message.warning('参数有误：已开票金额为空');
				return;
			}
			// 排除小于0的情况
			if (_row.params.totalInvoiceAmount < 0) {
				this.$message.warning('参数有误：已开票金额小于0');
				return;
			}
			// 更新选择的订单
			this.preOrderList = orders;

			// 计算要扣除的钱
			let money = 0;
			try {
				if (removedRows.length !== 0) {
					money = this.calculateMoney(removedRows, this.type);
					if (money && money > 0) {
						this.$store.commit('excel/ADD_INVOICE_AMOUNT', money);
					}
				}
				if (addedRows.length !== 0) {
					money = this.calculateMoney(addedRows, this.type);

					if (money && money > 0) {
						this.$store.commit('excel/MULTI_INVOICE_AMOUNT', money);
					}
				}
			} catch (err) {
				this.$message.warning('操作失败: ' + err.message || err);
				// 取消勾选
				this.$refs.goodsTable.clearSelection();
				// 重置金额
				this.$store.dispatch('excel/setInvoiceAmount', sessionStorage.getItem('invoiceAmount'));
			}
		},
		// 计算操作金额的函数
		calculateMoney(rows, type) {
			let money = this.math.bignumber(0);
			if (rows.length === 0) return Number(this.math.format(money, { precision: 2, notation: 'fixed' }));

			for (let row of rows) {
				if (type === PUBLIC_DICT_TYPE.CUSTOMER) {
					const totalInvoiceAmount = this.math.bignumber(row.params.totalInvoiceAmount || 0);
					if (this.math.larger(totalInvoiceAmount, this.math.bignumber(0))) {
						const allPayments = this.math.bignumber(row.allPayments || 0);
						if (this.math.larger(totalInvoiceAmount, allPayments)) {
							this.$message.warning('参数有误：已开票金额大于总货款');
							// 取消勾选
							this.$refs.goodsTable.clearSelection();
							break;
						}
						money = this.math.add(money, totalInvoiceAmount);
					} else {
						// 客户操作金额
						const allPayments = this.math.bignumber(row.allPayments || 0);
						money = this.math.add(money, allPayments);
					}
				} else if (type === PUBLIC_DICT_TYPE.SUPPLIER) {
					let _total = this.math.bignumber(0);
					if (!row.smailOrderDetails) {
						this.$message.warning('该行订单详情为空，总出厂货款为0');
					} else {
						// 计算总的出场货款 - 使用 mathjs 进行精确计算
						_total = row.smailOrderDetails.reduce((pre, cur) => {
							return this.math.add(this.math.bignumber(pre), this.math.bignumber(cur.paymentFactory || 0));
						}, this.math.bignumber(0));
					}

					const totalInvoiceAmount = this.math.bignumber(row.params.totalInvoiceAmount || 0);
					if (this.math.larger(totalInvoiceAmount, this.math.bignumber(0))) {
						if (this.math.larger(totalInvoiceAmount, _total)) {
							this.$message.warning('参数有误：已开票金额大于总出厂货款');
							// 取消勾选
							this.$refs.goodsTable.clearSelection();
							break;
						}
						money = this.math.add(money, totalInvoiceAmount);
					} else {
						row.smailOrderDetails.forEach(detail => {
							if (detail.supplierID === this.id) {
								const paymentFactory = this.math.bignumber(detail.paymentFactory || 0);
								money = this.math.add(money, paymentFactory);
							}
						});
					}
				}
			}

			return Number(this.math.format(money, { precision: 2, notation: 'fixed' }));
		},

		handleQuery(value) {
			// this.queryParams = value;
			Object.assign(this.queryParams, value);
			this.getList();
		},
		// 多选框是否禁用
		selectable() {
			return !this.isBaned;
		},
		// 重新拉取数据
		refresh() {
			this.checkFlag = null;
			this.resetParams();
			this.getList();
		},

		// 生成发票（占位，暂未实现）
		generateInvoice() {
			// 触发事件，由 InvoiceBody 去处理生成发票的逻辑
			this.$bus.$emit('generate-invoice');
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
				// invoiceState: '未开票',
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
				isAdjust: 0,
				adjustOrderid: null,
				isedit: null,
				customerIsInvoice: null,
				isSupplierInvoice: null,
				params: {
					BatchInsertInvoiceCompanyType: PUBLIC_DICT_TYPE.CUSTOMER,
					supplierId: null,
					isIncludeTaxSale: null,
					isIncludeTaxFactory: null
				}
			};
		}
	}
};
</script>

<template>
	<div>
		<QuerySearchBar :query-params="queryParams" :visible-fields="searchBarFields" @updateQuery="handleQuery" />
		<!-- 操作按钮：刷新 + 生成发票（右对齐） -->
		<div class="select-actions">
			<el-button type="primary" size="mini" @click="generateInvoice">生成发票</el-button>
		</div>
		<!--    订单列表主体-->
		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			fit
			ref="goodsTable"
			max-height="700px"
			border
			empty-text="暂无可开票订单（订单的可开票金额为0）"
			:data="goodsOrderList"
			virtual-scroll
			size="mini"
			:cell-style="
				() => {
					return { padding: '2px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column label="操作" width="100" align="center">
				<template #default="scope">
					<el-button type="text" size="mini" @click.stop="handleViewOrder(scope.row)">查 看</el-button>
				</template>
			</el-table-column>
			<el-table-column type="selection" width="55" align="center" :selectable="selectable" />
			<el-table-column v-if="type" show-overflow-tooltip :label="type + `剩余开票金额`" align="center" width="150px">
				<template #default="scope">
					{{ calculateRemainingAmount(scope.row) }}
				</template>
			</el-table-column>
			<el-table-column show-overflow-tooltip label="ID" align="center" prop="id" />
			<el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" />
			<el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" />
			<el-table-column show-overflow-tooltip label="供应商/仓库" align="center" prop="supplierNames" width="200"></el-table-column>
			<el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo" />
			<el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel" width="100px" />
			<el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName" width="100px" />
			<el-table-column show-overflow-tooltip label="总货款" align="center" prop="allPayments" width="100px"></el-table-column>
			<el-table-column show-overflow-tooltip label="陆运费" align="center" prop="landFreight" width="100px" />
			<!--      原为海运车牌号-->
			<el-table-column show-overflow-tooltip label="海运柜号" align="center" prop="seaCarNo">
				<template #default="scope">
					{{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}
				</template>
			</el-table-column>
			<el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel" width="100px">
				<template #default="scope">
					{{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}
				</template>
			</el-table-column>
			<!--      原为海运司机姓名-->
			<el-table-column show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName" width="100px">
				<template #default="scope">
					{{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverTel }}
				</template>
			</el-table-column>
			<el-table-column show-overflow-tooltip label="海运费" align="center" prop="seaFreight" width="100px" />
			<el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager" />
			<el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet" />
			<el-table-column show-overflow-tooltip label="录入员" align="center" prop="userName" width="120px" />
			<el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState" width="120"></el-table-column>
			<el-table-column show-overflow-tooltip label="客户是否开票" align="center" prop="customerIsInvoice" width="150px">
				<template #default="scope">
					{{ scope.row.customerIsInvoice === 1 ? '是' : '否' }}
				</template>
			</el-table-column>
			<el-table-column show-overflow-tooltip label="供应商是否开票" align="center" prop="isSupplierInvoice" width="120px">
				<template #default="scope">
					{{ scope.row.isSupplierInvoice >= 1 ? '是' : '否' }}
				</template>
			</el-table-column>
			<el-table-column show-overflow-tooltip label="备注" align="center" prop="comments" />
		</el-table>
		<!--    分页组件-->
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
	</div>
</template>

<style scoped lang="scss">
.select-actions {
	display: flex;
	justify-content: flex-end; /* 右对齐 */
	gap: 8px;
	margin: 8px 0;
}
</style>
