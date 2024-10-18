<!--查看文件的组件-->

<script>
import {check_file} from "../views/dashboard/mixins/utils/check_file";

export default {
  name: "CheckFiles",
  mixins: [check_file],
  props: {
    path: {
      type: String,
      default: ''
    }
  },
  methods: {
    checkFiles(path) {
      window.open(path)
    }
  }
}
</script>

<template>
  <div>
    <div v-if="!path">
      无附件
    </div>
    <div v-else>
      <el-button size="mini" @click="checkFiles(path)">查看附件</el-button>
    </div>
  </div>
</template>

<style scoped lang="scss">

</style>
