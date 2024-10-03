<template>
  <el-dialog :close-on-click-modal="false"
      title="原订单信息"
      :visible.sync="checkReviousOrderInfoVisible"
      width="1100px">
    <el-row>
      <OrderInfos :order-info="previousOrderInfo"/>
    </el-row>
    <el-row>
      <OrderDetailInfo :orderDetailInfoList="previousOrderInfo.orderDetailList" :ban="true"/>
    </el-row>
    <span slot="footer" class="dialog-footer">
    <el-button @click="close">关 闭</el-button>
  </span>
  </el-dialog>
</template>
<script>
import OrderDetailInfo from "@/components/OrderDetailInfo.vue"
import OrderInfos from "../../../components/OrderInfos.vue"

export default {
  name: 'PreviousOrderInfo',
  components: {OrderDetailInfo, OrderInfos},
  props: {
    checkReviousOrderInfoVisible: {},
    previousOrderInfo: {}
  },
  methods: {
    close() {
      this.$emit('close')
    }
  }
}
</script>
