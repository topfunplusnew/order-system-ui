<template>
	<el-form ref="form" :model="form" :rules="rules" label-width="110px" @submit.native.prevent="handleSubmit" @keyup.enter.native="handleSubmit">
		<el-row :gutter="4">
			<!-- 多列布局：每列垂直排列表单项 -->
			<el-col v-for="column in multiColumnConfig" :key="`column-${column.columnIndex}`" :span="column.span">
				<div v-for="(config, configIndex) in column.items" :key="`${config.prop || 'field'}-${configIndex}`" class="form-item-wrapper">
					<el-form-item :label="config.label" :prop="config.prop">
						<!-- 优先使用具名插槽 -->
						<slot v-if="$scopedSlots[config.prop]" :name="config.prop" :config="config" :value="form[config.prop]" :form="form" :updateValue="value => updateFieldValue(config.prop, value)"></slot>

						<!-- 输入框 -->
						<el-input v-else-if="config.formConfig.type === 'input'" v-model="form[config.prop]" :placeholder="config.formConfig.placeholder" :readonly="config.formConfig.readonly" @input="handleInputTrim($event, config.prop)" />

						<!-- 选择器 -->
						<el-select v-else-if="config.formConfig.type === 'select'" v-model="form[config.prop]" :placeholder="config.formConfig.placeholder" style="width: 100%" @change="handleSelectChange(config.prop, $event, config.formConfig.change)">
							<el-option v-for="option in getSelectOptions(config.formConfig.options)" :key="getOptionValue(option, config.formConfig)" :label="getOptionLabel(option, config.formConfig)" :value="getOptionValue(option, config.formConfig)"></el-option>
						</el-select>

						<!-- 文本域 -->
						<el-input v-else-if="config.formConfig.type === 'textarea'" v-model="form[config.prop]" type="textarea" :placeholder="config.formConfig.placeholder" :rows="config.formConfig.rows || 3" />

						<!-- 数字输入框 -->
						<el-input-number v-else-if="config.formConfig.type === 'number'" v-model="form[config.prop]" :placeholder="config.formConfig.placeholder" :min="config.formConfig.min" :max="config.formConfig.max" :precision="config.formConfig.precision" style="width: 100%" />

						<!-- 日期选择器 -->
						<el-date-picker v-else-if="config.formConfig.type === 'date'" v-model="form[config.prop]" type="date" :placeholder="config.formConfig.placeholder" style="width: 100%" />

						<!-- 日期时间选择器 -->
						<el-date-picker v-else-if="config.formConfig.type === 'datetime'" v-model="form[config.prop]" type="datetime" :placeholder="config.formConfig.placeholder" value-format="yyyy-MM-dd HH:mm:ss" style="width: 100%" />

						<!-- 时间选择器 -->
						<el-time-picker v-else-if="config.formConfig.type === 'time'" v-model="form[config.prop]" :placeholder="config.formConfig.placeholder" style="width: 100%" />

						<!-- 开关 -->
						<el-switch v-else-if="config.formConfig.type === 'switch'" v-model="form[config.prop]" />

						<!-- 单选框组 -->
						<el-radio-group v-else-if="config.formConfig.type === 'radio'" v-model="form[config.prop]">
							<el-radio v-for="option in getSelectOptions(config.formConfig.options)" :key="getOptionValue(option, config.formConfig)" :label="getOptionValue(option, config.formConfig)">
								{{ getOptionLabel(option, config.formConfig) }}
							</el-radio>
						</el-radio-group>

						<!-- 多选框组 -->
						<el-checkbox-group v-else-if="config.formConfig.type === 'checkbox'" v-model="form[config.prop]">
							<el-checkbox v-for="option in getSelectOptions(config.formConfig.options)" :key="getOptionValue(option, config.formConfig)" :label="getOptionValue(option, config.formConfig)">
								{{ getOptionLabel(option, config.formConfig) }}
							</el-checkbox>
						</el-checkbox-group>

						<!-- 默认显示文本 -->
						<span v-else>{{ form[config.prop] }}</span>
					</el-form-item>
				</div>
			</el-col>
		</el-row>
	</el-form>
</template>

<script>
import { createConfigManager } from '@/utils/configManager';
import { validationRules, validateChineseName } from '@/api/tool';

