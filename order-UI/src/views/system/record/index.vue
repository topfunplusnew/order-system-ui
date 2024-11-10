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
      <el-form-item label="收入方" prop="sourceCompanyName">
        <el-input
          v-model="queryParams.sourceCompanyName"
          placeholder="请输入收入方公司名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="支出方" prop="targetCompanyName">
        <el-input
          v-model="queryParams.targetCompanyName"
          placeholder="请输入收入方公司名称"
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
      <el-table-column label="收入方" align="center" prop="sourceCompanyName" show-overflow-tooltip/>
      <el-table-column label="收入方公司类型" align="center" prop="sourceCompanyType" show-overflow-tooltip/>
      <el-table-column label="支出方" align="center" prop="targetCompanyName" show-overflow-tooltip/>
      <el-table-column label="支出方公司类型" align="center" prop="targetCompanyType" show-overflow-tooltip/>
      <!--      附件上传-->
      <el-table-column label="附件" align="center" prop="attachment">
        <template #default="scope">
          <CheckFiles :path="scope.row.attachment"
                      @needToUpdate="(value)=>handleUpdateFilePath(value,scope.row,'attachment',getRecord(),updateRecord())"/>
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

    <!-- 添加或修改现金记账对话框  cashType 用于分别管理冲抵类型 : 冲抵货款 或者 冲抵第三方开票-->
    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="150px">
        <!--        目前支持两种类型 一种是冲抵货款 一种是冲抵第三方开票-->
        <el-form-item label="冲抵类型">
          <el-row>
            <el-radio v-model="cashType" label="offsetting">冲抵货款</el-radio>
            <!--            删除冲抵第三方开票-->
            <!--            <el-radio v-model="cashType" label="invoiceother">冲抵第三方开票</el-radio>-->
            <el-radio v-model="cashType" label="transfer">内部转账</el-radio>
          </el-row>
        </el-form-item>
        <!--   如果是第三方开票 还需要选择对应关联的票点 -->
        <el-row v-if="cashType === CASH_TYPE.INVOICE_OTHER">
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
        </el-row>

        <el-divider>
          <el-icon class="el-icon-circle-plus"></el-icon>
          收入方信息
        </el-divider>
        <!--        1.选择原-->
        <el-form-item :label="source" v-if="cashType !== CASH_TYPE.OFF_SETTING">
          <el-row>
            <el-col :span="20">
              <!--              如果是冲抵货款直接输入金额 如果是其他 才会有选择-->
              <el-input placeholder="请选择"
                        v-model="sourceName"/>
            </el-col>
            <!--            如果不是冲抵货款 才会有选择客户的按钮-->
            <el-col :span="3">
              <SearchOption :get-data="listBankAccount" @commitBack="handleCommitCompanySupplier"
                            :limit-info="{acountsType:'己方公司'}" query-info="acountsName" :query-name="querySupplier"
                            query-label="户名" @update:queryName="updateQuerySupplier">
                <template #table-columns>
                  <el-table-column label="账户类型" align="center" prop="acountsType" width="200"/>
                  <el-table-column label="开户名称" align="center" prop="acountsName" width="200"/>
                  <el-table-column label="银行账号" align="center" prop="bankNo" width="200"/>
                  <el-table-column label="开户行" align="center" prop="bankName" width="200"/>
                  <el-table-column label="公司名称" align="center" prop="companyName"
                                   width="200"/>
                  <el-table-column label="余额" align="center" prop="amount" width="200"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <!--        如果是冲抵货款 还需要选择一个公司 -->
        <el-row v-if="cashType === CASH_TYPE.OFF_SETTING">
          <el-form-item label="收入方类型">
            <el-radio v-model="form.sourceCompanyType" label="客户">客户</el-radio>
            <el-radio v-model="form.sourceCompanyType" label="供应商">供应商</el-radio>
          </el-form-item>
          <el-form-item label="收入方">
            <el-row>
              <el-col :span="14">
                <el-input type="text" v-model="sourceName"
                          placeholder="请输入收入方"></el-input>
              </el-col>
              <el-col :span="4">
                <SearchOption :limit-info="{companyType:form.sourceCompanyType}"
                              :get-data="listCompany" query-info="companyName"
                              query-label="公司名称" :query-name="queryCompanyName"
                              @update:queryName="handleUpdateCompanyNameGet" @commitBack="handleCommitBackCompanyGet">
                  <template #table-columns>
                    <el-table-column label="公司名称" align="center" prop="companyName"/>
                    <el-table-column label="公司类型" align="center" prop="companyType"/>
                    <el-table-column label="老板姓名" align="center" prop="leader"/>
                    <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                    <el-table-column label="区域" align="center" prop="region"/>
                    <el-table-column label="销售经理" align="center" prop="salesManager"/>
                  </template>
                </SearchOption>
              </el-col>
            </el-row>
          </el-form-item>
        </el-row>

        <el-divider>
          <el-icon class="el-icon-remove"></el-icon>
          支付方信息
        </el-divider>
        <!--        2.选择去-->
        <el-form-item :label="target" v-if="cashType !== CASH_TYPE.OFF_SETTING">
          <el-row>
            <el-col :span="20">
              <el-input placeholder="请选择"
                        v-model="targetName"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listBankAccount" @commitBack="handleCommitCompanyCustomer"
                            :limit-info="{acountsType:'己方公司'}" query-info="acountsName"
                            :query-name="queryCustomer"
                            query-label="户名" @update:queryName="updateQueryCustomer">
                <template #table-columns>
                  <el-table-column label="账户类型" align="center" prop="acountsType" width="200"/>
                  <el-table-column label="开户名称" align="center" prop="acountsName" width="200"/>
                  <el-table-column label="银行账号" align="center" prop="bankNo" width="200"/>
                  <el-table-column label="开户行" align="center" prop="bankName" width="200"/>
                  <el-table-column label="公司名称" align="center" prop="companyName"
                                   width="200"/>
                  <el-table-column label="余额" align="center" prop="amount" width="200"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>

        <!--        如果是冲抵货款 才要选择对方的公司类型 而如果是其他类型 不需要选择 直接填充-->
        <el-row v-if="cashType === CASH_TYPE.OFF_SETTING">
          <el-form-item label="支出方类型">
            <el-radio v-model="form.targetCompanyType" label="客户">客户</el-radio>
            <el-radio v-model="form.targetCompanyType" label="供应商">供应商</el-radio>
          </el-form-item>
          <el-form-item label="支出方">
            <el-row>
              <el-col :span="14">
                <el-input type="text" v-model="targetName"
                          placeholder="请输入支出方"></el-input>
              </el-col>
              <el-col :span="4">
                <SearchOption :limit-info="{companyType:form.targetCompanyType}"
                              :get-data="listCompany" query-info="companyName"
                              query-label="公司名称" :query-name="queryCompanyName"
                              @update:queryName="handleUpdateCompanyNamePay" @commitBack="handleCommitBackCompanyPay">
                  <template #table-columns>
                    <el-table-column label="公司名称" align="center" prop="companyName"/>
                    <el-table-column label="公司类型" align="center" prop="companyType"/>
                    <el-table-column label="老板姓名" align="center" prop="leader"/>
                    <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                    <el-table-column label="区域" align="center" prop="region"/>
                    <el-table-column label="销售经理" align="center" prop="salesManager"/>
                  </template>
                </SearchOption>
              </el-col>
            </el-row>
          </el-form-item>
        </el-row>

        <el-divider>
          <el-icon class="el-icon-edit"></el-icon>
          基本信息
        </el-divider>
        <!--        金额只有在不是冲抵货款的其他类型中才会展示 冲抵货款在前面就已经输入了金额-->
        <el-form-item :label="cashType === CASH_TYPE.TRANSFER ?'转账金额':'冲抵金额'" prop="amount">
          <el-row>
            <el-col :span="14">
              <el-input v-model="form.amount" :placeholder="cashType === CASH_TYPE.TRANSFER ?'转账金额':'冲抵金额'"
                        type="number"/>
            </el-col>
          </el-row>
        </el-form-item>

        <!--        甲方需要上传附件-->
        <el-form-item label="附件" prop="attachment">
          <!--          <el-upload-->
          <!--            class="upload-demo"-->
          <!--            drag-->
          <!--            :action="uploadFileUrl"-->
          <!--            multiple-->
          <!--            show-file-list-->
          <!--            :headers="headers"-->
          <!--            :file-list="fileList"-->
          <!--            :before-upload="beforeUpload">-->
          <!--            <i class="el-icon-upload"></i>-->
          <!--            <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>-->
          <!--            <div class="el-upload__tip" slot="tip">上传文件名长度不得超过20</div>-->
          <!--          </el-upload>-->
          <!--          <el-button type="success" @click="submitUploadAllFiles">开始上传</el-button>-->
          <file-upload @input="handleCommitUpload" ref="uploadFile"/>
        </el-form-item>

        <!--        交易时间-->
        <el-form-item label="交易时间" prop="transactionTime">
          <el-date-picker clearable
                          v-model="form.transactionTime"
                          type="date"
                          value-format="yyyy-MM-dd"
                          placeholder="请选择交易时间">
          </el-date-picker>
        </el-form-item>

        <!--        备注-->
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
import {listRecord, delRecord, addRecord,} from "@/api/system/record";
import {parseTime} from "../../../utils/ruoyi";
import {mixin_printHTML} from "../../dashboard/mixins/print";
import {mixin_record_uploadFiles} from "../../dashboard/mixins/record/record_upload";
import {listCompany} from "../../../api/system/company";
import SearchOption from "../../../components/SearchOption.vue";
import {excludeParams} from "../../../api/tool/exclude";
import {TableName} from "../../../api/tool/enums";
import {listInvoiceOther} from "../../../api/system/invoiceOther";
import CheckFiles from "../../../components/CheckFiles.vue";
import {mixin_record_fill} from "./recordFill";
import {CASH_TYPE} from "./constrant";
import {getRecord, updateRecord} from "../../../api/system/record";
import {mixin_checkfile} from "../../dashboard/mixins/checkfiles/mixin_checkfile";
import {listBankAccount} from "../../../api/system/bankAccount";

