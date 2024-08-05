<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="出差编号UUID" prop="bTripId">
        <el-input
          v-model="queryParams.bTripId"
          placeholder="请输入出差编号UUID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="加油卡卡号" prop="oilCardNo">
        <el-input
          v-model="queryParams.oilCardNo"
          placeholder="请输入加油卡卡号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="充值金额" prop="rechargeMoney">
        <el-input
          v-model="queryParams.rechargeMoney"
          placeholder="请输入充值金额"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="充值时间" prop="rechargeDate">
        <el-input
          v-model="queryParams.rechargeDate"
          placeholder="请输入充值时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="银行开户名" prop="acountsName">
        <el-input
          v-model="queryParams.acountsName"
          placeholder="请输入银行开户名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="银行账号" prop="bankNo">
        <el-input
          v-model="queryParams.bankNo"
          placeholder="请输入银行账号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="充值人员姓名" prop="rechargeName">
        <el-input
          v-model="queryParams.rechargeName"
          placeholder="请输入充值人员姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="充值附件" prop="attachment">
        <el-input
          v-model="queryParams.attachment"
          placeholder="请输入充值附件"
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
          v-hasPermi="['system:oilrecharge:add']"
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
          v-hasPermi="['system:oilrecharge:edit']"
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
          v-hasPermi="['system:oilrecharge:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:oilrecharge:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="oilRechargeList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="id" align="center" prop="id" />
      <el-table-column label="出差编号UUID" align="center" prop="bTripId" />
      <el-table-column label="加油卡卡号" align="center" prop="oilCardNo" />
      <el-table-column label="充值类型" align="center" prop="rechargeType" />
      <el-table-column label="充值金额" align="center" prop="rechargeMoney" />
      <el-table-column label="充值时间" align="center" prop="rechargeDate" />
      <el-table-column label="银行开户名" align="center" prop="acountsName" />
      <el-table-column label="银行账号" align="center" prop="bankNo" />
      <el-table-column label="充值人员姓名" align="center" prop="rechargeName" />
      <el-table-column label="充值附件" align="center" prop="attachment" />
      <el-table-column label="备注" align="center" prop="comments" />
      <el-table-column label="添加时间" align="center" prop="addtime" />
      <el-table-column label="操作人员ID" align="center" prop="userId" />
      <el-table-column label="操作人员姓名" align="center" prop="UserName" />
      <el-table-column label="删除标记" align="center" prop="delFlag" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:oilrecharge:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:oilrecharge:remove']"
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

    <!-- 添加或修改加油卡充值信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="出差编号UUID" prop="bTripId">
          <el-input v-model="form.bTripId" placeholder="请输入出差编号UUID" />
        </el-form-item>
        <el-form-item label="加油卡卡号" prop="oilCardNo">
          <el-input v-model="form.oilCardNo" placeholder="请输入加油卡卡号" />
        </el-form-item>
        <el-form-item label="充值金额" prop="rechargeMoney">
          <el-input v-model="form.rechargeMoney" placeholder="请输入充值金额" />
        </el-form-item>
        <el-form-item label="充值时间" prop="rechargeDate">
          <el-input v-model="form.rechargeDate" placeholder="请输入充值时间" />
        </el-form-item>
        <el-form-item label="银行开户名" prop="acountsName">
          <el-input v-model="form.acountsName" placeholder="请输入银行开户名" />
        </el-form-item>
        <el-form-item label="银行账号" prop="bankNo">
          <el-input v-model="form.bankNo" placeholder="请输入银行账号" />
        </el-form-item>
        <el-form-item label="充值人员姓名" prop="rechargeName">
          <el-input v-model="form.rechargeName" placeholder="请输入充值人员姓名" />
        </el-form-item>
        <el-form-item label="充值附件" prop="attachment">
          <el-input v-model="form.attachment" placeholder="请输入充值附件" />
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
import { listOilRecharge, getOilRecharge, delOilRecharge, addOilRecharge, updateOilRecharge } from "@/api/system/oilRecharge";

export default {
  name: "OilRecharge",
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
      // 加油卡充值信息表格数据
      oilRechargeList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        bTripId: null,
        oilCardNo: null,
        rechargeType: null,
        rechargeMoney: null,
        rechargeDate: null,
        acountsName: null,
        bankNo: null,
        rechargeName: null,
        attachment: null,
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
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询加油卡充值信息列表 */
    getList() {
      this.loading = true;
      listOilRecharge(this.queryParams).then(response => {
        this.oilRechargeList = response.rows;
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
        bTripId: null,
        oilCardNo: null,
        rechargeType: null,
        rechargeMoney: null,
        rechargeDate: null,
        acountsName: null,
        bankNo: null,
        rechargeName: null,
        attachment: null,
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
      this.title = "添加加油卡充值信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getOilRecharge(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改加油卡充值信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateOilRecharge(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addOilRecharge(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除加油卡充值信息编号为"' + ids + '"的数据项？').then(function() {
        return delOilRecharge(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/oilRecharge/export', {
        ...this.queryParams
      }, `oilRecharge_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
