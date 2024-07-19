<!--首页信息-->
<template>
    <lay-row space="30">
        <lay-col md="12" sm="12" xs="24">
            <h2>今日发货列表
            </h2>
            <br>
            <lay-row>
                <lay-col>
                    <lay-date-picker v-model="startTime" placeholder="开始时间" allowClear
                                     style="float: left"></lay-date-picker>
                    <lay-date-picker v-model="endTime" placeholder="结束时间" allowClear
                                     style="float: left"></lay-date-picker>
                </lay-col>
                <lay-col>
                    <lay-button type="primary">搜索</lay-button>
                </lay-col>
            </lay-row>
            <lay-table :default-toolbar="true" :columns="columns" :data-source="dataSource"></lay-table>
        </lay-col>
        <lay-col md="12" sm="12" xs="24">
            <h2>利润</h2>
            <lay-panel>
                <lay-icon type="layui-icon-rmb"></lay-icon>
                <span style="font-size: 60px;margin-left: 15px">500</span>元
            </lay-panel>
            <br>
            <lay-row>
                <lay-col>
                    <lay-date-picker v-model="startTime1" placeholder="开始时间" allowClear
                                     style="float: left"></lay-date-picker>
                    <lay-date-picker v-model="endTime1" placeholder="结束时间" allowClear
                                     style="float: left"></lay-date-picker>
                </lay-col>
                <lay-col>
                    <lay-button type="primary">搜索</lay-button>
                </lay-col>
            </lay-row>
            <lay-row style="margin-top: 30px">
                <lay-table :columns="columns_money" :data-source="dataSource_money"></lay-table>
            </lay-row>
        </lay-col>
    </lay-row>
</template>

<script setup lang="ts">
import {ref} from "vue";

//订单列表的数据
const columns = [
    {
        title: "编号",
        width: "120px",
        key: "id"
    },
    {
        title: "名称",
        width: "100px",
        key: "name"
    },
    {
        title: "性别",
        width: "100px",
        key: "sex"
    },

    {
        title: "签名",
        width: "240px",
        key: "remark"
    },
]
const dataSource = [
    {
        id: "10001",
        name: "夏娜1",
        sex: "女",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10002",
        name: "夏娜2",
        sex: "女",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10003",
        name: "夏娜3",
        sex: "女",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10004",
        name: "夏娜4",
        sex: "女",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10005",
        name: "夏娜5",
        sex: "女",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10006",
        name: "夏娜6",
        sex: "女",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10007",
        name: "夏娜7",
        sex: "女",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10008",
        name: "夏娜8",
        sex: "女",
        remark: '不知江月待何人，但见长江送流水。'
    }
]

//利润数据
const columns_money = [
    {
        title: "利润总额",
        width: "120px",
        key: "moneyTotal"
    },
    {
        title: "费用合计",
        width: "100px",
        key: "costTotal"
    },
]
const dataSource_money = [
    {
        moneyTotal: 500,
        costTotal: 600
    }
]

//开始和结束时间
const startTime = ref(null)
const endTime = ref(null);
const startTime1 = ref(null)
const endTime1 = ref(null)
</script>

<style scoped>

</style>
