<!--订单页面-->
<template>
  <div class="app-container">
    <QuerySearchBar :handle-query="handleQuery" :options="options" :options-invoice="optionsInvoice"
                    :query-params="queryParams" :show-search="showSearch"/>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:goodsorder:add']"
        >添加订单信息
        </el-button>
      </el-col>

      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" :columns="columns">
        <template v-slot:print>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-printer"
              size="mini"
              @click="printHTML"
            >
            </el-button>
          </el-col>
        </template>
        <template v-slot:export>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport"
              v-hasPermi="['system:goodsorder:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>
    <!--    表格列-->
    <el-table fit border v-loading="loading" :data="goodsOrderList" @selection-change="handleSelectionChange"
              id="printBox" v-horizontal-scroll="'always'" @header-dragend="changeColWidth"
              max-height="750" size="mini" :cell-style="()=>{return {padding:'2px'}}">

      <el-table-column label="行操作" align="center" class-name="small-padding fixed-width"
                       width="142" fixed="left">
        <template slot-scope="scope">
          <el-dropdown size="mini" split-button type="primary">
            操作
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item>
                <el-button
                  size="mini"
                  @click="checkOrderItemInfo(scope.row)"
                >查 看
                </el-button>
              </el-dropdown-item>
              <el-dropdown-item>
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleUpdate(scope.row)"
                  v-hasPermi="['system:goodsorder:edit']"
                >修 改
                </el-button>
              </el-dropdown-item>
              <el-dropdown-item>
                <el-button
                  size="mini"
                  type="warning"
                  @click="handleCheckOrderDetailInfo(scope.row)"
                >货 物
                </el-button>
              </el-dropdown-item>
              <el-dropdown-item>
                <el-button
                  size="mini"
                  type="danger"
                  @click="handleDelete(scope.row)"
                  v-hasPermi="['system:goodsorder:remove']"
                >删 除
                </el-button>
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
          <el-button
            style="margin-left: 5px"
            size="mini"
            type="success"
            @click="checkOrderHistory(scope.row)"
          >查看历史
          </el-button>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="ID" align="center" prop="id" fixed="left"/>
      <el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left"
                       v-if="columns[0].visible"/>
      <el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left"
                       v-if="columns[1].visible"/>
      <el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" fixed="left"
                       v-if="columns[2].visible"
                       width="200">
        <template #default="scope">
          <el-row v-if="scope.row.supplierNames !== null">
            <el-row>
              <span v-for="(item,index) in getSupplierNames(scope.row.orderDetailList)" :key="index">
             <el-badge is-dot class="item">
            <span @click="updateOrderItemVisibleSupplierInvoice(scope.row,item.supplierID)">
              {{ item.supplier }}
            </span>
          </el-badge>
          </span>
            </el-row>
          </el-row>
          <el-row>
            <span v-if="scope.row.supplierNames === null">无</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo"
                       v-if="columns[3].visible"/>
      <el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel"
                       v-if="columns[4].visible" width="100px"/>
      <el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName"
                       v-if="columns[5].visible" width="100px"/>
      <el-table-column show-overflow-tooltip label="总货款" align="center" prop="allPayments"
                       width="100px">
        <template #default="scope">
          {{ scope.row.allPayments | changeNumber(changeLength) }}
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="陆运费" align="center" prop="landFreight"
                       v-if="columns[6].visible" width="100px"/>

      <!--      原为海运车牌号-->
      <el-table-column show-overflow-tooltip label="海运柜号" align="center" prop="seaCarNo" v-if="columns[7].visible">
        <template #default="scope">
          {{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel"
                       v-if="columns[8].visible" width="100px">
        <template #default="scope">
          {{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}
        </template>
      </el-table-column>
      <!--      原为海运司机姓名-->
      <el-table-column show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName"
                       v-if="columns[9].visible" width="100px">
        <template #default="scope">
          {{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverTel }}
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="海运费" align="center" prop="seaFreight"
                       v-if="columns[10].visible" width="100px"/>
      <el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager"
                       v-if="columns[11].visible"/>
      <el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet" v-if="columns[12].visible"/>
      <el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState"
                       v-if="columns[13].visible"
                       width="120">
        <template #default="scope">
          <el-row v-if="scope.row.checkState === '已审核'">
            <el-tag type="success">{{ scope.row.checkState }}</el-tag>
          </el-row>
          <el-row v-else>
            <el-row>
              <el-button type="warning" @click="handleCheck(scope.row)" size="mini"
                         v-hasPermi="['system:goodsorder:audit']">审核
              </el-button>
            </el-row>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="开票状态" align="center" prop="invoiceState"
                       v-if="columns[14].visible" width="120px">
        <template #default="scope">
          <el-row v-if="scope.row.invoiceState === '已开票'">
            <el-tag type="success">已开票</el-tag>
          </el-row>
          <el-row v-else-if="scope.row.invoiceState === '未开票'">
            <el-row>
              <el-tag type="danger">未开票</el-tag>
            </el-row>
          </el-row>
          <el-row v-else>
            <el-row>
              <el-tag type="warning">部分开票</el-tag>
            </el-row>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="附件" align="center" prop="path" v-if="columns[15].visible"
                       width="150px">
        <template #default="scope">
          <el-row>
          </el-row>
          <el-row v-if="scope.row.path === '' || scope.row.path === null">
            无
          </el-row>
          <el-row v-else>
            <el-button size="mini" type="success" @click="checkAttachment(scope.row,'path')">
              查看
            </el-button>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="打款状态" align="center" prop="paymentState"
                       v-if="columns[16].visible" width="120px">
        <template slot-scope="scope">
          <el-row v-if="scope.row.paymentState === '未申请'">
            <el-button size="mini" type="primary" @click="applyForPayment(scope.row)">申请打款</el-button>
          </el-row>
          <el-row v-if="scope.row.paymentState === '审核中'">
            <el-tag type="warning">审核中</el-tag>
          </el-row>
          <el-row v-if="scope.row.paymentState === '未打款'">
            <el-tag type="warning">订单未打款</el-tag>
            <el-button>前往打款</el-button>
          </el-row>
          <el-row v-if="scope.row.paymentState === '已打款'">
            <el-tag type="success">订单已打款</el-tag>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="收到条附件路径" align="center" prop="receiveProof"
                       v-if="columns[17].visible"
                       width="150px">
        <template #default="scope">
          <el-row v-if="scope.row.receiveProof === '' || scope.row.receiveProof === null">
            无
          </el-row>
          <el-row v-else>
            <el-button size="mini" type="success" @click="checkAttachment(scope.row,'receiveProof')">
              查看
            </el-button>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="是否可编辑" align="center" prop="isedit" v-if="columns[19].visible"
                       width="100px">
        <template slot-scope="scope">
          <el-tag
            :type="scope.row.isedit === 0 ? 'danger' :'success'">{{ scope.row.isedit === 0 ? "否" : "是" }}
          </el-tag>
        </template>
      </el-table-column>
      <!--      客户供应商是否开票-->
      <el-table-column show-overflow-tooltip label="客户是否开票" align="center" prop="customerIsInvoice"
                       v-if="columns[20].visible"
                       width="150px">
        <template #default="scope">
          <el-row v-if="hasOpen(scope.row,1)">
            <el-row v-if="scope.row.customerIsInvoice > 0">
              <el-row>
                <el-button type="success" size="mini" @click="updateOrderItemVisibleCustomerInvoice(scope.row)">继续开票
                </el-button>
              </el-row>
            </el-row>
            <el-row v-else>
              <el-row>
                <el-button type="warning" size="mini" @click="updateOrderItemVisibleCustomerInvoice(scope.row)">前去开票
                </el-button>
              </el-row>
            </el-row>
          </el-row>
          <el-row v-else>
            无开票
          </el-row>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="供应商是否开票" align="center" prop="isSupplierInvoice"
                       v-if="columns[21].visible"
                       width="120px">
        <template #default="scope">
          <el-row v-if="hasOpen(scope.row,0)">
            <el-row v-if="scope.row.isSupplierInvoice > 0">
              <el-row>
                <el-button type="success" size="mini" @click="updateOrderItemVisibleSupplierInvoice(scope.row)">继续开票
                </el-button>
              </el-row>
            </el-row>
            <el-row v-else>
              <el-row>
                <el-button type="warning" size="mini" @click="updateOrderItemVisibleSupplierInvoice(scope.row)">前去开票
                </el-button>
              </el-row>
            </el-row>
          </el-row>
          <el-row v-else>
            无开票
          </el-row>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="备注" align="center" prop="comments" v-if="columns[22].visible"/>
      <!--      右侧操作栏-->
      <el-table-column show-overflow-tooltip label="订单操作" align="center" class-name="small-padding fixed-width"
                       width="280px"
                       fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            @click="handleOrder1(scope.row)"
            v-hasPermi="['system:goodsorder:edit']"
          >发货单
          </el-button>
          <el-button
            :disabled="scope.row.isAdjusted ==='是'"
            size="mini"
            type="primary"
            @click="handleOrderItemInfo(scope.row)"
          >调整单
          </el-button>
          <el-button
            size="mini"
            type="primary"
            @click="handleUpload(scope.row)"
          >上传附件
          </el-button>
          <el-button
            size="mini"
            @click="handleCommit(scope.row)"
            v-hasPermi="['system:goodsorder:remove']"
          >上传收到条
          </el-button>
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="运费申请" align="center" class-name="small-padding fixed-width"
                       width="100px"
                       fixed="right">
        <template slot-scope="scope">
          <el-dropdown size="mini" split-button type="primary">
            操作
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item>
                <el-row v-if="scope.row.landFreight>0 ||scope.row.seaFreight>0  ">
                  <el-button
                    size="mini"
                    v-if="scope.row.landFreight>0"
                    type="warning"
                    @click="handleApplyLandFree(scope.row)"
                    v-hasPermi="['system:goodsorder:remove']"
                  >陆运费申请
                  </el-button>
                  <el-button
                    size="mini"
                    v-if="scope.row.seaFreight>0"
                    type="primary"
                    @click="handleApplySeaFree(scope.row)"
                    v-hasPermi="['system:goodsorder:remove']"
                  >海运费申请
                  </el-button>
                </el-row>
                <el-row v-else>
                  无运费信息
                </el-row>
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </el-table-column>
    </el-table>
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!--        点击查看某个订单的弹窗   -->
    <CheckOrder :check-order-visible="checkOrderVisible" :order-info="orderInfo" @close="closeCheckOrderDialog"/>


    <!--    点击调整单的弹窗-->
    <el-dialog :close-on-click-modal="false" :show-close="false"
               title="提示"
               :visible.sync="handleOrderVisible"
               width="30%">
      <span>是否将订单设置为调整单?</span>
      <span slot="footer" class="dialog-footer">
    <el-button @click="handleOrderVisible = false">取 消</el-button>
    <el-button type="primary" @click="submitChangeOrder">确 定</el-button>
  </span>
    </el-dialog>

    <!--    点击发货单的弹窗 -->
    <OrderGiven :order1-visible="Order1Visible" @close="closeOrderGivenDialog"/>

    <!--    上传附件的弹窗 -->
    <UploadPath :before-upload="beforeUpload" :file-list="fileList" :handle-upload-visible="handleUploadVisible"
                :headers="headers" :submit-upload-all-files="()=>submitUploadAllFiles('path')"
                :upload-file-url="uploadFileUrl" @close="closeUploadPathDialog" />

    <!--    上传收到条的弹窗-->
    <UploadCommit :before-upload="beforeUpload" :file-list="fileList" :handle-commit-visible="handleCommitVisible"
                  :headers="headers" :submit-upload-all-files="()=>submitUploadAllFiles('receiveProof')"
                  :upload-file-url="uploadFileUrl" @close="closeUploadCommitDialog" />

    <!--    添加订单 || 修改订单对话框-->
    <InfoDialog :title="orderTitle" :visible.sync="orderItemVisible">
      <template #info>
        <OrderForm @close-dialog="closeDialog"
                   :submitInfo="submitInfo"
                   :orderId="orderId"/>
      </template>
    </InfoDialog>


    <!--    陆运费和海运费申请-->
    <el-dialog :close-on-click-modal="false" :show-close="false"
               title="陆运费申请"
               :visible.sync="landFreeDialogVisible"
               width="600px">
      <keep-alive>
        <FreeApply :order-info="landFreightInfo" @close="landFreeDialogVisible = false"/>
      </keep-alive>
    </el-dialog>

    <!--    海运费申请-->
    <el-dialog :close-on-click-modal="false" :show-close="false"
               title="海运费申请"
               :visible.sync="seaFreeDialogVisible"
               width="600px">
      <keep-alive>
        <FreeApply :order-info="seaFreightInfo" @close="seaFreeDialogVisible = false"/>
      </keep-alive>
    </el-dialog>


    <!--    订单货物详情-->
    <el-dialog :close-on-click-modal="false" :show-close="false"
               title="订单货物详情"
               :visible.sync="checkOrderDetailInfoVisible"
               width="1100px" destroy-on-close>
      <!--      传递订单详情列表-->
      <OrderDetailInfo :orderDetailInfoList="orderDetailInfoList"
                       @updateOrderDetailList="handleUpdateOrderDetailInfoList"/>
      <div slot="footer" class="dialog-footer">
        <el-button @click="checkOrderDetailInfoVisible = false">关 闭</el-button>
      </div>
    </el-dialog>


    <!--    开发票-->
    <Invoice :check-rules="CheckRules" :handle-commit-back-company="handleCommitBackCompany"
             :handle-update-company-name="handleUpdateCompanyName"
             :invoiceupdate-order-item-visible-visible="invoiceupdateOrderItemVisibleVisible"
             :list-company="listCompany" :query-company-name="queryCompanyName"
             :submitupdate-order-item-visible-title="submitupdateOrderItemVisibleTitle"
             :update-order-item-visible-title="updateOrderItemVisibleTitle"
             :update-order-item-visible-title-info="updateOrderItemVisibleTitleInfo" @close="handleCloseInvoice"
             :maxInvent="maxInvent" @resetAmount="resetAmount"/>


    <!--    订单打款申请 -->
    <OrderMoneyReceive :table-name="TableName" :handle-close-apply="handleCloseApply" :need-money="needMoney"
                       :payment-apply-visible="paymentApplyVisible" :t-i-d="tID"/>


    <!--    todo url其实就是返回了后端服务器的地址加端口 这里需要后期规定好后直接拼接就能查看了 -->
    <el-dialog :close-on-click-modal="false" :show-close="false" title="查看附件" :visible.sync="checkAttachmentVisible"
               width="48%">
      <el-row v-for="(item, index) in checkFileList" :key="index">
        <el-button type="text" icon="el-icon-document" @click="checkFileItem(item)">{{ item }}</el-button>
      </el-row>
      <el-button @click="checkAttachmentVisible = false">关 闭</el-button>
    </el-dialog>


    <!-- 订单历史信息查看-->
    <OrderHistoryCheck :active-names="activeNames" :check-history-order-visible="checkHistoryOrderVisible"
                       :checkcurrent-order-item-info="checkcurrentOrderItemInfo"
                       :order-history-info-list="orderHistoryInfoList"
                       :parse-time="parseTime(new Date(),'{y}-{m}-{d}')" @close="closeOrderHistoryCheck"/>

    <!--      原订单信息-->
    <PrimativeOrderInfo :current-order-item-info="currentOrderItemInfo"
                        :current-order-item-info-visible="currentOrderItemInfoVisible"
                        @close="closePrimativeOrderInfo"/>
  </div>
</template>

<script>
import {
  delGoodsOrder,
  listGoodsOrder,
} from "@/api/system/goodsOrder";
import OrderForm from "@/views/dashboard/components/goodsOrder/OrderForm.vue";
import {mapGetters} from "vuex";
import {listBankAccount} from "@/api/system/bankAccount";
import {listCompany} from "@/api/system/company";
import OrderDetailInfo from "@/views/dashboard/components/goodsOrder/OrderDetailInfo.vue";
import {TableName} from "@/api/tool/enums";
import FreeApply from "@/components/FreeApply.vue";
import {parseTime} from "../../../utils/ruoyi";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import InfoDialog from "../../../components/InfoDialog.vue";
import Invoice from "../../dashboard/components/goodsOrder/Invoice.vue";
import OrderMoneyReceive from "../../dashboard/components/goodsOrder/OrderMoneyReceive.vue";
import OrderHistoryCheck from "../../dashboard/components/goodsOrder/OrderHistoryCheck.vue";
import PrimativeOrderInfo from "../../dashboard/components/goodsOrder/PrimativeOrderInfo.vue";
import UploadCommit from "../../dashboard/components/goodsOrder/UploadCommit.vue";
import UploadPath from "../../dashboard/components/goodsOrder/UploadPath.vue";
import OrderGiven from "../../dashboard/components/goodsOrder/OrderGiven.vue";
import CheckOrder from "../../dashboard/components/goodsOrder/CheckOrder.vue";
import QuerySearchBar from "../../dashboard/components/goodsOrder/QuerySearchBar.vue";
import {mixin_order_deliverGoods} from "../../dashboard/mixins/order/order_deliverGoods";
import {mixin_order_checkOrder} from "../../dashboard/mixins/order/order_checkOrder";
import {mixin_order_adjustOrder} from "../../dashboard/mixins/order/order_adjustOrder";
import {mixin_order_Invoice} from "../../dashboard/mixins/order/order_Invoice";
import {mixin_order_uploadFiles} from "../../dashboard/mixins/order/order_UploadFiles";
import {mixin_order_add} from "../../dashboard/mixins/order/order_addOrder";
import {mixin_order_freeApply} from "../../dashboard/mixins/order/order_freeApply";
import {mixin_order_orderHistory} from "../../dashboard/mixins/order/order_history";
import {mixin_order_goodsItemInfo} from "../../dashboard/mixins/order/order_goodsItemInfo";
import {mixin_order_audit} from "../../dashboard/mixins/order/order_audit";
import {mixin_order_applyPayment} from "../../dashboard/mixins/order/order_applyPayment";
import {mixin_order_base} from "../../dashboard/mixins/order/order_base";
import reLength from "../../dashboard/mixins/reLength";

export default {
  name: "GoodsOrder",
  // 混入 订单逻辑分布在混入文件中
  mixins: [mixin_printHTML, mixin_order_deliverGoods
    , mixin_order_checkOrder, mixin_order_adjustOrder
    , mixin_order_Invoice, mixin_order_uploadFiles
    , mixin_order_add, mixin_order_freeApply, mixin_order_orderHistory,
    mixin_order_goodsItemInfo, mixin_order_audit, mixin_order_applyPayment,
    mixin_order_base, reLength],
  // 组件注册
  components: {
    QuerySearchBar,
    CheckOrder,
    OrderGiven,
    UploadPath,
    UploadCommit,
    PrimativeOrderInfo,
    OrderHistoryCheck,
    OrderMoneyReceive,
    Invoice,
    InfoDialog,
    FreeApply,
    OrderDetailInfo,
    OrderForm
  },
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      goodsOrderList: [],
      title: "",
      updateOrderItemVisible: false,
      queryParams: {
        orderDateStart: null,
        orderDateEnd: null,
        pageNum: 1,
        pageSize: 50,
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
        cancelFlag: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},


    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('goodsorder-columns') === 'null'
      || !localStorage.getItem('goodsorder-columns')) {
      localStorage.setItem("goodsorder-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('goodsorder-columns'));
    }
  },
  mounted() {
  },

  computed: {
    TableName() {
      return TableName
    },
    ...mapGetters(['orderItemList']), // 获取订单列表
    ...mapGetters(['currentOrderInfo']) // 拿到暂存里的订单信息
  },
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("goodsorder-columns", JSON.stringify(newVal))
      },
      deep: true,
    },
    // 监听整个开票表单 如果有变化 自动监听计算票点金额
    'updateOrderItemVisibleTitleInfo': {
      handler(val) {
        this.updateOrderItemVisibleTitleInfo.ticketPointAmount = Number(this.updateOrderItemVisibleTitleInfo.invoiceAmount * this.updateOrderItemVisibleTitleInfo.ticketPoint).toFixed(3)
      },
      deep: true,
      immediate: true,
    },

  },

  methods: {
    parseTime,
    listCompany,
    listBankAccount,
    // 拖拽改变列宽
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除订单编号为"' + ids + '"的数据项？').then(function () {
        return delGoodsOrder(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      })
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/goodsOrder/export', {
        ...this.queryParams
      }, `goodsOrder_${new Date().getTime()}.xlsx`)
    },
  }
};
</script>
<style lang="scss">

.item {
  margin-right: 5px; /* 添加一些间距 */
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
</style>

