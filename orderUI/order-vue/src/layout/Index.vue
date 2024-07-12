<template>
    <div>
        <Header>
            <lay-button type="normal" class="buttons" @click="handleCollapse">
                <lay-icon type="layui-icon-slider"></lay-icon>
            </lay-button>
        </Header>
        <div>
            <lay-row space="10">
                <div class="grid-demo left">
                    <MenuInfo :collapse="collapse"/>
                </div>
                <!--                右侧body-->
                <div class="left" style="width: 85%">
                    <Body :mockData="menuData"/>
                </div>
            </lay-row>

        </div>
    </div>
</template>

<script setup lang="ts">

import MenuInfo from "../components/MenuInfo.vue";
import Header from "./header/Index.vue"
import Body from './body/Index.vue'
import {ref} from "vue";

//点击隐藏功能
const collapse = ref(false)
const handleCollapse = () => {
    collapse.value = !collapse.value
}

//模拟数据
const menuData = [
    {
        id: 1,
        title: '首页',
        children: [],
        closable: false
    },
    {
        id: 2,
        title: '菜单',
        open: false, // 控制子菜单是否展开
        closable: true,
        children: [
            {
                id: 3,
                title: '菜单1',
                children: [],
                open: false,
                closable: true,
            },
            {
                id: 4,
                title: '菜单2',
                children: [],
                open: false,
                closable: true,
            },
            {
                id: 5,
                title: '菜单3',
                open: false,
                closable: true,
                children: [
                    {
                        id: 6,
                        title: "菜单3-1",
                        open: false,
                        closable: true,
                        children: []
                    },
                    {
                        id: 7,
                        title: "菜单3-2",
                        open: false,
                        closable: true,
                        children: []
                    }
                ]
            },
            {
                id: 8,
                title: '菜单4',
                closable: true,
                children: [
                    {
                        id: 9,
                        title: "菜单4-1",
                        open: false,
                        children: [],
                        closable: true,
                    },
                    {
                        id: 10,
                        title: "菜单4-2",
                        open: false,
                        children: [],
                        closable: true,
                    }
                ]
            }
        ]
    }
];
</script>

<style scoped>
.lay-split-panel-item {
    display: flex;
    font-size: 16px;
    font-weight: bold;
    justify-content: center;
    align-items: center;
}

</style>
