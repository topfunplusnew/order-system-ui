<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="开始时间" prop="beginTime">
        <el-date-picker
          v-model="beginTime"
          type="date"
          placeholder="选择日期">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="结束时间" prop="endTime">
        <el-date-picker
          v-model="endTime"
          type="date"
          placeholder="选择日期">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="公司名称" prop="companyName">
        <el-input
          v-model="queryParams.companyName"
          placeholder="请输入公司名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="票据单位名称" prop="invoiceCompanyName">
        <el-input
          v-model="queryParams.invoiceCompanyName"
          placeholder="请输入票据单位名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleTimesQuery">搜索</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:invoiceout:add']"
        >新增票点信息
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
              v-hasPermi="['system:bankaccount:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="invoiceOutList" @selection-change="handleSelectionChange" id="printBox">
      <el-table-column label="开票日期" align="center" prop="invoiceDate"/>
      <el-table-column label="我方开票实体" align="center" prop="invoiceObject"/>
      <el-table-column label="开票金额" align="center" prop="invoiceAmount"/>
      <el-table-column label="公司类别" align="center" prop="companyType"/>
      <el-table-column label="公司名称" align="center" prop="companyName"/>
      <!--      <el-table-column label="公司ID" align="center" prop="companyID"/>-->
      <el-table-column label="票据单位名称" align="center" prop="invoiceCompanyName"/>
      <el-table-column label="票点" align="center" prop="ticketPoint"/>
      <el-table-column label="票点金额" align="center" prop="ticketPointAmount"/>
      <el-table-column label="是否订单对应票点" align="center" prop="isOrderTax"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:invoiceout:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:invoiceout:remove']"
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

    <!-- 添加或修改发票卖出信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="开票日期" prop="invoiceDate">
          <el-input v-model="form.invoiceDate" placeholder="请输入开票日期"/>
        </el-form-item>
        <el-form-item label="我方开票实体" prop="invoiceObject">
          <el-input v-model="form.invoiceObject" placeholder="请输入我方开票实体"/>
        </el-form-item>
        <el-form-item label="开票金额" prop="invoiceAmount">
          <el-input v-model="form.invoiceAmount" placeholder="请输入开票金额"/>
        </el-form-item>
        <el-form-item label="公司名称" prop="companyName">
          <el-input v-model="form.companyName" placeholder="请输入公司名称"/>
        </el-form-item>
        <!--        <el-form-item label="公司ID" prop="companyID">-->
        <!--          <el-input v-model="form.companyID" placeholder="请输入公司ID"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="票据单位名称" prop="invoiceCompanyName">
          <el-input v-model="form.invoiceCompanyName" placeholder="请输入票据单位名称"/>
        </el-form-item>
        <el-form-item label="票点" prop="ticketPoint">
          <el-input v-model="form.ticketPoint" placeholder="请输入票点"/>
        </el-form-item>
        <el-form-item label="票点金额" prop="ticketPointAmount">
          <el-input v-model="form.ticketPointAmount" placeholder="请输入票点金额"/>
        </el-form-item>
        <el-form-item label="是否订单对应票点" prop="isOrderTax">
          <el-input v-model="form.isOrderTax" placeholder="请输入是否订单对应票点"/>
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
  </div>
</template>

<script>
import {listInvoiceOut, getInvoiceOut, delInvoiceOut, addInvoiceOut, updateInvoiceOut} from "@/api/system/invoiceOut";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {excludeParams} from "@/api/tool/exclude";

export default {
  name: "InvoiceOut",
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
      // 发票卖出信息表格数据
      invoiceOutList: [],
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
        {key: 0, label: `账户类型`, visible: true},
        {key: 1, label: `开户名称`, visible: true},
        {key: 2, label: `账号(银行卡号)`, visible: true},
        {key: 3, label: `开户行`, visible: true},
        {key: 4, label: `公司名称`, visible: true}
      ],
      beginTime: '',
      endTime: ''
    };
  },
  created() {
    this.getList();
  },
  methods: {
    handleTimesQuery() {
      listInvoiceOut({
        ...this.queryParams, beginTime: this.beginTime.getTime(),
        endTime: this.endTime.getTime()
      }).then(res => {
        console.log(res)
      })
    },
    /** 查询发票卖出信息列表 */
    getList() {
      this.loading = true;
      listInvoiceOut(this.queryParams,).then(response => {
        this.invoiceOutList = response.rows;
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
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加发票卖出信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getInvoiceOut(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改发票卖出信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            this.form = excludeParams(this.form, this.$exclude)
            updateInvoiceOut(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form = excludeParams(this.form, this.$exclude)
            addInvoiceOut(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除发票卖出信息编号为"' + ids + '"的数据项？').then(function () {
        return delInvoiceOut(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/invoiceOut/export', {
        ...this.queryParams
      }, `invoiceOut_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
