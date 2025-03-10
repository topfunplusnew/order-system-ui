<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="100px">
			<el-form-item label="开始日期" prop="fundsDate">
				<el-date-picker v-model="queryParams.startTime" type="datetime" placeholder="请选择日期" value-format="yyyy-MM-dd HH:mm:ss" class="w-85px" />
			</el-form-item>
			<el-form-item label="结束日期" prop="fundsDate">
				<el-date-picker v-model="queryParams.endTime" type="datetime" placeholder="请选择日期" value-format="yyyy-MM-dd HH:mm:ss" class="w-85px" />
			</el-form-item>
			<el-form-item label="我方户名" prop="selfAcountsName">
				<el-input v-model="queryParams.selfAcountsName" placeholder="请输入我方户名" clearable class="w-85px" @keyup.enter.native="handleQuery" />
			</el-form-item>

			<el-form-item label="对方户名" prop="otherAcountsName">
				<el-input v-model="queryParams.otherAcountsName" placeholder="请输入对方户名" clearable class="w-85px" @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button v-hasPermi="['system:receivemoney:add']" type="danger" size="mini" @click="handleAdd">新增收款信息</el-button>
			</el-col>
			<right-toolbar :show-search.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:receivemoney:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-horizontal-scroll="'always'"
			v-loading="loading"
			border
			:data="receiveMoneyList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column v-if="columns[0].visible" label="日期" align="center" prop="fundsDate" width="140" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="支付类型" align="center" prop="receiveType" width="165" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="金额" align="center" prop="moneyAmount" width="165" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="我方户名" align="center" prop="selfAcountsName" width="165" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="我方账号" align="center" prop="selfBankNo" width="165" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="我方开户行" align="center" prop="selfBankName" width="165" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="对方户名" align="center" prop="otherAcountsName" width="165" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="对方账号" align="center" prop="otherBankNo" width="165" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="对方开户行" align="center" prop="otherBankName" width="165" show-overflow-tooltip />
			<el-table-column v-if="columns[9].visible" label="对方公司" align="center" prop="companyName" width="165" show-overflow-tooltip />
			<el-table-column v-if="columns[10].visible" label="对方公司类型" align="center" prop="companyType" width="165">
				<template slot-scope="scope">
					<span v-if="scope.row.companyType === 1">客户</span>
					<span v-else-if="scope.row.companyType === 2">供应商</span>
				</template>
			</el-table-column>
			<el-table-column label="备注" align="center" prop="comments" width="165" />
			<el-table-column label="银行卡流水编号" align="center" prop="transactionHistory" width="165" />
			<el-table-column label="银行卡流水附件" align="center" prop="transactionHistoryAttachment" width="165" fixed="right">
				<template slot-scope="scope">
					<!-- 这是封装的一个通用组件 可以直接传入url 组件效果为一个按钮 点击后可以查看附件-->
					<CheckFiles
						:path="scope.row.transactionHistoryAttachment"
						@needToUpdate="value => handleUpdateFilePath(value, scope.row, 'transactionHistoryAttachment', getReceiveMoney(), updateReceiveMoney())"
					/>
				</template>
			</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="150">
				<template slot-scope="scope">
					<el-button v-hasPermi="['system:receivemoney:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
					<el-button v-hasPermi="['system:receivemoney:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改收款信息对话框 -->
		<el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="1200px" append-to-body>
			<div style="height: 530px">
				<el-form ref="form" :model="form" :rules="rules" label-width="150px">
					<!--        第一列-->
					<el-col :span="12">
						<el-form-item label="日期" prop="fundsDate">
							<el-date-picker v-model="form.fundsDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择日期" />
						</el-form-item>
						<el-form-item label="收款类型" prop="payType">
							<el-cascader v-model="form.receiveType" :options="paymentTypeTree" :props="props" />
						</el-form-item>
						<el-form-item label="金额" prop="moneyAmount">
							<el-input v-model="form.moneyAmount" placeholder="请输入金额" />
						</el-form-item>
						<!--  对方银行卡的消费类型 (承兑户或者现金户)-->
						<el-form-item label="我方银行账户类型">
							<BankType
								:bill-type="BankAcceptanceType.PAY_TYPE.RECEIVE"
								:select-type="form.selfBankCardType"
								@updateSelectedType="changeSelfBankType"
								@updateBankAcceptance="value => (form.params.bankacceptance = value)"
							/>
						</el-form-item>
						<el-form-item label="我方户名" prop="selfAcountsName">
							<el-row>
								<el-col :span="10">
									<el-input disabled v-model="form.selfAcountsName" placeholder="请选择" />
								</el-col>
								<!--   自定义组件查找-->
								<el-col :span="3">
									<SearchOption
										:get-data="listBankAccount"
										title="银行卡信息"
										icon="el-icon-search"
										:limit-info="{
											acountsType: '己方公司'
										}"
										:query-name="bankQuery"
										query-info="acountsName"
										query-label="户名查询"
										@commitBack="handleCallBack"
										@update:queryName="handleCommitBackBank"
									>
										<template #table-columns>
											<el-table-column label="账户类型" align="center" prop="acountsType" />
											<el-table-column label="显示名称" align="center" prop="displayName" />
											<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
											<el-table-column label="账号(银行账号)" align="center" prop="bankNo" />
											<el-table-column label="开户行" align="center" prop="bankName" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="我方账号" prop="selfBankNo">
							<el-input disabled v-model="form.selfBankNo" placeholder="请选择" />
						</el-form-item>
						<el-form-item label="我方开户行" prop="selfBankName">
							<el-input disabled v-model="form.selfBankName" placeholder="请选择" />
						</el-form-item>
						<el-form-item label="对方类型(请确认)">
							<el-select v-model="value" placeholder="请选择">
								<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
							</el-select>
							<span style="color: #1c84c6; font-size: 12px">请注意选择正确的对方公司类型!</span>
						</el-form-item>
					</el-col>

					<!--        第二列-->
					<el-col :span="12">
						<el-form-item v-if="value !== '对外付款'" :label="value === '司机' ? '司机' : '对方公司'" prop="companyName">
							<el-row>
								<el-col :span="14">
									<el-input disabled v-model="form.companyName" placeholder="请选择" />
								</el-col>
								<el-col v-if="value === '司机'" :span="4">
									<SearchOption
										:limit-info="{}"
										:get-data="listCars"
										query-info="carNo"
										query-label="车牌/柜号"
										:query-name="carName"
										@update:queryName="handleUpdateCarName"
										@commitBack="handleCommitBackCar"
									>
										<template #table-columns>
											<el-table-column label="车牌/柜号" align="center" prop="carNo" width="220" />
											<el-table-column label="司机姓名/海运公司" align="center" prop="driver" width="220" />
											<el-table-column label="司机电话" align="center" prop="tel" width="200" />
											<el-table-column label="户名" align="center" prop="acountsName" width="200" />
											<el-table-column label="银行账号" align="center" prop="bankNo" width="200" />
											<el-table-column label="开户行" align="center" prop="bankName" width="200" />
											<el-table-column label="运输类型" align="center" prop="carType" width="200" />
										</template>
									</SearchOption>
								</el-col>
								<el-col v-else :span="4">
									<SearchOption
										:limit-info="{ companyType: value }"
										:get-data="listCompany"
										query-info="companyName"
										query-label="公司名称"
										:query-name="companyName"
										@update:queryName="handleUpdateCompanyName"
										@commitBack="handleCommitBackCompany"
									>
										<template #table-columns>
											<el-table-column :label="value" align="center" prop="companyName" />
											<el-table-column label="公司类型" align="center" prop="companyType" />
											<el-table-column label="老板姓名" align="center" prop="leader" />
											<el-table-column label="老板电话" align="center" prop="leaderTel" />
											<el-table-column label="区域" align="center" prop="region" />
											<el-table-column label="销售经理" align="center" prop="salesManager" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="对方银行账户类型" v-if="value !== '对外付款'">
							<BankType :option-baned="true" :baned="true" :select-type="form.otherBankCardType" @updateSelectedType="changeOtherBankType" />
						</el-form-item>
						<el-form-item label="对方账号" prop="otherBankNo" v-if="value !== '对外付款'">
							<el-col :span="10">
								<el-input disabled v-model="form.otherBankNo" placeholder="请选择" />
							</el-col>
							<el-col :span="3">
								<SearchOption
									:get-data="listBankAccount"
									title="客户银行卡信息"
									icon="el-icon-search"
									query-label="户名查找"
									query-info="acountsName"
									:query-name="queryCustomerBank"
									:limit-info="{ acountsType: value }"
									@update:queryName="handleUpdateQueryNameCustomer"
									@commitBack="handleCallBackCompany"
								>
									<template #table-columns>
										<el-table-column label="账户类型" align="center" prop="acountsType" />
										<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
										<el-table-column label="账号(银行账号)" align="center" prop="bankNo" />
										<el-table-column label="开户行" align="center" prop="bankName" />
									</template>
								</SearchOption>
							</el-col>
						</el-form-item>
						<el-form-item label="对方开户行" prop="selfBankName" v-if="value !== '对外付款'">
							<el-input disabled v-model="form.otherBankName" placeholder="请选择" />
						</el-form-item>
						<el-form-item label="对方开户名" prop="selfBankName" v-if="value !== '对外付款'">
							<el-input disabled v-model="form.otherAcountsName" placeholder="请选择" />
						</el-form-item>
						<el-form-item label="银行卡流水编号" prop="transactionHistory">
							<el-input v-model="form.transactionHistory" placeholder="请输入银行卡流水编号" />
						</el-form-item>
						<el-form-item label="银行卡流水编号附件" prop="transactionHistoryAttachment">
							<file-upload ref="fileUploader" @input="handleCommitUpload" />
						</el-form-item>
						<el-form-item label="备注" prop="comments">
							<el-input v-model="form.comments" placeholder="请输入备注" />
						</el-form-item>
					</el-col>
				</el-form>
			</div>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { addReceiveMoney, delReceiveMoney, listReceiveMoney } from '@/api/system/receiveMoney';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import { excludeParams } from '@/api/tool/exclude';
