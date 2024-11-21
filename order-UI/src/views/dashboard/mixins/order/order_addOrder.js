import {addReason} from "../../../../api/system/user";
import {TableName} from "../../../../api/tool/enums";
import OrderForm from "@/views/dashboard/components/goodsOrder/OrderForm.vue";

/**
 * 添加或者修改订单的功能
 */
export var mixin_order_add = {
  data: function () {
    return {
      //当前订单id
      orderId: null,
      //添加新订单的弹窗
      orderItemVisible: false,
      orderTitle: '',
      submitInfo: '',
    }
  },
  methods: {
    // 新增按钮操作
    handleAdd() {
      this.reset()
      // 打开弹窗
      this.openDialog(OrderForm, '添加订单', '1300px', {
        orderId: null,
        submitInfo: '添加订单'
      })
    },
    //修改订单的操作
    handleUpdate(row) {
      this.$prompt('请输入编辑订单原因', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(({value}) => {
        addReason({reason: value, tableName: TableName.GOODS_ORDER, tid: row.id, modifyTime: this.modifyTime})
          .then(res => {
            // 先暂存订单修改原因
            sessionStorage.setItem('order-edit-reason', value)
            this.$message.success('提交成功')
            this.reset();
            // 打开弹窗
            this.openDialog(OrderForm, '修改订单', '1300px', {
              orderId: row.id,
              submitInfo: '修改订单'
            })
          })
      }).catch(() => {
        this.$message({
          type: 'warning',
          message: '请先输入编辑原因!'
        });
      });
    },
    // 表单重置
    reset() {
      this.orderInfo = {
        id: null,
        ordersNo: null,
        orderDate: null,
        customer: null,
        customerID: null,
        landCarID: null,
        landCarNo: null,
        landDriverTel: null,
        landDriverName: null,
        seaCarID: null,
        seaCarNo: null,
        seaDriverTel: null,
        seaDriverName: null,
        checkUserId: null,
        checkState: null,
        invoiceState: null,
        path: null,
        PaymentState: null,
        landBankName: null,
        landBankNo: null,
        seaBankName: null,
        seaBankNo: null,
        receiveProof: null,
        saleManager: null,
        fleet: null,
        isAdjusted: null,
        adjustDate: null,
        isAdjust: null,
        adjustOrderid: null,
        isedit: null,
        customerIsInvoice: null,
        isSupplierInvoice: null,
        cancelFlag: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null
      };
      this.resetForm("form");
      //清除vuex的状态
      this.$store.commit('order/CLEAR_ORDER_ITEM_LIST')
      sessionStorage.removeItem('order_id')
    },
  },
}
