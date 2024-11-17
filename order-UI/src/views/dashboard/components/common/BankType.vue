<!--银行卡账户类型选择的通用组件 分为现金户和承兑户 -->

<script>

export default {
  name: "BankType",
  dicts: ['order_bank_card_type_nodel'],
  data() {
    return {
      // 账户类型
      // types: [
      //   {
      //     value: '现金户',
      //     label: '现金户'
      //   },
      //   {
      //     value: '承兑户',
      //     label: '承兑户'
      //   }
      // ],
      // 选择的类型
      selectedType: null,
    }
  },
  methods: {
    // 传递给父组件 然后更新父组件的selectedType值
    handleEmitType(value) {
      this.$emit('updateSelectedType', value)
    }
  }
}
</script>

<template>
  <div>
    <el-select v-model="selectedType" placeholder="请选择账户类型" @change="handleEmitType">
      <el-option
        v-for="item in dict.type.order_bank_card_type_nodel"
        :key="item.value"
        :label="item.label"
        :value="item.value">
      </el-option>
    </el-select>
  </div>
</template>

<style scoped lang="scss">

</style>
