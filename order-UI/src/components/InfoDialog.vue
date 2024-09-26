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
    <el-dialog v-bind="$attrs" v-on="$listeners" @open="onOpen" :title="title" width="70%">
      <slot name="info"></slot>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">

</style>
