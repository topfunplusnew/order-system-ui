<template>
	<div class="app-container">
		<el-form
			v-show="showSearch"
			ref="queryForm"
			:model="queryParams"
			size="mini"
			:inline="true"
			label-width="68px"
		>
			<el-form-item label="主加油卡卡号" prop="oilMainCardNo">
				<el-input
					v-model="queryParams.oilMainCardNo"
					placeholder="请输入主加油卡卡号"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="副加油卡卡号" prop="oilSecondCardNo">
				<el-input
					v-model="queryParams.oilSecondCardNo"
					placeholder="请输入副加油卡卡号"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="充值时间" prop="rechargeDate">
				<el-date-picker
					v-model="queryParams.rechargeDate"
					type="datetime"
					placeholder="选择充值时间"
					value-format="yyyy-MM-dd HH:mm:ss"
				></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="mini"
					@click="handleQuery"
				>
					搜索
				</el-button>
			</el-form-item>
		</el-form>
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button
					v-hasPermi="['system:oilcardfundtransfer:add']"
					type="primary"
					plain
					icon="el-icon-plus"
					size="mini"
					@click="handleAdd"
				>
					新增加油卡圈存信息
				</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">
					重置
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
						></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button
							v-hasPermi="['system:oilcardfundtransfer:export']"
							plain
							icon="el-icon-folder-opened"
							size="mini"
							@click="handleExport"
						></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="oilCardFundTransferList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column
				v-if="columns[0].visible"
				label="id"
				align="center"
				prop="id"
			/>
			<el-table-column
				v-if="columns[1].visible"
				label="主加油卡卡号"
				align="center"
				prop="oilMainCardNo"
			/>
			<el-table-column
				v-if="columns[2].visible"
				label="副加油卡卡号"
				align="center"
				prop="oilSecondCardNo"
			/>
			<el-table-column
				v-if="columns[3].visible"
				label="充值金额"
				align="center"
				prop="rechargeMoney"
			/>
			<el-table-column
				v-if="columns[4].visible"
				label="充值时间"
				align="center"
				prop="rechargeDate"
			/>
			<el-table-column
				v-if="columns[5].visible"
				label="充值人员姓名"
				align="center"
				prop="rechargeName"
			/>
			<el-table-column
				v-if="columns[6].visible"
				label="备注"
				align="center"
				prop="comments"
			/>
			<el-table-column
				label="操作"
				align="center"
				class-name="small-padding fixed-width"
			>
				<template slot-scope="scope">
					<el-button
						v-hasPermi="['system:oilcardfundtransfer:edit']"
						size="mini"
						type="primary"
						@click="handleUpdate(scope.row)"
					>
						修改
					</el-button>
					<el-button
						v-hasPermi="['system:oilcardfundtransfer:remove']"
						size="mini"
						type="danger"
						@click="handleDelete(scope.row)"
					>
						删除
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

		<!-- 添加或修改加油卡圈存对话框 -->
		<el-dialog
			:close-on-click-modal="false"
			:show-close="false"
			:title="title"
			:visible.sync="open"
			width="500px"
			append-to-body
		>
			<el-form ref="form" :model="form" :rules="rules" label-width="120px">
				<el-form-item label="主加油卡卡号" prop="oilMainCardNo">
					<el-row>
						<el-col :span="10">
							<el-input
								disabled
								v-model="form.oilMainCardNo"
								placeholder="请选择"
							/>
						</el-col>
						<el-col :span="4">
							<SearchOption
								:get-data="listOilCard"
								query-info="oilCardNo"
								:query-name="queryOilCard"
								query-label="油卡账号查询"
								:limit-info="{ oilType: '主卡' }"
								@commitBack="handleCommitBackOilCard"
								@update:queryName="handleCommitBackQueryOilCard"
							>
								<template #table-columns>
									<el-table-column
										label="加油卡卡号"
										align="center"
										prop="oilCardNo"
									/>
									<el-table-column
										label="当前金额"
										align="center"
										prop="moneyAmount"
									/>
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="副加油卡卡号" prop="oilSecondCardNo">
					<el-row>
						<el-col :span="10">
							<el-input
								disabled
								v-model="form.oilSecondCardNo"
								placeholder="请选择"
							/>
						</el-col>
						<el-col :span="4">
							<SearchOption
								:get-data="listOilCard"
								query-info="oilCardNo"
								:query-name="queryOilCardOther"
								query-label="油卡账号查询"
								:limit-info="{ oilType: '副卡' }"
								@commitBack="handleCommitBackOilCardOther"
								@update:queryName="handleCommitBackQueryOilCardOther"
							>
								<template #table-columns>
									<el-table-column
										label="加油卡卡号"
										align="center"
										prop="oilCardNo"
									/>
									<el-table-column
										label="当前金额"
										align="center"
										prop="moneyAmount"
									/>
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="充值金额" prop="rechargeMoney">
					<el-input v-model="form.rechargeMoney" placeholder="请输入充值金额" />
				</el-form-item>
				<!--        <el-form-item label="充值人员姓名" prop="rechargeName">-->
				<!--          <el-input v-model="form.rechargeName" placeholder="请输入充值人员姓名"/>-->
				<!--        </el-form-item>-->
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
import {
	listOilCardFundTransfer,
	getOilCardFundTransfer,
	delOilCardFundTransfer,
	addOilCardFundTransfer,
	updateOilCardFundTransfer
} from '@/api/system/oilCardFundTransfer';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import SearchOption from '@/components/SearchOption.vue';
import { listOilCard } from '@/api/system/oilCard';
import { excludeParams } from '@/api/tool/exclude';
import { parseTime } from '../../../utils/ruoyi';

