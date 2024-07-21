<template>
    <div>
        <header style="border-top:3px solid #16baaa;">
            <lay-tab allow-close v-model="current" @change="change" @close="close" type="brief">
                <!-- todo 是否可以关闭-->
                <lay-tab-item v-for="a in mockData" :key="a" :title="a.menuName" :id="a.menuId" closable="1">
                    <!-- 首页-->
                    <!-- 这里的menuId会变化 注意-->
                    <HomeInfo v-if="a.menuId == 1"/>
                    <!-- 测试-->
                    <FormInfo v-if="a.menuId == 100"/>
                    <RoleInfo v-if="a.menuId == 101"/>
                    <MenuTakeInfo v-if="a.menuId == 102"/>
                    <DeptInfo v-if="a.menuId == 103"/>
                    <PostInfo v-if="a.menuId == 104"/>
                    <DeptInfo v-if="a.menuId == 105"/>
                    <CarInfo v-if="a.menuId == 2048"/>
                    <CompanyInfo v-if="a.menuId == 2054"/>
                    <!-- 动态组件 is绑定菜单名称-->
                    <!--  <component :is="a.menuName"/>-->
                </lay-tab-item>
            </lay-tab>
        </header>
    </div>
</template>

<script setup lang="ts">
import {computed,} from "vue";
import {useManuTabsStore, useSwitchStore} from "../../store";
import HomeInfo from "../../components/HomeInfo.vue";
import FormInfo from "../../components/system/FormInfo.vue";
import RoleInfo from "../../components/system/RoleInfo.vue";
import MenuTakeInfo from "../../components/system/MenuTakeInfo.vue";
import DeptInfo from "../../components/system/DeptInfo.vue";
import PostInfo from "../../components/system/PostInfo.vue";
import CarInfo from "../../components/order/CarInfo.vue";
import CompanyInfo from "../../components/order/CompanyInfo.vue";

const switch_store = useSwitchStore()
const menu_tabs_store = useManuTabsStore();


//computed可以缓存计算结果
const current = computed(() => {
    return switch_store.focus
})
const mockData = computed(() => {
    return menu_tabs_store.menuOpenList
});
const change = function (id) {
    switch_store.changeFocus(id)
}
const close = (id) => {
    menu_tabs_store.deleteToOpenList(id)
    console.log('关闭的id=', id)
}
</script>

<style scoped>

</style>
