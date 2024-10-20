import {fix} from "../../../../../api/tool/format";

/**
 * 订单的计算公式 分为四种情况
 * @type {{data: (function(): {}), computed: {profit10(): *|string, profit00(): *|string, profit11(): *|string, profit01(): *|string, tonnage00(): *|string, paymentFactory10(): *|string, tonnage11(): *|string, tonnage01(): *|string, paymentFactory01(): *|string, payments01(): *|string, paymentFactory00(): *|string, tonnage10(): *|string, paymentFactory11(): *|string, payments10(): *|string, payments00(): *|string, payments11(): *|string, landFreight10(): *|string, profitNoTax00(): *|string, profitNoTax11(): *|string, profitNoTax01(): *|string, profitNoTax10(): *|string, landFreight00(): *|string, landFreight11(): *|string, landFreight01(): *|string}, methods: {}}}
 */
export var mixin_item_compute = {
  data: function () {
    return {}
  },
  computed: {
    //公式计算相关的计算属性
    //是否含税 厂家否 客户否
    paymentFactory00() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 * this.orderItemInfo.price + Number(this.orderItemInfo.sundryCost))
    },
    payments00() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.outPieces / 1000000 * this.orderItemInfo.paymentUnload + Number(this.orderItemInfo.paymentsWithSundry));
    },
    // todo  长度宽度高度过低 会计算吨位为0
    tonnage00() {
      return fix((Number(this.orderItemInfo.height) - Number(this.orderItemInfo.erro)) * this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 / 20 / 20);
    },
    landFreight00() {
      return fix(Number(this.orderItemInfo.tonnage) * Number(this.orderItemInfo.landFreightPrice) + Number(this.orderItemInfo.additionalFees));
    },
    profit00() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight);
    },
    profitNoTax00() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight - this.orderItemInfo.otherCost);
    },
    //是否含税10
    paymentFactory10() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces * this.orderItemInfo.price / 1000000 + Number(this.orderItemInfo.sundryCost));
    },
    payments10() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.outPieces * this.orderItemInfo.paymentUnload / 1000000 + Number(this.orderItemInfo.paymentsWithSundry));
    },
    tonnage10() {
      return fix((this.orderItemInfo.height - this.orderItemInfo.erro) * this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 / 20 / 20)
    },
    landFreight10() {
      return fix(this.orderItemInfo.tonnage * this.orderItemInfo.landFreightPrice + Number(this.orderItemInfo.additionalFees))
    },
    profit10() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight)
    },
    // todo
    profitNoTax10() {
      return fix(this.orderItemInfo.payments - (this.orderItemInfo.paymentFactory / 1.075) - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight - this.orderItemInfo.otherCost)
    },
    //是否含税01
    paymentFactory01() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 * this.orderItemInfo.price + Number(this.orderItemInfo.sundryCost));
    },
    payments01() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.outPieces * this.orderItemInfo.paymentUnload / 1000000 + Number(this.orderItemInfo.paymentsWithSundry));
    },
    tonnage01() {
      return fix((this.orderItemInfo.height - this.orderItemInfo.erro) * this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 / 20 / 20)
    },
    landFreight01() {
      return fix(Number(this.orderItemInfo.tonnage * this.orderItemInfo.landFreightPrice) + Number(this.orderItemInfo.additionalFees))
    },
    profit01() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight)
    },
    // 否 是 运费
    profitNoTax01() {
      return fix((this.orderItemInfo.payments / 1.075) - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight - this.orderItemInfo.otherCost)
    },
    //是否含税11
    paymentFactory11() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces * this.orderItemInfo.price / 1000000 + Number(this.orderItemInfo.sundryCost));
    },
    payments11() {
      return fix(this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.outPieces * this.orderItemInfo.paymentUnload / 1000000 + Number(this.orderItemInfo.paymentsWithSundry));
    },
    tonnage11() {
      return fix((this.orderItemInfo.height - this.orderItemInfo.erro) * this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 / 20 / 20)
    },
    landFreight11() {
      return fix(this.orderItemInfo.tonnage * this.orderItemInfo.landFreightPrice + Number(this.orderItemInfo.additionalFees))
    },
    profit11() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - this.orderItemInfo.landFreight - this.orderItemInfo.seaFreight)
    },
    profitNoTax11() {
      return fix(this.orderItemInfo.payments - this.orderItemInfo.paymentFactory - (this.orderItemInfo.landFreight * 1.075) - this.orderItemInfo.seaFreight
        - (this.orderItemInfo.height * this.orderItemInfo.length * this.orderItemInfo.width * this.orderItemInfo.pieces / 1000000 / 20 * 0.5) - this.orderItemInfo.otherCost)
    },
  },
  watch: {
    //根据出厂片数自动计算
    pieces: {
      handler(val) {
        //如果选择的是仓库发货
        if (this.orderItemInfo.supplierID === null) {
          if (val > this.currentStockNumber) {
            this.$message.error("出厂片数不能大于库存量!");
            this.orderItemInfo.pieces = this.currentStockNumber;
          } else {
            //修改片数自动计算
            if (this.orderItemInfo.isIncludeTaxFactory === '0' && this.orderItemInfo.isIncludeTaxSale === '0') {
              this.orderItemInfo.paymentFactory = this.paymentFactory00;
              this.orderItemInfo.payments = this.payments00;
              this.orderItemInfo.tonnage = this.tonnage00
              this.orderItemInfo.landFreight = this.landFreight00
              this.orderItemInfo.profit = this.profit00
              this.orderItemInfo.profitNoTax = this.profitNoTax00
            } else if (this.orderItemInfo.isIncludeTaxFactory === '1' && this.orderItemInfo.isIncludeTaxSale === '0') {
              this.orderItemInfo.paymentFactory = this.paymentFactory10;
              this.orderItemInfo.payments = this.payments10
              this.orderItemInfo.tonnage = this.tonnage10
              this.orderItemInfo.landFreight = this.landFreight10
              this.orderItemInfo.profit = this.profit10
              this.orderItemInfo.profitNoTax = this.profitNoTax10
            } else if (this.orderItemInfo.isIncludeTaxFactory === '0' && this.orderItemInfo.isIncludeTaxSale === '1') {
              this.orderItemInfo.paymentFactory = this.paymentFactory01;
              this.orderItemInfo.payments = this.payments01
              this.orderItemInfo.tonnage = this.tonnage01
              this.orderItemInfo.landFreight = this.landFreight01
              this.orderItemInfo.profit = this.profit01
              this.orderItemInfo.profitNoTax = this.profitNoTax01
            } else {
              this.orderItemInfo.paymentFactory = this.paymentFactory11;
              this.orderItemInfo.payments = this.payments11
              this.orderItemInfo.tonnage = this.tonnage11
              this.orderItemInfo.landFreight = this.landFreight11
              this.orderItemInfo.profit = this.profit11
              this.orderItemInfo.profitNoTax = this.profitNoTax11
            }
          }
        }
      }
    },
  },
  methods: {},
}