export default {
	name: 'OilCardFundTransfer',
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
			// 加油卡圈存表格数据
			oilCardFundTransferList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				oilMainCardNo: null,
				oilSecondCardNo: null,
				rechargeMoney: null,
				rechargeDate: null,
				rechargeName: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			// 表单参数
			form: {
				rechargeDate: new Date().getTime()
			},
			// 表单校验
			rules: {
				oilMainCardNo: [
					{ required: true, message: '请输入主加油卡卡号', trigger: 'blur' }
				],
				oilSecondCardNo: [
					{ required: true, message: '请输入副加油卡卡号', trigger: 'blur' }
				],
				rechargeMoney: [
					{ required: true, message: '请输入充值金额', trigger: 'blur' },
					// 金额校验
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('请输入正确的金额'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `id`, visible: true },
				{ key: 1, label: `主加油卡卡号`, visible: true },
				{ key: 2, label: `副加油卡卡号`, visible: true },
				{ key: 3, label: `充值金额`, visible: true },
				{ key: 4, label: `充值时间`, visible: true },
				{ key: 5, label: `充值人员姓名`, visible: true },
				{ key: 6, label: `备注`, visible: true }
			],

			queryOilCard: '',
			queryOilCardOther: ''
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem(
					'oilcardfundtransfer-columns',
					JSON.stringify(newVal)
				);
			},
			deep: true
		}
	},
	created() {
		this.getList();
		if (
			localStorage.getItem('oilcardfundtransfer-columns') === 'null' ||
			!localStorage.getItem('oilcardfundtransfer-columns')
		) {
			// 设置localStorage
			localStorage.setItem(
				'oilcardfundtransfer-columns',
				JSON.stringify(this.columns)
			);
		} else {
			this.columns = JSON.parse(
				localStorage.getItem('oilcardfundtransfer-columns')
			);
		}
	},
	methods: {
		listOilCard,
		// 主卡
		handleCommitBackOilCard(val) {
			this.form.oilMainCardNo = val.oilCardNo;
		},
		handleCommitBackQueryOilCard(val) {
			this.queryOilCard = val;
		},
		// 副卡
		handleCommitBackOilCardOther(val) {
			this.form.oilSecondCardNo = val.oilCardNo;
		},
		handleCommitBackQueryOilCardOther(val) {
			this.queryOilCardOther = val;
		},
		/** 查询加油卡圈存列表 */
		getList() {
			this.loading = true;
			listOilCardFundTransfer(this.queryParams).then(response => {
				this.oilCardFundTransferList = response.rows;
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
				oilMainCardNo: null,
				oilSecondCardNo: null,
				rechargeMoney: null,
				rechargeDate: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
				rechargeName: null,
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
			this.title = '添加加油卡圈存';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getOilCardFundTransfer(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改加油卡圈存';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						updateOilCardFundTransfer(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form = excludeParams(this.form, this.$exclude);
						addOilCardFundTransfer(this.form).then(() => {
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
				.confirm('是否确认删除加油卡圈存编号为"' + ids + '"的数据项？')
				.then(function () {
					return delOilCardFundTransfer(ids);
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
				'system/oilCardFundTransfer/export',
				{
					...this.queryParams
				},
				`oilCardFundTransfer_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
