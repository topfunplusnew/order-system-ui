import {defineStore} from "pinia";
// @ts-ignore
import {listUser} from "../api/api/system/user.ts";
import {ref} from "vue";

//用户
export const useUserStore = defineStore('user-info', () => {
    const userInfo = ref([])
    //获取用户信息
    const getUserInfo = (query: any) => {
        listUser(query).then(res => {
            userInfo.value = res.data.rows
        })
    }
    return {
        userInfo,
        getUserInfo
    }
})

