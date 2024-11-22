<!--订单页面-->
<template>
  <div class="app-container">
    <!--    这是框架自带的搜索模组，封装成了组件并且放在与index.vue同级目录下-->
    <QuerySearchBar :handle-query="handleQuery" :options="options" :options-invoice="optionsInvoice"
      :query-params="queryParams" :show-search="showSearch" />

    <!--    表格列 数据大量展示-->
    <ElTableOrder />

    <!-- 订单历史信息查看  mixin_order_orderHistory -->
    <OrderHistoryCheck :active-names="activeNames" :check-history-order-visible="checkHistoryOrderVisible"
      :checkcurrent-order-item-info="checkcurrentOrderItemInfo" :order-history-info-list="orderHistoryInfoList"
      :parse-time="parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}')" @close="closeOrderHistoryCheck" />
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import { parseTime } from "../../../utils/ruoyi";
import { mixin_order_Invoice } from "../../dashboard/mixins/order/order_Invoice";
import { mixin_order_orderHistory } from "../../dashboard/mixins/order/order_history";
import { mixin_order_base } from "../../dashboard/mixins/order/order_base";
import ElTableOrder from "@/views/dashboard/components/goodsOrder/ElTableOrder.vue";
import QuerySearchBar from "@/views/dashboard/components/goodsOrder/QuerySearchBar.vue";
import OrderHistoryCheck from "@/views/dashboard/components/goodsOrder/OrderHistoryCheck.vue";

export default {
  name: "GoodsOrder",
  // 混入 订单逻辑分布在混入文件中
  mixins: [
    mixin_order_Invoice,
    mixin_order_orderHistory,
    mixin_order_base,
  ],
  // 组件注册
  components: {
    OrderHistoryCheck,
    QuerySearchBar,
    ElTableOrder
  },
  data () {
    return {
      showSearch: true,
    };
  },
  computed: {
    ...mapGetters(['orderItemList']), // 获取订单列表
    ...mapGetters(['currentOrderInfo']) // 拿到暂存里的订单信息
  },
  methods: {
    parseTime,
    /** 搜索按钮操作 */
    handleQuery () {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery () {
      this.resetForm("queryForm");
      this.handleQuery();
    },
  }
};
</script>
<style lang="scss">
//对于订单表格中的供应商的样式设计
.item {
  margin-right: 5px;
  /* 添加一些间距 */
  margin-top: 5px;
  cursor: pointer;

  &:hover {
    transform: scale(1.1);
    font-weight: bolder;
    color: #1ab394;
  }
}

.center {
  // 解决vue-code-diff对不齐和显示下拉标志问题
  max-height: 600px;
  overflow-y: auto;
  overflow-x: hidden;

  /* 样式穿透-起始行左右对齐，*/
  .d2h-code-side-line {
    height: 15px;
  }

  code.hljs {
    padding: 0;
  }

  // 删除行统计显示
  .d2h-code-side-linenumber {
    display: none;
  }

  .d2h-code-side-line {
    padding: unset;
  }

  .d2h-code-line-ctn {
    width: unset;
  }

  // 删除第一行的统计结果
  .d2h-info {
    display: none;
  }
}


.el-icon-arrow-down {
  font-size: 12px;
}
</style>
