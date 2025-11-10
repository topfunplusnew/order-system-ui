<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="仓库名称" prop="storeHouseName">
				<el-input v-model="queryParams.storeHouseName" placeholder="请输入仓库名称" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="出库日期">
				<el-date-picker
					v-model="dateRange"
					style="width: 240px"
					value-format="yyyy-MM-dd HH:mm:ss"
					type="daterange"
					range-separator="-"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
				></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-horizontal-scroll="'always'"
			v-loading="loading"
			border
			:data="exWarehouseList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column v-if="columns[0].visible" label="仓库名称" align="center" prop="storeHouseName" />
			<el-table-column v-if="columns[1].visible" label="出库方向" align="center" prop="outDirection">
				<template slot-scope="scope">
					<span v-if="scope.row.outDirection && scope.row.outDirection !== '二次加工' && scope.row.outDirection !== '破损出库'">
						<el-tooltip content="该出库方向为客户名称" placement="top">
							<span style="color: #f56c6c; font-weight: bold">{{ scope.row.outDirection }}[客户]</span>
						</el-tooltip>
					</span>
					<span v-else-if="scope.row.outDirection && scope.row.outDirection === '二次加工'">二次入库出库</span>
					<span v-else>存货毁损</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[2].visible" label="变动日期(出库)" align="center" prop="outDate">
				<template #default="scope">
					{{ parseTime(scope.row.outDate, '{y}-{m}-{d}') }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[3].visible" label="产品级别" align="center" prop="sourceInventoryDetail.levelName" />
			<el-table-column v-if="columns[4].visible" label="厚度" align="center" prop="sourceInventoryDetail.height" />
			<el-table-column v-if="columns[5].visible" label="长度" align="center" prop="sourceInventoryDetail.length" />
			<el-table-column v-if="columns[6].visible" label="宽度" align="center" prop="sourceInventoryDetail.width" />
			<el-table-column v-if="columns[7].visible" label="存货价" align="center" prop="sourceInventoryDetail.paymentUnload" />
			<el-table-column v-if="columns[8].visible" label="出库量" align="center" prop="outAmount" />
			<el-table-column v-if="columns[9].visible" label="出库金额" align="center">
				<template slot-scope="scope">
					{{ computedAmount(scope.row) }}
				</template>
			</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="80">
				<template slot-scope="scope">
					<el-dropdown trigger="hover">
						<span class="el-dropdown-link">
							操作
							<i class="el-icon-arrow-down el-icon--right"></i>
						</span>
						<el-dropdown-menu slot="dropdown">
							<el-dropdown-item
								:disabled="scope.row.ordersNo === '二次加工' || scope.row.ordersNo === '货物破损'"
								@click.native="scope.row.ordersNo !== '二次加工' && scope.row.ordersNo !== '货物破损' && checkOrderInfo(scope.row)"
							>
								<el-tooltip
									class="item"
									effect="dark"
									:content="scope.row.ordersNo === '二次加工' || scope.row.ordersNo === '货物破损' ? '特殊货物无法查看' : '查看订单信息'"
									placement="top-start"
								>
									<span>查看订单信息</span>
								</el-tooltip>
							</el-dropdown-item>
							<el-dropdown-item @click.native="checkInvoInfo(scope.row)">查看库存信息</el-dropdown-item>
						</el-dropdown-menu>
					</el-dropdown>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改出库对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="仓库名称" prop="storeHouseName">
					<el-input v-model="form.storeHouseName" placeholder="请输入仓库名称" />
				</el-form-item>
				<el-form-item label="仓库存储的货物ID" prop="storeID">
					<el-input v-model="form.storeID" placeholder="请输入仓库存储的货物ID" />
				</el-form-item>
				<el-form-item label="出库日期" prop="outDate">
					<el-input v-model="form.outDate" placeholder="请输入出库日期" />
				</el-form-item>
				<el-form-item label="出库量" prop="outAmount">
					<el-input v-model="form.outAmount" placeholder="请输入出库量" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="查看库存信息"
			:visible.sync="checkInventoryVisible"
			width="900px"
		>
			<el-descriptions title="库存详情" border size="mini">
				<el-descriptions-item label="备注">
					{{ inventoryInfo.remark || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="仓库名称">
					{{ inventoryInfo.storeHouseName }}
				</el-descriptions-item>
				<el-descriptions-item label="入库日期">
					{{ inventoryInfo.storeDate }}
				</el-descriptions-item>
				<el-descriptions-item label="库存数量">
					{{ inventoryInfo.stockNumber }}
				</el-descriptions-item>
				<el-descriptions-item label="供应商">
					{{ inventoryInfo.supplier }}
				</el-descriptions-item>
				<el-descriptions-item label="等级名称">
					{{ inventoryInfo.levelName }}
				</el-descriptions-item>
				<el-descriptions-item label="计数单位">
					{{ inventoryInfo.countingUnit }}
				</el-descriptions-item>
				<el-descriptions-item label="厚度">
					{{ inventoryInfo.height }}
				</el-descriptions-item>
				<el-descriptions-item label="长度">
					{{ inventoryInfo.length }}
				</el-descriptions-item>
				<el-descriptions-item label="宽度">
					{{ inventoryInfo.width }}
				</el-descriptions-item>
				<el-descriptions-item label="总片数">
					{{ inventoryInfo.pieces }}
				</el-descriptions-item>
				<el-descriptions-item label="每包片数">
					{{ inventoryInfo.piecesPerPack }}
				</el-descriptions-item>
				<el-descriptions-item label="包数">
					{{ inventoryInfo.packs }}
				</el-descriptions-item>
				<el-descriptions-item label="单价">
					{{ inventoryInfo.price }}
				</el-descriptions-item>
				<el-descriptions-item label="是否含税出厂">
					{{ inventoryInfo.isIncludeTaxFactory ? '是' : '否' }}
				</el-descriptions-item>
				<el-descriptions-item label="杂费">
					{{ inventoryInfo.sundryCost }}
				</el-descriptions-item>
				<el-descriptions-item label="出厂支付">
					{{ inventoryInfo.paymentFactory }}
				</el-descriptions-item>
				<el-descriptions-item label="卸货价">
					{{ inventoryInfo.paymentUnload }}
				</el-descriptions-item>
				<el-descriptions-item label="是否含税销售">
					{{ inventoryInfo.isIncludeTaxSale ? '是' : '否' }}
				</el-descriptions-item>
				<el-descriptions-item label="总支付">
					{{ inventoryInfo.payments }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运车号">
					{{ inventoryInfo.landCarNo }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运司机电话">
					{{ inventoryInfo.landDriverTel }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运司机姓名">
					{{ inventoryInfo.landDriverName }}
				</el-descriptions-item>
				<el-descriptions-item label="海运车号">
					{{ inventoryInfo.seaCarNo || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="海运司机电话">
					{{ inventoryInfo.seaDriverTel || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="海运公司">
					{{ inventoryInfo.seaDriverName || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="误差率">
					{{ inventoryInfo.erro }}
				</el-descriptions-item>
				<el-descriptions-item label="吨位">
					{{ inventoryInfo.tonnage }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运费单价">
					{{ inventoryInfo.landFreightPrice }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运费">
					{{ inventoryInfo.landFreight }}
				</el-descriptions-item>
				<el-descriptions-item label="海运费">
					{{ inventoryInfo.seaFreight }}
				</el-descriptions-item>
				<el-descriptions-item label="总运费">
					{{ inventoryInfo.freight }}
				</el-descriptions-item>
				<el-descriptions-item label="其他费用">
					{{ inventoryInfo.otherCost }}
				</el-descriptions-item>
				<el-descriptions-item label="利润">
					{{ inventoryInfo.profit }}
				</el-descriptions-item>
				<el-descriptions-item label="未税利润">
					{{ inventoryInfo.profitNoTax }}
				</el-descriptions-item>
				<el-descriptions-item label="卸货片数">
					{{ inventoryInfo.actualPieces }}
				</el-descriptions-item>
				<el-descriptions-item label="含杂费总支付">
					{{ inventoryInfo.paymentsWithSundry }}
				</el-descriptions-item>
				<el-descriptions-item label="附加费">
					{{ inventoryInfo.additionalFees }}
				</el-descriptions-item>
				<el-descriptions-item label="返利">
					{{ inventoryInfo.rebate }}
				</el-descriptions-item>
				<el-descriptions-item label="厂家佣金">
					{{ inventoryInfo.customerCommission }}
				</el-descriptions-item>
				<el-descriptions-item label="备注信息">
					{{ inventoryInfo.comments }}
				</el-descriptions-item>
			</el-descriptions>
			<span slot="footer" class="dialog-footer">
				<el-button @click="checkInventoryVisible = false">取 消</el-button>
				<el-button type="primary" @click="checkInventoryVisible = false">确 定</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
/* eslint-disable */
import { listExWarehouse, getExWarehouse, delExWarehouse, addExWarehouse, updateExWarehouse } from '@/api/system/exWarehouse';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { addDateRange, parseTime } from '@/utils/ruoyi';
import { getDetail } from '../../../api/system/detail';
import { listOrderDetailByOrderNos } from '../../../api/system/orderDetail';
import OrderDetailInfo from '../../dashboard/components/goodsOrder/OrderDetailInfo.vue';

export default {
	name: 'ExWarehouse',
	mixins: [common_dialog],
	data() {
		return {
			// 遮罩层
			loading: true,
			// 选中数组
			ids: [],
			// 非单个禁用
			single: true,
			// 非多个禁用
			multiple: true,
			// 显示搜索条件
			showSearch: true,
			// 总条数
			total: 0,
			// 出库表格数据
			exWarehouseList: [],
			// 弹出层标题
			title: '',
			// 日期范围
			dateRange: [],
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				ordersNo: null,
				storeHouseid: null,
				storeHouseName: null,
				storeID: null,
				outDate: null,
				outAmount: null,
				delFlag: null,
				addtime: null,
				userId: null,
				UserName: null,
				isOrder: true
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {},
			columns: [
				{ key: 0, label: `仓库名称`, visible: true },
				{ key: 1, label: `出库方向`, visible: true },
				{ key: 2, label: `出库日期`, visible: true },
				{ key: 3, label: `产品级别`, visible: true },
				{ key: 4, label: `厚度`, visible: true },
				{ key: 5, label: `长度`, visible: true },
				{ key: 6, label: `宽度`, visible: true },
				{ key: 7, label: `存货价`, visible: true },
				{ key: 8, label: `出库量`, visible: true },
				{ key: 9, label: `出库金额`, visible: true } // 新增
			],
			checkOrderVisible: false,
			orderDetailInfo: {},
			inventoryInfo: {},
			checkInventoryVisible: false
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('exwarehouse-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('exwarehouse-columns') === 'null' || !localStorage.getItem('exwarehouse-columns')) {
			// 设置localStorage
			localStorage.setItem('exwarehouse-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('exwarehouse-columns'));
		}
	},
	// 取消按钮
	cancel() {
		this.open = false;
		this.reset();
	},
	methods: {
		computedAmount(row) {
			const length = (row.sourceInventoryDetail && row.sourceInventoryDetail.length) || 0;
			const width = (row.sourceInventoryDetail && row.sourceInventoryDetail.width) || 0;
			const amount = row.outAmount || 0;
			const price = (row.sourceInventoryDetail && row.sourceInventoryDetail.paymentUnload) || 0;
			const result = (length / 1000) * (width / 1000) * amount * price;
			return result.toFixed(2);
		},
		checkOrderInfo(row) {
			// 使用动态弹窗显示订单详情
			if (!row || !row.ordersNo) {
				this.$message.warning('无效的订单号');
				return;
			}
			listOrderDetailByOrderNos([row.ordersNo])
				.then(res => {
					const details = res.rows || [];
					this.openDialog(OrderDetailInfo, '订单详情信息查看', '700px', { orderDetailInfoList: details, ban: true }, false);
				})
				.catch(err => {
					console.error('获取订单详情失败:', err);
					this.$message.error('获取订单详情失败，请稍后重试');
				});
		},

		// 查看库存信息 查询当前行的库存信息
		checkInvoInfo(row) {
			getDetail(row.storeID).then(res => {
				this.inventoryInfo = res.data;
				this.checkInventoryVisible = true;
			});
		},
		isOrNot(val) {
			return val === 1 ? '是' : '否';
		},

		/** 查询出库列表 */
		getList() {
			this.loading = true;
			// this.dateRange
			listExWarehouse(addDateRange(this.queryParams, this.dateRange)).then(response => {
				this.exWarehouseList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		/** 查询参数列表 */

		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				ordersNo: null,
				storeHouseid: null,
				storeHouseName: null,
				storeID: null,
				outDate: null,
				outAmount: null,
				delFlag: null,
				updateTime: null,
				addtime: null,
				userId: null,
				UserName: null
			};
			this.resetForm('form');
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.dateRange = [];
			this.resetForm('queryForm');
			this.handleQuery();
		},
		// 多选框选中数据
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
		},
		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加出库';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getExWarehouse(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改出库';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						updateExWarehouse(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addExWarehouse(this.form).then(response => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getList();
						});
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除出库编号为"' + ids + '"的数据项？')
				.then(function () {
					return delExWarehouse(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/exWarehouse/export',
				{
					...this.queryParams
				},
				`exWarehouse_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
