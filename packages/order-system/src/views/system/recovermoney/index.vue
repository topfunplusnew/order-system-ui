<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd HH:mm:ss" type="daterange" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
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
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:recovermoney:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="recoverMoneyList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column v-if="columns[0].visible" label="收回金额" align="center" prop="moneyAmount" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.moneyAmount }}</div>
						<span>{{ scope.row.moneyAmount }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" label="收回日期" align="center" prop="recoverDate" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.recoverDate }}</div>
						<span>{{ scope.row.recoverDate }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[2].visible" label="收回账户" align="center" prop="acountsName" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.acountsName }}</div>
						<span>{{ scope.row.acountsName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[3].visible" label="收回账号" align="center" prop="bankNo" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.bankNo }}</div>
						<span>{{ scope.row.bankNo }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[4].visible" label="备注" align="center" prop="comments" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<div slot="content">{{ scope.row.comments }}</div>
						<span>{{ scope.row.comments }}</span>
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
				<template slot-scope="scope">
					<el-button size="mini" type="primary" @click="handleUpdateRecoverMoney(scope.row)" v-hasPermi="['system:recovermoney:edit']">修改</el-button>
					<el-button v-hasPermi="['system:recovermoney:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改借出款收回信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="80px">
				<!-- 收回款编码（只读，仅编辑时展示） -->
				<el-form-item v-if="form && form.id != null" label="收回款编码">
					<el-input v-model="form.code" disabled />
				</el-form-item>
				<el-form-item label="借出款编号" prop="futuresNO">
					<el-input v-model="form.futuresNO" placeholder="请输入借出款编号" />
				</el-form-item>
				<el-form-item label="还款编号" prop="recoverNO">
					<el-input v-model="form.recoverNO" placeholder="请输入还款编号" />
				</el-form-item>
				<el-form-item label="收回金额" prop="moneyAmount">
					<el-input v-model="form.moneyAmount" placeholder="请输入收回金额" />
				</el-form-item>
				<el-form-item label="收回日期" prop="recoverDate">
					<el-input v-model="form.recoverDate" placeholder="请输入收回日期" />
				</el-form-item>
				<el-form-item label="收回账户" prop="acountsName">
					<el-input v-model="form.acountsName" placeholder="请输入收回账户" />
				</el-form-item>
				<el-form-item label="收回账号" prop="bankNo">
					<el-input v-model="form.bankNo" placeholder="请输入收回账号" />
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
	</div>
</template>

<script>
import { listRecoverMoney, getRecoverMoney, delRecoverMoney, addRecoverMoney, updateRecoverMoney } from '@/api/system/recoverMoney';
import { mapGetters } from 'vuex';
import { addDateRange } from '@/utils/ruoyi';
import { addReason } from '@/api/system/user';
import { TableName } from '@/api/tool/enums';
import { excludeParams } from '@/api/tool/exclude';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';

export default {
	name: 'RecoverMoney',
	components: {},
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
			// 借出款收回信息表格数据
			recoverMoneyList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			dateRange: [],
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				futuresNO: null,
				recoverNO: null,
				moneyAmount: null,
				recoverDate: null,
				acountsName: null,
				bankNo: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			// 表单参数
			form: {},
			columns: [
				/* {key: 0, label: `借出款编号`, visible: true},
         {key: 1, label: `还款编号`, visible: true},*/
				{ key: 0, label: `收回金额`, visible: true },
				{ key: 1, label: `收回日期`, visible: true },
				{ key: 2, label: `收回账户`, visible: true },
				{ key: 3, label: `收回账号`, visible: true },
				{ key: 4, label: `备注`, visible: true }
			],
			// 表单校验
			rules: {}
		};
	},
	created() {
		this.getList();
		if (localStorage.getItem('recovermoney-columns') === 'null' || !localStorage.getItem('recovermoney-columns')) {
			// 设置localStorage
			localStorage.setItem('recovermoney-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('recovermoney-columns'));
		}
		this.$store.dispatch('money/getTempRecoverMoneyList');
	},
	computed: {
		...mapGetters(['tempRecoverMoneyList'])
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('recovermoney-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	methods: {
		/** 查询借出款收回信息列表 */
		getList() {
			this.loading = true;
			listRecoverMoney(addDateRange(this.queryParams, this.dateRange)).then(response => {
				this.recoverMoneyList = response.rows;
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
				futuresNO: null,
				recoverNO: null,
				moneyAmount: null,
				recoverDate: null,
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
			this.title = '添加借出款收回信息';
		},
		/* /!** 修改按钮操作 *!/
    handleUpdateRecoverMoney(row) {
      this.reset();
      const id = row.id || this.ids
      getRecoverMoney(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改借出款收回信息";
      });
    },*/
		/** 修改按钮操作 */
		handleUpdateRecoverMoney(row) {
			// this.$prompt('请输入编辑原因', '提示', {
			// 	confirmButtonText: '确定',
			// 	cancelButtonText: '取消',
			// 	type: 'warning'
			// })
			// 	.then(({ value }) => {
			// 		addReason({
			// 			reason: value,
			// 			tableName: TableName.RECOVER_MONEY,
			// 			tid: row.id,
			// 			modifyTime: this.modifyTime
			// 		}).then(res => {
			// 			this.$message.success('提交成功');
			// 			this.reset();
			// 			const id = row.id || this.ids;
			// 			getRecoverMoney(id).then(response => {
			// 				this.form = response.data;
			// 				this.open = true;
			// 				this.title = '修改借出款收回信息';
			// 			});
			// 		});
			// 	})
			// 	.catch(() => {
			// 		this.$message({
			// 			type: 'warning',
			// 			message: '请先输入编辑原因!'
			// 		});
			// 	});

			this.reset();
			const id = row.id || this.ids;
			getRecoverMoney(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改借出款收回信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						updateRecoverMoney(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form = excludeParams(this.form, this.$exclude);
						addRecoverMoney(this.form).then(response => {
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
				.confirm('是否确认删除借出款收回信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delRecoverMoney(ids);
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
				'system/recoverMoney/export',
				{
					...this.queryParams
				},
				`收回款_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
