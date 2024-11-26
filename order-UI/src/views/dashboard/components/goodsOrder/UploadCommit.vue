<template>
	<el-dialog
		:close-on-click-modal="false"
		:show-close="false"
		title="提示"
		:visible.sync="handleCommitVisible"
		width="450px"
	>
		<el-upload
			class="upload-demo"
			drag
			:action="uploadFileUrl"
			multiple
			show-file-list
			:headers="headers"
			:file-list="fileList"
			:before-upload="beforeUpload"
		>
			<i class="el-icon-upload"></i>
			<div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
			<div slot="tip" class="el-upload__tip">
				只能上传jpg/png文件，且不超过500kb
			</div>
		</el-upload>
		<el-button type="success" @click="submitUploadAllFiles">开始上传</el-button>
		<span slot="footer" class="dialog-footer">
			<el-button @click="close">关 闭</el-button>
		</span>
	</el-dialog>
</template>
<script>
export default {
	name: 'UploadCommit',
	props: {
		beforeUpload: {},
		fileList: {},
		handleCommitVisible: {},
		headers: {},
		submitUploadAllFiles: {},
		uploadFileUrl: {}
	},
	methods: {
		close() {
			this.$emit('close');
		}
	}
};
</script>
<style lang="scss">
.upload-demo {
	width: 100%;
	margin: 0 auto;
}
</style>
