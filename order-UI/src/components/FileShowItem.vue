<script>
import {getToken} from "../utils/auth";

export default {
  name: "FileShowItem",
  data() {
    return {
      fileList: [],
      baseUrl: process.env.VUE_APP_BASE_API + '/common/upload',
      headers: {
        Authorization: "Bearer " + getToken(),
      },
      progress: null,
      text: '点击上传',
    }
  },
  watch: {
    'progress': {
      handler(val) {
        console.log(val)
      }
    }
  },
  methods: {
    handleUpload({file, onSuccess, onError, onProgress}) {
      this.progress = null;
      const formData = new FormData();
      formData.append('file', file);

      // 使用 axios 发起上传请求
      axios.post(this.baseUrl, formData, {
        headers: this.headers,
        onUploadProgress: (progressEvent) => {
          if (progressEvent.lengthComputable) {
            // 计算上传进度并传递给 onProgress 回调
            const progress = Math.round((progressEvent.loaded / progressEvent.total) * 100);
            onProgress({percent: progress});
          }
        }
        // 文件上传成功
      }).then((response) => {
        this.text = '继续上传'
        this.$refs.upload.clearFiles()
        // 上传成功 通知父组件修改状态
        this.$emit('handleFile', response.data.fileName)
        // 文件上传失败
      }).catch(err => {
        onError(err);
      })
    },
    // 处理上传进度
    handleProgress(event) {
      this.progress = event.percent;  // 更新进度
    },

  },
};
</script>

<template>
  <div>
    <div class="file-container">
      <div class="file-icon">
        <el-icon class="el-icon-plus">
        </el-icon>
      </div>
      <div class="file-name">
        <el-upload
          ref="upload"
          class="upload-demo"
          :action="baseUrl"
          :headers="headers"
          :show-file-list="false"
          multiple
          :http-request="handleUpload"
          :limit="1"
          :file-list="fileList"
          :on-progress="handleProgress">
          <el-button size="small" type="text">{{ text }}</el-button>
        </el-upload>
      </div>

      <!-- 自定义的上传进度显示 -->
      <div v-if="progress !== null" class="upload-progress-container">
        <div
          class="progress-bar"
          :style="{ width: progress + '%'}">
        </div>
        <span>{{ progress }}%</span>
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
</style>
