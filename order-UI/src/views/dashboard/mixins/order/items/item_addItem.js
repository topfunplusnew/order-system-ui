/**
 * 添加订单个体的混入
 */
export var mixin_item_addItem = {
  data: function () {
    return {
      orderItemInfo: {},
    }
  },
  watch: {
    'orderItemInfo': {
      handler() {
        //运费自动填充
        if (this.isSea === false) {
          this.orderItemInfo.freight = Number(this.orderItemInfo.landFreight);
        } else {
          this.orderItemInfo.freight = Number(this.orderItemInfo.landFreight) + Number(this.orderItemInfo.seaFreight);
        }
        //是否含税 厂家否 客户否
        if (this.orderItemInfo.isIncludeTaxFactory === '0' && this.orderItemInfo.isIncludeTaxSale === '0') {
          //误差为0.8
          console.log(this.orderItemInfo.erro)
          //出厂贷款
          this.orderItemInfo.paymentFactory = this.paymentFactory00;
          //总贷款
          this.orderItemInfo.payments = this.payments00;
          //吨位
          this.orderItemInfo.tonnage = this.tonnage00
          //运费
          this.orderItemInfo.landFreight = this.landFreight00
          //利润
          this.orderItemInfo.profit = this.profit00
          //不含税利润
          this.orderItemInfo.profitNoTax = this.profitNoTax00
          //出厂含税客户不含税
        } else if (this.orderItemInfo.isIncludeTaxFactory === '1' && this.orderItemInfo.isIncludeTaxSale === '0') {
          //误差为0
          this.orderItemInfo.paymentFactory = this.paymentFactory10;
          this.orderItemInfo.payments = this.payments10
          this.orderItemInfo.tonnage = this.tonnage10
          this.orderItemInfo.landFreight = this.landFreight10
          this.orderItemInfo.profit = this.profit10
          this.orderItemInfo.profitNoTax = this.profitNoTax10
          console.log('10', this.orderItemInfo.profitNoTax10, this.orderItemInfo.profitNoTax)
        } else if (this.orderItemInfo.isIncludeTaxFactory === '0' && this.orderItemInfo.isIncludeTaxSale === '1') {
          //误差为0
          this.orderItemInfo.paymentFactory = this.paymentFactory01;
          this.orderItemInfo.payments = this.payments01
          this.orderItemInfo.tonnage = this.tonnage01
          this.orderItemInfo.landFreight = this.landFreight01
          this.orderItemInfo.profit = this.profit01
          this.orderItemInfo.profitNoTax = this.profitNoTax01
        } else {
          //误差为0
          this.orderItemInfo.paymentFactory = this.paymentFactory11;
          this.orderItemInfo.payments = this.payments11
          this.orderItemInfo.tonnage = this.tonnage11
          this.orderItemInfo.landFreight = this.landFreight11
          this.orderItemInfo.profit = this.profit11
          this.orderItemInfo.profitNoTax = this.profitNoTax11
        }

      },
      deep: true,
      immediate: true,
    },
  },
  methods: {
    //添加订单vuex
    addOrderItem() {
      this.loading = true;
      this.$store.commit('order/changeOrderItemStatus', {...this.orderItemInfo, orderIndex: this.index})
      this.$message.success('添加货物成功')
      this.disabled = true;
      this.buttonText = '已添加该货物'
      this.loading = false
    },
    // 供应商信息 从供应商发货
    handleCommitBackCompany(val) {
      this.resetOrderItemInfo()
      this.orderItemInfo.supplierID = val.id;   //goodsOrderList->供应商ID
      this.orderItemInfo.supplier = val.companyName
    },
    // 仓库信息 从仓库发货
    handleCommitBackInventory(val) {
      this.resetOrderItemInfo()
      this.orderItemInfo.storeID = val.id;  //goodsOrderList ->仓库ID
      this.orderItemInfo.storeHouseID = val.id //goodsOrderList ->库存ID
      if (this.orderItemInfo.supplier) {
        this.orderItemInfo.supplier = null;
      }
      this.orderItemInfo.storeName = val.storeHouseName
      this.orderItemInfo.length = val.length;
      this.orderItemInfo.height = val.height;
      this.orderItemInfo.width = val.width;
      this.orderItemInfo.levelID = val.levelID;
      this.orderItemInfo.levelName = val.levelName;
      //出厂片数让用户自己填
      this.orderItemInfo.pieces = val.stockNumber;
      this.currentStockNumber = val.stockNumber;//暂存
    },
    // 产品级别自动填充
    handleCommitBackProductLevel(val) {
      // todo 这里用产品级别的吨位 填充了误差
      this.orderItemInfo.erro = val.tonnage
      this.orderItemInfo.levelID = val.id;
      this.orderItemInfo.levelName = val.levelName;
      this.orderItemInfo.height = val.height;
      this.orderItemInfo.length = val.length;
      this.orderItemInfo.width = val.width;
      this.orderItemInfo.levelNo = val.levelNo;
    },
    // 重置订单个体信息
    resetOrderItemInfo() {
      this.orderItemInfo = {
        orderDate: null,
        supplier: null,
        supplierID: null,
        customer: null,
        customerID: null,
        levelID: null,
        levelName: null,
        countingUnit: '片',
        height: null,
        length: null,
        width: null,
        pieces: null,
        piecesPerPack: 0,
        packs: 0,
        price: 0,
        isIncludeTaxFactory: '0',
        sundryCost: 0,
        paymentFactory: 0,
        paymentUnload: 0,
        isIncludeTaxSale: '0',
        payments: 0,
        erro: 0,
        tonnage: 0,
        landFreightPrice: 0,
        landFreight: 0,
        seaFreight: 0,
        freight: 0,
        otherCost: 0,
        profit: 0,
        profitNoTax: 0,
        actualPieces: 0,
        paymentsWithSundry: 0,
        additionalFees: 0,
        storeHouseID: null,
        storeHouseName: null,
        storeID: null,
        logisticsProfit: 0,
        customerCommission: null,
        isAdjusted: null,
        adjustDate: null,
        comments: null,
        addtime: null,
        userId: null,
        exWarehouseDate: null,
        outPieces: 0
      }
    }
  },
}
