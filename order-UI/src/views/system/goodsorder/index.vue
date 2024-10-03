<!--订单页面-->
<template>
  <div class="app-container">
    <QuerySearchBar :handle-query="handleQuery" :options="options" :options-invoice="optionsInvoice"
                    :query-params="queryParams" :show-search="showSearch"/>
    <!--    表格上方操作栏-->
    <el-row :gutter="10" class="mb8">
      <!--      左侧操作栏-->
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
      <!--      右侧表格的工具栏-->
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
              id="printBox" v-horizontal-scroll="'always'"
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

      <el-table-column show-overflow-tooltip label="陆运费" align="center" prop="landFreight"
                       v-if="columns[6].visible" width="100px"/>

      <el-table-column show-overflow-tooltip label="海运车牌" align="center" prop="seaCarNo" v-if="columns[7].visible">
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
      <el-table-column show-overflow-tooltip label="海运司机姓名" align="center" prop="seaDriverName"
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
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="供应商是否开票" align="center" prop="isSupplierInvoice"
                       v-if="columns[21].visible"
                       width="120px">
        <template #default="scope">
          <el-row v-if="scope.row.isSupplierInvoice > 0">
            <el-row>
              <el-button type="success" size="mini" @click="updateOrderItemVisibleCustomerInvoice(scope.row)">继续开票
              </el-button>
            </el-row>
          </el-row>
          <el-row v-else>
            <el-row>
              <el-button type="warning" size="mini" @click="updateOrderItemVisibleSupplierInvoice(scope.row)">前去开票
              </el-button>
            </el-row>
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
    <el-dialog :show-close="false"
               title="提示"
               :visible.sync="handleOrderVisible"
               width="30%">
      <span>是否将订单设置为调整单?</span>
      <span slot="footer" class="dialog-footer">
    <el-button @click="handleOrderVisible = false">取 消</el-button>
    <el-button type="primary" @click="submitChangeOrder">确 定</el-button>
  </span>
    </el-dialog>

    <!--    点击发货单的弹窗-->
    <OrderGiven :order1-visible="Order1Visible" @close="closeOrderGivenDialog"/>

    <!--    上传附件的弹窗 -->
    <UploadPath :before-upload="beforeUpload" :file-list="fileList" :handle-upload-visible="handleUploadVisible"
                :headers="headers" :submit-upload-all-files="()=>submitUploadAllFiles('path')"
                :upload-file-url="uploadFileUrl" @close="closeUploadPathDialog"/>


    <!--    上传收到条的弹窗-->
    <UploadCommit :before-upload="beforeUpload" :file-list="fileList" :handle-commit-visible="handleCommitVisible"
                  :headers="headers" :submit-upload-all-files="()=>submitUploadAllFiles('receiveProof')"
                  :upload-file-url="uploadFileUrl" @close="closeUploadCommitDialog"/>

    <!--    添加订单 || 修改订单对话框-->
    <InfoDialog :title="orderTitle" :visible.sync="orderItemVisible">
      <template #info>
        <OrderForm @close-dialog="closeDialog"
                   :submitInfo="submitInfo"
                   :orderId="orderId"/>
      </template>
    </InfoDialog>


    <!--    陆运费和海运费申请-->
    <el-dialog :show-close="false"
               title="陆运费申请"
               :visible.sync="landFreeDialogVisible"
               width="600px">
      <keep-alive>
        <FreeApply :order-info="landFreightInfo" @close="landFreeDialogVisible = false"/>
      </keep-alive>
    </el-dialog>


    <el-dialog :show-close="false"
               title="海运费申请"
               :visible.sync="seaFreeDialogVisible"
               width="600px">
      <keep-alive>
        <FreeApply :order-info="seaFreightInfo" @close="seaFreeDialogVisible = false"/>
      </keep-alive>
    </el-dialog>


    <!--    订单货物详情-->
    <el-dialog :show-close="false"
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
             :update-order-item-visible-title-info="updateOrderItemVisibleTitleInfo" @close="handleCloseInvoice"/>


    <!--    订单打款申请 -->
    <OrderMoneyReceive :table-name="TableName" :handle-close-apply="handleCloseApply" :need-money="needMoney"
                       :payment-apply-visible="paymentApplyVisible" :t-i-d="tID"/>


    <!--    todo url其实就是返回了后端服务器的地址加端口 这里需要后期规定好后直接拼接就能查看了 -->
    <el-dialog :show-close="false" title="查看附件" :visible.sync="checkAttachmentVisible" width="48%">
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
  adjustGoodsOrder,
  auditGoodsOrder,
  delGoodsOrder,
  getGoodsOrder,
  listGoodsOrder,
  updateGoodsOrder
} from "@/api/system/goodsOrder";
import OrderForm from "@/components/OrderForm.vue";
import {mapGetters} from "vuex";
import {getToken} from "@/utils/auth";
import {excludeParams} from "@/api/tool/exclude";
import {listBankAccount} from "@/api/system/bankAccount";
import {listCompany} from "@/api/system/company";
import {listOrderFreight} from "@/api/system/orderFreight";
import {addInvoiceOut} from "@/api/system/invoiceOut";
import OrderDetailInfo from "@/components/OrderDetailInfo.vue";
import {TableName} from "@/api/tool/enums";
import FreeApply from "@/components/FreeApply.vue";
import {parseTime} from "../../../utils/ruoyi";
import {addInvoiceIn} from "@/api/system/invoiceIn";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import axios from "axios";
import {getCompany} from "../../../api/system/company";
import {getHistoryGoodsOrder} from "../../../api/system/goodsOrder";
import InfoDialog from "../../../components/InfoDialog.vue";
import {addReason} from "../../../api/system/user";
import Invoice from "./Invoice.vue";
import OrderMoneyReceive from "./OrderMoneyReceive.vue";
import OrderHistoryCheck from "./OrderHistoryCheck.vue";
import PrimativeOrderInfo from "./PrimativeOrderInfo.vue";
import UploadCommit from "./UploadCommit.vue";
import UploadPath from "./UploadPath.vue";
import OrderGiven from "./OrderGiven.vue";
import CheckOrder from "./CheckOrder.vue";
import QuerySearchBar from "./QuerySearchBar.vue";

