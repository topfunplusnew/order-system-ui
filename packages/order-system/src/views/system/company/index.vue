<!--
用户需求：客户信息列表需要根据修改时间是否为 null，控制“修改记录”按钮的禁用状态，不能禁用编辑按钮。
实际改动：恢复“编辑”按钮原有可用状态；客户行数据 updateTime 为 null 时禁用“修改记录”按钮。
-->
<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="客户名称" prop="companyName">
				<el-input v-model="queryParams.companyName" placeholder="请输入客户名称" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'companyName')" />
			</el-form-item>
			<el-form-item label="联系人" prop="relationName">
				<el-input v-model="queryParams.relationName" placeholder="请输入联系人名称" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'relationName')" />
			</el-form-item>
			<el-form-item label="销售经理" prop="salesManager">
				<el-input v-model="queryParams.salesManager" placeholder="请输入销售经理名称" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'salesManager')" />
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
				<el-button v-hasPermi="['system:company:add']" type="danger" size="mini" @click="handleAdd">新增客户信息</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList" tableName="company-columns">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:company:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table id="printBox" v-loading="loading" v-horizontal-scroll="'always'" border :data="companyList" size="mini" :cell-style="cellStyle" @selection-change="handleSelectionChange">
			<el-table-column v-if="columns[0].visible" label="ID" align="center" prop="id" show-overflow-tooltip width="80" />
			<el-table-column v-if="columns[1].visible" label="客户名称" align="center" prop="companyName" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="老板姓名" align="center" prop="leader" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="老板电话" align="center" prop="leaderTel" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="联系人" align="center" prop="relationName" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="联系电话" align="center" prop="relationTel" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="销售经理" align="center" prop="salesManager" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="区域" align="center" show-overflow-tooltip>
				<template slot-scope="scope">
					{{ [scope.row.province, scope.row.city, scope.row.county].filter(Boolean).join(' - ') || '' }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[8].visible" label="地址" align="center" prop="address" show-overflow-tooltip />
			<el-table-column v-if="columns[9].visible" label="备注" align="center" prop="comments" show-overflow-tooltip />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="280">
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="jumpBankNo(scope.row)">银行卡号</el-button>
					<el-button v-hasPermi="['system:company:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">编辑</el-button>
					<el-button v-hasPermi="['system:company:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
					<el-button size="mini" type="text" :disabled="scope.row.updateTime == null" @click="handleViewEditHistory(scope.row)">修改记录</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<CompanyEditHistoryDialog :visible.sync="historyDialogVisible" :company-id="historyCompanyId" :company-type="companyType" />

		<!-- 添加或修改客户信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="54%" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="120px" @keyup.enter.native="submitForm">
				<el-row :gutter="4">
					<el-col :span="12">
						<el-form-item label="客户名称" prop="companyName">
							<el-input v-model="form.companyName" placeholder="请输入客户名称" @input="handleInputTrim($event, 'form', 'companyName')" @blur="handleCheckIsExits" />
						</el-form-item>
						<el-form-item label="联系电话" prop="relationTel">
							<el-input v-model="form.relationTel" placeholder="请输入联系电话" @input="handleInputTrim($event, 'form', 'relationTel')" />
						</el-form-item>
						<el-form-item label="联系人" prop="relationName">
							<el-input v-model="form.relationName" placeholder="请输入联系人" @input="handleInputTrim($event, 'form', 'relationName')" />
						</el-form-item>
						<el-form-item label="销售经理" prop="salesManager">
							<el-input v-model="form.salesManager" placeholder="请输入销售经理" @input="handleInputTrim($event, 'form', 'salesManager')" />
						</el-form-item>
						<el-form-item label="老板姓名" prop="leader">
							<el-input v-model="form.leader" placeholder="请输入老板姓名" @input="handleInputTrim($event, 'form', 'leader')" />
						</el-form-item>
						<el-form-item label="老板电话" prop="leaderTel">
							<el-input v-model="form.leaderTel" placeholder="请输入老板电话" @input="handleInputTrim($event, 'form', 'leaderTel')" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="省" prop="province">
							<el-select v-model="form.province" placeholder="请选择省" @change="changeProvince">
								<el-option v-for="item in provinceList" :key="item.code" :label="item.name" :value="item.name"></el-option>
							</el-select>
						</el-form-item>
						<el-form-item label="市县" prop="city">
							<el-select v-model="form.city" placeholder="请选择市" @change="changeCity">
								<el-option v-for="item in cityList" :key="item.code" :label="item.name" :value="item.name"></el-option>
							</el-select>
						</el-form-item>
						<el-form-item label="乡镇" prop="county">
							<el-input v-model="form.county" placeholder="请输入乡镇" @input="handleInputTrim($event, 'form', 'county')" />
						</el-form-item>
						<el-form-item label="地址" prop="address">
							<el-input v-model="form.address" placeholder="请输入地址" @input="handleInputTrim($event, 'form', 'address')" />
						</el-form-item>
						<el-form-item label="备注" prop="comments">
							<el-input v-model="form.comments" placeholder="请输入备注" @input="handleInputTrim($event, 'form', 'comments')" />
						</el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!-- 银行卡 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="银行卡号" :visible.sync="dialogFormVisible">
			<el-form :model="currentInfo">
				<el-row :gutter="4" style="text-align: center">
					<span style="font-weight: bolder; font-size: 18px">{{ currentInfo.companyName }}</span>
				</el-row>
			</el-form>
			<br />
			<el-divider>已绑定银行卡</el-divider>
			<el-row>
				<el-table v-loading="loading" :data="singleInfo" @selection-change="handleSelectionChange">
					<template #append>
						<AddBankAccounts :company-info="currentInfo" :company-type="companyType" @callGetList="handleRefresh" />
					</template>
					<el-table-column label="户名" align="center" prop="acountsName" />
					<el-table-column label="银行卡号" align="center" prop="bankNo" />
					<el-table-column label="开户行" align="center" prop="bankName" />
					<el-table-column label="公司名称" align="center" prop="companyName" />
					<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
						<template slot-scope="scope">
							<el-button size="mini" type="primary" @click="handleEditBank(scope.row)">修改</el-button>
							<el-button v-hasPermi="['system:company:remove']" size="mini" type="danger" @click="handleDeleteBank(scope.row)">
								<i class="el-icon-delete"></i>
								删除
							</el-button>
							<el-button size="mini" type="primary" @click="handleSearchBank">搜索银行卡</el-button>
						</template>
					</el-table-column>
				</el-table>
			</el-row>
			<div slot="footer" class="dialog-footer">
				<el-button @click="dialogFormVisible = false">取 消</el-button>
				<el-button type="primary" @click="dialogFormVisible = false">确 定</el-button>
			</div>
			<pagination v-show="bankTotal > 0" :total="bankTotal" :page.sync="bankPageNum" :limit.sync="bankPageSize" @pagination="getBankList" />
		</el-dialog>

		<!-- 银行卡编辑对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="true" title="编辑银行卡信息" :visible.sync="editBankDialogVisible" width="500px" append-to-body>
			<el-form ref="editBankForm" :model="editBankForm" :rules="editBankRules" label-width="100px">
				<el-form-item label="账户类型" prop="acountsType">
					<el-select v-model="editBankForm.acountsType" placeholder="请选择账户类型" style="width: 100%">
						<el-option label="己方公司" value="己方公司"></el-option>
						<el-option label="客户" value="客户"></el-option>
						<el-option label="供应商" value="供应商"></el-option>
						<el-option label="司机" value="司机"></el-option>
						<el-option label="其他" value="其他"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="账户名" prop="acountsName">
					<el-input v-model="editBankForm.acountsName" placeholder="请输入账户名"></el-input>
				</el-form-item>
				<el-form-item label="银行卡号" prop="bankNo">
					<el-input v-model="editBankForm.bankNo" placeholder="请输入银行卡号"></el-input>
				</el-form-item>
				<el-form-item label="开户行" prop="bankName">
					<el-input v-model="editBankForm.bankName" placeholder="请输入开户行"></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button @click="editBankDialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="submitEditBank">确 定</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { delBankAccount, listBankAccount, updateBankAccount } from '@/api/system/bankAccount';
import { addCompany, checkCustomerIsExit, delCompany, getCompany, listCompany, updateCompany } from '@/api/system/company';
import { excludeParams } from '@/api/tool/exclude';
import { INFO_TYPE, isUsed } from '@/api/system/isUsed';
import AddBankAccounts from '@/views/dashboard/components/company/AddBankAccounts.vue';
import CompanyEditHistoryDialog from '@/views/dashboard/components/company/CompanyEditHistoryDialog.vue';
import { PUBLIC_DICT_TYPE } from '@/api/tool/enums';
import _ from 'lodash';

export default {
	name: 'Company',
	components: { AddBankAccounts, CompanyEditHistoryDialog },
	data() {
		return {
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			companyList: [],
			title: '',
			open: false,
			historyDialogVisible: false,
			historyCompanyId: null,
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				companyName: null,
				relationName: null,
				relationTel: null,
				address: null,
				bankName: null,
				acountsName: null,
				bankNo: null,
				surplusMoney: null,
				companyType: PUBLIC_DICT_TYPE.CUSTOMER,
				salesman: null,
				leader: null,
				leaderTel: null,
				region: null,
				salesManager: null,
				province: null,
				city: null,
				county: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			form: {},
			rules: {
				companyName: [{ required: true, message: '客户名称不能为空', trigger: 'blur' }],
				relationName: [{ required: true, message: '联系人不能为空', trigger: 'blur' }],
				salesManager: [{ required: true, message: '销售经理不能为空', trigger: 'blur' }]
			},
			columns: [
				{ key: 0, label: 'ID', visible: true },
				{ key: 1, label: '客户名称', visible: true },
				{ key: 2, label: '老板姓名', visible: true },
				{ key: 3, label: '老板电话', visible: true },
				{ key: 4, label: '联系人', visible: true },
				{ key: 5, label: '联系电话', visible: true },
				{ key: 6, label: '销售经理', visible: true },
				{ key: 7, label: '区域', visible: true },
				{ key: 8, label: '地址', visible: true },
				{ key: 9, label: '备注', visible: true }
			],
			dialogFormVisible: false,
			currentInfo: {
				companyType: PUBLIC_DICT_TYPE.CUSTOMER,
				relationName: '',
				bankNo: '',
				bankName: '',
				acountsName: ''
			},
			singleInfo: [],
			currentID: '',
			bankTotal: 0,
			bankPageSize: 20,
			bankPageNum: 1,
			provinceList: [],
			cityList: [],
			districtList: [],
			editBankDialogVisible: false,
			editBankForm: {
				id: null,
				companyId: null,
				acountsType: '',
				acountsName: '',
				bankNo: '',
				bankName: ''
			},
			editBankRules: {
				acountsType: [{ required: true, message: '账户类型不能为空', trigger: 'blur' }],
				acountsName: [{ required: true, message: '账户名不能为空', trigger: 'blur' }],
				bankNo: [{ required: true, message: '银行卡号不能为空', trigger: 'blur' }],
				bankName: [{ min: 0, max: 1000, message: '开户行长度不能超过1000个字符', trigger: 'blur' }]
			}
		};
	},
	computed: {
		companyType() {
			return PUBLIC_DICT_TYPE.CUSTOMER;
		}
	},
	watch: {
		'form.province'(val) {
			this.provinceList.forEach(item => {
				if (item.name === val) {
					this.cityList = item.areaList || [];
				}
			});
		},
		'form.city'(val) {
			(this.cityList || []).forEach(item => {
				if (item.name === val) {
					this.districtList = item.areaList || [];
				}
			});
		}
	},
	created() {
		this.getList();

		fetch('/area.json')
			.then(res => res.json())
			.then(res => {
				this.provinceList = res;
			});
	},
	methods: {
		/** 表格单元格样式 */
		cellStyle() {
			return { padding: '.5px' };
		},

		handleInputTrim(val, obj, prop) {
			if (val.indexOf(' ') !== -1) {
				this[obj][prop] = val.replace(/\s+/g, '');
			}
		},

		handleEditBank(row) {
			this.editBankForm = {
				id: row.id,
				companyId: row.companyId || this.currentInfo.id,
				acountsType: row.acountsType || this.companyType,
				acountsName: row.acountsName,
				bankNo: row.bankNo,
				bankName: row.bankName
			};
			this.editBankDialogVisible = true;
		},

		submitEditBank() {
			this.$refs['editBankForm'].validate(valid => {
				if (valid) {
					updateBankAccount(this.editBankForm).then(() => {
						this.$modal.msgSuccess('修改成功');
						this.editBankDialogVisible = false;
						this.getBankList();
					});
				}
			});
		},

		handleRefresh() {
			this.getBankList();
		},

		handleDeleteBank(row) {
			this.$modal
				.confirm('是否确认删除该银行卡信息？')
				.then(() => delBankAccount(row.id))
				.then(() => {
					this.$modal.msgSuccess('删除成功');
					this.getBankList();
				})
				.catch(() => {});
		},

		handleSearchBank() {
			this.$message.info('搜索银行卡功能待实现');
		},

		changeProvince(e) {
			this.province = e;
			this.$set(this.form, 'city', null);
			this.$set(this.form, 'county', null);
			this.districtList = [];
		},
		changeCity(e) {
			this.city = e;
			this.$set(this.form, 'county', null);
		},

		/** 点击银行卡后弹窗 */
		jumpBankNo(row) {
			this.currentID = row.id;
			this.currentInfo = _.assign({}, this.currentInfo, {
				relationName: row.relationName,
				id: row.id,
				relationTel: row.relationTel,
				address: row.address,
				surplusMoney: row.surplusMoney,
				salesman: row.salesman,
				leader: row.leader,
				leaderTel: row.leaderTel,
				region: row.region,
				salesManager: row.salesManager,
				province: row.province,
				city: row.city,
				county: row.county,
				comments: row.comments,
				companyName: row.companyName
			});
			listBankAccount({
				companyId: row.id,
				acountsType: this.companyType,
				pageNum: this.bankPageNum,
				pageSize: this.bankPageSize
			}).then(res => {
				this.singleInfo = res.rows || [];
				this.bankTotal = res.total || 0;
				this.dialogFormVisible = true;
			});
		},

		/** 查询已绑定的银行卡信息 */
		getBankList() {
			if (!this.currentID) return;
			listBankAccount({
				companyId: this.currentID,
				acountsType: this.companyType,
				pageNum: this.bankPageNum,
				pageSize: this.bankPageSize
			}).then(res => {
				this.singleInfo = res.rows || [];
				this.bankTotal = res.total || 0;
			});
		},

		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*']
			});
		},

		getList() {
			this.loading = true;
			listCompany(this.queryParams).then(response => {
				this.companyList = response.rows || [];
				this.total = response.total || 0;
				this.loading = false;
			});
		},

		handleCheckIsExits() {
			if (!this.form.companyName) return;
			const exitId = _.cloneDeep(this.form.id);
			const check = exitId ? checkCustomerIsExit(this.form.companyName, exitId) : checkCustomerIsExit(this.form.companyName, null);
			check.then(res => {
				if (!res.data) {
					this.$message.error(exitId ? `检查时出现错误 ${this.form.companyName} 已存在!` : `客户 ${this.form.companyName} 已存在,请修改单据信息`);
				}
			});
		},

		/** 获取初始表单 */
		getInitForm() {
			return {
				id: null,
				companyName: null,
				relationName: null,
				relationTel: null,
				address: null,
				bankName: null,
				acountsName: null,
				bankNo: null,
				surplusMoney: null,
				companyType: PUBLIC_DICT_TYPE.CUSTOMER,
				salesman: null,
				leader: null,
				leaderTel: null,
				region: null,
				salesManager: null,
				province: null,
				city: null,
				county: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};
		},

		cancel() {
			this.open = false;
			this.reset();
		},

		reset() {
			this.form = this.getInitForm();
			this.$refs.form?.resetFields();
		},

		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},

		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},

		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},

		handleAdd() {
			this.form = this.getInitForm();
			this.open = true;
			this.title = '添加客户信息';
		},

		handleViewEditHistory(row) {
			this.historyCompanyId = row.id;
			this.historyDialogVisible = true;
		},

		openCompanyEditForm(companyData) {
			this.form = JSON.parse(JSON.stringify(companyData));
			this.open = true;
			this.title = '修改客户信息';
		},

		handleUpdate(row) {
			this.form = this.getInitForm();
			const id = row.id || this.ids;
			getCompany(id, PUBLIC_DICT_TYPE.CUSTOMER)
				.then(response => {
					const companyData = response.data;
					if (!companyData) {
						this.$message.error('获取客户信息失败');
						return;
					}
					if (companyData.shouldTrackEditReason === true) {
						this.$prompt('请输入修改原因', '提示', {
							confirmButtonText: '确定',
							cancelButtonText: '取消',
							inputType: 'textarea',
							inputPlaceholder: '请输入修改原因',
							inputValidator: value => (!value || value.trim() === '' ? '修改原因不能为空' : true)
						})
							.then(({ value }) => {
								this.openCompanyEditForm({ ...companyData, editReason: value.trim() });
							})
							.catch(() => {
								this.$message.info('已取消修改');
							});
						return;
					}
					this.openCompanyEditForm(companyData);
				})
				.catch(() => {
					this.$message.error('获取客户信息失败');
				});
		},

		submitForm() {
			this.$refs['form'].validate(valid => {
				if (!valid) return;
				const data = excludeParams({ ...this.form }, this.$exclude);
				delete data.shouldTrackEditReason;
				data.companyType = PUBLIC_DICT_TYPE.CUSTOMER;
				data.delFlag = null;
				data.addtime = null;
				data.updateTime = null;
				data.userId = null;
				if (this.form.id != null) {
					checkCustomerIsExit(this.form.companyName, this.form.id).then(res => {
						if (res.data) {
							updateCompany(data).then(() => {
								this.$modal.msgSuccess('修改成功');
								this.open = false;
								this.reset();
								this.getList();
							});
						} else {
							this.$message.error('修改时出现错误:该行ID已存在客户信息,但数据返回不存在');
						}
					});
				} else {
					checkCustomerIsExit(this.form.companyName, null).then(res => {
						if (!res.data) {
							this.$message.error('客户已存在,不允许新增!');
							return;
						}
						addCompany(data).then(() => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getList();
						});
					});
				}
			});
		},

		handleDelete(row) {
			const ids = row.id || this.ids;
			const query = { id: ids, type: INFO_TYPE.CUSTOMER };
			this.$modal
				.confirm('是否确认删除编号为"' + ids + '"的数据项？')
				.then(() => {
					isUsed(query).then(res => {
						if (res.data.isUsed) {
							this.$modal
								.confirm('系统检测该信息:"' + ids + '"的客户数据在系统中被使用，是否要继续删除?')
								.then(() => delCompany(ids, PUBLIC_DICT_TYPE.CUSTOMER))
								.then(() => {
									this.getList();
									this.$modal.msgSuccess('删除成功');
								})
								.catch(() => {});
						} else {
							delCompany(ids, PUBLIC_DICT_TYPE.CUSTOMER).then(() => {
								this.getList();
								this.$modal.msgSuccess('删除成功');
							});
						}
					});
				})
				.catch(() => {});
		},

		handleExport() {
			this.download('system/company/export', { ...this.queryParams }, `客户管理_${new Date().getTime()}.xlsx`);
		}
	}
};
</script>
