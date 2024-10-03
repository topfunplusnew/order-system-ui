import {getCompany} from "../../../../api/system/company";
import {addInvoiceIn} from "../../../../api/system/invoiceIn";
import {excludeParams} from "../../../../api/tool/exclude";
import {addInvoiceOut} from "../../../../api/system/invoiceOut";
import {getGoodsOrder} from "../../../../api/system/goodsOrder";

/**
 * 客户或者供应商发票功能
 */
export var mixin_order_Invoice = {
    data: function () {
        return {
            // 查询字段
            queryCompanyName: '',
            // 开票选择
            options: [
                {
                    value: '已审核',
                    label: '已审核'
                }, {
                    value: '未审核',
                    label: '未审核'
                },
            ],
            optionsInvoice: [{
                value: '未开票',
                label: '未开票'
            }, {
                value: '部分开票',
                label: '部分开票'
            }, {
                value: '已开票',
                label: '已开票'
            },],
            //开票信息
            updateOrderItemVisibleTitleInfo: {},
            // 开票信息校验
            CheckRules: {
                updateOrderItemVisibleTitleRules: {
                    invoiceDate: [
                        {required: true, message: '请选择开票日期', trigger: 'blur'}
                    ],
                    invoiceObject: [
                        {required: true, message: '请输入开票实体', trigger: 'blur'}
                    ],
                    invoiceCompanyName: [
                        {required: true, message: '请输入票据单位名称', trigger: 'blur'}
                    ],
                    invoiceAmount: [
                        {required: true, message: '请输入开票金额', trigger: 'blur'},
                        // 开票金额 可以是小数
                        {pattern: /^-?[0-9]+(\.[0-9]+)?$/, message: '只能输入数字和小数', trigger: 'blur'}
                    ],
                    companyName: [
                        {required: true, message: '请输入公司名称', trigger: 'blur'}],
                    // 只能是数字
                    ticketPoint: [
                        {required: true, message: '请输入开票点', trigger: 'blur'},
                        {pattern: /^-?[0-9]+(\.[0-9]+)?$/, message: '只能输入数字', trigger: 'blur'}
                    ],
                    ticketPointAmount: [
                        {required: true, message: '请输入开票点金额', trigger: 'blur'},
                        {pattern: /^-?[0-9]+(\.[0-9]+)?$/, message: '只能输入数字', trigger: 'blur'}],
                }
            },

            invoiceupdateOrderItemVisibleVisible: false,
            updateOrderItemVisibleTitle: '',
        }
    },
    methods: {
        // 点击客户开票
        updateOrderItemVisibleCustomerInvoice(row) {
            this.resetOpenTitleInfo()
            //客户开发票 即为发票卖出 添加发票卖出信息 1客户开票  2供应商开票
            this.updateOrderItemVisibleTitleInfo.domain = 1
            this.updateOrderItemVisibleTitleInfo.isOrderTax = row.id;
            this.updateOrderItemVisibleTitle = '客户开票'
            //设置该订单信息 需要进行一次查询 获取订单的开票个数
            getGoodsOrder(row.id)
                .then(res => {
                    this.updateOrderItemVisibleTitleInfo.orderInfo = res.data;
                    // 保存客户和供应商开票个数
                    this.updateOrderItemVisibleTitleInfo.customerInvoiceNumber = res.data.customerIsInvoice
                    this.updateOrderItemVisibleTitleInfo.supplierInvoiceNumber = res.data.isSupplierInvoice
                    this.invoiceupdateOrderItemVisibleVisible = true;
                })
        },
        // 点击供应商开票
        updateOrderItemVisibleSupplierInvoice(row, supplierID) {
            this.resetOpenTitleInfo()
            // 如果供应商ID存在 那么就自动填充供应商的信息
            if (supplierID !== undefined && supplierID !== '' && supplierID !== null) {
                this.updateOrderItemVisibleTitleInfo.domain = 2
                this.updateOrderItemVisibleTitleInfo.companyID = supplierID;
                this.updateOrderItemVisibleTitleInfo.isOrderTax = row.id;
                // 先获取公司信息
                getCompany(supplierID).then(res => {
                    this.updateOrderItemVisibleTitleInfo.companyName = res.data.companyName;
                    this.updateOrderItemVisibleTitleInfo.companyType = res.data.companyType;
                    this.updateOrderItemVisibleTitle = '供应商开票'
                    // 获取订单信息
                    getGoodsOrder(row.id)
                        .then(res => {
                            this.updateOrderItemVisibleTitleInfo.orderInfo = res.data;
                            // 保存客户和供应商开票个数
                            this.updateOrderItemVisibleTitleInfo.customerInvoiceNumber = res.data.customerIsInvoice
                            this.updateOrderItemVisibleTitleInfo.supplierInvoiceNumber = res.data.isSupplierInvoice
                            this.invoiceupdateOrderItemVisibleVisible = true;
                        })
                })
            } else {
                this.updateOrderItemVisibleTitleInfo.domain = 2
                this.updateOrderItemVisibleTitleInfo.isOrderTax = row.id;
                this.updateOrderItemVisibleTitleInfo.isOrderTax = row.id;
                this.updateOrderItemVisibleTitle = '供应商开票'
                getGoodsOrder(row.id)
                    .then(res => {
                        this.updateOrderItemVisibleTitleInfo.orderInfo = res.data;
                        // 保存客户和供应商开票个数
                        this.updateOrderItemVisibleTitleInfo.customerInvoiceNumber = res.data.customerIsInvoice
                        this.updateOrderItemVisibleTitleInfo.supplierInvoiceNumber = res.data.isSupplierInvoice
                        this.invoiceupdateOrderItemVisibleVisible = true;
                    })
            }
        },
        // 客户供应商开票功能
        submitupdateOrderItemVisibleTitle() {
            //排除不必要的字段
            this.updateOrderItemVisibleTitleInfo = excludeParams(this.updateOrderItemVisibleTitleInfo, this.$exclude)
            // 拿到开票个数
            const invoiceNumber = {
                customerInvoiceNumber: this.updateOrderItemVisibleTitleInfo.customerInvoiceNumber,
                supplierInvoiceNumber: this.updateOrderItemVisibleTitleInfo.supplierInvoiceNumber
            }
            //这里要判断一下 如果是客户开票 就添加发票卖出信息 如果是供应商开票 则添加发票买入信息
            if (this.updateOrderItemVisibleTitleInfo.domain === 1) {
                //客户开票 添加发票卖出信息
                addInvoiceOut(this.updateOrderItemVisibleTitleInfo)
                    .then(res => {
                        this.$message.success('客户开票成功~')
                        this.invoiceupdateOrderItemVisibleVisible = false;
                        this.resetOpenTitleInfo();
                        this.getList();
                        // this.updateGoodsOrderAfterOpen(invoiceNumber, this.updateOrderItemVisibleTitleInfo.domain)
                    })
            } else {
                // 客户开票
                addInvoiceIn(this.updateOrderItemVisibleTitleInfo)
                    .then(res => {
                        this.$message.success('供应商开票成功~')
                        this.invoiceupdateOrderItemVisibleVisible = false;
                        this.resetOpenTitleInfo();
                        this.getList();
                        // this.updateGoodsOrderAfterOpen(invoiceNumber, this.updateOrderItemVisibleTitleInfo.domain)
                    })
            }
        },
        // 根据类型来更新订单的开票状态
        // updateGoodsOrderAfterOpen(invoiceNumber, type) {
        //   const updateInvoiceState = (invoiceField, invoiceValue, state) => {
        //     let info = {
        //       ...this.updateOrderItemVisibleTitleInfo.orderInfo,
        //       [invoiceField]: invoiceValue,
        //       invoiceState: state
        //     };
        //     // 更新订单的开票状态
        //     updateGoodsOrder(excludeParams(info, this.$exclude))
        //         .then(res => {
        //           this.$message.success('开票状态设置成功~');
        //           this.invoiceupdateOrderItemVisibleVisible = false;
        //           this.resetOpenTitleInfo();
        //           this.getList();
        //         });
        //   };
        //   if (type === 0) { // 供应商开票
        //     if (invoiceNumber.customerInvoiceNumber === 0) {
        //       updateInvoiceState('isSupplierInvoice', invoiceNumber.supplierInvoiceNumber + 1, '部分开票');
        //     } else {
        //       updateInvoiceState('isSupplierInvoice', invoiceNumber.supplierInvoiceNumber + 1, '已开票');
        //     }
        //   } else { // 客户开票
        //     if (invoiceNumber.supplierInvoiceNumber === 0) {
        //       updateInvoiceState('customerIsInvoice', invoiceNumber.customerInvoiceNumber + 1, '部分开票');
        //     } else {
        //       updateInvoiceState('customerIsInvoice', invoiceNumber.customerInvoiceNumber + 1, '已开票');
        //     }
        //   }
        // },
        // 开票信息弹窗的搜索信息自动填充
        handleUpdateCompanyName(val) {
            this.queryCompanyName = val;
        },
        handleCommitBackCompany(val) {
            this.updateOrderItemVisibleTitleInfo.companyName = val.companyName;
            this.updateOrderItemVisibleTitleInfo.companyID = val.id;
            this.updateOrderItemVisibleTitleInfo.companyType = val.companyType;
        },
        // 关闭开票的弹窗
        handleCloseInvoice() {
            this.invoiceupdateOrderItemVisibleVisible = false
        },
        // 开票信息重置
        resetOpenTitleInfo() {
            this.updateOrderItemVisibleTitleInfo = {
                id: null,
                invoiceDate: null,
                invoiceObject: '',
                invoiceAmount: '',
                companyType: '',
                companyName: '',
                companyID: '',
                invoiceCompanyName: '',
                ticketPoint: null,
                ticketPointAmount: null,
                isOrderTax: 0,
                comments: '',
            }
        },
    },
}
