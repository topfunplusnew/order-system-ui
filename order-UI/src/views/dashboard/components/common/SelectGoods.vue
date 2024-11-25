<script>
  import { listGoodsOrder } from '@/api/system/goodsOrder'
  import QuerySearchBar from '@/views/dashboard/components/goodsOrder/QuerySearchBar.vue'
  import { OptionInvent, Options } from '@/views/dashboard/mixins/order/order_Invoice'

  export default {
    name: 'SelectGoods',
    components: { QuerySearchBar },
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
    mounted() {
      // 接受事件总线传递来的该组件的更新操作 并且传入回调函数
      this.$bus.$on('select-goods:update', () => this.refresh())
    },
    beforeDestroy() {
      // 清除事件监听 防止内存泄漏
      this.$bus.$off('select-goods:update', () => this.refresh()) // 清理事件监听
    },
    methods: {
      // 获取订单列表
      getList() {
        this.loading = true
        listGoodsOrder(this.queryParams).then((res) => {
          this.goodsOrderList = res.rows
          this.total = res.total
          this.loading = false
        })
      },
      // 多选 这边需要通过vuex进行管理状态 因为跨越组件了
      handleSelectionChange(selection) {
        // 本地也维护一份数据
        this.selectedGoodsOrderList = selection
        // 由vuex维护选中的订单列表 以便于其他组件使用
        this.$store.dispatch('excel/setSelectedOrders', selection)
      },
      handleQuery() {
        this.queryParams.pageNum = 1
        this.getList()
      },
      // 重新拉取数据
      refresh() {
        this.resetParams()
        this.getList()
      },
      // 重置搜索条件
      resetParams() {
        // 只选择未开票的订单
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
          invoiceState: '未开票',
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
          isSupplierInvoice: null
        }
      }
    }
  }
</script>

<template>
  <div>
    <QuerySearchBar
      :handle-query="handleQuery"
      :options="options"
      :options-invoice="optionsInvoice"
      :query-params="queryParams"
      :show-search="true"
    />
    <el-table
      id="printBox"
      v-loading="loading"
      v-horizontal-scroll="'always'"
      fit
      border
      :data="goodsOrderList"
      virtual-scroll
      max-height="750"
      size="mini"
      :cell-style="
        () => {
          return { padding: '2px' }
        }
      "
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column
        show-overflow-tooltip
        label="日期"
        align="center"
        prop="orderDate"
        fixed="left"
      />
      <el-table-column
        show-overflow-tooltip
        label="客户"
        align="center"
        prop="customer"
        fixed="left"
      />
      <el-table-column
        show-overflow-tooltip
        label="供应商"
        align="center"
        prop="supplierNames"
        fixed="left"
        width="200"
      ></el-table-column>
      <el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo" />
      <el-table-column
        show-overflow-tooltip
        label="陆运司机电话"
        align="center"
        prop="landDriverTel"
        width="100px"
      />
      <el-table-column
        show-overflow-tooltip
        label="陆地司机姓名"
        align="center"
        prop="landDriverName"
        width="100px"
      />
      <el-table-column
        show-overflow-tooltip
        label="总货款"
        align="center"
        prop="allPayments"
        width="100px"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        label="陆运费"
        align="center"
        prop="landFreight"
        width="100px"
      />
      <!--      原为海运车牌号-->
      <el-table-column show-overflow-tooltip label="海运柜号" align="center" prop="seaCarNo">
        <template #default="scope">
          {{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}
        </template>
      </el-table-column>
      <el-table-column
        show-overflow-tooltip
        label="海运司机电话"
        align="center"
        prop="seaDriverTel"
        width="100px"
      >
        <template #default="scope">
          {{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}
        </template>
      </el-table-column>
      <!--      原为海运司机姓名-->
      <el-table-column
        show-overflow-tooltip
        label="海运公司"
        align="center"
        prop="seaDriverName"
        width="100px"
      >
        <template #default="scope">
          {{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverTel }}
        </template>
      </el-table-column>
      <el-table-column
        show-overflow-tooltip
        label="海运费"
        align="center"
        prop="seaFreight"
        width="100px"
      />
      <el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager" />
      <el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet" />
      <el-table-column
        show-overflow-tooltip
        label="业务员"
        align="center"
        prop="userName"
        width="120px"
      />
      <el-table-column
        show-overflow-tooltip
        label="审核状态"
        align="center"
        prop="checkState"
        width="120"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        label="开票状态"
        align="center"
        prop="invoiceState"
        width="120px"
      />
      <el-table-column
        show-overflow-tooltip
        label="客户是否开票"
        align="center"
        prop="customerIsInvoice"
        width="150px"
      >
        <template #default="scope">
          {{ scope.row.customerIsInvoice === 1 ? '是' : '否' }}
        </template>
      </el-table-column>
      <el-table-column
        show-overflow-tooltip
        label="供应商是否开票"
        align="center"
        prop="isSupplierInvoice"
        width="120px"
      >
        <template #default="scope">
          {{ scope.row.isSupplierInvoice >= 1 ? '是' : '否' }}
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="备注" align="center" prop="comments" />
    </el-table>
    <!--    分页组件-->
    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
  </div>
</template>

<style scoped lang="scss"></style>
