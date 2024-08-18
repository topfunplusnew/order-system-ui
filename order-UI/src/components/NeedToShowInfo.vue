<!--申请审核需要展示的对应的表信息-->
<script>


import {TableName} from "@/api/tool/enums";
import CARS from "@/components/NeedToShow/CARS.vue";
import BORROWMONEY from "@/components/NeedToShow/BORROWMONEY.vue";
import ORDER_FREIGHT from "@/components/NeedToShow/ORDER_FREIGHT.vue";

export default {
  name: "needToShowInfo",
  props: {
    needToShowInfo: {},
    tableNameToProp: ''
  },
  data() {
    return {
      info: {}
    }
  },
  watch: {
    needToShowInfo(val) {
      this.info = val;
    },
    tableNameToProp(val) {
      switch (val) {
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
          return ORDER_FREIGHT
        }
      }
    }
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
          return ORDER_FREIGHT
        }
      }
    },
  }
}
</script>

<template>
  <div v-if="needToShowInfo">
    <component :is="show" :needToShowInfo="info"/>
  </div>
</template>

<style scoped lang="scss">

</style>
