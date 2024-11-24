export var mixin_oil_recharge_fill = {
  data: function () {
    return {
      queryOilCard: '',
      queryBank: ''
    }
  },
  methods: {
    // 主卡
    handleCommitBackOilCard(val) {
      this.form.oilCardNo = val.oilCardNo;
    },
    handleCommitBackQueryOilCard(val) {
      this.queryOilCard = val;
    },
    // 银行卡
    handleCommitBackBank(val) {
      this.form.acountsName = val.acountsName;
      this.form.bankNo = val.bankNo;
    },
    handleCommitBackQueryBank(val) {
      this.queryBank = val
    },
  }
}
