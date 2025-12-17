<script>
import { excludeParams } from '../../../../api/tool/exclude';
import { addBankAccount } from '../../../../api/system/bankAccount';

export default {
	name: 'AddBankAccounts',
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
		},
		// 传入的车牌号，用于自动填充
		carNo: {
			type: String,
			default: ''
		}
	},
	data() {
		return {
			dialogVisible: false,
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
		// 添加银行卡信息 这里需要选择客户或者供应商进行绑定
		handleAddBankAccount() {
			this.reset();

			// 优先从传入的公司信息填充数据
			if (this.computedCompanyInfo) {
				// 填充表单字段
				this.form.acountsType = this.companyType || this.computedCompanyInfo.companyType || this.computedCompanyInfo.acountsType || '司机';
				this.form.companyId = this.computedCompanyInfo.id || this.computedCompanyInfo.companyId;
				this.form.companyName = this.computedCompanyInfo.companyName || '';
				this.form.bankNo = this.computedCompanyInfo.bankNo || ''; // 如果有银行账号，填充
				this.form.acountsName = this.computedCompanyInfo.acountsName || ''; // 默认填充账户名称
				this.form.bankName = this.computedCompanyInfo.bankName || ''; // 默认填充开户行
			}

			// 自动填充车牌号（从 prop 传入）
			if (this.carNo) {
				this.form.carNo = this.carNo;
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
			<el-button v-hasPermi="['system:company:add']" type="text" size="mini" icon="el-icon-plus"
				@click="handleAddBankAccount">新增银行卡信息</el-button>
		</div>
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="提示" :visible.sync="dialogVisible"
			width="50%" append-to-body :close-on-click-modal="false" :close-on-press-escape="false">
			<div>
				<el-form ref="form" :model="form" :rules="rules" label-width="120px">
					<!-- 账号类型 -->
					<el-form-item v-show="false" label="账号类型" prop="acountsType">
						<el-select v-model="form.acountsType" placeholder="请选择账号类型">
							<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
						</el-select>
					</el-form-item>

					<!-- 车牌号（隐藏，自动填充） -->
					<el-form-item v-show="false" label="车牌号" prop="carNo">
						<el-input v-model="form.carNo" placeholder="请输入车牌号" />
					</el-form-item>

					<!-- 户名（隐藏，自动填充） -->
					<el-form-item v-show="false" label="户名" prop="acountsName">
						<el-input v-model="form.acountsName" placeholder="请输入户名" />
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