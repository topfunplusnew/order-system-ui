<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="操作日期" prop="operateDate">
        <el-input
          v-model="queryParams.operateDate"
          placeholder="请输入操作日期"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="票据号码" prop="billNo">
        <el-input
          v-model="queryParams.billNo"
          placeholder="请输入票据号码"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="出票日期" prop="issueDate">
        <el-input
          v-model="queryParams.issueDate"
          placeholder="请输入出票日期"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="到期日期" prop="dueDate">
        <el-input
          v-model="queryParams.dueDate"
          placeholder="请输入到期日期"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="我方承兑账户" prop="billAccount">
        <el-input
          v-model="queryParams.billAccount"
          placeholder="请输入我方承兑账户"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="票据日期" prop="billDate">
        <el-input
          v-model="queryParams.billDate"
          placeholder="请输入票据日期"
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
      <el-form-item label="票据金额" prop="billAmount">
        <el-input
          v-model="queryParams.billAmount"
          placeholder="请输入票据金额"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="贴息点数" prop="inDiscountPoints">
        <el-input
          v-model="queryParams.inDiscountPoints"
          placeholder="请输入贴息点数"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="贴息金额" prop="inDiscountAmount">
        <el-input
          v-model="queryParams.inDiscountAmount"
          placeholder="请输入贴息金额"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="票据种类" prop="billCategory">
        <el-input
          v-model="queryParams.billCategory"
          placeholder="请输入票据种类"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="来源" prop="origin">
        <el-input
          v-model="queryParams.origin"
          placeholder="请输入来源"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="背书人" prop="endorser">
        <el-input
          v-model="queryParams.endorser"
          placeholder="请输入背书人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="被背书人" prop="endorsee">
        <el-input
          v-model="queryParams.endorsee"
          placeholder="请输入被背书人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="背书事由" prop="endorseReason">
        <el-input
          v-model="queryParams.endorseReason"
          placeholder="请输入背书事由"
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
      <el-form-item label="删除标记" prop="delFlag">
        <el-input
          v-model="queryParams.delFlag"
          placeholder="请输入删除标记"
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
          v-hasPermi="['system:bankAcceptance:add']"
        >新增
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['system:bankAcceptance:edit']"
        >修改
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
          v-hasPermi="['system:bankAcceptance:remove']"
        >删除
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:bankAcceptance:export']"
        >导出
        </el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-horizontal-scroll="'always'" v-loading="loading" :data="bankAcceptanceList"
              @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center"/>
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="操作日期" align="center" prop="operateDate"/>
      <el-table-column label="票据号码" align="center" prop="billNo"/>
      <el-table-column label="出票日期" align="center" prop="issueDate"/>
      <el-table-column label="到期日期" align="center" prop="dueDate"/>
      <el-table-column label="我方承兑账户" align="center" prop="billAccount"/>
      <el-table-column label="票据日期" align="center" prop="billDate"/>
      <el-table-column label="分类" align="center" prop="billType"/>
      <el-table-column label="事由" align="center" prop="reason"/>
      <el-table-column label="票据金额" align="center" prop="billAmount"/>
      <el-table-column label="贴息点数" align="center" prop="inDiscountPoints"/>
      <el-table-column label="贴息金额" align="center" prop="inDiscountAmount"/>
      <el-table-column label="票据种类" align="center" prop="billCategory"/>
      <el-table-column label="来源" align="center" prop="origin"/>
      <el-table-column label="背书人" align="center" prop="endorser"/>
      <el-table-column label="被背书人" align="center" prop="endorsee"/>
      <el-table-column label="背书事由" align="center" prop="endorseReason"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <el-table-column label="添加时间" align="center" prop="addtime"/>
      <el-table-column label="操作人员ID" align="center" prop="userId"/>
      <el-table-column label="操作人员姓名" align="center" prop="UserName"/>
      <el-table-column label="删除标记" align="center" prop="delFlag"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:bankAcceptance:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:bankAcceptance:remove']"
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

    <!-- 添加或修改商业票据、银行承兑对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="操作日期" prop="operateDate">
          <el-input v-model="form.operateDate" placeholder="请输入操作日期"/>
        </el-form-item>
        <el-form-item label="票据号码" prop="billNo">
          <el-input v-model="form.billNo" placeholder="请输入票据号码"/>
        </el-form-item>
        <el-form-item label="出票日期" prop="issueDate">
          <el-input v-model="form.issueDate" placeholder="请输入出票日期"/>
        </el-form-item>
        <el-form-item label="到期日期" prop="dueDate">
          <el-input v-model="form.dueDate" placeholder="请输入到期日期"/>
        </el-form-item>
        <el-form-item label="我方承兑账户" prop="billAccount">
          <el-input v-model="form.billAccount" placeholder="请输入我方承兑账户"/>
        </el-form-item>
        <el-form-item label="票据日期" prop="billDate">
          <el-input v-model="form.billDate" placeholder="请输入票据日期"/>
        </el-form-item>
        <el-form-item label="事由" prop="reason">
          <el-input v-model="form.reason" placeholder="请输入事由"/>
        </el-form-item>
        <el-form-item label="票据金额" prop="billAmount">
          <el-input v-model="form.billAmount" placeholder="请输入票据金额"/>
        </el-form-item>
        <el-form-item label="贴息点数" prop="inDiscountPoints">
          <el-input v-model="form.inDiscountPoints" placeholder="请输入贴息点数"/>
        </el-form-item>
        <el-form-item label="贴息金额" prop="inDiscountAmount">
          <el-input v-model="form.inDiscountAmount" placeholder="请输入贴息金额"/>
        </el-form-item>
        <el-form-item label="票据种类" prop="billCategory">
          <el-input v-model="form.billCategory" placeholder="请输入票据种类"/>
        </el-form-item>
        <el-form-item label="来源" prop="origin">
          <el-input v-model="form.origin" placeholder="请输入来源"/>
        </el-form-item>
        <el-form-item label="背书人" prop="endorser">
          <el-input v-model="form.endorser" placeholder="请输入背书人"/>
        </el-form-item>
        <el-form-item label="被背书人" prop="endorsee">
          <el-input v-model="form.endorsee" placeholder="请输入被背书人"/>
        </el-form-item>
        <el-form-item label="背书事由" prop="endorseReason">
          <el-input v-model="form.endorseReason" placeholder="请输入背书事由"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注"/>
        </el-form-item>
        <el-form-item label="添加时间" prop="addtime">
          <el-input v-model="form.addtime" placeholder="请输入添加时间"/>
        </el-form-item>
        <el-form-item label="操作人员ID" prop="userId">
          <el-input v-model="form.userId" placeholder="请输入操作人员ID"/>
        </el-form-item>
        <el-form-item label="操作人员姓名" prop="UserName">
          <el-input v-model="form.UserName" placeholder="请输入操作人员姓名"/>
        </el-form-item>
        <el-form-item label="删除标记" prop="delFlag">
          <el-input v-model="form.delFlag" placeholder="请输入删除标记"/>
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
  listBankAcceptance,
  getBankAcceptance,
  delBankAcceptance,
  addBankAcceptance,
  updateBankAcceptance
} from "@/api/system/bankAcceptance";

