<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="加油卡卡号" prop="oilCardNo">
				<el-input v-model="queryParams.oilCardNo" placeholder="请输入加油卡卡号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="使用加油卡时间" prop="useDate">
				<el-input v-model="queryParams.useDate" placeholder="请输入使用加油卡时间" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="使用加油卡车辆车牌号" prop="carNo">
				<el-input v-model="queryParams.carNo" placeholder="请输入使用加油卡车辆车牌号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="地点、事由" prop="destination">
				<el-input v-model="queryParams.destination" placeholder="请输入地点、事由" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="期初余额" prop="startCardSurplus">
				<el-input v-model="queryParams.startCardSurplus" placeholder="请输入期初余额" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="主卡转副卡充值金额" prop="toPlusCardMoney">
				<el-input v-model="queryParams.toPlusCardMoney" placeholder="请输入主卡转副卡充值金额" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="加油量" prop="refuelingNumber">
				<el-input v-model="queryParams.refuelingNumber" placeholder="请输入加油量" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="单价" prop="unitPrice">
				<el-input v-model="queryParams.unitPrice" placeholder="请输入单价" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="加油金额(元）" prop="refuelingMoney">
				<el-input v-model="queryParams.refuelingMoney" placeholder="请输入加油金额(元）" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="充值金额" prop="rechargeMoney">
				<el-input v-model="queryParams.rechargeMoney" placeholder="请输入充值金额" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="是否有小票" prop="isTicket">
				<el-input v-model="queryParams.isTicket" placeholder="请输入是否有小票" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="加油卡余额" prop="endCardSurplus">
				<el-input v-model="queryParams.endCardSurplus" placeholder="请输入加油卡余额" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="备注" prop="comments">
				<el-input v-model="queryParams.comments" placeholder="请输入备注" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="添加时间" prop="addtime">
				<el-input v-model="queryParams.addtime" placeholder="请输入添加时间" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="操作人员ID" prop="userId">
				<el-input v-model="queryParams.userId" placeholder="请输入操作人员ID" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="操作人员姓名" prop="UserName">
				<el-input v-model="queryParams.UserName" placeholder="请输入操作人员姓名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="删除标记" prop="delFlag">
				<el-input v-model="queryParams.delFlag" placeholder="请输入删除标记" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:oilcardmain:add']" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:oilcardmain:edit']" type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate">修改</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:oilcardmain:remove']" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">删除</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:oilcardmain:export']" type="warning" plain icon="el-icon-download" size="mini" @click="handleExport">导出</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
		</el-row>

		<el-table v-loading="loading" :data="oilcardmainList" @selection-change="handleSelectionChange">
			<el-table-column type="selection" width="55" align="center" />
			<el-table-column label="id" align="center" prop="id" />
			<el-table-column label="加油卡卡号" align="center" prop="oilCardNo" />
			<el-table-column label="使用加油卡时间" align="center" prop="useDate" />
			<el-table-column label="使用加油卡车辆车牌号" align="center" prop="carNo" />
			<el-table-column label="地点、事由" align="center" prop="destination" />
			<el-table-column label="期初余额" align="center" prop="startCardSurplus" />
			<el-table-column label="主卡转副卡充值金额" align="center" prop="toPlusCardMoney" />
			<el-table-column label="加油量" align="center" prop="refuelingNumber" />
			<el-table-column label="单价" align="center" prop="unitPrice" />
			<el-table-column label="加油金额(元）" align="center" prop="refuelingMoney" />
			<el-table-column label="充值金额" align="center" prop="rechargeMoney" />
			<el-table-column label="是否有小票" align="center" prop="isTicket" />
			<el-table-column label="加油卡余额" align="center" prop="endCardSurplus" />
			<el-table-column label="备注" align="center" prop="comments" />
			<el-table-column label="添加时间" align="center" prop="addtime" />
			<el-table-column label="操作人员ID" align="center" prop="userId" />
			<el-table-column label="操作人员姓名" align="center" prop="UserName" />
			<el-table-column label="删除标记" align="center" prop="delFlag" />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:oilcardmain:edit']" size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:oilcardmain:remove']" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改基础信息-加油卡主卡登记对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<el-form-item label="加油卡卡号" prop="oilCardNo">
					<el-input v-model="form.oilCardNo" placeholder="请输入加油卡卡号" />
				</el-form-item>
				<el-form-item label="使用加油卡时间" prop="useDate">
					<el-input v-model="form.useDate" placeholder="请输入使用加油卡时间" />
				</el-form-item>
				<el-form-item label="使用加油卡车辆车牌号" prop="carNo">
					<el-input v-model="form.carNo" placeholder="请输入使用加油卡车辆车牌号" />
				</el-form-item>
				<el-form-item label="地点、事由" prop="destination">
					<el-input v-model="form.destination" placeholder="请输入地点、事由" />
				</el-form-item>
				<el-form-item label="期初余额" prop="startCardSurplus">
					<el-input v-model="form.startCardSurplus" placeholder="请输入期初余额" />
				</el-form-item>
				<el-form-item label="主卡转副卡充值金额" prop="toPlusCardMoney">
					<el-input v-model="form.toPlusCardMoney" placeholder="请输入主卡转副卡充值金额" />
				</el-form-item>
				<el-form-item label="加油量" prop="refuelingNumber">
					<el-input v-model="form.refuelingNumber" placeholder="请输入加油量" />
				</el-form-item>
				<el-form-item label="单价" prop="unitPrice">
					<el-input v-model="form.unitPrice" placeholder="请输入单价" />
				</el-form-item>
				<el-form-item label="加油金额(元）" prop="refuelingMoney">
					<el-input v-model="form.refuelingMoney" placeholder="请输入加油金额(元）" />
				</el-form-item>
				<el-form-item label="充值金额" prop="rechargeMoney">
					<el-input v-model="form.rechargeMoney" placeholder="请输入充值金额" />
				</el-form-item>
				<el-form-item label="是否有小票" prop="isTicket">
					<el-input v-model="form.isTicket" placeholder="请输入是否有小票" />
				</el-form-item>
				<el-form-item label="加油卡余额" prop="endCardSurplus">
					<el-input v-model="form.endCardSurplus" placeholder="请输入加油卡余额" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
				<el-form-item label="添加时间" prop="addtime">
					<el-input v-model="form.addtime" placeholder="请输入添加时间" />
				</el-form-item>
				<el-form-item label="操作人员ID" prop="userId">
					<el-input v-model="form.userId" placeholder="请输入操作人员ID" />
				</el-form-item>
				<el-form-item label="操作人员姓名" prop="UserName">
					<el-input v-model="form.UserName" placeholder="请输入操作人员姓名" />
				</el-form-item>
				<el-form-item label="删除标记" prop="delFlag">
					<el-input v-model="form.delFlag" placeholder="请输入删除标记" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { listOilcardmain, getOilcardmain, delOilcardmain, addOilcardmain, updateOilcardmain } from '@/api/system/oilcardmain';

