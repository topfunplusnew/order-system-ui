<!-- 通用的银行卡账户类型填充 需要配合 mixin_bankType 使用 -->

<template>
	<div>
		<el-select v-model="localSelectType" placeholder="请选择账户类型" @change="handleEmitType">
			<el-option v-for="item in dict.type.order_bank_card_type_nodel" :key="item.value" :label="item.label" :value="item.value" />
		</el-select>
	</div>
</template>

<script>
export default {
	name: 'BankType',
	dicts: ['order_bank_card_type_nodel'],
	props: {
		// 已经选择的
		selectType: {
			type: String,
			default: null
		}
	},
	data() {
		return {
			localSelectType: null
		};
	},
	watch: {
		selectType(newVal) {
			this.localSelectType = newVal;
		},
		localSelectType(newVal) {
			this.$emit('updateSelectedType', newVal);
		}
	},
	methods: {
		// 传递给父组件 然后更新父组件的 selectedType 值
		handleEmitType(value) {
			this.$emit('updateSelectedType', value);
		}
	}
};
</script>
