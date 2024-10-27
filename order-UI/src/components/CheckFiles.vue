<!--查看文件通用的的组件-->
<!-- 如果一个列需要展示文件 那么就可以用这个组件-->
<script>
import {check_file} from "../views/dashboard/mixins/utils/check_file";

export default {
  name: "CheckFiles",
  mixins: [check_file],
  props: {
    // 文件的地址url字段
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
      <el-button size="mini" type="text" @click="checkFiles(path)">查看附件</el-button>
    </div>
  </div>
</template>

<style scoped lang="scss">

</style>
