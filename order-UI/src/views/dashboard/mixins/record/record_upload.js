import { getToken } from "../../../../utils/auth";
import axios from "axios";
import { getRecord } from "../../../../api/system/record";
// 现金记账的上传功能
export var mixin_record_uploadFiles = {
  data: function () {
    return {
      fileList: [],
      fileNamesList: [],
      checkFileList: [],
      uploadFileUrl: process.env.VUE_APP_BASE_API + "/common/upload",
      headers: {
        Authorization: "Bearer " + getToken(),
      },
      checkAttachmentVisible: false,
    };
  },
  methods: {
    //查看附件信息
    checkAttachment(row) {
      getRecord(row.id).then((res) => {
        this.checkFileList = res.data.attachment.split("|");
        this.checkAttachmentVisible = true;
      });
    },
    // 上传之前的钩子函数
    beforeUpload(file) {
      // 如果文件名超出20个字符那么就提示
      if (file.name.length > 20) {
        this.$message.error("文件名不能超过20个字符,请重命名后上传");
        return false;
      }
      // 文件中不能包含 "|" 字符
      if (file.name.indexOf("|") !== -1) {
        this.$message.error('文件名不能包含"|"字符');
        return false;
      }
      // 列表中最多五个文件
      if (this.fileList.length >= 5) {
        this.$message.error("最多只能上传5个文件");
        return false;
      }
      // 推入数组中 后续点击开始上传的时候 ，对数组的每一个文件进行上传
      this.fileList.push(file);
      // 阻止默认上传行为
      return false;
    },
    async submitUploadAllFiles() {
      await this.uploadAllFilesAsync();
      this.$message.success("保存成功");
      this.form.attachment = this.fileNamesList.join("|");
    },
    async uploadAllFilesAsync() {
      // 开始批量发请求 上传文件 上传完毕的文件会返回一个fileName 只要把上传后的fileName推入到已上传的列表
      for (let i = 0; i < this.fileList.length; i++) {
        const file = this.fileList[i];
        // 点击上传的时候 要推入到上传数组中
        const formData = new FormData();
        formData.append("file", file);
        try {
          // 调用上传接口
          const response = await axios.post(
            process.env.VUE_APP_BASE_API + "/common/upload",
            formData,
            {
              headers: {
                ...this.headers,
                "Content-Type": "multipart/form-data",
              },
            }
          );
          // 删除
          this.fileList.splice(i, 1);
          i--;
          // 等待
          await this.sleep(1500);
          if (response.data.code === 200) {
            // 推入要上传的文件列表
            this.fileNamesList.push(response.data.fileName);
          } else {
            this.$message.error(response.data.msg);
          }
        } catch (e) {
          this.$message.error(
            `第${this.fileList.indexOf(file) + 1}个文件上传失败:`
          );
        }
      }
    },
    // 查看某一个文件
    checkFileItem(item) {
      window.open(item);
    },
    // 休眠函数
    sleep(ms) {
      return new Promise((resolve) => setTimeout(resolve, ms));
    },
  },
};
