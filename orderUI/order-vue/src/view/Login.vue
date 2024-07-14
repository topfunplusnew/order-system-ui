<template>
    <div style="background-color:#1e9dee;height: 45.25vmax">
        <div style="padding-top: 70px">
            <h1 style="text-align: center;margin-bottom: 50px;font-size: 40px;font-weight: bold;color: white;letter-spacing: 10px">
                订单管理系统</h1>
            <div class="login-form">
                <h2 style="border-bottom: 1px solid #d1e9fa;color: #1e9dee;font-weight: bold">
                    <lay-icon type="layui-icon-username"></lay-icon>
                    用户登录
                </h2>
                <br>
                <lay-json-schema-form ref="formRef" :model="userInfo" :schema="schema" required></lay-json-schema-form>
                <div style="text-align: center">
                    <lay-button @click="submit" type="primary">登录</lay-button>
                    <lay-button @click="reset">重置</lay-button>
                    <!--                <lay-button @click="clear">清除校验</lay-button>-->
                </div>
                <p style="text-align: center;padding-top: 30px;color: red">
                    温馨提示：推荐使用IE9以上浏览器以及360极速模式。</p>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import {onMounted, reactive, ref} from "vue";
import {UserLoginInfo} from "../interfaces/user.ts";
import {Login} from "../api/user/user.ts";
import {layer} from "@layui/layui-vue";
import {Router, useRouter} from "vue-router";


onMounted(() => {
    console.log('login')
})
const router: Router = useRouter()
//模拟数据
const userInfo = ref<UserLoginInfo>({
    username: '',
    password: ''
})
//登录
const handleLogin = (userInfo) => {
    console.log("user-login")
    Login(userInfo).then(res => {
        console.log(res)
        if (res.data.code == 200) {
            layer.msg("登录成功~", {time: 2000, icon: 1})
            //模拟保存用户信息或者jwt
            sessionStorage.setItem("token", res.data.token)
            sessionStorage.setItem("username", userInfo.username)
            router.push('/admin')
        } else {
            layer.msg("登录失败:" + res.data.msg, {time: 2000, icon: 2})
        }
    }).catch(err => {
        console.log('err->', err)
        layer.msg("登录失败!" + err.message, {time: 2000, icon: 2})
    })
}


//登录
const formRef = ref()
const schema = reactive({
    username: {
        label: '用户名',
        type: 'input',
        props: {
            type: 'text',
            placeholder: '请输入用户名',
        }
    },
    password: {
        label: '密码',
        type: 'input',
        props: {
            type: 'password',
            autocomplete: "off",
            placeholder: '请输入密码',
        }
    },
})

const submit = () => {
    formRef.value.validate().then(() => {
        handleLogin(userInfo.value)
    }).catch(err => {
        console.log(err)
    })
}

const reset = () => {
    formRef.value.resetFields()
}

// const clear = () => {
//     formRef.value.clearValidate()
// }

</script>

<style scoped>
.login-form {
    padding: 30px;
    width: 400px;
    height: 300px;
    margin: 0 auto;
    background-color: white;
    border-radius: 7px;
}
</style>
