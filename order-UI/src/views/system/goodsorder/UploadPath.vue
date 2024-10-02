<template>
  <el-dialog
      title="上传附件"
      :visible.sync="handleUploadVisible"
      width="450px">
    <el-row>
      <el-col :span="12" :offset="2">
        <el-upload
            class="upload-demo"
            drag
            :action="uploadFileUrl"
            multiple
            show-file-list
            :headers="headers"
            :file-list="fileList"
            :before-upload="beforeUpload">
          <i class="el-icon-upload"></i>
          <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
          <div class="el-upload__tip" slot="tip">只能上传jpg/png文件，且不超过500kb</div>
        </el-upload>
        <el-button type="success" @click="submitUploadAllFiles">开始上传</el-button>
      </el-col>
    </el-row>
    <span slot="footer" class="dialog-footer">
    <el-button @click="handleUploadVisible = false">取 消</el-button>
    <el-button type="primary" @click="handleUploadVisible = false">确 定</el-button>
  </span>
  </el-dialog>
</template>
<script>
export default {
  name: 'UploadPath',
  props: {
    beforeUpload: {},
    fileList: {},
    handleUploadVisible: {},
    headers: {},
    submitUploadAllFiles: {},
    uploadFileUrl: {}
  }
}
</script>
<style lang="scss">
.upload-demo {
  width: 100%;
  margin: 0 auto;
}

</style>