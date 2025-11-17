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
		attachmentList: { type: Array, default: () => [] },
		isUpload: { type: Boolean, default: true },
		flag: { type: String, default: '' },
		extraInfo: { type: Object, default: () => ({}) }
	},
	data() {
		return {
			checkFileList: [],
			dialogVisible: false,
			isUploading: false
		};
	},
	computed: {
		filteredAttachments() {
			if (!Array.isArray(this.attachmentList)) return [];
			return this.attachmentList.filter(item => item && item.flag === this.flag);
		},
		imgList() {
			const imageTypes = ['.jpeg', '.jpg', '.png', '.svg', '.gif', '.bmp', '.webp'];
			return this.checkFileList.filter(item => item && item.filePath && imageTypes.includes(`.${(item.fileSuffix || '').toLowerCase()}`)).map(item => item.filePath);
		}
	},
	watch: {
		attachmentList: {
			deep: true,
			handler() {
				if (!this.dialogVisible) this.checkFileList = [...this.filteredAttachments];
			}
		}
	},
	methods: {
		showImgSrc(p) {
			return process.env.VUE_APP_BASE_API + p;
		},
		openAttachmentPanel() {
			this.checkFileList = [...this.filteredAttachments];
			this.dialogVisible = true;
		},
		uploadFile() {
			this.checkFileList = [...this.filteredAttachments];
			this.isUploading = true;
			this.dialogVisible = true;
		},
		async handleAddFile(file) {
			if (!file) {
				this.$message.error('上传的文件格式有误!');
				return;
			}
			try {
				this.$message.info('文件上传中，请稍候...');
				const response = await addAttachments(file, { flag: this.flag, extraInfo: this.extraInfo });
				if (response.code === 200 && response.data) {
					this.checkFileList.push(response.data);
					this.$emit('needToUpdate', [...this.checkFileList]);
				} else {
					throw new Error(response.msg || '上传失败');
				}
			} catch (e) {
				console.error('文件上传失败:', e);
				this.$message.error('文件上传失败: ' + (e.message || '未知错误'));
			}
		},
		handleDeleteFile(attachment) {
			this.$antdconfirm({
				title: '系统提示',
				content: `是否要删除文件"${attachment.fileName}"?`,
				okText: '确定',
				cancelText: '取消',
				type: 'warning',
				zIndex: 2600,
				onOk: async () => {
					try {
						await deleteAttachments(attachment.id);
						this.checkFileList = this.checkFileList.filter(i => i.id !== attachment.id);
						this.$emit('needToUpdate', [...this.checkFileList]);
						this.$message.success('文件删除成功！');
					} catch (e) {
						console.error('文件删除失败:', e);
						this.$message.error('文件删除失败: ' + (e.message || '未知错误'));
					}
				}
			});
		},
		closeDialog() {
			this.dialogVisible = false;
			this.isUploading = false;
			this.$bus.$emit('refreshList');
		}
	}
};
</script>

<template>
	<div>
		<!-- 有附件时显示图标；无附件时不展示任何内容（仍保留点击区域以便上传，可按需移除 @click） -->
		<div class="attachment-entry" v-if="filteredAttachments.length > 0" @click="openAttachmentPanel">
			<el-tooltip content="点击查看/上传附件" placement="top">
				<div class="attachment-icon-wrapper">
					<i class="el-icon-picture" v-once />
				</div>
			</el-tooltip>
		</div>
		<div v-else class="attachment-entry empty" @click="openAttachmentPanel"></div>

		<!--    文件列表-->
		<el-dialog :modal="false" v-dialogDrag v-el-relen-dialog title="文件列表" :visible.sync="dialogVisible" width="670px" height="1000px" append-to-body :close-on-click-modal="false" :close-on-press-escape="false" custom-class="check-files-dialog" @close="isUploading = false">
			<h3 v-once>附件列表</h3>
			<div class="file-list" :class="{ 'empty-list': checkFileList.length === 0 }">
				<!--上传过的文件列表-->
				<template v-if="checkFileList.length > 0">
					<FileItems v-for="(item, index) in checkFileList" :key="item.id || index" :fileItem="item" @handleFile="handleDeleteFile" />
					<!--支持上传 - 有附件时显示在列表最后-->
					<FileShowItem @handleFile="handleAddFile" v-if="isUpload" variant="normal" />
				</template>
				<template v-else>
					<div class="empty-content">
						<div class="empty-text">暂无附件</div>
						<!--支持上传 - 无附件时显示在中央 使用空状态特有样式-->
						<FileShowItem @handleFile="handleAddFile" v-if="isUpload" variant="empty" />
					</div>
				</template>
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
.attachment-entry {
	display: inline-block;
	cursor: pointer;
	user-select: none;
	width: 20px;
	height: 20px;
	&.empty {
		border: 1px dashed #dcdfe6;
		border-radius: 6px;
		background: transparent;
		&:hover {
			border-color: #409eff;
		}
	}
	.attachment-icon-wrapper {
		width: 100%;
		height: 100%;
		border-radius: 6px;
		background: #409eff22;
		display: flex;
		align-items: center;
		justify-content: center;
		border: 1px solid #409eff55;
		transition: all 0.2s;
		color: #409eff;
		font-size: 16px;
		&:hover {
			background: #409eff33;
			border-color: #409eff;
			box-shadow: 0 0 0 2px #409eff22;
		}
	}
}

