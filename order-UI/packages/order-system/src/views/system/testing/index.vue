<template>
	<div></div>
</template>
<script>
import SockJS from 'sockjs-client';
import Stomp from 'webstomp-client';

export default {
	data() {
		const ip = `http://223.254.129.240:60036/ws`;
		// 连接到后端 WebSocket
		const socket = new SockJS(ip);
		const stompClient = Stomp.over(socket);

		return {
			socket,
			stompClient
		};
	},
	mounted() {
		this.stompClient.connect({}, () => {
			// 订阅消息
			this.stompClient.subscribe('/topic/exportevent', message => {
				console.log('收到消息:', message.body);
			});

			this.stompClient.subscribe('/topic/messages', message => {
				console.log('收到消息:', message.body);
			});
		});
	},
	methods: {}
};
</script>
<style lang="scss" scoped></style>
