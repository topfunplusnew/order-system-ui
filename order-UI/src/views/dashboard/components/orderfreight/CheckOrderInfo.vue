<script>
import OrderInfos from "../goodsOrder/OrderInfos.vue";
import {checkOrderByOrderNo, getGoodsOrder} from "../../../../api/system/goodsOrder";
import InfoDialog from "../../../../components/InfoDialog.vue";
import OrderDetailInfo from "../goodsOrder/OrderDetailInfo.vue";

export default {
  name: "CheckOrderInfo",
  components: {OrderDetailInfo, InfoDialog, OrderInfos},
  props: {
    row: {
      type: Object,
      default: {}
    },
    title: {
      type: String,
      default: '查看订单单据'
    }
  },
  data() {
    return {
      // 订单信息 可能为 调整单
      orderInfo: {},
      // 如果订单为 调整单的原订单信息
      adjustedOrderInfo: {},
      visible: false,
      // tab页
      activeName: 'first'
    }
  },
  methods: {
    // 查看运费对应的订单单据信息
    handleCheck(row) {
      let orderNo = row.ordersNo || row.orderNo
      // 拿到ordersNo 去查询订单信息
      checkOrderByOrderNo(orderNo).then(res => {
        this.orderInfo = res.data;
        const id = res.data.id
        // 根据获取到的订单id获取订单详情
        getGoodsOrder(id).then(res => {
          this.orderInfo.orderDetailList = res.data.orderDetailList;
          this.visible = true;
        })
      })
    },
    // 切换tab时候 要查询
    handleClick(tab, event) {
      // 如果点击第二个标签 那么就要去查询原订单的信息
      if (event.target.innerHTML === '原订单信息') {
        getGoodsOrder(this.orderInfo.adjustOrderid).then(res => {
          this.adjustedOrderInfo = res.data;
        })
      }
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
      v-hasPermi="['system:freight:edit']"
    >{{ title }}
    </el-button>


    <!--    弹窗-->
    <InfoDialog :visible="visible" title="订单单据信息" :width="'980px'" @close="visible=false">
      <template #info>
        <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
          <!-- 查看订单(有可能为调整单)的信息 如果该订单是调整单 那么还要查看原订单的信息-->
          <el-tab-pane :label="orderInfo.adjustOrderid ? '订单信息(该订单为调整单)' : '该订单信息'" name="first">
            <OrderInfos :order-info="orderInfo"/>
            <OrderDetailInfo :ban="true" :order-detail-info-list="orderInfo.orderDetailList"/>
          </el-tab-pane>

          <!-- 如果订单为调整单 则要查看其的原订单信息-->
          <el-tab-pane v-if="orderInfo.adjustOrderid" label="原订单信息" name="second">
            <OrderInfos :order-info="adjustedOrderInfo"/>
            <OrderDetailInfo :ban="true" :order-detail-info-list="adjustedOrderInfo.orderDetailList"/>
          </el-tab-pane>
        </el-tabs>
      </template>
    </InfoDialog>
  </div>
</template>

<style scoped lang="scss">

</style>