import { addReason } from '@/api/system/user';
import { BankAcceptanceType, TableName } from '@/api/tool/enums';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import CheckFiles from '../../../components/CheckFiles.vue';

import { listCompany } from '../../../api/system/company';
import { mixin_receive_money_fill } from './receiveMoneyFill';
import { listCars } from '../../../api/system/cars';
import { getReceiveMoney, updateReceiveMoney } from '../../../api/system/receiveMoney';
import { mixin_checkfile } from '../../dashboard/mixins/checkfiles/mixin_checkfile';
import BankType from '@/views/dashboard/components/common/BankType.vue';
import { mixin_bankType } from '../../dashboard/mixins/common/common_bankType';
import { mixin_receive_money_subject } from '@/views/dashboard/mixins/receivemoney/receive_money_subject';
import { getBankAcceptance } from '@/api/system/bankAcceptance';

export default {
	name: 'ReceiveMoney',
	computed: {
		BankAcceptanceType() {
			return BankAcceptanceType;
		}
	},
	components: { BankType, CheckFiles, SearchOption },
	mixins: [mixin_printHTML, mixin_receive_money_fill, mixin_checkfile, mixin_bankType, mixin_receive_money_subject],
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
			// 收款信息表格数据
			receiveMoneyList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				receiveNO: null,
				fundsDate: null,
				receiveType: null,
				tableName: null,
				tID: null,
				moneyAmount: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			// 表单参数
			form: {},
			// 表单校验
			rules: {
				fundsDate: [{ required: true, message: '日期不能为空', trigger: 'blur' }],
				moneyAmount: [
					{
						required: true,
						message: '金额不能为空',
						trigger: 'blur'
					},
					// 金额校验 小数点只能两位
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
				selfAcountsName: [
					{
						required: true,
						message: '我方户名不能为空',
						trigger: 'change'
					}
				],
				selfBankNo: [
					{
						required: true,
						message: '我方账号不能为空',
						trigger: 'blur'
					}
				],
				selfBankName: [
					{
						required: true,
						message: '我方开户行不能为空',
						trigger: 'blur'
					}
				],
				otherAcountsName: [
					{
						required: true,
						message: '对方户名不能为空',
						trigger: 'blur'
					}
				],
				otherBankNo: [
					{
						required: true,
						message: '对方账号不能为空',
						trigger: 'blur'
					}
				],
				otherBankName: [
					{
						required: true,
						message: '对方开户行不能为空',
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `支付类型`, visible: true },
				{ key: 2, label: `金额`, visible: true },
				{ key: 3, label: `乙方户名`, visible: true },
				{ key: 4, label: `我方账号`, visible: true },
				{ key: 5, label: `我方开户行`, visible: true },
				{ key: 6, label: `对方户名`, visible: true },
				{ key: 7, label: `对方账号`, visible: true },
				{ key: 8, label: `对方开户行`, visible: true },
				{ key: 9, label: `对方公司`, visible: true },
				{ key: 10, label: `对方公司类型`, visible: true }
			],
			// 银行卡查询
			bankQuery: ''
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('receivemoney-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		// 查询列表
		this.getList();
		// 获取本地显示隐藏列的存储 以便于下一次用户打开的时候读取喜好
		if (localStorage.getItem('receivemoney-columns') === 'null' || !localStorage.getItem('receivemoney-columns')) {
			// 设置localStorage
			localStorage.setItem('receivemoney-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('receivemoney-columns'));
		}
	},
	methods: {
		listCars,
		listCompany,
		listBankAccount,
		updateReceiveMoney() {
			return updateReceiveMoney;
		},
		getReceiveMoney() {
			return getReceiveMoney;
		},
		// 银行卡附件上传
		handleCommitUpload(val) {
			this.form.transactionHistoryAttachment = val;
		},
		/** 查询收款信息列表 */
		getList() {
			this.loading = true;
			listReceiveMoney(this.queryParams).then(response => {
				this.receiveMoneyList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.$bus.$emit('changeFlag', false);
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				receiveNO: null,
				fundsDate: null,
				receiveType: null,
				tableName: null,
				tID: null,
				moneyAmount: null,
				// 我方银行卡的账户类型
				selfBankCardType: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				// 对方银行卡账户的类型
				otherBankCardType: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null,
				params: {
					bankacceptance: null
				}
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
			this.title = '添加收款信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.$prompt('请输入编辑原因', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			}).then(({ value }) => {
				addReason({
					reason: value,
					tableName: TableName.RECEIVE_MONEY,
					tid: row.id,
					modifyTime: this.modifyTime
				}).then(() => {
					this.$message.success('提交成功');
					this.reset();
					const id = row.id || this.ids;
					getReceiveMoney(id).then(response => {
						this.form = response.data;
						this.$bus.$emit('changeFlag', response.data.bankacceptanceId > 0 ? response.data.bankacceptanceId : false);
						this.form.receiveType = response.data.receiveType.split('-');
						// 处理银行账户类型
						let flag = false;
						if (!response.data.bankacceptanceId) {
							this.$message.warning('该收款信息无凭证相关信息');
							flag = true;
						}
						if (!flag) {
							getBankAcceptance(response.data.bankacceptanceId).then(result => {
								if (!result.data) {
									this.$message.error('获取凭证数据失败:该行数据存储了凭证ID但没有查询到该ID对应的相关数据');
									return;
								}
								this.$nextTick(() => {
									this.form.params.bankacceptance = result.data;
								});
							});
						}
						this.open = true;
						this.title = '修改收款信息';
					});
				});
			});
		},

		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 校验收款类型 和银行卡类型
					if (!this.form.receiveType) {
						this.$message.warning('请选择收款类型');
						return;
					}
					if (!this.form.selfBankCardType || !this.form.otherBankCardType) {
						this.$message.warning('请选择银行账户类型,缺一不可!');
						return;
					}
					if (this.form.selfBankCardType && this.form.otherBankCardType) {
						if (this.form.selfBankCardType !== this.form.otherBankCardType) {
							this.$message.warning('操作失败，无法进行承兑与活期存款或者相反的交易,类型需要保持一致');
							return;
						}
					}
					this.form = excludeParams(this.form, this.$exclude);
					this.form.receiveType = this.form.receiveType.join('-');
					if (this.form.id != null) {
						updateReceiveMoney(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.clearFiles();
							this.getList();
							this.$bus.$emit('changeFlag', false);
						});
					} else {
						addReceiveMoney(this.form).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.clearFiles();
							this.getList();
							this.$bus.$emit('changeFlag', false);
						});
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除收款信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delReceiveMoney(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		// 清除文件
		clearFiles() {
			this.$refs.fileUploader.clearFileList();
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/receiveMoney/export',
				{
					...this.queryParams
				},
				`receiveMoney_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
<style scoped>
.w-85px {
	width: 85px;
}
</style>
