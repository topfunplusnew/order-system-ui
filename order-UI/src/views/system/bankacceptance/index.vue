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
			<el-form-item label="开始时间" prop="issueDateStart">
				<el-date-picker
					v-model="queryParams.issueDateStart"
					type="datetime"
					placeholder="选择日期"
					value-format="yyyy-MM-dd HH:mm:ss"
				></el-date-picker>
			</el-form-item>
			<el-form-item label="结束时间" prop="issueDateEnd">
				<el-date-picker
					v-model="queryParams.issueDateEnd"
					type="datetime"
					placeholder="选择日期"
					value-format="yyyy-MM-dd HH:mm:ss"
				></el-date-picker>
			</el-form-item>
			<el-form-item label="票据号码" prop="billNo">
				<el-input
					v-model="queryParams.billNo"
					placeholder="请输入票据号码"
					@keyup.enter.native="handleQuery"
				/>
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
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">
					刷新
				</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button
					v-hasPermi="['system:bankacceptance:add']"
					type="danger"
					size="mini"
					@click="handleAdd"
				>
					添加收入商业票据
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
							v-hasPermi="['system:bankacceptance:export']"
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
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="bankAcceptanceList"
			show-summary
			id="printBox"
			:summary-method="getSummaries"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			height="480px"
			@selection-change="handleSelectionChange"
		>
			<el-table-column
				v-if="columns[0].visible"
				label="操作日期"
				align="center"
				prop="operateDate"
				width="120"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[1].visible"
				label="票据种类"
				align="center"
				prop="billCategory"
				width="120"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[2].visible"
				label="票据号码"
				align="center"
				prop="billNo"
				width="120"
				show-overflow-tooltip
			>
				<!--        点击后出来一个台账-->
				<template #default="scope">
					<CheckTotal :row="scope.row" />
				</template>
			</el-table-column>
			<el-table-column
				v-if="columns[3].visible"
				label="出票日期"
				align="center"
				prop="issueDate"
				width="120"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[4].visible"
				label="到期日期"
				align="center"
				prop="dueDate"
				width="120"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[5].visible"
				label="我方承兑账户"
				align="center"
				prop="billAccount"
				width="120"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[6].visible"
				label="票据交易日期"
				align="center"
				prop="billDate"
				width="120"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[7].visible"
				label="背书事由"
				align="center"
				prop="reason"
				width="120"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[8].visible"
				label="背书人"
				align="center"
				prop="endorserName"
				width="120"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[9].visible"
				label="票据金额"
				align="center"
				prop="billAmount"
				width="120"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[10].visible"
				label="贴息点数"
				align="center"
				prop="inDiscountPoints"
				width="120"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[11].visible"
				label="贴息金额"
				align="center"
				prop="inDiscountAmount"
				width="120"
				show-overflow-tooltip
			/>
			<el-table-column
				v-if="columns[12].visible"
				label="来源"
				align="center"
				prop="origin"
				width="120"
				show-overflow-tooltip
			/>
			<el-table-column
				label="备注"
				align="center"
				prop="comments"
				show-overflow-tooltip
			/>

			<el-table-column
				label="操作"
				align="center"
				class-name="small-padding fixed-width"
				width="150px"
				fixed="right"
			>
				<template slot-scope="scope">
					<el-button
						v-hasPermi="['system:bankacceptance:edit']"
						size="mini"
						type="primary"
						@click="handleUpdate(scope.row)"
					>
						修改
					</el-button>
					<el-button
						v-hasPermi="['system:bankacceptance:remove']"
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

		<!-- 添加或修改商业票据、银行承兑对话框 -->
		<el-dialog
			:close-on-click-modal="false"
			:show-close="false"
			:title="title"
			:visible.sync="open"
			width="800px"
			append-to-body
		>
			<el-form ref="form" :model="form" :rules="rules" label-width="140px">
				<el-row>
					<el-col :span="12">
						<el-form-item label="票据号码" prop="billNo">
							<el-input v-model="form.billNo" placeholder="请输入票据号码" />
						</el-form-item>
						<el-form-item label="收票事由" prop="reason">
							<el-radio v-model="form.reason" label="购买">购买</el-radio>
							<el-radio v-model="form.reason" label="客户付款">
								客户付款
							</el-radio>
						</el-form-item>
						<el-form-item label="背书人类型" prop="reason">
							<el-radio v-model="type" label="客户">客户</el-radio>
							<el-radio v-model="type" label="供应商"> 供应商</el-radio>
						</el-form-item>
						<el-form-item label="背书人" prop="endorserName">
							<el-row>
								<el-col :span="20">
									<!--                  v-model="form.endorser"-->
									<el-input
										disabled
										placeholder="请输入背书人"
										v-model="form.endorserName"
									/>
								</el-col>
								<el-col :span="4">
									<!-- 选择的是客户或者供应商名称-->
									<SearchOption
										:limit-info="{ companyType: type }"
										:get-data="listCompany"
										query-info="companyName"
										query-label="公司名称"
										:query-name="companyName"
										@update:queryName="handleUpdateCompanyName"
										@commitBack="handleCommitBackCompany"
									>
										<template #table-columns>
											<el-table-column
												:label="type"
												align="center"
												prop="companyName"
											/>
											<el-table-column
												label="老板姓名"
												align="center"
												prop="leader"
											/>
											<el-table-column
												label="老板电话"
												align="center"
												prop="leaderTel"
											/>
											<el-table-column
												label="区域"
												align="center"
												prop="region"
											/>
											<el-table-column
												label="销售经理"
												align="center"
												prop="salesManager"
											/>
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="收入票据金额" prop="billAmount">
							<el-input
								v-model="form.billAmount"
								placeholder="请输入票据金额"
							/>
						</el-form-item>
						<el-form-item label="收入贴息点数" prop="inDiscountPoints">
							<el-input
								v-model="form.inDiscountPoints"
								placeholder="请输入贴息点数"
							/>
						</el-form-item>
						<el-form-item label="收入贴息金额" prop="inDiscountAmount">
							<el-input
								disabled
								v-model="form.inDiscountAmount"
								placeholder="请输入贴息金额"
							/>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="票据种类" prop="billCategory">
							<el-radio v-model="form.billCategory" label="电子">电子</el-radio>
							<el-radio v-model="form.billCategory" label="纸质">纸质</el-radio>
						</el-form-item>
						<el-form-item label="我方承兑账户" prop="billAccount">
							<el-row>
								<el-col :span="20">
									<el-input
										disabled
										v-model="form.billAccount"
										placeholder="请输入我方承兑账户"
									/>
								</el-col>
								<el-col :span="4">
									<SearchOption
										:get-data="listBankAccount"
										:limit-info="{ accountType: '己方公司' }"
										title="我方承兑账户"
										query-label="户名查找"
										query-info="acountsName"
										:query-name="queryBank"
										@commitBack="handleCommitBack"
										@update:queryName="handleUpdateQueryName"
									>
										<template #table-columns>
											<el-table-column
												label="显示名称"
												align="center"
												prop="displayName"
											/>
											<el-table-column
												label="开户名称(户名)"
												align="center"
												prop="acountsName"
											/>
											<el-table-column
												label="账号(银行账号)"
												align="center"
												prop="bankNo"
											/>
											<el-table-column
												label="开户行"
												align="center"
												prop="bankName"
											/>
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="我方收票日期" prop="billDate">
							<el-date-picker
								v-model="form.billDate"
								type="datetime"
								placeholder="选择日期"
								format="yyyy 年 MM 月 dd 日"
								value-format="yyyy-MM-dd HH:mm:ss"
							></el-date-picker>
						</el-form-item>
						<el-form-item label="出票日期" prop="issueDate">
							<el-date-picker
								v-model="form.issueDate"
								type="datetime"
								placeholder="选择日期"
								format="yyyy 年 MM 月 dd 日"
								value-format="yyyy-MM-dd HH:mm:ss"
							></el-date-picker>
						</el-form-item>
						<el-form-item label="到期日期" prop="dueDate">
							<el-date-picker
								v-model="form.dueDate"
								type="datetime"
								placeholder="选择日期"
								format="yyyy 年 MM 月 dd 日"
								value-format="yyyy-MM-dd HH:mm:ss"
							></el-date-picker>
						</el-form-item>
						<el-form-item label="备注" prop="comments">
							<el-input v-model="form.comments" placeholder="请输入备注" />
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
	listBankAcceptance,
	getBankAcceptance,
	delBankAcceptance,
	addBankAcceptance,
	updateBankAcceptance
} from '@/api/system/bankAcceptance';
import { formatTime } from '@/api/tool/format';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { excludeParams } from '@/api/tool/exclude';
import { mixin_bankacception_fill } from '../../dashboard/mixins/bankacceptance/bankacception_fill';
import CheckTotal from '../../dashboard/components/bankacceptance/CheckTotal.vue';
import { listCompany } from '@/api/system/company';

