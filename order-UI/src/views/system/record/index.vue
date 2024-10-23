<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="交易时间">
        <el-date-picker
          v-model="daterangeTransactionTime"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item label="金额" prop="amount">
        <el-input
          v-model="queryParams.amount"
          placeholder="请输入金额"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="备注" prop="remarks">
        <el-input
          v-model="queryParams.remarks"
          placeholder="请输入备注"
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
          v-hasPermi="['system:record:add']"
        >新增
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:record:remove']"
        >删除
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
              v-hasPermi="['system:payment:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="recordList" @selection-change="handleSelectionChange" id="printBox"
              v-horizontal-scroll="'always'" size="mini" border :cell-style="()=>{return {padding:'2px'}}">
      <el-table-column type="selection" width="55" align="center"/>
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="交易时间" align="center" prop="transactionTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.transactionTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="金额" align="center" prop="amount"/>
      <!--   todo    客户 供应商 选择-->
         <el-table-column label="客户" align="center" prop="customer"/>
         <el-table-column label="供应商" align="center" prop="supplier"/>
      <!--      附件上传-->
      <el-table-column label="附件" align="center" prop="attachment">
        <template #default="scope">
          <el-row v-if="scope.row.attachment === '' || scope.row.attachment === null">
            无
          </el-row>
          <el-row v-else>
            <el-button size="mini" type="success" @click="checkAttachment(scope.row,'attachment')">
              查看
            </el-button>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="remarks"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:record:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:record:remove']"
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

    <!-- 添加或修改现金记账对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="发票号码">
          <el-row>
            <el-col :span="20">
              <el-input disabled v-model="form.referenceTableId" placeholder="请选择发票号码"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listInvoiceOther" @commitBack="handleCommitInvoiceOther"
                            :limit-info="{}" query-label="供应商公司名称" :query-name="queryInvoice"
                            query-info="Supplier" @update:queryName="updateQueryInvoice">
                <template #table-columns>
                  <el-table-column label="开票日期" align="center" prop="invoiceDate"
                                   show-overflow-tooltip/>
                  <el-table-column label="开票金额" align="center" prop="invoiceAmount"
                                   show-overflow-tooltip/>
                  <el-table-column label="供应商票点" align="center" prop="supplierTicketPoint"
                                   show-overflow-tooltip/>
                  <el-table-column label="供应商票点金额" align="center" prop="supplierPointAmount"
                                   show-overflow-tooltip/>
                  <el-table-column label="供应商公司名称" align="center" prop="Supplier"
                                   show-overflow-tooltip/>
                  <el-table-column label="客户公司名称" align="center" prop="customer"
                                   show-overflow-tooltip/>
                  <el-table-column label="票据单位名称" align="center" prop="invoiceCompanyName"
                                   show-overflow-tooltip/>
                  <el-table-column label="客户票点" align="center" prop="customerTicketPoint"
                                   show-overflow-tooltip/>
                  <el-table-column label="票点金额" align="center" prop="customerPointAmount"
                                   show-overflow-tooltip/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="交易时间" prop="transactionTime">
          <el-date-picker clearable
                          v-model="form.transactionTime"
                          type="date"
                          value-format="yyyy-MM-dd"
                          placeholder="请选择交易时间">
          </el-date-picker>
        </el-form-item>
        <!--        选择供应商-->
        <el-form-item label="供应商" prop="supplier">
          <el-row>
            <el-col :span="20">
              <el-input disabled placeholder="请选择供应商" v-model="supplierName"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listCompany" @commitBack="handleCommitCompanySupplier"
                            :limit-info="{companyType:'供应商'}" query-info="companyName" :query-name="querySupplier"
                            query-label="供应商名称" @update:queryName="updateQuerySupplier">
                <template #table-columns>
                  <el-table-column label="公司名称" align="center" prop="companyName"/>
                  <el-table-column label="老板姓名" align="center" prop="leader"/>
                  <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                  <el-table-column label="开户行" align="center" prop="bankName"/>
                  <el-table-column label="开户名" align="center" prop="acountsName"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <!--        选择客户-->
        <el-form-item label="客户" prop="customer">
          <el-row>
            <el-col :span="20">
              <el-input disabled placeholder="请选择客户" v-model="customerName"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listCompany" @commitBack="handleCommitCompanyCustomer"
                            :limit-info="{companyType:'客户'}" query-info="companyName" :query-name="queryCustomer"
                            query-label="客户名称" @update:queryName="updateQueryCustomer">
                <template #table-columns>
                  <el-table-column label="公司名称" align="center" prop="companyName"/>
                  <el-table-column label="老板姓名" align="center" prop="leader"/>
                  <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                  <el-table-column label="开户行" align="center" prop="bankName"/>
                  <el-table-column label="开户名" align="center" prop="acountsName"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="金额" prop="amount">
          <el-input v-model="form.amount" placeholder="请输入金额"/>
        </el-form-item>
        <el-form-item label="附件" prop="attachment">
          <!--          <el-input v-model="form.attachment" type="textarea" placeholder="请输入内容"/>-->
          <el-upload
            class="upload-demo"
            drag
            :action="uploadFileUrl"
            multiple
            show-file-list
            :headers="headers"
            :file-list="fileList"
            :before-upload="beforeUpload">
            <i class="el-icon-upload"></i>
            <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
            <div class="el-upload__tip" slot="tip">上传文件名长度不得超过20</div>
          </el-upload>
          <el-button type="success" @click="submitUploadAllFiles">开始上传</el-button>
        </el-form-item>
        <el-form-item label="备注" prop="remarks">
          <el-input v-model="form.remarks" placeholder="请输入备注"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>


    <!--    查看附件列表的组件-->
    <el-dialog :close-on-click-modal="false" :show-close="false" title="查看附件" :visible.sync="checkAttachmentVisible"
               width="48%">
      <el-row v-for="(item, index) in checkFileList" :key="index">
        <el-button type="text" icon="el-icon-document" @click="checkFileItem(item)">{{ item }}</el-button>
      </el-row>
      <el-button @click="checkAttachmentVisible = false">关 闭</el-button>
    </el-dialog>
  </div>
