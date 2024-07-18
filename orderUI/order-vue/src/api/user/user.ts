import {UserLoginInfo} from "../../interfaces/user.ts";
import {instance} from "../http/http.ts";

/**
 * 登录接口
 * @param userInfo
 */
export const Login = (userInfo: UserLoginInfo) => {
    return new Promise((resolve, reject) => {
        instance.request({
            url: '/login',
            method: 'post',
            data: userInfo
        }).then(r => resolve(r))
            .catch(e => reject(e))
    })
}

/**
 * 登出接口
 * @param token
 */
export const logout = (token: string) => {
    return new Promise((resolve, reject) => {
        instance.request({
            url: '/logout',
            method: 'post',
            data: token
        }).then(r => resolve(r))
            .catch(err => reject(err))
    })
}
