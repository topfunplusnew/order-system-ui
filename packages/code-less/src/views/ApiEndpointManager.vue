<template>
  <div class="api-manager">
    <!-- 工具栏 -->
    <div class="api-toolbar">
      <el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增接口</el-button>
      <el-input
        v-model="searchKeyword"
        placeholder="搜索接口名称或路径"
        prefix-icon="el-icon-search"
        style="width: 280px; margin-left: 16px;"
        clearable
        @clear="handleSearch"
        @keyup.enter.native="handleSearch"
      />
    </div>

    <!-- 接口列表 -->
    <el-table :data="tableData" v-loading="loading" border style="width: 100%">
      <el-table-column prop="name" label="接口名称" min-width="160" show-overflow-tooltip />
      <el-table-column prop="method" label="方法" width="90" align="center">
        <template slot-scope="{ row }">
          <el-tag :type="getMethodTagType(row.method)" size="small">{{ row.method }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="path" label="接口路径" min-width="200" show-overflow-tooltip />
      <el-table-column prop="description" label="描述" min-width="180" show-overflow-tooltip />
      <el-table-column prop="status" label="状态" width="100" align="center">
        <template slot-scope="{ row }">
          <el-tag :type="getStatusTagType(row.status)" size="small">{{ getStatusLabel(row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="updatedAt" label="更新时间" width="170" align="center">
        <template slot-scope="{ row }">{{ formatTime(row.updatedAt) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="150" align="center" fixed="right">
        <template slot-scope="{ row }">
          <el-button type="text" icon="el-icon-edit" @click="handleEdit(row)">编辑</el-button>
          <el-button type="text" icon="el-icon-delete" style="color: #f56c6c" @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div class="api-pagination">
      <el-pagination
        background
        layout="total, sizes, prev, pager, next"
        :total="total"
        :page-size="pageSize"
        :current-page="currentPage"
        :page-sizes="[10, 20, 50]"
        @current-change="handlePageChange"
        @size-change="handleSizeChange"
      />
    </div>

    <!-- 新增/编辑弹窗 -->
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="700px" :close-on-click-modal="false">
      <el-form ref="formRef" :model="form" :rules="formRules" label-width="100px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="接口名称" prop="name">
              <el-input v-model="form.name" placeholder="如：获取用户列表" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="HTTP 方法" prop="method">
              <el-select v-model="form.method" placeholder="请选择" style="width: 100%">
                <el-option v-for="m in httpMethods" :key="m" :label="m" :value="m" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="接口路径" prop="path">
          <el-input v-model="form.path" placeholder="如：/api/users" />
        </el-form-item>
        <el-form-item label="接口描述" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="2" placeholder="接口功能描述" />
        </el-form-item>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-select v-model="form.status" placeholder="请选择" style="width: 100%">
                <el-option label="草稿" value="draft" />
                <el-option label="启用" value="active" />
                <el-option label="已废弃" value="deprecated" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="标签">
              <el-select v-model="form.tags" multiple filterable allow-create placeholder="输入后回车添加" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" :loading="submitLoading" @click="handleSubmit">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { apiEndpointService, HTTP_METHODS } from '../services/apiEndpoint';

export default {
  name: 'ApiEndpointManager',
  data() {
    return {
      loading: false,
      submitLoading: false,
      tableData: [],
      total: 0,
      currentPage: 1,
      pageSize: 10,
      searchKeyword: '',
      dialogVisible: false,
      isEdit: false,
      editId: null,
      httpMethods: HTTP_METHODS,
      form: this.getEmptyForm(),
      formRules: {
        name: [{ required: true, message: '请输入接口名称', trigger: 'blur' }],
        path: [
          { required: true, message: '请输入接口路径', trigger: 'blur' },
          { pattern: /^\//, message: '路径必须以 / 开头', trigger: 'blur' }
        ],
        method: [{ required: true, message: '请选择 HTTP 方法', trigger: 'change' }]
      }
    };
  },
  computed: {
    dialogTitle() {
      return this.isEdit ? '编辑接口' : '新增接口';
    }
  },
  created() {
    this.fetchList();
  },
  methods: {
    getEmptyForm() {
      return apiEndpointService.getEmptyForm();
    },
    // 获取列表
    async fetchList() {
      this.loading = true;
      try {
        const query = this.searchKeyword ? { keyword: this.searchKeyword } : {};
        const result = await apiEndpointService.getEndpointList(query, this.currentPage, this.pageSize);
        this.tableData = result.rows;
        this.total = result.total;
      } catch (e) {
        console.error(e);
      } finally {
        this.loading = false;
      }
    },
    handleSearch() {
      this.currentPage = 1;
      this.fetchList();
    },
    handlePageChange(page) {
      this.currentPage = page;
      this.fetchList();
    },
    handleSizeChange(size) {
      this.pageSize = size;
      this.currentPage = 1;
      this.fetchList();
    },
    // 新增
    handleAdd() {
      this.isEdit = false;
      this.editId = null;
      this.form = this.getEmptyForm();
      this.dialogVisible = true;
      this.$nextTick(() => this.$refs.formRef?.clearValidate());
    },
    // 编辑
    handleEdit(row) {
      this.isEdit = true;
      this.editId = row.id;
      this.form = {
        name: row.name,
        path: row.path,
        method: row.method,
        description: row.description || '',
        headers: row.headers || [],
        params: row.params || [],
        body: row.body || { type: 'json', schema: {} },
        response: row.response || { successCode: 200, schema: {} },
        tags: row.tags || [],
        status: row.status || 'draft'
      };
      this.dialogVisible = true;
      this.$nextTick(() => this.$refs.formRef?.clearValidate());
    },
    // 删除
    handleDelete(row) {
      this.$confirm(`确定删除接口「${row.name}」吗？`, '提示', {
        type: 'warning'
      }).then(async () => {
        await apiEndpointService.deleteEndpoint(row.id);
        this.fetchList();
      }).catch(() => {});
    },
    // 提交
    async handleSubmit() {
      try {
        await this.$refs.formRef.validate();
      } catch {
        return;
      }
      this.submitLoading = true;
      try {
        const success = this.isEdit
          ? await apiEndpointService.updateEndpoint(this.editId, this.form)
          : await apiEndpointService.createEndpoint(this.form);
        if (success) {
          this.dialogVisible = false;
          this.fetchList();
        }
      } finally {
        this.submitLoading = false;
      }
    },
    // 工具方法
    getMethodTagType(method) {
      const map = { GET: '', POST: 'success', PUT: 'warning', DELETE: 'danger', PATCH: 'info' };
      return map[method] || 'info';
    },
    getStatusTagType(status) {
      const map = { active: 'success', deprecated: 'info', draft: 'warning' };
      return map[status] || '';
    },
    getStatusLabel(status) {
      const map = { active: '启用', deprecated: '已废弃', draft: '草稿' };
      return map[status] || status;
    },
    formatTime(isoStr) {
      if (!isoStr) return '-';
      return isoStr.replace('T', ' ').slice(0, 19);
    }
  }
};
</script>

<style scoped>
.api-manager {
  background: #fff;
  border-radius: 4px;
  padding: 20px;
  min-height: calc(100vh - 140px);
}

.api-toolbar {
  display: flex;
  align-items: center;
  margin-bottom: 16px;
}

.api-pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}
</style>
