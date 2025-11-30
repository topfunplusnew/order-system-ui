<!--
UploadFilesButton 文件上传组件

功能说明：
- 支持多文件上传，自动管理上传状态
- 上传成功后返回指定格式的参数对象：{ params: { attachmentIds: [] } }
- 提供文件列表查看、图片预览、文件下载和删除功能
- 支持状态清除，适用于表单重置场景
- 使用 Vuex 全局附件 ID 池管理，所有组件共享全局状态
- 自动触发 files-updated 事件，返回标准格式的 params

基本使用：
<UploadFilesButton 
  @files-updated="handleFilesUpdated"
  ref="uploadButton"
/>

完整配置：
<UploadFilesButton 
  :max-files="5"
  :max-file-size="20"
  accept-types="image/*,.pdf,.doc,.docx"
  flag="customFlag"
  :extra-info="{ moduleId: 123, type: 'payment' }"
  :initial-attachments="[{id: 1, fileName: 'test.pdf', filePath: '/path/to/file.pdf'}]"
  @files-updated="handleFilesUpdated"
  ref="uploadButton"
/>

Props:
- acceptTypes: String - 接受的文件类型，如 'image/*,.pdf,.doc'
- maxFiles: Number - 最大文件数量限制（默认10）
- maxFileSize: Number - 单个文件大小限制MB（默认10）
- flag: String - 上传标识，用于区分不同模块（默认'uploadButton'）
- extraInfo: Object - 上传时的额外信息（默认{}）
- initialAttachments: Array - 初始附件列表，用于编辑时显示已有附件（默认[]）

事件:
- files-updated: 文件列表更新时自动触发，参数: { params: { attachmentIds: [] } }

方法:
- clearUploadedFiles(): 清除所有已上传文件的状态（表单关闭时调用）
- setAttachments(attachments): 手动设置附件列表
- getUploadParams(): 获取当前上传参数对象

使用示例:
methods: {
  handleFilesUpdated(params) {
    // params 结构: { params: { attachmentIds: [1, 2, 3] } }
    this.formData = { ...this.formData, ...params };
  },
  
  // 表单关闭时清除状态
  onFormClose() {
    this.$refs.uploadButton.clearUploadedFiles();
  }
}

技术特性:
- 基于 Vuex 的全局附件 ID 池，确保数据一致性
- 上传成功后自动将文件 ID 添加到全局池中
- 自动状态同步，emit 标准格式的 params 对象
- 组件维护本地文件信息用于展示，Vuex 只维护 ID 池
-->

