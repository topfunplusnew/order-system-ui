// 运费一键申请
import {DocumentNumber} from "../../../../api/tool/enums";

export var mixin_credentials_generation_orderlist = {
  data: function () {
    return {
      // 票据生成的弹窗
      dialogVisible: false,
    }
  },
  // 监听选择的单据类型 如果是订单，那么就显示订单列表 选择生成单据
  watch: {
    type: {
      handler(val) {
        if (val === DocumentNumber.GOODS_ORDER) {
          this.dialogVisible = true
        }
      },
      deep: true,
    },
  },
  methods: {
    // 生成凭证
    makeCredentials() {

    }
  },
}
