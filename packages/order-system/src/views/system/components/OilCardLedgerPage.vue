<!-- 用户需求：创建主卡登记与副卡登记页面并完成油卡登记台账全部前端功能。实际改动：新增共享列表、查询、表单、下拉、增删改和导出组件，并按卡类型控制字段与请求。 -->
<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="110px">
			<el-form-item label="加油卡卡号" prop="oilCardNo">
				<el-input v-model="queryParams.oilCardNo" placeholder="请输入加油卡卡号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="车辆车牌号" prop="licensePlate">
				<el-input v-model="queryParams.licensePlate" placeholder="请输入车辆车牌号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="使用时间">
				<el-date-picker v-model="dateRange" type="daterange" value-format="yyyy-MM-dd" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" style="width: 240px" />
			</el-form-item>
			<el-form-item label="是否有小票" prop="hasReceipt">
				<el-select v-model="queryParams.hasReceipt" placeholder="请选择" clearable style="width: 120px">
					<el-option label="是" value="是" />
					<el-option label="否" value="否" />
				</el-select>
			</el-form-item>
			<el-form-item label="地点、事由" prop="locationReason">
				<el-input v-model="queryParams.locationReason" placeholder="请输入地点、事由" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button v-hasPermi="[permission('add')]" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="[permission('edit')]" type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate()">修改</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="[permission('remove')]" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete()">删除</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" :tableName="tableName" @queryTable="getList">
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="[permission('export')]" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table id="printBox" v-loading="loading" v-horizontal-scroll="'always'" border size="mini" :data="ledgerList" @selection-change="handleSelectionChange">
			<el-table-column type="selection" width="45" align="center" />
			<el-table-column v-for="column in visibleColumns" :key="column.prop" :label="column.label" :prop="column.prop" :min-width="column.minWidth" align="center" show-overflow-tooltip>
				<template slot-scope="scope">
					<span>{{ getCellValue(scope.row, column) }}</span>
				</template>
			</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="130">
				<template slot-scope="scope">
					<el-button v-hasPermi="[permission('edit')]" size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="[permission('remove')]" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="900px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" size="mini" label-width="180px" @submit.native.prevent="submitForm">
				<el-row :gutter="20">
					<el-col :span="12">
						<el-form-item label="加油卡卡号" prop="oilCardId">
							<el-select v-model="form.oilCardId" filterable placeholder="请选择加油卡" style="width: 100%">
								<el-option v-for="item in oilCardOptions" :key="item.id" :label="item.oilCardNo" :value="item.id" />
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="使用加油卡时间" prop="useDate">
							<el-date-picker v-model="form.useDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择使用时间" style="width: 100%" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="使用车辆" prop="vehicleId">
							<el-select v-model="form.vehicleId" filterable clearable placeholder="请选择车辆，可不选" style="width: 100%">
								<el-option v-for="item in vehicleOptions" :key="item.id" :label="item.licensePlate" :value="item.id" />
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="是否有小票" prop="hasReceipt">
							<el-select v-model="form.hasReceipt" clearable placeholder="请选择" style="width: 100%">
								<el-option label="是" value="是" />
								<el-option label="否" value="否" />
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="24">
						<el-form-item label="地点、事由" prop="locationReason">
							<el-input v-model="form.locationReason" maxlength="255" show-word-limit placeholder="请输入地点、事由" />
						</el-form-item>
					</el-col>
					<el-col v-if="cardType === '主卡'" :span="12">
						<el-form-item label="充值金额" prop="rechargeAmount"><el-input-number v-model="form.rechargeAmount" :min="0" :precision="2" controls-position="right" style="width: 100%" /></el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="期初余额" prop="openingBalance"><el-input-number v-model="form.openingBalance" :min="0" :precision="2" controls-position="right" style="width: 100%" /></el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item :label="transferAmountLabel" prop="transferAmount"><el-input-number v-model="form.transferAmount" :min="0" :precision="2" controls-position="right" style="width: 100%" /></el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="加油量（升）" prop="refuelingVolume"><el-input-number v-model="form.refuelingVolume" :min="0" :precision="2" controls-position="right" style="width: 100%" /></el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="单价" prop="unitPrice"><el-input-number v-model="form.unitPrice" :min="0" :precision="2" controls-position="right" style="width: 100%" /></el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item :label="refuelingAmountLabel" prop="refuelingAmount"><el-input-number v-model="form.refuelingAmount" :min="0" :precision="2" controls-position="right" style="width: 100%" /></el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="加油卡余额" prop="closingBalance"><el-input-number v-model="form.closingBalance" :min="0" :precision="2" controls-position="right" style="width: 100%" /></el-form-item>
					</el-col>
					<el-col :span="24">
						<el-form-item label="备注" prop="comments"><el-input v-model="form.comments" type="textarea" :rows="3" maxlength="500" show-word-limit placeholder="请输入备注" /></el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" :loading="submitting" @click="submitForm">确 定</el-button>
				<el-button :disabled="submitting" @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { addOilCardLedger, delOilCardLedger, getOilCardLedger, listOilCardLedger, updateOilCardLedger } from '@/api/system/oilCardLedger';
