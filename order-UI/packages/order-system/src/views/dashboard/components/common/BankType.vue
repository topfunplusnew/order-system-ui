<!-- 通用的银行卡账户类型填充 需要配合 mixin_bankType 使用 -->

<template>
	<div>
		<el-select v-model="localSelectType" placeholder="请选择账户类型" @change="handleEmitType">
			<el-option v-for="item in dict.type.order_bank_card_type_nodel" :key="item.value" :label="item.label" :value="item.value" />
		</el-select>

		<el-button v-if="flag" type="warning" @click="drawer = true">重新填写</el-button>
		<el-drawer ref="drawer" title="承兑信息填写" :visible.sync="drawer" direction="rtl" :before-close="handleClose" :append-to-body="true" size="55%">
			<BankacceptanceForm :bankacceptance-info="bankacceptanceInfo" @submitForm="handleSubmit" @cancel="() => (drawer = false)" @assign="handleAssign" />
		</el-drawer>
	</div>
</template>

<script>
import BankacceptanceForm from '@/views/dashboard/components/bankacceptance/components/BankacceptanceForm.vue';
import { BankAcceptanceType } from '@/api/tool/enums';
import { getBankAcceptance } from '@/api/system/bankAcceptance';

export default {
	name: 'BankType',
	components: { BankacceptanceForm },
	dicts: ['order_bank_card_type_nodel'],
	props: {
		// 已经选择的
		selectType: {
			type: String,
			default: null
		},
		// 是否禁用承兑右侧滑窗
		baned: {
			type: Boolean,
			default: false
		}
	},
	data() {
		return {
			localSelectType: null,
			// 右侧抽屉
			drawer: false,
			flag: false,
			bankacceptanceInfo: {}
		};
	},
	mounted() {
		// 传递过来的 只可能是数字 或者是false 如果是数字 就要拿取对应的承兑信息
		this.$bus.$on('changeFlag', value => {
			if (this.baned) {
				this.flag = false;
				return;
			}
			if (!value) {
				this.flag = value;
				return;
			}
			// 获取承兑信息
			getBankAcceptance(value).then(res => {
				this.bankacceptanceInfo = res.data;
				this.flag = true;
			});
		});
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
			if (BankAcceptanceType.ACCEPTANCE === value && !this.baned) {
				this.drawer = true;
			}
		},
		// 右侧滑窗的提交逻辑
		handleSubmit(value) {
			// 新扔一个emit 给父组件用
			this.$emit('updateBankAcceptance', value);
			this.flag = true;
			this.drawer = false;
			this.$message.success('承兑信息填写成功');
		},
		// 抽屉关闭的逻辑
		handleClose(done) {
			done();
		},
		handleAssign(value) {
			this.$emit('updateBankAcceptance', value);
		}
	}
};
</script>

<style></style>
