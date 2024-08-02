<template>
  <div class="app-container">
    <!--    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">-->
    <!--      <el-form-item label="科目名称" prop="title">-->
    <!--        <el-input-->
    <!--          v-model="queryParams.title"-->
    <!--          placeholder="请输入科目名称"-->
    <!--          clearable-->
    <!--          @keyup.enter.native="handleQuery"-->
    <!--        />-->
    <!--      </el-form-item>-->
    <!--      <el-form-item label="编号" prop="subjectNo">-->
    <!--        <el-input-->
    <!--          v-model="queryParams.subjectNo"-->
    <!--          placeholder="请输入编号"-->
    <!--          clearable-->
    <!--          @keyup.enter.native="handleQuery"-->
    <!--        />-->
    <!--      </el-form-item>-->
    <!--      <el-form-item label="父级ID" prop="parentId">-->
    <!--        <el-input-->
    <!--          v-model="queryParams.parentId"-->
    <!--          placeholder="请输入父级ID"-->
    <!--          clearable-->
    <!--          @keyup.enter.native="handleQuery"-->
    <!--        />-->
    <!--      </el-form-item>-->
    <!--      <el-form-item>-->
    <!--        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>-->
    <!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
    <!--      </el-form-item>-->
    <!--    </el-form>-->


    <!--   main-->
    <el-row>
      <!--      树控组件-->
      <!--      <el-col :span="4">-->
      <!--        &lt;!&ndash;        data => :data&ndash;&gt;-->
      <!--        <el-tree :data="subjectList" :props="defaultProps"-->
      <!--                 @node-click="handleNodeClick">-->
      <!--                 <span class="custom-tree-node" slot-scope="{ node, data }">-->
      <!--                   <span><i v-if="!data.children" class="el-icon-document-remove"></i>-->
      <!--                     <i v-else class="el-icon-circle-plus-outline"></i>-->
      <!--                     {{ data.subjectNo }} {{ data.title }}-->
      <!--                   </span>-->
      <!--                 </span>-->
      <!--        </el-tree>-->
      <!--      </el-col>-->

      <!--      表格-->
      <el-col :span="24">
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button
              type="info"
              plain
              size="mini"
              @click="toggleExpandAll"
            >展开/折叠
            </el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button
              plain
              size="mini"
              @click="resetQuery"
            >刷新
            </el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button
              type="danger"
              plain
              size="mini"
              @click="handleAdd"
              v-hasPermi="['system:subject:add']"
            >添加科目信息
            </el-button>
          </el-col>
          <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
        </el-row>

        <!--        表格-->
        <el-table
          border
          v-if="refreshTable"
          v-loading="loading"
          :data="subjectList"
          row-key="id"
          :default-expand-all="isExpandAll"
          :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
        >
          <el-table-column label="科目名称" prop="title"/>
          <el-table-column label="科目编码" align="center" prop="subjectNo"/>
          <el-table-column label="科目类别" align="center" prop="type"/>
          <el-table-column label="父级ID" align="center" prop="parentId"/>
          <!--          <el-table-column label="显示顺序" align="center" prop="orderNum"/>-->
          <!--          <el-table-column label="状态" align="center" prop="STATUS"/>-->
          <el-table-column label="备注" align="center" prop="remark"/>
          <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
            <template slot-scope="scope">
              <el-button
                size="mini"
                @click="handleUpdate(scope.row)"
                v-hasPermi="['system:subject:edit']"
              >修改
              </el-button>
              <el-button
                size="mini"
                type="primary"
                @click="handleAdd(scope.row)"
                v-hasPermi="['system:subject:add']"
              >新增
              </el-button>
              <el-button
                size="mini"
                type="danger"
                @click="handleDelete(scope.row)"
                v-hasPermi="['system:subject:remove']"
              >删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-col>
    </el-row>
    <!-- 添加或修改科目对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="科目名称" prop="title">
          <el-input v-model="form.title" placeholder="请输入科目名称"/>
        </el-form-item>
        <el-form-item label="编号" prop="subjectNo">
          <el-input v-model="form.subjectNo" placeholder="请输入编号"/>
        </el-form-item>
        <el-form-item label="父级ID" prop="parentId">
          <treeselect v-model="form.parentId" :options="subjectOptions" :normalizer="normalizer"
                      placeholder="请选择父级ID"/>
        </el-form-item>
        <el-form-item label="显示顺序" prop="orderNum">
          <el-input v-model="form.orderNum" placeholder="请输入显示顺序"/>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容"/>
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
import {listSubject, getSubject, delSubject, addSubject, updateSubject} from "@/api/system/subject";
import Treeselect from "@riophae/vue-treeselect";
import "@riophae/vue-treeselect/dist/vue-treeselect.css";

