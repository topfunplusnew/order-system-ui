import SockJS from 'sockjs-client';
import Stomp from 'webstomp-client';

class WebSocketManager {
	constructor() {
		this.socket = null;
		this.stompClient = null;
		this.isConnected = false;
		this.reconnectTimer = null;
		this.subscriptions = new Map(); // 用于管理订阅
		this.connectPromise = null; // 避免重复连接
		this.maxReconnectAttempts = 5;
		this.reconnectAttempts = 0;
		this.reconnectInterval = 5000; // 5秒重连间隔
	}

	// 获取WebSocket连接URL
	getWebSocketUrl() {
		return process.env.VUE_APP_BASE_API + '/ws';
	}

	// 连接WebSocket
	async connect() {
		// 如果已经连接或正在连接，返回现有的Promise
		if (this.isConnected) {
			console.log('WebSocket已连接');
			return Promise.resolve();
		}

		if (this.connectPromise) {
			console.log('WebSocket正在连接中...');
			return this.connectPromise;
		}

		this.connectPromise = new Promise((resolve, reject) => {
			try {
				// 清理之前的连接
				this.disconnect();

				const url = this.getWebSocketUrl();
				console.log('正在为下载任务连接WebSocket:', url);

				this.socket = new SockJS(url);
				this.stompClient = Stomp.over(this.socket);

				// 设置心跳
				this.stompClient.heartbeat.outgoing = 20000;
				this.stompClient.heartbeat.incoming = 20000;

				// 禁用日志输出以减少内存占用
				this.stompClient.debug = () => {};

				this.stompClient.connect(
					{},
					() => {
						console.log('WebSocket连接成功，准备接收下载进度');
						this.isConnected = true;
						this.reconnectAttempts = 0;

						// 将连接实例暴露给全局
						window.stompClient = this.stompClient;

						// 清除重连定时器和连接Promise
						this.clearReconnectTimer();
						this.connectPromise = null;

						resolve();
					},
					error => {
						console.error('WebSocket连接失败:', error);
						this.isConnected = false;
						this.connectPromise = null;

						// 连接失败时不自动重连，让用户决定是否重试
						console.log('WebSocket连接失败，用户可以重新尝试下载');

						reject(error);
					}
				);

				// 监听socket关闭事件
				this.socket.onclose = () => {
					console.log('WebSocket连接已关闭');
					this.isConnected = false;
					window.stompClient = null;
					// 下载场景下连接关闭不需要自动重连
				};
			} catch (error) {
				console.error('初始化WebSocket连接失败:', error);
				this.connectPromise = null;
				reject(error);
			}
		});

		return this.connectPromise;
	}

	// 断开连接
	disconnect() {
		try {
			console.log('开始断开WebSocket连接，清理资源...');

			// 清除所有订阅
			this.subscriptions.forEach((subscription, id) => {
				if (subscription && typeof subscription.unsubscribe === 'function') {
					subscription.unsubscribe();
					console.log(`取消订阅: ${id}`);
				}
			});
			this.subscriptions.clear();

			// 断开STOMP连接
			if (this.stompClient && this.stompClient.connected) {
				this.stompClient.disconnect(() => {
					console.log('WebSocket连接已断开');
				});
			}

			// 关闭socket连接
			if (this.socket) {
				this.socket.close();
			}

			// 清理状态
			this.isConnected = false;
			this.socket = null;
			this.stompClient = null;
			window.stompClient = null;
			this.connectPromise = null;

			// 清除重连定时器
			this.clearReconnectTimer();

			console.log('WebSocket连接已完全清理');
		} catch (error) {
			console.error('断开WebSocket连接时出错:', error);
		}
	}

	// 订阅消息
	subscribe(topic, callback, subscriptionId = null) {
		if (!this.isConnected || !this.stompClient) {
			console.warn('WebSocket未连接，无法订阅消息');
			return null;
		}

		try {
			const subscription = this.stompClient.subscribe(topic, callback);

			// 使用提供的ID或生成一个唯一ID
			const id = subscriptionId || `${topic}_${Date.now()}`;
			this.subscriptions.set(id, subscription);

			console.log(`已订阅消息: ${topic}`);
			return { id, subscription };
		} catch (error) {
			console.error('订阅消息失败:', error);
			return null;
		}
	}

	// 取消订阅
	unsubscribe(subscriptionId) {
		if (this.subscriptions.has(subscriptionId)) {
			const subscription = this.subscriptions.get(subscriptionId);
			if (subscription && typeof subscription.unsubscribe === 'function') {
				subscription.unsubscribe();
				this.subscriptions.delete(subscriptionId);
				console.log(`已取消订阅: ${subscriptionId}`);
				return true;
			}
		}
		return false;
	}

	// 安排重连
	scheduleReconnect() {
		// 如果已经有重连定时器，或者超过最大重连次数，则不再重连
		if (this.reconnectTimer || this.reconnectAttempts >= this.maxReconnectAttempts) {
			if (this.reconnectAttempts >= this.maxReconnectAttempts) {
				console.warn('已达到最大重连次数，停止重连');
			}
			return;
		}

		this.reconnectAttempts++;
		const delay = this.reconnectInterval * this.reconnectAttempts; // 递增延迟

		console.log(`将在 ${delay / 1000} 秒后尝试第 ${this.reconnectAttempts} 次重连...`);

		this.reconnectTimer = setTimeout(() => {
			this.reconnectTimer = null;
			console.log(`尝试第 ${this.reconnectAttempts} 次重连...`);
			this.connect().catch(error => {
				console.error('重连失败:', error);
			});
		}, delay);
	}

	// 清除重连定时器
	clearReconnectTimer() {
		if (this.reconnectTimer) {
			clearTimeout(this.reconnectTimer);
			this.reconnectTimer = null;
		}
	}

	// 重置重连计数
	resetReconnectAttempts() {
		this.reconnectAttempts = 0;
	}

	// 获取连接状态
	getConnectionStatus() {
		return {
			isConnected: this.isConnected,
			reconnectAttempts: this.reconnectAttempts,
			subscriptionsCount: this.subscriptions.size
		};
	}
}

// 创建单例实例
const webSocketManager = new WebSocketManager();

export default webSocketManager;
