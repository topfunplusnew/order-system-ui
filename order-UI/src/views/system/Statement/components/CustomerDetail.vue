<!--客户科目明细表-->

<script>
export default {
  name: "CustomerDetail",
  props: {
    // 需要查看的那一行客户的信息
    detail: {
      type: Object,
      default: () => {
      }
    }
  },
  data() {
    return {
      dialogVisible: false,
    }
  },
  methods: {
    // 查看明细
    handleCheck() {
      // todo
      this.dialogVisible = true
    }
  }
}
</script>

<template>
  <div>
    <el-button type="primary" size="mini" @click="handleCheck">查看明细</el-button>

    <el-dialog
      title="提示"
      :visible.sync="dialogVisible"
      width="30%">
      <span>这是一段信息</span>
      <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">

</style>
