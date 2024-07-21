<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="保证金编号" prop="futuresNO">
        <el-input
          v-model="queryParams.futuresNO"
          placeholder="请输入保证金编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="期货保证金公司" prop="futuresMarginCompany">
        <el-input
          v-model="queryParams.futuresMarginCompany"
          placeholder="请输入期货保证金公司"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="对象(员工、外面公司在我公司借款)" prop="target">
        <el-input
          v-model="queryParams.target"
          placeholder="请输入对象(员工、外面公司在我公司借款)"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="保证金金额" prop="moneyAmount">
        <el-input
          v-model="queryParams.moneyAmount"
          placeholder="请输入保证金金额"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="对方账户" prop="targetAcountsName">
        <el-input
          v-model="queryParams.targetAcountsName"
          placeholder="请输入对方账户"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="对方账号" prop="targetBankNo">
        <el-input
          v-model="queryParams.targetBankNo"
          placeholder="请输入对方账号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="对方开户行" prop="targetBankName">
        <el-input
          v-model="queryParams.targetBankName"
          placeholder="请输入对方开户行"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="我方支付账户" prop="selfAcountsName">
        <el-input
          v-model="queryParams.selfAcountsName"
          placeholder="请输入我方支付账户"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="我方账号" prop="selfBankNo">
        <el-input
          v-model="queryParams.selfBankNo"
          placeholder="请输入我方账号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="我方开户行" prop="selfBankName">
        <el-input
          v-model="queryParams.selfBankName"
          placeholder="请输入我方开户行"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="支付期货保证金时间" prop="futuresDate">
        <el-input
          v-model="queryParams.futuresDate"
          placeholder="请输入支付期货保证金时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="事由" prop="reason">
        <el-input
          v-model="queryParams.reason"
          placeholder="请输入事由"
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
          v-hasPermi="['system:futuresmargin:add']"
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
          v-hasPermi="['system:futuresmargin:edit']"
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
          v-hasPermi="['system:futuresmargin:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:futuresmargin:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="futuresmarginList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="${comment}" align="center" prop="id" />
      <el-table-column label="保证金编号" align="center" prop="futuresNO" />
      <el-table-column label="期货保证金公司" align="center" prop="futuresMarginCompany" />
      <el-table-column label="对象(员工、外面公司在我公司借款)" align="center" prop="target" />
      <el-table-column label="保证金金额" align="center" prop="moneyAmount" />
      <el-table-column label="对方账户" align="center" prop="targetAcountsName" />
      <el-table-column label="对方账号" align="center" prop="targetBankNo" />
      <el-table-column label="对方开户行" align="center" prop="targetBankName" />
      <el-table-column label="我方支付账户" align="center" prop="selfAcountsName" />
      <el-table-column label="我方账号" align="center" prop="selfBankNo" />
      <el-table-column label="我方开户行" align="center" prop="selfBankName" />
      <el-table-column label="支付期货保证金时间" align="center" prop="futuresDate" />
      <el-table-column label="事由" align="center" prop="reason" />
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
            v-hasPermi="['system:futuresmargin:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:futuresmargin:remove']"
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

    <!-- 添加或修改期货保证金信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="保证金编号" prop="futuresNO">
          <el-input v-model="form.futuresNO" placeholder="请输入保证金编号" />
        </el-form-item>
        <el-form-item label="期货保证金公司" prop="futuresMarginCompany">
          <el-input v-model="form.futuresMarginCompany" placeholder="请输入期货保证金公司" />
        </el-form-item>
        <el-form-item label="对象(员工、外面公司在我公司借款)" prop="target">
          <el-input v-model="form.target" placeholder="请输入对象(员工、外面公司在我公司借款)" />
        </el-form-item>
        <el-form-item label="保证金金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入保证金金额" />
        </el-form-item>
        <el-form-item label="对方账户" prop="targetAcountsName">
          <el-input v-model="form.targetAcountsName" placeholder="请输入对方账户" />
        </el-form-item>
        <el-form-item label="对方账号" prop="targetBankNo">
          <el-input v-model="form.targetBankNo" placeholder="请输入对方账号" />
        </el-form-item>
        <el-form-item label="对方开户行" prop="targetBankName">
          <el-input v-model="form.targetBankName" placeholder="请输入对方开户行" />
        </el-form-item>
        <el-form-item label="我方支付账户" prop="selfAcountsName">
          <el-input v-model="form.selfAcountsName" placeholder="请输入我方支付账户" />
        </el-form-item>
        <el-form-item label="我方账号" prop="selfBankNo">
          <el-input v-model="form.selfBankNo" placeholder="请输入我方账号" />
        </el-form-item>
        <el-form-item label="我方开户行" prop="selfBankName">
          <el-input v-model="form.selfBankName" placeholder="请输入我方开户行" />
        </el-form-item>
        <el-form-item label="支付期货保证金时间" prop="futuresDate">
          <el-input v-model="form.futuresDate" placeholder="请输入支付期货保证金时间" />
        </el-form-item>
        <el-form-item label="事由" prop="reason">
          <el-input v-model="form.reason" placeholder="请输入事由" />
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
import { listFuturesmargin, getFuturesmargin, delFuturesmargin, addFuturesmargin, updateFuturesmargin } from "@/api/system/futuresmargin";

export default {
  name: "Futuresmargin",
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
      // 期货保证金信息表格数据
      futuresmarginList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        futuresNO: null,
        futuresMarginCompany: null,
        target: null,
        moneyAmount: null,
        targetAcountsName: null,
        targetBankNo: null,
        targetBankName: null,
        selfAcountsName: null,
        selfBankNo: null,
        selfBankName: null,
        futuresDate: null,
        reason: null,
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
    /** 查询期货保证金信息列表 */
    getList() {
      this.loading = true;
      listFuturesmargin(this.queryParams).then(response => {
        this.futuresmarginList = response.rows;
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
        futuresNO: null,
        futuresMarginCompany: null,
        target: null,
        moneyAmount: null,
        targetAcountsName: null,
        targetBankNo: null,
        targetBankName: null,
        selfAcountsName: null,
        selfBankNo: null,
        selfBankName: null,
        futuresDate: null,
        reason: null,
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
      this.title = "添加期货保证金信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getFuturesmargin(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改期货保证金信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateFuturesmargin(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addFuturesmargin(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除期货保证金信息编号为"' + ids + '"的数据项？').then(function() {
        return delFuturesmargin(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/futuresmargin/export', {
        ...this.queryParams
      }, `futuresmargin_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
