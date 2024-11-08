export var mixin_receive_money_fill = {
  data: function () {
    return {
      // 客户银行卡搜索
      queryCustomerBank: '',

      // 对方公司
      companyName: '',
      carName: '',

      // 对方公司类型
      options: [{
        value: '客户',
        label: '客户'
      }, {
        value: '供应商',
        label: '供应商'
      }, {
        value: '司机',
        label: '司机'
      }],
      value: '客户'
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
    handleUpdateCarName(val) {
      this.carName = val;
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
    },
    // 填充司机的信息 如果选择的对方类型是司机的话
    handleCommitBackCar(val) {
      // 填充司机基本信息
      this.form.companyName = val.driver;
      this.form.companyId = val.id;
      // 司机这里给的是3
      this.form.companyType = 3;

      // 填充银行卡数据 这里不填充了  因为司机和银行卡不强关联 自己选择
      // this.form.otherAcountsName = val.acountsName;
      // this.form.otherBankNo = val.bankNo;
      // this.form.otherBankName = val.bankName;
    },
  }
}
