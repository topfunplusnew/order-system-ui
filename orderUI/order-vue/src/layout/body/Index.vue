<template>
    <div>
        <header>
            <lay-tab type="card" allow-close v-model="current6" @change="change6">
                <lay-tab-item v-for="a in mockData" :key="a" :title="a.title" :id="a.id" :closable="a.closable">
                    内容{{ a.id }}
                </lay-tab-item>
            </lay-tab>
        </header>
    </div>
</template>

<script setup lang="ts">
import {ref} from "vue";

const current6 = ref('1')
const change6 = function (id) {
}
//选项卡的数据
defineProps(['mockData'])
</script>

<style scoped>

</style>
