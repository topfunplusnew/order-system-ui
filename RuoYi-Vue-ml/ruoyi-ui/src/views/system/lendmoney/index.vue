<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="付款编号" prop="payNO">
        <el-input
          v-model="queryParams.payNO"
          placeholder="请输入付款编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="金额" prop="moneyAmount">
        <el-input
          v-model="queryParams.moneyAmount"
          placeholder="请输入金额"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="公司/个人名称" prop="company">
        <el-input
          v-model="queryParams.company"
          placeholder="请输入公司/个人名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
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
      <el-form-item label="对方账号ID" prop="otherBankID">
        <el-input
          v-model="queryParams.otherBankID"
          placeholder="请输入对方账号ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="己方户名" prop="selfAcountsName">
        <el-input
          v-model="queryParams.selfAcountsName"
          placeholder="请输入己方户名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="己方账号" prop="selfBankNo">
        <el-input
          v-model="queryParams.selfBankNo"
          placeholder="请输入己方账号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="己方开户行" prop="selfBankName">
        <el-input
          v-model="queryParams.selfBankName"
          placeholder="请输入己方开户行"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="己方账号ID" prop="selfBankID">
        <el-input
          v-model="queryParams.selfBankID"
          placeholder="请输入己方账号ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="打入账户" prop="acountsName">
        <el-input
          v-model="queryParams.acountsName"
          placeholder="请输入打入账户"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="打入账号" prop="bankNo">
        <el-input
          v-model="queryParams.bankNo"
          placeholder="请输入打入账号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="打入时间" prop="payTime">
        <el-input
          v-model="queryParams.payTime"
          placeholder="请输入打入时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="缘由" prop="originReason">
        <el-input
          v-model="queryParams.originReason"
          placeholder="请输入缘由"
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
          v-hasPermi="['system:lendmoney:add']"
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
          v-hasPermi="['system:lendmoney:edit']"
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
          v-hasPermi="['system:lendmoney:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:lendmoney:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="lendmoneyList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="${comment}" align="center" prop="id" />
      <el-table-column label="付款编号" align="center" prop="payNO" />
      <el-table-column label="金额" align="center" prop="moneyAmount" />
      <el-table-column label="借出类型" align="center" prop="lendType" />
      <el-table-column label="公司/个人名称" align="center" prop="company" />
      <el-table-column label="对方户名" align="center" prop="otherAcountsName" />
      <el-table-column label="对方账号" align="center" prop="otherBankNo" />
      <el-table-column label="对方开户行" align="center" prop="otherBankName" />
      <el-table-column label="对方账号ID" align="center" prop="otherBankID" />
      <el-table-column label="己方户名" align="center" prop="selfAcountsName" />
      <el-table-column label="己方账号" align="center" prop="selfBankNo" />
      <el-table-column label="己方开户行" align="center" prop="selfBankName" />
      <el-table-column label="己方账号ID" align="center" prop="selfBankID" />
      <el-table-column label="打入账户" align="center" prop="acountsName" />
      <el-table-column label="打入账号" align="center" prop="bankNo" />
      <el-table-column label="打入时间" align="center" prop="payTime" />
      <el-table-column label="缘由" align="center" prop="originReason" />
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
            v-hasPermi="['system:lendmoney:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:lendmoney:remove']"
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

    <!-- 添加或修改借贷对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="付款编号" prop="payNO">
          <el-input v-model="form.payNO" placeholder="请输入付款编号" />
        </el-form-item>
        <el-form-item label="金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入金额" />
        </el-form-item>
        <el-form-item label="公司/个人名称" prop="company">
          <el-input v-model="form.company" placeholder="请输入公司/个人名称" />
        </el-form-item>
        <el-form-item label="对方户名" prop="otherAcountsName">
          <el-input v-model="form.otherAcountsName" placeholder="请输入对方户名" />
        </el-form-item>
        <el-form-item label="对方账号" prop="otherBankNo">
          <el-input v-model="form.otherBankNo" placeholder="请输入对方账号" />
        </el-form-item>
        <el-form-item label="对方开户行" prop="otherBankName">
          <el-input v-model="form.otherBankName" placeholder="请输入对方开户行" />
        </el-form-item>
        <el-form-item label="对方账号ID" prop="otherBankID">
          <el-input v-model="form.otherBankID" placeholder="请输入对方账号ID" />
        </el-form-item>
        <el-form-item label="己方户名" prop="selfAcountsName">
          <el-input v-model="form.selfAcountsName" placeholder="请输入己方户名" />
        </el-form-item>
        <el-form-item label="己方账号" prop="selfBankNo">
          <el-input v-model="form.selfBankNo" placeholder="请输入己方账号" />
        </el-form-item>
        <el-form-item label="己方开户行" prop="selfBankName">
          <el-input v-model="form.selfBankName" placeholder="请输入己方开户行" />
        </el-form-item>
        <el-form-item label="己方账号ID" prop="selfBankID">
          <el-input v-model="form.selfBankID" placeholder="请输入己方账号ID" />
        </el-form-item>
        <el-form-item label="打入账户" prop="acountsName">
          <el-input v-model="form.acountsName" placeholder="请输入打入账户" />
        </el-form-item>
        <el-form-item label="打入账号" prop="bankNo">
          <el-input v-model="form.bankNo" placeholder="请输入打入账号" />
        </el-form-item>
        <el-form-item label="打入时间" prop="payTime">
          <el-input v-model="form.payTime" placeholder="请输入打入时间" />
        </el-form-item>
        <el-form-item label="缘由" prop="originReason">
          <el-input v-model="form.originReason" placeholder="请输入缘由" />
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
import { listLendmoney, getLendmoney, delLendmoney, addLendmoney, updateLendmoney } from "@/api/system/lendmoney";

export default {
  name: "Lendmoney",
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
      // 借贷表格数据
      lendmoneyList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        payNO: null,
        moneyAmount: null,
        lendType: null,
        company: null,
        otherAcountsName: null,
        otherBankNo: null,
        otherBankName: null,
        otherBankID: null,
        selfAcountsName: null,
        selfBankNo: null,
        selfBankName: null,
        selfBankID: null,
        acountsName: null,
        bankNo: null,
        payTime: null,
        originReason: null,
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
    /** 查询借贷列表 */
    getList() {
      this.loading = true;
      listLendmoney(this.queryParams).then(response => {
        this.lendmoneyList = response.rows;
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
        payNO: null,
        moneyAmount: null,
        lendType: null,
        company: null,
        otherAcountsName: null,
        otherBankNo: null,
        otherBankName: null,
        otherBankID: null,
        selfAcountsName: null,
        selfBankNo: null,
        selfBankName: null,
        selfBankID: null,
        acountsName: null,
        bankNo: null,
        payTime: null,
        originReason: null,
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
      this.title = "添加借贷";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getLendmoney(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改借贷";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateLendmoney(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addLendmoney(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除借贷编号为"' + ids + '"的数据项？').then(function() {
        return delLendmoney(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/lendmoney/export', {
        ...this.queryParams
      }, `lendmoney_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
