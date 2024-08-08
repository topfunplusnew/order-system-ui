<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <!--      <el-form-item label="对应的表名" prop="tableName">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.tableName"-->
      <!--          placeholder="请输入对应的表名"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="对应的表主键" prop="tID">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.tID"-->
      <!--          placeholder="请输入对应的表主键"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <el-form-item label="日期" prop="fundsDate">
        <el-input
          v-model="queryParams.fundsDate"
          placeholder="请输入日期"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <!--      <el-form-item label="金额" prop="moneyAmount">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.moneyAmount"-->
      <!--          placeholder="请输入金额"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <el-form-item label="对方户名" prop="otherAcountsName">
        <el-input
          v-model="queryParams.otherAcountsName"
          placeholder="请输入对方户名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="对方账号" prop="otherBankNo">
        <el-input
          v-model="queryParams.otherBankNo"
          placeholder="请输入对方账号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="对方开户行" prop="otherBankName">
        <el-input
          v-model="queryParams.otherBankName"
          placeholder="请输入对方开户行"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="对方公司" prop="companyName">
        <el-input
          v-model="queryParams.companyName"
          placeholder="请输入对方公司"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <!--      <el-form-item label="对方公司ID" prop="companyId">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.companyId"-->
      <!--          placeholder="请输入对方公司ID"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="申请人" prop="applyPerson">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.applyPerson"-->
      <!--          placeholder="请输入申请人"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="申请人ID" prop="applyPersonID">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.applyPersonID"-->
      <!--          placeholder="请输入申请人ID"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="审核状态" prop="checkState">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.checkState"-->
      <!--          placeholder="请输入审核状态"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="备注" prop="comments">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.comments"-->
      <!--          placeholder="请输入备注"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
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
          v-hasPermi="['system:paymentapply:add']"
        >新增付款信息
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
          v-hasPermi="['system:paymentapply:remove']"
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
              v-hasPermi="['system:company:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="paymentApplyList"
              @selection-change="handleSelectionChange" id="printBox">
      <el-table-column label="id" align="center" prop="id"/>
      <!--      <el-table-column label="对应的表名" align="center" prop="tableName"/>-->
      <!--      <el-table-column label="对应的表主键" align="center" prop="tID"/>-->
      <el-table-column label="日期" align="center" prop="fundsDate"/>
      <el-table-column label="支付类型" align="center" prop="payType"/>
      <el-table-column label="金额" align="center" prop="moneyAmount"/>
      <el-table-column label="对方户名" align="center" prop="otherAcountsName"/>
      <el-table-column label="对方账号" align="center" prop="otherBankNo"/>
      <el-table-column label="对方开户行" align="center" prop="otherBankName"/>
      <el-table-column label="对方公司" align="center" prop="companyName"/>
      <el-table-column label="对方公司ID" align="center" prop="companyId"/>
      <el-table-column label="对方公司类型" align="center" prop="companyType"/>
      <el-table-column label="付款原因" align="center" prop="reason"/>
      <el-table-column label="附件" align="center" prop="attachment"/>
      <el-table-column label="申请人" align="center" prop="applyPerson"/>
      <el-table-column label="申请人ID" align="center" prop="applyPersonID"/>
      <el-table-column label="审核状态" align="center" prop="checkState">
        <template slot-scope="scope">
          <el-tag
            :type="scope.row.checkState === '通过' ? 'success' : 'danger'"
            disable-transitions>{{ scope.row.checkState }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="comments"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:paymentapply:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:paymentapply:remove']"
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

    <!-- 添加或修改付款信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <!--        <el-form-item label="对应的表名" prop="tableName">-->
        <!--          <el-input v-model="form.tableName" placeholder="请输入对应的表名"/>-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="对应的表主键" prop="tID">-->
        <!--          <el-input v-model="form.tID" placeholder="请输入对应的表主键"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="日期" prop="fundsDate">
          <el-input v-model="form.fundsDate" placeholder="请输入日期"/>
        </el-form-item>
        <el-form-item label="金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入金额"/>
        </el-form-item>
        <el-form-item label="对方户名" prop="otherAcountsName">
          <el-input v-model="form.otherAcountsName" placeholder="请输入对方户名"/>
        </el-form-item>
        <el-form-item label="对方账号" prop="otherBankNo">
          <el-input v-model="form.otherBankNo" placeholder="请输入对方账号"/>
        </el-form-item>
        <el-form-item label="对方开户行" prop="otherBankName">
          <el-input v-model="form.otherBankName" placeholder="请输入对方开户行"/>
        </el-form-item>
        <el-form-item label="对方公司" prop="companyName">
          <el-input v-model="form.companyName" placeholder="请输入对方公司"/>
        </el-form-item>
        <el-form-item label="对方公司ID" prop="companyId">
          <el-input v-model="form.companyId" placeholder="请输入对方公司ID"/>
        </el-form-item>
        <el-form-item label="付款原因" prop="reason">
          <el-input v-model="form.reason" type="textarea" placeholder="请输入内容"/>
        </el-form-item>
        <el-form-item label="附件" prop="attachment">
          <el-input v-model="form.attachment" type="textarea" placeholder="请输入内容"/>
        </el-form-item>
        <el-form-item label="申请人" prop="applyPerson">
          <el-input v-model="form.applyPerson" placeholder="请输入申请人"/>
        </el-form-item>
        <el-form-item label="申请人ID" prop="applyPersonID">
          <el-input v-model="form.applyPersonID" placeholder="请输入申请人ID"/>
        </el-form-item>
        <el-form-item label="审核状态" prop="checkState">
          <el-input v-model="form.checkState" placeholder="请输入审核状态"/>
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
import {
  listPaymentApply,
  getPaymentApply,
  delPaymentApply,
  addPaymentApply,
  updatePaymentApply
} from "@/api/system/paymentApply";
import {excludeParams} from "@/api/tool/exclude";

export default {
  name: "PaymentApply",
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
      // 付款信息表格数据
      paymentApplyList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        tableName: null,
        tID: null,
        fundsDate: null,
        payType: null,
        moneyAmount: null,
        otherAcountsName: null,
        otherBankNo: null,
        otherBankName: null,
        companyName: null,
        companyId: null,
        companyType: null,
        reason: null,
        attachment: null,
        applyPerson: null,
        applyPersonID: null,
        checkState: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null,
        submitflag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      columns: [
        {key: 0, label: `收款编号`, visible: true},
        {key: 1, label: `日期`, visible: true},
        {key: 2, label: `支付类型`, visible: true},
        {key: 3, label: `金额`, visible: true},
        {key: 4, label: `己方户名`, visible: true},
        {key: 5, label: `己方账号`, visible: true},
        {key: 6, label: `己方开户行`, visible: true},
        {key: 7, label: `己方账号ID`, visible: true},
        {key: 8, label: `对方户名`, visible: true},
        {key: 9, label: `对方账号`, visible: true},
        {key: 10, label: `对方开户行`, visible: true},
        {key: 11, label: `对方公司`, visible: true},
        {key: 12, label: `对方公司ID`, visible: true},
        {key: 13, label: `对方公司类型`, visible: true},
      ],
    };
  },
  created() {
    this.getList();
  },
  methods: {
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    /** 查询付款信息列表 */
    getList() {
      this.loading = true;
      listPaymentApply(this.queryParams).then(response => {
        this.paymentApplyList = response.rows;
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
        tableName: null,
        tID: null,
        fundsDate: null,
        payType: null,
        moneyAmount: null,
        otherAcountsName: null,
        otherBankNo: null,
        otherBankName: null,
        companyName: null,
        companyId: null,
        companyType: null,
        reason: null,
        attachment: null,
        applyPerson: null,
        applyPersonID: null,
        checkState: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null,
        submitflag: null
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
      this.title = "添加付款信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getPaymentApply(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改付款信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            //排除不必要字段
            excludeParams(this, this.$exclude)
            updatePaymentApply(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addPaymentApply(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除付款信息编号为"' + ids + '"的数据项？').then(function () {
        return delPaymentApply(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/paymentApply/export', {
        ...this.queryParams
      }, `paymentApply_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
