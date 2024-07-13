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
