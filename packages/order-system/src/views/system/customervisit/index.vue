<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="客户" prop="customer">
				<el-input v-model="queryParams.customer" placeholder="请输入客户姓名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="区域" prop="region">
				<el-input v-model="queryParams.region" placeholder="请输入区域" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<!--      <el-form-item label="省" prop="province">-->
			<!--        &lt;!&ndash;          <el-input v-model="form.province" placeholder="请输入省"/ @keyup.enter.native="handleQuery">&ndash;&gt;-->
			<!--        <el-select v-model="queryParams.province" placeholder="请选择省" @change="changeProvince" @keyup.enter.native="handleQuery">-->
			<!--          <el-option-->
			<!--            v-for="item in provinceList"-->
			<!--            :key="item.code"-->
			<!--            :label="item.name"-->
			<!--            :value="item.name">-->
			<!--          </el-option>-->
			<!--        </el-select>-->
			<!--      </el-form-item>-->
			<!--      <el-form-item label="市县" prop="city">-->
			<!--        &lt;!&ndash;          <el-input v-model="form.city" placeholder="请输入市县"/ @keyup.enter.native="handleQuery">&ndash;&gt;-->
			<!--        <el-select v-model="queryParams.city" placeholder="请选择市" @change="changeCity" @keyup.enter.native="handleQuery">-->
			<!--          <el-option-->
			<!--            v-for="item in cityList"-->
			<!--            :key="item.code"-->
			<!--            :label="item.name"-->
			<!--            :value="item.name">-->
			<!--          </el-option>-->
			<!--        </el-select>-->
			<!--      </el-form-item>-->
			<!--      <el-form-item label="乡镇" prop="county">-->
			<!--        <el-input v-model="queryParams.county" placeholder="请输入乡镇"/ @keyup.enter.native="handleQuery">-->
			<!--      </el-form-item>-->
			<el-form-item label="业务经理" prop="UserName">
				<el-input v-model="queryParams.UserName" placeholder="请输入业务经理" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="走访日期">
				<el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd HH:mm:ss" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>

			<!--      <el-form-item>-->
			<!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>-->
			<!--      </el-form-item>-->
		</el-form>

		<el-row :gutter="10" class="mb8">
			<!-- 刷新按钮-->
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:customervisit:add']" type="danger" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增走访记录</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList" tableName="customervisit-columns">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:customervisit:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="CustomerVisitList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column label="id" align="center" prop="id" fixed="left" show-overflow-tooltip />
			<el-table-column label="走访日期" align="center" prop="visitDate" fixed="left" show-overflow-tooltip />
			<el-table-column align="center" prop="userName" fixed="left" show-overflow-tooltip width="120px">
				<template #header>
					<span>业务经理</span>
					<el-tooltip content="该列取值为行信息的录入人员" placement="top">
						<i class="el-icon-question" style="margin-left: 4px; cursor: pointer; color: #909399"></i>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[0].visible" label="是否审核" align="center" prop="isCheckState" fixed="left" show-overflow-tooltip width="120px">
				<template #default="scope">
					<el-row v-if="scope.row.checkState === 1">
						<el-tag type="success">已审核</el-tag>
						<el-button v-hasPermi="['system:customervisit:audit']" type="text" size="mini" @click="handleReCheck(scope.row)">取消审核</el-button>
					</el-row>
					<el-row v-else>
						<el-button v-hasPermi="['system:customervisit:audit']" type="text" size="mini" @click="handleCheck(scope.row)">审核</el-button>
					</el-row>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" label="客户名称" align="center" prop="customer" fixed="left" show-overflow-tooltip width="150px" />
			<el-table-column v-if="columns[2].visible" label="负责人姓名" align="center" prop="leaderName" width="150px" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="负责人电话" align="center" prop="LeaderTel" width="150px" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="厂房设备" align="center" prop="equipment" width="150px" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="竞争对手" align="center" prop="competitor" width="150px" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="当地经销商" align="center" prop="localDealer" width="150px" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="月用货量" align="center" prop="monthlyConsumption" show-overflow-tooltip width="150px" />
			<el-table-column v-if="columns[8].visible" label="白玻用货习惯及厂家" align="center" prop="whiteGlassFactory" width="200px" show-overflow-tooltip />
			<el-table-column v-if="columns[9].visible" label="lowe玻璃用货厂家及用量" align="center" prop="loweGlassConsumption" width="300px" show-overflow-tooltip />
			<el-table-column v-if="columns[10].visible" label="色玻、过度色玻璃用货厂家及用量" align="center" prop="colorGlassConsumption" width="300px" show-overflow-tooltip />
			<el-table-column v-if="columns[11].visible" label="特色厚度、特殊尺寸、协议品用货厂家及用量" align="center" prop="specialGlassConsumption" width="300px" show-overflow-tooltip />
			<el-table-column v-if="columns[12].visible" label="备注" align="center" prop="comments" show-overflow-tooltip width="180px" />

			<el-table-column v-if="columns[13].visible" label="省" align="center" prop="province" show-overflow-tooltip width="180px" />
			<el-table-column v-if="columns[14].visible" label="市" align="center" prop="city" show-overflow-tooltip width="180px" />
			<el-table-column v-if="columns[15].visible" label="乡镇" align="center" prop="county" show-overflow-tooltip width="180px" />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="130px">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:customervisit:edit']" size="mini" type="primary" :disabled="scope.row.checkState === 1" @click="handleUpdate(scope.row)">编辑</el-button>
					<el-button v-hasPermi="['system:customervisit:remove']" size="mini" type="danger" :disabled="scope.row.checkState === 1" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改走访记录对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="70%" append-to-body fullscreen>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-col :span="8">
					<el-form-item label="走访日期" prop="visitDate">
						<el-date-picker v-model="form.visitDate" type="datetime" placeholder="选择走访日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
					</el-form-item>
					<el-form-item label="省" prop="province">
						<el-select v-model="form.province" filterable placeholder="请选择省" @change="changeProvince">
							<el-option v-for="item in provinceList" :key="item.code" :label="item.name" :value="item.name"></el-option>
						</el-select>
					</el-form-item>
					<el-form-item label="市县" prop="city">
						<!--          <el-input v-model="form.city" placeholder="请输入市县"/>-->
						<el-select v-model="form.city" filterable placeholder="请选择市" @change="changeCity">
							<el-option v-for="item in cityList" :key="item.code" :label="item.name" :value="item.name"></el-option>
						</el-select>
					</el-form-item>
					<el-form-item label="乡镇" prop="county">
						<el-input v-model="form.county" placeholder="请输入乡镇" />
					</el-form-item>
					<el-form-item label="客户名称" prop="customer">
						<el-input v-model="form.customer" placeholder="请输入客户名称" />
					</el-form-item>
					<el-form-item label="负责人" prop="leaderName">
						<el-input v-model="form.leaderName" type="textarea" placeholder="请输入内容" />
					</el-form-item>
					<el-form-item label="负责人电话" prop="LeaderTel">
						<el-input v-model="form.LeaderTel" type="textarea" placeholder="请输入内容" />
					</el-form-item>
					<el-form-item label="厂房设备" prop="equipment">
						<el-input v-model="form.equipment" placeholder="请输入厂房设备" type="textarea" />
					</el-form-item>
				</el-col>
				<el-col :span="8">
					<el-form-item label="竞争对手" prop="competitor">
						<el-input v-model="form.competitor" placeholder="请输入竞争对手" type="textarea" />
					</el-form-item>
					<el-form-item label="当地经销商" prop="localDealer">
						<el-input v-model="form.localDealer" placeholder="请输入当地经销商" type="textarea" />
					</el-form-item>
					<el-form-item label="月用货量" prop="monthlyConsumption">
						<el-input v-model="form.monthlyConsumption" placeholder="请输入月用货量" type="textarea" />
					</el-form-item>
					<el-form-item label="白玻用货习惯及厂家" prop="whiteGlassFactory">
						<el-input v-model="form.whiteGlassFactory" placeholder="请输入白玻用货习惯及厂家" type="textarea" />
					</el-form-item>
					<el-form-item label="lowe玻璃用货厂家及用量" prop="loweGlassConsumption">
						<el-input v-model="form.loweGlassConsumption" placeholder="请输入lowe玻璃用货厂家及用量" type="textarea" />
					</el-form-item>
				</el-col>
				<el-col :span="8">
					<el-form-item label="色玻、过度色玻璃用货厂家及用量" prop="colorGlassConsumption">
						<el-input v-model="form.colorGlassConsumption" placeholder="请输入色玻、过度色玻璃用货厂家及用量" type="textarea" />
					</el-form-item>
					<el-form-item label="特色厚度、特殊尺寸、协议品用货厂家及用量" prop="specialGlassConsumption">
						<el-input v-model="form.specialGlassConsumption" placeholder="请输入特色厚度、特殊尺寸、协议品用货厂家及用量" type="textarea" />
					</el-form-item>
					<el-form-item label="备注" prop="comments">
						<el-input v-model="form.comments" placeholder="请输入备注" type="textarea" />
					</el-form-item>
					<!--          <el-form-item label="提交时间" prop="submittime">-->
					<!--            <el-input v-model="form.submittime" placeholder="请输入添加时间"/>-->
					<!--          </el-form-item>-->
				</el-col>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { listCustomerVisit, getCustomerVisit, delCustomerVisit, addCustomerVisit, updateCustomerVisit, auditCustomerVisit } from '@/api/system/CustomerVisit';
