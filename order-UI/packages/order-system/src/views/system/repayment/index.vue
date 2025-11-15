<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="开始时间" prop="startTime">
				<el-date-picker v-model="queryParams.startTime" type="datetime" placeholder="请选择开始时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item label="结束时间" prop="endTIme">
				<el-date-picker v-model="queryParams.endTime" type="datetime" placeholder="请选择结束时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQueryTime">搜索</el-button>
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
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:repayment:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="repaymentList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
		<el-table-column v-if="columns[0].visible" label="还款金额" align="center" prop="moneyAmount" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.moneyAmount }}</div>
					<span>{{ scope.row.moneyAmount }}</span>
				</el-tooltip>
			</template>
		</el-table-column>
		<el-table-column v-if="columns[1].visible" label="付息" align="center" prop="ratio" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.ratio }}</div>
					<span>{{ scope.row.ratio }}</span>
				</el-tooltip>
			</template>
		</el-table-column>
		<el-table-column v-if="columns[2].visible" label="还款日期" align="center" prop="payDate" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.payDate }}</div>
					<span>{{ scope.row.payDate }}</span>
				</el-tooltip>
			</template>
		</el-table-column>
		<el-table-column v-if="columns[3].visible" label="还款账户" align="center" prop="acountsName" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.acountsName }}</div>
					<span>{{ scope.row.acountsName }}</span>
				</el-tooltip>
			</template>
		</el-table-column>
		<el-table-column v-if="columns[4].visible" label="还款账号" align="center" prop="bankNo" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.bankNo }}</div>
					<span>{{ scope.row.bankNo }}</span>
				</el-tooltip>
			</template>
		</el-table-column>
		<el-table-column label="备注" align="center" prop="comments" show-overflow-tooltip>
			<template #default="scope">
				<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
					<div slot="content">{{ scope.row.comments }}</div>
					<span>{{ scope.row.comments }}</span>
				</el-tooltip>
			</template>
		</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding">
				<template slot-scope="scope">
					<el-button v-if="scope.row.checkState === '未申请'" size="mini" type="warning" @click="applyForPayment(scope.row)">申请付款</el-button>
					<el-button v-if="scope.row.checkState === '审核中'" size="mini" type="warning" disabled>审核中</el-button>
					<el-button v-hasPermi="['system:repayment:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改贷款还款信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<!-- 还款编码（只读，仅编辑时展示） -->
				<el-form-item v-if="form && form.id != null" label="还款编码">
					<el-input v-model="form.code" disabled />
				</el-form-item>
				<el-form-item label="贷款编号" prop="loanNO">
					<el-input v-model="form.loanNO" placeholder="请输入贷款编号" />
				</el-form-item>
				<el-form-item label="还款编号" prop="payNO">
					<el-input v-model="form.payNO" placeholder="请输入还款编号" />
				</el-form-item>
				<el-form-item label="还" prop="moneyAmount">
					<el-input v-model="form.moneyAmount" placeholder="请输入还" />
				</el-form-item>
				<el-form-item label="付息" prop="ratio">
					<el-input v-model="form.ratio" placeholder="请输入付息" />
				</el-form-item>
				<el-form-item label="还款日期" prop="payDate">
					<el-input v-model="form.payDate" placeholder="请输入还款日期" />
				</el-form-item>
				<el-form-item label="还款账户" prop="acountsName">
					<el-input v-model="form.acountsName" placeholder="请输入还款账户" />
				</el-form-item>
				<el-form-item label="还款账号" prop="bankNo">
					<el-input v-model="form.bankNo" placeholder="请输入还款账号" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
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
			title="付款申请"
			:visible.sync="PaymentApplyInfoVisible"
			width="45%"
		>
			<keep-alive>
				<ApplyPayment :table-name="TableName.REPAYMENT" :t-i-d="tID" :need-money="needMoney" :need-info="{}" @changeOpen="changePaymentApplyInfoVisible" />
			</keep-alive>
		</el-dialog>
	</div>
</template>

<script>
import { listRepayment, getRepayment, delRepayment, addRepayment, updateRepayment } from '@/api/system/repayment';
import { mapGetters } from 'vuex';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import { TableName } from '@/api/tool/enums';

export default {
	name: 'Repayment',
	components: { ApplyPayment },
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
			// 贷款还款信息表格数据
			repaymentList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				loanNO: null,
				payNO: null,
				moneyAmount: null,
				ratio: null,
				payDate: null,
				acountsName: null,
				bankNo: null,
				comments: null,
				startTime: null,
				endTime: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {},
			columns: [
				{ key: 2, label: `还款金额`, visible: true },
				{ key: 3, label: `付息`, visible: true },
				{ key: 4, label: `还款日期`, visible: true },
				{ key: 5, label: `还款账户`, visible: true },
				{ key: 6, label: `还款账号`, visible: true }
			],
			options: [
				{
					label: 'test',
					value: 'test'
				}
			],
			tID: '',
			needMoney: 0,
			PaymentApplyInfoVisible: false
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('repayment-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('repayment-columns') === 'null' || !localStorage.getItem('repayment-columns')) {
			// 设置localStorage
			localStorage.setItem('repayment-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('repayment-columns'));
		}
		this.$store.dispatch('money/getRepaymentList');
	},
	computed: {
		TableName() {
			return TableName;
		},
		...mapGetters(['tempRepaymentList'])
	},
	methods: {
		applyForPayment(row) {
			this.tID = row.id;
			this.PaymentApplyInfoVisible = true;
			this.needMoney = row.moneyAmount;
		},
		changePaymentApplyInfoVisible() {
			this.needMoney = 0;
			this.PaymentApplyInfoVisible = false;
			this.getList();
		},
		// 时间查询
		handleQueryTime() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
		},
		/** 查询贷款还款信息列表 */
		getList() {
			this.loading = true;
			listRepayment(this.queryParams).then(response => {
				this.repaymentList = response.rows;
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
				code: null,
				id: null,
				loanNO: null,
				payNO: null,
				moneyAmount: null,
				ratio: null,
				payDate: null,
				acountsName: null,
				bankNo: null,
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
			this.title = '添加贷款还款信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getRepayment(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改贷款还款信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form.delFlag = null;
						this.form.addtime = null;
						this.form.updateTime = null;
						this.form.userId = null;
						updateRepayment(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form.delFlag = null;
						this.form.addtime = null;
						this.form.updateTime = null;
						this.form.userId = null;
						addRepayment(this.form).then(() => {
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
				.confirm('是否确认删除贷款还款信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delRepayment(ids);
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
				'system/repayment/export',
				{
					...this.queryParams
				},
				`repayment_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
