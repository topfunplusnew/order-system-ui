<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="150px">
      <!--      时间查询-->
      <el-form-item label="开票开始日期" prop="beginTime">
        <el-date-picker
          v-model="queryParams.beginTime"
          type="date"
          placeholder="选择日期" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="开票结束日期" prop="endTime">
        <el-date-picker
          v-model="queryParams.endTime"
          type="date"
          placeholder="选择日期" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
<!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
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
          v-hasPermi="['system:invoicein:add']"
        >新增
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

    <el-table id="printBox" v-horizontal-scroll="'always'" border v-loading="loading" :data="invoiceInList"
              @selection-change="handleSelectionChange">
      <el-table-column label="开票日期" align="center" prop="invoiceDate" v-if="columns[0].visible"/>
      <el-table-column label="我方开票实体" align="center" prop="invoiceObject" v-if="columns[1 ].visible"/>
      <el-table-column label="开票金额" align="center" prop="invoiceAmount" v-if="columns[2 ].visible"/>
      <el-table-column label="对方公司类别" align="center" prop="companyType" v-if="columns[3].visible"/>
      <el-table-column label="对方公司名称" align="center" prop="companyName" v-if="columns[4].visible"/>
      <el-table-column label="票据单位名称" align="center" prop="invoiceCompanyName" v-if="columns[5].visible"/>
      <el-table-column label="票点" align="center" prop="ticketPoint" v-if="columns[6].visible"/>
      <el-table-column label="票点金额" align="center" prop="ticketPointAmount" v-if="columns[7].visible"/>
      <el-table-column label="是否订单对应票点" align="center" prop="isOrderTax" v-if="columns[8].visible"/>
      <el-table-column label="审核状态" align="center" prop="checkState" width="240" v-if="columns[9].visible">
        <template #default="scope">
          <el-row>
            <el-col :span="12">
              <el-tag>
                {{ scope.row.checkState }}
              </el-tag>
            </el-col>
            <el-col :span="12">
              <el-button size="mini" type="warning" :disabled="scope.row.checkState!=='未申请'"
                         @click="addPaymentApplyInfos(scope.row)">
                添加付款申请
              </el-button>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[10].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:invoicein:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:invoicein:remove']"
          >删除
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

    <!-- 添加或修改发票购入信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="开票日期" prop="invoiceDate">
          <el-date-picker
            v-model="form.invoiceDate"
            type="date"
            placeholder="选择日期"
            value-format="yyyy-MM-dd">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="我方开票实体" prop="invoiceObject">
          <el-input v-model="form.invoiceObject" placeholder="请输入我方开票实体"/>
        </el-form-item>
        <el-form-item label="开票金额" prop="invoiceAmount">
          <el-input v-model="form.invoiceAmount" placeholder="请输入开票金额"/>
        </el-form-item>
        <el-form-item label="对方公司名称" prop="companyName">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.companyName" placeholder="请输入对方公司名称"/>
            </el-col>
            <el-col :span="2">
              <SearchOption :limit-info="{}" :get-data="listCompany" query-info="companyName"
                            query-label="公司名称" :query-name="companyName"
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
          <el-input v-model="form.invoiceCompanyName" placeholder="请输入票据单位名称"/>
        </el-form-item>
        <el-form-item label="票点" prop="ticketPoint">
          <el-input v-model="form.ticketPoint" placeholder="请输入票点"/>
        </el-form-item>
        <el-form-item label="票点金额" prop="ticketPointAmount">
          <el-input v-model="invoiceAmount" placeholder="请输入票点金额" disabled/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!--    添加付款申请-->
    <el-dialog title="付款申请" :visible.sync="PaymentApplyInfoVisible" width="500px" append-to-body>
      <ApplyPayment :table-name="TableName.INVOICE_IN" @changeOpen="changePaymentApplyInfoVisible"
                    :t-i-d="tID" :need-money="needMoney" :need-info="{}"/>
    </el-dialog>
  </div>
</template>

<script>
import {listInvoiceIn, getInvoiceIn, delInvoiceIn, addInvoiceIn, updateInvoiceIn} from "@/api/system/invoiceIn";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import SearchOption from "@/components/SearchOption.vue";
import {listCompany} from "@/api/system/company";
import ApplyPayment from "@/components/ApplyPayment.vue";
import {TableName} from "@/api/tool/enums";

export default {
  name: "InvoiceIn",
  components: {ApplyPayment, SearchOption},
  mixins: [mixin_printHTML],
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
      rules: {},
      columns: [
        {key: 0, label: `开票日期`, visible: true},
        {key: 1, label: `我方开票实体`, visible: true},
        {key: 2, label: `开票金额`, visible: true},
        {key: 3, label: `对方公司类别`, visible: true},
        {key: 4, label: `对方公司名称`, visible: true},
        {key: 5, label: `票据单位名称`, visible: true},
        {key: 6, label: `票点`, visible: true},
        {key: 7, label: `票点金额`, visible: true},
        {key: 8, label: `是否订单对应票点`, visible: true},
        {key: 9, label: `审核状态`, visible: true},
        {key: 10, label: `备注`, visible: true},
      ],

      //公司名称
      companyName: '',
      //付款申请
      PaymentApplyInfoVisible: false,
      tID: '',
      needMoney: 0
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('invoicein-columns') === 'null'
      || !localStorage.getItem('invoicein-columns')) {
      //设置localStorage
      localStorage.setItem("invoicein-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('invoicein-columns'));
    }
  },
  computed: {
    TableName() {
      return TableName
    },
    //票点金额 开票金额*票点
    invoiceAmount: {
      set(val) {
        this.form.ticketPointAmount = val;
      },
      get() {
        return this.form.invoiceAmount * this.form.ticketPoint
      }
    },
  },
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("invoicein-columns", JSON.stringify(newVal))
      },
      deep: true,
    },
    form: {
      handler(val) {
        this.invoiceAmount = this.form.invoiceAmount * this.form.ticketPoint;
      },
      deep: true
    }
  },
  methods: {
    listCompany,
    /** 查询发票购入信息列表 */
    getList() {
      this.loading = true;
      listInvoiceIn(this.queryParams).then(response => {
        this.invoiceInList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    handleUpdateCompanyName(val) {
      this.companyName = val;
    },
    handleCommitBackCompany(val) {
      console.log(val)
      this.form.companyName = val.companyName;
      this.form.companyID = val.id;
      this.form.companyType = val.companyType;
    },

    //添加付款申请
    addPaymentApplyInfos(row) {
      this.tID = row.id;
      this.needMoney = row.ticketPointAmount;
      this.PaymentApplyInfoVisible = true
    },
    changePaymentApplyInfoVisible(val) {
      this.PaymentApplyInfoVisible = val;
      this.getList()
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
        isOrderTax: 0,
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
      this.single = selection.length !== 1
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
      this.$modal.confirm('是否确认删除发票购入信息编号为"' + ids + '"的数据项？').then(function () {
        return delInvoiceIn(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
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
