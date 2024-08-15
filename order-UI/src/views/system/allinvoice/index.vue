<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="120px">
      <!--      时间查询-->
      <el-form-item label="开始日期" prop="startDate">
        <el-date-picker
          v-model="queryParams.startDate"
          type="date"
          placeholder="选择日期" value-format="timestamp">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="结束日期" prop="endDate">
        <el-date-picker
          v-model="queryParams.endDate"
          type="date"
          placeholder="选择日期" value-format="timestamp">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="供应商/客户" prop="searchCompamyName">
        <el-input
          v-model="queryParams.searchCompamyName"
          placeholder="请输入开票日期"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="开票单位" prop="searchInvoiceCompanyName">
        <el-input
          v-model="queryParams.searchInvoiceCompanyName"
          placeholder="请输入开票日期"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
<!--      <el-col :span="1.5">-->
<!--        <el-button-->
<!--          type="primary"-->
<!--          plain-->
<!--          icon="el-icon-plus"-->
<!--          size="mini"-->
<!--          @click="handleAdd"-->
<!--          v-hasPermi="['system:invoicein:add']"-->
<!--        >新增</el-button>-->
<!--      </el-col>-->
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
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
    <el-row>
      <h2>
        发票总台帐
      </h2>
    </el-row>
    <el-table id="printBox" v-horizontal-scroll="'always'" border v-loading="loading" :data="invoiceInList" @selection-change="handleSelectionChange">
      <el-table-column label="id" align="center" prop="id" />
      <el-table-column label="开票日期" align="center" prop="invoiceDate" />
      <el-table-column label="发票金额" align="center" prop="invoiceAmount" />
      <el-table-column label="公司类型" align="center" prop="companyType" />
      <el-table-column label="公司名称" align="center" prop="companyName" />
      <el-table-column label="开票单位名称" align="center" prop="invoiceCompanyName" />
      <el-table-column label="票点" align="center" prop="ticketPoint" />
      <el-table-column label="票点金额" align="center" prop="ticketPointAmount" />
      <el-table-column label="是否为订单税" align="center" prop="isOrderTax" />
      <el-table-column label="供应商名称" align="center" prop="supplier" />
      <el-table-column label="客户名称" align="center" prop="customer" />
      <el-table-column label="采购发票金额" align="center" prop="purchaseInvoiceAmount" />
      <el-table-column label="票点成本（点数）" align="center" prop="ticketPointCost" />
      <el-table-column label="票点成本（金额）" align="center" prop="ticketPointCostAmount" />
      <el-table-column label="票点收入（点数）" align="center" prop="ticketPointIncome" />
      <el-table-column label="票点收入（金额）" align="center" prop="ticketPointIncomeAmount" />
      <el-table-column label="票点差额" align="center" prop="ticketPointDifference" />
      <el-table-column label="票点成本（点数）" align="center" prop="ticketPointCost" />
      <el-table-column label="票点成本（点数）" align="center" prop="ticketPointCost" />
      <el-table-column label="总货款" align="center" prop="allPayments" />
      <el-table-column label="实际开票日期" align="center" prop="orderDate" />
      <el-table-column label="当月欠票" align="center" prop="orderDate" >
<!--        parseTime(scope.row.orderDate, '{y}-{m}')-->
        <template #default="scope">
          <span>{{ scope.row.allPayments }}</span>
        </template>
      </el-table-column>


      <el-table-column label="备注" align="center" prop="comments" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:invoicein:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:invoicein:remove']"
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

    <!-- 添加或修改发票购入信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="开票日期" prop="invoiceDate">
          <el-input v-model="form.invoiceDate" placeholder="请输入开票日期" />
        </el-form-item>
        <el-form-item label="我方开票实体" prop="invoiceObject">
          <el-input v-model="form.invoiceObject" placeholder="请输入我方开票实体" />
        </el-form-item>
        <el-form-item label="开票金额" prop="invoiceAmount">
          <el-input v-model="form.invoiceAmount" placeholder="请输入开票金额" />
        </el-form-item>
        <el-form-item label="对方公司名称" prop="companyName">
          <el-input v-model="form.companyName" placeholder="请输入对方公司名称" />
        </el-form-item>
        <el-form-item label="对方公司ID" prop="companyID">
          <el-input v-model="form.companyID" placeholder="请输入对方公司ID" />
        </el-form-item>
        <el-form-item label="票据单位名称" prop="invoiceCompanyName">
          <el-input v-model="form.invoiceCompanyName" placeholder="请输入票据单位名称" />
        </el-form-item>
        <el-form-item label="票点" prop="ticketPoint">
          <el-input v-model="form.ticketPoint" placeholder="请输入票点" />
        </el-form-item>
        <el-form-item label="票点金额" prop="ticketPointAmount">
          <el-input v-model="form.ticketPointAmount" placeholder="请输入票点金额" />
        </el-form-item>
        <el-form-item label="是否订单对应票点" prop="isOrderTax">
          <el-input v-model="form.isOrderTax" placeholder="请输入是否订单对应票点" />
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
        <el-form-item label="删除标记" prop="delFlag">
          <el-input v-model="form.delFlag" placeholder="请输入删除标记" />
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
import { listInvoiceIn, getInvoiceIn, delInvoiceIn, addInvoiceIn, updateInvoiceIn } from "@/api/system/invoiceIn";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";

export default {
  name: "InvoiceIn",
  mixins:[mixin_printHTML],
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
      // 发票购入信息表格数据
      invoiceInList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        startDate:null,
        endDate:null,
        searchCompamyName:null,
        searchInvoiceCompanyName:null,
        pageNum: 1,
        pageSize: 10,
        invoiceDate: null,
        invoiceObject: null,
        invoiceAmount: null,
        companyType: null,
        companyName: null,
        companyID: null,
        invoiceCompanyName: null,
        ticketPoint: null,
        ticketPointAmount: null,
        isOrderTax: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
      },
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
      ],
      options: [{
        value: '已开发票',
        label: '已开发票'
      }, {
        value: '未开发票',
        label: '未开发票'
      }],
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询发票购入信息列表 */
    getList() {
      this.loading = true;
      listInvoiceIn(this.queryParams).then(response => {
        this.invoiceInList = response.rows;
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
        invoiceDate: null,
        invoiceObject: null,
        invoiceAmount: null,
        companyType: null,
        companyName: null,
        companyID: null,
        invoiceCompanyName: null,
        ticketPoint: null,
        ticketPointAmount: null,
        isOrderTax: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null
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
      this.title = "添加发票购入信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getInvoiceIn(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改发票购入信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateInvoiceIn(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addInvoiceIn(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除发票购入信息编号为"' + ids + '"的数据项？').then(function() {
        return delInvoiceIn(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/invoiceIn/export', {
        ...this.queryParams
      }, `invoiceIn_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
