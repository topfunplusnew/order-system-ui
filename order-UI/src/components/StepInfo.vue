<script>
export default {
  name: "StepInfo",
  props: {
    processInfo: {
      type: Array,
      required: true
    }
  },
  computed: {
    //当前审核进度
    currentStep() {
      //找到step最大的
      return Math.max.apply(null, this.processInfo.map(item => item.step));
    }
  },
}
</script>

<template>
  <div>
    <el-steps :active="currentStep" finish-status="success" style="margin-top: 20px">
      <!--      循环-->
      <el-step v-for="item in processInfo" :status="item.checkState==='通过'?'success':'error'" :key="item.id">
        <template #title>
          <span style="font-weight: bolder">
            {{ item.flowname }}
          </span>
        </template>
        <template #description>
          <span style="font-weight: bolder">
            审核意见:{{ item.auditcomment === null ? '无' : item.auditcomment }}
          </span>
        </template>
      </el-step>
    </el-steps>
  </div>
</template>

<style scoped lang="scss">

</style>
