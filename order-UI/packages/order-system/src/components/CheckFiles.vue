<!--查看文件通用的的组件-->
<!-- 如果一个列需要展示文件 那么就可以用这个组件-->
<script>
import { check_file } from '../views/dashboard/mixins/utils/check_file';
import { addAttachments, deleteAttachments } from '@/api/system/attachments';
import FileItems from './FileItems.vue';
import FileShowItem from './FileShowItem.vue';

export default {
	name: 'CheckFiles',
	components: { FileShowItem, FileItems },
	mixins: [check_file],
	props: {
		// 附件数组
		attachmentList: {
			type: Array,
			default: () => []
		},
		// 是否允许上传
		isUpload: {
			type: Boolean,
			default: true
		},
		// 上传文件时的标识flag
		flag: {
			type: String,
			default: ''
		},
		// 额外信息
		extraInfo: {
			type: Object,
			default: () => ({})
		}
	},
	data() {
		return {
			// 检查的文件列表（现在是附件对象数组）
			checkFileList: [],
			dialogVisible: false,
			// 是否正在上传文件的标志位
			isUploading: false
		};
	},
	computed: {
		// 过滤出来图片 给模板使用
		imgList() {
			const imageTypes = ['.jpeg', '.jpg', '.png', '.svg', '.gif', '.bmp', '.webp'];
			return this.checkFileList
				.filter(item => {
					if (!item || !item.filePath) return false;
					const suffix = item.fileSuffix ? `.${item.fileSuffix.toLowerCase()}` : '';
					return imageTypes.includes(suffix);
				})
				.map(item => item.filePath);
		}
	},
	mounted() {
		// 事件总线 接受dialogVisible的变化 设置一个全局监听器 当监听到某个事件发生的时候 那么就要执行相关逻辑
		this.$bus.$on('changeFileVisible', value => {
			// 如果正在上传文件，不关闭弹窗
			if (this.isUploading && !value) {
				return;
			}
			this.dialogVisible = value;
		});
	},
	methods: {
		showImgSrc(item) {
			return process.env.VUE_APP_BASE_API + item;
		},
		// 查看文件列表
		checkFiles(attachmentList) {
			this.checkFileList = [];
			if (attachmentList && attachmentList.length > 0) {
				this.checkFileList = [...attachmentList];
			}
			// 查看文件时不是上传模式
			this.isUploading = false;
			this.dialogVisible = true;
		},
		// 上传附件
		uploadFile(attachmentList) {
			this.checkFileList = [];
			if (attachmentList && attachmentList.length > 0) {
				this.checkFileList = [...attachmentList];
			}
			// 设置上传标志位
			this.isUploading = true;
			this.dialogVisible = true;
		},
		// 添加某个文件
		async handleAddFile(file) {
			if (!file) {
				this.$message.error('上传的文件格式有误!');
				return;
			}

			try {
				// 显示上传中状态
				this.$message.info('文件上传中，请稍候...');
				// 调用API上传文件
				const response = await addAttachments(file, {
					flag: this.flag,
					extraInfo: this.extraInfo
				});
				if (response.code === 200 && response.data) {
					// 上传成功，添加到列表中
					this.checkFileList.push(response.data);
					// 触发更新事件，传递新的附件列表
					this.$emit('needToUpdate', [...this.checkFileList]);
				} else {
					throw new Error(response.msg || '上传失败');
				}
			} catch (error) {
				console.error('文件上传失败:', error);
				this.$message.error('文件上传失败: ' + (error.message || '未知错误'));
			}
		},
		// 删除某个文件
		handleDeleteFile(attachment) {
			// 弹出确认框 先确认是否要删除
			this.$antconfirm({
				title: '系统提示',
				content: `是否要删除文件"${attachment.fileName}"?`,
				okText: '确定',
				cancelText: '取消',
				type: 'warning',
				zIndex: 2600,
				onOk: async () => {
					try {
						// 调用API删除文件
						await deleteAttachments(attachment.id);

						// 从列表中移除
						this.checkFileList = this.checkFileList.filter(item => item.id !== attachment.id);

						// 触发更新事件
						this.$emit('needToUpdate', [...this.checkFileList]);

						this.$message.success('文件删除成功！');
					} catch (error) {
						console.error('文件删除失败:', error);
						this.$message.error('文件删除失败: ' + (error.message || '未知错误'));
					}
				},
				onCancel: () => {
					this.$message.info('已取消删除操作');
				}
			});
		},
		// 关闭弹窗
		closeDialog() {
			this.dialogVisible = false;
			// 重置上传标志位
			this.isUploading = false;
		}
	}
};
</script>

