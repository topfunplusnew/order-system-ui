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
                <span style="margin-left: 10px">姓名:</span>
                <lay-input placeholder="提示信息" style="width:100px; margin-left: 20px"></lay-input>
                <lay-button size="sm" @click="remove" style="margin-left: 5px">查询</lay-button>
            </template>
            <template v-slot:operator="{ row }">
                <lay-button size="xs" type="primary" @click="changeVisible11(row)">编辑</lay-button>
            </template>
        </lay-table>

        <!--        弹窗-->
        <lay-layer v-model="visible11" :shade="false" :area="['500px', '450px']" :btn="action11">
            <div style="padding: 20px;">
                <lay-form :model="model11" ref="layFormRef11" required>
                    <lay-form-item label="用户名" prop="name">
                        <lay-input v-model="model11.name"></lay-input>
                    </lay-form-item>
                    <lay-form-item label="性别" prop="sex">
                        <lay-input v-model="model11.sex">></lay-input>
                    </lay-form-item>
                </lay-form>
            </div>
        </lay-layer>

        <!--        新增弹窗-->
        <lay-layer v-model="visibleAdd" :shade="false" :area="['500px', '450px']" :btn="actionAdd" title="新增">
            <div style="padding: 20px;">
                <lay-form :model="modelAdd" ref="layFormRefAdd" required>
                    <lay-form-item label="栏目权限" prop="name">
                        <lay-select v-model="model11.sex" placeholder="请选择">
                            <lay-select-option v-for="(item,index) in roleList" :value="index" :label="item.roleName"
                                               :key="index"></lay-select-option>
                        </lay-select>
                    </lay-form-item>
                    <lay-form-item label="用户名" prop="sex">
                        <lay-input v-model="model11.sex">></lay-input>
                    </lay-form-item>
                    <lay-form-item label="密码" prop="sex">
                        <lay-input v-model="model11.sex">></lay-input>
                    </lay-form-item>
                    <lay-form-item label="电话号码" prop="sex">
                        <lay-input v-model="model11.sex">></lay-input>
                    </lay-form-item>
                </lay-form>
            </div>
        </lay-layer>
        <!--        加载-->

    </div>
</template>

<script setup lang="ts">
import {ref, reactive,} from 'vue';
import {layer} from '@layui/layui-vue';
import {listUser} from "../../api/api/system/user.ts";
import {listRole} from "../../api/api/system/role.ts";
import {isNumber} from "@layui/layui-vue/types/utils";


//data
const loading = ref(true);
const selectedKeys = ref([]);
const page = reactive({current: 1, limit: 10, total: 100});
const columns = ref([
    {title: "选项", width: "55px", type: "checkbox", fixed: "left"},
    {title: "ID", width: "80px", key: "userId", fixed: "left", sort: "desc"},
    {title: "用户名", width: "80px", key: "userName", sort: "desc"},
    {title: "状态", width: "180px", key: "status", customSlot: "status"},
    {title: "邮箱", width: "120px", key: "email"},
    {title: "性别", width: "80px", key: "sex"},
    {title: "创建时间", width: "80px", key: "createTime"}, //, totalRow: true
    {title: "创建人", width: "120px", key: "createBy"},
    {title: "手机号", width: "260px", key: "phonenumber"},
    {title: "操作", width: "150px", customSlot: "operator", key: "operator", fixed: "right", ignoreExport: true}
]);
const sortChange = (key, sort) => {
    layer.msg(`字段${key} - 排序${sort}, 你可以利用 sort-change 实现服务端排序`)
}
const dataSource = ref([])
const remove = () => {
    layer.msg(selectedKeys.value + '', {area: '50%'})
}
//弹窗
const model11 = ref({})
const layFormRef11 = ref();
const visible11 = ref(false);

//操作
const action11 = ref([
    {
        text: "确认",
        //这里发送请求 更改数据库信息
        callback: () => {
            layer.confirm("确定要这样操作吗", {
                btn: [
                    {
                        text: '确认', callback: (id) => {
                            layer.msg("确定");
                            layer.close(id);
                        }
                    },
                    {
                        text: '取消', callback: (id) => {
                            layer.msg("取消");
                            layer.close(id);
                        }
                    }
                ]
            });
        }
    },
    {
        text: "取消",
        callback: () => {
            layer.confirm("操作取消", {
                btn: [
                    {
                        text: '确认', callback: (id) => {
                            layer.msg("确定");
                            layer.close(id);
                        }
                    },
                    {
                        text: '取消', callback: (id) => {
                            layer.msg("取消");
                            layer.close(id);
                        }
                    }
                ]
            });
        }
    }
])
//新增
const layFormRefAdd = ref(null)
const visibleAdd = ref(false)
const modelAdd = ref({
    userName: String,
    password: String,
    phonenumber: Number
})
const actionAdd = ref([
    {
        text: "确认",
        //这里发送请求 更改数据库信息
        callback: () => {
            layer.confirm("确定要这样操作吗", {
                btn: [
                    {
                        text: '确认', callback: (id) => {
                            layer.msg("确定");
                            layer.close(id);
                        }
                    },
                    {
                        text: '取消', callback: (id) => {
                            layer.msg("取消");
                            layer.close(id);
                        }
                    }
                ]
            });
        }
    },
    {
        text: "取消",
        callback: () => {
            layer.confirm("操作取消", {
                btn: [
                    {
                        text: '确认', callback: (id) => {
                            layer.msg("确定");
                            layer.close(id);
                        }
                    },
                    {
                        text: '取消', callback: (id) => {
                            layer.msg("取消");
                            layer.close(id);
                        }
                    }
                ]
            });
        }
    }
])
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

//切换页码的回调
const change = (page) => {
    console.log('page=>', page)
    loading.value = true;
    setTimeout(() => {
        dataSource.value = loadDataSource(page.current, page.limit);
        loading.value = false;
    }, 1000);
}

const changeStatus = (isChecked, row) => {
    dataSource.value.forEach((item) => {
        if (item.id === row.id) {
            layer.msg("Success", {icon: 1}, () => {
                item.status = isChecked;
            })
        }
    })
}
//弹出
const changeVisible11 = (row) => {
    model11.value = row;
    visible11.value = !visible11.value;
}
const handleAdd = () => {
    visibleAdd.value = !visibleAdd.value
}


//用户信息
const query = null
//获取权限信息
const roleList = ref([])
listRole(query).then(res => {
    roleList.value = res.data.rows
})
//获取用户信息
listUser(query).then(res => {
    loading.value = false
    dataSource.value = res.data.rows
})

</script>
