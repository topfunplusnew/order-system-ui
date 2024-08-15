<!--查看订单-->
<script>
import TagsItem from "@/components/TagsItem/index.vue";

export default {
  name: "OrderInfos",
  components: {TagsItem},
  props: {
    orderInfo: {}
  },
  data() {
    return {}
  },
  created() {

  },
  mounted() {
    console.log(this.orderInfo)
  },
  methods: {
    isOrNot(val) {
      return val === 1 ? "是" : "否";
    },
  }
}
</script>

<template>
  <div>
    <el-descriptions title="订单信息">
      <el-descriptions-item label="日期">{{ orderInfo.orderDate }}</el-descriptions-item>
      <el-descriptions-item label="客户">{{ orderInfo.customer }}</el-descriptions-item>
      <el-descriptions-item label="商家姓名">{{ orderInfo.supplierNames }}</el-descriptions-item>
      <el-descriptions-item label="车队">{{ orderInfo.fleet }}</el-descriptions-item>
      <el-descriptions-item label="审核状态">
        <TagsItem :check-info="orderInfo.checkState" checkValue="未审核"/>
      </el-descriptions-item>
      <el-descriptions-item label="开票状态">
        <TagsItem :check-info="orderInfo.invoiceState" checkValue="未开票"/>
      </el-descriptions-item>
      <el-descriptions-item label="附件">{{ orderInfo.path }}</el-descriptions-item>
      <el-descriptions-item label="陆运车牌">{{ orderInfo.landCarNo }}</el-descriptions-item>
      <el-descriptions-item label="陆运司机电话">{{ orderInfo.landDriverTel }}</el-descriptions-item>
      <el-descriptions-item label="陆运司机姓名">{{ orderInfo.landDriverName }}</el-descriptions-item>
      <el-descriptions-item label="海运车牌">{{ orderInfo.seaCarNo }}</el-descriptions-item>
      <el-descriptions-item label="海运司机电话">{{ orderInfo.seaDriverTel }}</el-descriptions-item>
      <el-descriptions-item label="海运司机姓名">{{ orderInfo.seaDriverName }}</el-descriptions-item>
      <el-descriptions-item label="打款状态">{{ orderInfo.PaymentState }}</el-descriptions-item>
      <el-descriptions-item label="陆运银行户名">{{ orderInfo.landBankName }}</el-descriptions-item>
      <el-descriptions-item label="陆运银行账号">{{ orderInfo.landBankNo }}</el-descriptions-item>
      <el-descriptions-item label="海运银行户名">{{ orderInfo.seaBankName }}</el-descriptions-item>
      <el-descriptions-item label="海运银行账号">{{ orderInfo.seaBankNo }}</el-descriptions-item>
      <el-descriptions-item label="收到条附件">{{ orderInfo.receiveProof }}</el-descriptions-item>
      <el-descriptions-item label="是否被调整单">
        <TagsItem :check-info=" orderInfo.isAdjusted " check-value="否"/>
      </el-descriptions-item>
      <el-descriptions-item label="调整日期" v-if=" orderInfo.isAdjusted">{{
          orderInfo.adjustDate
        }}
      </el-descriptions-item>
      <el-descriptions-item label="原订单编号">{{ orderInfo.adjustOrderid }}</el-descriptions-item>
      <el-descriptions-item label="是否可编辑">
        <TagsItem :check-info="isOrNot( orderInfo.isedit) " check-value="否"/>
      </el-descriptions-item>
      <el-descriptions-item label="客户是否开票">
        <TagsItem :check-info="isOrNot( orderInfo.customerIsInvoice)" check-value="否"/>
      </el-descriptions-item>
      <el-descriptions-item label="供应商是否开票">
        <TagsItem :check-info="isOrNot( orderInfo.customerIsInvoice)" check-value="否"/>
      </el-descriptions-item>
      <el-descriptions-item label="陆运费">{{ orderInfo.landFreight }}</el-descriptions-item>
      <el-descriptions-item label="海运费">{{ orderInfo.seaFreight }}</el-descriptions-item>
    </el-descriptions>
  </div>
</template>

<style scoped lang="scss">

</style>
