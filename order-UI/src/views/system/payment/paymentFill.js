export var mixin_payment_fill = {
  data: function () {
    return {
      // bank搜索
      queryBank: '',
      // 供应商搜索
      queryOtherSupplier: '',
      // 客户搜索
      queryOtherCustomer: '',
      // 司机搜索
      queryOtherDriver: '',
      // 银行卡选择搜索
      queryChoose: '',
    }
  },
  methods: {
    //自动填充己方信息
    handleCommitBack(val) {
      this.form.selfBankName = val.bankName;
      this.form.selfAcountsName = val.acountsName
      this.form.selfBankNo = val.bankNo
    },
    // 填充供应商信息
    handleCommitBackOtherSupplier(val) {
      this.form.otherBankName = val.bankName;
      this.form.otherAcountsName = val.acountsName;
      this.form.otherBankNo = val.bankNo;
      this.form.companyName = val.companyName;
    },
    //自动填充客户信息
    handleCommitBackOther(val) {
      this.form.otherBankName = val.bankName;
      this.form.otherAcountsName = val.acountsName;
      this.form.otherBankNo = val.bankNo;
      this.form.companyName = val.companyName;
    },
    // 补充司机信息
    handleCommitBackOtherCars(val) {
      this.form.otherBankName = val.bankName;
      this.form.otherAcountsName = val.acountsName;
      this.form.otherBankNo = val.bankNo;
      this.form.companyName = val.driver;
    },
    // 选择己方银行卡
    handleCommitBackChoose(val) {
      this.chooseInfo.selfBankName = val.bankName;
      this.chooseInfo.selfAcountsName = val.acountsName
      this.chooseInfo.selfBankNo = val.bankNo
    },
    // 这些方法是组件中的检索字段填充方法
    handleUpdateQueryChoose(val) {
      this.queryChoose = val;
    },
    handleUpdateQueryName(val) {
      this.queryBank = val;
    },
    handleUpdateQueryNameOtherSupplier(val) {
      this.queryOtherSupplier = val;
    },
    handleUpdateQueryNameOtherCustomer(val) {
      this.queryOtherCustomer = val;
    },
    handleUpdateQueryNameOtherDriver(val) {
      this.queryOtherDriver = val;
    },
  }
}
