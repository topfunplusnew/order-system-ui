// 添加返利回扣时选择订单的逻辑
import {addDateRange} from "../../../../utils/ruoyi";
import {noPageListRebate} from "../../../../api/system/Rebate";
import {getGoodsOrder} from "../../../../api/system/goodsOrder";

export var mixin_choose_order = {
  data() {
    return {
      // 选中货物 这个是最终要传递给后端的id数组
      goods: [],
      // 点击选择订单后 选择订单的显示
      orderSelectVisible: false,
      // 选择供应商出来的搜索
      queryParamsSupplier: {
        supplier: '',
        dateRange: []
      },
      // 供应商筛选  供应商列表名称 可以通过list拿
      nameFilters: [],
      // 已经选择的订单货物弹窗
      orderGoodsVisible: false,
      // 已选择的货物列表
      orderDetailInfoList: [],
      // 查看订单详情
      checkOrderInformation: {},
      // 查看订单信息
      orderVisible: false,
      // 选择供应商
      orderBySupplierVisible: false,
      // 筛选的订单详情列表
      needToSelectOrderDetailList: [],
      orderGoodsListVisible: false,
    }
  },
  methods: {
    // 点击选择订单
    selectOrderItem() {
      this.orderSelectVisible = true;
    },
    // 两种方式 一种是直接选订单 另一种是先选供应商 再选订单
    // 1.根据供应商选择
    selectBySupplier() {
      this.orderBySupplierVisible = true;
    },
    // 供应商自动填充
    handleCommitCompany(val) {
      this.queryParamsSupplier.supplier = val.companyName
    },
    // 确认选择供应商
    handleCommitSupplier() {
      //点击选择供应商和时间段后 查询列表 然后弹出选择货物详情
      noPageListRebate(addDateRange(this.queryParamsSupplier, this.queryParamsSupplier.dateRange)).then(res => {
        this.needToSelectOrderDetailList = res.rows;
        this.orderGoodsListVisible = true;
      })
    },
    // 2. 直接选择订单
    // 点击选择订单弹出的订单列表页选择某个订单 需要自动填充信息
    handleSelectOrderItem(row) {
      this.goods = []
      getGoodsOrder(row.id).then(res => {
        this.orderInfo = res.data;
        this.orderDetailList = res.data.orderDetailList;
        // 补充供应商信息
        this.nameFilters = this.orderDetailList.map(item => {
          return {
            text: item.supplier,
            value: item.supplier
          }
        })
      })
      this.orderSelectVisible = false
    },
    // 查看订单信息
    checkOrderInfo(row) {
      getGoodsOrder(row.id).then(res => {
        this.checkOrderInformation = res.data;
        this.orderVisible = true;
      })
    },
    // 订单多选
    handleSelectionChangeOrders(selection) {
      this.goods = selection;
    },
    // 多选某个货物
    handleSelectionChangeOrderDetail(selection) {
      // this.goods = selection;
    },
    // 选择需要返利的订单进行返利
    handleSelectOrderDetailChange(selection) {
      this.goods = selection;
      this.orderGoodsListVisible = false
      this.orderBySupplierVisible = false
      this.submitSelectOrderDetail()
    },
    // 查看已选择的货物
    checkSelectedGoods() {
      this.orderGoodsVisible = true
    },
    // 清空已选择的货物
    refreshSelectedGoods() {
      this.goods = []
    },
    // 确认选择
    submitSelectOrderDetail() {
      this.goods.forEach(item => {
        this.form.orderDetailIds.push(item.id)
      })
      this.orderDialogVisible = false
    },
  }
}