export default {
  name: "Record",
  // 计算属性
  computed: {
    CASH_TYPE() {
      return CASH_TYPE
    },
    // 交易双方的计算属性 这是来源
    source() {
      // 如果是冲抵货款 那么就是用货款来去冲抵金额
      if (this.cashType === CASH_TYPE.OFF_SETTING) {
        return '收入方金额'
      }

      // 如果是冲抵第三方开票
      if (this.cashType === CASH_TYPE.INVOICE_OTHER) {
        return '供应商'
      }

      if (this.cashType === 'transfer') {
        return '收入方'
      }
    },
    // 这是目标原
    target() {
      if (this.cashType === CASH_TYPE.OFF_SETTING) {
        return '支出方金额'
      }

      if (this.cashType === CASH_TYPE.INVOICE_OTHER) {
        return '客户'
      }
      if (this.cashType === 'transfer') {
        return '支出方'
      }
    }
  },
  components: {CheckFiles, SearchOption},
  mixins: [mixin_printHTML, mixin_record_fill, mixin_record_uploadFiles, mixin_checkfile],
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
        delFlag: null,
        sourceCompanyName: null,
        targetCompanyName: null,
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

      // 冲抵类型 默认为冲抵货款
      cashType: CASH_TYPE.OFF_SETTING
    };
  },
  watch: {
    'cashType': {
      handler(val) {
        // 只要冲抵类型改变那么就是要重新赋值表单
        this.reset()
      },
      immediate: true
    }
  },
  created() {
    this.getList();
  },
  methods: {
    listBankAccount,
    updateRecord() {
      return updateRecord
    },
    getRecord() {
      return getRecord
    },
    listInvoiceOther,
    listCompany,
    parseTime,
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
      this.$refs.uploadFile.clearFileList()
    },
    // 表单重置
    reset() {
      this.form = {
        id: null,
        transactionTime: null,
        sourceId: null,
        targetId: null,
        amount: null,
        referenceTableId: null,
        referenceTableName: null,
        attachment: null,
        remarks: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null,
        // 收入方与支付方的公司类型
        sourceCompanyType: '客户',
        targetCompanyType: '客户',
      };
      // 把展示字段给赋值为null
      this.sourceName = null
      this.targetName = null
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
      this.title = "添加冲抵款";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      //根据类型赋值
      this.reset();
      const id = row.id || this.ids
      getRecord(id).then(response => {
        this.form = response.data;
        // 填充冲抵类型
        this.cashType = response.data.referenceTableName;


        // 根据冲抵类型 分别赋值
        if (this.cashType === CASH_TYPE.OFF_SETTING) {
          // 填充支付方类型
          this.form.targetCompanyType = response.data.targetCompanyType
          // 填充收方类型
          this.form.sourceCompanyType = response.data.sourceCompanyType
          // 填充原和去的公司名称
          this.sourceName = response.data.sourceCompanyName;
          this.targetName = response.data.targetCompanyName;

        } else {
          // 填充原和去的公司名称
          this.sourceName = response.data.sourceCompanyName;
          this.targetName = response.data.targetCompanyName;

          // 填充id
          this.form.referenceTableId = response.data.referenceTableId;
        }


        this.open = true;
        this.title = "修改冲抵款";
      });
    },
    /** 提交按钮 */
    submitForm() {

      // fixme
      this.$refs["form"].validate(valid => {
        if (valid) {
          // 如果id不为空 那么就是修改操作
          if (this.form.id != null) {
            this.form = excludeParams(this.form, this.$exclude)
            updateRecord(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
              // 清除上传的文件列表
              this.$refs.uploadFile.clearFileList()
            });

            // 如果id为空 那么就是新增操作
          } else {
            // 如果是冲抵货款 那么就是填充一个非法的tableName和tID
            if (this.cashType === CASH_TYPE.OFF_SETTING) {
              this.form.referenceTableName = TableName.OFFSETTING;
              this.form.referenceTableId = -1;

              // 如果是内部转账 那么就填充参数
            } else {
              this.form.referenceTableName = CASH_TYPE.TRANSFER;
              this.form.referenceTableId = -1;
            }
            // 清理一下不必要的参数
            this.form = excludeParams(this.form, this.$exclude)
            // 发送请求 添加一条冲抵款(原为现金记账)信息
            addRecord(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
              // 清除上传的文件列表
              this.$refs.uploadFile.clearFileList()
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
