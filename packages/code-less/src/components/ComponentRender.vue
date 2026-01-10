<template>
	<div class="component-render">
		<!-- 输入框 -->
		<el-form-item v-if="config.type === 'input'" :label="config.props.label" :prop="config.props.field" :rules="getRules(config)">
			<el-input v-model="localValue" :placeholder="config.props.placeholder" :disabled="config.props.disabled" :maxlength="config.props.maxlength" @input="handleInput"></el-input>
		</el-form-item>

		<!-- 多行文本 -->
		<el-form-item v-else-if="config.type === 'textarea'" :label="config.props.label" :prop="config.props.field" :rules="getRules(config)">
			<el-input v-model="localValue" type="textarea" :rows="config.props.rows || 3" :placeholder="config.props.placeholder" :disabled="config.props.disabled" @input="handleInput"></el-input>
		</el-form-item>

		<!-- 下拉选择 -->
		<el-form-item v-else-if="config.type === 'select'" :label="config.props.label" :prop="config.props.field" :rules="getRules(config)">
			<el-select v-model="localValue" :placeholder="config.props.placeholder" :multiple="config.props.multiple" :disabled="config.props.disabled" @change="handleInput">
				<el-option v-for="opt in config.props.options || []" :key="opt.value" :label="opt.label" :value="opt.value"></el-option>
			</el-select>
		</el-form-item>

		<!-- 日期选择 -->
		<el-form-item v-else-if="config.type === 'datepicker'" :label="config.props.label" :prop="config.props.field" :rules="getRules(config)">
			<el-date-picker v-model="localValue" :type="config.props.type || 'date'" :placeholder="config.props.placeholder" :disabled="config.props.disabled" @change="handleInput"></el-date-picker>
		</el-form-item>

		<!-- 单选框 -->
		<el-form-item v-else-if="config.type === 'radio'" :label="config.props.label" :prop="config.props.field" :rules="getRules(config)">
			<el-radio-group v-model="localValue" @change="handleInput">
				<el-radio v-for="opt in config.props.options || []" :key="opt.value" :label="opt.value">{{ opt.label }}</el-radio>
			</el-radio-group>
		</el-form-item>

		<!-- 多选框 -->
		<el-form-item v-else-if="config.type === 'checkbox'" :label="config.props.label" :prop="config.props.field" :rules="getRules(config)">
			<el-checkbox-group v-model="localValue" @change="handleInput">
				<el-checkbox v-for="opt in config.props.options || []" :key="opt.value" :label="opt.value">{{ opt.label }}</el-checkbox>
			</el-checkbox-group>
		</el-form-item>

		<!-- 按钮 -->
		<el-button v-else-if="config.type === 'button'" :type="config.props.type" :size="config.props.size">
			{{ config.props.text }}
		</el-button>

		<!-- 文本 -->
		<p v-else-if="config.type === 'text'" :style="textStyle">
			{{ config.props.content }}
		</p>

		<!-- 表格 -->
		<el-table v-else-if="config.type === 'table'" :data="tableData" :border="config.props.border" :stripe="config.props.stripe" style="width: 100%">
			<el-table-column v-for="col in config.props.columns || []" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width"></el-table-column>
		</el-table>

		<!-- 默认 -->
		<div v-else class="unknown-component">未知组件类型: {{ config.type }}</div>
	</div>
</template>

<script>
export default {
	name: 'ComponentRender',
	props: {
		config: {
			type: Object,
			required: true
		},
		formData: {
			type: Object,
			default: () => ({})
		},
		isPreview: {
			type: Boolean,
			default: false
		}
	},
	data() {
		return {
			localValue: ''
		};
	},
	computed: {
		textStyle() {
			const props = this.config.props || {};
			return {
				fontSize: (props.fontSize || 14) + 'px',
				color: props.color || '#333',
				fontWeight: props.fontWeight || 'normal',
				margin: '10px 0'
			};
		},
		tableData() {
			// 示例数据
			return [
				{ name: '示例数据1', value: '值1' },
				{ name: '示例数据2', value: '值2' }
			];
		}
	},
	watch: {
		formData: {
			immediate: true,
			deep: true,
			handler(val) {
				if (this.isPreview && this.config.props?.field) {
					this.localValue = val[this.config.props.field];
				}
			}
		}
	},
	created() {
		if (this.config.type === 'checkbox') {
			this.localValue = [];
		}
	},
	methods: {
		// 获取校验规则
		getRules(config) {
			if (!config.props?.required) return [];
			return [{ required: true, message: `请填写${config.props.label || '此项'}`, trigger: 'blur' }];
		},

		// 输入处理
		handleInput() {
			if (this.isPreview && this.config.props?.field) {
				this.$set(this.formData, this.config.props.field, this.localValue);
			}
		}
	}
};
</script>

<style scoped>
.component-render {
	width: 100%;
}
.unknown-component {
	padding: 10px;
	background: #fef0f0;
	color: #f56c6c;
	border-radius: 4px;
}
</style>