import { listOilCard } from '@/api/system/oilCard';
import { listVehicles } from '@/api/system/vehicles';
import { buildLedgerColumns, buildLedgerExportParams, buildLedgerPayload, buildLedgerQuery, getLedgerCellValue, serializeLedgerIds } from './oilCardLedger.config';

const createForm = () => ({
	id: undefined,
	oilCardId: undefined,
	useDate: undefined,
	vehicleId: null,
	locationReason: undefined,
	rechargeAmount: undefined,
	openingBalance: undefined,
	transferAmount: undefined,
	refuelingVolume: undefined,
	unitPrice: undefined,
	refuelingAmount: undefined,
	hasReceipt: undefined,
	closingBalance: undefined,
	comments: undefined
});

export default {
	name: 'OilCardLedgerPage',
	props: {
		cardType: { type: String, required: true },
		pageTitle: { type: String, required: true },
		permissionPrefix: { type: String, required: true },
		tableName: { type: String, required: true }
	},
	data() {
		return {
			loading: false,
			submitting: false,
			showSearch: true,
			total: 0,
			ledgerList: [],
			ids: [],
			single: true,
			multiple: true,
			dateRange: [],
			oilCardOptions: [],
			vehicleOptions: [],
			columns: buildLedgerColumns(this.cardType).map((column, index) => ({ ...column, key: index, visible: true })),
			open: false,
			title: '',
			form: createForm(),
			queryParams: { pageNum: 1, pageSize: 20, oilCardNo: undefined, licensePlate: undefined, hasReceipt: undefined, locationReason: undefined },
			rules: {
				oilCardId: [{ required: true, message: '请选择加油卡', trigger: 'change' }],
				useDate: [{ required: true, message: '请选择使用加油卡时间', trigger: 'change' }],
				locationReason: [{ max: 255, message: '地点、事由不能超过255个字符', trigger: 'blur' }],
				comments: [{ max: 500, message: '备注不能超过500个字符', trigger: 'blur' }]
			}
		};
	},
	computed: {
		visibleColumns() {
			return this.columns.filter(column => column.visible);
		},
		transferAmountLabel() {
			return this.cardType === '主卡' ? '主卡转副卡充值金额' : '主卡转副卡圈存金额';
		},
		refuelingAmountLabel() {
			return this.cardType === '主卡' ? '金额(元）' : '加油金额(元）';
		}
	},
	created() {
		this.getList();
	},
	methods: {
		permission(action) {
			return `${this.permissionPrefix}:${action}`;
		},
		getCellValue(row, column) {
			const value = getLedgerCellValue(row, column);
			return value === null || value === undefined ? '' : value;
		},
		getList() {
			this.loading = true;
			listOilCardLedger(buildLedgerQuery(this.queryParams, this.cardType, this.dateRange))
				.then(response => {
					this.ledgerList = response.rows || [];
					this.total = response.total || 0;
				})
				.finally(() => {
					this.loading = false;
				});
		},
		loadOptions() {
			return Promise.all([listOilCard({ oilType: this.cardType, pageNum: 1, pageSize: 1000 }), listVehicles({ pageNum: 1, pageSize: 1000 })]).then(([oilCardResponse, vehicleResponse]) => {
				this.oilCardOptions = oilCardResponse.rows || [];
				this.vehicleOptions = vehicleResponse.rows || [];
			});
		},
		resetFormData() {
			this.form = createForm();
			if (this.$refs.form) this.$refs.form.resetFields();
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.dateRange = [];
			this.$refs.queryForm.resetFields();
			this.handleQuery();
		},
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = selection.length === 0;
		},
		handleAdd() {
			this.resetFormData();
			this.title = `新增${this.pageTitle}`;
			this.loadOptions().then(() => {
				this.open = true;
			});
		},
		handleUpdate(row) {
			const id = row ? row.id : this.ids[0];
			this.resetFormData();
			Promise.all([this.loadOptions(), getOilCardLedger(id)]).then(([, response]) => {
				this.form = { ...createForm(), ...(response.data || response) };
				this.title = `修改${this.pageTitle}`;
				this.open = true;
			});
		},
		cancel() {
			this.open = false;
			this.resetFormData();
		},
		submitForm() {
			this.$refs.form.validate(valid => {
				if (!valid || this.submitting) return;
				this.submitting = true;
				const payload = buildLedgerPayload(this.form, this.cardType, Boolean(this.form.id));
				const request = this.form.id ? updateOilCardLedger(payload) : addOilCardLedger(payload);
				request
					.then(() => {
						this.msgSuccess(this.form.id ? '修改成功' : '新增成功');
						this.open = false;
						this.getList();
					})
					.finally(() => {
						this.submitting = false;
					});
			});
		},
		handleDelete(row) {
			const ids = row ? [row.id] : this.ids;
			this.$confirm(`是否确认删除选中的${this.pageTitle}记录？`, '提示', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' })
				.then(() => delOilCardLedger(serializeLedgerIds(ids)))
				.then(() => {
					this.msgSuccess('删除成功');
					this.getList();
				})
				.catch(() => {});
		},
		handleExport() {
			const exportParams = buildLedgerExportParams(this.queryParams, this.cardType, this.dateRange);
			this.download('/system/oilCardLedger/export', exportParams, `${this.pageTitle}_${new Date().getTime()}.xlsx`);
		}
	}
};
</script>
