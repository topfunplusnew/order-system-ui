<template>
	<DynamicForm ref="dynamicForm" :config="columnConfig" :form-data="formData" :is-edit="isEdit" :external-data="externalData" @field-change="handleFieldChange">
		<!-- 省份选择器插槽 -->
		<template #province="{ value, updateValue }">
			<el-select :value="value" placeholder="请选择省份" @change="val => handleProvinceChange(val, updateValue)">
				<el-option v-for="province in externalData.provinceList" :key="province.name" :label="province.name" :value="province.name" />
			</el-select>
		</template>

		<!-- 城市选择器插槽 -->
		<template #city="{ value, updateValue }">
			<el-select :value="value" placeholder="请选择城市" @change="val => handleCityChange(val, updateValue)">
				<el-option v-for="city in externalData.cityList" :key="city.name" :label="city.name" :value="city.name" />
			</el-select>
		</template>

		<!-- 区县选择器插槽 -->
		<template #county="{ value, updateValue }">
			<el-select :value="value" placeholder="请选择区县" @change="updateValue">
				<el-option v-for="county in externalData.districtList" :key="county.name" :label="county.name" :value="county.name" />
			</el-select>
		</template>
	</DynamicForm>
</template>

<script>
import DynamicForm from '@/components/DynamicForm';
import { addCompany, checkCustomerIsExit, updateCompany } from '@/api/system/company';
import { excludeParams } from '@/api/tool/exclude';
import columnConfig from './columns';

export default {
	name: 'CompanyForm',
	components: {
		DynamicForm
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
			default: '添加客户信息'
		}
	},
	data() {
		return {
			columnConfig,
			// 外部数据（省市列表等）
			externalData: {
				provinceList: [],
				cityList: [],
				districtList: []
			}
		};
	},
	created() {
		// 获取城市信息
		fetch('/area.json')
			.then(res => res.json())
			.then(res => {
				this.externalData.provinceList = res;
			});
	},
	methods: {
		// 省份变化处理 - 新的插槽方式
		handleProvinceChange(val, updateValue) {
			// 更新省份值
			updateValue(val);

			// 使用updateFieldValue方法来更新字段，避免触发表单重新初始化
			this.$refs.dynamicForm.updateFieldValue('city', null);
			this.$refs.dynamicForm.updateFieldValue('county', null);

			// 更新城市列表
			this.externalData.cityList = [];
			this.externalData.districtList = [];

			this.externalData.provinceList.forEach(item => {
				if (item.name === val) {
					this.externalData.cityList = item.areaList || [];
				}
			});
		},

		// 城市变化处理 - 新的插槽方式
		handleCityChange(val, updateValue) {
			// 更新城市值
			updateValue(val);

			// 使用updateFieldValue方法来更新字段，避免触发表单重新初始化
			this.$refs.dynamicForm.updateFieldValue('county', null);

			// 更新区县列表
			this.externalData.districtList = [];

			this.externalData.cityList.forEach(item => {
				if (item.name === val) {
					this.externalData.districtList = item.areaList || [];
				}
			});
		},

		// 城市变化处理 - 兼容旧的方式
		changeProvince(val) {
			// 使用updateFieldValue方法避免触发表单重新初始化
			this.$refs.dynamicForm.updateFieldValue('city', null);
			this.$refs.dynamicForm.updateFieldValue('county', null);

			// 更新城市列表
			this.externalData.cityList = [];
			this.externalData.districtList = [];

			this.externalData.provinceList.forEach(item => {
				if (item.name === val) {
					this.externalData.cityList = item.areaList || [];
				}
			});
		},

		changeCity(val) {
			// 使用updateFieldValue方法避免触发表单重新初始化
			this.$refs.dynamicForm.updateFieldValue('county', null);

			// 更新区县列表
			this.externalData.districtList = [];

			this.externalData.cityList.forEach(item => {
				if (item.name === val) {
					this.externalData.districtList = item.areaList || [];
				}
			});
		},

		// 字段变化处理
		handleFieldChange({ prop, value }) {
			// 这里可以处理字段变化的副作用
			console.log(`字段 ${prop} 变化为:`, value);
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
				console.log('获取到的表单数据:', formData);

				// 3. 根据编辑模式执行相应的业务逻辑
				if (this.isEdit) {
					await this.updateCompanyData(formData);
					this.$message.success('修改成功');
				} else {
					await this.addCompanyData(formData);
					this.$message.success('新增成功');
				}

				// 4. 触发成功事件
				this.$emit('success', formData);

				return Promise.resolve(formData);
			} catch (error) {
				console.error('处理失败:', error);
				this.$message.error(error.message || (this.isEdit ? '修改失败' : '新增失败'));
				return Promise.reject(error);
			}
		},

		// 取消/关闭操作处理函数 - 弹窗系统要求的方法
		handleReject() {
			this.$emit('cancel');
			return Promise.resolve();
		},

		// 新增客户数据
		async addCompanyData(formData) {
			const data = excludeParams(formData);
			// 添加客户信息之前先校验客户是否已经存在
			const checkResult = await checkCustomerIsExit(data.companyName, null);
			if (!checkResult.data) {
				throw new Error('客户已存在,不允许新增!');
			}
			await addCompany(data);
		},

		// 修改客户数据
		async updateCompanyData(formData) {
			const data = excludeParams(formData);

			// 修改时检查客户是否存在
			const checkResult = await checkCustomerIsExit(data.companyName, data.id);
			if (!checkResult.data) {
				throw new Error('修改时出现错误:该行ID已存在客户信息,但数据返回不存在');
			}
			await updateCompany(data);
		}
	}
};
</script>

<style scoped>
/* 组件样式 */
</style>
