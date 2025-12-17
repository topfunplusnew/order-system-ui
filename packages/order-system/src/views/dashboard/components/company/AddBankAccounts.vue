<script>
	import { listCompany } from '../../../../api/system/company';
	import { excludeParams } from '../../../../api/tool/exclude';
	import { addBankAccount } from '../../../../api/system/bankAccount';
	import { listCars } from '../../../../api/system/cars';
	import SearchOption from '@/components/SearchOption.vue';
	
	export default {
	  name: 'AddBankAccounts',
	  components: { SearchOption },
	  props: {
		companyType: {
		  type: String,
		  default: '客户'
		},
		// 需要companyName companyId
		companyInfo: {
		  type: Object,
		  required: true,
		  default() {
			return {};
		  }
		}
	  },
	  data() {
		return {
		  dialogVisible: false,
		  // 搜索字段
		  queryCompany: '',
		  queryCompanyGive: '',
		  queryCarsBank: '',
		  title: '',
		  options: [
			{ value: '己方公司', label: '己方公司' },
			{ value: '客户', label: '客户' },
			{ value: '供应商', label: '供应商' },
			{ value: '司机', label: '司机' },
			{ value: '其他', label: '其他' }
		  ],
		  form: {},
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
			carNo: [
			  {
				required: true,
				message: '车牌号不能为空',
				trigger: 'blur'
			  }
			]
		  }
		};
	  },
	  computed: {
		computedCompanyInfo() {
		  return this.companyInfo;
		}
	  },
	  watch: {
		computedCompanyInfo: {
		  handler(val) {
			console.log(val);
		  },
		  deep: true,
		  immediate: true
		}
	  },
	  methods: {
		listCompany,
		listCars,
		// 添加银行卡信息 这里需要选择客户或者供应商进行绑定
		handleAddBankAccount() {
		  this.reset();
		  
		  // 优先从传入的公司信息填充数据
		  if (this.computedCompanyInfo) {
			// 填充表单字段
			this.form.acountsType = this.companyType || this.computedCompanyInfo.companyType || this.computedCompanyInfo.acountsType || '司机';
			this.form.companyId = this.computedCompanyInfo.id || this.computedCompanyInfo.companyId;
			this.form.companyName = this.computedCompanyInfo.companyName || '';
			this.form.carNo = this.computedCompanyInfo.carNo || ''; // 默认填充车牌号，如果有的话
			this.form.bankNo = this.computedCompanyInfo.bankNo || ''; // 如果有银行账号，填充
			this.form.acountsName = this.computedCompanyInfo.acountsName || ''; // 默认填充账户名称
			this.form.bankName = this.computedCompanyInfo.bankName || ''; // 默认填充开户行
		  }
	
		  // 打开弹窗
		  this.dialogVisible = true;
		},
		// 取消按钮
		cancel() {
		  this.dialogVisible = false;
		  this.reset();
		},
		reset() {
		  this.form = {
			id: null,
			carNo: null,  // 新增车牌号字段
			bankName: null,
			acountsName: null,
			bankNo: null,
			acountsType: '司机',
			amount: null,
			comments: null,
			delFlag: null
		  };
		  this.$nextTick(() => {
			this.$refs['form'] && this.$refs['form'].resetFields();  // 重置表单字段
		  });
		},
		// 车牌号选择回调，自动填充司机信息
		handleCommitBackCar(val) {
		  // 自动填充车牌号
		  this.form.carNo = val.carNo || '';
		  // 自动填充司机账户信息
		  this.form.acountsName = val.acountsName || val.driver || '';
		  this.form.bankNo = val.bankNo || '';
		  this.form.bankName = val.bankName || '';
		},
		// 更新车牌号查询字段
		handleUpdateQueryCars(val) {
		  this.queryCarsBank = val;
		},
		submitForm() {
		  this.$refs['form'].validate(valid => {
			if (valid) {
			  this.form = excludeParams(this.form, this.$exclude);
			  addBankAccount(this.form).then(response => {
				this.$modal.msgSuccess('新增成功');
				this.dialogVisible = false;
				this.$emit('callGetList');
			  });
			}
		  });
		}
	  }
	};
	</script>
	

	<template>
		<div>
		  <!-- 新增银行卡信息 -->
		  <div class="add-bank-account">
			<el-button v-hasPermi="['system:company:add']" type="text" size="mini" icon="el-icon-plus" @click="handleAddBankAccount">新增银行卡信息</el-button>
		  </div>
		  <el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="提示" :visible.sync="dialogVisible" width="50%" append-to-body :close-on-click-modal="false" :close-on-press-escape="false">
			<div>
			  <el-form ref="form" :model="form" :rules="rules" label-width="120px">
				<!-- 账号类型 -->
				<el-form-item v-show="false" label="账号类型" prop="acountsType">
				  <el-select v-model="form.acountsType" placeholder="请选择账号类型">
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
				  </el-select>
				</el-form-item>
	  
				<!-- 车牌号 -->
				<el-form-item label="车牌号" prop="carNo">
				  <el-row>
					<el-col :span="20">
					  <el-input v-model="form.carNo" placeholder="请输入车牌号" />
					</el-col>
					<el-col :span="4">
					  <SearchOption 
						:get-data="listCars" 
						:limit-info="{}" 
						query-label="车牌查找" 
						query-info="carNo" 
						:query-name="queryCarsBank" 
						@commitBack="handleCommitBackCar" 
						@update:queryName="handleUpdateQueryCars">
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
					</el-col>
				  </el-row>
				</el-form-item>
	  
				<!-- 户名 -->
				<el-form-item label="户名" prop="acountsName">
				  <el-row v-if="form.acountsType === '司机'">
					<el-col :span="20">
					  <el-input v-model="form.acountsName" placeholder="请输入户名" />
					</el-col>
				  </el-row>
				  <el-row v-else>
					<el-input v-model="form.acountsName" placeholder="请输入户名" />
				  </el-row>
				</el-form-item>
	  
				<!-- 银行账号 -->
				<el-form-item label="银行账号" prop="bankNo">
				  <el-input v-model="form.bankNo" placeholder="请输入银行账号" />
				</el-form-item>
	  
				<!-- 开户行 -->
				<el-form-item label="开户行" prop="bankName">
				  <el-input v-model="form.bankName" placeholder="请输入开户行" />
				</el-form-item>
			  </el-form>
	  
			  <div slot="footer" class="dialog-footer" style="text-align: center">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			  </div>
			</div>
		  </el-dialog>
		</div>
	  </template>
	  

<style scoped lang="scss">
.add-bank-account {
	text-align: center;
}
</style>