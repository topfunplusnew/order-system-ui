<!--申请审核需要展示的对应的表信息-->
<script>


  import { TableName } from '@/api/tool/enums';
  import CARS from '@/components/NeedToShow/CARS.vue';
  import BORROWMONEY from '@/components/NeedToShow/BORROWMONEY.vue';
  import ORDER_FREIGHT from '@/components/NeedToShow/ORDER_FREIGHT.vue';
  import OIL_RECHARGE from '@/components/NeedToShow/OIL_RECHARGE.vue';
  import INVOICE_IN from '@/components/NeedToShow/INVOICE_IN.vue';
  import GOODS_ORDER from './NeedToShow/GOODS_ORDER.vue';

  export default {
    name: 'NeedToShowInfo',
    props: {
      needToShowInfo: {},
      tableNameToProp: ''
    },
    data() {
      return {
        info: {}
      }
    },
    computed: {
      show() {
        switch (this.tableNameToProp) {
          // 如果是车辆信息
          case TableName.CARS: {
            return CARS
          }
          // 如果是借钱信息
          case TableName.BORROWED_MONEY: {
            return BORROWMONEY
          }
          // 如果是订单运费
          case TableName.ORDER_FREIGHT: {
            return ORDER_FREIGHT
          }
          // 如果是油卡充值
          case TableName.OIL_RECHARGE: {
            return OIL_RECHARGE
          }
          // 如果是发票购入
          case TableName.INVOICE_IN: {
            return INVOICE_IN
          }
          // 如果是订单打款
          case TableName.GOODS_ORDER: {
            return GOODS_ORDER
          }
        }
      },
    },
    watch: {
      needToShowInfo(val) {
        this.info = val;
      },
      tableNameToProp(val) {
        switch (val) {
          // 如果是车辆信息
          case TableName.CARS: {
            return CARS
          }
          // 如果是借钱信息
          case TableName.BORROWED_MONEY: {
            return BORROWMONEY
          }
          // 如果是订单运费
          case TableName.ORDER_FREIGHT: {
            return ORDER_FREIGHT
          }

          // 如果是油卡充值
          case TableName.OIL_RECHARGE: {
            return OIL_RECHARGE
          }

          // 如果是发票购入
          case TableName.INVOICE_IN: {
            return INVOICE_IN
          }
          // 如果是订单打款
          case TableName.GOODS_ORDER: {
            return GOODS_ORDER
          }
        }
      }
    }
  }
</script>

<template>
  <div v-if="needToShowInfo">
    <component :is="show" :needToShowInfo="info" />
  </div>
</template>

<style scoped lang="scss">

</style>