<template>
	<div class="upload-files-button">
		<!-- 文件上传操作区域 -->
		<div class="upload-container">
			<!-- 主要上传按钮 -->
			<el-button type="primary" size="mini" icon="el-icon-upload2" @click="triggerFileUpload" :loading="uploading" class="upload-btn">上传附件</el-button>

			<!-- 查看已上传文件的图标按钮 -->
			<el-button v-if="uploadedFiles.length > 0" type="text" size="mini" icon="el-icon-view" @click="showUploadedFiles" class="view-btn" :title="`已上传 ${uploadedFiles.length} 个文件`">({{ uploadedFiles.length }})</el-button>
		</div>

		<!-- 隐藏的文件输入框 -->
		<input ref="fileInput" type="file" multiple style="display: none" @change="handleFileSelect" :accept="acceptTypes" />

		<!-- 文件列表查看对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="已上传文件列表" :visible.sync="dialogVisible" width="600px" append-to-body :close-on-click-modal="false" custom-class="upload-files-dialog">
			<div class="file-list-container">
				<div v-if="uploadedFiles.length > 0" class="file-grid">
					<div v-for="(file, index) in uploadedFiles" :key="file.id" class="file-item">
						<div class="file-info">
							<i :class="getFileIcon(file.fileSuffix)" class="file-icon"></i>
							<div class="file-details">
								<div class="file-name" :title="file.fileName">{{ file.fileName }}</div>
								<div class="file-size">{{ formatFileSize(file.fileSize) }}</div>
								<div class="file-time">{{ formatTime(file.createTime) }}</div>
							</div>
						</div>
						<div class="file-actions">
							<el-button type="text" size="mini" icon="el-icon-download" @click="downloadFile(file)" title="下载文件"></el-button>
							<el-button type="text" size="mini" icon="el-icon-delete" @click="removeFile(index)" style="color: #f56c6c" title="移除文件"></el-button>
						</div>
					</div>
				</div>
				<div v-else class="empty-state">
					<i class="el-icon-folder-opened" style="font-size: 48px; color: #c0c4cc"></i>
					<p>暂无上传文件</p>
				</div>
			</div>

			<!-- 图片预览区域 -->
			<div v-if="imageFiles.length > 0" class="image-preview-section">
				<h4>图片预览</h4>
				<div class="image-grid">
					<div v-for="(image, index) in imageFiles" :key="index" class="image-item">
						<img :src="getImageUrl(image.filePath)" :alt="image.fileName" @click="previewImage(image)" class="preview-thumbnail" />
					</div>
				</div>
			</div>

			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">关 闭</el-button>
				<el-button type="danger" @click="clearAllFiles" v-if="uploadedFiles.length > 0">清空所有文件</el-button>
			</span>
		</el-dialog>

		<!-- 图片预览对话框 -->
		<el-dialog title="图片预览" :visible.sync="imagePreviewVisible" width="80%" append-to-body>
			<div class="image-preview-container">
				<img v-if="currentPreviewImage" :src="getImageUrl(currentPreviewImage.filePath)" :alt="currentPreviewImage.fileName" class="preview-image" />
			</div>
		</el-dialog>
	</div>
</template>

<script>
import { addAttachments, addAttachmentsBatch } from '@/api/system/attachments';

