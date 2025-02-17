<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px" class="form-container">
			<el-form-item label="客户名称" prop="relationName">
				<el-input v-model="queryParams.relationName" placeholder="请输入客户名称" clearable @keyup.enter.native="handleQuery" />
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
			<!--      新增银行卡信息-->
			<!--      <AddBankAccounts :company-type="'客户'"/>-->

			<!--      右侧工具栏-->
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:company:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="companyList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			@selection-change="handleSelectionChange"
			class="table-container"
		>
			<el-table-column v-if="columns[0].visible" label="客户名称" align="center" prop="companyName" width="180" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="老板姓名" align="center" prop="leader" width="180" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="老板电话" align="center" prop="leaderTel" width="180" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="区域" align="center" prop="region" width="180" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="联系人" align="center" prop="relationName" width="180" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="销售经理" align="center" prop="salesManager" width="180" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="地址" align="center" prop="address" width="150" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="电话" align="center" prop="relationTel" width="180" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="备注" align="center" prop="comments" width="180" show-overflow-tooltip />
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="180">
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="jumpBankNo(scope.row)">银行卡号</el-button>
					<el-button v-hasPermi="['system:company:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">编辑</el-button>
					<el-button v-hasPermi="['system:company:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改客户、供应商信息对话框 -->
		<el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="54%" append-to-body class="dialog-container">
			<el-form ref="form" :model="form" :rules="rules" label-width="110px">
				<el-row :gutter="4">
					<el-col :span="12">
						<el-form-item label="客户名称" prop="companyName">
							<el-input v-model="form.companyName" placeholder="请输入客户名称" />
						</el-form-item>
						<el-form-item label="联系人" prop="relationName">
							<el-input v-model="form.relationName" placeholder="请输入联系人名称" />
						</el-form-item>
						<el-form-item label="联系人电话" prop="relationTel">
							<el-input v-model="form.relationTel" placeholder="请输入联系人电话" />
						</el-form-item>
						<el-form-item label="老板姓名" prop="leader">
							<el-input v-model="form.leader" placeholder="请输入老板姓名" />
						</el-form-item>
						<el-form-item label="老板联系方式" prop="leaderTel">
							<el-input v-model="form.leaderTel" placeholder="请输入老板联系方式" />
						</el-form-item>
						<!--						<el-form-item label="录入员" prop="salesman">-->
						<!--							<el-input-->
						<!--								v-model="form.salesman"-->
						<!--								placeholder="请输入录入员名称"-->
						<!--							/>-->
						<!--						</el-form-item>-->
					</el-col>
					<el-col :span="12">
						<el-form-item label="销售经理" prop="salesManager">
							<el-input v-model="form.salesManager" placeholder="请输入销售经理" />
						</el-form-item>
						<el-form-item label="省" prop="province">
							<!--          <el-input v-model="form.province" placeholder="请输入省"/>-->
							<el-select v-model="form.province" placeholder="请选择省" @change="changeProvince">
								<el-option v-for="item in provinceList" :key="item.code" :label="item.name" :value="item.name"></el-option>
							</el-select>
						</el-form-item>
						<el-form-item label="市县" prop="city">
							<!--          <el-input v-model="form.city" placeholder="请输入市县"/>-->
							<el-select v-model="form.city" placeholder="请选择市" @change="changeCity">
								<el-option v-for="item in cityList" :key="item.code" :label="item.name" :value="item.name"></el-option>
							</el-select>
						</el-form-item>
						<el-form-item label="乡镇" prop="county">
							<el-input v-model="form.county" placeholder="请输入乡镇" />
						</el-form-item>
						<el-form-item label="地址" prop="address">
							<el-input v-model="form.address" placeholder="请输入地址" />
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

		<!--    账号搜索-->
		<el-dialog :close-on-click-modal="false" :show-close="true" title="账号搜索" :visible.sync="dialogFormSearchVisible" width="60%" class="dialog-container">
			<el-form :model="queryParams">
				<el-row :gutter="4">
					<el-col :span="8">
						<el-form-item label="客户名称" :label-width="formLabelWidth">
							<el-input v-model="queryParams.relationName" autocomplete="off"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="8">
						<el-form-item label="银行卡号" :label-width="formLabelWidth">
							<el-input v-model="queryParams.bankNo" autocomplete="off"></el-input>
						</el-form-item>
					</el-col>
					<el-col :span="3">
						<el-button type="primary" @click="handleSearchCompanyGive">搜索</el-button>
					</el-col>
				</el-row>
			</el-form>
			<el-table v-loading="loading" :data="companyList" @selection-change="handleSelectionChange" class="table-container">
				<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="left" width="180">
					<template slot-scope="">
						<el-button type="danger" size="mini" @click="dialogFormSearchVisible = false">确认</el-button>
					</template>
				</el-table-column>
				<el-table-column label="客户名称" align="center" prop="relationName" />
				<el-table-column label="银行卡号" align="center" prop="bankNo" />
				<el-table-column label="户名" align="center" prop="acountsName" />
			</el-table>
			<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
		</el-dialog>

		<!--    搜索已绑定的银行卡信息-->
		<el-dialog :close-on-click-modal="false" :show-close="false" title="银行卡号" :visible.sync="dialogFormVisible" class="dialog-container">
			<el-form :model="currentInfo">
				<el-row :gutter="4" style="text-align: center">
					<span style="font-weight: bolder; font-size: 18px">
						{{ currentInfo.companyName }}
					</span>
				</el-row>
			</el-form>
			<br />

			<!-- <el-divider>默认银行卡信息</el-divider> -->
			<!-- <el-row>
        <el-row>
          <el-row v-if="defaultBankCardInfo.not !== true">
            <br />
            <el-descriptions>
              <el-descriptions-item label="户名">
                {{ defaultBankCardInfo.acountsName }}
              </el-descriptions-item>
              <el-descriptions-item label="开户行">
                {{ defaultBankCardInfo.bankName }}
              </el-descriptions-item>
              <el-descriptions-item label="银行卡号">
                {{ defaultBankCardInfo.bankNo }}
              </el-descriptions-item>
              <el-descriptions-item label="余额">
                <el-tag size="small">{{ defaultBankCardInfo.amount }}</el-tag>
              </el-descriptions-item>
            </el-descriptions>
          </el-row>
          <el-row v-else>
            <el-descriptions>
              <el-descriptions-item label=" 户名">暂无</el-descriptions-item>
              <el-descriptions-item label="开户行">暂无</el-descriptions-item>
              <el-descriptions-item label="银行卡号">暂无</el-descriptions-item>
              <el-descriptions-item label="余额">
                <el-tag size="small">暂无</el-tag>
              </el-descriptions-item>
              <el-descriptions-item>
                <el-button
                  size="mini"
                  type="primary"
                  @click="addDefaultCard($event)"
                >
                  添加默认银行卡
                </el-button>
              </el-descriptions-item>
            </el-descriptions>
          </el-row>
        </el-row>
      </el-row> -->
			<el-divider>已绑定银行卡</el-divider>
			<!--      客户的银行卡列表  应查询已经绑定的银行卡-->
			<el-row>
				<el-table v-loading="loading" :data="singleInfo" @selection-change="handleSelectionChange" class="table-container">
					<!--          为本公司绑定银行卡 拿到该客户的信息 然后进行添加银行卡的操作  通过companyId把银行卡和客户供应商绑定-->
					<template #append>
						<!--            <AddBank :company-info="currentInfo" @changeBankOpen="handleChangeBank"/>-->
						<AddBankAccounts :company-info="currentInfo" @callGetList="handleChangeBank" />
					</template>
					<el-table-column label="户名" align="center" prop="acountsName" />
					<el-table-column label="银行卡号" align="center" prop="bankNo" />
					<el-table-column label="银行卡余额" align="center" prop="amount" />
					<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="180">
						<template slot-scope="scope">
							<el-button v-hasPermi="['system:company:remove']" size="mini" @click="handleDeleteBankaccount(scope.row)">
								<i class="el-icon-delete"></i>
							</el-button>
							<!-- <el-button
                v-hasPermi="['system:company:edit']"
                size="mini"
                @click="addDefaultCard(scope.row)"
              >
                设置为默认
              </el-button> -->
						</template>
					</el-table-column>
				</el-table>
			</el-row>
			<div slot="footer" class="dialog-footer">
				<el-button @click="dialogFormVisible = false">取 消</el-button>
				<el-button type="primary" @click="dialogFormVisible = false">确 定</el-button>
			</div>
			<pagination v-show="bankTotal > 0" :total="bankTotal" :page.sync="bankPageNum" :limit.sync="bankPageSize" @pagination="getBankList" />

			<!--    银行信息-->
			<el-dialog :close-on-click-modal="false" :show-close="false" title="操作银行卡" :visible.sync="dialogBankInfoVisible" width="60%" class="dialog-container">
				<el-form :model="queryBankInfo">
					<el-row :gutter="4">
						<el-col :span="8">
							<el-form-item label="账号类型" :label-width="formLabelWidth">
								<el-select v-model="queryBankInfo.acountsType" placeholder="请选择">
									<el-option v-for="item in acountsTypeList" :key="item.value" :label="item.label" :value="item.value"></el-option>
								</el-select>
							</el-form-item>
						</el-col>
						<el-col :span="8">
							<el-form-item label="账户名" :label-width="formLabelWidth">
								<el-input v-model="queryBankInfo.acountsName" autocomplete="off"></el-input>
							</el-form-item>
						</el-col>
						<el-col :span="3">
							<el-button type="primary" @click="handleSearchBankInfo">搜索</el-button>
						</el-col>
					</el-row>
				</el-form>
				<el-row>
					<el-table v-loading="loading" :data="bankInfo" class="table-container">
						<el-table-column label="银行卡号" align="center" prop="bankNo" />
						<el-table-column label="账户类型" align="center" prop="acountsType" />
						<el-table-column label="账户名" align="center" prop="acountsName" />
						<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="180">
							<template slot-scope="scope">
								<el-button type="danger" @click="addThisBankInfo(scope.row)">添加该银行卡</el-button>
							</template>
						</el-table-column>
					</el-table>
				</el-row>
				<div slot="footer" class="dialog-footer">
					<el-button @click="dialogBankInfoVisible = false">取 消</el-button>
					<el-button type="primary" @click="dialogBankInfoVisible = false">确 定</el-button>
				</div>
				<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
			</el-dialog>
		</el-dialog>

		<el-dialog :close-on-click-modal="false" :show-close="false" title="设置默认银行卡" :visible.sync="addDefaultCardVisible" width="500px" append-to-body class="dialog-container">
			<el-table v-loading="loading" v-horizontal-scroll="'always'" border :data="singleInfo" height="300px" @selection-change="handleSelectionChange" class="table-container">
				<el-table-column label="账户类型" align="center" prop="acountsType" />
				<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
				<el-table-column label="账号(银行账号)" align="center" prop="bankNo" />
				<el-table-column label="开户行" align="center" prop="bankName" />
				<el-table-column label="公司名称" align="center" prop="companyName" />
				<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
					<template slot-scope="scope">
						<el-button size="mini" type="primary" @click="addDefaultCard(scope.row)">设置为默认</el-button>
					</template>
				</el-table-column>
			</el-table>
		</el-dialog>
	</div>
