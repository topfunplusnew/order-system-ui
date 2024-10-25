export var mixin_record_fill = {
  data() {
    return {
      // 查询字段
      querySupplier: '',
      queryCustomer: '',
      queryInvoice: '',
    }
  },
  methods: {
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
      this.form.supplierId = val.id;
      this.supplierName = val.companyName;
    },
    handleCommitCompanyCustomer(val) {
      this.form.customerId = val.id;
      this.customerName = val.companyName;
    },
    // 开票号码绑定
    handleCommitInvoiceOther(val) {
      this.form.referenceTableId = val.id;
    },
  }
}