export default {
  name: "Subject",
  components: {
    Treeselect
  },
  data() {
    return {
      // 遮罩层
      loading: true,
      // 显示搜索条件
      showSearch: true,
      // 科目表格数据
      subjectList: [],
      // 科目树选项
      subjectOptions: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 是否展开，默认全部展开
      isExpandAll: true,
      // 重新渲染表格状态
      refreshTable: true,
      // 查询参数
      queryParams: {
        title: null,
        type: null,
        subjectNo: null,
        parentId: null,
        orderNum: null,
        STATUS: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        title: [
          {required: true, message: "科目名称不能为空", trigger: "blur"}
        ],
        type: [
          {required: true, message: "科目类别不能为空", trigger: "change"}
        ],
      },
      //测试数据
      test_data: [{
        id: 1,
        label: '一级 1',
        children: [{
          id: 4,
          label: '二级 1-1',
          children: [{
            id: 9,
            label: '三级 1-1-1'
          }, {
            id: 10,
            label: '三级 1-1-2'
          }]
        }]
      }, {
        id: 2,
        label: '一级 2',
        children: [{
          id: 5,
          label: '二级 2-1'
        }, {
          id: 6,
          label: '二级 2-2'
        }]
      }, {
        id: 3,
        label: '一级 3',
        children: [{
          id: 7,
          label: '二级 3-1'
        }, {
          id: 8,
          label: '二级 3-2'
        }]
      }],
      //树形控件
      defaultProps: {
        children: 'children',
        label: 'label'
      },
    };
  },
  created() {
    this.getList();
  },
  methods: {
    //点击某个树的节点
    handleNodeClick(data) {
      console.log(data);
    },
    /** 查询科目列表 */
    getList() {
      this.loading = true;
      listSubject(this.queryParams).then(response => {
        //children:[]
        console.log(response.data)
        this.subjectList = this.handleTree(response.data, "id", "parentId"); //转成树

        this.loading = false;
      });
    },
    /** 转换科目数据结构 */
    normalizer(node) {
      if (node.children && !node.children.length) {
        delete node.children;
      }
      return {
        id: node.id,
        label: node.title,
        children: node.children
      };
    },
    /** 查询科目下拉树结构 */
    getTreeselect() {
      listSubject().then(response => {
        this.subjectOptions = [];
        const data = {id: 0, title: '顶级节点', children: []};
        data.children = this.handleTree(response.data, "id", "parentId");
        this.subjectOptions.push(data);
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
        title: null,
        type: null,
        subjectNo: null,
        parentId: null,
        orderNum: null,
        STATUS: null,
        createBy: null,
        createTime: null,
        updateBy: null,
        updateTime: null,
        remark: null
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 新增按钮操作 */
    handleAdd(row) {
      this.reset();
      this.getTreeselect();
      if (row != null && row.id) {
        this.form.parentId = row.id;
      } else {
        this.form.parentId = 0;
      }
      this.open = true;
      this.title = "添加科目";
    },
    /** 展开/折叠操作 */
    toggleExpandAll() {
      this.refreshTable = false;
      this.isExpandAll = !this.isExpandAll;
      this.$nextTick(() => {
        this.refreshTable = true;
      });
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      this.getTreeselect();
      if (row != null) {
        this.form.parentId = row.parentId;
      }
      getSubject(row.id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改科目";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateSubject(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addSubject(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除科目编号为"' + row.id + '"的数据项？').then(function () {
        return delSubject(row.id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    }
  }
};
</script>
