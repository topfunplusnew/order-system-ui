<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
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
				<!--    后端说导出不要了 删除了    导出-->
				<!-- <template #export>
          <el-col :span="1.5">
            <el-button
              v-hasPermi="['system:exwarehouse:export']"
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport"
            ></el-button>
          </el-col>
        </template> -->
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
			<el-table-column v-if="columns[1].visible" label="出库日期" align="center" prop="outDate" />
			<el-table-column v-if="columns[2].visible" label="出库量" align="center" prop="outAmount" />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-tooltip
						class="item"
						effect="dark"
						:content="scope.row.ordersNo === '二次加工' || scope.row.ordersNo === '货物破损' ? '特殊货物无法查看' : '查看订单信息'"
						placement="top-start"
					>
						<el-button size="mini" type="text" :disabled="scope.row.ordersNo === '二次加工' || scope.row.ordersNo === '货物破损'" @click="checkOrderInfo(scope.row)">
							查看订单信息
						</el-button>
					</el-tooltip>
					<el-button size="mini" type="text" @click="checkInvoInfo(scope.row)">查看库存信息</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改出库对话框 -->
		<el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<!--        <el-form-item label="订单编号" prop="ordersNo">-->
				<!--          <el-input v-model="form.ordersNo" placeholder="请输入订单编号"/>-->
				<!--        </el-form-item>-->
				<!--        <el-form-item label="仓库ID" prop="storeHouseid">-->
				<!--          <el-input v-model="form.storeHouseid" placeholder="请输入仓库ID"/>-->
				<!--        </el-form-item>-->
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

		<!--    查看订单详情信息-->
		<el-dialog :close-on-click-modal="false" :show-close="false" title="查看订单信息" :visible.sync="checkOrderVisible" width="900px">
			<el-descriptions title="订单信息" :column="3" border size="mini">
				<el-descriptions-item label="id">
					{{ orderDetailInfo.id || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="日期">
					{{ orderDetailInfo.orderDate || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="客户">
					{{ orderDetailInfo.customer || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="商家姓名">
					{{ orderDetailInfo.supplierNames || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="车队">
					{{ orderDetailInfo.fleet || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="审核状态">
					<TagsItem :check-info="orderDetailInfo.checkState" checkValue="未审核" />
				</el-descriptions-item>
				<el-descriptions-item label="开票状态">
					<TagsItem :check-info="orderDetailInfo.invoiceState" checkValue="未开票" />
				</el-descriptions-item>
				<el-descriptions-item label="附件">
					{{ orderDetailInfo.path || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运车牌">
					{{ orderDetailInfo.landCarNo || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运司机电话">
					{{ orderDetailInfo.landDriverTel || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运司机姓名">
					{{ orderDetailInfo.landDriverName || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="柜号">
					{{ orderDetailInfo.seaCarNo || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="海运司机电话">
					{{ orderDetailInfo.seaDriverTel || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="海运公司">
					{{ orderDetailInfo.seaDriverName || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="打款状态">
					{{ orderDetailInfo.PaymentState || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运银行户名">
					{{ orderDetailInfo.landBankName || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运银行账号">
					{{ orderDetailInfo.landBankNo || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="海运银行户名">
					{{ orderDetailInfo.seaBankName || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="海运银行账号">
					{{ orderDetailInfo.seaBankNo || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="收到条附件">
					{{ orderDetailInfo.receiveProof || '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="是否被调整单">
					<TagsItem :check-info="orderDetailInfo.isAdjusted" check-value="否" />
				</el-descriptions-item>
				<el-descriptions-item v-if="orderDetailInfo.isAdjusted" label="调整日期">
					{{ orderDetailInfo.adjustDate }}
				</el-descriptions-item>
				<el-descriptions-item label="原订单编号">
					{{ orderDetailInfo.adjustOrderid }}
				</el-descriptions-item>
				<el-descriptions-item label="是否可编辑">
					<TagsItem :check-info="isOrNot(orderDetailInfo.isedit)" check-value="否" />
				</el-descriptions-item>
				<el-descriptions-item label="客户是否开票">
					<TagsItem :check-info="isOrNot(orderDetailInfo.customerIsInvoice)" check-value="否" />
				</el-descriptions-item>
				<el-descriptions-item label="供应商是否开票">
					<TagsItem :check-info="isOrNot(orderDetailInfo.customerIsInvoice)" check-value="否" />
				</el-descriptions-item>
				<el-descriptions-item label="陆运费">
					{{ orderDetailInfo.landFreight }}
				</el-descriptions-item>
				<el-descriptions-item label="海运费">
					{{ orderDetailInfo.seaFreight }}
				</el-descriptions-item>
			</el-descriptions>
			<span slot="footer" class="dialog-footer">
				<el-button @click="checkOrderVisible = false">取 消</el-button>
				<el-button type="primary" @click="checkOrderVisible = false">确 定</el-button>
			</span>
		</el-dialog>

		<!--    库存信息-->
		<el-dialog :close-on-click-modal="false" :show-close="false" title="查看库存信息" :visible.sync="checkInventoryVisible" width="900px">
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
				<el-descriptions-item label="卸货费">
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
				<el-descriptions-item label="实际片数">
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
import { listExWarehouse, getExWarehouse, delExWarehouse, addExWarehouse, updateExWarehouse } from '@/api/system/exWarehouse';
import { listGoodsOrder } from '@/api/system/goodsOrder';
import TagsItem from '@/components/TagsItem/index.vue';
import { getInventory, listInventory } from '@/api/system/inventory';
import { listConfig } from '@/api/system/config';
import { addDateRange } from '@/utils/ruoyi';
import { getDetail, listDetail } from '../../../api/system/detail';

export default {
	name: 'ExWarehouse',
	components: { TagsItem },
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
				pageSize: 10,
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
				{ key: 1, label: `出库日期`, visible: true },
				{ key: 2, label: `出库量`, visible: true }
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
		checkOrderInfo(row) {
			// 查询订单详情
			listGoodsOrder({ ordersNo: row.ordersNo }).then(res => {
				this.orderDetailInfo = res.rows[0];
				this.checkOrderVisible = true;
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
