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
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<!-- <el-col :span="1.5">
				<el-button v-hasPermi="['system:bankacceptance:add']" type="danger" size="mini" @click="handleAdd">添加支出商业票据</el-button>
			</el-col> -->
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:bankacceptance:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table v-loading="loading" v-horizontal-scroll="'always'" id="printBox" border :data="bankAcceptanceList" size="mini" show-summary :summary-method="getSummaries" :cell-style="() => ({ padding: '.5px' })" @selection-change="handleSelectionChange">
			<el-table-column v-if="columns[0].visible" label="ID" align="center" prop="id" show-overflow-tooltip />

			<el-table-column v-if="columns[1].visible" label="操作日期" align="center" prop="operateDate" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="票据种类" align="center" prop="billCategory" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="票据号码" align="center" prop="billNo" show-overflow-tooltip>
				<template #default="scope">
					<CheckTotal :row="scope.row" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[4].visible" label="收票事由" align="center" prop="reason" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="背书人" align="center" prop="endorserName" show-overflow-tooltip />

			<el-table-column v-if="columns[6].visible" label="出票日期" align="center" prop="issueDate" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="到期日期" align="center" prop="dueDate" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="我方承兑账户" align="center" prop="billAccount" show-overflow-tooltip />
			<el-table-column v-if="columns[9].visible" label="票据交易日期" align="center" prop="billDate" show-overflow-tooltip />

			<el-table-column v-if="columns[10].visible" label="票据金额" align="center" prop="billAmount" show-overflow-tooltip />
			<el-table-column v-if="columns[11].visible" label="贴息点数" align="center" prop="inDiscountPoints" show-overflow-tooltip />
			<el-table-column v-if="columns[12].visible" label="贴息金额" align="center" prop="inDiscountAmount" show-overflow-tooltip />

			<el-table-column v-if="columns[13].visible" label="来源" align="center" prop="origin" show-overflow-tooltip />
			<el-table-column v-if="columns[14].visible" label="备注" align="center" prop="comments" show-overflow-tooltip />

			<el-table-column label="操作" align="center" class-name="small-padding">
				<template #default="scope">
					<el-button v-hasPermi="['system:bankacceptance:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:bankacceptance:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改商业票据、银行承兑对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="800px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="140px">
				<el-row>
					<el-col :span="12">
						<el-form-item label="票据号码" prop="billNo">
							<el-input v-model="form.billNo" placeholder="请输入票据号码" @input="getBankAcceptanceDate" />
						</el-form-item>
						<el-form-item label="背书事由" prop="reason">
							<el-radio v-model="form.reason" label="出卖">出卖</el-radio>
							<el-radio v-model="form.reason" label="支付货款">支付货款</el-radio>
						</el-form-item>
						<el-form-item label="被背书人类型" prop="reason">
							<el-radio v-model="type" label="客户">客户</el-radio>
							<el-radio v-model="type" label="供应商">供应商</el-radio>
							<el-radio v-model="type" label="己方公司">己方公司</el-radio>
						</el-form-item>
						<el-form-item label="被背书人" prop="endorserName">
							<!--							<el-input v-model="form.endorser" placeholder="请输入背书人" />-->
							<el-row>
								<el-col :span="20">
									<!--                  v-model="form.endorser"-->
									<el-input disabled placeholder="请输入被背书人" v-model="displayEndorserName" />
								</el-col>
								<el-col :span="4">
									<!-- 选择的是客户或者供应商名称-->
									<SearchOption :limit-info="{ companyType: type }" :get-data="listCompany" query-info="companyName" query-label="公司名称" :query-name="companyName" @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
										<template #table-columns>
											<el-table-column :label="type" align="center" prop="companyName" />
											<el-table-column label="老板姓名" align="center" prop="leader" />
											<el-table-column label="老板电话" align="center" prop="leaderTel" />
											<el-table-column label="区域" align="center" prop="region" />
											<el-table-column label="销售经理" align="center" prop="salesManager" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="支出票据金额" prop="billAmount">
							<el-input v-model="form.billAmount" placeholder="请输入票据金额" />
						</el-form-item>
						<el-form-item label="支出贴息点数" prop="inDiscountPoints">
							<el-input v-model="form.inDiscountPoints" placeholder="请输入贴息点数" />
						</el-form-item>
						<el-form-item label="支出贴息金额" prop="inDiscountAmount">
							<el-input disabled v-model="form.inDiscountAmount" placeholder="请输入贴息金额" />
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
									<el-input disabled v-model="form.billAccount" placeholder="请输入我方承兑账户" />
								</el-col>
								<el-col :span="4">
									<SearchOption
										:get-data="listBankAccount"
										:limit-info="{
											acountsType: '己方公司'
										}"
										query-label="户名查找"
										query-info="acountsName"
										:query-name="queryBank"
										@commitBack="handleCommitBack"
										@update:queryName="handleUpdateQueryName"
									>
										<template #table-columns>
											<el-table-column label="己方公司" align="center" prop="displayName" />
											<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
											<el-table-column label="账号(银行账号)" align="center" prop="bankNo" />
											<el-table-column label="开户行" align="center" prop="bankName" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<div style="width: 100%">
							<el-form-item label="票据交易日期" prop="billDate">
								<el-date-picker style="width: 100%" v-model="form.billDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
							</el-form-item>
						</div>
						<div style="width: 100%">
							<el-form-item label="出票日期" prop="issueDate">
								<el-date-picker style="width: 100%" v-model="form.issueDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
							</el-form-item>
						</div>
						<div style="width: 100%">
							<el-form-item label="到期日期" prop="dueDate">
								<el-date-picker style="width: 100%" v-model="form.dueDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
							</el-form-item>
						</div>
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
import { listBankAcceptance, getBankAcceptance, delBankAcceptance, addBankAcceptance, updateBankAcceptance, getMinIdByBillNo } from '@/api/system/bankAcceptance';
import { fix, formatTime } from '@/api/tool/format';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import { excludeParams } from '@/api/tool/exclude';
import { mixin_bank_acception_fill } from '../../dashboard/mixins/bankacceptancegive/mixin_bankacception_fill';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import CheckTotal from '../../dashboard/components/bankacceptance/CheckTotal.vue';
import { listCompany } from '@/api/system/company';
import _ from 'lodash';

