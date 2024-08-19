<!--订单页面-->

<template>
  <div class="app-container">
    <el-form :model="timesQuery" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="100px">
      <el-form-item label="开始时间" prop="beginTime">
        <el-date-picker
          v-model="timesQuery.beginTime"
          type="date"
          placeholder="选择开始时间"
        value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="结束时间" prop="endTime">
        <el-date-picker
          v-model="timesQuery.endTime"
          type="date"
          placeholder="选择结束时间"
        value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="客户名称" prop="customer">
        <el-input
          v-model="paramQuery.customer"
          placeholder="请输入陆运车牌"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="审核状态" prop="checkState">
        <el-select v-model="paramQuery.checkState" placeholder="请选择">
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="开票状态" prop="invoiceState">
        <el-select v-model="paramQuery.invoiceState" placeholder="请选择">
          <el-option
            v-for="item in optionsInvoice"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleTimesQuery">搜索</el-button>
      </el-form-item>
    </el-form>
    <!--    表格上方操作栏-->
    <el-row :gutter="10" class="mb8">
      <!--      左侧操作栏-->
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <!--        todo 审核的时候添加审核权限 -->
        <el-button
          type="danger"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:goodsorder:add']"
        >添加订单信息
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:goodsorder:export']"
        >导出订单数据
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
        <!--        导出-->
        <template v-slot:export>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport"
              v-hasPermi="['system:orderdetail:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>
    <!--    表格列-->
    <el-table border v-loading="loading" :data="goodsOrderList" @selection-change="handleSelectionChange"
              id="printBox" :row-class-name="tableRowClassName" v-horizontal-scroll="'always'"
              max-height="500">
      <!--      左侧操作栏-->
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="170px" fixed="left">
        <template slot-scope="scope">
          <el-button
            size="mini"
            @click="checkOrderItemInfo(scope.row)"
          >查看
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
            type="warning"
            @click="handleCheckOrderDetailInfo(scope.row)"
          >订单详情
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:goodsorder:remove']"
          >删除
          </el-button>
        </template>
      </el-table-column>
      <!--      固定列-->
      <el-table-column label="日期" align="center" prop="orderDate" fixed="left"/>
      <el-table-column label="客户" align="center" prop="customer" fixed="left"/>
      <el-table-column label="订单编号" align="center" prop="ordersNo" v-if="columns[0].visible"/>
      <el-table-column label="陆运车牌" align="center" prop="landCarNo" v-if="columns[1].visible"/>
      <el-table-column label="陆运司机电话" align="center" prop="landDriverTel" v-if="columns[2].visible"/>
      <el-table-column label="陆地司机姓名" align="center" prop="landDriverName" v-if="columns[3].visible"/>
      <el-table-column label="海运车牌" align="center" prop="seaCarNo" v-if="columns[4].visible"/>
      <el-table-column label="海运司机电话" align="center" prop="seaDriverTel" v-if="columns[5].visible"/>
      <el-table-column label="海运司机姓名" align="center" prop="seaDriverName" v-if="columns[6].visible"/>
      <el-table-column label="销售经理" align="center" prop="saleManager" v-if="columns[7].visible"/>
      <el-table-column label="车队" align="center" prop="fleet" v-if="columns[8].visible"/>
      <el-table-column label="审核状态" align="center" prop="checkState" v-if="columns[9].visible" width="120">
        <template slot-scope="scope">
          <SwitchBarForCheck :model-value="scope.row.checkState==='未审核'"
                             @update:modelValue="handleOpenCheck($event,scope.row)"/>
        </template>
      </el-table-column>
      <el-table-column label="开票状态" align="center" prop="invoiceState" v-if="columns[10].visible" width="120px">
        <template slot-scope="scope">
          <SwitchBarItem :model-value="scope.row.customerIsInvoice==='未开票'"
                         @update:modelValue="handleOpenTitle($event,scope.row)"/>
        </template>
      </el-table-column>
      <!--  todo    压缩上传-->
      <el-table-column label="附件路径" align="center" prop="path" v-if="columns[11].visible"/>

      <el-table-column label="打款状态" align="center" prop="paymentState"
                       v-if="columns[12].visible">
        <template slot-scope="scope">
          <el-tag
            disable-transitions>{{ scope.row.paymentState }}
          </el-tag>
        </template>
      </el-table-column>
      <!--      <el-table-column label="陆运银行户名" align="center" prop="landBankName" v-if="columns[13].visible"/>-->
      <!--      <el-table-column label="陆运银行账号" align="center" prop="landBankNo" v-if="columns[14].visible"/>-->
      <!--      <el-table-column label="海运银行户名" align="center" prop="seaBankName" v-if="columns[15].visible"/>-->
      <!--      <el-table-column label="海运银行账号" align="center" prop="seaBankNo" v-if="columns[16].visible"/>-->
      <el-table-column label="收到条附件路径" align="center" prop="receiveProof" v-if="columns[17].visible"/>
      <el-table-column label="是否被调整单" align="center" prop="isAdjusted" v-if="columns[18].visible">
        <template slot-scope="scope">
          <el-tag
            :type="scope.row.isAdjusted === '否' ? 'danger' :'success'"
            disable-transitions>{{ scope.row.isAdjusted }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="是否调整单" align="center" prop="isAdjust" v-if="columns[19].visible">
        <template slot-scope="scope">
          <el-tag
            :type="scope.row.isAdjust === '否' ? 'danger' :'success'"
            disable-transitions>{{ scope.row.isAdjust }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="调整日期" align="center" prop="adjustDate" v-if="columns[20].visible"/>
      <el-table-column label="原订单编号" align="center" prop="adjustOrderid" v-if="columns[21].visible"/>
      <el-table-column label="是否可编辑" align="center" prop="isedit" v-if="columns[22].visible">
        <template slot-scope="scope">
          <el-tag
            :type="scope.row.isedit === 0 ? 'danger' :'success'"
            disable-transitions>{{ isOrNot(scope.row.isedit) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="客户是否开票" align="center" prop="customerIsInvoice" v-if="columns[23].visible"
                       width="150px">
        <template slot-scope="scope">
          <SwitchBarItem :model-value="scope.row.customerIsInvoice===1"
                         @update:modelValue="handleOpenTitle"/>
        </template>
      </el-table-column>
      <el-table-column label="供应商是否开票" align="center" prop="isSupplierInvoice" v-if="columns[24].visible"
                       width="120px">
        <template slot-scope="scope">
          <SwitchBarItem :model-value="scope.row.customerIsInvoice===1"
                         @update:modelValue="handleOpenTitle"/>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[25].visible"/>
      <!--      右侧操作栏-->
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="300px" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            @click="handleOrder1(scope.row)"
            v-hasPermi="['system:goodsorder:edit']"
          >发货单
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleUpload(scope.row)"
          >上传附件
          </el-button>
          <el-button
            size="mini"
            @click="handleCommit(scope.row)"
            v-hasPermi="['system:goodsorder:remove']"
          >上传收到条
          </el-button>

          <el-button
            v-if="scope.row.landFreight>0"
            size="mini"
            type="warning"
            @click="handleApplyLandFree(scope.row)"
            v-hasPermi="['system:goodsorder:remove']"
          >陆运费申请
          </el-button>
          <el-button
            v-if="scope.row.seaFreight>0"
            type="primary"
            size="mini"
            @click="handleApplySeaFree(scope.row)"
            v-hasPermi="['system:goodsorder:remove']"
          >海运费申请
          </el-button>
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
    <el-dialog
      title="查看订单信息"
      :visible.sync="checkOrderVisible"
      width="30%">
      <el-descriptions title="订单信息" :column="1" border>
        <el-descriptions-item label="日期">{{ orderDetailInfo.orderDate }}</el-descriptions-item>
        <el-descriptions-item label="客户">{{ orderDetailInfo.customer }}</el-descriptions-item>
        <el-descriptions-item label="商家姓名">{{ orderDetailInfo.supplierNames }}</el-descriptions-item>
        <el-descriptions-item label="车队">{{ orderDetailInfo.fleet }}</el-descriptions-item>
        <el-descriptions-item label="审核状态">
          <TagsItem :check-info="orderDetailInfo.checkState" checkValue="未审核"/>
        </el-descriptions-item>
        <el-descriptions-item label="开票状态">
          <TagsItem :check-info="orderDetailInfo.invoiceState" checkValue="未开票"/>
        </el-descriptions-item>
        <el-descriptions-item label="附件">{{ orderDetailInfo.path }}</el-descriptions-item>
        <el-descriptions-item label="陆运车牌">{{ orderDetailInfo.landCarNo }}</el-descriptions-item>
        <el-descriptions-item label="陆运司机电话">{{ orderDetailInfo.landDriverTel }}</el-descriptions-item>
        <el-descriptions-item label="陆运司机姓名">{{ orderDetailInfo.landDriverName }}</el-descriptions-item>
        <el-descriptions-item label="海运车牌">{{ orderDetailInfo.seaCarNo }}</el-descriptions-item>
        <el-descriptions-item label="海运司机电话">{{ orderDetailInfo.seaDriverTel }}</el-descriptions-item>
        <el-descriptions-item label="海运司机姓名">{{ orderDetailInfo.seaDriverName }}</el-descriptions-item>
        <el-descriptions-item label="打款状态">{{ orderDetailInfo.PaymentState }}</el-descriptions-item>
        <el-descriptions-item label="陆运银行户名">{{ orderDetailInfo.landBankName }}</el-descriptions-item>
        <el-descriptions-item label="陆运银行账号">{{ orderDetailInfo.landBankNo }}</el-descriptions-item>
        <el-descriptions-item label="海运银行户名">{{ orderDetailInfo.seaBankName }}</el-descriptions-item>
        <el-descriptions-item label="海运银行账号">{{ orderDetailInfo.seaBankNo }}</el-descriptions-item>
        <el-descriptions-item label="收到条附件">{{ orderDetailInfo.receiveProof }}</el-descriptions-item>
        <el-descriptions-item label="是否被调整单">
          <TagsItem :check-info="orderDetailInfo.isAdjusted " check-value="否"/>
        </el-descriptions-item>
        <el-descriptions-item label="调整日期" v-if="orderDetailInfo.isAdjusted">{{
            orderDetailInfo.adjustDate
          }}
        </el-descriptions-item>
        <el-descriptions-item label="原订单编号">{{ orderDetailInfo.adjustOrderid }}</el-descriptions-item>
        <el-descriptions-item label="是否可编辑">
          <TagsItem :check-info="isOrNot(orderDetailInfo.isedit) " check-value="否"/>
        </el-descriptions-item>
        <el-descriptions-item label="客户是否开票">
          <TagsItem :check-info="isOrNot(orderDetailInfo.customerIsInvoice)" check-value="否"/>
        </el-descriptions-item>
        <el-descriptions-item label="供应商是否开票">
          <TagsItem :check-info="isOrNot(orderDetailInfo.customerIsInvoice)" check-value="否"/>
        </el-descriptions-item>
        <el-descriptions-item label="陆运费">{{ orderDetailInfo.landFreight }}</el-descriptions-item>
        <el-descriptions-item label="海运费">{{ orderDetailInfo.seaFreight }}</el-descriptions-item>
      </el-descriptions>
      <span slot="footer" class="dialog-footer">
        <el-button @click="checkOrderVisible = false">取 消</el-button>
        <el-button type="primary" @click="checkOrderVisible = false">确 定</el-button>
      </span>
    </el-dialog>


    <!--    点击调整单的弹窗-->
    <el-dialog
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
    <el-dialog
      title="发货单"
      :visible.sync="Order1Visible"
      width="75%">
      <!--      发货单主体-->
      <el-row>
        <ChatForm/>
      </el-row>
      <span slot="footer" class="dialog-footer">
    <el-button @click="Order1Visible = false">取 消</el-button>
    <el-button type="primary" @click="Order1Visible = false">确 定</el-button>
  </span>
    </el-dialog>

    <!--    上传附件的弹窗-->
    <el-dialog
      title="上传附件"
      :visible.sync="handleUploadVisible"
      width="30%">
      <file-upload is-show-tip @input="handleBackUpload"/>
      <span slot="footer" class="dialog-footer">
    <el-button @click="handleUploadVisible = false">取 消</el-button>
    <el-button type="primary" @click="handleUploadVisible = false">确 定</el-button>
  </span>
    </el-dialog>

    <!--    上传收到条的弹窗-->
    <el-dialog
      title="提示"
      :visible.sync="handleCommitVisible"
      width="30%">
      <file-upload @input="handleCommitGet"/>
      <span slot="footer" class="dialog-footer">
    <el-button @click="handleCommitVisible = false">取 消</el-button>
    <el-button type="primary" @click="handleCommitVisible = false">确 定</el-button>
  </span>
    </el-dialog>


    <!--    添加订单的新弹窗 原有的新增不使用-->
    <el-dialog
      title="订单信息"
      :visible.sync="addOrderItemVisible"
      width="80%">
      <!--      添加订单 传递本组件的orderInfo信息 -->
      <OrderForm :orderInfo="orderInfo" @updateOrderInfo="handleChangeOrderInfo"/>
      <span slot="footer" class="dialog-footer">
    <el-button @click="cancelSubmit">取 消</el-button>
    <el-button type="primary" @click="submitOrder">添加订单</el-button>
  </span>
    </el-dialog>


    <!--    开票弹窗-->
    <el-dialog
      title="开票"
      :visible.sync="handleOpenTitleDialogVisible"
      width="30%">
      <el-form :model="openTitleInfo" label-width="110px">
        <el-form-item label="开票日期" prop="invoiceDate">
          <el-date-picker
            v-model="openTitleInfo.invoiceDate"
            type="date"
            placeholder="选择日期"
            value-format="yyyy-MM-dd">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="我方开票实体" prop="invoiceObject">
          <el-input v-model="openTitleInfo.invoiceObject" placeholder="请输入我方开票实体"/>
        </el-form-item>
        <el-form-item label="开票金额" prop="invoiceAmount">
          <el-input v-model="openTitleInfo.invoiceAmount" placeholder="请输入开票金额"/>
        </el-form-item>
        <el-form-item label="公司名称" prop="companyName">
          <el-row>
            <el-col :span="10">
              <el-input v-model="openTitleInfo.companyName" placeholder="请输入对方公司名称"/>
            </el-col>
            <el-col :span="2">
              <SearchOption :limit-info="{}" :get-data="listCompany" query-info="companyName"
                            query-label="公司名称" :query-name="queryCompanyName"
                            @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
                <template #table-columns>
                  <el-table-column label="客户" align="center" prop="relationName"/>
                  <el-table-column label="老板姓名" align="center" prop="leader"/>
                  <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                  <el-table-column label="区域" align="center" prop="region"/>
                  <el-table-column label="公司名称" align="center" prop="companyName"/>
                  <el-table-column label="销售经理" align="center" prop="salesManager"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="票据单位名称" prop="invoiceCompanyName">
          <el-input v-model="openTitleInfo.invoiceCompanyName" placeholder="请输入票据单位名称"/>
        </el-form-item>
        <el-form-item label="票点" prop="ticketPoint">
          <el-input v-model="openTitleInfo.ticketPoint" placeholder="请输入票点"/>
        </el-form-item>
        <el-form-item label="票点金额" prop="ticketPointAmount">
          <el-input v-model="invoiceAmount" placeholder="请输入票点金额" disabled/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="openTitleInfo.comments" placeholder="请输入备注"/>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
    <el-button @click="closeOpenTitle">取 消</el-button>
    <el-button type="primary" @click="submitOpenTitle">确 定</el-button>
  </span>
    </el-dialog>

    <!--    陆运费申请 指定destroy-on-close来销毁dialog的元素让其下次打开重新渲染 从而反复执行created-->
    <el-dialog
      title="陆运费申请"
      :visible.sync="landFreeDialogVisible"
      width="50%" destroy-on-close>
      <FreeApply :order-info="landFreightInfo"/>
    </el-dialog>

    <!--    海运费申请 :key="keyFlag"-->
    <el-dialog
      title="海运费申请"
      :visible.sync="seaFreeDialogVisible"
      width="50%" destroy-on-close>
      <FreeApply :order-info="seaFreightInfo"/>
    </el-dialog>


    <!--    订单详情-->
    <el-dialog
      title="订单详情"
      :visible.sync="checkOrderDetailInfoVisible"
      width="70%" destroy-on-close>
      <!--      传递订单详情列表-->
      <OrderDetailInfo :orderDetailInfoList="orderDetailInfoList"/>
    </el-dialog>
  </div>
</template>

<script>
import {
  listGoodsOrder,
  getGoodsOrder,
  delGoodsOrder,
  addGoodsOrder,
  updateGoodsOrder,
  adjustGoodsOrder, auditGoodsOrder
} from "@/api/system/goodsOrder";
import TagsItem from "@/components/TagsItem/index.vue";
import OrderForm from "@/components/OrderForm.vue";
import {mapGetters} from "vuex";
import {getToken} from "@/utils/auth";
import {excludeParams} from "@/api/tool/exclude";
import SearchOption from "@/components/SearchOption.vue";
import {listBankAccount} from "@/api/system/bankAccount";
import {listCompany} from "@/api/system/company";
import {addRebate} from "@/api/system/Rebate";
import {formatDate} from "@/utils";
import {addOrderFreight, listOrderFreight} from "@/api/system/orderFreight";
import SwitchBarItem from "@/components/SwitchBarItem.vue";
import SwitchBarForCheck from "@/components/SwitchBarForCheck.vue";
import ApplyPayment from "@/components/ApplyPayment.vue";
import ChatForm from "@/components/ChatForm.vue";
import {addInvoiceOut} from "@/api/system/invoiceOut";
import OrderDetail from "@/views/system/orderdetail/index.vue";
import OrderDetailInfo from "@/components/OrderDetailInfo.vue";
import {listPaymentApply} from "@/api/system/paymentApply";
import Vue from "vue";
import {TableName} from "@/api/tool/enums";
import FreeApply from "@/components/FreeApply.vue";

export default {
  name: "GoodsOrder",
  components: {
    FreeApply,
    OrderDetailInfo,
    OrderDetail, ChatForm, ApplyPayment, SwitchBarForCheck, SwitchBarItem, SearchOption, OrderForm, TagsItem
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
      //key强制重新渲染组件
      keyFlag: 0,
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
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
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      timesQuery: {},
      paramQuery: {},
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
      //隐藏列
      columns: [
        {key: 0, label: `订单编号`, visible: true},
        {key: 1, label: `陆运车牌`, visible: true},
        {key: 2, label: `陆运司机电话`, visible: true},
        {key: 3, label: `陆运司机姓名`, visible: true},
        {key: 4, label: `海运车牌`, visible: true},
        {key: 5, label: `海运司机电话`, visible: true},
        {key: 6, label: `海运司机姓名`, visible: true},
        {key: 7, label: `销售经理`, visible: true},
        {key: 8, label: `车队`, visible: true},
        {key: 9, label: `审核状态`, visible: true},
        {key: 10, label: `开票状态`, visible: true},
        {key: 11, label: `附件路径`, visible: true},
        {key: 12, label: `打款状态`, visible: true},
        {key: 13, label: `陆运银行户名`, visible: true},
        {key: 14, label: `陆运银行账号`, visible: true},
        {key: 15, label: `海运银行户名`, visible: true},
        {key: 16, label: `海运银行账号`, visible: true},
        {key: 17, label: `收到条附件路径`, visible: true},
        {key: 18, label: `是否被调整单`, visible: true},
        {key: 19, label: `是否调整单`, visible: true},
        {key: 20, label: `调整日期`, visible: true},
        {key: 21, label: `原订单编号`, visible: true},
        {key: 22, label: `是否可编辑`, visible: true},
        {key: 23, label: `客户是否开票`, visible: true},
        {key: 24, label: `供应商是否开票`, visible: true},
        {key: 25, label: `备注`, visible: true},
      ],
      //顶部条件搜索
      queryOrderInfo: {},
      //点击查看的弹窗
      checkOrderVisible: false,
      //调整单的弹窗
      handleOrderVisible: false,
      //订单弹窗
      Order1Visible: false,
      //上传和收到条
      handleUploadVisible: false,
      handleCommitVisible: false,
      //添加新订单的弹窗
      addOrderItemVisible: false,
      //开票
      handleOpenTitleDialogVisible: false,
      //查看订单中的列表
      orderDetailInfo: {},

      //添加订单详情
      addOrderItem: {},
      //调整单的id
      tempId: '',
      //订单输入详情信息
      orderInfo: {},
      //上传附件临时保存当前点击订单信息
      tempOrderInfo: {},
      //运费的弹窗
      landFreeDialogVisible: false,
      seaFreeDialogVisible: false,
      //订单详情的
      checkOrderDetailInfoVisible: false,
      orderDetailInfoList: [],
      //运费
      landFreightFree: 0,
      seaFreightFree: 0,
      //订单中的司机相关信息 自动填充响应的收款方账号信息
      driverInfo: {},
      //开票信息
      openTitleInfo: {
        id: null,
        invoiceDate: null,
        invoiceObject: null,
        invoiceAmount: null,
        companyType: null,
        companyName: null,
        companyID: null,
        invoiceCompanyName: null,
        ticketPoint: null,
        ticketPointAmount: null,
        isOrderTax: 0,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null
      },
      //当前订单id
      currentOrderId: null,
      queryCompanyName: '',
      //付款申请信息列表 用于判断海运费和陆运费按钮是否可用
      paymentApplyInfoList: [],
      isFreight: '',
      //陆运费信息
      landFreightInfo: {},
      seaFreightInfo: {},

    };
  },
  created() {
    this.getList();
    this.$store.dispatch('order/getOrderList')
  },
  computed: {
    TableName() {
      return TableName
    },
    //票点金额 开票金额*票点
    invoiceAmount: {
      set(val) {
        this.openTitleInfo.ticketPointAmount = val;
      },
      get() {
        return this.openTitleInfo.invoiceAmount * this.openTitleInfo.ticketPoint
      }
    },
    //获取订单列表
    ...mapGetters(['orderItemList']),
    ...mapGetters(['orderList']),
    //拿到暂存里的订单信息
    ...mapGetters(['currentOrderInfo'])
  },
  //监听开票表单的变化 如果有 就赋值
  watch: {
    openTitleInfo: {
      handler(val) {
        this.invoiceAmount = this.openTitleInfo.invoiceAmount * this.openTitleInfo.ticketPoint;
      },
      deep: true
    }
  },
  methods: {
    cancelSubmit() {
      this.orderInfo = {};
      this.addOrderItemVisible = false
      //清空订单详情填写信息
      this.$store.dispatch('order/clearOrderItemList');
      //清空订单列表基础信息
      this.orderInfo = {}
    },
    //时间查询
    handleTimesQuery() {
      //重新赋值
      this.goodsOrderList = this.orderList;
      if (Object.keys(JSON.parse(JSON.stringify(this.paramQuery))).length !== 0) {
        this.goodsOrderList = this.goodsOrderList.filter(obj => {
          let exclude = Object.entries(JSON.parse(JSON.stringify(this.paramQuery))) //填写的参数列表 判断item的某个属性
          return exclude.every((item) => {
            return obj.hasOwnProperty(item[0]) && obj[item[0]] === item[1];
          })
        })
        if (this.timesQuery.beginTime && this.timesQuery.endTime) {
          this.goodsOrderList =
            this.$dateRange(this, 'goodsOrderList', 'orderDate', this.timesQuery.beginTime, this.timesQuery.endTime);
        }
      } else {
        this.goodsOrderList =
          this.$dateRange(this, 'goodsOrderList', 'orderDate', this.timesQuery.beginTime, this.timesQuery.endTime);
      }
    },
    listCompany,
    listBankAccount,
    //子组件提醒父组件修改orderInfo信息
    handleChangeOrderInfo(val) {
      this.orderInfo = val;
    },

    //是或者否
    isOrNot(val) {
      return val === 1 ? "是" : "否";
    },
    //点击查看
    checkOrderItemInfo(row) {
      this.checkOrderVisible = true;
      const id = row.id;
      getGoodsOrder(id).then(res => {
        this.orderDetailInfo = res.data;
      })
    },
    //点击调整单的弹窗
    handleOrderItemInfo(row) {
      this.handleOrderVisible = true
      this.tempId = row.id;
    },
    //查看订单详情列表
    handleCheckOrderDetailInfo(row) {
      //查询该订单的订单详情，根据id查询  然后扔到暂存里
      getGoodsOrder(row.id).then(res => {
        this.orderDetailInfoList = res.data.orderDetailList;
      })
      this.checkOrderDetailInfoVisible = true;
    },

    //订单发货单
    handleOrder1(row) {
      this.Order1Visible = true
    },

    //todo 压缩上传和收到条
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
    //收到条回调
    handleCommitGet(value) {
      this.tempOrderInfo.receiveProof = value;
      excludeParams(this.tempOrderInfo, this.$exclude)
      //更新订单状态
      updateGoodsOrder(this.tempOrderInfo).then(res => {
        console.log(res)
      })
    },

    //上传组件的回调
    handleBackUpload(val) {
      //去除不必要字段
      this.tempOrderInfo = excludeParams(this.tempOrderInfo, this.$exclude)
      //修改订单信息
      updateGoodsOrder({...this.tempOrderInfo, path: val})
        .then(res => {
          this.$message.success('上传成功')
        })
    },

    //调整单
    submitChangeOrder() {
      const id = this.tempId
      //查询该id的订单详细信息
      getGoodsOrder(id).then(res => {
        //调整单 调用调整订单接口 传入数据
        //todo 将ordersNo赋值为空
        let orderInfo = res.data
        for (let i = 0; i < orderInfo.orderDetailList.length; i++) {
          orderInfo.orderDetailList[i].ordersNo = ''
        }
        //去除字段
        orderInfo.delFlag = null;
        orderInfo.addtime = null;
        orderInfo.updateTime = null;
        orderInfo.userId = null;
        orderInfo.cancelFlag = null;
        //调整单
        adjustGoodsOrder({...orderInfo, ordersNo: '', adjustDate: new Date().getTime()}).then(res => {
          this.$message.success('调整单提交成功')
          this.getList();
        })
        this.handleOrderVisible = false
      })
    },

    //表格中的列自定义样式信息 渲染的时候每一个列都会执行这个函数
    tableRowClassName({row, rowIndex}) {
    },

    //提交订单
    //订单列表的对象封装一个，订单详情有两个一样的对象 对应供应商发货和仓库发货
    submitOrder() {
      this.addOrderItemVisible = false
      this.orderInfo.orderDetailList = this.orderItemList; //从vuex拿到订单详细列表 加入到订单信息中
      //订单详情添加客户信息
      for (let i = 0; i < this.orderItemList.length; i++) {
        let item = this.orderItemList[i];
        item.customerID = this.orderInfo.customerID;
        item.customer = this.orderInfo.customer;
        //是否含税
        item.isIncludeTaxFactory = item.isIncludeTaxFactory === '是' ? '1' : '0';
        item.isIncludeTaxSale = item.isIncludeTaxSale === '是' ? '1' : '0';
        //时间处理
      }
      //添加订单 转化时间戳
      addGoodsOrder({...this.orderInfo, PaymentState: ''}).then(res => {
        this.$message.success('订单提交成功')
      })
    },

    //表格统计
    //自定义列统计总函数
    getSummaries(param) {
      const {columns, data} = param;
      const sums = [];
      columns.forEach((column, index) => {
        if (index === 0) {
          sums[index] = '统计';
          return;
        }
        const values = data.map(item => {
          return Number(item[column.property])
        });
        if (!values.every(value => isNaN(value))) {
          //对指定列进行计算
          // if(index)
          //需要进行统计的索引列
          const out_list = [9, 10, 11]
          //index !== 9 && index !== 1 && index !== 16 && index !== 2
          if (out_list.includes(index)) {
            sums[index] = values.reduce((prev, curr) => {
              const value = Number(curr);
              if (!isNaN(value)) {
                return prev + curr;
              } else {
                return prev;
              }
            }, 0);
            sums[index] += ' ';
          }
        } else {
          sums[index] = '';
        }
      });
      return sums;
    },


    //开票信息弹窗
    handleUpdateCompanyName(val) {
      this.queryCompanyName = val;
    },
    handleCommitBackCompany(val) {
      this.openTitleInfo.companyName = val.companyName;
      this.openTitleInfo.companyID = val.id;
      this.openTitleInfo.companyType = val.companyType;
    },
    //val是选中行的订单信息 包含订单详细信息
    handleOpenTitle(event, val) {
      console.log(event, val)
      //先把订单信息扔进暂存
      this.$store.dispatch('trash/setCurrentOrderInfo', val)
      // //这里是反的,如果是true,代表未开票 false代表已开票
      if (event) {
        //关闭开票
        alert('关闭订单开票操作')
      } else {
        //准备开票 传递订单的id
        this.currentOrderId = val.id
        this.handleOpenTitleDialogVisible = true;
      }
    },
    //添加开票 是否订单开票要给订单id
    submitOpenTitle() {
      //排除不必要的字段
      this.openTitleInfo = excludeParams(this.openTitleInfo, this.$exclude)
      //传入订单id
      this.openTitleInfo.isOrderTax = this.currentOrderId;
      //添加开票信息
      this.$wait();
      addInvoiceOut(this.openTitleInfo).then(response => {
        this.$modal.msgSuccess("开票成功~");
        this.handleOpenTitleDialogVisible = false;
        this.$close();
        this.getList();
      }).catch(err => {
        this.$close();
      })
      let info = {...this.currentOrderInfo, invoiceState: '已开票'} //修改后的订单信息
      //修改开票信息
      setTimeout(() => {
        this.$wait();
        //排除不必要字段
        updateGoodsOrder(excludeParams(info, this.$exclude)).then(res => {
          this.$message.success('开票状态设置成功~')
          this.$close();
        })
      }, 20)
    },
    closeOpenTitle() {
      this.handleOpenTitleDialogVisible = false
      setTimeout(() => {
        location.reload()
      }, 200)
    },
    handleOpenCheck(val, row) {
      if (!val) {
        auditGoodsOrder({id: row.id, isaudit: true}).then(res => {
          this.$message.success('审核成功')
        })
      }
    },
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
          // this.keyFlag += 1 //让dialog组件重新渲染
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
    //打印
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
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
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
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
    /** 新增按钮操作 */
    handleAdd() {
      // this.reset();
      // this.open = true;
      // this.title = "添加订单";

      //打开新的新增框
      this.addOrderItemVisible = true
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getGoodsOrder(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改订单";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateGoodsOrder(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addGoodsOrder(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
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
    }
  }
};
</script>


<!-- 添加或修改订单对话框 -->
<!--    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>-->
<!--      <el-form ref="form" :model="form" :rules="rules" label-width="80px">-->
<!--        <el-form-item label="订单编号" prop="ordersNo">-->
<!--          <el-input v-model="form.ordersNo" placeholder="请输入订单编号"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="日期" prop="orderDate">-->
<!--          <el-input v-model="form.orderDate" placeholder="请输入日期"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="客户" prop="customer">-->
<!--          <el-input v-model="form.customer" placeholder="请输入客户"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="客户ID" prop="customerID">-->
<!--          <el-input v-model="form.customerID" placeholder="请输入客户ID"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="陆运车辆ID" prop="landCarID">-->
<!--          <el-input v-model="form.landCarID" placeholder="请输入陆运车辆ID"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="陆运车牌" prop="landCarNo">-->
<!--          <el-input v-model="form.landCarNo" placeholder="请输入陆运车牌"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="陆运司机电话" prop="landDriverTel">-->
<!--          <el-input v-model="form.landDriverTel" placeholder="请输入陆运司机电话"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="陆地司机姓名" prop="landDriverName">-->
<!--          <el-input v-model="form.landDriverName" placeholder="请输入陆地司机姓名"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="海运车辆ID" prop="seaCarID">-->
<!--          <el-input v-model="form.seaCarID" placeholder="请输入海运车辆ID"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="海运车牌" prop="seaCarNo">-->
<!--          <el-input v-model="form.seaCarNo" placeholder="请输入海运车牌"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="海运司机电话" prop="seaDriverTel">-->
<!--          <el-input v-model="form.seaDriverTel" placeholder="请输入海运司机电话"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="海运司机姓名" prop="seaDriverName">-->
<!--          <el-input v-model="form.seaDriverName" placeholder="请输入海运司机姓名"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="审核人编号" prop="checkUserId">-->
<!--          <el-input v-model="form.checkUserId" placeholder="请输入审核人编号"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="审核状态" prop="checkState">-->
<!--          <el-input v-model="form.checkState" placeholder="请输入审核状态"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="开票状态" prop="invoiceState">-->
<!--          <el-input v-model="form.invoiceState" placeholder="请输入开票状态"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="附件路径" prop="path">-->
<!--          <el-input v-model="form.path" placeholder="请输入附件路径"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="打款状态(申请中，已打款，未打款)" prop="PaymentState">-->
<!--          <el-input v-model="form.PaymentState" placeholder="请输入打款状态(申请中，已打款，未打款)"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="陆运银行户名" prop="landBankName">-->
<!--          <el-input v-model="form.landBankName" placeholder="请输入陆运银行户名"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="陆运银行账号" prop="landBankNo">-->
<!--          <el-input v-model="form.landBankNo" placeholder="请输入陆运银行账号"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="海运银行户名" prop="seaBankName">-->
<!--          <el-input v-model="form.seaBankName" placeholder="请输入海运银行户名"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="海运银行账号" prop="seaBankNo">-->
<!--          <el-input v-model="form.seaBankNo" placeholder="请输入海运银行账号"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="收到条附件路径" prop="receiveProof">-->
<!--          <el-input v-model="form.receiveProof" type="textarea" placeholder="请输入内容"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="销售经理" prop="saleManager">-->
<!--          <el-input v-model="form.saleManager" placeholder="请输入销售经理"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="车队" prop="fleet">-->
<!--          <el-input v-model="form.fleet" placeholder="请输入车队"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="是否被调整单" prop="isAdjusted">-->
<!--          <el-input v-model="form.isAdjusted" placeholder="请输入是否被调整单"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="调整日期" prop="adjustDate">-->
<!--          <el-input v-model="form.adjustDate" placeholder="请输入调整日期"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="是否调整单" prop="isAdjust">-->
<!--          <el-input v-model="form.isAdjust" placeholder="请输入是否调整单"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="原订单编号" prop="adjustOrderid">-->
<!--          <el-input v-model="form.adjustOrderid" placeholder="请输入原订单编号"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="是否可编辑" prop="isedit">-->
<!--          <el-input v-model="form.isedit" placeholder="请输入是否可编辑"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="客户是否开票" prop="customerIsInvoice">-->
<!--          <el-input v-model="form.customerIsInvoice" placeholder="请输入客户是否开票"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="供应商是否开票" prop="isSupplierInvoice">-->
<!--          <el-input v-model="form.isSupplierInvoice" placeholder="请输入供应商是否开票"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="作废标记" prop="cancelFlag">-->
<!--          <el-input v-model="form.cancelFlag" placeholder="请输入作废标记"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="备注" prop="comments">-->
<!--          <el-input v-model="form.comments" placeholder="请输入备注"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="添加时间" prop="addtime">-->
<!--          <el-input v-model="form.addtime" placeholder="请输入添加时间"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="操作人员ID" prop="userId">-->
<!--          <el-input v-model="form.userId" placeholder="请输入操作人员ID"/>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="操作人员姓名" prop="UserName">-->
<!--          <el-input v-model="form.UserName" placeholder="请输入操作人员姓名"/>-->
<!--        </el-form-item>-->
<!--      </el-form>-->
<!--      <div slot="footer" class="dialog-footer">-->
<!--        <el-button type="primary" @click="submitForm">确 定</el-button>-->
<!--        <el-button @click="cancel">取 消</el-button>-->
<!--      </div>-->
<!--    </el-dialog>-->
