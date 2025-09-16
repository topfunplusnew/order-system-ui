<template>
	<DynamicForm ref="dynamicForm" :config="columnConfig" :form-data="formData" :external-data="externalData" @field-change="handleFieldChange">
		<!-- 对象选择器插槽 -->
		<template #target="{ value, updateValue }">
			<el-row>
				<el-col :span="16">
					<el-input :value="value" disabled placeholder="请选择对象" />
				</el-col>
				<el-col :span="8">
					<SearchOption
						v-if="getTargetCompanySearchConfig().show"
						:limit-info="getTargetCompanySearchConfig().limitInfo"
						:get-data="getTargetCompanySearchConfig().getData"
						icon="el-icon-search"
						:query-label="getTargetCompanySearchConfig().queryLabel"
						:query-info="getTargetCompanySearchConfig().queryInfo"
						:query-name="queryCompany"
						@commitBack="val => handleCommitBackCompany(val, updateValue)"
						@update:queryName="val => (queryCompany = val)"
					>
						<template #table-columns>
							<el-table-column v-for="col in getTargetCompanySearchConfig().columns" :key="col.prop" :label="col.label" align="center" :prop="col.prop" />
						</template>
					</SearchOption>
				</el-col>
			</el-row>
		</template>

		<!-- 对方账户选择器插槽 -->
		<template #targetAccountsName="{ value, updateValue }">
			<el-row>
				<el-col :span="16">
					<el-input :value="value" disabled placeholder="请选择对方账户" />
				</el-col>
				<el-col :span="8">
					<SearchOption
						:limit-info="getTargetLimitInfo()"
						:get-data="listBankAccount"
						icon="el-icon-search"
						query-label="户名查找"
						query-info="acountsName"
						:query-name="queryBankOther"
						@commitBack="val => handleCommitBackOther(val, updateValue)"
						@update:queryName="val => (queryBankOther = val)"
					>
						<template #table-columns>
							<el-table-column :label="getTargetAccountLabel()" align="center" prop="acountsName" />
							<el-table-column label="开户行" align="center" prop="bankName" />
							<el-table-column label="账号" align="center" prop="bankNo" />
						</template>
					</SearchOption>
				</el-col>
			</el-row>
		</template>

		<!-- 我方收款账户选择器插槽 -->
		<template #selfAccountsName="{ value, updateValue }">
			<el-row>
				<el-col :span="16">
					<el-input :value="value" disabled placeholder="请选择我方账户" />
				</el-col>
				<el-col :span="8">
					<SearchOption
						:limit-info="{ acountsType: '己方公司' }"
						:get-data="listBankAccount"
						icon="el-icon-search"
						query-label="户名查找"
						query-info="acountsName"
						:query-name="queryBankSelf"
						@commitBack="val => handleCommitBackSelf(val, updateValue)"
						@update:queryName="val => (queryBankSelf = val)"
					>
						<template #table-columns>
							<el-table-column label="开户行" align="center" prop="bankName" />
							<el-table-column label="开户名" align="center" prop="acountsName" />
							<el-table-column label="账号" align="center" prop="bankNo" />
						</template>
					</SearchOption>
				</el-col>
			</el-row>
		</template>
	</DynamicForm>
</template>

<script>
import DynamicForm from '@/components/DynamicForm';
import SearchOption from '@/components/SearchOption.vue';
import { addDepositMoney, updateDepositMoney } from '@/api/system/depositMoney';
import { listBankAccount } from '@/api/system/bankAccount';
import { listCompany } from '@/api/system/company';
import { listCars } from '@/api/system/cars';
import { excludeParams } from '@/api/tool/exclude';
import columnConfig from './columns';

