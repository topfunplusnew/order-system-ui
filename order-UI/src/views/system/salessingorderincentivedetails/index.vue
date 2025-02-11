<template>
	<div class="app-container">
		<el-form
			v-show="showSearch"
			ref="queryForm"
			:model="queryParams"
			size="small"
			:inline="true"
			label-width="68px"
		>
			<el-form-item label="订单编号" prop="orderNo">
				<el-input
					v-model="queryParams.orderNo"
					placeholder="请输入订单编号"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="订单日期">
				<el-date-picker
					v-model="daterangeOrderDate"
					style="width: 240px"
					value-format="yyyy-MM-dd HH:mm:ss"
					type="daterange"
					range-separator="-"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
				></el-date-picker>
			</el-form-item>
			<el-form-item label="接受奖励人员" prop="rewardReceiver">
				<el-input
					v-model="queryParams.rewardReceiver"
					placeholder="请输入接受奖励人员"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="奖励日期">
				<el-date-picker
					v-model="daterangeRewardDate"
					style="width: 240px"
					value-format="yyyy-MM-dd HH:mm:ss"
					type="daterange"
					range-separator="-"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
				></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="mini"
					@click="handleQuery"
					>搜索</el-button
				>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery"
					>重置</el-button
				>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button
					v-hasPermi="['system:salessingorderincentivedetails:add']"
					type="primary"
					plain
					icon="el-icon-plus"
					size="mini"
					@click="handleAdd"
					>新增
				</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button
					v-hasPermi="['system:salessingorderincentivedetails:edit']"
					type="success"
					plain
					icon="el-icon-edit"
					size="mini"
					:disabled="single"
					@click="handleUpdate"
					>修改
				</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button
					v-hasPermi="['system:salessingorderincentivedetails:remove']"
					type="danger"
					plain
					icon="el-icon-delete"
					size="mini"
					:disabled="multiple"
					@click="handleDelete"
					>删除
				</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button
					v-hasPermi="['system:salessingorderincentivedetails:export']"
					type="warning"
					plain
					icon="el-icon-download"
					size="mini"
					@click="handleExport"
					>导出
				</el-button>
			</el-col>
			<right-toolbar
				:showSearch.sync="showSearch"
				:columns="columns"
				@queryTable="getList"
			>
				<template #print>
					<el-col :span="1.5">
						<el-button
							plain
							icon="el-icon-printer"
							size="mini"
							@click="printHTML"
						>
						</el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button
							v-hasPermi="['system:adjustOrders:export']"
							plain
							icon="el-icon-folder-opened"
							size="mini"
							@click="handleExport"
						>
						</el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			v-loading="loading"
			v-horizontal-scroll="'always'"
			:data="salessingorderincentivedetailsList"
			border
			size="mini"
			:cell-style="
				() => {
					return { padding: '1px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column type="selection" width="55" align="center" />

			<el-table-column
				v-if="columns[0].visible"
				label="id"
				align="center"
				prop="id"
			/>

			<el-table-column
				v-if="columns[1].visible"
				label="订单日期"
				align="center"
				prop="orderDate"
				width="180"
				show-overflow-tooltip
			>
				<template #default="scope">
					<span>{{
						parseTime(scope.row.orderDate, '{y}-{m}-{d} {h}:{i}:{s}')
					}}</span>
				</template>
			</el-table-column>

			<el-table-column
				v-if="columns[2].visible"
				label="接受奖励人员"
				align="center"
				prop="rewardReceiver"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[3].visible"
				label="订单不含税利润"
				align="center"
				prop="orderProfit"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[4].visible"
				label="厂家返利"
				align="center"
				prop="manufacturerRebate"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[5].visible"
				label="佣金"
				align="center"
				prop="customerCommission"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[6].visible"
				label="综合单车利润"
				align="center"
				prop="comprehensiveProfit"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[7].visible"
				label="奖励金额"
				align="center"
				prop="rewardAmount"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[8].visible"
				label="奖励日期"
				align="center"
				prop="rewardDate"
				width="180"
				show-overflow-tooltip
			>
				<template #default="scope">
					<span>{{
						parseTime(scope.row.rewardDate, '{y}-{m}-{d} {h}:{i}:{s}')
					}}</span>
				</template>
			</el-table-column>

			<el-table-column
				v-if="columns[9].visible"
				label="备注"
				align="center"
				prop="remark"
				show-overflow-tooltip
			/>

			<el-table-column
				label="操作"
				align="center"
				class-name="small-padding fixed-width"
			>
				<template #default="scope">
					<el-button
						v-hasPermi="['system:salessingorderincentivedetails:edit']"
						size="mini"
						type="text"
						icon="el-icon-edit"
						@click="handleUpdate(scope.row)"
						>修改
					</el-button>
					<el-button
						v-hasPermi="['system:salessingorderincentivedetails:remove']"
						size="mini"
						type="text"
						icon="el-icon-delete"
						@click="handleDelete(scope.row)"
						>删除
					</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination
			v-show="total > 0"
			:total="total"
			:page.sync="queryParams.pageNum"
			:limit.sync="queryParams.pageSize"
			@pagination="getList"
		/>

		<!-- 添加或修改唱单制对话框 -->
		<el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="150px">
				<el-row>
					<el-col :span="12">
						<el-form-item label="订单">
							<!--        子组件 填充订单信息 包含日期 录入员(UserName) 客户名称 不含税利润 -->
							<Incent @update:orderInfo="handleFillOrderInfo" />
						</el-form-item>
						<el-form-item label="订单日期" prop="orderDate">
							<el-date-picker
								v-model="form.orderDate"
								clearable
								type="datetime"
								value-format="yyyy-MM-dd HH:mm:ss"
								placeholder="请选择订单日期"
							>
							</el-date-picker>
						</el-form-item>
						<el-form-item label="录入员" prop="rewardReceiver">
							<el-input
								v-model="form.rewardReceiver"
								placeholder="请输入录入员"
							/>
						</el-form-item>
						<el-form-item label="客户名称" prop="companyName">
							<el-input
								v-model="form.companyName"
								placeholder="请输入客户名称"
							/>
						</el-form-item>
						<el-form-item label="订单不含税利润" prop="orderProfit">
							<el-input
								v-model="form.orderProfit"
								placeholder="请输入订单不含税利润"
							/>
						</el-form-item>
						<el-form-item label="厂家返利" prop="manufacturerRebate">
							<el-input
								v-model="form.manufacturerRebate"
								placeholder="请输入厂家返利"
							/>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="佣金" prop="customerCommission">
							<el-input
								v-model="form.customerCommission"
								placeholder="请输入佣金"
							/>
						</el-form-item>
						<el-form-item label="综合单车利润" prop="comprehensiveProfit">
							<el-input
								v-model="form.comprehensiveProfit"
								placeholder="请输入综合单车利润"
								disabled
							/>
						</el-form-item>
						<el-form-item label="奖励金额" prop="rewardAmount">
							<el-input
								v-model="form.rewardAmount"
								placeholder="请输入奖励金额"
							/>
						</el-form-item>
						<el-form-item label="奖励日期" prop="rewardDate">
							<el-date-picker
								v-model="form.rewardDate"
								clearable
								type="datetime"
								value-format="yyyy-MM-dd HH:mm:ss"
								placeholder="请选择奖励日期"
							>
							</el-date-picker>
						</el-form-item>
						<el-form-item label="备注" prop="remark">
							<el-input
								v-model="form.remark"
								type="textarea"
								placeholder="请输入内容"
							/>
						</el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import {
	listSalessingorderincentivedetails,
	getSalessingorderincentivedetails,
	delSalessingorderincentivedetails,
	addSalessingorderincentivedetails,
	updateSalessingorderincentivedetails
} from '@/api/system/salessingorderincentivedetails';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { mixin_sing_order_fill } from './saleorder_fill';
import Incent from '../../dashboard/components/incent/Incent.vue';
import { parseTime } from '../../../utils/ruoyi';

export default {
	name: 'Salessingorderincentivedetails',
	components: { Incent },
	mixins: [mixin_printHTML, mixin_sing_order_fill],
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
			// 唱单制表格数据
			salessingorderincentivedetailsList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 备注时间范围
			daterangeOrderDate: [],
			// 备注时间范围
			daterangeRewardDate: [],
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				orderNo: null,
				orderDate: null,
				rewardReceiver: null,
				rewardDate: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				orderDate: [
					{ required: true, message: '请选择订单日期', trigger: 'blur' }
				],
				rewardReceiver: [
					{ required: true, message: '请输入接受奖励人员', trigger: 'blur' }
				],
				companyName: [
					{ required: true, message: '请输入客户名称', trigger: 'blur' }
				],
				orderProfit: [
					{ required: true, message: '请输入订单不含税利润', trigger: 'blur' }
				],
				manufacturerRebate: [
					{ required: true, message: '请输入厂家返利', trigger: 'blur' }
				],
				customerCommission: [
					{ required: true, message: '请输入佣金', trigger: 'blur' }
				],
				comprehensiveProfit: [
					{ required: true, message: '请输入综合单车利润', trigger: 'blur' }
				],
				rewardAmount: [
					{ required: true, message: '请输入奖励金额', trigger: 'blur' }
				],
				rewardDate: [
					{ required: true, message: '请选择奖励日期', trigger: 'blur' }
				]
			},
			columns: [
				{ key: 0, label: `id`, visible: true },
				{ key: 1, label: `订单日期`, visible: true },
				{ key: 2, label: `接受奖励人员`, visible: true },
				{ key: 3, label: `订单不含税利润`, visible: true },
				{ key: 4, label: `厂家返利`, visible: true },
				{ key: 5, label: `佣金`, visible: true },
				{ key: 6, label: `综合单车利润`, visible: true },
				{ key: 7, label: `奖励金额`, visible: true },
				{ key: 8, label: `奖励日期`, visible: true },
				{ key: 9, label: `备注`, visible: true }
			]
		};
	},
	watch: {
		form: {
			handler(newName, oldName) {
				this.form.comprehensiveProfit =
					Number(this.form.orderProfit) +
					Number(this.form.manufacturerRebate) -
					Number(this.form.customerCommission);
			},
			deep: true
		}
	},
	created() {
		this.getList();
	},
	methods: {
		parseTime,
		/** 查询唱单制列表 */
		getList() {
			this.loading = true;
			this.queryParams.params = {};
			if (this.daterangeOrderDate != null && this.daterangeOrderDate != '') {
				this.queryParams.params['beginOrderDate'] = this.daterangeOrderDate[0];
				this.queryParams.params['endOrderDate'] = this.daterangeOrderDate[1];
			}
			if (this.daterangeRewardDate != null && this.daterangeRewardDate != '') {
				this.queryParams.params['beginRewardDate'] =
					this.daterangeRewardDate[0];
				this.queryParams.params['endRewardDate'] = this.daterangeRewardDate[1];
			}
			listSalessingorderincentivedetails(this.queryParams).then(response => {
				this.salessingorderincentivedetailsList = response.rows;
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
				orderNo: null,
				orderDate: null,
				rewardReceiver: null,
				customerId: null,
				customerType: null,
				orderProfit: null,
				manufacturerRebate: null,
				customerCommission: null,
				comprehensiveProfit: null,
				rewardAmount: null,
				rewardDate: null,
				delFlag: null,
				updateTime: null,
				updateBy: null,
				createTime: null,
				createBy: null,
				remark: null
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
			this.daterangeOrderDate = [];
			this.daterangeRewardDate = [];
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
			this.title = '添加唱单制';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getSalessingorderincentivedetails(id).then(response => {
				this.form = response.data;
				this.form.profitStandardMet = response.data.profitStandardMet + '';
				this.open = true;
				this.title = '修改唱单制';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						updateSalessingorderincentivedetails(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						addSalessingorderincentivedetails(this.form).then(response => {
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
				.confirm('是否确认删除唱单制编号为"' + ids + '"的数据项？')
				.then(function () {
					return delSalessingorderincentivedetails(ids);
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
				'system/salesstepincentivedetails/export',
				{
					...this.queryParams
				},
				`salessingorderincentivedetails_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
