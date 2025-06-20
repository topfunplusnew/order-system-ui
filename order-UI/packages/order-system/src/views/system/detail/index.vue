<template>
	<div class="app-container">
		<el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="100px">
			<el-form-item label="仓库名称" prop="supplier">
				<el-row>
					<el-col :span="20">
						<el-input v-model="storeHouseName" placeholder="请输入仓库" clearable size="mini" @keyup.enter.native="handleQuery" disabled />
					</el-col>
					<el-col :span="4">
						<SearchOption
							:get-data="listStoreHouse"
							icon="el-icon-search"
							:limit-info="{}"
							query-label="仓库名称"
							query-info="storeHouseName"
							:query-name="queryStoreHouseName"
							@commitBack="
								value => {
									queryParams.params.main_storeHouseid = value.id;
									storeHouseName = value.storeHouseName;
								}
							"
							@update:queryName="value => (queryStoreHouseName = value)"
						>
							<template #table-columns>
								<el-table-column label="仓库名称" align="center" prop="storeHouseName" />
								<el-table-column label="地址" align="center" prop="address" />
							</template>
						</SearchOption>
					</el-col>
				</el-row>
			</el-form-item>
			<el-form-item label="入库开始日期" prop="storeDate">
				<el-date-picker v-model="queryParams.params.main_storeDate_startTime" type="date" value-format="yyyy-MM-dd" placeholder="选择入库日期" clearable />
			</el-form-item>
			<el-form-item label="入库结束日期" prop="storeDate">
				<el-date-picker v-model="queryParams.params.main_storeDate_endTime" type="date" value-format="yyyy-MM-dd" placeholder="选择入库日期" clearable />
			</el-form-item>
			<el-form-item label="供应商" prop="supplier">
				<el-input v-model="queryParams.supplier" placeholder="请输入供应商" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="级别编码" prop="levelID">
				<el-input v-model="queryParams.levelID" placeholder="请输入级别编码" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="级别名称" prop="levelName">
				<el-input v-model="queryParams.levelName" placeholder="请输入级别名称" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="厚度" prop="height">
				<el-input v-model="queryParams.height" placeholder="请输入厚度" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="长度" prop="length">
				<el-input v-model="queryParams.length" placeholder="请输入长度" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="宽度" prop="width">
				<el-input v-model="queryParams.width" placeholder="请输入宽度" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="吨位" prop="tonnage">
				<el-input v-model="queryParams.tonnage" placeholder="请输入吨位" clearable size="mini" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['system:detail:export']">导出</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-row :gutter="10">
			<el-col :span="4">
				<div class="tree-container" style="max-height: 400px; overflow-y: auto">
					<el-tree :data="storeList" :props="defaultProps" @node-click="handleNodeClick" />
				</div>
			</el-col>
			<el-col :span="20">
				<el-table border id="printBox" size="mini" v-loading="loading" :data="detailList" @selection-change="handleSelectionChange">
					<!-- 手写每一列，使用 v-if 判断列的可见性 -->
					<el-table-column v-if="columns[0].visible" label="ID" align="center" prop="id" show-overflow-tooltip />
					<el-table-column v-if="columns[1].visible" label="变动日期(入库)" align="center" prop="storeDate" show-overflow-tooltip />
					<el-table-column v-if="columns[2].visible" label="仓库名称" align="center" prop="storeHouseName" show-overflow-tooltip />
					<el-table-column v-if="columns[3].visible" label="入库片数" align="center" prop="stockNumber" show-overflow-tooltip />
					<el-table-column v-if="columns[4].visible" label="剩余量" align="center" prop="actualPieces" show-overflow-tooltip />
					<el-table-column v-if="columns[5].visible" label="供应商" align="center" prop="supplier" show-overflow-tooltip />
					<el-table-column v-if="columns[6].visible" label="计量单位" align="center" prop="countingUnit" show-overflow-tooltip />
					<el-table-column v-if="columns[7].visible" label="厚度" align="center" prop="height" show-overflow-tooltip />
					<el-table-column v-if="columns[8].visible" label="长度" align="center" prop="length" show-overflow-tooltip />
					<el-table-column v-if="columns[9].visible" label="宽度" align="center" prop="width" show-overflow-tooltip />
					<el-table-column v-if="columns[10].visible" label="每包片数" align="center" prop="piecesPerPack" show-overflow-tooltip />
					<el-table-column v-if="columns[11].visible" label="包数" align="center" prop="packs" show-overflow-tooltip />
					<el-table-column v-if="columns[12].visible" label="存货价" align="center" prop="paymentUnload" show-overflow-tooltip />
					<el-table-column v-if="columns[13].visible" label="库存是否含税" align="center" prop="isIncludeTaxSale" show-overflow-tooltip>
						<template #default="scope">
							<span>{{ scope.row.isIncludeTaxSale === 1 ? '含税' : '不含税' }}</span>
						</template>
					</el-table-column>
					<el-table-column v-if="columns[14].visible" label="入库金额" align="center" prop="payments" show-overflow-tooltip />
					<el-table-column v-if="columns[15].visible" label="误差" align="center" prop="erro" show-overflow-tooltip />
					<el-table-column v-if="columns[16].visible" label="吨位" align="center" prop="tonnage" show-overflow-tooltip />
					<!-- 操作列 -->
					<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="120px">
						<template #default="scope">
							<el-dropdown trigger="hover">
								<span class="el-dropdown-link">
									操作
									<i class="el-icon-arrow-down el-icon--right"></i>
								</span>
								<el-dropdown-menu slot="dropdown">
									<el-dropdown-item @click.native="secondryInventoryOut(scope.row)">加工后出库</el-dropdown-item>
									<el-dropdown-item @click.native="afterbreakInventoryOut(scope.row)">破损后出库</el-dropdown-item>
								</el-dropdown-menu>
							</el-dropdown>
						</template>
					</el-table-column>
				</el-table>
			</el-col>
		</el-row>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改库存子对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="主表ID，关联inventory_main表的id" prop="mainId">
					<el-input v-model="form.mainId" placeholder="请输入主表ID，关联inventory_main表的id" />
				</el-form-item>
				<el-form-item label="库存量(片数)(用来记录入库时的个数)" prop="stockNumber">
					<el-input v-model="form.stockNumber" placeholder="请输入库存量(片数)(用来记录入库时的个数)" />
				</el-form-item>
				<el-form-item label="供应商" prop="supplier">
					<el-input v-model="form.supplier" placeholder="请输入供应商" />
				</el-form-item>
				<el-form-item label="供应商ID" prop="supplierId">
					<el-input v-model="form.supplierId" placeholder="请输入供应商ID" />
				</el-form-item>
				<el-form-item label="级别编码" prop="levelID">
					<el-input v-model="form.levelID" placeholder="请输入级别编码" />
				</el-form-item>
				<el-form-item label="级别名称" prop="levelName">
					<el-input v-model="form.levelName" placeholder="请输入级别名称" />
				</el-form-item>
				<el-form-item label="计量单位" prop="countingUnit">
					<el-input v-model="form.countingUnit" placeholder="请输入计量单位" />
				</el-form-item>
				<el-form-item label="厚度" prop="height">
					<el-input v-model="form.height" placeholder="请输入厚度" />
				</el-form-item>
				<el-form-item label="长度" prop="length">
					<el-input v-model="form.length" placeholder="请输入长度" />
				</el-form-item>
				<el-form-item label="宽度" prop="width">
					<el-input v-model="form.width" placeholder="请输入宽度" />
				</el-form-item>
				<el-form-item label="出厂片数" prop="pieces">
					<el-input v-model="form.pieces" placeholder="请输入出厂片数" />
				</el-form-item>
				<el-form-item label="每包片数" prop="piecesPerPack">
					<el-input v-model="form.piecesPerPack" placeholder="请输入每包片数" />
				</el-form-item>
				<el-form-item label="包数" prop="packs">
					<el-input v-model="form.packs" placeholder="请输入包数" />
				</el-form-item>
				<el-form-item label="出厂单价" prop="price">
					<el-input v-model="form.price" placeholder="请输入出厂单价" />
				</el-form-item>
				<el-form-item label="出厂是否含税" prop="isIncludeTaxFactory">
					<el-input v-model="form.isIncludeTaxFactory" placeholder="请输入出厂是否含税" />
				</el-form-item>
				<el-form-item label="杂费" prop="sundryCost">
					<el-input v-model="form.sundryCost" placeholder="请输入杂费" />
				</el-form-item>
				<el-form-item label="出厂货款" prop="paymentFactory">
					<el-input v-model="form.paymentFactory" placeholder="请输入出厂货款" />
				</el-form-item>
				<el-form-item label="卸货价" prop="paymentUnload">
					<el-input v-model="form.paymentUnload" placeholder="请输入卸货价" />
				</el-form-item>
				<el-form-item label="销售是否含税" prop="isIncludeTaxSale">
					<el-input v-model="form.isIncludeTaxSale" placeholder="请输入销售是否含税" />
				</el-form-item>
				<el-form-item label="总货款" prop="payments">
					<el-input v-model="form.payments" placeholder="请输入总货款" />
				</el-form-item>
				<el-form-item label="误差" prop="erro">
					<el-input v-model="form.erro" placeholder="请输入误差" />
				</el-form-item>
				<el-form-item label="吨位" prop="tonnage">
					<el-input v-model="form.tonnage" placeholder="请输入吨位" />
				</el-form-item>
				<el-form-item label="陆运费单价" prop="landFreightPrice">
					<el-input v-model="form.landFreightPrice" placeholder="请输入陆运费单价" />
				</el-form-item>
				<el-form-item label="陆运费" prop="landFreight">
					<el-input v-model="form.landFreight" placeholder="请输入陆运费" />
				</el-form-item>
				<el-form-item label="海运费" prop="seaFreight">
					<el-input v-model="form.seaFreight" placeholder="请输入海运费" />
				</el-form-item>
				<el-form-item label="运费" prop="freight">
					<el-input v-model="form.freight" placeholder="请输入运费" />
				</el-form-item>
				<el-form-item label="其他费用" prop="otherCost">
					<el-input v-model="form.otherCost" placeholder="请输入其他费用" />
				</el-form-item>
				<el-form-item label="利润" prop="profit">
					<el-input v-model="form.profit" placeholder="请输入利润" />
				</el-form-item>
				<el-form-item label="不含税利润" prop="profitNoTax">
					<el-input v-model="form.profitNoTax" placeholder="请输入不含税利润" />
				</el-form-item>
				<el-form-item label="卸货片数" prop="actualPieces">
					<el-input v-model="form.actualPieces" placeholder="用来记录仓库还剩余的个数" />
				</el-form-item>
				<el-form-item label="总货款杂费" prop="paymentsWithSundry">
					<el-input v-model="form.paymentsWithSundry" placeholder="请输入总货款杂费" />
				</el-form-item>
				<el-form-item label="加费" prop="additionalFees">
					<el-input v-model="form.additionalFees" placeholder="请输入加费" />
				</el-form-item>
				<el-form-item label="返利金额" prop="rebate">
					<el-input v-model="form.rebate" placeholder="请输入返利金额" />
				</el-form-item>
				<el-form-item label="厂家佣金" prop="factoryCommission">
					<el-input v-model="form.factoryCommission" placeholder="请输入厂家佣金" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
				<el-form-item label="二次入库对应的出库id" prop="exWareHoustId">
					<el-input v-model="form.exWareHoustId" placeholder="请输入二次入库对应的出库id" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!-- 二次出库对话框 -->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="二次出库"
			:visible.sync="secondInvoiceInVisible"
			width="30%"
			append-to-body
		>
			<div slot="footer" class="dialog-footer">
				<el-row :gutter="5">
					<el-col :span="8">
						<span style="font-weight: bolder; line-height: 30px">请输入出库数量</span>
					</el-col>
					<el-col :span="10">
						<el-input type="number" v-model="secondNumber" placeholder="请输入出库数量" />
					</el-col>
				</el-row>
				<br />
				<el-button type="primary" @click="submitSecondInvoiceIn">确 定</el-button>
				<el-button @click="secondInvoiceInVisible = false">取 消</el-button>
			</div>
		</el-dialog>
		<!-- 货物破损出库对话框 -->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="货物破损出库"
			:visible.sync="breakInvoiceInVisible"
			width="30%"
			append-to-body
		>
			<div slot="footer" class="dialog-footer">
				<el-row :gutter="5">
					<el-col :span="8">
						<span style="font-weight: bolder; line-height: 30px">请输入出库数量</span>
					</el-col>
					<el-col :span="10">
						<el-input type="number" v-model="breakNumber" placeholder="请输入出库数量" />
					</el-col>
				</el-row>
				<br />
				<el-button type="primary" @click="submitBreakInvoiceIn">确 定</el-button>
				<el-button @click="breakInvoiceInVisible = false">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { addDetail, delDetail, getDetail, listDetail, updateDetail } from '@/api/system/detail';
