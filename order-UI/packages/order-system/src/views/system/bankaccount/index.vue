<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="类型" prop="acountsType">
				<el-select v-model="queryParams.acountsType" placeholder="请选择">
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item label="开户名" prop="acountsName">
				<el-input v-model="queryParams.acountsName" placeholder="请输入开户名" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'acountsName')" />
			</el-form-item>
			<el-form-item label="银行账号" prop="bankNo">
				<el-input v-model="queryParams.bankNo" placeholder="请输入银行账号" clearable @keyup.enter.native="handleQuery" @input="handleInputTrim($event, 'queryParams', 'bankNo')" />
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
				<el-button v-hasPermi="['system:bankaccount:add']" type="danger" size="mini" @click="handleAdd">新增银行卡信息</el-button>
			</el-col>
			<el-col :span="1.5">
				<BankAccountChangeDash />
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:bankaccount:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<!-- 打印内容 -->
		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="bankAccountList"
			height="450px"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column v-if="columns[0].visible" label="绑定状态" align="center">
				<template slot-scope="scope">
					<span v-if="scope.row.companyId === 0" style="color: #138fe1">己方公司银行卡</span>
					<span v-else-if="scope.row.companyId === -1" style="color: #ff5722">该卡未被绑定</span>
					<span v-else>已绑定</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[1].visible" label="账户类型" align="center" prop="acountsType" />
			<el-table-column v-if="columns[2].visible" label="公私户类型" align="center" prop="isPublicAccount">
				<template slot-scope="scope">
					<span v-if="scope.row.isPublicAccount === 0" style="color: #138fe1">私户</span>
					<span v-else-if="scope.row.isPublicAccount === 1" style="color: #ff5722">公户</span>
					<span v-else>未区分</span>
				</template>
			</el-table-column>
			<el-table-column v-if="columns[3].visible" label="我方公司" align="center" prop="displayName" />
			<el-table-column v-if="columns[7].visible" label="公司名称/车牌号" align="center" prop="companyName" />
			<el-table-column v-if="columns[4].visible" label="开户名称" align="center" prop="acountsName" />
			<el-table-column v-if="columns[5].visible" label="银行账号" align="center" prop="bankNo" />
			<el-table-column v-if="columns[6].visible" label="开户行" align="center" prop="bankName" />

			<!-- 余额的展示 分为现金户和承兑户的展示 -->
			<!-- bankAccountList需要在data中声明一个默认的属性 cardTypeBalances 不然会报undefined-->

			<el-table-column align="center" v-for="element in typeList" :key="element" :label="element">
				<template slot-scope="scope">
					{{ scope.row.cardTypeBalances | handleArray(element) }}
				</template>
			</el-table-column>
			<el-table-column label="银行卡操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-row>
						<el-button size="mini" type="text" @click="checkBankChangeFlow(scope.row)">变动流水</el-button>
					</el-row>
				</template>
			</el-table-column>
			<el-table-column label="行操作" align="center" class-name="small-padding fixed-width">
				<template slot-scope="scope">
					<el-row>
						<el-button v-hasPermi="['system:bankaccount:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">编辑</el-button>
						<el-button v-hasPermi="['system:bankaccount:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
					</el-row>
				</template>
			</el-table-column>
		</el-table>
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改银行账号对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="120px" @keyup.enter.native="submitForm" @submit.native.prevent="submitForm">
				<!--        选择账号类型 分为：司机、公司、己方公司等等-->
				<el-form-item label="账号类型" prop="acountsType">
					<el-select v-model="form.acountsType" placeholder="请选择账号类型">
						<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
					</el-select>
				</el-form-item>
				<!--        如果选择了己方公司 还要选择一个公私户类型-->
				<div>
					<el-row v-if="form.acountsType === PUBLIC_DICT_TYPE.SELF_COMPANY">
						<el-form-item label="公私户类型" prop="isPublicAccount">
							<el-radio v-model="form.isPublicAccount" :label="1">公户</el-radio>
							<el-radio v-model="form.isPublicAccount" :label="0">私户</el-radio>
						</el-form-item>
					</el-row>
				</div>
				<!--  如果是司机 要选择车牌号 -->
				<el-form-item label="车牌号" prop="companyName" v-if="form.acountsType === PUBLIC_DICT_TYPE.DRIVER">
					<el-row>
						<el-col :span="20">
							<el-input v-model="form.companyName" placeholder="请输入车牌号" @input="handleInputTrim($event, 'form', 'companyName')" />
						</el-col>
						<SearchOption
							:limit-info="{}"
							:get-data="listCars"
							query-info="carNo"
							query-label="车牌查找"
							:query-name="queryBankAccount"
							@update:queryName="handleUpdateBankAccount"
							@commitBack="handleCommitBackBankAccount"
						>
							<template #table-columns>
								<el-table-column label="司机" align="center" prop="driver" />
								<el-table-column label="车牌号" align="center" prop="carNo" />
								<el-table-column label="司机电话" align="center" prop="tel" />
								<el-table-column label="开户名" align="center" prop="acountsName" />
								<el-table-column label="账号" align="center" prop="bankNo" />
								<el-table-column label="开户行" align="center" prop="bankName" />
								<el-table-column label="运输方式" align="center" prop="carType" />
							</template>
						</SearchOption>
					</el-row>
				</el-form-item>

				<!--          车牌-->
				<el-form-item label="户名" prop="acountsName" v-if="form.acountsType === PUBLIC_DICT_TYPE.DRIVER">
					<el-row>
						<el-input v-model="form.acountsName" placeholder="请输入司机户名" @input="handleInputTrim($event, 'form', 'acountsName')" />
					</el-row>
				</el-form-item>
				<el-form-item v-if="isNeed" :label="showLabel" prop="companyName">
					<el-row>
						<el-col :span="10">
							<el-input v-model="form.companyName" placeholder="请输入" @input="handleInputTrim($event, 'form', 'companyName')" />
						</el-col>
						<!-- 我方员工信息搜索-->
						<el-col v-if="form.acountsType === PUBLIC_DICT_TYPE.EMPLOYEE" :span="4">
							<SearchOption
								:limit-info="{}"
								:get-data="listUser"
								query-label="姓名"
								:query-name="queryUser"
								query-info="trueName"
								@commitBack="handleCommitBackUser"
								@update:queryName="handleQueryUser"
							>
								<template #table-columns>
									<el-table-column key="nickName" label="员工" align="center" prop="trueName" :show-overflow-tooltip="true" />
									<el-table-column key="deptName" label="岗位" align="center" prop="postName" :show-overflow-tooltip="true" />
									<el-table-column label="手机号码" align="center" prop="phonenumber" width="120" />
									<el-table-column label="就职状态" align="center" prop="state" width="120" />
									<el-table-column label="入职时间" align="center" prop="startDate" width="120" />
									<el-table-column label="身份证号码" align="center" prop="iDCard" width="120" />
									<el-table-column label="性别" align="center" prop="sex" width="120" />
									<el-table-column label="出生日期" align="center" prop="birthday" width="120" />
									<el-table-column label="民族" align="center" prop="nation" width="120" />
									<el-table-column label="政治面貌" align="center" prop="politicalStatus" width="120" />
									<el-table-column label="婚姻状况" align="center" prop="maritalStatus" width="120" />
									<el-table-column label="户籍地址" align="center" prop="domicileAddress" width="120" />
									<el-table-column label="居住地址" align="center" prop="residentialAddress" width="120" />
									<el-table-column label="紧急联系人" align="center" prop="relationPerson" width="120" />
									<el-table-column label="紧急联系人电话" align="center" prop="relationPersonTel" width="120" />
								</template>
							</SearchOption>
						</el-col>
						<el-col :span="2" v-if="form.acountsType === PUBLIC_DICT_TYPE.EMPLOYEE">
							<el-tooltip class="item" effect="dark" content="若未找到员工可能是您权限不够,请设置权限后再做选择" placement="top-start">
								<el-icon class="el-icon-warning" style="color: red" />
							</el-tooltip>
						</el-col>
						<!-- 供应商信息搜索-->
						<el-col v-if="form.acountsType === PUBLIC_DICT_TYPE.SUPPLIER" :span="2">
							<SearchOption
								title="供应商信息"
								:limit-info="{ companyType: '供应商' }"
								:get-data="listCompany"
								@commitBack="handleCommitBackCompanyGive"
								@update:queryName="handleQueryCompanyGive"
								query-info="companyName"
								query-label="公司名称"
								:query-name="queryCompanyGive"
							>
								<template #table-columns>
									<el-table-column label="供应商" align="center" prop="companyName" />
									<el-table-column label="地址" align="center" prop="address" />
								</template>
							</SearchOption>
						</el-col>
						<!-- 客户信息搜索-->
						<el-col v-if="form.acountsType === PUBLIC_DICT_TYPE.CUSTOMER" :span="2">
							<SearchOption
								title="客户信息"
								:limit-info="{ companyType: '客户' }"
								:get-data="listCompany"
								@commitBack="handleCommitBackCompany"
								@update:queryName="handleQueryCompany"
								query-info="companyName"
								query-label="公司名称"
								:query-name="queryCompany"
							>
								<template #table-columns>
									<el-table-column label="客户" align="center" prop="companyName" />
									<el-table-column label="老板姓名" align="center" prop="leader" />
									<el-table-column label="老板电话" align="center" prop="leaderTel" />
									<el-table-column label="销售经理" align="center" prop="salesManager" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<!--          如果不是司机 直接填写开户名-->
				<el-form-item prop="acountsName" label="户名" v-if="form.acountsType !== PUBLIC_DICT_TYPE.DRIVER">
					<el-row>
						<el-input v-model="form.acountsName" placeholder="请输入开户名" @input="handleInputTrim($event, 'form', 'acountsName')" />
					</el-row>
				</el-form-item>
				<el-form-item label="银行账号" prop="bankNo">
					<el-input v-model="form.bankNo" placeholder="请输入银行账号" @input="handleInputTrim($event, 'form', 'bankNo')" />
				</el-form-item>
				<el-form-item :label="'开户行'" :prop="form.acountsType === PUBLIC_DICT_TYPE.SELF_COMPANY ? 'bankNameRequired' : 'bankName'">
					<el-input v-model="form.bankName" placeholder="请输入开户行" @input="handleInputTrim($event, 'form', 'bankName')" />
				</el-form-item>

				<!--        我方公司 只有己方公司才会区分-->
				<el-form-item v-if="form.acountsType === PUBLIC_DICT_TYPE.SELF_COMPANY" label="我方公司" prop="displayName">
					<el-input v-model="form.displayName" placeholder="请输入我方公司" @input="handleInputTrim($event, 'form', 'displayName')" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    银行卡流水-->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="银行卡流水"
			:visible.sync="bankChangeDialogVisible"
			width="850px"
			append-to-body
		>
			<el-row>
				<div>
					<el-form :model="bankAcountQuery" label-width="80px" :inline="true">
						<el-form-item label="开始日期" prop="params.operateDateStartTime">
							<el-date-picker v-model="bankAcountQuery.params.operateDateStartTime" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="日期" size="mini" />
						</el-form-item>
						<el-form-item label="结束日期" prop="params.operateDateEndTime">
							<el-date-picker v-model="bankAcountQuery.params.operateDateEndTime" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="日期" size="mini" />
						</el-form-item>
						<el-form-item>
							<el-button type="primary" size="mini" @click="getBankAcountChangeList">搜索</el-button>
						</el-form-item>
					</el-form>
				</div>
				<el-table :data="bankChangeList" style="width: 100%">
					<el-table-column prop="selfBankNo" label="我方账号" width="180"></el-table-column>
					<el-table-column prop="operateDate" label="日期" width="180"></el-table-column>
					<el-table-column prop="changeType" label="变动类型"></el-table-column>
					<el-table-column prop="moneyAmount" label="金额"></el-table-column>
				</el-table>
				<pagination
					v-show="bankAcountTotal > 0"
					:total="bankAcountTotal"
					:page.sync="bankAcountQuery.bankAcountTotalPageNum"
					:limit.sync="bankAcountQuery.bankAcountTotalPageSize"
					@pagination="getBankAcountChangeList"
				/>
			</el-row>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitBankChange">确 定</el-button>
				<el-button @click="bankChangeDialogVisible = false">取 消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { addBankAccount, delBankAccount, getBankAccount, updateBankAccount } from '@/api/system/bankAccount';
