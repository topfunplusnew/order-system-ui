<template>
  <!--    递归生成子菜单-->
    <div v-for="(item,index) in menuData" :key="index">
        <!--        如果当前item没有子菜单-->
        <lay-menu-item v-if="!item.children || item.children.length === 0" :id="item.id"
                       style="border-top: 1px solid #dddddd">
            <template #icon>
                <lay-icon type="layui-icon-home"></lay-icon>
            </template>
            {{ item.title }}
        </lay-menu-item>
        <!--      如果有子菜单-->
        <lay-sub-menu v-else :id="item.id" style="border-top: 1px solid #dddddd">
            <template #icon>
                <!--                使用 lay-icon来定义一个图表-->
                <lay-icon type="layui-icon-home"></lay-icon>
            </template>
            <!--            递归子菜单-->
            <Menu v-if="item.length !== 0" :menuData="item.children"></Menu>
            <template #title>
                {{ item.title }}
            </template>
        </lay-sub-menu>
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
