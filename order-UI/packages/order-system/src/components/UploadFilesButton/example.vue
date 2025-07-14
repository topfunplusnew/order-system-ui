<!-- 使用示例 - 更新后的布局 -->
<template>
	<div style="padding: 20px">
		<h3>UploadFilesButton 组件示例</h3>

		<!-- 基本使用 -->
		<div style="margin: 20px 0">
			<label>基本使用：</label>
			<UploadFilesButton @files-updated="handleFilesUpdated" ref="uploadButton" />
		</div>

		<!-- 自定义配置 -->
		<div style="margin: 20px 0">
			<label>自定义配置：</label>
			<UploadFilesButton
				:max-files="5"
				:max-file-size="20"
				accept-types="image/*,.pdf,.doc,.docx"
				flag="customFlag"
				:extra-info="{ moduleId: 123, type: 'payment' }"
				@files-updated="handleFilesUpdated"
				ref="uploadButtonCustom"
			/>
		</div>

		<!-- 表单中使用 -->
		<div style="margin: 20px 0">
			<el-form :model="form" label-width="120px">
				<el-form-item label="订单号：">
					<el-input v-model="form.orderNo" style="width: 200px"></el-input>
				</el-form-item>
				<el-form-item label="附件上传：">
					<UploadFilesButton @files-updated="handleFilesUpdated" ref="formUploadButton" />
				</el-form-item>
			</el-form>
		</div>

		<!-- 操作按钮 -->
		<div style="margin: 20px 0">
			<el-button @click="getCurrentParams">获取当前参数</el-button>
			<el-button @click="clearFiles">清空文件</el-button>
			<el-button @click="showCurrentData">显示当前数据</el-button>
		</div>

		<!-- 显示当前数据 -->
		<div v-if="currentParams" style="margin: 20px 0; padding: 16px; background: #f5f7fa; border-radius: 4px">
			<h4>当前文件参数：</h4>
			<pre>{{ JSON.stringify(currentParams, null, 2) }}</pre>
		</div>
	</div>
</template>

<script>
import UploadFilesButton from './index.vue';

export default {
	name: 'ExampleUsage',
	components: {
		UploadFilesButton
	},
	data() {
		return {
			currentParams: null,
			form: {
				orderNo: 'ORD20250713001'
			}
		};
	},
	methods: {
		// 处理文件更新事件
		handleFilesUpdated(params) {
			console.log('文件参数更新:', params);
			this.currentParams = params;

			// 将附件参数合并到表单数据中
			this.form = { ...this.form, ...params };

			this.$message.success(`文件列表已更新，当前有 ${params.params.attachmentIds.length} 个文件`);
		},

		// 获取当前上传参数
		getCurrentParams() {
			const params = this.$refs.uploadButton.getUploadParams();
			console.log('当前参数:', params);
			this.$message.info(`当前有 ${params.params.attachmentIds.length} 个文件`);
		},

		// 清空文件（比如在表单关闭时调用）
		clearFiles() {
			this.$refs.uploadButton.clearUploadedFiles();
			this.$refs.uploadButtonCustom.clearUploadedFiles();
			this.$refs.formUploadButton.clearUploadedFiles();
			this.currentParams = null;
			this.form = { orderNo: 'ORD20250713001' };
			this.$message.success('已清空所有文件');
		},

		// 显示当前表单数据
		showCurrentData() {
			this.$alert(JSON.stringify(this.form, null, 2), '当前表单数据', {
				confirmButtonText: '确定'
			});
		}
	}
};
</script>

<style scoped>
label {
	display: inline-block;
	width: 120px;
	font-weight: bold;
	margin-right: 10px;
}

.el-form-item {
	margin-bottom: 20px;
}

pre {
	background: #ffffff;
	padding: 12px;
	border-radius: 4px;
	border: 1px solid #e4e7ed;
	font-size: 12px;
	line-height: 1.4;
}
</style>