</template>

<script>
import {listRecord, getRecord, delRecord, addRecord, updateRecord} from "@/api/system/record";
import {parseTime} from "../../../utils/ruoyi";
import {mixin_printHTML} from "../../dashboard/mixins/print";
import {mixin_record_uploadFiles} from "../../dashboard/mixins/record/record_upload";
import {listCompany} from "../../../api/system/company";
import SearchOption from "../../../components/SearchOption.vue";
import {excludeParams} from "../../../api/tool/exclude";
import {TableName} from "../../../api/tool/enums";
import {listInvoiceOther} from "../../../api/system/invoiceOther";

export default {
  name: "Record",
  components: {SearchOption},
  mixins: [mixin_printHTML, mixin_record_uploadFiles],
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
      // 现金记账表格数据
      recordList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 删除标记时间范围
      daterangeTransactionTime: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        transactionTime: null,
        supplierId: null,
        customerId: null,
        amount: null,
        referenceTableId: null,
        referenceTableName: null,
        attachment: null,
        remarks: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        transactionTime: [
          {required: true, message: "交易时间不能为空", trigger: "blur"}
        ],
        supplierId: [
          {required: true, message: "供应商id(或者说来源方)不能为空", trigger: "blur"}
        ],
        customerId: [
          {required: true, message: "客户id(或者说目的地)不能为空", trigger: "blur"}
        ],
        amount: [
          {required: true, message: "金额不能为空", trigger: "blur"}
        ],
        referenceTableId: [
          {required: true, message: "对应表id不能为空", trigger: "blur"}
        ],
        referenceTableName: [
          {required: true, message: "对应表名不能为空", trigger: "blur"}
        ],
      },
      columns: [],

      // 查询字段
      querySupplier: '',
      queryCustomer: '',
      queryInvoice: '',
      // 表单中用于展示的字段
      supplierName: '',
      customerName: '',
    };
  },
  created() {
    this.getList();
  },
  methods: {
    listInvoiceOther,
    listCompany,
    parseTime,
    // 客户供应商的搜索
    updateQuerySupplier(val) {
      this.querySupplier = val;
    },
    updateQueryCustomer(val) {
      this.queryCustomer = val;
    },
    updateQueryInvoice(val) {
      this.queryInvoice = val;
    },
    // 供应商的自动填充 填充id即可
    handleCommitCompanySupplier(val) {
      this.form.supplierId = val.id;
      this.supplierName = val.companyName;
    },
    handleCommitCompanyCustomer(val) {
      this.form.customerId = val.id;
      this.customerName = val.companyName;
    },
    // 开票号码绑定
    handleCommitInvoiceOther(val) {
      this.form.referenceTableId = val.id;
    },
    /** 查询现金记账列表 */
    getList() {
      this.loading = true;
      this.queryParams.params = {};
      if (null != this.daterangeTransactionTime && '' != this.daterangeTransactionTime) {
        this.queryParams.params["beginTransactionTime"] = this.daterangeTransactionTime[0];
        this.queryParams.params["endTransactionTime"] = this.daterangeTransactionTime[1];
      }
      listRecord(this.queryParams).then(response => {
        this.recordList = response.rows;
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
        transactionTime: null,
        supplierId: null,
        customerId: null,
        amount: null,
        referenceTableId: null,
        referenceTableName: null,
        attachment: null,
        remarks: null,
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
      this.daterangeTransactionTime = [];
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
      this.title = "添加现金记账";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getRecord(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改现金记账";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            this.form = excludeParams(this.form, this.$exclude)
            updateRecord(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form = excludeParams(this.form, this.$exclude)
            addRecord({
              ...this.form,
              referenceTableName: TableName.INVOICE_OTHER,
            }).then(response => {
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
      this.$modal.confirm('是否确认删除现金记账编号为"' + ids + '"的数据项？').then(function () {
        return delRecord(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/record/export', {
        ...this.queryParams
      }, `record_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
