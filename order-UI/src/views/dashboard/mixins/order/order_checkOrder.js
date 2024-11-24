import { getGoodsOrder } from '../../../../api/system/goodsOrder';
import CheckOrder from '@/views/dashboard/components/goodsOrder/CheckOrder.vue';

/**
 * 行操作点击查看的功能
 */
export var mixin_order_checkOrder = {
  data: function () {
    return {}
  },
  methods: {
    // 行操作中点击查看 查看当前行订单的信息
    checkOrderItemInfo(row) {
      const id = row.id;
      // 读取订单信息
      getGoodsOrder(id).then(res => {
        this.orderInfo = res.data
        this.orderDetailInfo = res.data.orderDetailList;
        // 打开弹窗
        this.openDialog(CheckOrder, '查看订单详情', '1300px', {
          orderInfo: this.orderInfo,
          orderDetailInfo: this.orderDetailInfo
        })
      })
    },
  },
}
