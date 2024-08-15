<!--申请审核需要展示的对应的表信息-->
<script>


import {TableName} from "@/api/tool/enums";
import CARS from "@/components/NeedToShow/CARS.vue";
import BORROWMONEY from "@/components/NeedToShow/BORROWMONEY.vue";

export default {
  name: "needToShowInfo",
  props: {
    needToShowInfo: {},
    tableNameToProp: ''
  },
  computed: {
    show() {
      switch (this.tableNameToProp) {
        //如果是车辆信息
        case TableName.CARS: {
          return CARS
        }
        //如果是借钱信息
        case TableName.BORROWED_MONEY: {
          return BORROWMONEY
        }
        //如果是订单运费
        case TableName.ORDER_FREIGHT: {

        }
      }
    }
  }
}
</script>

<template>
  <div v-if="needToShowInfo">
    <component :is="show" :needToShowInfo="needToShowInfo"/>
  </div>
</template>

<style scoped lang="scss">

</style>
