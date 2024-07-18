<template>
    <div>
        <header>
            <lay-tab type="card" allow-close v-model="current" @change="change" @close="close">
                <!-- todo 是否可以关闭-->
                <lay-tab-item v-for="a in mockData" :key="a" :title="a.menuName" :id="a.menuId" closable="1">
                    内容{{ a.menuId }}
                </lay-tab-item>
            </lay-tab>
        </header>
    </div>
</template>

<script setup lang="ts">
import {computed,} from "vue";
import {useManuTabsStore, useSwitchStore} from "../../store";

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
