<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="主加油卡卡号" prop="oilMainCardNo">
        <el-input
          v-model="queryParams.oilMainCardNo"
          placeholder="请输入主加油卡卡号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="副加油卡卡号" prop="oilSecondCardNo">
        <el-input
          v-model="queryParams.oilSecondCardNo"
          placeholder="请输入副加油卡卡号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="充值时间" prop="rechargeDate">
        <el-date-picker
          v-model="queryParams.rechargeDate"
          type="date"
          placeholder="选择充值时间" value-format="timestamp">
        </el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
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
          v-hasPermi="['system:oilcardfundtransfer:add']"
        >新增加油卡圈存信息
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
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
              v-hasPermi="['system:inventory:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="oilCardFundTransferList" @selection-change="handleSelectionChange"
              v-horizontal-scroll="'always'" id="printBox">
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="主加油卡卡号" align="center" prop="oilMainCardNo"/>
      <el-table-column label="副加油卡卡号" align="center" prop="oilSecondCardNo"/>
      <el-table-column label="充值金额" align="center" prop="rechargeMoney"/>
      <el-table-column label="充值时间" align="center" prop="rechargeDate"/>
      <el-table-column label="充值人员姓名" align="center" prop="rechargeName"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:oilcardfundtransfer:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:oilcardfundtransfer:remove']"
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

    <!-- 添加或修改加油卡圈存对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="主加油卡卡号" prop="oilMainCardNo">
          <el-input v-model="form.oilMainCardNo" placeholder="请输入主加油卡卡号"/>
        </el-form-item>
        <el-form-item label="副加油卡卡号" prop="oilSecondCardNo">
          <el-input v-model="form.oilSecondCardNo" placeholder="请输入副加油卡卡号"/>
        </el-form-item>
        <el-form-item label="充值金额" prop="rechargeMoney">
          <el-input v-model="form.rechargeMoney" placeholder="请输入充值金额"/>
        </el-form-item>
        <el-form-item label="充值时间" prop="rechargeDate">
          <el-input v-model="form.rechargeDate" placeholder="请输入充值时间"/>
        </el-form-item>
        <el-form-item label="充值人员姓名" prop="rechargeName">
          <el-input v-model="form.rechargeName" placeholder="请输入充值人员姓名"/>
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
  listOilCardFundTransfer,
  getOilCardFundTransfer,
  delOilCardFundTransfer,
  addOilCardFundTransfer,
  updateOilCardFundTransfer
} from "@/api/system/oilCardFundTransfer";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";

export default {
  name: "OilCardFundTransfer",
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
      // 加油卡圈存表格数据
      oilCardFundTransferList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        oilMainCardNo: null,
        oilSecondCardNo: null,
        rechargeMoney: null,
        rechargeDate: null,
        rechargeName: null,
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
      columns: []
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询加油卡圈存列表 */
    getList() {
      this.loading = true;
      listOilCardFundTransfer(this.queryParams).then(response => {
        this.oilCardFundTransferList = response.rows;
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
        oilMainCardNo: null,
        oilSecondCardNo: null,
        rechargeMoney: null,
        rechargeDate: null,
        rechargeName: null,
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
      this.title = "添加加油卡圈存";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getOilCardFundTransfer(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改加油卡圈存";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateOilCardFundTransfer(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addOilCardFundTransfer(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除加油卡圈存编号为"' + ids + '"的数据项？').then(function () {
        return delOilCardFundTransfer(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/oilCardFundTransfer/export', {
        ...this.queryParams
      }, `oilCardFundTransfer_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