export default {
	name: 'BankAcceptanceGive',
	components: { CheckTotal, SearchOption },
	mixins: [mixin_bank_acception_fill, mixin_printHTML],
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
				pageNum: 1,
				pageSize: 20,
				operateDate: null,
				issueDateEnd: null,
				issueDateStart: null,
				billNo: null,
				issueDate: null,
				dueDate: null,
				billAccount: null,
				billDate: null,
				billType: '支出',
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
				delFlag: null,
				// 新增字段：区分是否是内部转账票据，支出票据默认为0（非内部转账）
				isInternalTransfer: 0
			},
			columns: [
				{ key: 0, label: `ID`, visible: true }, // 新增 ID
				{ key: 1, label: `操作日期`, visible: true },
				{ key: 2, label: `票据种类`, visible: true },
				{ key: 3, label: `票据号码`, visible: true },
				{ key: 4, label: `收票事由`, visible: true }, // 新增 收票事由
				{ key: 5, label: `背书人`, visible: true }, // 新增 背书人
				{ key: 6, label: `出票日期`, visible: true },
				{ key: 7, label: `到期日期`, visible: true },
				{ key: 8, label: `我方承兑账户`, visible: true },
				{ key: 9, label: `票据交易日期`, visible: true }, // 将原 "票据日期" 修改为 "票据交易日期"
				{ key: 10, label: `票据金额`, visible: true },
				{ key: 11, label: `贴息点数`, visible: true },
				{ key: 12, label: `贴息金额`, visible: true },
				{ key: 13, label: `来源`, visible: true },
				{ key: 14, label: `备注`, visible: true }
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
					},
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('金额只能为数字且小数点后最多两位'));
							} else {
								callback();
							}
						},
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
					},
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('金额只能为数字且小数点后最多两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				]
			},
			displayEndorserName: null
		};
	},
	created() {
		this.getList();
		if (localStorage.getItem('bankacceptancegive-columns') === 'null' || !localStorage.getItem('bankacceptancegive-columns')) {
			// 设置localStorage
			localStorage.setItem('bankacceptancegive-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('bankacceptancegive-columns'));
		}
		// 创建防抖函数
	},
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('bankacceptancegive-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		// 贴息金额的自动计算
		form: {
			handler() {
				this.form.inDiscountAmount = Number(this.form.billAmount * this.form.inDiscountPoints).toFixed(2);
			},
			deep: true
		}
	},
	methods: {
		listCompany,
		listBankAccount,
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
						const sum = values.reduce((prev, curr) => {
							const value = Number(curr);
							if (!isNaN(value)) {
								return prev + curr;
							} else {
								return prev;
							}
						}, 0);
						// 保留两位小数
						sums[index] = Number(sum).toFixed(2);
					}
				} else {
					sums[index] = '';
				}
			});
			return sums;
		},
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				maxWidth: 2500,
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
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
				billType: '支出',
				reason: '购买',
				billAmount: null,
				inDiscountPoints: null,
				inDiscountAmount: null,
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
			this.title = '添加支出商业票据、银行承兑';
			this.form.billDate = formatTime(new Date());
		},
		// 获取票据信息
		getBankAcceptanceDate(e) {
			if (!e) return;
			const inputValue = e.target.value;
			if (!inputValue) {
				this.$message.error('票据号码为空,填充失败');
				return;
			}
			// 在这里 发送请求 获取三个时间 自动填充
			getMinIdByBillNo(inputValue).then(res => {
				if (!res.data) {
					this.$message.error('该票据不存在,自动填充时间失败');
					return;
				}
				if (this.form.id) {
					this.$message.warning('操作为修改票据信息,未填充时间');
					return;
				}
				const obj = _.cloneDeep(res.data);
				// 填充三个时间
				this.$nextTick(() => {
					this.form.billDate = obj.billDate;
					this.form.issueDate = obj.issueDate;
					this.form.dueDate = obj.dueDate;
				});
			});
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getBankAcceptance(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改支出商业票据、银行承兑';
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
						// 支出 默认
						this.form.billType = '支出';
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
						this.form.billType = '支出';
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