import { excludeParams } from '@/api/tool/exclude';

export default {
	name: 'CustomerVisit',
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
			// 走访记录表格数据
			CustomerVisitList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			dateRange: [],
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				province: null,
				city: null,
				county: null,
				customer: null,
				leaderName: null,
				LeaderTel: null,
				equipment: null,
				competitor: null,
				localDealer: null,
				monthlyConsumption: null,
				whiteGlassFactory: null,
				loweGlassConsumption: null,
				colorGlassConsumption: null,
				specialGlassConsumption: null,
				comments: null,
				submittime: null,
				userId: null,
				UserName: null,
				visitDate: null,
				checkState: null,
				checkUserID: null,
				checkUserName: null,
				delFlag: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				visitDate: [
					{
						required: true,
						message: '请选择走访日期',
						trigger: 'blur'
					}
				],
				province: [{ required: true, message: '请选择省', trigger: 'blur' }],
				city: [{ required: true, message: '请选择市', trigger: 'blur' }],
				county: [{ required: true, message: '请输入乡镇', trigger: 'blur' }],
				customer: [
					{
						required: true,
						message: '请输入客户名称',
						trigger: 'blur'
					}
				],
				leaderName: [
					{
						required: true,
						message: '请输入负责人姓名',
						trigger: 'blur'
					}
				],
				LeaderTel: [
					{
						required: true,
						message: '请输入负责人电话',
						trigger: 'blur'
					}
				],
				equipment: [
					{
						required: true,
						message: '请输入厂房设备',
						trigger: 'blur'
					}
				],
				competitor: [
					{
						required: true,
						message: '请输入竞争对手',
						trigger: 'blur'
					}
				],
				localDealer: [
					{
						required: true,
						message: '请输入当地经销商',
						trigger: 'blur'
					}
				],
				monthlyConsumption: [
					{
						required: true,
						message: '请输入月用货量',
						trigger: 'blur'
					}
				],
				whiteGlassFactory: [
					{
						required: true,
						message: '请输入白玻用货习惯及厂家',
						trigger: 'blur'
					}
				],
				loweGlassConsumption: [
					{
						required: true,
						message: '请输入lowe玻璃用货厂家及用量',
						trigger: 'blur'
					}
				],
				colorGlassConsumption: [
					{
						required: true,
						message: '请输入色玻、过度色玻璃用货厂家及用量',
						trigger: 'blur'
					}
				],
				specialGlassConsumption: [
					{
						required: true,
						message: '请输入特色厚度、特殊尺寸、协议品用货厂家及用量',
						trigger: 'blur'
					}
				],
				comments: [{ required: true, message: '请输入备注', trigger: 'blur' }]
			},
			columns: [
				{ key: 0, label: `是否审核`, visible: true },
				/* {key: 1, label: `人员`, visible: true},
         {key: 2, label: `区域`, visible: true},*/
				{ key: 1, label: `客户名称`, visible: true },
				{ key: 2, label: `负责人姓名`, visible: true },
				{ key: 3, label: `负责人电话`, visible: true },
				{ key: 4, label: `厂房设备`, visible: true },
				{ key: 5, label: `竞争对手`, visible: true },
				{ key: 6, label: `当地经销商`, visible: true },
				{ key: 7, label: `月用货量`, visible: true },
				{ key: 8, label: `白玻用货习惯及厂家`, visible: true },
				{ key: 9, label: `lowe玻璃用货厂家及用量`, visible: true },
				{
					key: 10,
					label: `色玻、过度色玻璃用货厂家及用量`,
					visible: true
				},
				{
					key: 11,
					label: `特色厚度、特殊尺寸、协议品用货厂家及用量`,
					visible: true
				},
				{ key: 12, label: `备注`, visible: true },
				/* {key: 15, label: `提交时间`, visible: true},*/
				{ key: 13, label: `省`, visible: true },
				{ key: 14, label: `市`, visible: true },
				{ key: 15, label: `乡镇`, visible: true }
			],
			// 省市县
			provinceList: [],
			cityList: [],
			districtList: [],
			province: '',
			city: '',
			district: ''
		};
	},
	// 展示与隐藏
	watch: {
		form: {
			handler: function (newVal) {
				console.log(newVal);
			},
			deep: true
		},
		// 城市变化
		'queryParams.province': function (val) {
			this.provinceList.forEach(item => {
				if (item.name === val) {
					this.cityList = item.areaList;
				}
			});
		},
		'queryParams.city': function (val) {
			this.cityList.forEach(item => {
				if (item.name === val) {
					this.districtList = item.areaList;
				}
			});
		},
		// 城市变化
		'form.province': function (val) {
			this.provinceList.forEach(item => {
				if (item.name === val) {
					this.cityList = item.areaList;
				}
			});
		},
		'form.city': function (val) {
			this.cityList.forEach(item => {
				if (item.name === val) {
					this.districtList = item.areaList;
				}
			});
		}
	},

	created() {
		// 获取城市信息
		fetch('/area.json')
			.then(res => res.json())
			.then(res => {
				this.provinceList = res;
			});
		this.getList();
	},
	methods: {
		// 城市变化
		changeProvince(e) {
			this.province = e;
		},
		changeCity(e) {
			this.city = e;
		},
		changeDis(e) {
			this.district = e;
		},
		/** 走访记录审核 */
		handleCheck(row) {
			this.$antdconfirm({
				title: '提示',
				content: '是否审核该信息?',
				okText: '确定',
				cancelText: '取消',
				type: 'warning',
				zIndex: 2600,
				onOk: async () => {
					try {
						await auditCustomerVisit({ id: row.id, isaudit: true });
						this.$message.success('操作成功~!');
						this.getList();
					} catch {
						this.$message.error('审核失败，请重试');
					}
				},
				onCancel: () => {
					this.$message.info('已取消审核操作');
				}
			});
		},
		/** 取消审核，传递 isaudit 为 false */
		handleReCheck(row) {
			this.$antdconfirm({
				title: '提示',
				content: '是否取消审核该信息?',
				okText: '确定',
				cancelText: '取消',
				type: 'warning',
				zIndex: 2600,
				onOk: async () => {
					try {
						await auditCustomerVisit({ id: row.id, isaudit: false });
						this.$message.success('取消审核成功');
						this.getList();
					} catch {
						this.$message.error('取消审核失败，请重试');
					}
				},
				onCancel: () => {
					this.$message.info('已取消操作');
				}
			});
		},
		getList() {
			this.loading = true;
			// 范围时间搜索方法
			listCustomerVisit(this.addDateRange(this.queryParams, this.dateRange, 'visit', this.queryParams.region)).then(response => {
				this.CustomerVisitList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
		},
		// 打印按钮操作
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				province: null,
				city: null,
				county: null,
				customer: null,
				leaderName: null,
				LeaderTel: null,
				equipment: null,
				competitor: null,
				localDealer: null,
				monthlyConsumption: null,
				whiteGlassFactory: null,
				loweGlassConsumption: null,
				colorGlassConsumption: null,
				specialGlassConsumption: null,
				comments: null,
				submittime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				visitDate: null,
				checkState: null,
				checkUserID: null,
				checkUserName: null,
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
			this.title = '添加走访记录';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getCustomerVisit(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改走访记录';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						updateCustomerVisit(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form = excludeParams(this.form, this.$exclude);
						addCustomerVisit(this.form).then(response => {
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
				.confirm('是否确认删除走访记录编号为"' + ids + '"的数据项？')
				.then(function () {
					return delCustomerVisit(ids);
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
				'system/CustomerVisit/export',
				{
					...this.queryParams
				},
				`走访记录_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
