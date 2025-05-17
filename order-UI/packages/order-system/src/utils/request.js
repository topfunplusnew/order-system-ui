import axios from 'axios';
import { Notification, MessageBox, Message, Loading } from 'element-ui';
import store from '@/store';
import { getToken } from '@/utils/auth';
import errorCode from '@/utils/errorCode';
import { tansParams, blobValidate } from '@/utils/ruoyi';
import cache from '@/plugins/cache';
import { saveAs } from 'file-saver';
import { getDownLoadStatus } from '@/api/system/onceDownload';

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
		if (status) {
			downLoadFile(url, params, filename, config);
			return;
		} else if (status === false) {
			Message.success('文件正在正常下载中，请勿重复下载!');
			return;
		} else {
			Message.error('下载文件出现错误，请联系管理员！');
			return;
		}
	});
}

async function downLoadFile(url, params, filename, config) {
	// 重置进度条为0，确保立即显示进度条
	await store.dispatch('downloadOnce/setPercent', 1); // 从1%开始，让用户立即看到进度

	// 保存最后接收到的实际进度
	let actualProgress = 0;
	let actualMaxProgress = 100;
	let lastProgressUpdate = Date.now();

	// 模拟进度的增长速度控制
	let simulatedProgress = 1;
	let progressGrowthPaused = false;

	// 获取WebSocket客户端
	let stompClient = window.stompClient;
	let subscriptionId = null;

	// 平滑增长进度的定时器
	const progressInterval = setInterval(() => {
		const now = Date.now();
		// 如果超过3秒没有收到新的进度更新，且进度还没到80%，则继续增长模拟进度
		if (!progressGrowthPaused && now - lastProgressUpdate > 3000 && simulatedProgress < 80) {
			// 根据当前进度动态调整增长速度，越接近80%增长越慢
			const increment = 0.3 * (1 - simulatedProgress / 80);
			simulatedProgress += increment;
			// 确保不超过80%（留给实际完成进度）
			simulatedProgress = Math.min(80, simulatedProgress);
			store.dispatch('downloadOnce/setPercent', Math.round(simulatedProgress));
		}
	}, 500);

	if (stompClient && stompClient.connected) {
		// 订阅下载进度通知
		subscriptionId = stompClient.subscribe('/topic/exportevent', message => {
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

						// 根据实际进度判断是否暂停模拟进度增长
						if (actualProgress / actualMaxProgress > 0.8) {
							progressGrowthPaused = true;
						}

						// 计算百分比进度
						let percent = Math.round((actualProgress / actualMaxProgress) * 100);

						// 确保进度至少为1%，且不超过99%（留1%给完成时设置为100%）
						percent = Math.max(1, Math.min(99, percent));

						// 更新模拟进度为实际进度
						simulatedProgress = percent;

						// 更新store中的进度
						store.dispatch('downloadOnce/setPercent', percent);

						// 显示当前操作的消息提示（限制频率，避免消息过多）
						if (messageData.data.message && percent % 10 === 0) {
							Message({ message: messageData.data.message, type: 'info', duration: 2000 });
						}
					}
				}
			} catch (error) {
				console.error('处理WebSocket消息出错:', error);
			}
		});
	} else {
		Message.warning('WebSocket连接未建立，将使用模拟进度');
	}

	let elNotificationComponent;
	let timeout = setTimeout(() => {
		elNotificationComponent = Notification({
			title: '下载卡顿提醒',
			dangerouslyUseHTMLString: true,
			message: '<button>下载卡住了?点此重新下载</button>',
			duration: 500000,
			type: 'warning',
			onClick: () => {
				// 取消订阅并重新下载
				if (subscriptionId) {
					subscriptionId.unsubscribe();
				}
				downLoadFile(url, params, filename, config);
			}
		});
	}, 3000);

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
			// 停止进度增长定时器
			clearInterval(progressInterval);

			// 清理资源
			if (subscriptionId) {
				subscriptionId.unsubscribe();
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

			// 添加3秒后重置进度条为0
			setTimeout(() => {
				store.dispatch('downloadOnce/setPercent', 0);
			}, 3000);
		})
		.catch(r => {
			// 停止进度增长定时器
			clearInterval(progressInterval);

			// 清理资源
			if (subscriptionId) {
				subscriptionId.unsubscribe();
			}
			console.error(r);
			Message.error('下载文件出现错误，请联系管理员！');

			// 错误时也设置进度为100然后延迟重置
			store.dispatch('downloadOnce/setPercent', 100);

			// 添加3秒后重置进度条为0（即使出错也重置）
			setTimeout(() => {
				store.dispatch('downloadOnce/setPercent', 0);
			}, 3000);
		});
}

export default service;
