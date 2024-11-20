<script>
import OrderDetailInfo from "@/views/dashboard/components/goodsOrder/OrderDetailInfo.vue";

export default {
  name: "ORDER_DETAIL",
  components: {OrderDetailInfo},
  props: {
    needToShowInfo: {
      type: Object
    }
  }
}
</script>

<template>
  <div>
    <OrderDetailInfo :orderDetailInfoList="needToShowInfo" :ban="true"/>
  </div>
</template>

<style scoped lang="scss">

</style>
