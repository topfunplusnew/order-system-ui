<script>
import {listGoodsOrder} from "@/api/system/goodsOrder";
import QuerySearchBar from "@/views/dashboard/components/goodsOrder/QuerySearchBar.vue";
import {OptionInvent, Options} from "@/views/dashboard/mixins/order/order_Invoice";

export default {
  name: "SelectGoods",
  components: {QuerySearchBar},
  data() {
    return {
      // 查询参数
      queryParams: {},
      // 订单列表
      goodsOrderList: [],
      total: 0,
      loading: false,
      options: Options,
      optionsInvoice: OptionInvent,
      // 选中的订单列表
      selectedGoodsOrderList: []
    }
  },
  created() {
    this.resetParams()
    this.getList()
  },
  methods: {
    // 获取订单列表
    getList() {
      this.loading = true
      listGoodsOrder(this.queryParams).then(res => {
        this.goodsOrderList = res.rows
        this.total = res.total
        this.loading = false
      })
    },
    // 多选
    handleSelectionChange(selection) {
      this.selectedGoodsOrderList = selection
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetParams() {
      this.queryParams = {
        orderDateStart: null,
        orderDateEnd: null,
        pageNum: 1,
        pageSize: 10,
        ordersNo: null,
        orderDate: null,
        customer: null,
        customerID: null,
        landCarID: null,
        landCarNo: null,
        landDriverTel: null,
        landDriverName: null,
        seaCarID: null,
        seaCarNo: null,
        seaDriverTel: null,
        seaDriverName: null,
        checkUserId: null,
        checkState: null,
        invoiceState: null,
        path: null,
        PaymentState: null,
        landBankName: null,
        landBankNo: null,
        seaBankName: null,
        seaBankNo: null,
        receiveProof: null,
        saleManager: null,
        fleet: null,
        isAdjusted: null,
        adjustDate: null,
        isAdjust: '否',
        adjustOrderid: null,
        isedit: null,
        customerIsInvoice: null,
        isSupplierInvoice: null,
      }
    }
  }
}
</script>

<template>
  <div>
    <QuerySearchBar :handle-query="handleQuery" :options="options" :options-invoice="optionsInvoice"
                    :query-params="queryParams" :show-search="true"/>
    <el-table fit border v-loading="loading" :data="goodsOrderList" @selection-change="handleSelectionChange"
              id="printBox" v-horizontal-scroll="'always'" virtual-scroll
              max-height="750"
              size="mini" :cell-style="() => { return { padding: '2px' } }">
      <el-table-column type="selection" width="55" align="center"/>
      <el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left"
      />
      <el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left"
      />
      <el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" fixed="left"
                       width="200">
      </el-table-column>
      <el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo"
      />
      <el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel"
                       width="100px"/>
      <el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName"
                       width="100px"/>
      <el-table-column show-overflow-tooltip label="总货款" align="center" prop="allPayments" width="100px">
      </el-table-column>
      <el-table-column show-overflow-tooltip label="陆运费" align="center" prop="landFreight"
                       width="100px"/>
      <!--      原为海运车牌号-->
      <el-table-column show-overflow-tooltip label="海运柜号" align="center" prop="seaCarNo"
      >
        <template #default="scope">
          {{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel"
                       width="100px">
        <template #default="scope">
          {{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}
        </template>
      </el-table-column>
      <!--      原为海运司机姓名-->
      <el-table-column show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName"
                       width="100px">
        <template #default="scope">
          {{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverTel }}
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="海运费" align="center" prop="seaFreight"
                       width="100px"/>
      <el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager"
      />
      <el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet"
      />
      <el-table-column show-overflow-tooltip label="业务员" align="center" prop="userName" width="120px"/>
      <el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState"
                       width="120">
      </el-table-column>
      <el-table-column show-overflow-tooltip label="开票状态" align="center" prop="invoiceState"
                       width="120px"/>
      <el-table-column show-overflow-tooltip label="客户是否开票" align="center" prop="customerIsInvoice"
                       width="150px">
      </el-table-column>
      <el-table-column show-overflow-tooltip label="供应商是否开票" align="center" prop="isSupplierInvoice"
                       width="120px">
      </el-table-column>
      <el-table-column show-overflow-tooltip label="备注" align="center" prop="comments"/>
      <el-table-column show-overflow-tooltip label="操作" align="center" prop="comments">
        <template #default="scope">
          <slot name="option"/>
        </template>
      </el-table-column>
    </el-table>
    <!--    分页组件-->
    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum"
                :limit.sync="queryParams.pageSize"
                @pagination="getList"/>
  </div>
</template>

<style scoped lang="scss">

</style>
