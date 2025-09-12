import axios from 'axios';
import { Notification, MessageBox, Message, Loading } from 'element-ui';
import store from '@/store';
import { getToken } from '@/utils/auth';
import errorCode from '@/utils/errorCode';
import { tansParams, blobValidate } from '@/utils/ruoyi';
import cache from '@/plugins/cache';
import { saveAs } from 'file-saver';
import { getDownLoadStatus, resetDownLoadProgress } from '@/api/system/onceDownload';
import webSocketManager from '@/utils/websocket';

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

// 定义需要排除全屏loading效果的API路径数组
export const excludeLoadingPaths = [
	'system/allExport/export', // 一键下载路径
	'statistics/export', // 统计导出路径
	'/download/', // 所有下载相关路径
	'/export/' // 所有导出相关路径
];

let loadingInstance = null;
// request拦截器
service.interceptors.request.use(
	config => {
		// 检查当前请求URL是否在排除loading的路径列表中
		const isExcluded = excludeLoadingPaths.some(path => config.url.includes(path));

		// 只有当路径不在排除列表中时，才显示loading
		if (!isExcluded) {
			// 开始加载
			loadingInstance = Loading.service({
				fullscreen: true,
				text: '正在加载,请耐心等待😊....'
			});
		}

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
				params: config.params,
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
				const s_params = sessionObj.params; // 请求参数
				const s_time = sessionObj.time; // 请求时间
				const interval = 1000; // 间隔时间(ms)，小于此时间视为重复提交
				if (s_data === requestObj.data && s_params === requestObj.params && requestObj.time - s_time < interval && s_url === requestObj.url) {
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
		if (loadingInstance) {
			loadingInstance.close();
		}
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
			if (loadingInstance) {
				loadingInstance.close();
			}
			return res.data;
		}

		// 在所有可能的返回路径中都要检查loadingInstance是否存在
		if (code === 401) {
			if (loadingInstance) {
				loadingInstance.close();
			}
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
			if (loadingInstance) {
				loadingInstance.close();
			}
			Message({ message: msg, type: 'error' });
			return Promise.reject(new Error(msg));
		} else if (code === 601) {
			if (loadingInstance) {
				loadingInstance.close();
			}
			Message({ message: msg, type: 'warning' });
			return Promise.reject('error');
		} else if (code !== 200) {
			if (loadingInstance) {
				loadingInstance.close();
			}
			Notification.error({ title: msg });
			return Promise.reject('error');
		} else {
			if (loadingInstance) {
				loadingInstance.close();
			}
			return res.data;
		}
	},
	error => {
		if (loadingInstance) {
			loadingInstance.close();
		}
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
					return params ? tansParams(params) : null;
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

// 一键下载的方法 点击下载后先校验一下是否可以下载，并建立WebSocket连接
export function onceDownload(url, params, filename, config) {
	// 先获取是否可以下载
	getDownLoadStatus()
		.then(status => {
			if (status) {
				// 只有当允许下载时，才建立WebSocket连接并下载
				console.log('开始建立WebSocket连接用于一键下载...');
				webSocketManager
					.connect()
					.then(() => {
						console.log('WebSocket连接成功，开始下载');
						downLoadFile(url, params, filename, config);
					})
					.catch(error => {
						console.error('WebSocket连接失败:', error);
						Message.error('WebSocket连接失败，但将继续下载（无进度显示）');
						// 即使WebSocket连接失败也继续下载，只是没有进度显示
						downLoadFile(url, params, filename, config);
					});
			} else if (status === false) {
				Message.error('当前正在有用户进行文件下载中!');
			} else {
				Message.error('下载文件出现错误，请联系管理员！');
			}
		})
		.catch(error => {
			console.error('检查下载状态失败:', error);
			Message.error('检查下载状态失败，请联系管理员！');
		});
}

// TODO
async function downLoadFile(url, params, filename, config) {
	// 重置进度条为0，确保立即显示进度条
	await store.dispatch('downloadOnce/setPercent', 1); // 从1%开始，让用户立即看到进度

	// 保存最后接收到的实际进度
	let actualProgress = 0;
	let actualMaxProgress = 100;
	let lastProgressUpdate = Date.now();

	let subscriptionInfo = null;

	// 检查WebSocket连接并订阅进度消息
	const connectionStatus = webSocketManager.getConnectionStatus();
	if (connectionStatus.isConnected) {
		console.log('WebSocket已连接，开始订阅下载进度消息');
		// 使用WebSocket管理器订阅消息
		subscriptionInfo = webSocketManager.subscribe(
			'/topic/exportevent',
			message => {
				try {
					const messageData = JSON.parse(message.body);
					// 匹配消息类型，增加容错性
					const messageType = messageData.type ? messageData.type.toLowerCase() : '';
					if (messageType.includes('process') || messageType.includes('progress')) {
						// 更新进度信息
						if (messageData.data) {
							// 更新最后一次收到进度的时间
							lastProgressUpdate = Date.now();
							// 获取实际进度
							actualProgress = messageData.data.NowProgress || 0;
							actualMaxProgress = messageData.data.MaxProgress || 100;
							const downloadMessage = messageData.data.message || '正在下载...';
							console.log(`下载进度: ${actualProgress}/${actualMaxProgress} - ${downloadMessage}`);
							// 计算百分比进度
							let percent = Math.round((actualProgress / actualMaxProgress) * 100);
							// 确保进度至少为1%，且不超过99%（留1%给完成时设置为100%）
							percent = Math.max(1, Math.min(99, percent));
							// 更新store中的进度 和 消息
							store.dispatch('downloadOnce/setPercent', percent);
							store.dispatch('downloadOnce/setMessage', downloadMessage);
						}
					}
				} catch (error) {
					console.error('处理WebSocket消息出错:', error);
					if (subscriptionInfo) {
						webSocketManager.unsubscribe(subscriptionInfo.id);
						subscriptionInfo = null;
					}
					store.dispatch('downloadOnce/setPercent', 0);
				}
			},
			'download_progress'
		);

		if (!subscriptionInfo) {
			console.warn('订阅下载进度消息失败');
		}
	} else {
		console.warn('WebSocket未连接，将进行无进度显示的下载');
		Message.info('WebSocket未连接，下载过程中无法显示进度');
	}

	let elNotificationComponent;
	let timeout = setTimeout(() => {
		elNotificationComponent = Notification({
			title: '下载卡顿提醒',
			dangerouslyUseHTMLString: true,
			message: '<button>下载卡住了?点此重置服务端</button>',
			duration: 500000,
			type: 'warning',
			onClick: () => {
				// 取消订阅并重新下载
				if (subscriptionInfo) {
					webSocketManager.unsubscribe(subscriptionInfo.id);
					subscriptionInfo = null;
				}
				resetDownLoadProgress();
				Message.success('已重置服务端,请重新点击一键下载!');
				store.dispatch('downloadOnce/setPercent', 0);
			}
		});
	}, 1000 * 60 * 3);

	// 发送下载请求
	return service
		.post(url + `?date=${params.date}&exportEmptyData=${params.exportEmptyData}`, null, {
			// headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
			responseType: 'blob',
			timeout: 600000, // 超时时间，默认600秒
			...config
		})
		.then(async data => {
			// 清理资源
			if (subscriptionInfo) {
				console.log('下载完成，取消WebSocket订阅');
				webSocketManager.unsubscribe(subscriptionInfo.id);
				subscriptionInfo = null;
			}
			clearTimeout(timeout);

			// 关闭右上角提示
			if (elNotificationComponent) {
				elNotificationComponent.close();
			}

			// 更新完成状态
			await store.dispatch('downloadOnce/setPercent', 100);
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

			// 添加3秒后重置进度条为0，并断开WebSocket连接
			setTimeout(() => {
				store.dispatch('downloadOnce/setPercent', 0);
				// 下载完成后断开WebSocket连接以释放资源
				console.log('下载完成，断开WebSocket连接');
				webSocketManager.disconnect();
			}, 3000);
		})
		.catch(r => {
			// 清理资源
			if (subscriptionInfo) {
				console.log('下载出错，取消WebSocket订阅');
				webSocketManager.unsubscribe(subscriptionInfo.id);
				subscriptionInfo = null;
			}
			clearTimeout(timeout);

			// 关闭右上角提示
			if (elNotificationComponent) {
				elNotificationComponent.close();
			}

			console.error(r);
			Message.error('下载文件出现错误，请联系管理员！');

			// 添加3秒后重置进度条为0，并断开WebSocket连接
			setTimeout(() => {
				store.dispatch('downloadOnce/setPercent', 0);
				// 下载出错后也断开WebSocket连接
				console.log('下载出错，断开WebSocket连接');
				webSocketManager.disconnect();
			}, 3000);
		});
}
export default service;
