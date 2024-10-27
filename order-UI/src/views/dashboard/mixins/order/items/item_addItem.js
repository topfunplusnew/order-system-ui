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
        this.orderItemInfo.freight = Number(this.orderItemInfo.landFreight) +
          (this.isSea ? Number(this.orderItemInfo.seaFreight) : 0);
        const taxMapping = {
          '00': {
            paymentFactory: this.paymentFactory00,
            payments: this.payments00,
            tonnage: this.tonnage00,
            landFreight: this.landFreight00,
            profit: this.profit00,
            profitNoTax: this.profitNoTax00
          },
          '10': {
            paymentFactory: this.paymentFactory10,
            payments: this.payments10,
            tonnage: this.tonnage10,
            landFreight: this.landFreight10,
            profit: this.profit10,
            profitNoTax: this.profitNoTax10
          },
          '01': {
            paymentFactory: this.paymentFactory01,
            payments: this.payments01,
            tonnage: this.tonnage01,
            landFreight: this.landFreight01,
            profit: this.profit01,
            profitNoTax: this.profitNoTax01
          },
          '11': {
            paymentFactory: this.paymentFactory11,
            payments: this.payments11,
            tonnage: this.tonnage11,
            landFreight: this.landFreight11,
            profit: this.profit11,
            profitNoTax: this.profitNoTax11
          }
        };
        // 根据 isIncludeTaxFactory 和 isIncludeTaxSale 确定映射键
        const key = `${this.orderItemInfo.isIncludeTaxFactory}${this.orderItemInfo.isIncludeTaxSale}`;
        // 获取对应的数据并解构赋值到 orderItemInfo 中
        Object.assign(this.orderItemInfo, taxMapping[key]);
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
