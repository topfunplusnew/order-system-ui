<!--付款申请组件-->
<script>
export default {
  name: "ApplyInfo",
  data() {
    return {
      dialogVisible: false
    }
  }
}
</script>

<template>
  <div>
    <el-dialog :close-on-click-modal="false"
      title="付款申请填写"
      :visible.sync="dialogVisible"
      width="30%">

      <!--      付款申请-->
      <el-row>

      </el-row>
      <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">

</style>
