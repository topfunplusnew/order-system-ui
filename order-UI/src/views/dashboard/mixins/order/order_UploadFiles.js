import axios from "axios";
import {getGoodsOrder, updateGoodsOrder} from "../../../../api/system/goodsOrder";
import {getToken} from "../../../../utils/auth";
import {excludeParams} from "../../../../api/tool/exclude";

/**
 *  点击上传附件 上传附件功能 查看附件功能
 */
export var mixin_order_uploadFiles = {
  data: function () {
    return {
      //上传和收到条
      handleUploadVisible: false,
      handleCommitVisible: false,
      //上传附件临时保存当前点击订单信息
      tempOrderInfo: {
        receiveProof: ''
      },
      fileList: [],
      // 已上传后的文件名称列表
      fileNamesList: [],
      // 查看附件或者收到条的文件列表
      checkFileList: [],
      checkAttachmentVisible: false,
      //上传路径
      uploadFileUrl: process.env.VUE_APP_BASE_API + "/common/upload",
      headers: {
        Authorization: "Bearer " + getToken(),
      },
    }
  },
  methods: {
    //查看附件信息
    checkAttachment(row, type) {
      if (type === 'path') {
        getGoodsOrder(row.id).then(res => {
          this.checkFileList = res.data.path.split('|');
          this.checkAttachmentVisible = true;
        })
      } else {
        getGoodsOrder(row.id).then(res => {
          this.checkFileList = res.data.receiveProof.split('|');
          this.checkAttachmentVisible = true;
        })
      }
    },
    // 上传附件
    handleUpload(row) {
      this.handleUploadVisible = true
      //保存当前订单信息 现根据当前订单列表信息查询详细订单信息
      getGoodsOrder(row.id).then(res => {
        this.tempOrderInfo = res.data;
      })
    },
    handleCommit(row) {
      this.handleCommitVisible = true
      //点击收到条的时候查询当前订单详细信息
      getGoodsOrder(row.id).then(res => {
        this.tempOrderInfo = res.data;
      })
    },
    // 上传之前的钩子函数
    beforeUpload(file) {
      // 如果文件名超出20个字符那么就提示
      if (file.name.length > 20) {
        this.$message.error('文件名不能超过20个字符,请重命名后上传')
        return false
      }
      // 文件中不能包含 "|" 字符
      if (file.name.indexOf('|') !== -1) {
        this.$message.error('文件名不能包含"|"字符')
        return false
      }
      // 列表中最多五个文件
      if (this.fileList.length >= 5) {
        this.$message.error('最多只能上传5个文件')
        return false
      }
      // 推入数组中 后续点击开始上传的时候 ，对数组的每一个文件进行上传
      this.fileList.push(file)
      // 阻止默认上传行为
      return false
    },

    // 点击开始上传 type是上传的类型
    async submitUploadAllFiles(type) {
      // 开始批量发请求 上传文件 上传完毕的文件会返回一个fileName 只要把上传后的fileName推入到已上传的列表
      for (let i = 0; i < this.fileList.length; i++) {
        const file = this.fileList[i];
        // 点击上传的时候 要推入到上传数组中
        const formData = new FormData();
        formData.append('file', file)
        try {
          // 调用上传接口
          const response = await axios.post(process.env.VUE_APP_BASE_API + '/common/upload', formData, {
            headers: {
              ...this.headers,
              'Content-Type': 'multipart/form-data'
            }
          })
          this.fileList.splice(i, 1);
          i--;
          // 等待
          await this.sleep(1500);
          if (response.data.code === 200) {
            this.fileNamesList.push(response.data.fileName)
          } else {
            this.$message.error(response.data.msg)
          }

        } catch (e) {
          console.error(`第${this.fileList.indexOf(file) + 1}个文件上传失败:`, e);
        }
      }
      // 全部上传完事后 修改订单的附件
      this.tempOrderInfo = excludeParams(this.tempOrderInfo, this.$exclude)
      const path = this.fileNamesList.join('|')
      if (type === 'path') {
        //修改订单信息
        updateGoodsOrder({...this.tempOrderInfo, path: path})
          .then(res => {
            this.$message.success('保存成功')
            this.getList()
          })
        // 收到条
      } else if (type === 'receiveProof') {
        //修改订单信息
        updateGoodsOrder({...this.tempOrderInfo, receiveProof: path})
          .then(res => {
            this.$message.success('保存成功')
            this.getList()
          })
      }
    },
    // 关闭上传附件的弹窗
    closeUploadPathDialog() {
      this.handleUploadVisible = false
    },
    // 关闭上传收到条的弹窗
    closeUploadCommitDialog() {
      this.handleCommitVisible = false
    },
  },
}
