<!-- 通用的银行卡账户类型填充 需要配合 mixin_bankType 使用 -->

<template>
	<div>
		<el-select :disabled="optionBaned" v-model="localSelectType" placeholder="请选择账户类型" @change="handleEmitType">
			<el-option v-for="item in dict.type.order_bank_card_type_nodel" :key="item.value" :label="item.label"
				:value="item.value" />
		</el-select>
	
		<el-button v-if="flag" type="primary" @click="handleReopenDrawer">修改</el-button>
		<el-drawer ref="drawer" title="承兑信息填写" :visible.sync="drawer" direction="rtl" :before-close="handleClose"
			:append-to-body="true" size="55%">
			<BankacceptanceForm :bankacceptance-info="bankacceptanceInfo" @submitForm="handleSubmit"
				@cancel="() => (drawer = false)" @assign="handleAssign" :bill-type="billType"
				:is-internal-transfer="isInternalTransfer" />
		</el-drawer>
	</div>
</template>

<script>
import BankacceptanceForm from '@/views/dashboard/components/bankacceptance/components/BankacceptanceForm.vue';
import { BankAcceptanceType } from '@/api/tool/enums';
import { getBankAcceptance } from '@/api/system/bankAcceptance';
import { MessageBox } from 'element-ui'; // 引入 ElementUI 的 MessageBox 组件
import _ from 'lodash';
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
    },
    // 接收父组件传递的承兑信息
    externalBankacceptanceInfo: {
      type: Object,
      default: () => ({})
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
    // 监听父组件传递的承兑信息变化
    externalBankacceptanceInfo: {
      handler(newVal) {
        // 如果有承兑信息且不是空对象，应该显示修改按钮
        if (newVal && Object.keys(newVal).length > 0) {
          // 避免无限循环：只有当内容真正不同时才更新
          if (JSON.stringify(this.bankacceptanceInfo) !== JSON.stringify(newVal)) {
            this.bankacceptanceInfo = { ...newVal };
            this.flag = true;
          }
        }
      },
      deep: true,
      immediate: true
    }
  },
  methods: {
    // 设置已填写承兑信息状态
    setAcceptanceFilled() {
      // 同时保存承兑信息到sessionStorage
      sessionStorage.setItem(this.bankAcceptanceFilledKey, JSON.stringify(this.bankacceptanceInfo));
    },
    // 清除承兑信息填写状态
    clearAcceptanceFillStatus() {
      sessionStorage.removeItem(this.bankAcceptanceFilledKey);
    },
    // 清除所有共享状态
    clearAllAcceptanceStatus() {
      sessionStorage.removeItem(this.bankAcceptanceFilledKey);
    },
    // 修改承兑信息的处理方法
    handleReopenDrawer() {
      // 在打开抽屉前，确保承兑信息已经加载
      const json = sessionStorage.getItem(this.bankAcceptanceFilledKey);
      if (json) {
        try {
          this.bankacceptanceInfo = JSON.parse(json);
          console.log('修改模式加载承兑信息:', this.bankacceptanceInfo);
        } catch (error) {
          console.error('解析承兑信息失败:', error);
        }
      }
      // 直接打开抽屉进行修改
      this.drawer = true;
    },
    // 传递给父组件 然后更新父组件的 selectedType 值
    handleEmitType(value) {
      // 重要：只有当不是承兑类型时才清空承兑的填写状态
      if (value !== BankAcceptanceType.ACCEPTANCE) {
        this.clearAcceptanceFillStatus();
      }
      this.$emit('updateBankAcceptance', null);
      this.$emit('updateSelectedType', value);
      if (BankAcceptanceType.ACCEPTANCE === value) {
        // 如果选择了承兑类型
        if (this.baned) {
          return;
        }
        const json = sessionStorage.getItem(this.bankAcceptanceFilledKey);
        console.log('从sessionStorage获取数据:', json);

        // 检查是否已经填写过承兑信息
        if (json) {
          try {
            // 从sessionStorage恢复已保存的承兑信息
            this.bankacceptanceInfo = JSON.parse(json);
            this.flag = true;
            console.log('恢复的承兑信息:', this.bankacceptanceInfo);
            // 通知父组件已有承兑信息
            this.$emit('updateBankAcceptance', _.cloneDeep(this.bankacceptanceInfo));
          } catch (error) {
            console.error('解析承兑信息失败:', error);
            // 解析失败时直接打开抽屉
            this.drawer = true;
          }
        } else {
          // 未填写过，直接打开抽屉
          this.drawer = true;
        }
      }
    },
    // 右侧滑窗的提交逻辑
    handleSubmit(value) {
      // 新扔一个emit 给父组件用
      this.$emit('updateBankAcceptance', _.cloneDeep(value));
      this.flag = true;
      this.drawer = false;
      this.bankacceptanceInfo = value;
      // 保存数据到sessionStorage
      this.setAcceptanceFilled();
      console.log('承兑信息已保存到sessionStorage:', value);

      // 在内部转账场景下，设置默认的收票事由为内部转账
      if (this.isInternalTransfer && value) {
        value.reason = '内部转账';
      }

      this.$message.success('承兑信息保存成功');
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
    // 组件销毁时清除当前组件的sessionStorage
    sessionStorage.removeItem(this.bankAcceptanceFilledKey);
  }
};
</script>

<style></style>
