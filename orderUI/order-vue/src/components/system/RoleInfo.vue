<template>
    <div>
        <lay-table
                :page="page"
                :resize="true"
                :height="'100%'"
                :columns="columns"
                :loading="loading"
                :default-toolbar="true"
                :data-source="dataSource"
                v-model:selected-keys="selectedKeys"
                @change="change"
                @sortChange="sortChange">
            <template #status="{ row }">
                <lay-switch :model-value="row.status" @change="changeStatus($event , row)"></lay-switch>
            </template>
            <template v-slot:toolbar>
                <lay-button size="sm" type="primary" @click="handleAdd">新增</lay-button>
                <lay-button size="sm" @click="remove">删除</lay-button>
            </template>
            <template v-slot:operator="{ row }">
                <lay-button size="xs" type="primary" @click="handleEdit(row)">编辑</lay-button>
                <lay-button size="xs">查看</lay-button>
            </template>
        </lay-table>

        <!--        弹窗-->
        <lay-layer v-model="visiblePop" :shade="false" :area="['500px', '450px']" :btn="actionPop">
            <div style="padding: 20px;">
                <lay-form :model="modelPop" ref="layFormRef11" required>
                    <lay-form-item label="用户名" prop="name">
                        <lay-input v-model="modelPop.name"></lay-input>
                    </lay-form-item>
                    <lay-form-item label="性别" prop="sex">
                        <lay-input v-model="modelPop.sex">></lay-input>
                    </lay-form-item>
                </lay-form>
            </div>
        </lay-layer>

        <!--        新增弹窗-->
        <lay-layer v-model="visibleAdd" :shade="false" :area="['500px', '450px']" :btn="actionAdd" title="新增">
            <div style="padding: 20px;">
                <lay-form :model="modelAdd" ref="layFormRefAdd" required>
                    <lay-form-item label="用户名" prop="name">
                        <lay-input v-model="modelAdd.name"></lay-input>
                    </lay-form-item>
                    <lay-form-item label="邮箱" prop="sex">
                        <lay-input v-model="modelAdd.sex">></lay-input>
                    </lay-form-item>
                </lay-form>
            </div>
        </lay-layer>
    </div>
</template>

<script setup lang="ts">
import {ref, reactive} from 'vue';
import {layer} from '@layui/layui-vue';
import {listRole} from "../../api/api/system/role.ts";
import {useAddForm, usePopForm} from "../../hooks/form.ts";
import {AxiosPromise} from "axios";

const loading = ref(true);
const selectedKeys = ref([]);
const page = reactive({current: 1, limit: 10, total: 100});
const columns = ref([
    {title: "选项", width: "55px", type: "checkbox", fixed: "left"},
    {title: "ID", width: "80px", key: "roleId", fixed: "left", sort: "desc"},
    {title: "角色名称", width: "80px", key: "roleName", sort: "desc"},
    {title: "创建时间", width: "180px", key: "createTime"},
    {title: "角色权限字符串", width: "120px", key: "roleKey"},
    {title: "角色状态", width: "80px", key: "status"},
    {title: "权限列表", width: "80px", key: "permissions"},
    {title: "创建者", width: "80px", key: "createBy"},
    {title: "是否是超级管理员", width: "80px", key: "admin"},
    {title: "操作", width: "150px", customSlot: "operator", key: "operator", fixed: "right", ignoreExport: true}
]);

const change = (page) => {
    loading.value = true;
    setTimeout(() => {
        dataSource.value = loadDataSource(page.current, page.limit);
        loading.value = false;
    }, 1000);
}

const sortChange = (key, sort) => {
    layer.msg(`字段${key} - 排序${sort}, 你可以利用 sort-change 实现服务端排序`)
}

const dataSource = ref([])

const changeStatus = (isChecked, row) => {
    dataSource.value.forEach((item) => {
        if (item.id === row.id) {
            layer.msg("Success", {icon: 1}, () => {
                item.status = isChecked;
            })
        }
    })
}

const remove = () => {
    layer.msg(selectedKeys.value, {area: '50%'})
}

const loadDataSource = (page, pageSize) => {
    var response = [];
    var startIndex = ((page - 1) * pageSize) + 1;
    var endIndex = page * pageSize;
    for (var i = startIndex; i <= endIndex; i++) {
        response.push({
            id: `${i}`,
            age: "18",
            sex: "男",
            name: `张三${i}`,
            email: "test@qq.com",
            remark: '花开堪折直须折,莫待无花空折枝.',
            joinTime: "2022-02-09",
            city: "浙江杭州",
            status: true
        })
    }
    return response;
}


//弹窗
const handleChange = (): AxiosPromise => {
    return new Promise(() => {
        alert(1)
    })
}
const {visiblePop, actionPop, modelPop} = usePopForm(handleChange)
const {visibleAdd, actionAdd, modelAdd} = useAddForm(handleChange)

const handleAdd = () => {
    visibleAdd.value = !visibleAdd.value;
}
const handleEdit = (row) => {
    modelAdd.value = row;
    visiblePop.value = !visiblePop.value
}
listRole(null).then(res => {
    loading.value = false
    dataSource.value = res.data.rows
})
</script>
