<script>
import OrderInfos from "../goodsOrder/OrderInfos.vue";
import {getGoodsOrder} from "../../../../api/system/goodsOrder";
import InfoDialog from "../../../../components/InfoDialog.vue";
import OrderDetailInfo from "../goodsOrder/OrderDetailInfo.vue";

export default {
  name: "CheckOrderInfo",
  components: {OrderDetailInfo, InfoDialog, OrderInfos},
  props: {
    row: {
      type: Object,
      default: {}
    }
  },
  data() {
    return {
      orderInfo: {},
      visible: false,
    }
  },
  methods: {
    // 查看运费对应的订单单据信息
    handleCheck(row) {
      // 拿到ordersNo 去查询订单信息
      getGoodsOrder(row.ordersNo).then(res => {
        this.orderInfo = res?.data
        this.visible = true;
      })
    }
  }
}
</script>

<template>
  <div>
    <el-button
      size="mini"
      type="text"
      @click="handleCheck(row)"
      v-hasPermi="['system:orderfreight:edit']"
    >查看订单单据
    </el-button>


    <!--    弹窗-->
    <InfoDialog :visible="visible" title="订单单据信息" :width="'750px'" @close="visible=false">
      <template #info>
        <OrderInfos :order-info="orderInfo"/>
        <OrderDetailInfo :ban="true" :order-detail-info-list="orderInfo.orderDetailList"/>
      </template>
    </InfoDialog>
  </div>
</template>

<style scoped lang="scss">

</style>