</template>

<script>
import { delBankAccount, listBankAccount, setDefault } from '@/api/system/bankAccount';
import { addCompany, delCompany, getCompany, listCompany, updateCompany } from '@/api/system/company';
import { excludeParams } from '@/api/tool/exclude';
import { INFO_TYPE, isUsed } from '../../../api/system/isUsed';
import AddBankAccounts from '../../dashboard/components/company/AddBankAccounts.vue';

export default {
	name: 'Company',
	components: { AddBankAccounts },
	data() {
		// 自定义校验规则
		const validateRegion = (rule, value, callback) => {
			if (this.form.province && this.form.city) {
				callback();
			} else {
				callback(new Error('请选择省市'));
			}
		};

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
			queryParams: {
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
				companyType: '客户',
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
				companyName: [
					{
						required: true,
						message: '公司名称不能为空',
						trigger: 'blur'
					}
				],
				relationName: [
					{
						required: true,
						message: '联系人姓名不能为空',
						trigger: 'blur'
					}
				],
				relationTel: [
					{
						required: true,
						message: '联系人电话不能为空',
						trigger: 'blur'
					}
				],
				address: [
					{
						required: true,
						message: '公司地址不能为空',
						trigger: 'blur'
					}
				],
				// salesman: [
				// 	{ required: true, message: '录入员不能为空', trigger: 'blur' }
				// ],
				// leader: [
				// 	{ required: true, message: '老板姓名不能为空', trigger: 'blur' }
				// ],
				// leaderTel: [
				// 	{ required: true, message: '老板电话不能为空', trigger: 'blur' }
				// ],
				salesManager: [
					{
						required: true,
						message: '销售经理不能为空',
						trigger: 'blur'
					}
				],
				province: [
					{
						required: true,
						validator: validateRegion,
						trigger: 'change'
					}
				],
				city: [
					{
						required: true,
						validator: validateRegion,
						trigger: 'change'
					}
				]
				// 移除county的单独校验规则，因为不是必选项
			},
			columns: [
				{ key: 0, label: `客户`, visible: true },
				{ key: 1, label: `老板姓名`, visible: true },
				{ key: 2, label: `老板电话`, visible: true },
				{ key: 3, label: `区域`, visible: true },
				{ key: 4, label: `联系人`, visible: true },
				{ key: 5, label: `销售经理`, visible: true },
				{ key: 6, label: `地址`, visible: true },
				{ key: 7, label: `电话`, visible: true },
				{ key: 8, label: `备注`, visible: true }
			],
			dialogFormVisible: false, // 搜索已绑定的银行卡信息
			dialogFormSearchVisible: false,
			formLabelWidth: '140px',
			// 点击弹窗出来的搜索信息
			currentInfo: {
				companyType: '客户',
				relationName: '',
				bankNo: '',
				bankName: '',
				acountsName: ''
			},
			// 指定用户的信息
			singleInfo: [],
			bankInfo: [],
			dialogBankInfoVisible: false,
			queryBankInfo: {
				acountsType: '',
				acountsName: ''
			},
			bankAccountList: [],
			// 账户类型
			acountsTypeList: [
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
					value: '其他',
					label: '其他'
				}
			],
			// 省市县
			provinceList: [],
			cityList: [],
			districtList: [],
			province: '',
			city: '',
			district: '',
			// 默认银行卡信息
			defaultBankCardInfo: {},
			addDefaultCardVisible: false,

			// 默认银行卡列表的id
			currentID: '',
			bankTotal: 0,
			bankPageSize: 10,
			bankPageNum: 1
		};
	},
	// 展示与隐藏
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('company-columns', JSON.stringify(newVal));
			},
			deep: true
		},
		// 城市变化
		'form.province': function (val) {
			this.provinceList.forEach(item => {
				if (item.name === val) {
					this.cityList = item.areaList;
				}
			});
		},
		'form.city': function (val) {
			this.cityList.forEach(item => {
				if (item.name === val) {
					this.districtList = item.areaList;
				}
			});
		}
	},
	created() {
		this.getList();
		if (localStorage.getItem('company-columns') === 'null' || !localStorage.getItem('company-columns')) {
			// 设置localStorage
			localStorage.setItem('company-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('company-columns'));
		}
		// 获取城市信息
		fetch('/area.json')
			.then(res => res.json())
			.then(res => {
				this.provinceList = res;
			});
	},
	methods: {
		// 城市变化
		changeProvince(e) {
			this.province = e;
		},
		changeCity(e) {
			this.city = e;
		},
		// 点击银行卡后弹窗
		jumpBankNo(row) {
			// 绑定ID 分页查询默认银行卡有用
			this.currentID = row.id;
			this.currentInfo = Object.assign(this.currentInfo, {
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
			// 搜索信息
			const query = {
				companyId: row.id,
				acountsType: this.queryParams.companyType
			};
			// 查询已绑定的银行卡信息
			listBankAccount(query).then(res => {
				this.singleInfo = res.rows;
				this.bankTotal = res.total;
				// 打开弹窗
				this.dialogFormVisible = true;
			});
			// 查询客户的默认银行卡信息
			// listBankAccount({ acountsType: '客户默认', companyId: row.id }).then(
			//   (res) => {
			//     if (res.rows.length > 0) {
			//       this.defaultBankCardInfo = res.rows[0]
			//     } else {
			//       this.defaultBankCardInfo.not = true
			//     }
			//     this.dialogFormVisible = true
			//   }
			// )
		},
		// 查询已经绑定的银行卡信息
		getBankList() {
			listBankAccount({
				companyId: this.currentID,
				acountsType: '客户',
				pageNum: this.bankPageNum,
				pageSize: this.bankPageSize
			}).then(res => {
				this.singleInfo = res.rows;
				this.bankTotal = res.total;
			});
		},
		// 银行卡搜索按钮
		handleSearchCompanyGive() {
			this.getList();
		},
		// 查询银行卡
		handleSearchBankInfo() {
			listBankAccount({
				acountsType: this.queryBankInfo.acountsType,
				acountsName: this.queryBankInfo.acountsName
			}).then(res => {
				this.bankInfo = res.rows;
			});
		},
		addThisBankInfo(row) {
			this.dialogBankInfoVisible = false;
			this.dialogFormVisible = false;
			// 如果账户名不一样不允许添加银行卡
			if (this.currentInfo.relationName !== row.acountsName) {
				this.$message.error('不允许添加非己银行卡!');
			} else {
				this.currentInfo.bankNo = row.bankNo;
				this.currentInfo.bankName = row.bankName;
				this.currentInfo.acountsName = row.acountsName;
				// 如果该用户没有银行卡，那么就修改客户信息里面的银行卡信息，如果有银行卡 添加
				updateCompany(this.currentInfo).then(() => {
					this.$message.success('添加成功');
				});
			}
		},
		// 添加默认银行卡
		addDefaultCard(row) {
			// 如果是undefined 代表是个对象
			if (row.target === undefined) {
				// 设置默认银行卡
				setDefault({
					...excludeParams(row, this.$exclude),
					acountsType: '客户默认'
				}).then(() => {
					this.$message.success('设置成功~');
					this.dialogFormVisible = false; // 关闭银行卡弹窗
					this.addDefaultCardVisible = false;
					this.getList();
				});
			} else {
				// 如果还没有添加过银行卡信息
				// 先查询
				listBankAccount({
					companyId: this.currentInfo.id,
					acountsType: '客户'
				}).then(res => {
					if (res.rows.length === 0) {
						this.$confirm('您还没有设置银行卡信息，是否前往设置?', '提示', {
							confirmButtonText: '确定',
							cancelButtonText: '取消',
							type: 'warning'
						})
							.then(() => {
								this.dialogFormVisible = false;
								this.$router.push('/baseInfo/bankaccount');
							})
							.catch(() => {});
					} else {
						this.addDefaultCardVisible = true;
					}
				});
			}
		},
		// 删除用户已绑定的某张银行卡信息
		handleDeleteBankaccount(row) {
			delBankAccount(row.id).then(() => {
				this.$message.success('删除成功~');
				this.dialogFormVisible = false;
				this.getList();
			});
		},
		// 主动绑定银行卡后的回调函数
		handleChangeBank() {
			this.dialogFormVisible = false;
			this.getList();
		},
		printHTML() {
			this.$print({
				printable: 'printBox',
				type: 'html',
				targetStyles: ['*'] // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
			});
		},
		/** 查询客户、供应商信息列表 */
		getList() {
			this.loading = true;
			listCompany(this.queryParams).then(response => {
				this.companyList = response.rows;
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
				companyName: null,
				relationName: null,
				relationTel: null,
				address: null,
				bankName: null,
				acountsName: null,
				bankNo: null,
				surplusMoney: null,
				companyType: '客户',
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
			this.title = '添加客户信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getCompany(id, '客户').then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改客户信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form = excludeParams(this.form, this.$exclude);
						updateCompany(this.form).then(() => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form = excludeParams(this.form, this.$exclude);
						addCompany(this.form).then(() => {
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
			// 删除前要去检索一下是否有用到该数据 要给用户提示
			const query = {
				id: ids,
				type: INFO_TYPE.CUSTOMER
			};
			// 弹窗删除
			this.$modal
				.confirm('是否确认删除编号为"' + ids + '"的数据项？')
				.then(() => {
					// 查询该数据是否被使用
					isUsed(query).then(res => {
						if (res.data.isUsed) {
							this.$modal
								.confirm('系统检测该信息:"' + ids + '"的客户数据在系统中被使用，是否要继续删除?')
								.then(function () {
									return delCompany(ids, '客户');
								})
								.then(() => {
									this.getList();
									this.$modal.msgSuccess('删除成功');
								})
								.catch(() => {});
						} else {
							delCompany(ids, '客户').then(() => {
								this.getList();
								this.$modal.msgSuccess('删除成功');
							});
						}
					});
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/company/export',
				{
					...this.queryParams
				},
				`company_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>

<style scoped>
.form-container {
	background-color: #f9f9f9;
	padding: 10px;
	border-radius: 5px;
	margin-bottom: 10px;
}

.table-container {
	background-color: #fff;
	border-radius: 5px;
	padding: 10px;
}
</style>
