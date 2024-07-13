<template>
    <div>
        <lay-button @click="handleLogin">点击登录</lay-button>
        <RouterLink to="/admin">跳转回到首页</RouterLink>
    </div>
</template>

<script setup lang="ts">
import {onMounted} from "vue";
import {UserLoginInfo} from "../interfaces/user.ts";
import {Login} from "../api/user/user.ts";
import {layer} from "@layui/layui-vue";
import {Router, useRouter} from "vue-router";


onMounted(() => {
    console.log('login')
})
const router: Router = useRouter()
//模拟数据
const userInfo: UserLoginInfo = {
    username: 'Adminw',
    password: '123456'
}
//登录
const handleLogin = () => {
    console.log("user-login")
    Login(userInfo).then(res => {
        console.log(res)
        if (res.data.code == 200) {
            layer.msg("登录成功~", {time: 2000, icon: 1})
            localStorage.setItem("user", userInfo.toString())
            router.push('/')
        } else {
            layer.msg("登录失败" + res.message, {time: 2000, icon: 2})
        }
    }).catch(err => {
        layer.msg("登录失败!" + err.message, {time: 2000, icon: 2})
    })
}
</script>

<style scoped>

</style>