export default {
	name: 'Oilcardmain',
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
			// 基础信息-加油卡主卡登记表格数据
			oilcardmainList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				oilCardNo: null,
				useDate: null,
				carNo: null,
				destination: null,
				startCardSurplus: null,
				toPlusCardMoney: null,
				refuelingNumber: null,
				unitPrice: null,
				refuelingMoney: null,
				rechargeMoney: null,
				isTicket: null,
				endCardSurplus: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {}
		};
	},
	created() {
		this.getList();
	},
	methods: {
		/** 查询基础信息-加油卡主卡登记列表 */
		getList() {
			this.loading = true;
			listOilcardmain(this.queryParams).then(response => {
				this.oilcardmainList = response.rows;
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
				oilCardNo: null,
				useDate: null,
				carNo: null,
				destination: null,
				startCardSurplus: null,
				toPlusCardMoney: null,
				refuelingNumber: null,
				unitPrice: null,
				refuelingMoney: null,
				rechargeMoney: null,
				isTicket: null,
				endCardSurplus: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
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
			this.title = '添加基础信息-加油卡主卡登记';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getOilcardmain(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改基础信息-加油卡主卡登记';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						updateOilcardmain(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addOilcardmain(this.form).then(response => {
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
				.confirm('是否确认删除基础信息-加油卡主卡登记编号为"' + ids + '"的数据项？')
				.then(function () {
					return delOilcardmain(ids);
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
				'system/oilcardmain/export',
				{
					...this.queryParams
				},
				`oilcardmain_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
