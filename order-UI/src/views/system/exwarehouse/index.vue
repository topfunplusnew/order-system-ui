<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="订单编号" prop="ordersNo">
        <el-input
          v-model="queryParams.ordersNo"
          placeholder="请输入订单编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <!--      <el-form-item label="仓库ID" prop="storeHouseid">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.storeHouseid"-->
      <!--          placeholder="请输入仓库ID"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <el-form-item label="仓库名称" prop="storeHouseName">
        <el-input
          v-model="queryParams.storeHouseName"
          placeholder="请输入仓库名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <!--      <el-form-item label="仓库存储的货物ID" prop="storeID">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.storeID"-->
      <!--          placeholder="请输入仓库存储的货物ID"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <el-form-item label="出库日期" prop="outDate">
        <el-input
          v-model="queryParams.outDate"
          placeholder="请输入出库日期"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <!--      <el-form-item label="出库量" prop="outAmount">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.outAmount"-->
      <!--          placeholder="请输入出库量"-->
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
          v-hasPermi="['system:exwarehouse:add']"
        >新增出库信息
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
              v-hasPermi="['system:bankaccount:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="exWarehouseList"
              @selection-change="handleSelectionChange" id="printBox">
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="订单编号" align="center" prop="ordersNo"/>
      <!--      <el-table-column label="仓库ID" align="center" prop="storeHouseid"/>-->
      <el-table-column label="仓库名称" align="center" prop="storeHouseName"/>
      <!--      <el-table-column label="仓库存储的货物ID" align="center" prop="storeID"/>-->
      <el-table-column label="出库日期" align="center" prop="outDate"/>
      <el-table-column label="出库量" align="center" prop="outAmount"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:exwarehouse:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:exwarehouse:remove']"
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

    <!-- 添加或修改出库对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="订单编号" prop="ordersNo">
          <el-input v-model="form.ordersNo" placeholder="请输入订单编号"/>
        </el-form-item>
        <!--        <el-form-item label="仓库ID" prop="storeHouseid">-->
        <!--          <el-input v-model="form.storeHouseid" placeholder="请输入仓库ID"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="仓库名称" prop="storeHouseName">
          <el-input v-model="form.storeHouseName" placeholder="请输入仓库名称"/>
        </el-form-item>
        <el-form-item label="仓库存储的货物ID" prop="storeID">
          <el-input v-model="form.storeID" placeholder="请输入仓库存储的货物ID"/>
        </el-form-item>
        <el-form-item label="出库日期" prop="outDate">
          <el-input v-model="form.outDate" placeholder="请输入出库日期"/>
        </el-form-item>
        <el-form-item label="出库量" prop="outAmount">
          <el-input v-model="form.outAmount" placeholder="请输入出库量"/>
        </el-form-item>
        <el-form-item label="删除标记" prop="delFlag">
          <el-input v-model="form.delFlag" placeholder="请输入删除标记"/>
        </el-form-item>
        <el-form-item label="添加时间" prop="addtime">
          <el-input v-model="form.addtime" placeholder="请输入添加时间"/>
        </el-form-item>
        <!--        <el-form-item label="操作人员ID" prop="userId">-->
        <!--          <el-input v-model="form.userId" placeholder="请输入操作人员ID"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="操作人员姓名" prop="UserName">
          <el-input v-model="form.UserName" placeholder="请输入操作人员姓名"/>
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
  listExWarehouse,
  getExWarehouse,
  delExWarehouse,
  addExWarehouse,
  updateExWarehouse
} from "@/api/system/exWarehouse";

export default {
  name: "ExWarehouse",
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
      // 出库表格数据
      exWarehouseList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        ordersNo: null,
        storeHouseid: null,
        storeHouseName: null,
        storeID: null,
        outDate: null,
        outAmount: null,
        delFlag: null,
        addtime: null,
        userId: null,
        UserName: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      columns: [
        {key: 0, label: `账户类型`, visible: true},
        {key: 1, label: `开户名称`, visible: true},
        {key: 2, label: `账号(银行卡号)`, visible: true},
        {key: 3, label: `开户行`, visible: true},
        {key: 4, label: `公司名称`, visible: true}
      ],
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询出库列表 */
    getList() {
      this.loading = true;
      listExWarehouse(this.queryParams).then(response => {
        this.exWarehouseList = response.rows;
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
        ordersNo: null,
        storeHouseid: null,
        storeHouseName: null,
        storeID: null,
        outDate: null,
        outAmount: null,
        delFlag: null,
        updateTime: null,
        addtime: null,
        userId: null,
        UserName: null
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
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加出库";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getExWarehouse(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改出库";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateExWarehouse(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addExWarehouse(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除出库编号为"' + ids + '"的数据项？').then(function () {
        return delExWarehouse(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/exWarehouse/export', {
        ...this.queryParams
      }, `exWarehouse_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