export default {
	name: 'UploadFilesButton',
	props: {
		// 接受的文件类型
		acceptTypes: {
			type: String,
			default: '*'
		},
		// 最大文件数量限制
		maxFiles: {
			type: Number,
			default: 10
		},
		// 单个文件大小限制（MB）
		maxFileSize: {
			type: Number,
			default: 10
		},
		// 上传标识
		flag: {
			type: String,
			default: 'uploadButton'
		},
		// 额外信息
		extraInfo: {
			type: Object,
			default: () => ({})
		},
		// 初始附件列表
		initialAttachments: {
			type: Array,
			default: () => []
		}
	},
	data() {
		return {
			uploading: false,
			dialogVisible: false,
			imagePreviewVisible: false,
			currentPreviewImage: null,
			// 本地文件列表，用于展示文件信息
			uploadedFiles: []
		};
	},
	computed: {
		// 过滤出图片文件
		imageFiles() {
			const imageTypes = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg'];
			return this.uploadedFiles.filter(file => imageTypes.includes((file.fileSuffix || '').toLowerCase()));
		},
		// 获取标准格式的 params 对象（从 Vuex 全局状态获取）
		params() {
			return this.$store.getters['attachments/getParams'];
		}
	},
	watch: {
		// 监听 Vuex 中的全局附件 ID 变化，自动触发 files-updated 事件
		'$store.state.attachments.attachmentIds': {
			handler() {
				this.$nextTick(() => {
					this.$emit('files-updated', this.params);
				});
			},
			deep: true
		},
		// 监听初始附件列表变化
		initialAttachments: {
			handler(newAttachments) {
				this.initializeAttachments(newAttachments);
			},
			immediate: true,
			deep: true
		}
	},
	created() {
		// 初始化附件列表
		this.initializeAttachments(this.initialAttachments);
	},
	methods: {
		// 初始化附件列表
		initializeAttachments(attachments) {
			if (!attachments || !Array.isArray(attachments) || attachments.length === 0) {
				return;
			}

			// 清空当前组件的文件列表
			this.uploadedFiles = [];

			// 设置初始附件到组件本地
			this.uploadedFiles = [...attachments].filter(file => file.flag === this.flag);
			console.log(`attachments`, attachments);
			console.log(`this.flag`, this.flag);
			const attachmentIds = attachments.map(file => file.id).filter(id => id);

			// 将初始附件ID添加到全局池（不清空，避免覆盖其他组件的ID）
			if (attachmentIds.length > 0) {
				attachmentIds.forEach(id => {
					this.$store.dispatch('attachments/addAttachmentId', id);
				});
			}
		},

		// 触发文件选择
		triggerFileUpload() {
			this.$refs.fileInput.click();
		},

		// 处理文件选择
		async handleFileSelect(event) {
			const files = Array.from(event.target.files);
			if (files.length === 0) return;

			// 检查文件数量限制
			if (this.uploadedFiles.length + files.length > this.maxFiles) {
				this.$message.warning(`最多只能上传 ${this.maxFiles} 个文件`);
				this.$refs.fileInput.value = '';
				return;
			}

			// 检查文件大小
			const oversizeFiles = files.filter(file => file.size > this.maxFileSize * 1024 * 1024);
			if (oversizeFiles.length > 0) {
				const oversizeNames = oversizeFiles.map(f => f.name).join(', ');
				this.$message.warning(`以下文件大小超过 ${this.maxFileSize}MB：${oversizeNames}`);
				this.$refs.fileInput.value = '';
				return;
			}

			// 检查文件格式（如果指定了 acceptTypes）
			if (this.acceptTypes && this.acceptTypes !== '*') {
				const invalidFiles = this.validateFileTypes(files);
				if (invalidFiles.length > 0) {
					const invalidNames = invalidFiles.map(f => f.name).join(', ');
					const allowedTypes = this.getAcceptableTypesDescription();
					this.$message.error(`以下文件格式不支持：${invalidNames}。请上传 ${allowedTypes} 格式的文件`);
					this.$refs.fileInput.value = '';
					return;
				}
			}

			// 校验重名（包括后缀）：禁止选中文件内部有重名，或与已上传文件重名
			const selectedNames = files.map(f => (f.name || '').trim());
			// 选中文件内部重复
			const dupInSelected = selectedNames.filter((name, idx, arr) => name && arr.indexOf(name) !== idx);
			if (dupInSelected.length > 0) {
				this.$message.warning(`选中文件中存在重名文件：${[...new Set(dupInSelected)].join(', ')}`);
				this.$refs.fileInput.value = '';
				return;
			}
			// 与已上传文件重复 (uploadedFiles 中使用 fileName 字段)
			const existingNames = new Set(this.uploadedFiles.map(f => (f.fileName || f.name || '').trim()));
			const dupWithExisting = selectedNames.filter(name => existingNames.has(name));
			if (dupWithExisting.length > 0) {
				this.$message.warning(`存在与已上传文件同名的文件：${[...new Set(dupWithExisting)].join(', ')}`);
				this.$refs.fileInput.value = '';
				return;
			}

			this.uploading = true;
			console.log(this.flag);
			try {
				// 构建按文件名映射的 params 元数据
				const paramsMap = {};
				files.forEach(file => {
					const ext = (file.name || '').split('.').pop() || '';
					paramsMap[file.name] = {
						flag: this.flag,
						remark: file.name,
						extraInfo: Object.assign({}, this.extraInfo || {}, {
							fileType: ext.toLowerCase(),
							uploadTime: new Date().toISOString()
						})
					};
				});

				console.log(paramsMap);

				// 使用批量接口上传
				const response = await addAttachmentsBatch(files, paramsMap);
				if (response && response.code === 200 && response.data) {
					let uploaded = [];
					if (Array.isArray(response.data)) uploaded = response.data;
					else if (typeof response.data === 'object') uploaded = Object.values(response.data);

					// 更新本地列表和 Vuex 全局池
					uploaded.forEach(item => {
						if (item) {
							this.uploadedFiles.push(item);
							if (item.id) this.$store.dispatch('attachments/addAttachmentId', item.id);
						}
					});

					this.$message.success(`成功上传 ${uploaded.length} 个文件`);
					this.$nextTick(() => {
						this.$emit('files-updated', this.params);
					});
				} else {
					throw new Error((response && response.msg) || '上传失败');
				}
			} catch (error) {
				console.error('文件上传失败:', error);
				// 检查是否是文件格式错误
				const errorMessage = error.message || error.msg || '未知错误';
				if (errorMessage.includes('格式') || errorMessage.includes('格式有误') || errorMessage.includes('不支持') || errorMessage.includes('file format')) {
					const allowedTypes = this.getAcceptableTypesDescription();
					this.$message.error(`文件格式错误：${errorMessage}。${allowedTypes !== '任意格式' ? '请上传 ' + allowedTypes + ' 格式的文件' : ''}`);
				} else {
					this.$message.error('文件上传失败: ' + errorMessage);
				}
			} finally {
				this.uploading = false;
				// 清空文件输入框
				this.$refs.fileInput.value = '';
			}
		},

		// 上传单个文件
		async uploadSingleFile(file) {
			try {
				const response = await addAttachments(file, {
					flag: this.flag,
					extraInfo: this.extraInfo
				});
				if (response.code === 200 && response.data) {
					// 将文件信息添加到本地列表用于展示
					this.uploadedFiles.push(response.data);
					// 将文件 ID 添加到 Vuex 全局池
					this.$store.dispatch('attachments/addAttachmentId', response.data.id);
				} else {
					throw new Error(response.msg || '上传失败');
				}
			} catch (error) {
				console.error(`文件 ${file.name} 上传失败:`, error);
				throw error;
			}
		},

		// 显示已上传文件列表
		showUploadedFiles() {
			this.dialogVisible = true;
		},

		// 移除文件
		removeFile(index) {
			this.$confirm('确定要移除这个文件吗？', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			})
				.then(() => {
					const file = this.uploadedFiles[index];
					if (file && file.id) {
						// 从本地列表移除文件
						this.uploadedFiles.splice(index, 1);
						// 从 Vuex 全局池移除文件 ID
						this.$store.dispatch('attachments/removeAttachmentId', file.id);
					}
					this.$message.success('文件已移除');
				})
				.catch(() => {
					// 用户取消
				});
		},

		// 清空所有文件
		clearAllFiles() {
			this.$confirm('确定要清空所有文件吗？', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			})
				.then(() => {
					// 从 Vuex 全局池移除当前组件的所有文件 ID
					this.uploadedFiles.forEach(file => {
						if (file.id) {
							this.$store.dispatch('attachments/removeAttachmentId', file.id);
						}
					});
					// 清空本地文件列表
					this.uploadedFiles = [];
					this.$message.success('已清空所有文件');
				})
				.catch(() => {
					// 用户取消
				});
		},

		// 清除上传状态（对外暴露的方法）
		clearUploadedFiles() {
			// 从 Vuex 全局池移除当前组件的所有文件 ID
			this.uploadedFiles.forEach(file => {
				if (file.id) {
					this.$store.dispatch('attachments/removeAttachmentId', file.id);
				}
			});
			// 清空本地文件列表和对话框状态
			this.uploadedFiles = [];
			this.dialogVisible = false;
			this.imagePreviewVisible = false;
			this.currentPreviewImage = null;
			// 清空Vuex状态
			this.$store.dispatch('attachments/clearAttachmentIds');
		},

		// 设置附件列表（对外暴露的方法）
		setAttachments(attachments) {
			this.initializeAttachments(attachments);
		},

		// 获取文件图标
		getFileIcon(fileSuffix) {
			const suffix = (fileSuffix || '').toLowerCase();
			const iconMap = {
				pdf: 'el-icon-document',
				doc: 'el-icon-document',
				docx: 'el-icon-document',
				xls: 'el-icon-document',
				xlsx: 'el-icon-document',
				ppt: 'el-icon-document',
				pptx: 'el-icon-document',
				txt: 'el-icon-document',
				jpg: 'el-icon-picture',
				jpeg: 'el-icon-picture',
				png: 'el-icon-picture',
				gif: 'el-icon-picture',
				bmp: 'el-icon-picture',
				webp: 'el-icon-picture',
				svg: 'el-icon-picture',
				zip: 'el-icon-folder-opened',
				rar: 'el-icon-folder-opened',
				'7z': 'el-icon-folder-opened'
			};

			return iconMap[suffix] || 'el-icon-document';
		},

		// 格式化文件大小
		formatFileSize(size) {
			if (!size) return '0 B';

			const units = ['B', 'KB', 'MB', 'GB'];
			let index = 0;
			let fileSize = size;

			while (fileSize >= 1024 && index < units.length - 1) {
				fileSize /= 1024;
				index++;
			}

			return `${fileSize.toFixed(1)} ${units[index]}`;
		},

		// 格式化时间
		formatTime(timeString) {
			if (!timeString) return '';
			const date = new Date(timeString);
			return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
		},

		// 获取图片URL
		getImageUrl(filePath) {
			return process.env.VUE_APP_BASE_API + filePath;
		},

		// 预览图片
		previewImage(image) {
			this.currentPreviewImage = image;
			this.imagePreviewVisible = true;
		},

		// 下载文件
		downloadFile(file) {
			const link = document.createElement('a');
			link.href = this.getImageUrl(file.filePath);
			link.download = file.fileName;
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
		},

		// 获取当前上传的文件参数（对外暴露的方法）
		getUploadParams() {
			return this.params;
		},

		// 验证文件类型
		validateFileTypes(files) {
			if (!this.acceptTypes || this.acceptTypes === '*') {
				return [];
			}

			const invalidFiles = [];
			const acceptTypesArray = this.acceptTypes.split(',').map(type => type.trim().toLowerCase());

			files.forEach(file => {
				const fileName = file.name.toLowerCase();
				const fileExtension = fileName.substring(fileName.lastIndexOf('.'));
				let isValid = false;

				// 检查每个接受的文件类型
				for (const acceptType of acceptTypesArray) {
					// 处理通配符类型，如 "image/*"
					if (acceptType.includes('/*')) {
						const category = acceptType.split('/')[0];
						if (category === 'image') {
							const imageExts = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.svg'];
							if (imageExts.includes(fileExtension)) {
								isValid = true;
								break;
							}
						} else if (category === 'application') {
							const appExts = ['.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.zip', '.rar'];
							if (appExts.includes(fileExtension)) {
								isValid = true;
								break;
							}
						}
					}
					// 处理具体的文件扩展名，如 ".pdf", ".doc"
					else if (acceptType.startsWith('.')) {
						if (fileExtension === acceptType) {
							isValid = true;
							break;
						}
					}
					// 处理不带点的扩展名，如 "pdf", "doc"
					else if (!acceptType.includes('/')) {
						if (fileExtension === '.' + acceptType) {
							isValid = true;
							break;
						}
					}
					// 处理 MIME 类型，如 "application/pdf"
					else if (acceptType.includes('/')) {
						// 这里可以根据需要扩展 MIME 类型检查
						// 目前主要检查扩展名
						const mimeMap = {
							'application/pdf': '.pdf',
							'application/msword': '.doc',
							'application/vnd.openxmlformats-officedocument.wordprocessingml.document': '.docx',
							'application/vnd.ms-excel': '.xls',
							'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': '.xlsx',
							'image/jpeg': '.jpg',
							'image/png': '.png',
							'image/gif': '.gif'
						};
						if (mimeMap[acceptType] === fileExtension) {
							isValid = true;
							break;
						}
					}
				}

				if (!isValid) {
					invalidFiles.push(file);
				}
			});

			return invalidFiles;
		},

		// 获取可接受的文件类型描述
		getAcceptableTypesDescription() {
			if (!this.acceptTypes || this.acceptTypes === '*') {
				return '任意格式';
			}

			const acceptTypesArray = this.acceptTypes.split(',').map(type => type.trim());
			const descriptions = [];

			acceptTypesArray.forEach(type => {
				if (type === 'image/*') {
					descriptions.push('图片文件（jpg, png, gif, bmp, webp, svg）');
				} else if (type === 'application/*') {
					descriptions.push('文档文件（pdf, doc, docx, xls, xlsx, ppt, pptx）');
				} else if (type.startsWith('.')) {
					descriptions.push(type.toUpperCase());
				} else if (!type.includes('/')) {
					descriptions.push(type.toUpperCase());
				} else {
					descriptions.push(type);
				}
			});

			return descriptions.join('、') || '指定格式';
		}
	}
};
</script>

