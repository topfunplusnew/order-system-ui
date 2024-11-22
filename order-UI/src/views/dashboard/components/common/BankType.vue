<!--银行卡账户类型选择的通用组件 分为现金户和承兑户 -->

<script>
export default {
  name: "BankType",
  dicts: ["order_bank_card_type_nodel"],
  props: {
    // 已经选择的
    selectType: {
      type: String,
      default: null,
    },
  },
  mounted() {
    // 如果父组件给值 那么就挂载默认值
    if (this.selectType) {
      // 初始化默认值
      this.selectedType = this.selectType;
    }
  },
  data() {
    return {
      selectedType: null,
    };
  },
  methods: {
    // 传递给父组件 然后更新父组件的selectedType值
    handleEmitType(value) {
      this.$emit("updateSelectedType", value);
    },
  },
};
</script>

<template>
  <div>
    <el-select
      v-model="selectedType"
      placeholder="请选择账户类型"
      @change="handleEmitType"
    >
      <el-option
        v-for="item in dict.type.order_bank_card_type_nodel"
        :key="item.value"
        :label="item.label"
        :value="item.value"
      >
      </el-option>
    </el-select>
  </div>
</template>

<style scoped lang="scss"></style>
