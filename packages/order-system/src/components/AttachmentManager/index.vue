<!--
  用户需求：salesReward 类型接口都支持附件，本期在「质量赔偿统计表」统一提供附件入口。
  实际改动：受控式附件管理组件，上传走 POST /system/attachments（multipart 字段 file，取 data.id），对外只暴露最新附件数组。
-->
<template>
	<div class="attachment-manager">
		<div class="attachment-manager__toolbar">
			<el-button type="primary" size="mini" icon="el-icon-upload2" :loading="uploading" :disabled="disabled || uploading" @click="triggerSelect">上传附件</el-button>
			<span class="attachment-manager__tip">单个文件不超过 {{ maxFileSize }}MB，最多 {{ maxFiles }} 个</span>
			<el-button v-if="!disabled && attachments.length" type="text" size="mini" class="attachment-manager__clear" @click="handleClear">清空附件</el-button>
		</div>
		<input ref="fileInput" class="attachment-manager__input" type="file" multiple :accept="acceptTypes" @change="handleFileChange" />
		<div v-if="attachments.length" class="attachment-manager__list">
			<div v-for="(item, index) in attachments" :key="item.id || index" class="attachment-manager__item">
				<i :class="getFileIcon(item)" class="attachment-manager__icon" />
				<div class="attachment-manager__meta">
					<span class="attachment-manager__name" :title="item.fileName">{{ item.fileName || '未命名附件' }}</span>
					<span class="attachment-manager__sub">
						{{ formatFileSize(item.fileSize) }}
						<template v-if="item.createTime">· {{ formatTime(item.createTime) }}</template>
					</span>
				</div>
				<div class="attachment-manager__actions">
					<el-button v-if="isImage(item)" type="text" size="mini" icon="el-icon-view" title="预览图片" @click="preview(item)" />
					<el-button type="text" size="mini" icon="el-icon-download" title="下载附件" @click="download(item)" />
					<el-button v-if="!disabled" type="text" size="mini" icon="el-icon-delete" title="移除附件" class="attachment-manager__remove" @click="remove(index)" />
				</div>
			</div>
		</div>
		<div v-else class="attachment-manager__empty">暂无附件</div>
		<el-dialog :visible.sync="previewVisible" title="图片预览" width="70%" append-to-body>
			<img v-if="previewUrl" :src="previewUrl" alt="附件预览" style="display: block; width: 100%" />
		</el-dialog>
	</div>
</template>

<script>
import { addAttachments } from '@/api/system/attachments';

const IMAGE_SUFFIXES = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg'];
const ARCHIVE_SUFFIXES = ['zip', 'rar', '7z'];

const fileSuffixOf = item => {
	if (!item) return '';
	if (item.fileSuffix) return String(item.fileSuffix).replace(/^\./, '').toLowerCase();
	const name = String(item.fileName || '');
	const index = name.lastIndexOf('.');
	return index === -1 ? '' : name.slice(index + 1).toLowerCase();
};