<template>
	<div>
		<div>
			<el-dropdown>
				<span class="el-dropdown-link" style="color: orangered">
					附件
					<i class="el-icon-arrow-down el-icon--right"></i>
				</span>
				<el-dropdown-menu slot="dropdown">
					<el-dropdown-item>
						<el-button size="mini" type="text" v-if="isUpload" @click="uploadFile(attachmentList)">上传附件</el-button>
					</el-dropdown-item>
					<el-dropdown-item>
						<div v-if="attachmentList && attachmentList.length > 0">
							<el-button size="mini" type="text" @click="checkFiles(attachmentList)">查看附件</el-button>
						</div>
						<div v-else>无附件</div>
					</el-dropdown-item>
				</el-dropdown-menu>
			</el-dropdown>
		</div>

		<!--    文件列表-->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			title="文件列表"
			:visible.sync="dialogVisible"
			width="620px"
			height="650px"
			append-to-body
			:close-on-click-modal="false"
			:close-on-press-escape="false"
			custom-class="check-files-dialog"
			@close="isUploading = false"
		>
			<h3>附件列表</h3>
			<div class="file-list">
				<!--上传过的文件列表-->
				<FileItems v-for="(item, index) in checkFileList" :key="item.id || index" :file-name="item.fileName" :file-path="item.filePath" @handleFile="() => handleDeleteFile(item)" />
				<!--支持上传-->
				<FileShowItem @handleFile="handleAddFile" v-if="isUpload" />
			</div>

			<h3>附件图片预览</h3>
			<div class="img-preview-container">
				<div class="img-list">
					<!--        只渲染checkFileList中的图片-->
					<div class="img-wrapper">
						<img v-for="(item, index) in imgList" :key="index" :src="showImgSrc(item)" alt="该附件无图片/图片无法查看" class="preview-img" />
					</div>
				</div>
			</div>
			<span slot="footer" class="dialog-footer">
				<el-button @click="closeDialog">取 消</el-button>
				<el-button type="primary" @click="closeDialog">确 定</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss">
// 弹窗样式优化
::v-deep .check-files-dialog {
	height: 650px !important;
	max-height: none !important;

	.el-dialog {
		height: 650px !important;
		max-height: none !important;
		display: flex !important;
		flex-direction: column !important;
		margin-top: calc(50vh - 325px) !important;
		margin-bottom: 0 !important;
	}

	.el-dialog__header {
		flex-shrink: 0 !important;
		padding: 20px 20px 10px !important;
	}

	.el-dialog__body {
		flex: 1 !important;
		overflow: hidden !important;
		padding: 10px 20px !important;
		display: flex !important;
		flex-direction: column !important;
		min-height: 0 !important;
		height: calc(650px - 120px) !important; /* 总高度减去头部和底部 */
	}

	.el-dialog__footer {
		flex-shrink: 0 !important;
		padding: 10px 20px 20px !important;
	}
}

.file-list {
	display: flex;
	flex-wrap: wrap;
	justify-content: flex-start;
	align-items: flex-start;
	align-content: flex-start;
	padding: 15px;
	border: 1px solid #ccc;
	border-radius: 15px;
	background: #fafafa;
	margin-bottom: 10px;
	flex-shrink: 0;
}

// 图片预览容器样式优化
.img-preview-container {
	flex: 1;
	overflow: hidden;
	display: flex;
	flex-direction: column;
	min-height: 0;

	h3 {
		flex-shrink: 0;
		margin: 10px 0;
	}
}

.img-list {
	flex: 1;
	overflow-y: auto;
	border: 1px solid #e6e6e6;
	border-radius: 8px;
	background: #f9f9f9;
	min-height: 180px;
	max-height: 250px;

	// 美化滚动条
	&::-webkit-scrollbar {
		width: 8px;
	}

	&::-webkit-scrollbar-track {
		background: #f1f1f1;
		border-radius: 4px;
	}

	&::-webkit-scrollbar-thumb {
		background: #c1c1c1;
		border-radius: 4px;

		&:hover {
			background: #a8a8a8;
		}
	}
}

.img-wrapper {
	padding: 15px;
	display: flex;
	flex-direction: column;
	gap: 15px;
}

.preview-img {
	max-width: 100%;
	width: 100%;
	height: auto;
	border-radius: 6px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
	transition: transform 0.2s ease;
	object-fit: contain;

	&:hover {
		transform: scale(1.02);
		box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
	}
}

// 当没有图片时的提示样式
.img-list:empty::before {
	content: '暂无图片预览';
	display: flex;
	justify-content: center;
	align-items: center;
	height: 180px;
	color: #999;
	font-size: 14px;
}
</style>
