<script>
import OrderInfos from "../../views/dashboard/components/goodsOrder/OrderInfos.vue";
import OrderDetailInfo from "../../views/dashboard/components/goodsOrder/OrderDetailInfo.vue";

export default {
  name: "GOODSORDER",
  components: {OrderDetailInfo, OrderInfos},
  props: {
    needToShowInfo: {
      type: Object,
      default() {
        return {}
      }
    }
  }
}
</script>

<template>
  <div>
    <OrderInfos :order-info="needToShowInfo" />
    <OrderDetailInfo :order-detail-info-list="needToShowInfo.orderDetailList" :ban="true" />
  </div>
</template>

<style scoped lang="scss">

</style>
