<template>
    <lay-button type="primary" @click="changeVisible11">填报信息</lay-button>
    <lay-layer v-model="visible11" :shade="false" :area="['500px', '450px']" :btn="action11">
        <div style="padding: 20px;">
            <lay-form :model="model11" ref="layFormRef11" required>
                <lay-form-item label="账户" prop="username">
                    <lay-input v-model="model11.username"></lay-input>
                </lay-form-item>
                <lay-form-item label="密码" prop="password">
                    <lay-input v-model="model11.password" type="password">></lay-input>
                </lay-form-item>
                <lay-form-item label="爱好" prop="hobby">
                    <lay-select v-model="model11.hobby" multiple style="width:100%;">
                        <lay-select-option value="1" label="学习"></lay-select-option>
                        <lay-select-option value="2" label="编码"></lay-select-option>
                        <lay-select-option value="3" label="运动"></lay-select-option>
                    </lay-select>
                </lay-form-item>
                <lay-form-item label="特长" prop="specialty">
                    <lay-radio v-model="model11.specialty" name="specialty" value="1">写作</lay-radio>
                    <lay-radio v-model="model11.specialty" name="specialty" value="2">画画</lay-radio>
                    <lay-radio v-model="model11.specialty" name="specialty" value="3">编码</lay-radio>
                </lay-form-item>
                <lay-form-item label="描述" prop="desc">
                    <lay-textarea placeholder="请输入描述" v-model="model11.desc"></lay-textarea>
                </lay-form-item>
            </lay-form>
        </div>
    </lay-layer>
</template>

<script setup>
import {ref, reactive} from 'vue'
import {layer} from '@layui/layui-vue'

const model11 = reactive({
    username: "admin"
})

const layFormRef11 = ref();

const visible11 = ref(false);

const changeVisible11 = () => {
    visible11.value = !visible11.value;
}

const action11 = ref([
    {
        text: "确认",
        callback: () => {
            layer.confirm("确认操作", {shade: false});
        }
    },
    {
        text: "取消",
        callback: () => {
            layer.confirm("取消操作", {shade: false});
        }
    }
])
</script>