export default {
  name: "GoodsOrder",
  mixins: [mixin_printHTML],
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
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 订单表格数据
      goodsOrderList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      updateOrderItemVisible: false,
      // 查询参数
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
      //隐藏列
      columns: [
        {key: 0, label: '日期', visible: true},
        {key: 1, label: '客户', visible: true},
        {key: 2, label: '供应商', visible: true},
        {key: 3, label: '陆运车牌', visible: true},
        {key: 4, label: '陆运司机电话', visible: true},
        {key: 5, label: '陆地司机姓名', visible: true},
        {key: 6, label: '陆运费', visible: true},
        {key: 7, label: '海运车牌', visible: true},
        {key: 8, label: '海运司机电话', visible: true},
        {key: 9, label: '海运司机姓名', visible: true},
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


      /**
       * 发货单功能
       */
      Order1Visible: false,


      /**
       * 添加订单的功能
       */
      //当前订单id
      orderId: null,
      //添加新订单的弹窗
      orderItemVisible: false,
      orderTitle: '',
      submitInfo: '',


      /**
       * 调整单功能
       */
      //调整单的id`
      tempId: '',
      //调整单的弹窗
      handleOrderVisible: false,
      //订单信息
      orderInfo: {},


      /**
       * 查看货物信息功能
       */
      //查看订单中的列表
      orderDetailInfo: {},
      checkOrderDetailInfoVisible: false,
      orderDetailInfoList: [],


      /**
       * 行操作点击查看的功能
       */
      checkOrderVisible: false,

      /**
       * 订单开票功能
       */
      // 查询字段
      queryCompanyName: '',
      // 开票选择
      options: [
        {
          value: '已审核',
          label: '已审核'
        }, {
          value: '未审核',
          label: '未审核'
        },
      ],
      optionsInvoice: [{
        value: '未开票',
        label: '未开票'
      }, {
        value: '部分开票',
        label: '部分开票'
      }, {
        value: '已开票',
        label: '已开票'
      },],
      //开票信息
      updateOrderItemVisibleTitleInfo: {},
      // 开票信息校验
      CheckRules: {
        updateOrderItemVisibleTitleRules: {
          invoiceDate: [
            {required: true, message: '请选择开票日期', trigger: 'blur'}
          ],
          invoiceObject: [
            {required: true, message: '请输入开票实体', trigger: 'blur'}
          ],
          invoiceCompanyName: [
            {required: true, message: '请输入票据单位名称', trigger: 'blur'}
          ],
          invoiceAmount: [
            {required: true, message: '请输入开票金额', trigger: 'blur'},
            // 开票金额 可以是小数
            {pattern: /^-?[0-9]+(\.[0-9]+)?$/, message: '只能输入数字和小数', trigger: 'blur'}
          ],
          companyName: [
            {required: true, message: '请输入公司名称', trigger: 'blur'}],
          // 只能是数字
          ticketPoint: [
            {required: true, message: '请输入开票点', trigger: 'blur'},
            {pattern: /^-?[0-9]+(\.[0-9]+)?$/, message: '只能输入数字', trigger: 'blur'}
          ],
          ticketPointAmount: [
            {required: true, message: '请输入开票点金额', trigger: 'blur'},
            {pattern: /^-?[0-9]+(\.[0-9]+)?$/, message: '只能输入数字', trigger: 'blur'}],
        }
      },


      /**
       * 海陆运费申请信息 海陆运费申请功能
       */
      //订单中的司机相关信息 自动填充响应的收款方账号信息
      driverInfo: {},
      //运费
      landFreightFree: 0,
      seaFreightFree: 0,
      landFreightInfo: {},
      seaFreightInfo: {},
      //运费的弹窗
      landFreeDialogVisible: false,
      seaFreeDialogVisible: false,

      /**
       * 客户或者供应商发票功能
       */
      invoiceupdateOrderItemVisibleVisible: false,
      updateOrderItemVisibleTitle: '',


      /**
       * 订单申请打款功能
       */
      tID: '',
      paymentApplyVisible: false,
      needMoney: 0,


      /**
       * 文件上传功能
       */
      //上传和收到条
      handleUploadVisible: false,
      handleCommitVisible: false,
      //上传附件临时保存当前点击订单信息
      tempOrderInfo: {
        receiveProof: ''
      },
      fileList: [],
      // 已上传后的文件名称列表
      fileNamesList: [],
      // 查看附件或者收到条的文件列表
      checkFileList: [],
      checkAttachmentVisible: false,
      //上传路径
      uploadFileUrl: process.env.VUE_APP_BASE_API + "/common/upload",
      headers: {
        Authorization: "Bearer " + getToken(),
      },

      /**
       * 查看原订单信息的功能
       */
      currentOrderItemInfo: {},
      currentOrderItemInfoVisible: false,


      /**
       * 查看订单历史信息
       */
      checkHistoryOrderVisible: false,
      // 订单历史信息列表
      orderHistoryInfoList: [],
      activeNames: [],
      // 订单详情映射对象 然后每一个订单的详情列表都按照这个映射以后进行比较渲染
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
        'seaCarNo': '海运车牌号',
        'seaDriverName': '海运司机姓名',
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
        this.updateOrderItemVisibleTitleInfo.ticketPointAmount = Number(this.updateOrderItemVisibleTitleInfo.invoiceAmount * this.updateOrderItemVisibleTitleInfo.ticketPoint).toFixed(2)
      },
      deep: true,
      immediate: true,
    }
  },
  methods: {
    parseTime,
    listCompany,
    listBankAccount,
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


    /**
     * 1.开票功能
     */
    // 点击客户开票
    updateOrderItemVisibleCustomerInvoice(row) {
      this.resetOpenTitleInfo()
      //客户开发票 即为发票卖出 添加发票卖出信息 1客户开票  2供应商开票
      this.updateOrderItemVisibleTitleInfo.domain = 1
      this.updateOrderItemVisibleTitleInfo.isOrderTax = row.id;
      this.updateOrderItemVisibleTitle = '客户开票'
      //设置该订单信息 需要进行一次查询 获取订单的开票个数
      getGoodsOrder(row.id)
          .then(res => {
            this.updateOrderItemVisibleTitleInfo.orderInfo = res.data;
            // 保存客户和供应商开票个数
            this.updateOrderItemVisibleTitleInfo.customerInvoiceNumber = res.data.customerIsInvoice
            this.updateOrderItemVisibleTitleInfo.supplierInvoiceNumber = res.data.isSupplierInvoice
            this.invoiceupdateOrderItemVisibleVisible = true;
          })
    },
    // 点击供应商开票
    updateOrderItemVisibleSupplierInvoice(row, supplierID) {
      this.resetOpenTitleInfo()
      // 如果供应商ID存在 那么就自动填充供应商的信息
      if (supplierID !== undefined && supplierID !== '' && supplierID !== null) {
        this.updateOrderItemVisibleTitleInfo.domain = 2
        this.updateOrderItemVisibleTitleInfo.companyID = supplierID;
        this.updateOrderItemVisibleTitleInfo.isOrderTax = row.id;
        // 先获取公司信息
        getCompany(supplierID).then(res => {
          this.updateOrderItemVisibleTitleInfo.companyName = res.data.companyName;
          this.updateOrderItemVisibleTitleInfo.companyType = res.data.companyType;
          this.updateOrderItemVisibleTitle = '供应商开票'
          // 获取订单信息
          getGoodsOrder(row.id)
              .then(res => {
                this.updateOrderItemVisibleTitleInfo.orderInfo = res.data;
                // 保存客户和供应商开票个数
                this.updateOrderItemVisibleTitleInfo.customerInvoiceNumber = res.data.customerIsInvoice
                this.updateOrderItemVisibleTitleInfo.supplierInvoiceNumber = res.data.isSupplierInvoice
                this.invoiceupdateOrderItemVisibleVisible = true;
              })
        })
      } else {
        this.updateOrderItemVisibleTitleInfo.domain = 2
        this.updateOrderItemVisibleTitleInfo.isOrderTax = row.id;
        this.updateOrderItemVisibleTitleInfo.isOrderTax = row.id;
        this.updateOrderItemVisibleTitle = '供应商开票'
        getGoodsOrder(row.id)
            .then(res => {
              this.updateOrderItemVisibleTitleInfo.orderInfo = res.data;
              // 保存客户和供应商开票个数
              this.updateOrderItemVisibleTitleInfo.customerInvoiceNumber = res.data.customerIsInvoice
              this.updateOrderItemVisibleTitleInfo.supplierInvoiceNumber = res.data.isSupplierInvoice
              this.invoiceupdateOrderItemVisibleVisible = true;
            })
      }
    },
    // 客户供应商开票功能
    submitupdateOrderItemVisibleTitle() {
      //排除不必要的字段
      this.updateOrderItemVisibleTitleInfo = excludeParams(this.updateOrderItemVisibleTitleInfo, this.$exclude)
      // 拿到开票个数
      const invoiceNumber = {
        customerInvoiceNumber: this.updateOrderItemVisibleTitleInfo.customerInvoiceNumber,
        supplierInvoiceNumber: this.updateOrderItemVisibleTitleInfo.supplierInvoiceNumber
      }
      //这里要判断一下 如果是客户开票 就添加发票卖出信息 如果是供应商开票 则添加发票买入信息
      if (this.updateOrderItemVisibleTitleInfo.domain === 1) {
        //客户开票 添加发票卖出信息
        addInvoiceOut(this.updateOrderItemVisibleTitleInfo)
            .then(res => {
              this.$message.success('客户开票成功~')
              this.invoiceupdateOrderItemVisibleVisible = false;
              this.resetOpenTitleInfo();
              this.getList();
              // this.updateGoodsOrderAfterOpen(invoiceNumber, this.updateOrderItemVisibleTitleInfo.domain)
            })
      } else {
        // 客户开票
        addInvoiceIn(this.updateOrderItemVisibleTitleInfo)
            .then(res => {
              this.$message.success('供应商开票成功~')
              this.invoiceupdateOrderItemVisibleVisible = false;
              this.resetOpenTitleInfo();
              this.getList();
              // this.updateGoodsOrderAfterOpen(invoiceNumber, this.updateOrderItemVisibleTitleInfo.domain)
            })
      }
    },
    // 根据类型来更新订单的开票状态
    // updateGoodsOrderAfterOpen(invoiceNumber, type) {
    //   const updateInvoiceState = (invoiceField, invoiceValue, state) => {
    //     let info = {
    //       ...this.updateOrderItemVisibleTitleInfo.orderInfo,
    //       [invoiceField]: invoiceValue,
    //       invoiceState: state
    //     };
    //     // 更新订单的开票状态
    //     updateGoodsOrder(excludeParams(info, this.$exclude))
    //         .then(res => {
    //           this.$message.success('开票状态设置成功~');
    //           this.invoiceupdateOrderItemVisibleVisible = false;
    //           this.resetOpenTitleInfo();
    //           this.getList();
    //         });
    //   };
    //   if (type === 0) { // 供应商开票
    //     if (invoiceNumber.customerInvoiceNumber === 0) {
    //       updateInvoiceState('isSupplierInvoice', invoiceNumber.supplierInvoiceNumber + 1, '部分开票');
    //     } else {
    //       updateInvoiceState('isSupplierInvoice', invoiceNumber.supplierInvoiceNumber + 1, '已开票');
    //     }
    //   } else { // 客户开票
    //     if (invoiceNumber.supplierInvoiceNumber === 0) {
    //       updateInvoiceState('customerIsInvoice', invoiceNumber.customerInvoiceNumber + 1, '部分开票');
    //     } else {
    //       updateInvoiceState('customerIsInvoice', invoiceNumber.customerInvoiceNumber + 1, '已开票');
    //     }
    //   }
    // },
    // 开票信息弹窗的搜索信息自动填充
    handleUpdateCompanyName(val) {
      this.queryCompanyName = val;
    },
    handleCommitBackCompany(val) {
      this.updateOrderItemVisibleTitleInfo.companyName = val.companyName;
      this.updateOrderItemVisibleTitleInfo.companyID = val.id;
      this.updateOrderItemVisibleTitleInfo.companyType = val.companyType;
    },


    /**
     * 2.查看订单历史修改记录功能
     */
    // 查看原订单信息
    checkcurrentOrderItemInfo() {
      this.currentOrderItemInfoVisible = true;
    },
    // 查看订单历史信息
    checkOrderHistory(row) {
      // 保存原订单的信息
      this.currentOrderItemInfo = JSON.parse(JSON.stringify(row));
      const id = row.id;
      // 查询订单历史信息
      getHistoryGoodsOrder({goodsOrderID: id}).then(res => {
        if (res.rows.length === 0) {
          this.$message.warning('没有修改记录')
          return;
        }
        this.orderHistoryInfoList = res.rows;
        for (let i = 0; i < this.orderHistoryInfoList.length - 1; i++) {
          this.orderHistoryInfoList[i].diff = {
            old: this.formatData(excludeParams(this.orderHistoryInfoList[i], this.$excludeWithUpdate)),
            new: this.formatData(excludeParams(this.orderHistoryInfoList[i + 1], this.$excludeWithUpdate)),
            updateTime: this.parseTime(this.orderHistoryInfoList[i + 1].updateTime)
          }
        }
        if (this.orderHistoryInfoList.length > 0) {
          this.orderHistoryInfoList[this.orderHistoryInfoList.length - 1].diff = {
            old: this.formatData(excludeParams(this.orderHistoryInfoList[this.orderHistoryInfoList.length - 1], this.$excludeWithUpdate)),
            new: this.formatData(excludeParams(this.currentOrderItemInfo, this.$excludeWithUpdate)),
            updateTime: this.parseTime(this.currentOrderItemInfo.updateTime)
          }
        }
        this.checkHistoryOrderVisible = true;
      })
    },

    /**
     *  3.行操作中点击查看 查看当前行订单的信息
     */
    checkOrderItemInfo(row) {
      const id = row.id;
      getGoodsOrder(id).then(res => {
        this.orderInfo = res.data
        this.orderDetailInfo = res.data.orderDetailList;
        this.checkOrderVisible = true;
      })
    },


    /**
     *  4.点击调整单按钮，调整订单
     */
    //点击调整单的弹窗
    handleOrderItemInfo(row) {
      this.handleOrderVisible = true
      this.tempId = row.id;
    },
    // 调整单
    submitChangeOrder() {
      const id = this.tempId  // 拿到上个方法赋值的状态
      // 查询该id的订单详细信息
      getGoodsOrder(id).then(res => {
        // 调整单 调用调整订单接口 传入数据 将ordersNo赋值为空 后端自动填充
        let orderInfo = res.data
        // 将每个货物信息的ordersNo赋值为空 并且去除不必要的参数
        orderInfo.orderDetailList.forEach(item => {
          item.ordersNo = '';
          item = excludeParams(item, this.$exclude)
        })
        // 去除字段
        orderInfo = excludeParams(orderInfo, this.$exclude)
        // 调整单
        adjustGoodsOrder({...orderInfo, ordersNo: '', adjustDate: parseTime(new Date())}).then(res => {
          this.$message.success('调整单提交成功')
          this.getList();
        })
        this.handleOrderVisible = false
      })
    },


    /**
     *  5.行操作中点击货物按钮，查看该订单的货物信息
     */
    handleCheckOrderDetailInfo(row) {
      //赋值 以便于给子组件id
      sessionStorage.setItem('order_id', row.id)
      //查询该订单的订单详情，根据id查询  然后扔到暂存里
      getGoodsOrder(row.id).then(res => {
        this.orderDetailInfoList = res.data.orderDetailList;
      })
      this.checkOrderDetailInfoVisible = true;
    },
    // 当订单详情组件删除个体后，这里要进行刷新列表操作
    handleUpdateOrderDetailInfoList(order_id) {
      getGoodsOrder(order_id).then(res => {
        this.orderDetailInfoList = res.data.orderDetailList;
      })
    },

    /**
     *  6.点击订单的发货单按钮 查看发货单
     */
    // 订单发货单
    handleOrder1(row) {
      this.Order1Visible = true
    },


    /**
     *  7.点击上传附件 上传附件功能
     */
    // 上传附件
    handleUpload(row) {
      this.handleUploadVisible = true
      //保存当前订单信息 现根据当前订单列表信息查询详细订单信息
      getGoodsOrder(row.id).then(res => {
        this.tempOrderInfo = res.data;
      })
    },
    handleCommit(row) {
      this.handleCommitVisible = true
      //点击收到条的时候查询当前订单详细信息
      getGoodsOrder(row.id).then(res => {
        this.tempOrderInfo = res.data;
      })
    },
    // 上传之前的钩子函数
    beforeUpload(file) {
      // 如果文件名超出20个字符那么就提示
      if (file.name.length > 20) {
        this.$message.error('文件名不能超过20个字符,请重命名后上传')
        return false
      }
      // 推入数组中 后续点击开始上传的时候 ，对数组的每一个文件进行上传
      this.fileList.push(file)
      // 阻止默认上传行为
      return false
    },

    // 点击开始上传 type是上传的类型
    async submitUploadAllFiles(type) {
      // 开始批量发请求 上传文件 上传完毕的文件会返回一个fileName 只要把上传后的fileName推入到已上传的列表
      for (let i = 0; i < this.fileList.length; i++) {
        const file = this.fileList[i];
        // 点击上传的时候 要推入到上传数组中
        const formData = new FormData();
        formData.append('file', file)
        try {
          // 调用上传接口
          const response = await axios.post(process.env.VUE_APP_BASE_API + '/common/upload', formData, {
            headers: {
              ...this.headers,
              'Content-Type': 'multipart/form-data'
            }
          })
          this.fileList.splice(i, 1);
          i--;
          // 等待
          await this.sleep(1500);
          if (response.data.code === 200) {
            this.fileNamesList.push(response.data.fileName)
            this.$message.success(`上传成功,剩余${this.fileList.length}个文件未上传`)
          } else {
            this.$message.error(response.data.msg)
          }

        } catch (e) {
          console.error(`第${this.fileList.indexOf(file) + 1}个文件上传失败:`, e);
        }
      }
      // 全部上传完事后 修改订单的附件
      this.tempOrderInfo = excludeParams(this.tempOrderInfo, this.$exclude)
      const path = this.fileNamesList.join('|')
      if (type === 'path') {
        //修改订单信息
        updateGoodsOrder({...this.tempOrderInfo, path: path})
            .then(res => {
              this.$message.success('上传附件成功')
              this.getList()
            })
        // 收到条
      } else if (type === 'receiveProof') {
        //修改订单信息
        updateGoodsOrder({...this.tempOrderInfo, receiveProof: path})
            .then(res => {
              this.$message.success('上传收到条成功')
              this.getList()
            })
      }
    },


    /**
     * 查看附件功能
     */
    //查看附件信息
    checkAttachment(row, type) {
      if (type === 'path') {
        getGoodsOrder(row.id).then(res => {
          this.checkFileList = res.data.path.split('|');
          this.checkAttachmentVisible = true;
        })
      } else {
        getGoodsOrder(row.id).then(res => {
          this.checkFileList = res.data.receiveProof.split('|');
          this.checkAttachmentVisible = true;
        })
      }
    },


    /**
     * 订单申请打款功能
     */
    // 订单申请打款
    applyForPayment(row) {
      this.paymentApplyVisible = true;
      this.tID = row.id;
    },
    handleCloseApply() {
      this.paymentApplyVisible = false
      this.getList()
    },

    /**
     * 订单审核功能 点击后审核订单
     */
    // 订单审核
    handleCheck(row) {
      //弹出确认和取消
      this.$confirm('是否审核该信息?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        //修改审核状态
        auditGoodsOrder({id: row.id, isaudit: true})
            .then(res => {
              this.$message({
                type: 'success',
                message: '操作成功~!'
              });
              this.getList()
            })
      })
    },


    /**
     *  海陆运费申请功能
     */
    //申请陆运费
    handleApplyLandFree(row) {
      //组装订单运费信息 己方银行卡信息弹窗自己选
      this.landFreightInfo = {
        ordersNo: row.ordersNo,
        freightType: '陆运',
        moneyAmount: row.landFreight,
        otherAcountsName: row.landDriverName,
        otherBankNo: row.landBankNo,
        otherBankName: row.landBankName,
        paymentState: '申请中',
        driverName: row.landDriverName,
        driverId: row.landCarID,
        carNo: row.landCarNo,
        fleet: row.fleet,
      }
      //首先去运费表查看是否有运费信息
      listOrderFreight({...this.landFreightInfo, paymentState: '未支付'}).then(res => {
        if (res.rows.length === 0) {
          this.landFreightFree = row.landFreight
          //组装司机信息
          this.driverInfo = {
            otherAcountsName: row.landDriverName,
            companyName: null,
            isExit: true,//用这个字段来表示有司机信息
          }
          this.landFreeDialogVisible = true;
        } else {
          this.$message.error('该订单已有陆运费信息!!!')
        }
      })
    },
    //申请海运费
    handleApplySeaFree(row) {
      //组装海运费信息
      this.seaFreightInfo = {
        ordersNo: row.ordersNo,
        freightType: '海运',
        moneyAmount: row.seaFreight,
        otherAcountsName: row.seaDriverName,
        otherBankNo: row.seaBankNo,
        otherBankName: row.seaBankName,
        paymentState: '申请中',
        driverName: row.seaDriverName,
        driverId: row.seaCarID,
        carNo: row.seaCarNo,
        fleet: '',
      }
      listOrderFreight({...this.seaFreightInfo, paymentState: '未支付'}).then(res => {
        if (res.rows.length === 0) {
          this.seaFreightFree = row.seaFreight
          this.driverInfo = {
            otherAcountsName: row.seaDriverName,
            companyName: null,
            isExit: true,
          }
          this.seaFreeDialogVisible = true;
        } else {
          this.$message.error('该订单已有运费信息!!!')
        }
      })

    },


    /** 查询订单列表 */
    getList() {
      this.loading = true;
      listGoodsOrder(this.queryParams).then(response => {
        this.goodsOrderList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 开票信息重置
    resetOpenTitleInfo() {
      this.updateOrderItemVisibleTitleInfo = {
        id: null,
        invoiceDate: null,
        invoiceObject: '',
        invoiceAmount: '',
        companyType: '',
        companyName: '',
        companyID: '',
        invoiceCompanyName: '',
        ticketPoint: null,
        ticketPointAmount: null,
        isOrderTax: 0,
        comments: '',
      }
    },
    // 表单重置
    reset() {
      this.orderInfo = {
        id: null,
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
        isAdjust: null,
        adjustOrderid: null,
        isedit: null,
        customerIsInvoice: null,
        isSupplierInvoice: null,
        cancelFlag: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null
      };
      this.resetForm("form");
      //清除vuex的状态
      this.$store.commit('order/CLEAR_ORDER_ITEM_LIST')
      sessionStorage.removeItem('order_id')
    },
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
    // 关闭弹窗
    closeDialog() {
      this.orderId = null
      this.orderItemVisible = false
      this.getList()
    },
    // 关闭查看订单的弹窗
    closeCheckOrderDialog() {
      this.checkOrderVisible = false
      this.reset()
    },
    // 关闭发货单的弹窗
    closeOrderGivenDialog() {
      this.Order1Visible = false;
    },
    // 关闭上传附件的弹窗
    closeUploadPathDialog() {
      this.handleUploadVisible = false
    },
    // 关闭上传收到条的弹窗
    closeUploadCommitDialog() {
      this.handleCommitVisible = false
    },
    // 关闭开票的弹窗
    handleCloseInvoice() {
      this.invoiceupdateOrderItemVisibleVisible = false
    },
    // 关闭历史订单的弹窗
    closeOrderHistoryCheck() {
      this.checkHistoryOrderVisible = false
    },
    // 关闭查看原始订单
    closePrimativeOrderInfo() {
      this.currentOrderItemInfoVisible = false
    },
    // 新增按钮操作
    handleAdd() {
      //打开新的新增框
      this.orderItemVisible = true
      this.orderTitle = '添加订单信息'
      this.submitInfo = '添加订单'
    },
    //修改订单的操作
    handleUpdate(row) {
      this.$prompt('请输入编辑订单原因', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(({value}) => {
        addReason({reason: value, tableName: TableName.GOODS_ORDER, tid: row.id, modifyTime: this.modifyTime})
            .then(res => {
              // 先暂存订单修改原因
              sessionStorage.setItem('order-edit-reason', value)
              this.$message.success('提交成功')
              this.reset();
              this.orderId = row.id
              this.orderItemVisible = true;
              this.orderTitle = '修改订单信息'
              this.submitInfo = '修改订单'
            })
      }).catch(() => {
        this.$message({
          type: 'warning',
          message: '请先输入编辑原因!'
        });
      });
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

<!--      订单货物信息-->
<!--      <el-descriptions border :title="'货物信息'+ `${index+1}` " v-for="(item,index) in orderDetailInfo" :key="index">-->
<!--        <el-descriptions-item label="供应商" v-if="item.supplier !== null && item.supplier !== ''">{{-->
<!--            item.supplier-->
<!--          }}-->
<!--        </el-descriptions-item>-->
<!--        <el-descriptions-item label="仓库名称" v-if="item.storeHouseName !== null && item.storeHouseName !== ''">-->
<!--          {{ item.storeHouseName }}-->
<!--        </el-descriptions-item>-->
<!--        <el-descriptions-item label="级别编码">{{ item.levelID }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="级别名称">{{ item.levelName }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="计量单位">{{ item.countingUnit }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="厚度">{{ item.height }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="长度">{{ item.length }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="宽度">{{ item.width }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="出厂片数">{{ item.pieces }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="每包片数">{{ item.piecesPerPack }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="包数">{{ item.packs }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="出厂单价">{{ item.price }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="出厂是否含税">{{ item.isIncludeTaxFactory }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="杂费">{{ item.sundryCost }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="出厂货款">{{ item.paymentFactory }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="卸货价">{{ item.paymentUnload }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="销售是否含税">{{ item.isIncludeTaxSale }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="总货款">{{ item.payments }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="误差">{{ item.erro }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="吨位">{{ item.tonnage }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="陆运费单价">{{ item.landFreightPrice }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="陆运费">{{ item.landFreight }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="海运费">{{ item.seaFreight }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="总运费">{{ item.freight }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="其他费用">{{ item.otherCost }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="利润">{{ item.profit }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="不含税利润">{{ item.profitNoTax }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="实际片数">{{ item.actualPieces }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="总货款杂费">{{ item.paymentsWithSundry }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="加费">{{ item.additionalFees }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="物流利润">{{ item.logisticsProfit }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="客户佣金">{{ item.customerCommission }}</el-descriptions-item>-->
<!--        <el-descriptions-item label="客户佣金">{{ item.customerCommission }}</el-descriptions-item>-->
<!--      </el-descriptions>-->


<!--//表格统计-->
<!--//自定义列统计总函数-->
<!--// getSummaries(param) {-->
<!--//   const {columns, data} = param;-->
<!--//   const sums = [];-->
<!--//   columns.forEach((column, index) => {-->
<!--//     if (index === 0) {-->
<!--//       sums[index] = '统计';-->
<!--//       return;-->
<!--//     }-->
<!--//     const values = data.map(item => {-->
<!--//       return Number(item[column.property])-->
<!--//     });-->
<!--//     if (!values.every(value => isNaN(value))) {-->
<!--//       //对指定列进行计算-->
<!--//       // if(index)-->
<!--//       //需要进行统计的索引列-->
<!--//       const out_list = [9, 10, 11]-->
<!--//       //index !== 9 && index !== 1 && index !== 16 && index !== 2-->
<!--//       if (out_list.includes(index)) {-->
<!--//         sums[index] = values.reduce((prev, curr) => {-->
<!--//           const value = Number(curr);-->
<!--//           if (!isNaN(value)) {-->
<!--//             return prev + curr;-->
<!--//           } else {-->
<!--//             return prev;-->
<!--//           }-->
<!--//         }, 0);-->
<!--//         sums[index] += ' ';-->
<!--//       }-->
<!--//     } else {-->
<!--//       sums[index] = '';-->
<!--//     }-->
<!--//   });-->
<!--//   return sums;-->
<!--// },-->
