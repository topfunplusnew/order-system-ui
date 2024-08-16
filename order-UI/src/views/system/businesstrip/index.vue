<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="出差时间" prop="starttime">
        <el-date-picker
            v-model="queryParams.starttime"
            type="date"
            placeholder="选择日期" value-format="timestamp">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="返回时间" prop="endtime">
        <el-date-picker
            v-model="queryParams.endtime"
            type="date"
            placeholder="选择日期" value-format="timestamp">
        </el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
            type="danger"
            plain
            size="mini"
            @click="handleAdd"
            v-hasPermi="['system:BusinessTrip:add']"
        >新增出差信息
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
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

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="BusinessTripList"
              @selection-change="handleSelectionChange">
      <!--      <el-table-column label="报销人ID" align="center" prop="employeeID"/>-->
      <el-table-column label="报销人" align="center" prop="employee"/>
      <el-table-column label="共同出差人员" align="center" prop="personnel"/>
      <el-table-column label="出差时间" align="center" prop="starttime"/>
      <el-table-column label="出差结束时间" align="center" prop="endtime"/>
      <el-table-column label="附件地址" align="center" prop="attachmentPath"/>
      <el-table-column label="是否已报销" align="center" prop="isReimburse"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
              size="mini"
              type="primary"
              @click="handleUpdate(scope.row)"
              v-hasPermi="['system:BusinessTrip:edit']"
          >修改
          </el-button>
          <el-button
              size="mini"
              type="danger"
              @click="handleDelete(scope.row)"
              v-hasPermi="['system:BusinessTrip:remove']"
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

    <!-- 添加或修改出差对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="报销人ID" prop="employeeID">
          <el-input v-model="form.employeeID" placeholder="请输入报销人ID"/>
        </el-form-item>
        <el-form-item label="报销人" prop="employee">
          <el-input v-model="form.employee" placeholder="请输入报销人"/>
        </el-form-item>
        <el-form-item label="共同出差人员" prop="personnel">
          <el-input v-model="form.personnel" placeholder="请输入共同出差人员"/>
        </el-form-item>
        <el-form-item label="出差时间" prop="starttime">
          <el-input v-model="form.starttime" placeholder="请输入出差时间"/>
        </el-form-item>
        <el-form-item label="出差结束时间" prop="endtime">
          <el-input v-model="form.endtime" placeholder="请输入出差结束时间"/>
        </el-form-item>
        <el-form-item label="附件地址" prop="attachmentPath">
          <el-input v-model="form.attachmentPath" placeholder="请输入附件地址"/>
        </el-form-item>
        <el-form-item label="是否已报销" prop="isReimburse">
          <el-input v-model="form.isReimburse" placeholder="请输入是否已报销"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" type="textarea" placeholder="请输入内容"/>
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
        <el-divider content-position="center">出差报销信息</el-divider>
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddTripReimbursement">添加
            </el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" icon="el-icon-delete" size="mini" @click="handleDeleteTripReimbursement">删除
            </el-button>
          </el-col>
        </el-row>
        <el-table :data="tripReimbursementList" :row-class-name="rowTripReimbursementIndex"
                  @selection-change="handleTripReimbursementSelectionChange" ref="tripReimbursement">
          <el-table-column type="selection" width="50" align="center"/>
          <el-table-column label="序号" align="center" prop="index" width="50"/>
          <el-table-column label="报销项" prop="item" width="150">
            <template slot-scope="scope">
              <el-input v-model="scope.row.item" placeholder="请输入报销项"/>
            </template>
          </el-table-column>
          <el-table-column label="费用" prop="itemCost" width="150">
            <template slot-scope="scope">
              <el-input v-model="scope.row.itemCost" placeholder="请输入费用"/>
            </template>
          </el-table-column>
          <el-table-column label="添加时间" prop="addtime" width="150">
            <template slot-scope="scope">
              <el-input v-model="scope.row.addtime" placeholder="请输入添加时间"/>
            </template>
          </el-table-column>
          <el-table-column label="操作人员ID" prop="userId" width="150">
            <template slot-scope="scope">
              <el-input v-model="scope.row.userId" placeholder="请输入操作人员ID"/>
            </template>
          </el-table-column>
          <el-table-column label="操作人员姓名" prop="UserName" width="150">
            <template slot-scope="scope">
              <el-input v-model="scope.row.UserName" placeholder="请输入操作人员姓名"/>
            </template>
          </el-table-column>
          <el-table-column label="删除标记" prop="delFlag" width="150">
            <template slot-scope="scope">
              <el-input v-model="scope.row.delFlag" placeholder="请输入删除标记"/>
            </template>
          </el-table-column>
        </el-table>
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
  listBusinessTrip,
  getBusinessTrip,
  delBusinessTrip,
  addBusinessTrip,
  updateBusinessTrip
} from "@/api/system/BusinessTrip";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";

export default {
  name: "BusinessTrip",
  mixins: [mixin_printHTML],
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 子表选中数据
      checkedTripReimbursement: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 出差表格数据
      BusinessTripList: [],
      // 出差报销表格数据
      tripReimbursementList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        employeeID: null,
        employee: null,
        personnel: null,
        starttime: null,
        endtime: null,
        attachmentPath: null,
        isReimburse: null,
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
    /** 查询出差列表 */
    getList() {
      this.loading = true;
      listBusinessTrip(this.queryParams).then(response => {
        this.BusinessTripList = response.rows;
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
        employeeID: null,
        employee: null,
        personnel: null,
        starttime: null,
        endtime: null,
        attachmentPath: null,
        isReimburse: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null
      };
      this.tripReimbursementList = [];
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
      this.title = "添加出差";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getBusinessTrip(id).then(response => {
        this.form = response.data;
        this.tripReimbursementList = response.data.tripReimbursementList;
        this.open = true;
        this.title = "修改出差";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.form.tripReimbursementList = this.tripReimbursementList;
          if (this.form.id != null) {
            updateBusinessTrip(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addBusinessTrip(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除出差编号为"' + ids + '"的数据项？').then(function () {
        return delBusinessTrip(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 出差报销序号 */
    rowTripReimbursementIndex({row, rowIndex}) {
      row.index = rowIndex + 1;
    },
    /** 出差报销添加按钮操作 */
    handleAddTripReimbursement() {
      let obj = {};
      obj.item = "";
      obj.itemCost = "";
      obj.comments = "";
      obj.addtime = "";
      obj.userId = "";
      obj.UserName = "";
      obj.delFlag = "";
      this.tripReimbursementList.push(obj);
    },
    /** 出差报销删除按钮操作 */
    handleDeleteTripReimbursement() {
      if (this.checkedTripReimbursement.length == 0) {
        this.$modal.msgError("请先选择要删除的出差报销数据");
      } else {
        const tripReimbursementList = this.tripReimbursementList;
        const checkedTripReimbursement = this.checkedTripReimbursement;
        this.tripReimbursementList = tripReimbursementList.filter(function (item) {
          return checkedTripReimbursement.indexOf(item.index) == -1
        });
      }
    },
    /** 复选框选中数据 */
    handleTripReimbursementSelectionChange(selection) {
      this.checkedTripReimbursement = selection.map(item => item.index)
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/BusinessTrip/export', {
        ...this.queryParams
      }, `BusinessTrip_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
