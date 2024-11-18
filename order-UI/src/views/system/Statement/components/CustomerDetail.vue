<!--客户科目明细表-->

<script>
import TotalTag from "@/views/system/Statement/components/TotalTag.vue";

export default {
  name: "CustomerDetail",
  components: {TotalTag},
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
      // 弹窗
      dialogVisible: false,
    }
  },
  methods: {
    // 查看明细
    handleCheck() {
      // todo 查询客户明细表
      this.dialogVisible = true
    }
  }
}
</script>

<template>
  <div>
    <!--    客户明细表的按钮-->
    <el-button type="primary" size="mini" @click="handleCheck">查看明细</el-button>

    <!--    客户明细表的弹窗-->
    <el-dialog
      title="提示"
      :visible.sync="dialogVisible"
      width="900px">
      <!--      客户明细表五个字段的显示组件 跟现在的客户明细表在一个查询框下
                含税货款、不含税货款、公户收款、私户收款、票点收入
                这五个数据-->
      <TotalTag/>
      <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">

</style>
