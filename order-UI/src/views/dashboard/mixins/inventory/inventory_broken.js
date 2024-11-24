import { parseTime } from '../../../../utils/ruoyi';

export var mixin_inventory_broken = {
  data: function () {
    return {
      // 货物破损
      breakNumber: 0,
      breakInvoiceInVisible: false,
      breakInfo: {},
    }
  },
  methods: {
    // 货物破损出库
    afterbreakInventoryOut(row) {
      this.breakInfo = {
        ordersNo: '货物破损',
        storeHouseid: row.storeHouseid,
        storeHouseName: row.storeHouseName,
        storeID: row.id,
        outDate: parseTime(new Date())
      };
      this.breakInvoiceInVisible = true
    },
    // 提交货物破损出库
    submitBreakInvoiceIn() {
      this.breakInfo.outAmount = this.breakNumber
      addExWarehouse(this.breakInfo).then(res => {
        this.$message.success('货物破损出库成功~')
      })
      this.breakInvoiceInVisible = false
    },
  }
}
