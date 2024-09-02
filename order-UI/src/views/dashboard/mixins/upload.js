import {findFileExtension} from "@/utils/trash/utils";

export var mixin_upload = {
  data: function () {
    return {
      isImg: false
    }
  },
  methods: {
    handleFileUpload(url) {
      //删除文件 图片删除
      if (url === null || url === '') {
        this.isImg = false
        return false;
      }
      this.form.attachmentPath = url;
      //如果是图片
      if (this.$imgs.includes(findFileExtension(url))) {
        this.isImg = true;
        return true;
      }
    },
  }
}
