<!--文件弹窗组件-->

<script>
import { getToken } from '../utils/auth';

export default {
	name: 'FileShowItem',
	props: {
		// 样式变体：normal(默认/附件列表中显示)，empty(空状态居中展示用)
		variant: { type: String, default: 'normal' }
	},
	data() {
		return {
			fileList: [],
			headers: {
				Authorization: 'Bearer ' + getToken()
			},
			progress: null,
			text: '点击上传',
			uploading: false
		};
	},
	watch: {
		progress: {
			handler(val) {
				console.log(val);
			}
		}
	},
	methods: {
		async handleUpload({ file, onProgress }) {
			if (this.uploading) return;

			this.uploading = true;
			this.progress = 0;
			this.text = '选择中...';

			try {
				// 模拟进度更新
				const progressInterval = setInterval(() => {
					if (this.progress < 90) {
						this.progress += 10;
						onProgress({ percent: this.progress });
					}
				}, 50);

				// 模拟选择过程
				setTimeout(() => {
					// 清除进度模拟
					clearInterval(progressInterval);

					// 完成进度
					this.progress = 100;
					onProgress({ percent: 100 });

					// 延迟一下显示完成状态
					setTimeout(() => {
						this.text = '继续上传';
						this.progress = null;
						this.uploading = false;
						this.$refs.upload.clearFiles();

						// 只传递文件对象给父组件，由父组件负责实际上传
						this.$emit('handleFile', file);
					}, 300);
				}, 500);
			} catch (error) {
				console.error('文件选择失败:', error);
				this.$message.error('文件选择失败: ' + (error.message || '未知错误'));

				// 重置状态
				this.text = '点击上传';
				this.progress = null;
				this.uploading = false;
				this.$refs.upload.clearFiles();
			}
		},
		// 处理上传进度
		handleProgress(event) {
			this.progress = event.percent; // 更新进度
		}
	}
};
</script>

<template>
	<div>
		<div :class="['file-container', variant === 'empty' ? 'file-container-empty' : '']">
			<div class="file-icon">
				<el-icon class="el-icon-plus"></el-icon>
			</div>
			<div class="file-name">
				<el-upload
					ref="upload"
					class="upload-demo"
					action="#"
					:show-file-list="false"
					multiple
					:http-request="handleUpload"
					:limit="1"
					:file-list="fileList"
					:on-progress="handleProgress"
					:disabled="uploading"
				>
					<el-button size="small" type="text">{{ text }}</el-button>
				</el-upload>
			</div>

			<!-- 自定义的上传进度显示 -->
			<div v-if="progress !== null" class="upload-progress-container">
				<div class="progress-bar" :style="{ width: progress + '%' }"></div>
				<span class="progress-text">{{ progress }}%</span>
			</div>
		</div>
	</div>
</template>

<style scoped lang="scss">
.file-container {
	margin: 0 10px;
	width: 98px;
	height: 98px;
	background: white;
	border-radius: 15px;
	display: flex;
	justify-content: center;
	align-items: center;
	flex-direction: column;
	box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
	text-align: center;
	transition: background 0.3s, box-shadow 0.3s, transform 0.2s;
	position: relative;

	&:hover {
		cursor: pointer;
		box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.3);
	}

	.file-icon {
		font-size: 28px;
		color: black;
		transition: background 0.3s;
	}

	.file-name {
		font-weight: 600;
		font-size: 13px;
		color: #333;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		max-width: 80px;
	}
}

/* 空状态样式变体 */
.file-container-empty {
	width: 180px;
	height: 140px;
	border-radius: 12px;
	background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
	border: 2px dashed #c2cedb;
	box-shadow: none;
	margin: 0; /* 去掉左右空隙，保证居中美观 */
	.file-icon {
		font-size: 36px;
		color: #409eff;
		margin-bottom: 6px;
	}
	.file-name {
		font-weight: 500;
		font-size: 14px;
		color: #409eff;
	}
	&:hover {
		box-shadow: 0 6px 18px -2px rgba(64, 158, 255, 0.25), 0 0 0 2px rgba(64, 158, 255, 0.15);
		transform: translateY(-2px);
	}
}

// 上传进度样式
.upload-progress-container {
	position: absolute;
	bottom: 8px;
	left: 8px;
	right: 8px;
	background: rgba(255, 255, 255, 0.9);
	border-radius: 8px;
	padding: 4px;
	display: flex;
	align-items: center;
	gap: 6px;

	.progress-bar {
		flex: 1;
		height: 4px;
		background: #409eff;
		border-radius: 2px;
		transition: width 0.3s ease;
	}

	.progress-text {
		font-size: 10px;
		color: #409eff;
		font-weight: bold;
		min-width: 25px;
	}
}
</style>
