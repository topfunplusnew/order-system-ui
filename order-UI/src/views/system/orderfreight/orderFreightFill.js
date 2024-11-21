// 创建运费 来源
export const FREIGHT_PAYMENT = {
  GOODS_ORDER: 'goodsorder',
  INVENTORY: 'inventory'
}


// 运费的相关填充信息
export var mixin_order_freight_fill = {
  data: function () {
    return {
      queryCompany: '',
      queryCars: '',
      queryFleet: '',
    }
  },
  methods: {
    //己方公司点击确定的回调
    handleCommitBack(val) {
      this.form.otherBankNo = val.bankNo;
      this.form.otherBankName = val.bankName;
      this.form.companyName = val.companyName;
      this.form.companyId = val.id;
      this.form.otherAcountsName = val.acountsName;
      this.form.companyType = val.companyType
    },
    handleCommitBackCars(val) {
      this.form.carNo = val.dictLabel
    },
    updateQueryCars(val) {
      this.queryCars = val;
    },
    //update
    handleUpdateQueryName(val) {
      this.queryCompany = val;
    },
    handleCommitBackFleet(val) {
      this.form.fleet = val.fname;
    },
    updateQueryFleet(val) {
      this.queryFleet = val
    },
  }
}
