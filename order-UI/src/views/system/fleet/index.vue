<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="车队名称" prop="fName">
        <el-input
          v-model="queryParams.fName"
          placeholder="请输入车队名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="车队经理" prop="fLeader">
        <el-input
          v-model="queryParams.fLeader"
          placeholder="请输入车队经理"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="车队经理电话" prop="tel">
        <el-input
          v-model="queryParams.tel"
          placeholder="请输入车队经理电话"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="地址" prop="address">
        <el-input
          v-model="queryParams.address"
          placeholder="请输入地址"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
<!--      <el-form-item label="添加时间" prop="addtime">
        <el-input
          v-model="queryParams.addtime"
          placeholder="请输入添加时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="编辑时间" prop="editTime">
        <el-input
          v-model="queryParams.editTime"
          placeholder="请输入编辑时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>-->
<!--      <el-form-item label="删除标记" prop="delFlag">
        <el-input
          v-model="queryParams.delFlag"
          placeholder="请输入删除标记"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>-->
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
<!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <!-- 刷新按钮-->
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <!-- 新增按钮 -->
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:fleet:add']"
        >添加车队信息</el-button>
      </el-col>
<!--      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['system:fleet:edit']"
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
          v-hasPermi="['system:fleet:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:fleet:export']"
        >导出</el-button>
      </el-col>-->

      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" :columns="columns">
        <!--    打印    -->
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
              v-hasPermi="['system:fleet:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="fleetList" @selection-change="handleSelectionChange"  id="printBox"  >
<!--      <el-table-column type="selection" width="55" align="center" />-->
      <el-table-column label="id" align="center" prop="id" />
      <el-table-column label="车队名称" align="center" prop="fName" v-if="columns[0].visible"/>
      <el-table-column label="车队经理" align="center" prop="fLeader" v-if="columns[1].visible"/>
      <el-table-column label="车队经理电话" align="center" prop="tel" v-if="columns[2].visible"/>
      <el-table-column label="地址" align="center" prop="address" v-if="columns[3].visible"/>
<!--      <el-table-column label="添加时间" align="center" prop="addtime" />
      <el-table-column label="编辑时间" align="center" prop="editTime" />-->
<!--      <el-table-column label="删除标记" align="center" prop="delFlag" />-->
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
<!--          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:fleet:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:fleet:remove']"
          >删除</el-button>-->


          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:fleet:edit']"
          >编辑
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:fleet:remove']"
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

    <!-- 添加或修改车队对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="车队名称" prop="fName">
          <el-input v-model="form.fName" placeholder="请输入车队名称" />
        </el-form-item>
        <el-form-item label="车队经理" prop="fLeader">
          <el-input v-model="form.fLeader" placeholder="请输入车队经理" />
        </el-form-item>
        <el-form-item label="车队经理电话" prop="tel">
          <el-input v-model="form.tel" placeholder="请输入车队经理电话" />
        </el-form-item>
        <el-form-item label="地址" prop="address">
          <el-input v-model="form.address" placeholder="请输入地址" />
        </el-form-item>
<!--        <el-form-item label="添加时间" prop="addtime">
          <el-input v-model="form.addtime" placeholder="请输入添加时间" />
        </el-form-item>
        <el-form-item label="编辑时间" prop="editTime">
          <el-input v-model="form.editTime" placeholder="请输入编辑时间" />
        </el-form-item>-->
<!--        <el-form-item label="删除标记" prop="delFlag">
          <el-input v-model="form.delFlag" placeholder="请输入删除标记" />
        </el-form-item>-->
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listFleet, getFleet, delFleet, addFleet, updateFleet } from "@/api/system/fleet";

export default {
  name: "Fleet",
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
      // 车队表格数据
      fleetList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        fName: null,
        fLeader: null,
        tel: null,
        address: null,
        addtime: null,
        editTime: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
      },
      columns: [
        {key: 0, label: `车队名称`, visible: true},
        {key: 1, label: `车队经理`, visible: true},
        {key: 2, label: `车队经理电话`, visible: true},
        {key: 3, label: `地址`, visible: true},

      ]
    };
  },

  created() {
    this.getList();
    if (localStorage.getItem('columns') !== null || localStorage.getItem('columns') !== undefined) {
      this.columns = JSON.parse(localStorage.getItem('columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  methods: {
    /*打印信息*/
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    /** 查询车队列表 */
    getList() {
      this.loading = true;
      listFleet(this.queryParams).then(response => {
        this.fleetList = response.rows;
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
        fName: null,
        fLeader: null,
        tel: null,
        address: null,
        addtime: null,
        editTime: null,
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
      this.title = "添加车队";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getFleet(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改车队";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            this.form.delFlag = null;
            this.form.addtime=null;
            this.form.updateTime=null;
            this.form.userId=null;
            updateFleet(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addFleet(this.form).then(response => {
              this.form.delFlag = null;
              this.form.addtime = null;
              this.form.updateTime = null;
              this.form.userId = null;
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
      this.$modal.confirm('是否确认删除车队编号为"' + ids + '"的数据项？').then(function() {
        return delFleet(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/fleet/export', {
        ...this.queryParams
      }, `fleet_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>

