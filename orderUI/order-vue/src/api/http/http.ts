// @ts-ignore
import axios, {AxiosInstance} from "axios";

export const instance: AxiosInstance = axios.create({
    baseURL: 'http://localhost:5173/api',
    timeout: 2000
})

//请求拦截器
instance.interceptors.request.use(function (config: any) {
    if (config.url != '/login') {
        config.headers.Authorization = sessionStorage.getItem("token")
        return config
    } else {
        return config
    }
}, function (error: any) {
    return Promise.reject(error);
});


// 添加响应拦截器
instance.interceptors.response.use(function (response: any) {
    console.log(response)
    return response;
}, function (error: any) {
    return Promise.reject(error);
});
