<template>
  <div>
    <header style="border-top: 3px solid #16baaa">
      <lay-tab
        allow-close
        v-model="current"
        @change="change"
        @close="close"
        type="brief"
      >
        <!-- todo 是否可以关闭-->
        <lay-tab-item
          v-for="a in mockData"
          :key="a"
          :title="a.menuName"
          :id="a.menuId"
          closable="1"
        >
          <!-- 首页-->
          <!-- 这里的menuId会变化 注意-->
          <HomeInfo v-if="a.menuId == 1" />
          <!-- 测试-->
          <FormInfo v-if="a.menuId == 100" />
          <RoleInfo v-if="a.menuId == 101" />
          <MenuTakeInfo v-if="a.menuId == 102" />
          <DeptInfo v-if="a.menuId == 103" />
          <PostInfo v-if="a.menuId == 104" />
          <DeptInfo v-if="a.menuId == 105" />
          <CarInfo v-if="a.menuId == 2048" />
          <CompanyInfo v-if="a.menuId == 2054" />
          <CompanyInfo v-if="a.menuId == 2060" />
          <ExwarehouseInfo v-if="a.menuId == 2066" />
          <FixedassetsInfo v-if="a.menuId == 2072" />
          <FleetInfo v-if="a.menuId == 2078" />
          <GoodsorderInfo v-if="a.menuId == 2084" />
          <InventoryInfo v-if="a.menuId == 2090" />
          <LendmoneyInfo v-if="a.menuId == 2096" />
          <OffsettingInfo v-if="a.menuId == 2102" />
          <OilcardmainInfo v-if="a.menuId == 2108" />
          <OilcardInfo v-if="a.menuId == 2114" />
          <OrderdetailInfo v-if="a.menuId == 2120" />
          <OrderfreightInfo v-if="a.menuId == 2126" />
          <Orderinvoice v-if="a.menuId == 2132" />
          <PaymentInfo v-if="a.menuId == 2138" />
          <ProductlevelInfo v-if="a.menuId == 2144" />
          <RebateInfo v-if="a.menuId == 2150" />
          <RecovermoneyInfo v-if="a.menuId == 2156" />
          <RepaymentInfo v-if="a.menuId == 2162" />
          <SocialinsuranceInfo v-if="a.menuId == 2168" />
          <StorehouseInfo v-if="a.menuId == 2174" />
          <TableeditmessageInfo v-if="a.menuId == 2180" />
          <VirtualbankaccountchangeInfo v-if="a.menuId == 2186" />
          <BackInfo v-if="a.menuId == 2000" />
          <BalanceaccountsInfo v-if="a.menuId == 2006" />
          <BankacceptanceInfo v-if="a.menuId == 2012" />
          <BankaccountchangeInfo v-if="a.menuId == 2018" />
          <BankaccountInfo v-if="a.menuId == 2024" />
          <BorrowedmoneyInfo v-if="a.menuId == 2030" />
          <BusinesstripInfo v-if="a.menuId == 2036" />
          <CarapplyInfo v-if="a.menuId == 2042" />
          <!-- 动态组件 is绑定菜单名称-->
          <!--  <component :is="a.menuName"/>-->
        </lay-tab-item>
      </lay-tab>
    </header>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useManuTabsStore, useSwitchStore } from '../../store'
import HomeInfo from '../../components/HomeInfo.vue'
import FormInfo from '../../components/system/FormInfo.vue'
import RoleInfo from '../../components/system/RoleInfo.vue'
import MenuTakeInfo from '../../components/system/MenuTakeInfo.vue'
import DeptInfo from '../../components/system/DeptInfo.vue'
import PostInfo from '../../components/system/PostInfo.vue'
import CarInfo from '../../components/order/CarInfo.vue'
import CompanyInfo from '../../components/order/CompanyInfo.vue'
import ExwarehouseInfo from '../../components/order/ExwarehouseInfo.vue'
import FixedassetsInfo from '../../components/order/FixedassetsInfo.vue'
import FleetInfo from '../../components/order/FleetInfo.vue'
import GoodsorderInfo from '../../components/order/GoodsorderInfo.vue'
import InventoryInfo from '../../components/order/InventoryInfo.vue'
import LendmoneyInfo from '../../components/order/LendmoneyInfo.vue'
import OffsettingInfo from '../../components/order/OffsettingInfo.vue'
import OilcardmainInfo from '../../components/order/OilcardmainInfo.vue'
import OilcardInfo from '../../components/order/OilcardInfo.vue'
import OrderdetailInfo from '../../components/order/OrderdetailInfo.vue'
import OrderfreightInfo from '../../components/order/OrderfreightInfo.vue'
import Orderinvoice from '../../components/order/Orderinvoice.vue'
import PaymentInfo from '../../components/order/PaymentInfo.vue'
import ProductlevelInfo from '../../components/order/ProductlevelInfo.vue'
import RebateInfo from '../../components/order/RebateInfo.vue'
import RecovermoneyInfo from '../../components/order/RecovermoneyInfo.vue'
import RepaymentInfo from '../../components/order/RepaymentInfo.vue'
import SocialinsuranceInfo from '../../components/order/SocialinsuranceInfo.vue'
import StorehouseInfo from '../../components/order/StorehouseInfo.vue'
import TableeditmessageInfo from '../../components/order/TableeditmessageInfo.vue'
import VirtualbankaccountchangeInfo from '../../components/order/VirtualbankaccountchangeInfo.vue'
import BackInfo from '../../components/order/BackInfo.vue'
import BalanceaccountsInfo from '../../components/order/BalanceaccountsInfo.vue'
import BankacceptanceInfo from '../../components/order/BankacceptanceInfo.vue'
import BankaccountchangeInfo from '../../components/order/BankaccountchangeInfo.vue'
import BankaccountInfo from '../../components/order/BankaccountInfo.vue'
import BorrowedmoneyInfo from '../../components/order/BorrowedmoneyInfo.vue'
import BusinesstripInfo from '../../components/order/BusinesstripInfo.vue'
import CarapplyInfo from '../../components/order/CarapplyInfo.vue'

const switch_store = useSwitchStore()
const menu_tabs_store = useManuTabsStore()

//computed可以缓存计算结果
const current = computed(() => {
  return switch_store.focus
})
const mockData = computed(() => {
  return menu_tabs_store.menuOpenList
})
console.log('mockData=>', mockData.value)
const change = function (id: number) {
  switch_store.changeFocus(id)
}
const close = (id: number) => {
  menu_tabs_store.deleteToOpenList(id)
  console.log('关闭的id=', id)
}
</script>

<style scoped></style>
