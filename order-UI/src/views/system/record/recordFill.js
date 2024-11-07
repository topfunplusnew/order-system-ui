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
    updateQueryInvoice(val) {
      this.queryInvoice = val;
    },
    // 供应商的自动填充 填充id即可
    handleCommitCompanySupplier(val) {
      this.form.sourceId = val.id;
      this.sourceName = val.companyName;
    },
    handleCommitCompanyCustomer(val) {
      this.form.targetId = val.id;
      this.targetName = val.companyName;
    },
    // 开票号码绑定
    handleCommitInvoiceOther(val) {
      this.form.referenceTableId = val.id;
      // 填充客户和供应商的信息
      // 来源方
      this.sourceName = val.customer;
      this.form.sourceId = val.customerID;
      this.form.sourceCompanyType = '客户';
      // 去方
      this.targetName = val.supplier;
      this.form.targetId = val.supplierID;
      this.form.targetCompanyType = '供应商';
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
