<template>
  <el-dialog :close-on-click-modal="false" :show-close="false"
      title="发货单"
      :visible.sync="Order1Visible"
      width="75%">
    <!--      发货单主体-->
    <el-row>
      <ChatForm/>
    </el-row>
    <span slot="footer" class="dialog-footer">
    <el-button @click="close">取 消</el-button>
    <el-button type="primary" @click="close">确 定</el-button>
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
  },
  methods: {
    close() {
      this.$emit('close')
    }
  }
}
</script>
