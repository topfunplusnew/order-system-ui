export var mixin_record_fill = {
  data() {
    return {
      // 收入方与支付方 只做展示
      sourceName: '',
      targetName: '',

      // 查询字段
      querySupplier: '',
      queryCustomer: '',
      queryInvoice: '',

      // 选择客户或者供应商的相关信息
      queryCompanyName: '',
    }
  },
  methods: {
    // 上传的回调函数
    handleCommitUpload(val) {
      this.form.attachment = val;
    },
    // 需求:  客户张三欠我1万，我欠供应商李四一万。我现在让张三直接把这一万给李四了
    // 我记账收入客户张三1万，支出供应商李四一万。他是一笔账
    // 客户供应商的搜索
    updateQuerySupplier(val) {
      this.querySupplier = val;
    },
    updateQueryCustomer(val) {
      this.queryCustomer = val;
    },
    // 收入方的自动填充 填充id即可
    handleCommitCompanySupplier(val) {
      this.form.sourceId = val.id;
      // 修改 应该填充的是银行账户名称
      this.sourceName = val.acountsName;
    },
    // 支出方的自动填充
    handleCommitCompanyCustomer(val) {
      this.targetName = val.acountsName;
      this.form.targetId = val.id;
    },
    // 以下是新增 填充方法 2024/11/7 现金记账改为冲抵款 合并冲抵货款
    // 选择客户或者供应商的回调
    handleUpdateCompanyNameGet(val) {
      this.queryCompanyName = val;
    },
    handleCommitBackCompanyGet(val) {
      // 填充展示字段
      this.sourceName = val.companyName;
      // 填充业务字段
      this.form.sourceId = val.id;
    },
    handleUpdateCompanyNamePay(val) {
      this.queryCompanyName = val;
    },
    handleCommitBackCompanyPay(val) {
      // 填充展示字段
      this.targetName = val.companyName;
      // 填充业务字段
      this.form.targetId = val.id;
    },
  }
}