export default {
	name: 'DepositMoneyForm',
	components: {
		DynamicForm,
		SearchOption
	},
	props: {
		// 表单数据，由父组件传入
		formData: {
			type: Object,
			default: () => ({})
		},
		// 是否为编辑模式
		isEdit: {
			type: Boolean,
			default: false
		},
		// 弹窗标题
		title: {
			type: String,
			default: '添加保证金收取信息'
		}
	},
	data() {
		return {
			columnConfig,
			// 外部数据（如果需要的话）
			externalData: {},
			// 搜索控件本地变量
			queryBankOther: '',
			queryBankSelf: '',
			queryCompany: ''
		};
	},
	methods: {
		// 字段变化处理
		handleFieldChange({ prop, value }) {
			// 当对象类型发生变化时，清空对方账户相关信息
			if (prop === 'targetType') {
				this.handleTargetTypeChange();
			}
		},

		// 对象类型变化处理
		handleTargetTypeChange() {
			// 清空相关字段
			this.$refs.dynamicForm.updateFieldValue('target', null);
			this.$refs.dynamicForm.updateFieldValue('targetId', null);
			this.$refs.dynamicForm.updateFieldValue('targetAccountsName', null);
			this.$refs.dynamicForm.updateFieldValue('targetBankNo', null);
			this.$refs.dynamicForm.updateFieldValue('targetBankName', null);
			this.queryBankOther = '';
			this.queryCompany = '';
		},

		// 获取对象搜索配置
		getTargetCompanySearchConfig() {
			const formData = this.$refs.dynamicForm ? this.$refs.dynamicForm.getFormData() : {};
			const targetType = formData.targetType;

			// 根据对象类型返回不同的搜索配置
			switch (targetType) {
				case '客户':
					return {
						show: true,
						limitInfo: { companyType: '客户' },
						getData: listCompany,
						queryLabel: '公司名称',
						queryInfo: 'companyName',
						columns: [
							{ prop: 'companyName', label: '客户' },
							{ prop: 'leader', label: '老板姓名' },
							{ prop: 'leaderTel', label: '老板电话' },
							{ prop: 'region', label: '区域' },
							{ prop: 'salesManager', label: '销售经理' }
						]
					};
				case '供应商':
					return {
						show: true,
						limitInfo: { companyType: '供应商' },
						getData: listCompany,
						queryLabel: '公司名称',
						queryInfo: 'companyName',
						columns: [
							{ prop: 'companyName', label: '供应商' },
							{ prop: 'leader', label: '老板姓名' },
							{ prop: 'leaderTel', label: '老板电话' },
							{ prop: 'region', label: '区域' },
							{ prop: 'salesManager', label: '销售经理' }
						]
					};
				case '司机':
					return {
						show: true,
						limitInfo: { companyType: '司机' },
						getData: listCars,
						queryLabel: '司机',
						queryInfo: 'driver',
						columns: [
							{ prop: 'carType', label: '运输类型' },
							{ prop: 'carNo', label: '车牌/柜号' },
							{ prop: 'driver', label: '司机姓名/海运公司' },
							{ prop: 'tel', label: '司机电话' }
						]
					};
				default:
					return {
						show: false,
						limitInfo: {},
						getData: null,
						queryLabel: '',
						queryInfo: '',
						columns: []
					};
			}
		},

		// 对象选择回调
		handleCommitBackCompany(val, updateValue) {
			const formData = this.$refs.dynamicForm ? this.$refs.dynamicForm.getFormData() : {};
			const targetType = formData.targetType;

			// 更新对象名称字段
			const targetName = targetType === '司机' ? val.driver : val.companyName;
			updateValue(targetName);

			// 自动填充对象ID
			this.$refs.dynamicForm.updateFieldValue('targetId', val.id);

			// 清空对方账户相关信息，因为公司变更了
			this.$refs.dynamicForm.updateFieldValue('targetAccountsName', null);
			this.$refs.dynamicForm.updateFieldValue('targetBankNo', null);
			this.$refs.dynamicForm.updateFieldValue('targetBankName', null);
			this.queryBankOther = '';
		},

		// 获取对方账户的限制信息
		getTargetLimitInfo() {
			const formData = this.$refs.dynamicForm ? this.$refs.dynamicForm.getFormData() : {};
			const targetType = formData.targetType;
			const targetId = formData.targetId;

			// 基本的账户类型限制
			let limitInfo = {};

			switch (targetType) {
				case '客户':
					limitInfo = { acountsType: '客户' };
					// 如果已选择了具体的客户公司，则添加公司ID限制
					if (targetId) {
						limitInfo.companyId = targetId;
						limitInfo.companyType = '客户';
					}
					break;
				case '供应商':
					limitInfo = { acountsType: '供应商' };
					// 如果已选择了具体的供应商公司，则添加公司ID限制
					if (targetId) {
						limitInfo.companyId = targetId;
						limitInfo.companyType = '供应商';
					}
					break;
				case '司机':
					limitInfo = { acountsType: '司机' };
					// 如果已选择了具体的司机，则添加公司ID限制
					if (targetId) {
						limitInfo.companyId = targetId;
						limitInfo.companyType = '司机';
					}
					break;
				default:
					limitInfo = {};
			}

			return limitInfo;
		},

		// 获取对方账户的标签
		getTargetAccountLabel() {
			const formData = this.$refs.dynamicForm ? this.$refs.dynamicForm.getFormData() : {};
			const targetType = formData.targetType;

			switch (targetType) {
				case '客户':
					return '客户名称';
				case '供应商':
					return '供应商名称';
				case '司机':
					return '司机姓名';
				default:
					return '名称';
			}
		},

		// 对方账户选择回调
		handleCommitBackOther(val, updateValue) {
			// 更新当前字段值
			updateValue(val.acountsName);

			// 自动填充相关字段 - 注意：这里不设置 targetId，targetId 应该来自公司选择
			this.$refs.dynamicForm.updateFieldValue('targetBankNo', val.bankNo);
			this.$refs.dynamicForm.updateFieldValue('targetBankName', val.bankName);
		},

		// 我方账户选择回调
		handleCommitBackSelf(val, updateValue) {
			// 更新当前字段值
			updateValue(val.acountsName);

			// 自动填充相关字段
			this.$refs.dynamicForm.updateFieldValue('selfBankNo', val.bankNo);
			this.$refs.dynamicForm.updateFieldValue('selfBankName', val.bankName);
		},

		// 确认操作处理函数 - 弹窗系统要求的方法
		async handleProcess() {
			try {
				// 1. 首先进行表单验证
				const isValid = await this.$refs.dynamicForm.validateForm();
				if (!isValid) {
					throw new Error('表单验证失败，请检查输入信息');
				}
				// 2. 获取表单数据
				const formData = this.$refs.dynamicForm.getFormData();
				// 3. 根据编辑模式执行相应的业务逻辑
				if (this.isEdit) {
					await this.updateDepositMoneyData(formData);
					this.$message.success('修改成功');
				} else {
					await this.addDepositMoneyData(formData);
					this.$message.success('新增成功');
				}

				// 4. 触发成功事件
				this.$emit('success', formData);
				return Promise.resolve(formData);
			} catch (error) {
				this.$message.error(error.message || (this.isEdit ? '修改失败' : '新增失败'));
				return Promise.reject(error);
			}
		},

		// 取消/关闭操作处理函数 - 弹窗系统要求的方法
		handleReject() {
			this.$emit('cancel');
			return Promise.resolve();
		},

		// 新增保证金数据
		async addDepositMoneyData(formData) {
			const data = excludeParams(formData);
			await addDepositMoney(data);
		},

		// 修改保证金数据
		async updateDepositMoneyData(formData) {
			const data = excludeParams(formData);
			await updateDepositMoney(data);
		},

		// 银行账户搜索方法
		listBankAccount,

		// 公司搜索方法
		listCompany,

		// 司机搜索方法
		listCars
	}
};
</script>

<style scoped>
/* 组件样式 */
</style>