import { addExWarehouse } from '@/api/system/exWarehouse';
import { parseTime } from '@/utils/ruoyi';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import SearchOption from '@/components/SearchOption.vue';
import { listStoreHouse } from '@/api/system/StoreHouse';

export default {
	name: 'Detail',
	components: { SearchOption },
	mixins: [mixin_printHTML],
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
			// 库存子表格数据
			detailList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			storeHouseName: null,
			queryStoreHouseName: null,
			storeList: [],
			defaultProps: {
				label: 'label'
			},
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				mainId: null,
				stockNumber: null,
				supplier: null,
				supplierId: null,
				levelID: null,
				levelName: null,
				countingUnit: null,
				height: null,
				length: null,
				width: null,
				pieces: null,
				piecesPerPack: null,
				packs: null,
				price: null,
				isIncludeTaxFactory: null,
				sundryCost: null,
				paymentFactory: null,
				paymentUnload: null,
				isIncludeTaxSale: null,
				payments: null,
				erro: null,
				tonnage: null,
				landFreightPrice: null,
				landFreight: null,
				seaFreight: null,
				freight: null,
				otherCost: null,
				profit: null,
				profitNoTax: null,
				actualPieces: null,
				paymentsWithSundry: null,
				additionalFees: null,
				rebate: null,
				factoryCommission: null,
				comments: null,
				exWareHoustId: null,
				delFlag: null,
				params: {
					main_storeHouseid: null,
					main_storeDate_startTime: null,
					main_storeDate_endTime: null
				}
			},
			// 表单参数
			form: {},
			columns: [
				{ key: 0, label: 'ID', prop: 'id', visible: true },
				{ key: 1, label: '变动日期(入库)', prop: 'storeDate', visible: true },
				{ key: 2, label: '仓库名称', prop: 'storeHouseName', visible: true },
				{ key: 3, label: '入库片数', prop: 'stockNumber', visible: true },
				{ key: 4, label: '剩余量', prop: 'actualPieces', visible: true },
				{ key: 5, label: '供应商', prop: 'supplier', visible: true },
				{ key: 6, label: '计量单位', prop: 'countingUnit', visible: true },
				{ key: 7, label: '厚度', prop: 'height', visible: true },
				{ key: 8, label: '长度', prop: 'length', visible: true },
				{ key: 9, label: '宽度', prop: 'width', visible: true },
				{ key: 10, label: '每包片数', prop: 'piecesPerPack', visible: true },
				{ key: 11, label: '包数', prop: 'packs', visible: true },
				{ key: 12, label: '存货价', prop: 'paymentUnload', visible: true },
				{ key: 13, label: '库存是否含税', prop: 'isIncludeTaxSale', visible: true },
				{ key: 14, label: '入库金额', prop: 'payments', visible: true },
				{ key: 15, label: '误差', prop: 'erro', visible: true },
				{ key: 16, label: '吨位', prop: 'tonnage', visible: true }
			],
			// 表单校验
			rules: {
				mainId: [
					{
						required: true,
						message: '主表ID，关联inventory_main表的id不能为空',
						trigger: 'blur'
					}
				]
			},
			secondNumber: 0,
			secondInvoiceInVisible: false,
			secondInfo: {},
			breakNumber: 0,
			breakInvoiceInVisible: false,
			breakInfo: {}
		};
	},
	watch: {
		/**
		 * @description: 监听列配置的变化，并将其保存到 localStorage
		 * @param {Array} newVal 新的列配置
		 */
		columns: {
			handler: function (newVal) {
				localStorage.setItem('detail-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		this.fetchStore();
		this.storeDisplayColumns();
	},
	methods: {
		listStoreHouse,
		storeDisplayColumns() {
			if (localStorage.getItem('detail-columns') === 'null' || !localStorage.getItem('detail-columns')) {
				localStorage.setItem('detail-columns', JSON.stringify(this.columns));
			} else {
				this.columns = JSON.parse(localStorage.getItem('detail-columns'));
			}
		},
		fetchStore() {
			listStoreHouse().then(res => {
				this.storeList = res.rows.map(item => {
					return {
						label: item.storeHouseName,
						id: item.id,
						children: []
					};
				});
			});
		},
		// 左侧树的点击
		handleNodeClick(data) {
			this.loading = true;
			listDetail({
				params: {
					main_storeHouseid: data.id
				}
			}).then(res => {
				this.detailList = res.rows;
				this.loading = false;
			});
		},
		/** 查询库存子列表 */
		getList() {
			this.loading = true;
			listDetail(this.queryParams).then(response => {
				this.detailList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				mainId: null,
				stockNumber: null,
				supplier: null,
				supplierId: null,
				levelID: null,
				levelName: null,
				countingUnit: null,
				height: null,
				length: null,
				width: null,
				pieces: null,
				piecesPerPack: null,
				packs: null,
				price: null,
				isIncludeTaxFactory: null,
				sundryCost: null,
				paymentFactory: null,
				paymentUnload: null,
				isIncludeTaxSale: null,
				payments: null,
				erro: null,
				tonnage: null,
				landFreightPrice: null,
				landFreight: null,
				seaFreight: null,
				freight: null,
				otherCost: null,
				profit: null,
				profitNoTax: null,
				actualPieces: null,
				paymentsWithSundry: null,
				additionalFees: null,
				rebate: null,
				factoryCommission: null,
				comments: null,
				exWareHoustId: null,
				delFlag: null
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
			this.resetForm('queryForm');
			this.handleQuery();
		},
		// 多选框选中数据
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加库存子';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getDetail(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改库存子';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						updateDetail(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addDetail(this.form).then(() => {
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
				.confirm('是否确认删除库存子编号为"' + ids + '"的数据项？')
				.then(function () {
					return delDetail(ids);
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
				'system/inventoryDetail/export',
				{
					...this.queryParams
				},
				`detail_${new Date().getTime()}.xlsx`
			);
		},
		secondryInventoryOut(row) {
			this.secondInfo = {
				ordersNo: '二次加工',
				storeHouseid: row.storeHouseid,
				storeHouseName: row.storeHouseName,
				storeID: row.id,
				outDate: parseTime(new Date())
			};
			this.secondInvoiceInVisible = true;
		},
		submitSecondInvoiceIn() {
			this.secondInfo.outAmount = this.secondNumber;
			addExWarehouse(this.secondInfo).then(() => {
				this.$message.success('加工后出库成功~');
				this.secondInvoiceInVisible = false;
				this.getList();
			});
		},
		afterbreakInventoryOut(row) {
			this.breakInfo = {
				ordersNo: '货物破损',
				storeHouseid: row.storeHouseid,
				storeHouseName: row.storeHouseName,
				storeID: row.id,
				outDate: parseTime(new Date())
			};
			this.breakInvoiceInVisible = true;
		},
		submitBreakInvoiceIn() {
			this.breakInfo.outAmount = this.breakNumber;
			addExWarehouse(this.breakInfo).then(() => {
				this.$message.success('货物破损出库成功~');
				this.breakInvoiceInVisible = false;
				this.getList();
			});
		}
	}
};
</script>

<style scoped>
/* 提高 el-table 横向滚动条的高度 */
::v-deep .el-table__body-wrapper::-webkit-scrollbar {
	height: 16px; /* 默认是6px，改为16px更高 */
}
::v-deep .el-table__body-wrapper::-webkit-scrollbar-thumb {
	border-radius: 2px;
	background: #848383;
}
::v-deep .el-table__body-wrapper::-webkit-scrollbar-track {
	background: #e3e2e2;
}
</style>
