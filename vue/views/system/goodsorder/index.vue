<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="订单编号" prop="ordersNo">
        <el-input
          v-model="queryParams.ordersNo"
          placeholder="请输入订单编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="日期" prop="orderDate">
        <el-input
          v-model="queryParams.orderDate"
          placeholder="请输入日期"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="客户" prop="customer">
        <el-input
          v-model="queryParams.customer"
          placeholder="请输入客户"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="客户ID" prop="customerID">
        <el-input
          v-model="queryParams.customerID"
          placeholder="请输入客户ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="陆运车辆ID" prop="landCarID">
        <el-input
          v-model="queryParams.landCarID"
          placeholder="请输入陆运车辆ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="陆运车牌" prop="landCarNo">
        <el-input
          v-model="queryParams.landCarNo"
          placeholder="请输入陆运车牌"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="陆运司机电话" prop="landDriverTel">
        <el-input
          v-model="queryParams.landDriverTel"
          placeholder="请输入陆运司机电话"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="陆地司机姓名" prop="landDriverName">
        <el-input
          v-model="queryParams.landDriverName"
          placeholder="请输入陆地司机姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="海运车辆ID" prop="seaCarID">
        <el-input
          v-model="queryParams.seaCarID"
          placeholder="请输入海运车辆ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="海运车牌" prop="seaCarNo">
        <el-input
          v-model="queryParams.seaCarNo"
          placeholder="请输入海运车牌"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="海运司机电话" prop="seaDriverTel">
        <el-input
          v-model="queryParams.seaDriverTel"
          placeholder="请输入海运司机电话"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="海运司机姓名" prop="seaDriverName">
        <el-input
          v-model="queryParams.seaDriverName"
          placeholder="请输入海运司机姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="审核人编号" prop="checkUserId">
        <el-input
          v-model="queryParams.checkUserId"
          placeholder="请输入审核人编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="审核状态" prop="checkState">
        <el-input
          v-model="queryParams.checkState"
          placeholder="请输入审核状态"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="开票状态" prop="invoiceState">
        <el-input
          v-model="queryParams.invoiceState"
          placeholder="请输入开票状态"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="附件路径" prop="path">
        <el-input
          v-model="queryParams.path"
          placeholder="请输入附件路径"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="打款状态(申请中，已打款，未打款)" prop="PaymentState">
        <el-input
          v-model="queryParams.PaymentState"
          placeholder="请输入打款状态(申请中，已打款，未打款)"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="陆运银行户名" prop="landBankName">
        <el-input
          v-model="queryParams.landBankName"
          placeholder="请输入陆运银行户名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="陆运银行账号" prop="landBankNo">
        <el-input
          v-model="queryParams.landBankNo"
          placeholder="请输入陆运银行账号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="海运银行户名" prop="seaBankName">
        <el-input
          v-model="queryParams.seaBankName"
          placeholder="请输入海运银行户名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="海运银行账号" prop="seaBankNo">
        <el-input
          v-model="queryParams.seaBankNo"
          placeholder="请输入海运银行账号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="销售经理" prop="saleManager">
        <el-input
          v-model="queryParams.saleManager"
          placeholder="请输入销售经理"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="车队" prop="fleet">
        <el-input
          v-model="queryParams.fleet"
          placeholder="请输入车队"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="是否被调整单" prop="isAdjusted">
        <el-input
          v-model="queryParams.isAdjusted"
          placeholder="请输入是否被调整单"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="调整日期" prop="adjustDate">
        <el-input
          v-model="queryParams.adjustDate"
          placeholder="请输入调整日期"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="是否调整单" prop="isAdjust">
        <el-input
          v-model="queryParams.isAdjust"
          placeholder="请输入是否调整单"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="原订单编号" prop="adjustOrderid">
        <el-input
          v-model="queryParams.adjustOrderid"
          placeholder="请输入原订单编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="是否可编辑" prop="isedit">
        <el-input
          v-model="queryParams.isedit"
          placeholder="请输入是否可编辑"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="客户是否开票" prop="customerIsInvoice">
        <el-input
          v-model="queryParams.customerIsInvoice"
          placeholder="请输入客户是否开票"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="供应商是否开票" prop="isSupplierInvoice">
        <el-input
          v-model="queryParams.isSupplierInvoice"
          placeholder="请输入供应商是否开票"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="作废标记" prop="cancelFlag">
        <el-input
          v-model="queryParams.cancelFlag"
          placeholder="请输入作废标记"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="备注" prop="comments">
        <el-input
          v-model="queryParams.comments"
          placeholder="请输入备注"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="添加时间" prop="addtime">
        <el-input
          v-model="queryParams.addtime"
          placeholder="请输入添加时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="操作人员ID" prop="userId">
        <el-input
          v-model="queryParams.userId"
          placeholder="请输入操作人员ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="操作人员姓名" prop="UserName">
        <el-input
          v-model="queryParams.UserName"
          placeholder="请输入操作人员姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:goodsOrder:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['system:goodsOrder:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:goodsOrder:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:goodsOrder:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="goodsOrderList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="id" align="center" prop="id" />
      <el-table-column label="订单编号" align="center" prop="ordersNo" />
      <el-table-column label="日期" align="center" prop="orderDate" />
      <el-table-column label="客户" align="center" prop="customer" />
      <el-table-column label="客户ID" align="center" prop="customerID" />
      <el-table-column label="陆运车辆ID" align="center" prop="landCarID" />
      <el-table-column label="陆运车牌" align="center" prop="landCarNo" />
      <el-table-column label="陆运司机电话" align="center" prop="landDriverTel" />
      <el-table-column label="陆地司机姓名" align="center" prop="landDriverName" />
      <el-table-column label="海运车辆ID" align="center" prop="seaCarID" />
      <el-table-column label="海运车牌" align="center" prop="seaCarNo" />
      <el-table-column label="海运司机电话" align="center" prop="seaDriverTel" />
      <el-table-column label="海运司机姓名" align="center" prop="seaDriverName" />
      <el-table-column label="审核人编号" align="center" prop="checkUserId" />
      <el-table-column label="审核状态" align="center" prop="checkState" />
      <el-table-column label="开票状态" align="center" prop="invoiceState" />
      <el-table-column label="附件路径" align="center" prop="path" />
      <el-table-column label="打款状态(申请中，已打款，未打款)" align="center" prop="PaymentState" />
      <el-table-column label="陆运银行户名" align="center" prop="landBankName" />
      <el-table-column label="陆运银行账号" align="center" prop="landBankNo" />
      <el-table-column label="海运银行户名" align="center" prop="seaBankName" />
      <el-table-column label="海运银行账号" align="center" prop="seaBankNo" />
      <el-table-column label="收到条附件路径" align="center" prop="receiveProof" />
      <el-table-column label="销售经理" align="center" prop="saleManager" />
      <el-table-column label="车队" align="center" prop="fleet" />
      <el-table-column label="是否被调整单" align="center" prop="isAdjusted" />
      <el-table-column label="调整日期" align="center" prop="adjustDate" />
      <el-table-column label="是否调整单" align="center" prop="isAdjust" />
      <el-table-column label="原订单编号" align="center" prop="adjustOrderid" />
      <el-table-column label="是否可编辑" align="center" prop="isedit" />
      <el-table-column label="客户是否开票" align="center" prop="customerIsInvoice" />
      <el-table-column label="供应商是否开票" align="center" prop="isSupplierInvoice" />
      <el-table-column label="作废标记" align="center" prop="cancelFlag" />
      <el-table-column label="备注" align="center" prop="comments" />
      <el-table-column label="添加时间" align="center" prop="addtime" />
      <el-table-column label="操作人员ID" align="center" prop="userId" />
      <el-table-column label="操作人员姓名" align="center" prop="UserName" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:goodsOrder:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:goodsOrder:remove']"
          >删除</el-button>
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

    <!-- 添加或修改订单对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="订单编号" prop="ordersNo">
          <el-input v-model="form.ordersNo" placeholder="请输入订单编号" />
        </el-form-item>
        <el-form-item label="日期" prop="orderDate">
          <el-input v-model="form.orderDate" placeholder="请输入日期" />
        </el-form-item>
        <el-form-item label="客户" prop="customer">
          <el-input v-model="form.customer" placeholder="请输入客户" />
        </el-form-item>
        <el-form-item label="客户ID" prop="customerID">
          <el-input v-model="form.customerID" placeholder="请输入客户ID" />
        </el-form-item>
        <el-form-item label="陆运车辆ID" prop="landCarID">
          <el-input v-model="form.landCarID" placeholder="请输入陆运车辆ID" />
        </el-form-item>
        <el-form-item label="陆运车牌" prop="landCarNo">
          <el-input v-model="form.landCarNo" placeholder="请输入陆运车牌" />
        </el-form-item>
        <el-form-item label="陆运司机电话" prop="landDriverTel">
          <el-input v-model="form.landDriverTel" placeholder="请输入陆运司机电话" />
        </el-form-item>
        <el-form-item label="陆地司机姓名" prop="landDriverName">
          <el-input v-model="form.landDriverName" placeholder="请输入陆地司机姓名" />
        </el-form-item>
        <el-form-item label="海运车辆ID" prop="seaCarID">
          <el-input v-model="form.seaCarID" placeholder="请输入海运车辆ID" />
        </el-form-item>
        <el-form-item label="海运车牌" prop="seaCarNo">
          <el-input v-model="form.seaCarNo" placeholder="请输入海运车牌" />
        </el-form-item>
        <el-form-item label="海运司机电话" prop="seaDriverTel">
          <el-input v-model="form.seaDriverTel" placeholder="请输入海运司机电话" />
        </el-form-item>
        <el-form-item label="海运司机姓名" prop="seaDriverName">
          <el-input v-model="form.seaDriverName" placeholder="请输入海运司机姓名" />
        </el-form-item>
        <el-form-item label="审核人编号" prop="checkUserId">
          <el-input v-model="form.checkUserId" placeholder="请输入审核人编号" />
        </el-form-item>
        <el-form-item label="审核状态" prop="checkState">
          <el-input v-model="form.checkState" placeholder="请输入审核状态" />
        </el-form-item>
        <el-form-item label="开票状态" prop="invoiceState">
          <el-input v-model="form.invoiceState" placeholder="请输入开票状态" />
        </el-form-item>
        <el-form-item label="附件路径" prop="path">
          <el-input v-model="form.path" placeholder="请输入附件路径" />
        </el-form-item>
        <el-form-item label="打款状态(申请中，已打款，未打款)" prop="PaymentState">
          <el-input v-model="form.PaymentState" placeholder="请输入打款状态(申请中，已打款，未打款)" />
        </el-form-item>
        <el-form-item label="陆运银行户名" prop="landBankName">
          <el-input v-model="form.landBankName" placeholder="请输入陆运银行户名" />
        </el-form-item>
        <el-form-item label="陆运银行账号" prop="landBankNo">
          <el-input v-model="form.landBankNo" placeholder="请输入陆运银行账号" />
        </el-form-item>
        <el-form-item label="海运银行户名" prop="seaBankName">
          <el-input v-model="form.seaBankName" placeholder="请输入海运银行户名" />
        </el-form-item>
        <el-form-item label="海运银行账号" prop="seaBankNo">
          <el-input v-model="form.seaBankNo" placeholder="请输入海运银行账号" />
        </el-form-item>
        <el-form-item label="收到条附件路径" prop="receiveProof">
          <el-input v-model="form.receiveProof" type="textarea" placeholder="请输入内容" />
        </el-form-item>
        <el-form-item label="销售经理" prop="saleManager">
          <el-input v-model="form.saleManager" placeholder="请输入销售经理" />
        </el-form-item>
        <el-form-item label="车队" prop="fleet">
          <el-input v-model="form.fleet" placeholder="请输入车队" />
        </el-form-item>
        <el-form-item label="是否被调整单" prop="isAdjusted">
          <el-input v-model="form.isAdjusted" placeholder="请输入是否被调整单" />
        </el-form-item>
        <el-form-item label="调整日期" prop="adjustDate">
          <el-input v-model="form.adjustDate" placeholder="请输入调整日期" />
        </el-form-item>
        <el-form-item label="是否调整单" prop="isAdjust">
          <el-input v-model="form.isAdjust" placeholder="请输入是否调整单" />
        </el-form-item>
        <el-form-item label="原订单编号" prop="adjustOrderid">
          <el-input v-model="form.adjustOrderid" placeholder="请输入原订单编号" />
        </el-form-item>
        <el-form-item label="是否可编辑" prop="isedit">
          <el-input v-model="form.isedit" placeholder="请输入是否可编辑" />
        </el-form-item>
        <el-form-item label="客户是否开票" prop="customerIsInvoice">
          <el-input v-model="form.customerIsInvoice" placeholder="请输入客户是否开票" />
        </el-form-item>
        <el-form-item label="供应商是否开票" prop="isSupplierInvoice">
          <el-input v-model="form.isSupplierInvoice" placeholder="请输入供应商是否开票" />
        </el-form-item>
        <el-form-item label="作废标记" prop="cancelFlag">
          <el-input v-model="form.cancelFlag" placeholder="请输入作废标记" />
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注" />
        </el-form-item>
        <el-form-item label="添加时间" prop="addtime">
          <el-input v-model="form.addtime" placeholder="请输入添加时间" />
        </el-form-item>
        <el-form-item label="操作人员ID" prop="userId">
          <el-input v-model="form.userId" placeholder="请输入操作人员ID" />
        </el-form-item>
        <el-form-item label="操作人员姓名" prop="UserName">
          <el-input v-model="form.UserName" placeholder="请输入操作人员姓名" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listGoodsOrder, getGoodsOrder, delGoodsOrder, addGoodsOrder, updateGoodsOrder } from "@/api/system/goodsOrder";

export default {
  name: "GoodsOrder",
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
      rules: {
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
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
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加订单";
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
      this.$modal.confirm('是否确认删除订单编号为"' + ids + '"的数据项？').then(function() {
        return delGoodsOrder(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
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
