// 运费一键申请
import {DocumentNumber} from "../../../../api/tool/enums";
import {parseTime} from "../../../../utils/ruoyi";
import {mapGetters} from "vuex";
import {listGoodsOrder} from "../../../../api/system/goodsOrder";

export var mixin_credentials_generation_orderlist = {
  data: function () {
    return {
      // 订单票据生成的弹窗
      orderDialogVisible: false,
      // 选中的要生成的订单列表
      selectedNeedOrderList: [],
      needToMakeList: [],
      // 检查订单的页面
      CheckDialogVisible: false,
      // 票据类型 用于区分票据生成
      DOC_TYPE: '',
    }
  },
  computed: {
    ...mapGetters(['trueName'])
  },
  // 监听选择的单据类型 如果是订单，那么就显示订单列表 选择生成单据
  watch: {
    type: {
      handler(val) {
        // 赋值类型 根据这个类型来决定渲染哪一个组件
        this.DOC_TYPE = val;
        this.$message.info('type:' + this.DOC_TYPE)
        this.orderDialogVisible = true
      },
      deep: true,
    },
  },
  methods: {
    // 生成凭证
    makeCredentials() {
      this.CheckDialogVisible = true
    },
    // 订单确认生成凭证 分两类 一种是订单的运费 总货款 出厂贷款的凭证生成  一种是票点的 包含 买入 卖出 第三方
    submitMakeCredentials() {
      // 根据类型生成
      switch (this.DOC_TYPE) {
        case DocumentNumber.GOODS_ORDER:
          this.makeCredentialsFirst() // 如果是第一类凭证
          break;
        case DocumentNumber.INVOICE_IN:
          this.makeCredentialsSecond(invoiceIn) // 如果是第二类凭证 即发票 如果是买入
          break;
        case DocumentNumber.INVOICE_OUT:
          this.makeCredentialsSecond(invoiceOut) // 如果是第二类凭证 即发票 如果是卖出
          break;
        case DocumentNumber.INVOICE_OTHER:
          this.makeCredentialsSecond(invoiceOther) // 第三方特殊处理
          break;
      }
      this.CheckDialogVisible = false
      this.orderDialogVisible = false

      // 发票买入生成凭证函数
      function invoiceIn(item) {
        // 买入的逻辑 借 主营业务成本-票点成本  票点金额成本(金额)
        this.needToMakeList.push({
          quote: parseTime(new Date()),
          voucherType: '主营业务成本-票点成本',
          lender: item.invoiceAmount,
          borrower: '',
          comments: '无',
          amount: item.invoiceAmount
        })
        //贷 应付账款 - 供应商往来 - 供应商name   票点金额成本(金额)
        this.needToMakeList.push({
          quote: parseTime(new Date()),
          voucherType: '应付账款-供应商往来-' + item.companyName,
          lender: '',
          borrower: item.invoiceAmount,
          comments: '无',
          amount: item.invoiceAmount
        })
      }

      // 发票卖出生成凭证函数
      function invoiceOut(item) {
        // 卖出的逻辑 借 应收账款-客户往来-客户名字 票点收入金额
        this.needToMakeList.push({
          quote: parseTime(new Date()),
          voucherType: '应收账款-客户往来' + item.companyName,
          lender: item.invoiceAmount,
          borrower: '',
          comments: '无',
          amount: item.invoiceAmount
        })
        //贷 主营业务收入-票点收入 票点收入金额
        this.needToMakeList.push({
          quote: parseTime(new Date()),
          voucherType: '主营业务收入-票点收入',
          lender: '',
          borrower: item.invoiceAmount,
          comments: '无',
          amount: item.invoiceAmount
        })
      }

      // 第三方
      function invoiceOther(item) {
        // 同时有买入和卖出 客户是卖出 供应商是买入
        this.needToMakeList.push({
          quote: parseTime(new Date()),
          voucherType: '主营业务成本-票点成本',
          lender: item.invoiceAmount,
          borrower: '',
          comments: '无',
          amount: item.invoiceAmount
        })
        this.needToMakeList.push({
          quote: parseTime(new Date()),
          voucherType: '应付账款-供应商往来-' + item.Supplier,
          lender: '',
          borrower: item.invoiceAmount,
          comments: '无',
          amount: item.invoiceAmount
        })
        this.needToMakeList.push({
          quote: parseTime(new Date()),
          voucherType: '应收账款-客户往来' + item.customer,
          lender: item.invoiceAmount,
          borrower: '',
          comments: '无',
          amount: item.invoiceAmount
        })
        this.needToMakeList.push({
          quote: parseTime(new Date()),
          voucherType: '主营业务收入-票点收入',
          lender: '',
          borrower: item.invoiceAmount,
          comments: '无',
          amount: item.invoiceAmount
        })
      }
    },
    // 生成第一类凭证 订单的运费 总货款 出厂贷款的凭证生成
    makeCredentialsFirst() {
      // 1. 如果出厂货款大于0 贷 应付账款 - 供应商往来 - 宁夏xxxxx 供应商名字 金额 2271.46  **注意一个订单多个供应商  group by 供应商分组 *
      function makeSupplierVoucher(item) {
        if (item.supplierNames) {
          // 获取供应商列表 分组添加
          item.orderDetailList.forEach(element => {
            // 贷方
            this.needToMakeList.push({
              quote: parseTime(new Date()) + element.supplier + '进货',
              voucherType: '应付账款-供应商往来-' + element.supplier,
              lender: '',
              borrower: element.paymentFactory,
              comments: element.supplier,
              amount: element.paymentFactory
            })
            // 借方
            this.needToMakeList.push({
              quote: parseTime(new Date()) + element.supplier + '进货',
              voucherType: '主营业务成本-玻璃成本',
              lender: element.paymentFactory,
              borrower: '',
              comments: '无',
              amount: element.paymentFactory
            })
          })
        }
      }

      // 2. 总货款 借  应收账款 - 客户往来 - - 客户名称    总货款  2271.46 // 贷 主营业务收入 - 玻璃收入 - 金额 总货款  2271.46
      function makeCustomerVoucher(item) {
        if (item.allPayments > 0) {
          // 贷方
          this.needToMakeList.push({
            quote: parseTime(new Date()) + item.customer + '进货',
            voucherType: '主营业务收入-玻璃收入-金额',
            lender: item.allPayments,
            borrower: '',
            comments: item.customer,
            amount: item.allPayments
          })
          // 借方
          this.needToMakeList.push({
            quote: parseTime(new Date()) + item.customer + '进货',
            voucherType: '应收账款-客户往来-' + item.customer,
            lender: '',
            borrower: item.allPayments,
            comments: '无',
            amount: item.allPayments
          })
        }
      }

      // 3. 运费  借  主营业务成本-运费成本 - 68.25  运费 海运陆运之和  贷  应付运费 - 陆运   应付运费 - 海运  分开写填运费
      function makeFreightVoucher(item) {
        if (item.landFreight || item.seaFreight) {
          // 贷方
          this.needToMakeList.push({
            quote: parseTime(new Date()) + '运费',
            voucherType: '应付运费-陆运',
            lender: '',
            borrower: item.landFreight,
            comments: item.landCarNo,
            amount: item.landFreight
          })
          if (item.seaFreight) {
            this.needToMakeList.push({
              quote: parseTime(new Date()) + '运费',
              voucherType: '应付运费-海运',
              lender: '',
              borrower: item.seaFreight,
              comments: item.seaCarNo,
              amount: item.seaFreight
            })
          }
          // 借方
          this.needToMakeList.push({
            quote: parseTime(new Date()) + '运费',
            voucherType: '主营业务成本-运费成本',
            lender: item.landFreight + item.seaFreight,
            borrower: '',
            comments: item.landCarNo,
            amount: item.landFreight + item.seaFreight
          })
        }
      }

      // 生成
      this.selectedNeedOrderList.forEach(item => {
        makeSupplierVoucher.call(this, item);
        makeCustomerVoucher.call(this, item);
        makeFreightVoucher.call(this, item);
      })
      // 填充基本信息
      this.needToMakeList.forEach(item => {
        item.voucherNo = 'orderId_' + this.selectedNeedOrderList[0].id
        item.pid = this.selectedNeedOrderList[0].id
        item.vDate = parseTime(new Date())
        item.makeUser = this.trueName;
      })
    },
    // 生成第二类凭证  分为买入 和 卖出 需要查询订单信息
    makeCredentialsSecond(callback) {
      this.$message.success('制作票点凭证')
      // 生成
      this.selectedNeedOrderList.forEach(item => {
        callback.call(this, item)
      })
      // 填充基本信息 如果是第三方开票 需要根据ordersNo查询原订单id 拼接
      listGoodsOrder({ordersNo: item.ordersNo})
      this.needToMakeList.forEach((item, index) => {
        item.voucherNo = 'invoice_' + this.selectedNeedOrderList[0].id
        // 这个地方会绑定多个id
        // todo
        item.pid = this.selectedNeedOrderList[0].id
        item.vDate = parseTime(new Date())
        item.makeUser = this.trueName;
      })
    },
    // 获取出厂货款
    getPaymentFactory(row) {
      return row.orderDetailList.reduce((pre, cur) => {
        return pre + cur.paymentFactory
      }, 0)
    },
    // 获取供应商列表
    getSupplierNames(list) {
      if (list.length === 0) {
        return;
      }
      return list.map(item => {
        return {
          supplier: item.supplier,
          supplierID: item.supplierID
        }
      })
    },
  },
}
