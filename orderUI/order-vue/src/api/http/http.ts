import axios, {AxiosInstance} from "axios";

export const instance: AxiosInstance = axios.create({
    baseURL: 'http://localhost:5173/api',
    timeout: 2000
})

