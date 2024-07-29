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
          <component :is="Test" />
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
import Test from '../../view/Test.vue'
const switch_store = useSwitchStore()
const menu_tabs_store = useManuTabsStore()

//computed可以缓存计算结果
const current = computed(() => {
  return switch_store.focus
})
const mockData = computed(() => {
  return menu_tabs_store.menuOpenList
})
const change = function (id: number) {
  switch_store.changeFocus(id)
}
const close = (id: number) => {
  menu_tabs_store.deleteToOpenList(id)
  console.log('关闭的id=', id)
}
</script>

<style scoped></style>
