<!--查看文件通用的的组件-->
<!-- 如果一个列需要展示文件 那么就可以用这个组件-->
<script>
import { check_file } from '../views/dashboard/mixins/utils/check_file';
import FileItems from './FileItems.vue';
import FileShowItem from './FileShowItem.vue';

export default {
	name: 'CheckFiles',
	components: { FileShowItem, FileItems },
	mixins: [check_file],
	props: {
		// 文件的地址url字段
		path: {
			type: String,
			default: ''
		},
		isUpload: {
			type: Boolean,
			default: true
		}
	},
	data() {
		return {
			// 检查的文件列表
			checkFileList: [],
			dialogVisible: false,
			// 是否正在上传文件的标志位
			isUploading: false,

			// 最大文件个数限制
			maxFileNum: 5
		};
	},
	computed: {
		// 过滤出来图片 给模板使用
		imgList() {
			// todo 这里有问题 报错undefied
			// 不一定只有jpg格式的 可能还有png格式
			const type = ['.jpeg', '.jpg', '.png', '.svg'];
			// 根据文件名称的后缀来判断
			return this.checkFileList.filter(el => {
				if (!el) return false;
				return type.some(item => item === el.slice(el.lastIndexOf('.')));
			});
		},
		// 不大于五个附件返回true
		isFull() {
			return this.checkFileList.length < this.maxFileNum;
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
		// 查看文件列表
		checkFiles(path) {
			this.checkFileList = [];
			// 如果path有值 才能分隔 没有值就是本身
			if (path) {
				this.checkFileList = path.split('|').filter(item => item !== '');
			}
			// 查看文件时不是上传模式
			this.isUploading = false;
			this.dialogVisible = true;
		},
		// 上传附件
		uploadFile(path) {
			// fileList即为已经上传的文件列表
			this.checkFileList = [];
			if (path) {
				this.checkFileList = path.split('|').filter(item => item !== '');
			}
			// 设置上传标志位
			this.isUploading = true;
			this.dialogVisible = true;
		},
		// 添加某个文件
		handleAddFile(value) {
			// 这里如果选择了不合适的文件 会返回undefined
			if (!value) {
				this.$message.error('上传的文件格式有误!');
				return;
			}
			let newPath = null;
			// 如果长度大于等于5 不得上传
			if (this.checkFileList.length >= this.maxFileNum) {
				this.$message.error('最多只能上传' + this.maxFileNum + '个文件');
			} else {
				// 立即添加到列表中，让用户能看到上传的文件
				this.checkFileList.push(value);
				
				// 如果是第一个文件，需要拼接一个|
				if (this.checkFileList.length === 1) {
					newPath = value + '|';
				} else {
					newPath = this.checkFileList.join('|');
				}

				// 调用传入的业务接口 修改数据
				this.$emit('needToUpdate', newPath);
				
				// 显示成功消息
				this.$message.success('文件上传成功！');
			}
		},
		// 删除某个文件
		handleDeleteFile(value) {
			// 弹出确认框 先确认是否要删除
			this.$antconfirm({
				title: '系统提示',
				content: '是否要删除该文件?',
				okText: '确定',
				cancelText: '取消',
				type: 'warning',
				zIndex: 2600,
				onOk: () => {
					const files = this.checkFileList.filter(item => item !== value);
					const newPath = files.length === 0 ? '' : files.join('|');
					this.$emit('needToUpdate', newPath);
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
						<el-button size="mini" type="text" v-if="isUpload" @click="uploadFile(path)">上传附件</el-button>
					</el-dropdown-item>
					<el-dropdown-item>
						<div v-if="path">
							<el-button size="mini" type="text" @click="checkFiles(path)">查看附件</el-button>
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
			title="文件列表(最多上传五个文件)"
			:visible.sync="dialogVisible"
			width="620px"
			append-to-body
			:close-on-click-modal="false"
			:close-on-press-escape="false"
			custom-class="check-files-dialog"
			@close="isUploading = false"
		>
			<h3>附件列表</h3>
			<div class="file-list">
				<!--        上传过的文件列表-->
				<FileItems v-if="path" v-for="(item, index) in checkFileList" :key="index" :file-name="item" @handleFile="handleDeleteFile" />
				<!--        支持上传-->
				<FileShowItem @handleFile="handleAddFile" v-if="isFull && isUpload" />
			</div>

			<h3>附件图片预览</h3>
			<div class="img-preview-container">
				<div class="img-list">
					<!--        只渲染checkFileList中的图片-->
					<div class="img-wrapper">
						<img v-for="(item, index) in imgList" :key="index" :src="item" alt="该附件无图片/图片无法查看" class="preview-img" />
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
	max-height: 87vh !important;
	
	.el-dialog {
		max-height: 85vh !important;
		display: flex !important;
		flex-direction: column !important;
		margin-top: 5vh !important;
		margin-bottom: 5vh !important;
	}
	
	.el-dialog__body {
		flex: 1 !important;
		overflow: hidden !important;
		padding: 10px 20px !important;
		display: flex !important;
		flex-direction: column !important;
		min-height: 0 !important;
	}
	
	.el-dialog__footer {
		flex-shrink: 0 !important;
		padding: 10px 20px 15px !important;
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
	min-height: 200px;
	max-height: 400px;

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
	height: 200px;
	color: #999;
	font-size: 14px;
}
</style>
