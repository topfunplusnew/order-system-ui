<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="开始时间" prop="issueDateStart">
				<el-date-picker v-model="queryParams.issueDateStart" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item label="结束时间" prop="issueDateEnd">
				<el-date-picker v-model="queryParams.issueDateEnd" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item label="票据号码" prop="billNo">
				<el-input v-model="queryParams.billNo" placeholder="请输入票据号码" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="我方承兑账户" prop="billAccount">
				<el-input v-model="queryParams.billAccount" placeholder="请输入我方承兑账户" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="排序方式">
				<el-select v-model="queryParams.isOrderBybillNo" placeholder="请选择排序方式" size="mini" clearable @keyup.enter.native="handleQuery">
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">查询流水</el-button>
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
						<el-button v-hasPermi="['system:bankacceptance:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table v-loading="loading" v-horizontal-scroll="'always'" border :data="bankAcceptanceList" show-summary id="printBox" :summary-method="getSummaries" size="mini" :cell-style="() => ({ padding: '1.5px' })" @selection-change="handleSelectionChange" :max-height="600">
			<el-table-column v-if="columns[1].visible" label="票据号码" align="center" prop="billNo" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="出票日期" align="center" prop="issueDate" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="到期日期" align="center" prop="dueDate" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="我方承兑账户" align="center" prop="billAccount" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="票据交易日期" align="center" prop="billDate" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[20].visible" label="分类" align="center" prop="billType" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="票据种类" align="center" prop="billCategory" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="收票事由" align="center" prop="incomeReason" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[9].visible" label="收入票据来源" align="center" prop="incomeOrigin" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="背书人" align="center" prop="incomeEndorserName" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[10].visible" label="收入票据金额" align="center" prop="incomeBillAmount" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[11].visible" label="收入贴息点数" align="center" prop="incomeInDiscountPoints" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[12].visible" label="收入贴息金额" align="center" prop="incomeInDiscountAmount" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[13].visible" label="背书事由" align="center" prop="expenseReason" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[15].visible" label="支出票据去向" align="center" prop="expenseOrigin" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[14].visible" label="被背书人" align="center" prop="expenseEndorserName" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[16].visible" label="支出票据金额" align="center" prop="expenseBillAmount" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[17].visible" label="支出贴息点数" align="center" prop="expenseInDiscountPoints" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[18].visible" label="支出贴息金额" align="center" prop="expenseInDiscountAmount" width="120" show-overflow-tooltip />
			<el-table-column v-if="columns[19].visible" label="备注" align="center" prop="comments" width="120" show-overflow-tooltip />

			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150px" fixed="right">
				<template #default="scope">
					<el-button v-hasPermi="['system:bankacceptance:remove']" size="mini" type="text" @click="handleCheck(scope.row)">查看详情</el-button>
					<el-button v-hasPermi="['system:bankacceptance:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<InfoDialog title="票据详情" :visible.sync="totalVisible">
			<template #info>
				<el-table
					v-loading="loading"
					v-horizontal-scroll="'always'"
					border
					:data="bankAcceptanceMoneyList"
					show-summary
					id="printBox"
					:summary-method="getSummaries"
					size="mini"
					:cell-style="
						() => {
							return { padding: '2px' };
						}
					"
					@selection-change="handleSelectionChange"
				>
					<el-table-column label="ID" align="center" prop="id" width="120" show-overflow-tooltip />
					<el-table-column label="票据号码" align="center" prop="billNo" width="120" show-overflow-tooltip />
					<el-table-column label="出票日期" align="center" prop="issueDate" width="120" show-overflow-tooltip />
					<el-table-column label="到期日期" align="center" prop="dueDate" width="120" show-overflow-tooltip />
					<el-table-column label="我方承兑账户" align="center" prop="billAccount" width="120" show-overflow-tooltip />
					<el-table-column label="票据交易日期" align="center" prop="billDate" width="120" show-overflow-tooltip />
					<el-table-column label="收票事由" align="center" prop="incomeReason" width="120" show-overflow-tooltip />
					<el-table-column label="票据种类（电子/纸质）" align="center" prop="billCategory" width="120" show-overflow-tooltip />
					<el-table-column label="背书人(来源)" align="center" prop="incomeEndorserName" width="120" show-overflow-tooltip />
					<el-table-column label="收入票据来源" align="center" prop="incomeOrigin" width="120" show-overflow-tooltip />
					<el-table-column label="收入票据金额" align="center" prop="incomeBillAmount" width="120" show-overflow-tooltip />
					<el-table-column label="收入贴息点数" align="center" prop="incomeInDiscountPoints" width="120" show-overflow-tooltip />
					<el-table-column label="收入贴息金额" align="center" prop="incomeInDiscountAmount" width="120" show-overflow-tooltip />
					<el-table-column label="背书是由" align="center" prop="expenseReason" width="120" show-overflow-tooltip />
					<el-table-column label="被背书人" align="center" prop="expenseEndorserName" width="120" show-overflow-tooltip />
					<el-table-column label="支出票据去向" align="center" prop="expenseOrigin" width="120" show-overflow-tooltip />
					<el-table-column label="支出票据金额" align="center" prop="expenseBillAmount" width="120" show-overflow-tooltip />
					<el-table-column label="支出贴息点数" align="center" prop="expenseInDiscountPoints" width="120" show-overflow-tooltip />
					<el-table-column label="支出贴息金额" align="center" prop="expenseInDiscountAmount" width="120" show-overflow-tooltip />
					<el-table-column label="票据余额" align="center" prop="balance" width="120" show-overflow-tooltip />
					<el-table-column label="备注" align="center" prop="comments" width="120" show-overflow-tooltip />
				</el-table>
			</template>
		</InfoDialog>
	</div>
