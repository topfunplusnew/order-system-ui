<script>
import OrderInfos from "../../views/dashboard/components/goodsOrder/OrderInfos.vue";
import OrderDetailInfo from "../../views/dashboard/components/goodsOrder/OrderDetailInfo.vue";

export default {
  name: "GOODS_ORDER",
  components: {OrderDetailInfo, OrderInfos},
  props: {
    needToShowInfo: {
      type: Object
    }
  }
}
</script>

<template>
  <div>
    <OrderInfos :orderInfo="needToShowInfo"/>
    <OrderDetailInfo :orderDetailInfoList="needToShowInfo.orderDetailList" :ban="true"/>
  </div>
</template>

<style scoped lang="scss">

</style>
