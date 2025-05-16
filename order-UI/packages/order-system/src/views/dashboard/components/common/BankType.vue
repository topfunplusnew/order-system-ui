<!-- 通用的银行卡账户类型填充 需要配合 mixin_bankType 使用 -->

<template>
	<div>
		<el-select :disabled="optionBaned" v-model="localSelectType" placeholder="请选择账户类型" @change="handleEmitType">
			<el-option v-for="item in dict.type.order_bank_card_type_nodel" :key="item.value" :label="item.label" :value="item.value" />
		</el-select>

		<el-button v-if="flag" type="warning" @click="handleReopenDrawer">重新填写</el-button>
		<el-drawer ref="drawer" title="承兑信息填写" :visible.sync="drawer" direction="rtl" :before-close="handleClose" :append-to-body="true" size="55%">
			<BankacceptanceForm
				:bankacceptance-info="bankacceptanceInfo"
				@submitForm="handleSubmit"
				@cancel="() => (drawer = false)"
				@assign="handleAssign"
				:bill-type="billType"
				:is-internal-transfer="isInternalTransfer"
			/>
		</el-drawer>
	</div>
</template>

<script>
import BankacceptanceForm from '@/views/dashboard/components/bankacceptance/components/BankacceptanceForm.vue';
import { BankAcceptanceType } from '@/api/tool/enums';
import { getBankAcceptance } from '@/api/system/bankAcceptance';
import { MessageBox } from 'element-ui'; // 引入 ElementUI 的 MessageBox 组件

export default {
	name: 'BankType',
	components: { BankacceptanceForm },
	dicts: ['order_bank_card_type_nodel'],
	// 对于不需要选择的场景，设置optionBaned = true  banned= true
	props: {
		// 禁用选择
		optionBaned: {
			type: Boolean,
			default: false
		},
		// 已经选择的
		selectType: {
			type: String,
			default: null
		},
		// 是否禁用承兑右侧滑窗
		baned: {
			type: Boolean,
			default: false
		},
		billType: {
			type: String,
			default: '收入'
		},
		// 是否为内部转账
		isInternalTransfer: {
			type: Boolean,
			default: false
		},
		// 唯一标识，用于区分不同表单实例
		formId: {
			type: String,
			default: () => `bank-type-${Date.now()}`
		}
	},
	data() {
		return {
			localSelectType: null,
			// 右侧抽屉
			drawer: false,
			flag: false,
			bankacceptanceInfo: {},
			// 统一存储键，用于检查是否已填写过承兑信息
			bankAcceptanceFilledKey: 'bankAcceptanceFilled'
		};
	},
	mounted() {
		this.clearAllAcceptanceStatus();
		// 传递过来的 只可能是数字 或者是false 如果是数字 就要拿取对应的承兑信息
		this.$bus.$on('changeFlag', value => {
			if (this.baned) {
				this.flag = false;
				return;
			}
			if (!value) {
				this.flag = value;
				// 清除填写状态
				this.clearAcceptanceFillStatus();
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
		// 设置已填写承兑信息状态
		setAcceptanceFilled() {
			// 同时保存承兑信息到localStorage
			localStorage.setItem(this.bankAcceptanceFilledKey, JSON.stringify(this.bankacceptanceInfo));
		},
		// 清除承兑信息填写状态
		clearAcceptanceFillStatus() {
			localStorage.removeItem(this.bankAcceptanceFilledKey);
		},
		// 清除所有共享状态
		clearAllAcceptanceStatus() {
			localStorage.removeItem(this.bankAcceptanceFilledKey);
		},
		// 重新打开抽屉的处理方法
		handleReopenDrawer() {
			MessageBox.confirm('您确定要重新填写承兑信息吗？', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			})
				.then(() => {
					this.drawer = true;
				})
				.catch(() => {
					// 取消操作
				});
		},
		// 传递给父组件 然后更新父组件的 selectedType 值
		handleEmitType(value) {
			this.$emit('updateSelectedType', value);
			if (BankAcceptanceType.ACCEPTANCE === value) {
				// 如果选择了承兑类型
				if (this.baned) {
					return;
				}
				const json = localStorage.getItem(this.bankAcceptanceFilledKey);
				this.filledAcceptanceInfo = JSON.parse(JSON.stringify(json));

				// 检查是否已经填写过承兑信息
				if (this.filledAcceptanceInfo) {
					// 如果已经填写过，询问是否重新填写
					MessageBox.confirm('您已经填写过承兑信息，是否重新填写？', '提示', {
						confirmButtonText: '确定',
						cancelButtonText: '取消',
						type: 'warning'
					})
						.then(() => {
							// 用户确认，打开抽屉
							this.drawer = true;
						})
						.catch(() => {
							if (typeof this.filledAcceptanceInfo === 'string') {
								// 取消操作 使用已经保存的
								this.bankacceptanceInfo = JSON.parse(this.filledAcceptanceInfo);
								return;
							}
							// 取消操作 使用已经保存的
							this.bankacceptanceInfo = this.filledAcceptanceInfo;
						});
				} else {
					// 未填写过，直接打开抽屉
					this.drawer = true;
				}
			}
		},
		// 右侧滑窗的提交逻辑
		handleSubmit(value) {
			console.log(`承兑信息:`, value);
			// 新扔一个emit 给父组件用
			this.$emit('updateBankAcceptance', _.cloneDeep(value));
			this.flag = true;
			this.drawer = false;
			this.bankacceptanceInfo = value;
			this.setAcceptanceFilled();
			this.$message.success('承兑信息填写成功');
		},
		// 抽屉关闭的逻辑
		handleClose(done) {
			done();
		},
		handleAssign(value) {
			this.$emit('updateBankAcceptance', value);
		}
	},
	beforeDestroy() {
		// 组件销毁时清除当前组件的localStorage
		localStorage.removeItem(this.bankAcceptanceFilledKey);
	}
};
</script>

<style></style>
