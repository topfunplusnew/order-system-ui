<template>
    <div>
        <header>
            <lay-tab type="card" allow-close v-model="current" @change="change" @close="close">
                <lay-tab-item v-for="a in mockData" :key="a" :title="a.title" :id="a.id" :closable="a.closable">
                    内容{{ a.id }}
                </lay-tab-item>
            </lay-tab>
        </header>
    </div>
</template>

<script setup lang="ts">
import {computed, ref} from "vue";
import {useManuTabsStore} from "../../store";

const current = ref(1)
const menu_tabs_store = useManuTabsStore();
//computed可以缓存计算结果
const mockData = computed(() => {
    return menu_tabs_store.menuOpenList
});
const change = function (id) {
    console.log('打开的id=', id)
}
const close = (id) => {
    menu_tabs_store.deleteToOpenList(id)
    console.log('关闭的id=', id)
}
//选项卡的数据
// defineProps(['mockData'])


</script>

<style scoped>

</style>
