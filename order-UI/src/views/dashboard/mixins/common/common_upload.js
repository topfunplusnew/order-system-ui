import { getToken } from '../../../../utils/auth';

export var mixin_common_upload = {
  data: function () {
    return {
      baseUrl: process.env.VUE_APP_BASE_API,
      // 上传文件路径
      uploadPath: process.env.VUE_APP_BASE_API + '/common/upload',
      headers: {
        Authorization: 'Bearer ' + getToken(),
      },
    }
  },
  methods: {
    commonUploadFile(file) {
      console.log(file)
    }
  }
}
