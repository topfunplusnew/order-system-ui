export var mixin_receive_money_fill = {
  data: function () {
    return {
      // 客户银行卡搜索
      queryCustomerBank: '',

      // 对方公司
      companyName: '',
    }
  },
  methods: {
    // 对方账号的自动填充
    handleUpdateQueryNameCustomer(val) {
      this.queryCustomerBank = val;
    },
    //对方账号的自动填充
    handleCallBackCompany(val) {
      this.form.otherAcountsName = val.acountsName;
      this.form.otherBankNo = val.bankNo;
      this.form.otherBankName = val.bankName;
    },
    //己方信息 点击确认的回调函数 点击后自动补充相关字段
    handleCallBack(val) {
      this.form.selfAcountsName = val.acountsName
      this.form.selfBankNo = val.bankNo;
      this.form.selfBankName = val.bankName
      this.form.selfBankID = val.id;
    },
    //银行卡输入搜索信息
    handleCommitBackBank(val) {
      this.bankQuery = val;
    },

    // 对方公司信息的自动填充
    handleUpdateCompanyName(val) {
      this.companyName = val;
    },
    handleCommitBackCompany(val) {
      this.form.companyName = val.companyName
      this.form.companyId = val.id
      this.form.companyType = val.companyType === '供应商' ? 2 : 1;
    }
  }
}
