export var mixin_lend_money_fill = {
  data: function () {
    return {
      queryBank: '',
    }
  },
  methods: {
    // 收回资金的搜索按钮自动填充方法
    handleUpdateQueryBankAcountForm(val) {
      this.queryBank = val;
    },
    handleCommitBack(val) {
      this.form.targetBankNo = val.bankNo;
      this.form.targetBankName = val.bankName;
      this.form.targetAcountsName = val.acountsName;
    },
    handleUpdateQueryName(val) {
      this.queryBank = val;
    },
    handleCommitBackSelf(val) {
      this.form.selfBankNo = val.bankNo;
      this.form.selfBankName = val.bankName;
      this.form.selfAcountsName = val.acountsName;
    },
  }
}