.file-list {
	display: flex;
	flex-wrap: wrap;
	justify-content: flex-start;
	align-items: flex-start;
	align-content: flex-start;
	padding: 12px;
	border: 1px solid #ccc;
	border-radius: 10px;
	background: #fafafa;
	/* 移除旧的 centered-upload，使用 FileShowItem 的 variant 实现 */
}
.centered-upload:hover {
	border-color: #409eff;
	background: #f0f8ff;
	box-shadow: 0 6px 18px -2px rgba(64, 158, 255, 0.25), 0 0 0 2px rgba(64, 158, 255, 0.2);
	transform: translateY(-2px);
}
.centered-upload:active {
	transform: translateY(0);
	box-shadow: 0 3px 10px -1px rgba(64, 158, 255, 0.3), 0 0 0 2px rgba(64, 158, 255, 0.25);
}

/* 适配深色模式（若以后支持） */
@media (prefers-color-scheme: dark) {
	.centered-upload {
		background: linear-gradient(135deg, #2a3138 0%, #232a31 100%);
		border-color: #44515e;
		box-shadow: 0 2px 6px rgba(0, 0, 0, 0.6), 0 0 0 1px rgba(120, 144, 156, 0.25) inset;
	}
	.centered-upload::before {
		color: #d0d7df;
	}
	.centered-upload:hover {
		background: #2f3c48;
		border-color: #409eff;
	}
}

.img-preview-container {
	flex: 1 1 auto;
	min-height: 0;
	display: flex;
	flex-direction: column;
}
.img-list {
	flex: 1 1 auto;
	min-height: 0;
	overflow-y: auto;
	border: 1px solid #e6e6e6;
	border-radius: 8px;
	background: #f9f9f9;
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
.img-preview-container h3 {
	flex-shrink: 0;
	margin: 8px 0;
}
.img-wrapper {
	padding: 15px;
	display: flex;
	flex-direction: column;
	gap: 18px;
}
.preview-img {
	max-width: 100%;
	width: 100%;
	height: auto;
	object-fit: contain;
	border-radius: 6px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
	transition: transform 0.2s ease, box-shadow 0.2s ease;
	background: #fff;
	&:hover {
		transform: scale(1.02);
		box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
	}
}
.img-list:empty::before {
	content: '暂无图片预览';
	display: flex;
	justify-content: center;
	align-items: center;
	height: 180px;
	color: #999;
	font-size: 14px;
}

/* 弹窗自定义样式 - 固定标题栏 */
::v-deep .check-files-dialog {
	.el-dialog__header {
		position: sticky;
		top: 0;
		background: #fff;
		border-bottom: 1px solid #ebeef5;
		z-index: 10;
		padding: 20px 20px 16px;
		margin: 0;
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
	}

	.el-dialog__body {
		padding-top: 0;
		max-height: calc(100vh - 150px);
		overflow-y: auto;
	}

	.el-dialog__footer {
		position: sticky;
		bottom: 0;
		background: #fff;
		border-top: 1px solid #ebeef5;
		z-index: 10;
		padding: 16px 20px 20px;
		margin: 0;
		box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.08);
	}
}
</style>
