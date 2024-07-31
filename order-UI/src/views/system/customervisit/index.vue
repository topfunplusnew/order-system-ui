<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="客户" prop="province">
        <el-input
          v-model="queryParams.province"
          placeholder="请输入客户姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="区域" prop="city">
        <el-input
          v-model="queryParams.city"
          placeholder="请输入区域"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="日期" prop="county">
        <el-input
          v-model="queryParams.county"
          placeholder="请输入日期"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="姓名" prop="equipment">
        <el-input
          v-model="queryParams.equipment"
          placeholder="请输入姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>

      <el-form-item>
      <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>

      <el-form-item>
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
          v-hasPermi="['system:CustomerVisit:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          @click="handleUpdate"
          :disabled="single"
          v-hasPermi="['system:CustomerVisit:edit']"
        >修改</el-button>
        <!--初始状态不能点击-->
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          @click="handleDelete"
          :disabled="multiple"
          v-hasPermi="['system:CustomerVisit:remove']"
        >删除</el-button>
         <!--初始状态不能点击-->

      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          size="mini"
          icon="el-icon-download"
          @click="handleExport"
          v-hasPermi="['system:CustomerVisit:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="CustomerVisitList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="ID" />
      <el-table-column label="是否审核" align="center" prop="isCheckState" />
      <el-table-column label="人员" align="center" prop="personnel" />
      <el-table-column label="区域" align="center" prop="region" />
      <el-table-column label="客户名称" align="center" prop="customer" />
      <el-table-column label="负责人姓名" align="center" prop="leaderName" />
      <el-table-column label="负责人电话" align="center" prop="LeaderTel" />
      <el-table-column label="厂房设备" align="center" prop="equipment" />
      <el-table-column label="竞争对手" align="center" prop="competitor" />
      <el-table-column label="当地经销商" align="center" prop="localDealer" />
      <el-table-column label="月用货量" align="center" prop="monthlyConsumption" />
      <el-table-column label="白玻用货习惯及厂家" align="center" prop="whiteGlassFactory" />
      <el-table-column label="lowe玻璃用货厂家及用量" align="center" prop="loweGlassConsumption" />
      <el-table-column label="色玻、过度色玻璃用货厂家及用量" align="center" prop="colorGlassConsumption" />
      <el-table-column label="特色厚度、特殊尺寸、协议品用货厂家及用量" align="center" prop="specialGlassConsumption" />
      <el-table-column label="备注" align="center" prop="comments" />
      <el-table-column label="提交时间" align="center" prop="submittime" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:CustomerVisit:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:CustomerVisit:remove']"
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

    <!-- 添加或修改走访记录对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="省" prop="province">
          <el-input v-model="form.province" placeholder="请输入省" />
        </el-form-item>
        <el-form-item label="市县" prop="city">
          <el-input v-model="form.city" placeholder="请输入市县" />
        </el-form-item>
        <el-form-item label="乡镇" prop="county">
          <el-input v-model="form.county" placeholder="请输入乡镇" />
        </el-form-item>
        <el-form-item label="客户" prop="customer">
          <el-input v-model="form.customer" type="textarea" placeholder="请输入内容" />
        </el-form-item>
        <el-form-item label="负责人" prop="leaderName">
          <el-input v-model="form.leaderName" type="textarea" placeholder="请输入内容" />
        </el-form-item>
        <el-form-item label="负责人电话" prop="LeaderTel">
          <el-input v-model="form.LeaderTel" type="textarea" placeholder="请输入内容" />
        </el-form-item>
        <el-form-item label="厂房设备" prop="equipment">
          <el-input v-model="form.equipment" placeholder="请输入厂房设备" />
        </el-form-item>
        <el-form-item label="竞争对手" prop="competitor">
          <el-input v-model="form.competitor" placeholder="请输入竞争对手" />
        </el-form-item>
        <el-form-item label="当地经销商" prop="localDealer">
          <el-input v-model="form.localDealer" placeholder="请输入当地经销商" />
        </el-form-item>
        <el-form-item label="月用货量" prop="monthlyConsumption">
          <el-input v-model="form.monthlyConsumption" placeholder="请输入月用货量" />
        </el-form-item>
        <el-form-item label="白玻用货习惯及厂家" prop="whiteGlassFactory">
          <el-input v-model="form.whiteGlassFactory" placeholder="请输入白玻用货习惯及厂家" />
        </el-form-item>
        <el-form-item label="lowe玻璃用货厂家及用量" prop="loweGlassConsumption">
          <el-input v-model="form.loweGlassConsumption" placeholder="请输入lowe玻璃用货厂家及用量" />
        </el-form-item>
        <el-form-item label="色玻、过度色玻璃用货厂家及用量" prop="colorGlassConsumption">
          <el-input v-model="form.colorGlassConsumption" placeholder="请输入色玻、过度色玻璃用货厂家及用量" />
        </el-form-item>
        <el-form-item label="特色厚度、特殊尺寸、协议品用货厂家及用量" prop="specialGlassConsumption">
          <el-input v-model="form.specialGlassConsumption" placeholder="请输入特色厚度、特殊尺寸、协议品用货厂家及用量" />
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
        <el-form-item label="走访日期" prop="visitDate">
          <el-input v-model="form.visitDate" placeholder="请输入走访日期" />
        </el-form-item>
        <el-form-item label="审核标志" prop="checkState">
          <el-input v-model="form.checkState" placeholder="请输入审核标志" />
        </el-form-item>
        <el-form-item label="审核人ID" prop="checkUserID">
          <el-input v-model="form.checkUserID" placeholder="请输入审核人ID" />
        </el-form-item>
        <el-form-item label="审核人" prop="checkUserName">
          <el-input v-model="form.checkUserName" placeholder="请输入审核人" />
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
import { listCustomerVisit, getCustomerVisit, delCustomerVisit, addCustomerVisit, updateCustomerVisit } from "@/api/system/CustomerVisit";

export default {
  name: "CustomerVisit",
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
      // 走访记录表格数据
      CustomerVisitList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        province: null,
        city: null,
        county: null,
        customer: null,
        leaderName: null,
        LeaderTel: null,
        equipment: null,
        competitor: null,
        localDealer: null,
        monthlyConsumption: null,
        whiteGlassFactory: null,
        loweGlassConsumption: null,
        colorGlassConsumption: null,
        specialGlassConsumption: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        visitDate: null,
        checkState: null,
        checkUserID: null,
        checkUserName: null,
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
    /** 查询走访记录列表 */
    getList() {
      this.loading = true;
      listCustomerVisit(this.queryParams).then(response => {
        this.CustomerVisitList = response.rows;
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
        province: null,
        city: null,
        county: null,
        customer: null,
        leaderName: null,
        LeaderTel: null,
        equipment: null,
        competitor: null,
        localDealer: null,
        monthlyConsumption: null,
        whiteGlassFactory: null,
        loweGlassConsumption: null,
        colorGlassConsumption: null,
        specialGlassConsumption: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        visitDate: null,
        checkState: null,
        checkUserID: null,
        checkUserName: null,
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
      this.title = "添加走访记录";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getCustomerVisit(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改走访记录";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateCustomerVisit(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addCustomerVisit(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除走访记录编号为"' + ids + '"的数据项？').then(function() {
        return delCustomerVisit(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/CustomerVisit/export', {
        ...this.queryParams
      }, `CustomerVisit_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