</template>

<script>
import { listBankAcceptanceAll, getBankAcceptance, delBankAcceptance, addBankAcceptance, updateBankAcceptance } from '@/api/system/bankAcceptance';
import { formatTime } from '@/api/tool/format';
import { listBankAccount } from '@/api/system/bankAccount';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { excludeParams } from '@/api/tool/exclude';
import InfoDialog from '../../../components/InfoDialog.vue';
import { listBankAcceptanceBalanceMoney } from '../../../api/system/bankAcceptance';

export default {
	name: 'BillStatement',
	components: { InfoDialog },
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
			// 商业票据、银行承兑表格数据
			bankAcceptanceList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				isOrderBybillNo: null,
				issueDateStart: null,
				issueDateEnd: null,
				pageNum: 1,
				pageSize: 20,
				operateDate: null,
				billNo: null,
				issueDate: null,
				dueDate: null,
				billAccount: null,
				billDate: null,
				billType: null,
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
				{ key: 0, label: `ID`, visible: true },
				{ key: 1, label: `票据号码`, visible: true },
				{ key: 2, label: `出票日期`, visible: true },
				{ key: 3, label: `到期日期`, visible: true },
				{ key: 4, label: `我方承兑账户`, visible: true },
				{ key: 5, label: `票据交易日期`, visible: true },
				{ key: 6, label: `收票事由`, visible: true },
				{ key: 7, label: `票据种类`, visible: true },
				{ key: 8, label: `背书人`, visible: true },
				{ key: 9, label: `收入票据来源`, visible: true },
				{ key: 10, label: `收入票据金额`, visible: true },
				{ key: 11, label: `收入贴息点数`, visible: true },
				{ key: 12, label: `收入贴息金额`, visible: true },
				{ key: 13, label: `背书事由`, visible: true },
				{ key: 14, label: `被背书人`, visible: true },
				{ key: 15, label: `支出票据去向`, visible: true },
				{ key: 16, label: `支出票据金额`, visible: true },
				{ key: 17, label: `支出贴息点数`, visible: true },
				{ key: 18, label: `支出贴息金额`, visible: true },
				{ key: 19, label: `备注`, visible: true },
				{ key: 20, label: `分类`, visible: true }
			],
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				billNo: [
					{
						required: true,
						message: '请输入票据号码',
						trigger: 'blur'
					}
				],
				dueDate: [
					{
						required: true,
						message: '请输入到期日期',
						trigger: 'blur'
					}
				],
				reason: [
					{
						required: true,
						message: '请选择收票事由',
						trigger: 'change'
					}
				],
				issueDate: [
					{
						required: true,
						message: '请输入出票日期',
						trigger: 'blur'
					}
				],
				billCategory: [
					{
						required: true,
						message: '请选择票据分类',
						trigger: 'change'
					}
				],
				endorseReason: [
					{
						required: true,
						message: '请输入背书事由',
						trigger: 'blur'
					}
				],
				origin: [
					{
						required: true,
						message: '请选择票据来源',
						trigger: 'blur'
					}
				],
				endorsee: [
					{
						required: true,
						message: '请输入被背书人',
						trigger: 'blur'
					}
				],
				endorser: [{ required: true, message: '请输入背书人', trigger: 'blur' }],
				// 添加校验
				billAccount: [
					{
						required: true,
						message: '请选择我方承兑账户',
						trigger: 'blur'
					}
				],
				billType: [
					{
						required: true,
						message: '请选择票据种类',
						trigger: 'change'
					}
				],
				billDate: [
					{
						required: true,
						message: '请选择票据日期',
						trigger: 'change'
					}
				],
				billAmount: [
					{
						required: true,
						message: '请输入票据金额',
						trigger: 'blur'
					}
				],
				inDiscountPoints: [
					{
						required: true,
						message: '请输入贴息点数',
						trigger: 'blur'
					}
				],
				inDiscountAmount: [
					{
						required: true,
						message: '请输入贴息金额',
						trigger: 'blur'
					}
				]
			},
			options: [
				{
					value: '操作日期',
					label: '操作日期'
				},
				{
					value: '票据单号',
					label: '票据单号'
				}
			],
			// 查看票据余额
			totalVisible: false,
			bankAcceptanceMoneyList: []
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('billstatement-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('billstatement-columns') === 'null' || !localStorage.getItem('billstatement-columns')) {
			// 设置localStorage
			localStorage.setItem('billstatement-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('billstatement-columns'));
		}
	},
	methods: {
		listBankAccount,
		// 查看某张票据的收入支出详情
		handleCheck(row) {
			listBankAcceptanceBalanceMoney({ billNo: row.billNo }).then(res => {
				this.bankAcceptanceMoneyList = res.rows;
				this.totalVisible = true;
			});
		},
		// 填充
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
					const out_list = [10, 11];
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
			listBankAcceptanceAll(this.queryParams).then(response => {
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
				updateTime: null,
				delFlag: null
			};
			this.resetForm('form');
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			if (!this.queryParams.params) {
				this.queryParams.params = {};
			}
			// 添加searchParams 如果这个存在
			if (this.queryParams.isOrderBybillNo) {
				this.queryParams.params['isOrderBybillNo'] = 'true';
			}
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
				'system/bankAcceptance/exportAll',
				{
					...this.queryParams
				},
				`票据流水账_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
