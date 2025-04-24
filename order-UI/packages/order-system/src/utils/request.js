import axios from 'axios';
import { Notification, MessageBox, Message, Loading } from 'element-ui';
import store from '@/store';
import { getToken } from '@/utils/auth';
import errorCode from '@/utils/errorCode';
import { tansParams, blobValidate } from '@/utils/ruoyi';
import cache from '@/plugins/cache';
import { saveAs } from 'file-saver';
import { getDownLoadProgress, getDownLoadStatus, resetDownLoadProgress } from '@/api/system/onceDownload';

let downloadLoadingInstance;
// 是否显示重新登录
export const isRelogin = { show: false };

axios.defaults.headers['Content-Type'] = 'application/json;charset=utf-8';
// 创建axios实例
const service = axios.create({
	// axios中请求配置有baseURL选项，表示请求URL公共部分
	baseURL: process.env.VUE_APP_BASE_API,
	// 超时
	timeout: 60 * 1000
});

let loadingInstance = null;
// request拦截器
service.interceptors.request.use(
	config => {
		// 开始加载
		loadingInstance = Loading.service({
			fullscreen: true,
			text: '正在加载,请耐心等待😊....'
		});
		// 是否需要设置 token
		const isToken = (config.headers || {}).isToken === false;
		// 是否需要防止数据重复提交
		const isRepeatSubmit = (config.headers || {}).repeatSubmit === false;
		if (getToken() && !isToken) {
			config.headers['Authorization'] = 'Bearer ' + getToken(); // 让每个请求携带自定义token 请根据实际情况自行修改
		}
		// get请求映射params参数
		if (config.method === 'get' && config.params) {
			let url = config.url + '?' + tansParams(config.params);
			url = url.slice(0, -1);
			config.params = {};
			config.url = url;
		}
		if (!isRepeatSubmit && (config.method === 'post' || config.method === 'put')) {
			const requestObj = {
				url: config.url,
				data: typeof config.data === 'object' ? JSON.stringify(config.data) : config.data,
				time: new Date().getTime()
			};
			const requestSize = Object.keys(JSON.stringify(requestObj)).length; // 请求数据大小
			const limitSize = 5 * 1024 * 1024; // 限制存放数据5M
			if (requestSize >= limitSize) {
				console.warn(`[${config.url}]: ` + '请求数据大小超出允许的5M限制，无法进行防重复提交验证。');
				return config;
			}
			const sessionObj = cache.session.getJSON('sessionObj');
			if (sessionObj === undefined || sessionObj === null || sessionObj === '') {
				cache.session.setJSON('sessionObj', requestObj);
			} else {
				const s_url = sessionObj.url; // 请求地址
				const s_data = sessionObj.data; // 请求数据
				const s_time = sessionObj.time; // 请求时间
				const interval = 1000; // 间隔时间(ms)，小于此时间视为重复提交
				if (s_data === requestObj.data && requestObj.time - s_time < interval && s_url === requestObj.url) {
					const message = '数据正在处理，请勿重复提交';
					console.warn(`[${s_url}]: ` + message);
					return Promise.reject(new Error(message));
				} else {
					cache.session.setJSON('sessionObj', requestObj);
				}
			}
		}
		return config;
	},
	error => {
		console.log(error);
		loadingInstance.close();
		Promise.reject(error);
	}
);

// 响应拦截器
service.interceptors.response.use(
	res => {
		// 未设置状态码则默认成功状态
		const code = res.data.code || 200;
		// 获取错误信息
		const msg = errorCode[code] || res.data.msg || errorCode['default'];
		// 二进制数据则直接返回
		if (res.request.responseType === 'blob' || res.request.responseType === 'arraybuffer') {
			loadingInstance.close();
			return res.data;
		}
		if (code === 401) {
			loadingInstance.close();
			if (!isRelogin.show) {
				isRelogin.show = true;
				MessageBox.confirm('登录状态已过期，您可以继续留在该页面，或者重新登录', '系统提示', {
					confirmButtonText: '重新登录',
					cancelButtonText: '取消',
					type: 'warning'
				})
					.then(() => {
						isRelogin.show = false;
						store.dispatch('LogOut').then(() => {
							location.href = '/index';
						});
					})
					.catch(() => {
						isRelogin.show = false;
					});
			}
			return Promise.reject('无效的会话，或者会话已过期，请重新登录。');
		} else if (code === 500) {
			loadingInstance.close();
			Message({ message: msg, type: 'error' });
			return Promise.reject(new Error(msg));
		} else if (code === 601) {
			loadingInstance.close();
			Message({ message: msg, type: 'warning' });
			return Promise.reject('error');
		} else if (code !== 200) {
			loadingInstance.close();
			Notification.error({ title: msg });
			return Promise.reject('error');
		} else {
			loadingInstance.close();
			return res.data;
		}
	},
	error => {
		loadingInstance.close();
		console.log('err' + error);
		let { message } = error;
		if (message == 'Network Error') {
			message = '后端接口连接异常';
		} else if (message.includes('timeout')) {
			message = '系统接口请求超时';
		} else if (message.includes('Request failed with status code')) {
			message = '系统接口' + message.substr(message.length - 3) + '异常';
		}
		Message({ message: message, type: 'error', duration: 5 * 1000 });
		return Promise.reject(error);
	}
);