export default {
	name: 'BankAcceptance',
	components: { CheckTotal, SearchOption },
	mixins: [mixin_printHTML, mixin_bankacception_fill],
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
			// 商业票据、银行承兑表格数据
			bankAcceptanceList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				issueDateStart: null,
				issueDateEnd: null,
				pageNum: 1,
				pageSize: 10,
				operateDate: null,
				billNo: null,
				issueDate: null,
				dueDate: null,
				billAccount: null,
				billDate: null,
				billType: '收入',
				reason: null,
				billAmount: null,
				inDiscountPoints: null,
				inDiscountAmount: null,
				billCategory: null,
				origin: null,
				endorser: null,
				endorsee: null,
				endorseReason: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			columns: [
				{ label: '操作日期', visible: true },
				{ label: '票据种类', visible: true },
				{ label: '票据号码', visible: true },
				{ label: '出票日期', visible: true },
				{ label: '到期日期', visible: true },
				{ label: '我方承兑账户', visible: true },
				{ label: '票据交易日期', visible: true },
				{ label: '背书事由', visible: true },
				{ label: '背书人', visible: true },
				{ label: '票据金额', visible: true },
				{ label: '贴息点数', visible: true },
				{ label: '贴息金额', visible: true },
				{ label: '来源', visible: true },
				{ label: '备注', visible: true }
			],
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				billNo: [
					{ required: true, message: '请输入票据号码', trigger: 'blur' }
				],
				dueDate: [
					{ required: true, message: '请输入到期日期', trigger: 'blur' }
				],
				reason: [
					{ required: true, message: '请选择收票事由', trigger: 'change' }
				],
				issueDate: [
					{ required: true, message: '请输入出票日期', trigger: 'blur' }
				],
				billCategory: [
					{ required: true, message: '请选择票据分类', trigger: 'change' }
				],
				endorseReason: [
					{ required: true, message: '请输入背书事由', trigger: 'blur' }
				],
				origin: [
					{ required: true, message: '请选择票据来源', trigger: 'blur' }
				],
				endorserName: [
					{ required: true, message: '请输入背书人', trigger: 'blur' }
				],
				// 添加校验
				billAccount: [
					{ required: true, message: '请选择我方承兑账户', trigger: 'blur' }
				],
				billType: [
					{ required: true, message: '请选择票据种类', trigger: 'change' }
				],
				billDate: [
					{ required: true, message: '请选择票据日期', trigger: 'change' }
				],
				billAmount: [
					{ required: true, message: '请输入票据金额', trigger: 'blur' }
				],
				inDiscountPoints: [
					{ required: true, message: '请输入贴息点数', trigger: 'blur' }
				],
				inDiscountAmount: [
					{ required: true, message: '请输入贴息金额', trigger: 'blur' }
				]
			}
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('bankacceptance-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		// 贴息金额的自动计算
		form: {
			handler() {
				this.form.inDiscountAmount =
					this.form.billAmount * this.form.inDiscountPoints;
			},
			deep: true
		}
	},

	created() {
		this.getList();
		if (
			localStorage.getItem('bankacceptance-columns') === 'null' ||
			!localStorage.getItem('bankacceptance-columns')
		) {
			// 设置localStorage
			localStorage.setItem(
				'bankacceptance-columns',
				JSON.stringify(this.columns)
			);
		} else {
			this.columns = JSON.parse(localStorage.getItem('bankacceptance-columns'));
		}
	},
	methods: {
		listCompany,
		listBankAccount,
		handleCommitBack(val) {
			this.form.billAccount = val.acountsName;
		},
		// 自定义列统计总函数
		getSummaries(param) {
			const { columns, data } = param;
			const sums = [];
			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '统计';
					return;
				}
				const values = data.map(item => {
					return Number(item[column.property]);
				});

				if (!values.every(value => isNaN(value))) {
					// 对指定列进行计算
					// if(index)
					// 需要进行统计的索引列
					const out_list = [9, 10, 11];
					// index !== 9 && index !== 1 && index !== 16 && index !== 2
					if (out_list.includes(index)) {
						sums[index] = values.reduce((prev, curr) => {
							const value = Number(curr);
							if (!isNaN(value)) {
								return prev + curr;
							} else {
								return prev;
							}
						}, 0);
						sums[index] += ' ';
					}
				} else {
					sums[index] = '';
				}
			});
			return sums;
		},
		/** 查询商业票据、银行承兑列表 */
		getList() {
			this.loading = true;
			listBankAcceptance(this.queryParams).then(response => {
				this.bankAcceptanceList = response.rows;
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
				operateDate: null,
				billNo: null,
				issueDate: null,
				dueDate: null,
				billAccount: null,
				billDate: null,
				billType: null,
				// 收票是由默认为购买
				reason: '购买',
				billAmount: null,
				inDiscountPoints: null,
				inDiscountAmount: null,
				// 票据种类默认为电子
				billCategory: '电子',
				origin: null,
				endorserName: null,
				endorseReason: null,
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
			// this.queryParams.issueDate = ''
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
			this.title = '添加收入商业票据、银行承兑';
			this.form.billDate = formatTime(new Date());
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getBankAcceptance(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改收入商业票据、银行承兑';
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
						this.form.billType = '收入';
						this.form = excludeParams(this.form, this.$exclude);
						updateBankAcceptance(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form.delFlag = null;
						this.form.addtime = null;
						this.form.updateTime = null;
						this.form.userId = null;
						this.form.billType = '收入';
						this.form = excludeParams(this.form, this.$exclude);
						addBankAcceptance(this.form).then(response => {
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
				.confirm('是否确认删除商业票据、银行承兑编号为"' + ids + '"的数据项？')
				.then(function () {
					return delBankAcceptance(ids);
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
				'system/bankAcceptance/export',
				{
					...this.queryParams
				},
				`bankAcceptance_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