<style scoped lang="scss">
.upload-files-button {
	display: inline-block;

	.upload-container {
		display: flex;
		align-items: center;
		width: 160px;
		padding: 4px;
		border: 1px solid #dcdfe6;
		border-radius: 4px;
		background: #ffffff;
		transition: border-color 0.3s ease;

		&:hover {
			border-color: #409eff;
		}

		.upload-btn {
			flex: 1;
			margin: 0;
			border: none;
			background: transparent;
			color: #409eff;
			font-size: 12px;
			padding: 4px 8px;

			&:hover {
				background: #ecf5ff;
			}

			&.is-loading {
				color: #c0c4cc;
			}
		}

		.view-btn {
			flex-shrink: 0;
			margin: 0;
			padding: 4px 6px;
			color: #409eff;
			font-size: 12px;
			border-left: 1px solid #e4e7ed;
			margin-left: 4px;

			&:hover {
				background: #ecf5ff;
				color: #337ecc;
			}
		}
	}
}

// 对话框样式
::v-deep .upload-files-dialog {
	.el-dialog {
		max-height: 80vh;
		overflow: hidden;
		display: flex;
		flex-direction: column;
	}

	.el-dialog__body {
		flex: 1;
		overflow-y: auto;
		padding: 20px;
	}
}

.file-list-container {
	margin-bottom: 20px;
}