export default {
  name: "BankAcceptance",
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
      // 商业票据、银行承兑表格数据
      bankAcceptanceList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        operateDate: null,
        billNo: null,
        issueDate: null,
        dueDate: null,
        billAccount: null,
        billDate: null,
        billType: null,
        reason: null,
        billAmount: null,
        inDiscountPoints: null,
        inDiscountAmount: null,
        billCategory: null,
        origin: null,
        endorser: null,
        endorsee: null,
        endorseReason: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {}
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询商业票据、银行承兑列表 */
    getList() {
      this.loading = true;
      listBankAcceptance(this.queryParams).then(response => {
        this.bankAcceptanceList = response.rows;
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
        operateDate: null,
        billNo: null,
        issueDate: null,
        dueDate: null,
        billAccount: null,
        billDate: null,
        billType: null,
        reason: null,
        billAmount: null,
        inDiscountPoints: null,
        inDiscountAmount: null,
        billCategory: null,
        origin: null,
        endorser: null,
        endorsee: null,
        endorseReason: null,
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
      this.title = "添加商业票据、银行承兑";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getBankAcceptance(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改商业票据、银行承兑";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            updateBankAcceptance(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            addBankAcceptance(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除商业票据、银行承兑编号为"' + ids + '"的数据项？').then(function () {
        return delBankAcceptance(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/bankAcceptance/export', {
        ...this.queryParams
      }, `bankAcceptance_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
<style>
//隐藏原有滚动条
.el-table__body-wrapper::-webkit-scrollbar {
  /*width: 0;宽度为0隐藏*/
  width: 0px;
}

.el-table__body-wrapper::-webkit-scrollbar-thumb {
  border-radius: 2px;
  height: 50px;
  background: #eee;
}

.el-table__body-wrapper::-webkit-scrollbar-track {
  box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
  border-radius: 2px;
  background: rgba(0, 0, 0, 0.4);
}

.el-table--scrollable-y .el-table__body-wrapper {
  overflow: hidden !important;
}

.el-table--scrollable-x .el-table__body-wrapper {
  overflow: hidden !important;
}
</style>
