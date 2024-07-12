<template>
    <lay-menu :tree="true" theme="light" v-model:selected-key="selectKey" v-model:openKeys="openKeys"
              @changeSelectedKey="handleChooseKey" @changeOpenKeys="handleOpenKeys" :indent="true" :level="true"
              :collapse="collapse" :collapse-transition="collapseTransition">
        <Menu :menuData="menuData"></Menu>
    </lay-menu>
</template>

<script setup lang="ts">
import {ref} from "vue";
import Menu from "./Menu.vue";
//先拿到显示与隐藏
defineProps(['collapse'])
const collapseTransition = ref(true);
//菜单
const menuData = [
    {
        id: 1,
        title: '首页',
        children: []
    },
    {
        id: 2,
        title: '菜单',
        open: false, // 控制子菜单是否展开
        children: [
            {
                id: 3,
                title: '菜单1',
                children: [],
                open: false
            },
            {
                id: 4,
                title: '菜单2',
                children: [],
                open: false,
            },
            {
                id: 5,
                title: '菜单3',
                open: false,
                children: [
                    {
                        id: 6,
                        title: "菜单3-1",
                        open: false,
                        children: []
                    },
                    {
                        id: 7,
                        title: "菜单3-2",
                        open: false,
                        children: []
                    }
                ]
            },
            {
                id: 8,
                title: '菜单4',
                children: [
                    {
                        id: 9,
                        title: "菜单4-1",
                        open: false,
                        children: []
                    },
                    {
                        id: 10,
                        title: "菜单4-2",
                        open: false,
                        children: []
                    }
                ]
            }
        ]
    }
];
const openKeys = ref([])
const selectKey = ref("")
//展开和关闭
const handleChooseKey = (props) => {
    selectKey.value = props;
    console.log(props)
}
const handleOpenKeys = (keys) => {
    openKeys.value = keys;
    console.log(keys)
}

</script>

<style scoped>

</style>
