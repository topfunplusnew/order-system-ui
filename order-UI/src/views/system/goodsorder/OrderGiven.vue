<template>
  <el-dialog
      title="发货单"
      :visible.sync="Order1Visible"
      width="75%">
    <!--      发货单主体-->
    <el-row>
      <ChatForm/>
    </el-row>
    <span slot="footer" class="dialog-footer">
    <el-button @click="Order1Visible = false">取 消</el-button>
    <el-button type="primary" @click="Order1Visible = false">确 定</el-button>
  </span>
  </el-dialog>
</template>
<script>
import ChatForm from "@/components/ChatForm.vue"

export default {
  name: 'OrderGiven',
  components: {ChatForm},
  props: {
    Order1Visible: {}
  }
}
</script>