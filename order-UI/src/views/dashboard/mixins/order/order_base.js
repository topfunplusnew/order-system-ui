import {listGoodsOrder} from "../../../../api/system/goodsOrder";

/**
 * 订单基类
 */
export var mixin_order_base = {
  data: function () {
    return {
      columns: [
        {key: 0, label: '日期', visible: true},
        {key: 1, label: '客户', visible: true},
        {key: 2, label: '供应商', visible: true},
        {key: 3, label: '陆运车牌', visible: true},
        {key: 4, label: '陆运司机电话', visible: true},
        {key: 5, label: '陆地司机姓名', visible: true},
        {key: 6, label: '陆运费', visible: true},
        {key: 7, label: '柜号', visible: true},
        {key: 8, label: '海运司机电话', visible: true},
        {key: 9, label: '海运公司', visible: true},
        {key: 10, label: '海运费', visible: true},
        {key: 11, label: '销售经理', visible: true},
        {key: 12, label: '车队', visible: true},
        {key: 13, label: '审核状态', visible: true},
        {key: 14, label: '开票状态', visible: true},
        {key: 15, label: '附件', visible: true},
        {key: 16, label: '打款状态', visible: true},
        {key: 17, label: '收到条附件路径', visible: true},
        {key: 18, label: '原订单编号', visible: true},
        {key: 19, label: '是否可编辑', visible: true},
        {key: 20, label: '客户是否开票', visible: true},
        {key: 21, label: '供应商是否开票', visible: true},
        {key: 22, label: '备注', visible: true}
      ],
      //顶部条件搜索
      queryOrderInfo: {},
      mapper: {
        'orderDate': '订单日期',
        'supplier': '供应商名称',
        'customer': '客户名称',
        'levelName': '级别名称',
        'countingUnit': '计数单位',
        'height': '高度',
        'length': '长度',
        'width': '宽度',
        'pieces': '数量',
        'piecesPerPack': '每包数量',
        'packs': '包数',
        'price': '单价',
        'isIncludeTaxFactory': '是否含税（工厂）',
        'sundryCost': '杂费',
        'paymentFactory': '工厂付款',
        'paymentUnload': '卸货费用',
        'isIncludeTaxSale': '是否含税（销售）',
        'payments': '销售付款',
        'erro': '误差',
        'tonnage': '吨位',
        'landFreightPrice': '陆运价格',
        'landFreight': '陆运费',
        'seaFreight': '海运费',
        'freight': '运费',
        'otherCost': '其他费用',
        'profit': '利润',
        'profitNoTax': '无税利润',
        'actualPieces': '实际数量',
        'paymentsWithSundry': '含杂费付款',
        'additionalFees': '额外费用',
        'storeHouseName': '仓库名称',
        'logisticsProfit': '物流利润',
        'customerCommission': '客户佣金',
        'comments': '备注',
        'updateTime': '订单修改时间',
        'remark': '修改记录',
        'landCarNo': '陆运车牌号',
        'landDriverName': '陆运司机姓名',
        'landBankNo': '陆运司机银行卡号',
        'landDriverTel': '陆运司机电话',
        'fleet': "车队",
        'seaCarNo': '柜号',
        'seaDriverName': '海运公司',
        'seaDriverTel': '海运司机电话',
        'seaBankNo': '海运司机银行卡号',
        'seaBankName': '海运司机开户名',
        'landBankName': '陆运司机开户名',
        'companyName': '公司名称',
        'saleManager': '销售经理',
        'userName': '修改人',
        'supplierNames': '供应商',
        'allPayments': '总货款',
      },
    }
  },
  methods: {
    // 获取供应商的名称列表
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
    /** 查询订单列表 */
    getList() {
      listGoodsOrder(this.queryParams).then(response => {
        this.goodsOrderList = response.rows;
        this.total = response.total;
        this.loading = false
      });
    },
    // 休眠函数
    sleep(ms) {
      return new Promise(resolve => setTimeout(resolve, ms));
    },
    // 格式化对象
    formatData(data) {
      let formattedString = '';
      for (const key in data) {
        if (data.hasOwnProperty(key)) {
          const value = data[key];
          const mappedKey = this.mapper[key] || key;
          formattedString += `${mappedKey}: ${value}\n`;
        }
      }
      return formattedString.trim(); // 去掉最后一个换行符
    },
    // 查看某一个文件
    checkFileItem(item) {
      window.open(item)
    },
  },
}