export default {
	name: 'AttachmentManager',
	props: {
		// 当前附件列表（v-model），每项包含 id / fileName / filePath / fileSuffix / fileSize / createTime
		value: {
			type: Array,
			default: () => []
		},
		// 只读模式：隐藏上传、移除、清空
		disabled: {
			type: Boolean,
			default: false
		},
		// 允许上传的文件类型
		acceptTypes: {
			type: String,
			default: '*'
		},
		// 最多文件数
		maxFiles: {
			type: Number,
			default: 10
		},
		// 单个文件大小上限（MB）
		maxFileSize: {
			type: Number,
			default: 20
		}
	},
	data() {
		return {
			uploading: false,
			previewVisible: false,
			previewUrl: ''
		};
	},
	computed: {
		attachments() {
			return Array.isArray(this.value) ? this.value : [];
		}
	},
	methods: {
		triggerSelect() {
			if (this.disabled || this.uploading) return;
			if (this.$refs.fileInput) this.$refs.fileInput.click();
		},
		/**
		 * 选中文件后逐个上传，全部结束后一次性同步最新附件数组
		 * @param {Event} event - input change 事件
		 * @returns {Promise<void>}
		 */
		async handleFileChange(event) {
			const input = event && event.target;
			const files = Array.from((input && input.files) || []);
			if (input) input.value = '';
			if (!files.length) return;

			if (this.attachments.length + files.length > this.maxFiles) {
				this.$message.warning(`最多只能上传 ${this.maxFiles} 个附件`);
				return;
			}
			const oversize = files.filter(file => file.size > this.maxFileSize * 1024 * 1024);
			if (oversize.length) {
				this.$message.warning(`以下附件超过 ${this.maxFileSize}MB：${oversize.map(file => file.name).join('、')}`);
				return;
			}

			this.uploading = true;
			const next = [...this.attachments];
			const failures = [];
			for (const file of files) {
				try {
					const response = await addAttachments(file, {}, { repeatSubmit: false });
					const uploaded = response && response.data;
					if (uploaded && uploaded.id !== null && uploaded.id !== undefined) {
						next.push(uploaded);
					} else {
						failures.push(`${file.name}：${(response && response.msg) || '上传失败'}`);
					}
				} catch (error) {
					failures.push(`${file.name}：${(error && error.message) || '上传失败'}`);
				}
			}
			this.uploading = false;
			this.emitChange(next);
			const succeeded = next.length - this.attachments.length;
			if (succeeded > 0) this.$message.success(`成功上传 ${succeeded} 个附件`);
			if (failures.length) this.$message.error(`附件上传失败：${failures.join('；')}`);
		},
		remove(index) {
			const target = this.attachments[index];
			if (!target) return;
			this.$confirm(`是否移除附件「${target.fileName || '未命名附件'}」？`, '提示', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' })
				.then(() => {
					this.emitChange(this.attachments.filter((item, current) => current !== index));
					this.$message.success('已移除附件，保存后生效');
				})
				.catch(() => {});
		},
		handleClear() {
			if (!this.attachments.length) return;
			this.$confirm('是否清空全部附件？保存后生效。', '提示', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' })
				.then(() => {
					this.emitChange([]);
					this.$message.success('已清空附件，保存后生效');
				})
				.catch(() => {});
		},
		emitChange(list) {
			this.$emit('input', [...list]);
			this.$emit('change', [...list]);
		},
		fileUrl(item) {
			const path = (item && item.filePath) || '';
			if (!path) return '';
			if (/^https?:\/\//i.test(path)) return path;
			return `${process.env.VUE_APP_BASE_API || ''}${path}`;
		},
		download(item) {
			const url = this.fileUrl(item);
			if (!url) {
				this.$message.warning('该附件缺少文件地址，无法下载');
				return;
			}
			const link = document.createElement('a');
			link.href = url;
			link.download = (item && item.fileName) || '';
			link.target = '_blank';
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
		},
		preview(item) {
			this.previewUrl = this.fileUrl(item);
			this.previewVisible = Boolean(this.previewUrl);
			if (!this.previewUrl) this.$message.warning('该附件缺少文件地址，无法预览');
		},
		isImage(item) {
			return IMAGE_SUFFIXES.includes(fileSuffixOf(item));
		},
		getFileIcon(item) {
			const suffix = fileSuffixOf(item);
			if (IMAGE_SUFFIXES.includes(suffix)) return 'el-icon-picture-outline attachment-manager__icon--image';
			if (ARCHIVE_SUFFIXES.includes(suffix)) return 'el-icon-folder-opened';
			return 'el-icon-document';
		},
		formatFileSize(size) {
			const bytes = Number(size);
			if (!Number.isFinite(bytes) || bytes <= 0) return '未知大小';
			const units = ['B', 'KB', 'MB', 'GB'];
			let index = 0;
			let value = bytes;
			while (value >= 1024 && index < units.length - 1) {
				value /= 1024;
				index += 1;
			}
			return `${value.toFixed(index === 0 ? 0 : 1)} ${units[index]}`;
		},
		formatTime(time) {
			if (!time) return '';
			const date = new Date(String(time).replace(/-/g, '/'));
			if (Number.isNaN(date.getTime())) return String(time);
			const pad = value => String(value).padStart(2, '0');
			return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}`;
		}
	}
};
</script>

<style scoped lang="scss">
.attachment-manager {
	width: 100%;

	&__toolbar {
		display: flex;
		align-items: center;
		flex-wrap: wrap;
		gap: 8px;
	}

	&__tip {
		color: #909399;
		font-size: 12px;
	}

	&__clear {
		color: #f56c6c;
	}

	&__input {
		display: none;
	}

	&__list {
		margin-top: 8px;
		border: 1px solid #ebeef5;
		border-radius: 6px;
		background: #fafafa;
	}

	&__item {
		display: flex;
		align-items: center;
		gap: 10px;
		padding: 6px 10px;

		& + & {
			border-top: 1px solid #ebeef5;
		}
	}

	&__icon {
		color: #409eff;
		font-size: 18px;
	}

	&__icon--image {
		color: #67c23a;
	}

	&__meta {
		display: flex;
		flex: 1 1 auto;
		min-width: 0;
		flex-direction: column;
	}

	&__name {
		font-size: 13px;
		color: #303133;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	&__sub {
		font-size: 12px;
		color: #909399;
	}

	&__actions {
		flex: 0 0 auto;
	}

	&__remove {
		color: #f56c6c;
	}

	&__empty {
		margin-top: 8px;
		padding: 12px;
		border: 1px dashed #dcdfe6;
		border-radius: 6px;
		color: #909399;
		font-size: 12px;
		text-align: center;
	}
}
</style>
