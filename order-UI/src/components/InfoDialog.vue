<!--弹窗通用组件 可以传入自定义的函数来进行使用 -->

<script>

export default {
  name: "InfoDialog",
  inheritAttrs: false,
  props: {
    title: String,
  },
  data() {
    return {}
  },
  methods: {
    onOpen() {
    },
    close() {
      this.$emit('update:visible', false);
    },
    confirm() {

    },
  },
  created() {

  },
  mounted() {
  },
  watch: {}
}
</script>

<template>
  <div>
    <el-dialog v-bind="$attrs" v-on="$listeners" @open="onOpen" :title="title" width="1100px">
      <!--      slot只是一个占位符 实际上还是在index.vue中作为子组件 所以可以直接在slot代表的组件中定义回调-->
      <slot name="info"></slot>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">

</style>