export default {
	name: 'DynamicForm',
	props: {
		// 配置对象
		config: {
			type: Object,
			required: true
		},
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
		// 外部数据（如省市列表等）
		externalData: {
			type: Object,
			default: () => ({})
		}
	},
	data() {
		return {
			form: {},
			rules: {},
			configManager: null,
			groupedFormConfig: [],
			// 内置验证器映射
			validatorMap: {
				validateChineseName
			}
		};
	},
	watch: {
		// 监听父组件传入的表单数据变化
		formData: {
			handler(newVal) {
				// 确保configManager已经初始化后再初始化表单
				this.$nextTick(() => {
					this.initForm(newVal);
				});
			},
			immediate: true,
			deep: true
		},
		// 监听配置变化
		config: {
			handler() {
				this.initConfig();
				// 配置初始化完成后，重新初始化表单数据
				this.$nextTick(() => {
					this.initForm(this.formData);
				});
			},
			immediate: true
		}
	},
	mounted() {
		// 组件挂载后清除初始验证状态
		this.$nextTick(() => {
			if (this.$refs.form) {
				this.$refs.form.clearValidate();
			}
		});
	},
	computed: {
		// 多列布局配置 - 基于sortIndex进行垂直优先排列
		multiColumnConfig() {
			if (!this.configManager) {
				return [];
			}

			// 使用configManager的getMultiColumnFormConfig方法
			return this.configManager.getMultiColumnFormConfig();
		}
	},
	methods: {
		// 初始化配置
		initConfig() {
			this.configManager = createConfigManager(this.config);
			this.groupedFormConfig = this.configManager.getGroupedFormConfig();
			this.initRules();
		},

		// 初始化表单
		initForm(data = {}) {
			if (!this.configManager) {
				console.warn('DynamicForm: ConfigManager 未初始化，无法初始化表单数据');
				return;
			}

			try {
				this.form = this.configManager.generateFormData(data);
				// 在下一个tick中清除验证状态，防止初始化时显示错误信息
				this.$nextTick(() => {
					if (this.$refs.form) {
						this.$refs.form.clearValidate();
					}
				});
			} catch (error) {
				console.error('DynamicForm: 表单数据初始化失败', error);
			}
		},

		// 初始化验证规则
		initRules() {
			this.rules = {};
			// 通过configManager获取配置的验证规则 configManager.js
			const configRules = this.configManager.getFormRules();
			Object.keys(configRules).forEach(prop => {
				this.rules[prop] = this.processRules(configRules[prop]);
			});
		},

		// 处理验证规则（将字符串验证器转换为函数）
		processRules(rules) {
			// 如果 rules 不是数组，直接返回（可能是单个规则对象）
			if (!Array.isArray(rules)) {
				// 如果是单个规则对象，将其包装成数组再处理
				if (typeof rules === 'object' && rules !== null) {
					return [rules];
				}
				return [];
			}

			return rules.map(rule => {
				if (rule.validator && typeof rule.validator === 'string') {
					// 查找内置验证器
					if (this.validatorMap[rule.validator]) {
						return { ...rule, validator: this.validatorMap[rule.validator] };
					}
					// 查找validation tools中的验证器
					if (validationRules[rule.validator]) {
						return { ...rule, ...validationRules[rule.validator] };
					}
				}
				return rule;
			});
		},

		// 获取选择器选项
		getSelectOptions(optionsKey) {
			if (typeof optionsKey === 'string') {
				// 从外部数据或组件数据中获取
				return this.externalData[optionsKey] || this[optionsKey] || [];
			}
			if (Array.isArray(optionsKey)) {
				return optionsKey;
			}
			return [];
		},

		// 获取选项的标签
		getOptionLabel(option, config) {
			if (typeof option === 'object' && config.optionLabel) {
				return option[config.optionLabel];
			}
			return option.label || option.name || option;
		},

		// 获取选项的值
		getOptionValue(option, config) {
			if (typeof option === 'object' && config.optionValue) {
				return option[config.optionValue];
			}
			return option.value || option.id || option;
		},

		// 处理输入框禁止输入空格
		handleInputTrim(val, prop) {
			if (val && val.indexOf(' ') !== -1) {
				this.form[prop] = val.replace(/\s+/g, '');
			}
		},

		// 处理选择器变化
		handleSelectChange(prop, value, changeMethod) {
			if (changeMethod && typeof this[changeMethod] === 'function') {
				this[changeMethod](value);
			}
			this.$emit('field-change', { prop, value });
		},

		// 更新字段值 - 供插槽使用
		updateFieldValue(prop, value) {
			this.form[prop] = value;
			this.$emit('field-change', { prop, value });
		},

		// 表单验证方法 - 供父组件调用
		async validateForm() {
			try {
				const isValid = await this.$refs.form.validate();
				return isValid;
			} catch (error) {
				console.error('表单验证失败:', error);
				return false;
			}
		},

		// 清除验证状态
		clearValidate() {
			if (this.$refs.form) {
				this.$refs.form.clearValidate();
			}
		},

		// 验证指定字段
		validateField(props) {
			if (this.$refs.form) {
				this.$refs.form.validateField(props);
			}
		},

		// 提交表单处理（兼容旧版本）
		handleSubmit() {
			return this.validateForm();
		},

		// 简化的 handleProcess - 仅用于弹窗系统兼容
		async handleProcess() {
			// 只做验证，不处理业务逻辑
			const isValid = await this.validateForm();
			if (!isValid) {
				return Promise.reject(new Error('表单验证失败'));
			}
			return Promise.resolve(this.getFormData());
		},

		// 取消/关闭操作处理函数 - 弹窗系统要求的方法
		handleReject() {
			// 清理表单状态
			this.clearValidate();
			this.$emit('cancel');
			return Promise.resolve();
		},

		// 重置表单
		resetForm() {
			if (this.$refs.form) {
				this.$refs.form.resetFields();
			}
			this.clearValidate();
			this.initForm();
		},

		// 获取表单数据
		getFormData() {
			return { ...this.form };
		},

		// 设置表单数据
		setFormData(data) {
			this.initForm(data);
		}
	}
};
</script>

<style scoped>
/* 表单样式 */
.el-form {
	padding: 20px 0;
}

.el-form-item {
	margin-bottom: 18px;
}
</style>
