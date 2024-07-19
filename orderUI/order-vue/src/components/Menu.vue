<template>
  <!--    递归生成子菜单-->
    <div v-for="(item,index) in menuData" :key="index">
        <lay-sub-menu v-if="item.type != 'C'" :id="item.id" style="border-top: 1px solid #dddddd">
            <template #icon>
                <!--                使用 lay-icon来定义一个图表-->
                <lay-icon type="layui-icon-template-one"></lay-icon>
            </template>
            <!--            递归子菜单-->
            <Menu v-if="item.length !== 0" :menuData="item.children"></Menu>
            <template #title>
                {{ item.label }}
            </template>
        </lay-sub-menu>


        <lay-menu-item v-else :id="item.id"
                       style="border-top: 1px solid #dddddd">
            <template #icon>
                <lay-icon type="layui-icon-component"></lay-icon>
            </template>
            {{ item.label }}
        </lay-menu-item>
    </div>
</template>
<script setup lang="ts">
import {LayIcon} from "@layui/layui-vue";

defineProps(['menuData'])

</script>

<style scoped>
* {
    box-sizing: border-box;
}
</style>
