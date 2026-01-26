# Vue2 CRUD 页面模板

## 完整页面结构

```vue
<template>
  <div class="app-container">
    <!-- 搜索表单 -->
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch">
      <el-form-item label="名称" prop="name">
        <el-input v-model="queryParams.name" placeholder="请输入名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option label="启用" value="0" />
          <el-option label="禁用" value="1" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 工具栏 -->
    <el-row>
      <right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
        <template #left>
          <el-row :gutter="10">
            <el-col :span="1.5">
              <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['system:xxx:add']">新增</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button type="primary" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['system:xxx:edit']">修改</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['system:xxx:remove']">删除</el-button>
            </el-col>
          </el-row>
        </template>
      </right-toolbar>
    </el-row>

    <!-- 数据表格 -->
    <el-table v-loading="loading" :data="dataList" @selection-change="handleSelectionChange" border stripe size="mini">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column v-if="columns[0].visible" label="ID" align="center" prop="id" width="80" />
      <el-table-column v-if="columns[1].visible" label="名称" align="center" prop="name" show-overflow-tooltip />
      <el-table-column v-if="columns[2].visible" label="状态" align="center" prop="status" width="100">
        <template #default="scope">
          <dict-tag :options="statusOptions" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column v-if="columns[3].visible" label="创建时间" align="center" prop="createTime" width="160" />
      <el-table-column label="操作" align="center" width="180" fixed="right">
        <template #default="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['system:xxx:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['system:xxx:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <!-- 新增/修改弹窗 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body @close="cancel">
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入名称" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio label="0">启用</el-radio>
            <el-radio label="1">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="cancel">取 消</el-button>
        <el-button type="primary" @click="submitForm" :loading="submitLoading">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listXxx, getXxx, addXxx, updateXxx, delXxx } from '@/api/xxx';

export default {
  name: 'XxxPage',
  data() {
    return {
      // 加载状态
      loading: false,
      submitLoading: false,
      // 选中数据
      ids: [],
      single: true,
      multiple: true,
      // 显示控制
      showSearch: true,
      open: false,
      title: '',
      // 数据列表
      dataList: [],
      total: 0,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        name: undefined,
        status: undefined
      },
      // 表单数据
      form: {},
      // 校验规则
      rules: {
        name: [{ required: true, message: '名称不能为空', trigger: 'blur' }]
      },
      // 列配置
      columns: [
        { key: 0, label: 'ID', visible: true },
        { key: 1, label: '名称', visible: true },
        { key: 2, label: '状态', visible: true },
        { key: 3, label: '创建时间', visible: true }
      ],
      // 字典选项
      statusOptions: [
        { label: '启用', value: '0' },
        { label: '禁用', value: '1' }
      ]
    };
  },
  created() {
    this.getList();
  },
  methods: {
    // 初始表单
    getInitForm() {
      return {
        id: undefined,
        name: '',
        status: '0'
      };
    },
    // 查询列表
    getList() {
      this.loading = true;
      listXxx(this.queryParams).then(res => {
        this.dataList = res?.rows || [];
        this.total = res?.total || 0;
      }).finally(() => {
        this.loading = false;
      });
    },
    // 搜索
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    // 重置搜索
    resetQuery() {
      this.$refs.queryForm?.resetFields();
      this.handleQuery();
    },
    // 多选
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    // 重置表单
    reset() {
      this.form = this.getInitForm();
      this.$nextTick(() => {
        this.$refs.form?.resetFields();
      });
    },
    // 新增
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = '新增';
    },
    // 修改
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids[0];
      getXxx(id).then(res => {
        this.form = JSON.parse(JSON.stringify(res.data));
        this.open = true;
        this.title = '修改';
      });
    },
    // 提交
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) return;
        this.submitLoading = true;
        const request = this.form.id ? updateXxx(this.form) : addXxx(this.form);
        request.then(() => {
          this.$message.success(this.form.id ? '修改成功' : '新增成功');
          this.open = false;
          this.getList();
        }).finally(() => {
          this.submitLoading = false;
        });
      });
    },
    // 删除
    handleDelete(row) {
      const ids = row.id ? [row.id] : this.ids;
      this.$confirm('确认删除选中的数据？', '警告', {
        type: 'warning'
      }).then(() => {
        return delXxx(ids.join(','));
      }).then(() => {
        this.$message.success('删除成功');
        this.getList();
      }).catch(() => {});
    },
    // 取消
    cancel() {
      this.open = false;
      this.$nextTick(() => {
        this.form = this.getInitForm();
        this.$refs.form?.resetFields();
      });
    }
  }
};
</script>

<style scoped>
/* 仅添加必要样式 */
</style>
```

## 说明

1. **表单初始化**: 必须使用 `getInitForm()` 方法
2. **编辑数据**: 必须深拷贝 `JSON.parse(JSON.stringify())`
3. **关闭弹窗**: 必须重置表单和校验
4. **可选链**: 接口返回值使用 `res?.rows || []`
5. **权限控制**: 使用 `v-hasPermi` 指令