import { addBankAccountChange, listBankAccountChange } from '@/api/system/bankAccountChange';
import { listCompany } from '@/api/system/company';
import SearchOption from '@/components/SearchOption.vue';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import keepAliveDialog from '@/views/dashboard/mixins/keepAliveDialog';
import BankAccountChangeDash from '../Statement/bankAccountChangeDash.vue';
import { listUser } from '@/api/system/user';
import { listCars } from '@/api/system/cars';
import { excludeParams } from '@/api/tool/exclude';
import { listBankAccount } from '../../../api/system/bankAccount';

export default {
	name: 'BankAccount',
	components: { SearchOption, BankAccountChangeDash },
	mixins: [mixin_printHTML, keepAliveDialog],
	data() {
		return {
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			// 银行卡列表
			bankAccountList: [],
			// 类型列表
			typeList: [],
			title: '',
			open: false,
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				companyName: null,
				companyId: null,
				bankName: null,
				acountsName: null,
				bankNo: null,
				acountsType: null,
				amount: null,
				comments: null,
				delFlag: null
			},
			// 查询供应商
			queryParamsCompany: {
				pageNum: 1,
				pageSize: 10,
				companyName: null,
				relationName: null,
				relationTel: null,
				address: null,
				bankName: null,
				acountsName: null,
				bankNo: null,
				surplusMoney: null,
				companyType: null,
				salesman: null,
				leader: null,
				leaderTel: null,
				salesManager: null,
				province: null,
				city: null,
				county: null,
				comments: null
			},
			// 表单参数
			form: {
				bankNo: '',
				bankName: '',
				acountsName: '',
				companyName: '',
				acountsType: ''
			},
			// 表单校验
			rules: {
				bankNo: [
					{
						required: true,
						message: '银行账号不能为空',
						trigger: 'blur'
					}
				],
				acountsName: [
					{
						required: true,
						message: '账户名称不能为空',
						trigger: 'blur'
					}
				],
				acountsType: [
					{
						required: true,
						message: '账户类型不能为空',
						trigger: 'blur'
					}
				],
				companyName: [
					{
						required: true,
						message: '公司名称不能为空',
						trigger: 'blur'
					}
				],
				companyType: [
					{
						required: true,
						message: '公司类型不能为空',
						trigger: 'blur'
					}
				],
				bankNameRequired: [
					{
						required: true,
						message: '开户行不能为空',
						trigger: 'blur'
					}
				]
			},
			// 对方类型
			options: [
				{
					value: '己方公司',
					label: '己方公司'
				},
				{
					value: '客户',
					label: '客户'
				},
				{
					value: '供应商',
					label: '供应商'
				},
				{
					value: '司机',
					label: '司机'
				},
				{
					value: '其它',
					label: '其它'
				},
				{
					value: '员工',
					label: '员工'
				}
			],
			// 隐藏列信息
			columns: [
				{ key: 0, label: `绑定状态`, visible: true },
				{ key: 1, label: `账户类型`, visible: true },
				{ key: 2, label: `公私户类型`, visible: true },
				{ key: 3, label: `我方公司`, visible: true },
				{ key: 4, label: `开户名称`, visible: true },
				{ key: 5, label: `银行账号`, visible: true },
				{ key: 6, label: `开户行`, visible: true },
				{ key: 7, label: `公司名称`, visible: true }
			],
			companyList: [],
			// 调整银行卡
			Adjustment: false,
			adjustmentInfo: {},
			AdjustInfo: {},
			// 银行卡之间转账
			transformDialogVisible: false,
			transformInfo: {
				fromBankNo: null,
				toBankNo: null,
				money: null
			},
			// 银行卡流水
			bankChangeDialogVisible: false,
			bankChangeList: [],
			currentBankNo: '',
			bankAcountQuery: {
				bankAcountTotalPageNum: 1,
				bankAcountTotalPageSize: 10,
				params: {
					operateDateEndTime: null,
					operateDateStartTime: null
				}
			},
			bankAcountTotal: 0,
			// 用户搜索字段
			queryUser: '',
			// 供应商搜索组件
			queryCompanyGive: '',
			queryCompany: '',
			// 银行卡搜索组件
			queryBankAccount: ''
		};
	},
	computed: {
		// 公共字典
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		// 是否是己方公司
		isNeed() {
			return this.form.acountsType !== '己方公司' && this.form.acountsType !== '司机';
		},
		showLabel() {
			if (this.form.acountsType) {
				return this.options.find(item => item.value === this.form.acountsType).value + '名称';
			} else {
				return '公司名称';
			}
		}
	},
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('bankaccount-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('bankaccount-columns') === 'null' || !localStorage.getItem('bankaccount-columns')) {
			localStorage.setItem('bankaccount-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('bankaccount-columns'));
		}
	},
	filters: {
		// values 为被筛选的数据 prop为自定义传入的属性
		handleArray(values, prop) {
			const target = values.filter(item => item.bankCardType === prop);
			return target.length === 0 ? '无数据' : target[0].amount;
		}
	},
	methods: {
		// 处理输入框禁止输入空格
		handleInputTrim(val, obj, prop) {
			if (val.indexOf(' ') !== -1) {
				this[obj][prop] = val.replace(/\s+/g, '');
			}
		},
		listUser,
		listCars,
		listBankAccount,
		listCompany,
		// 2.查询客户 供应商信息
		getCompanyInfo() {
			listCompany(this.queryParamsCompany).then(res => {
				this.companyList = res.rows;
			});
		},
		// 3.银行卡变动流水
		checkBankChangeFlow(row) {
			this.currentBankNo = row.bankNo;
			// 查询该银行账号的变动流水
			listBankAccountChange({ selfBankNo: row.bankNo }).then(res => {
				this.bankChangeList = res.rows;
				this.bankAcountTotal = res.total;
				this.bankChangeDialogVisible = true;
			});
		},
		// 分页的请求
		getBankAcountChangeList() {
			listBankAccountChange({
				selfBankNo: this.currentBankNo,
				pageNum: this.bankAcountQuery.bankAcountTotalPageNum,
				pageSize: this.bankAcountQuery.bankAcountTotalPageSize,
				...this.bankAcountQuery
			}).then(res => {
				this.bankChangeList = res.rows;
				this.bankAcountTotal = res.total;
			});
		},
		submitBankChange() {
			this.bankChangeDialogVisible = false;
		},
		// 搜索员工信息的回调
		handleQueryUser(val) {
			this.queryUser = val;
		},
		handleCommitBackUser(val) {
			this.form.companyName = val.trueName;
			this.form.companyId = val.userId;
		},
		// 搜索供应商信息的回调
		handleCommitBackCompanyGive(val) {
			this.form.companyName = val.companyName;
			this.form.companyId = val.id;
		},
		// 客户信息的回调
		handleCommitBackCompany(val) {
			this.form.companyName = val.companyName;
			this.form.companyId = val.id;
		},
		handleQueryCompanyGive(value) {
			this.queryCompanyGive = value;
		},
		handleQueryCompany(value) {
			this.queryCompany = value;
		},
		// 搜索银行卡信息
		handleCommitBackBankAccount(val) {
			// this.form.acountsName = val.acountsName;
			this.form.companyId = val.id;
			this.form.companyType = '司机';
			// 司机信息公司默认给的是司机
			this.form.companyName = val.carNo;
		},
		handleUpdateBankAccount(val) {
			this.queryBankAccount = val;
		},
		// 调整银行卡
		submitAdjustmentInfo() {
			const { bankNo } = this.AdjustInfo;
			addBankAccountChange({
				selfBankNo: bankNo,
				payNO: '手动调整',
				...this.adjustmentInfo
			}).then(() => {
				this.$message.success('调整成功~');
				this.Adjustment = false;
				this.getList();
			});
		},
		// 查询列表
		getList() {
			this.loading = true;
			listBankAccount(this.queryParams).then(response => {
				// 先拿到类型列表
				this.typeList = this.getAllTypes(response.rows);
				this.bankAccountList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 获取所有的类型
		getAllTypes(bankAccounts) {
			// 收集所有的可能
			let types = new Set();
			bankAccounts.forEach(element => {
				element.cardTypeBalances.forEach(item => {
					types.add(item.bankCardType);
				});
			});
			return Array.from(types);
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
				companyName: null,
				companyId: null,
				bankName: null,
				isPublicAccount: null, // 公私户
				acountsName: null,
				bankNo: null,
				acountsType: null,
				amount: null,
				comments: null,
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
			this.title = '新增银行卡信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			// 获取银行卡的信息
			getBankAccount(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改银行卡信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 如果id不为空 那么就是修改操作
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						updateBankAccount(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
						// 否则就是添加操作
					} else {
						// 去除参数
						this.form = excludeParams(this.form, this.$exclude);
						// 如果不填公司id
						if (!this.form.companyId) {
							// 如果是己方公司
							if (this.form.acountsType === PUBLIC_DICT_TYPE.SELF_COMPANY) {
								this.form.companyId = 0;
								// 填充公司名称为己方公司
								this.form.companyName = PUBLIC_DICT_TYPE.SELF_COMPANY;
							} else {
								// 其他银行卡填充-1 表示还没绑定
								this.form.companyId = -1;
							}
						}
						// 添加银行卡信息
						addBankAccount(this.form).then(() => {
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
				.confirm('是否确认删除银行账号编号为"' + ids + '"的数据项？')
				.then(function () {
					return delBankAccount(ids);
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
				'system/bankAccount/export',
				{
					...this.queryParams
				},
				`bankAccount_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
