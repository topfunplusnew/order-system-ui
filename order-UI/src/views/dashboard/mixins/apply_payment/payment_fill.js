// 付款申请的付款逻辑文件

export var mixin_payment_fill = {
  data: function () {
    return {
      // 对方户名
      queryCompany: '',
    }
  },
  methods: {
    //对方信息 - 点击确认后自动填充
    handleCommitBack(val) {
      this.form.otherBankNo = val.bankNo;
      this.form.otherBankName = val.bankName;
      this.form.otherAcountsName = val.acountsName;
      this.form.companyName = val.companyName;
      this.form.companyId = val.companyId
    },
    handleUpdateQueryName(val) {
      this.queryCompany = val;
    },
  }
}
