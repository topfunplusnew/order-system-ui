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
      <el-form-item label="付款时间" prop="payTime">
        <el-input
          v-model="queryParams.payTime"
          placeholder="请输入付款时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="付款类型" prop="payState">
        <el-input
          v-model="queryParams.payState"
          placeholder="请输入付款类型"
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
          v-hasPermi="['system:liabilities:add']"
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
          v-hasPermi="['system:liabilities:edit']"
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
          v-hasPermi="['system:liabilities:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:liabilities:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="liabilitiesList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="${comment}" align="center" prop="id" />
      <el-table-column label="付款编号" align="center" prop="payNO" />
      <el-table-column label="金额" align="center" prop="moneyAmount" />
      <el-table-column label="付款类型" align="center" prop="payType" />
      <el-table-column label="对方户名" align="center" prop="otherAcountsName" />
      <el-table-column label="对方账号" align="center" prop="otherBankNo" />
      <el-table-column label="对方开户行" align="center" prop="otherBankName" />
      <el-table-column label="对方账号ID" align="center" prop="otherBankID" />
      <el-table-column label="己方户名" align="center" prop="selfAcountsName" />
      <el-table-column label="己方账号" align="center" prop="selfBankNo" />
      <el-table-column label="己方开户行" align="center" prop="selfBankName" />
      <el-table-column label="己方账号ID" align="center" prop="selfBankID" />
      <el-table-column label="付款时间" align="center" prop="payTime" />
      <el-table-column label="付款类型" align="center" prop="payState" />
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
            v-hasPermi="['system:liabilities:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:liabilities:remove']"
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

    <!-- 添加或修改负债信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="付款编号" prop="payNO">
          <el-input v-model="form.payNO" placeholder="请输入付款编号" />
        </el-form-item>
        <el-form-item label="金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入金额" />
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
        <el-form-item label="付款时间" prop="payTime">
          <el-input v-model="form.payTime" placeholder="请输入付款时间" />
        </el-form-item>
        <el-form-item label="付款类型" prop="payState">
          <el-input v-model="form.payState" placeholder="请输入付款类型" />
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
import { listLiabilities, getLiabilities, delLiabilities, addLiabilities, updateLiabilities } from "@/api/system/liabilities";

export default {
  name: "Liabilities",
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
      // 负债信息表格数据
      liabilitiesList: [],
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
        payType: null,
        otherAcountsName: null,
        otherBankNo: null,
        otherBankName: null,
        otherBankID: null,
        selfAcountsName: null,
        selfBankNo: null,
        selfBankName: null,
        selfBankID: null,
        payTime: null,
        payState: null,
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
    /** 查询负债信息列表 */
    getList() {
      this.loading = true;
      listLiabilities(this.queryParams).then(response => {
        this.liabilitiesList = response.rows;
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
        payType: null,
        otherAcountsName: null,
        otherBankNo: null,
        otherBankName: null,
        otherBankID: null,
        selfAcountsName: null,
        selfBankNo: null,
        selfBankName: null,
        selfBankID: null,
        payTime: null,
        payState: null,
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
      this.title = "添加负债信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getLiabilities(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改负债信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateLiabilities(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addLiabilities(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除负债信息编号为"' + ids + '"的数据项？').then(function() {
        return delLiabilities(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/liabilities/export', {
        ...this.queryParams
      }, `liabilities_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
