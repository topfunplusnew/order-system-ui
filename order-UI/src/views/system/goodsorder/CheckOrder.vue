<template>
  <el-dialog
      title="货物信息详细"
      :visible.sync="checkOrderVisible"
      width="80%">
    <!--      订单基本信息-->
    <el-descriptions border>
      <el-descriptions-item label="订单日期">{{ orderInfo.orderDate }}</el-descriptions-item>
      <el-descriptions-item label="客户">{{ orderInfo.customer }}</el-descriptions-item>
      <el-descriptions-item label="销售经理">{{ orderInfo.saleManager }}</el-descriptions-item>
      <el-descriptions-item label="陆运车牌">{{ orderInfo.landCarNo }}</el-descriptions-item>
      <el-descriptions-item label="陆运司机姓名">{{ orderInfo.landDriverName }}</el-descriptions-item>
      <el-descriptions-item label="陆运司机电话">{{ orderInfo.landDriverTel }}</el-descriptions-item>
      <el-descriptions-item label="海运车牌">{{ orderInfo.seaCarNo }}</el-descriptions-item>
      <el-descriptions-item label="海运司机姓名">{{ orderInfo.seaDriverName }}</el-descriptions-item>
      <el-descriptions-item label="海运司机电话">{{ orderInfo.seaDriverTel }}</el-descriptions-item>
      <el-descriptions-item label="车队">{{ orderInfo.fleet }}</el-descriptions-item>
    </el-descriptions>
    <OrderDetailInfo :order-detail-info-list="orderInfo.orderDetailList"></OrderDetailInfo>
    <el-descriptions border>
      <el-descriptions-item label="备注">{{ orderInfo.comments }}</el-descriptions-item>
    </el-descriptions>
    <span slot="footer" class="dialog-footer">
        <el-button @click="close">取 消</el-button>
        <el-button type="primary" @click="close">确 定</el-button>
      </span>
  </el-dialog>
</template>
<script>
import OrderDetailInfo from "@/components/OrderDetailInfo.vue"

export default {
  name: 'CheckOrder',
  components: {OrderDetailInfo},
  props: {
    checkOrderVisible: {},
    orderInfo: {}
  },
  methods: {
    close() {
      this.$emit('close')
    },
  }
}
</script>
