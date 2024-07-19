<template>
    <lay-row space="30">
        <lay-col md="12" sm="12" xs="24">
            <h2>今日发货列表</h2>
            <lay-table :default-toolbar="true" :columns="columns5" :data-source="dataSource5"></lay-table>
        </lay-col>
        <lay-col md="12" sm="12" xs="24">
            <h2>利润</h2>
            <lay-table :default-toolbar="true" :columns="columns5" :data-source="dataSource5"></lay-table>
        </lay-col>
    </lay-row>
</template>

<script setup lang="ts">
const columns5 = [
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
        title: "地址",
        children: [
            {title: "省", key: "prov", width: "100px"},
            {title: "市", key: "city", width: "100px"},
            {title: "区", key: "area", width: "100px"},
        ]
    },
    {
        title: "签名",
        width: "240px",
        key: "remark"
    },
]

const dataSource5 = [
    {
        id: "10001",
        name: "夏娜1",
        prov: "浙江",
        sex: "女",
        city: "杭州",
        area: "西湖区",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10002",
        name: "夏娜2",
        prov: "浙江",
        sex: "女",
        city: "杭州",
        area: "西湖区",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10003",
        name: "夏娜3",
        prov: "浙江",
        sex: "女",
        city: "杭州",
        area: "西湖区",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10004",
        name: "夏娜4",
        prov: "浙江",
        sex: "女",
        city: "杭州",
        area: "西湖区",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10005",
        name: "夏娜5",
        prov: "浙江",
        sex: "女",
        city: "杭州",
        area: "西湖区",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10006",
        name: "夏娜6",
        prov: "浙江",
        sex: "女",
        city: "杭州",
        area: "西湖区",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10007",
        name: "夏娜7",
        prov: "浙江",
        sex: "女",
        city: "杭州",
        area: "西湖区",
        remark: '不知江月待何人，但见长江送流水。'
    },
    {
        id: "10008",
        name: "夏娜8",
        prov: "浙江",
        sex: "女",
        city: "杭州",
        area: "西湖区",
        remark: '不知江月待何人，但见长江送流水。'
    }
]
</script>

<style scoped>

</style>