// 通用下载方法-修改版
export function download(url, params, filename, config, isShowConfig = false) {
	let progress = 0; // 初始化进度
	const maxProgress = 98; // 假进度条的最大值，留出2%等待真实下载完成
	let fakeProgressInterval;

	// 启动下载的 Loading
	downloadLoadingInstance = Loading.service({
		text: `正在下载数据，请稍候 (${progress}%)`,
		spinner: 'el-icon-loading',
		background: 'rgba(0, 0, 0, 0.7)'
	});

	// 假进度条增长函数（基于 log 调整增量）
	function calculateIncrement(progress, maxProgress) {
		const remainingProgress = maxProgress - progress;
		const base = 1 + remainingProgress / maxProgress; // 基于剩余进度动态调整对数函数的基数
		return Math.log(base) * 10; // 增量由对数函数计算得出，乘以一个系数控制增长速度
	}

	// 启动假进度条
	fakeProgressInterval = setInterval(() => {
		if (progress < maxProgress) {
			const increment = calculateIncrement(progress, maxProgress);
			progress += increment;
			progress = Math.min(progress, maxProgress); // 防止超过最大值
			downloadLoadingInstance.setText(`正在下载数据，请稍候 (${Math.round(progress)}%)`);
		} else {
			clearInterval(fakeProgressInterval); // 停止假进度
		}
	}, 500); // 每500ms更新一次进度

	// 发送下载请求
	return service
		.post(url, params, {
			transformRequest: [
				params => {
					return tansParams(params);
				}
			],
			headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
			responseType: 'blob',
			timeout: 600000, // 超时时间，默认600秒
			...config
		})
		.then(async data => {
			clearInterval(fakeProgressInterval); // 停止假进度
			downloadLoadingInstance.setText(`正在下载数据，请稍候 (100%)`); // 下载完成设置为100%

			const isBlob = blobValidate(data);
			if (isBlob) {
				const blob = new Blob([data]);
				saveAs(blob, filename);
			} else {
				const resText = await data.text();
				const rspObj = JSON.parse(resText);
				const errMsg = errorCode[rspObj.code] || rspObj.msg || errorCode['default'];
				Message.error(errMsg);
			}
			downloadLoadingInstance.close();
		})
		.catch(r => {
			clearInterval(fakeProgressInterval); // 停止假进度
			console.error(r);
			Message.error('下载文件出现错误，请联系管理员！');
			downloadLoadingInstance.close();
		});
}

// 一键下载的方法
export function onceDownload(url, params, filename, config) {
	// 先获取是否可以下载
	getDownLoadStatus().then(status => {
		console.log(status);

		if (status) {
			downLoadFile(url, params, filename, config);
		} else if (status === false) {
			Message.success('文件正在正常下载中，请勿重复下载!');
		} else {
			Message.error('下载文件出现错误，请联系管理员！');
		}
	});
}

async function downLoadFile(url, params, filename, config) {
	const { data } = await getDownLoadProgress();
	await store.dispatch('downloadOnce/setPercent', 0);
	let progress = data.NowProgress; // 初始化进度
	const maxProgress = data.MaxProgress; // 假进度条的最大值，留出2%等待真实下载完成
	let fakeProgressInterval;

	// 启动下载的 Loading
	downloadLoadingInstance = Loading.service({
		text: `正在进行一键下载操作，请稍候 (${progress}%)`,
		spinner: 'el-icon-loading',
		background: 'rgba(0, 0, 0, 0.7)'
	});

	function calculateIncrement(progress, maxProgress) {
		const remainingProgress = maxProgress - progress;
		const base = 1 + remainingProgress / maxProgress; // 基于剩余进度动态调整对数函数的基数
		return Math.log(base) * 10; // 增量由对数函数计算得出，乘以一个系数控制增长速度
	}

	// 启动假进度条
	fakeProgressInterval = setInterval(() => {
		if (progress < maxProgress) {
			const increment = calculateIncrement(progress, maxProgress);
			progress += increment;
			progress = Math.min(progress, maxProgress); // 防止超过最大值
			downloadLoadingInstance.setText(`正在下载系统数据，请稍候 (${Math.round(progress)}%)`);
		} else {
			clearInterval(fakeProgressInterval); // 停止假进度
		}
	}, 500); // 每500ms更新一次进度

	let elNotificationComponent;
	let timeout = setTimeout(() => {
		elNotificationComponent = Notification({
			title: '下载卡顿提醒',
			dangerouslyUseHTMLString: true,
			message: '<button>下载卡住了?点此重新下载</button>',
			duration: 500000,
			type: 'warning',
			onClick: () => {
				downLoadFile(url, params, filename, config);
			}
		});
	}, 3000);

	// // 每一秒发送一次请求 拿取下载进度
	let downloadInterval = setInterval(async () => {
		await store.dispatch('downloadOnce/setPercent');
	}, 2000);

	// 发送下载请求
	return service
		.post(url, params, {
			transformRequest: [
				params => {
					return tansParams(params);
				}
			],
			headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
			responseType: 'blob',
			timeout: 600000, // 超时时间，默认600秒
			...config
		})
		.then(async data => {
			clearInterval(fakeProgressInterval); // 停止假进度
			clearInterval(downloadInterval); // 停止下载进度
			clearTimeout(timeout);
			// 关闭右上角提示
			elNotificationComponent.close();
			await store.dispatch('downloadOnce/setPercent', 100);
			downloadLoadingInstance.setText(`下载完毕  (100%)`); // 下载完成设置为100%
			Message.success('下载完毕');

			const isBlob = blobValidate(data);
			if (isBlob) {
				const blob = new Blob([data]);
				saveAs(blob, filename);
			} else {
				const resText = await data.text();
				const rspObj = JSON.parse(resText);
				const errMsg = errorCode[rspObj.code] || rspObj.msg || errorCode['default'];
				Message.error(errMsg);
			}
			downloadLoadingInstance.close();
		})
		.catch(r => {
			clearInterval(fakeProgressInterval); // 停止假进度
			console.error(r);
			Message.error('下载文件出现错误，请联系管理员！');
			downloadLoadingInstance.close();
		});
}

export default service;