.file-grid {
	display: grid;
	grid-template-columns: 1fr;
	gap: 12px;
}

.file-item {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 12px;
	border: 1px solid #e6e6e6;
	border-radius: 8px;
	background: #fafafa;
	transition: all 0.3s ease;

	&:hover {
		border-color: #409eff;
		background: #f0f8ff;
	}
}

.file-info {
	display: flex;
	align-items: center;
	flex: 1;
	min-width: 0;
}

.file-icon {
	font-size: 24px;
	color: #606266;
	margin-right: 12px;
	flex-shrink: 0;
}

.file-details {
	flex: 1;
	min-width: 0;
}

.file-name {
	font-weight: 500;
	color: #303133;
	margin-bottom: 4px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.file-size {
	font-size: 12px;
	color: #909399;
	margin-bottom: 2px;
}

.file-time {
	font-size: 12px;
	color: #c0c4cc;
}

.file-actions {
	display: flex;
	gap: 8px;
	flex-shrink: 0;
}

.empty-state {
	text-align: center;
	padding: 40px 20px;
	color: #909399;

	p {
		margin-top: 16px;
		font-size: 14px;
	}
}

// 图片预览样式
.image-preview-section {
	border-top: 1px solid #e6e6e6;
	padding-top: 20px;
	margin-top: 20px;

	h4 {
		margin: 0 0 16px 0;
		color: #303133;
		font-size: 16px;
	}
}

.image-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
	gap: 12px;
}

.image-item {
	border-radius: 8px;
	overflow: hidden;
	border: 1px solid #e6e6e6;
	transition: all 0.3s ease;

	&:hover {
		border-color: #409eff;
		transform: translateY(-2px);
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	}
}

.preview-thumbnail {
	width: 100%;
	height: 120px;
	object-fit: cover;
	cursor: pointer;
	transition: transform 0.3s ease;

	&:hover {
		transform: scale(1.05);
	}
}

.image-preview-container {
	text-align: center;
}

.preview-image {
	max-width: 100%;
	max-height: 70vh;
	object-fit: contain;
}

.dialog-footer {
	display: flex;
	justify-content: space-between;
	align-items: center;
}
</style>
