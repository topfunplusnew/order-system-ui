<!--文件列表组件-->

<script>
export default {
	name: 'FileItems',
	// 动态引入
	components: {
		ExcelIcon: () => import('@/views/dashboard/components/icons/ExcelIcon.vue'),
		WordIcon: () => import('@/views/dashboard/components/icons/WordIcon.vue'),
		ImgIcon: () => import('@/views/dashboard/components/icons/ImgIcon.vue'),
		FileIcon: () => import('@/views/dashboard/components/icons/FileIcon.vue'),
		PowerIcon: () => import('@/views/dashboard/components/icons/PowerIcon.vue'),
		TextIcon: () => import('@/views/dashboard/components/icons/TextIcon.vue')
	},
	props: {
		fileName: {
			type: String,
			default: '无名称'
		}
	},
	data() {
		return {};
	},
	computed: {
		_fileName() {
			return this.fileName;
		},
		currentIcon() {
			// 文件后缀与组件的映射关系
			const iconMap = {
				'.doc': 'WordIcon',
				'.docx': 'WordIcon',
				'.xls': 'ExcelIcon',
				'.xlsx': 'ExcelIcon',
				'.pdf': 'PowerIcon',
				'.txt': 'TextIcon'
			};

			// 提取文件后缀
			const fileExt = this._fileName
				.slice(this._fileName.lastIndexOf('.'))
				.toLowerCase();

			// 根据后缀查找对应组件
			return iconMap[fileExt] || 'FileIcon';
		}
	},
	methods: {
		// 点击某一个文件
		handleCheckFile(item) {
			window.open(item);
		},

		// 点击删除文件
		handleDeleteFile() {
			this.$emit('handleFile', this.fileName);
		}
	}
};
</script>

<template>
	<div>
		<div class="file-container">
			<div class="delete">
				<el-button
					type="danger"
					size="mini"
					circle
					icon="el-icon-close"
					round
					@click="handleDeleteFile"
				>
				</el-button>
			</div>
			<div class="file-icon">
				<component :is="currentIcon" v-if="currentIcon"></component>
				<div class="file-name" @click="handleCheckFile(fileName)">
					{{ _fileName }}...
				</div>
			</div>
		</div>
	</div>
</template>

<style scoped lang="scss">
.file-container {
	position: relative;
	margin: 4px 4px;
	width: 98px;
	height: 98px;
	background-color: #f7f2f8;
	border-radius: 15px;
	display: flex;
	justify-content: center;
	flex-direction: column;
	box-shadow: 0px 0px 5px 0px rgba(0, 0, 0, 0.25);
	text-align: center;

	&:hover {
		cursor: pointer;
		background-color: #e6e6e6;
		transition: all 0.7s ease-in-out;
		box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.45);
	}

	.file-icon {
		font-size: 27px;
		color: #171717;
	}

	.file-name {
		text-align: center;
		font-weight: bold;
		font-size: 14px;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}

	.file-name:hover {
		transition: all 0.3s ease-in-out;
		color: #c31212;
	}

	.delete {
		position: absolute;
		right: 5px;
		top: 5px;
	}
}
</style>
