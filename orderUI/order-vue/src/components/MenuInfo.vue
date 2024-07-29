<template>
  <lay-menu
    :tree="true"
    theme="light"
    v-model:selected-key="selectKey"
    v-model:openKeys="openKeys"
    @changeSelectedKey="handleChooseKey"
    @changeOpenKeys="handleOpenKeys"
    :indent="true"
    :level="true"
    :collapse="collapse"
    :collapse-transition="collapseTransition"
    style="border-top: #1ab394 3px solid; height: 700px; overflow: scroll"
  >
    <Menu :menuData="menuData"></Menu>
  </lay-menu>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import Menu from './Menu.vue'
import { useManuTabsStore, useSwitchStore, useSysMenuInfoStore } from '../store'
import { getMenu } from '../api/api/system/menu.ts'
import { layer } from '@layui/layui-vue'
//先拿到显示与隐藏
defineProps(['collapse'])
const collapseTransition = ref(true)

//菜单
const menu_store = useSysMenuInfoStore()
const menuData = menu_store.getMenuList() //获取菜单信息
const openKeys = ref([])
const selectKey = ref('')

//展开和关闭
const menu_tabs_store = useManuTabsStore()
const switch_store = useSwitchStore()
const handleChooseKey = (props: any) => {
  selectKey.value = props
  //获取菜单详细信息
  getMenu(props)
    .then((r) => {
      menu_tabs_store.addToOpenList(r.data.data)
    })
    .catch((e) => {
      layer.msg({} + e.msg, { time: 1000, icon: 2 })
    })
  //自动聚焦
  switch_store.changeFocus(props)
  switch_store.changeSelectedKey(props.toString())
}
const handleOpenKeys = (keys: any) => {
  openKeys.value = keys
}
</script>

<style scoped></style>
