<template>
  <div class="app-container">
    <!--    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">-->
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
              type="primary"
              size="mini"
              @click="handleAddType"
            >1-添加科目类型
            </el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button
              type="danger"
              size="mini"
              @click="handleAdd"
              v-hasPermi="['system:subject:add']"
            >2-添加科目信息
            </el-button>
          </el-col>
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
                  v-hasPermi="['system:subject:export']"
                >
                </el-button>
              </el-col>
            </template>
          </right-toolbar>
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
          size="mini"
        >
          <el-table-column label="科目名称" prop="title" v-if="columns[0].visible"/>
          <el-table-column label="科目编码" align="center" prop="subjectNo" v-if="columns[1].visible"/>
          <el-table-column label="科目类别" align="center" prop="type" v-if="columns[2].visible"/>
          <el-table-column label="父级ID" align="center" prop="parentId" v-if="columns[3].visible"/>
          <el-table-column label="备注" align="center" prop="remark" v-if="columns[4].visible"/>
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
    <el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="父级ID" prop="parentId">
          <treeselect v-model="form.parentId" :options="subjectOptions" :normalizer="normalizer"
                      placeholder="请选择父级ID"/>
        </el-form-item>
        <el-form-item label="分类名称" prop="type">
          <!--          <el-input v-model="form.type" placeholder="请输入分类名称"/>-->
          <el-select v-model="form.type" placeholder="请选择">
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="科目名称" prop="title">
          <el-input v-model="form.title" placeholder="请输入科目名称"/>
        </el-form-item>
        <el-form-item label="编号" prop="subjectNo">
          <el-input v-model="form.subjectNo" placeholder="请输入编号"/>
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

    <!--    添加科目分类的弹窗-->
    <el-dialog :close-on-click-modal="false" :show-close="false" title="添加科目分类" :visible.sync="openType" width="500px" append-to-body>
      <el-form :model="formType" :rules="rules" label-width="80px">
        <el-form-item label="科目分类" prop="type">
          <el-select v-model="formType.type" placeholder="请选择">
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="科目编号" prop="subjectNo">
          <el-input v-model="formType.subjectNo" type="textarea" placeholder="请输入科目编号"/>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="formType.remark" type="textarea" placeholder="请输入备注"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitFormType">确 定</el-button>
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
  dicts: ['order_product_categories'],
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
      form: {type: ''},
      titleOptions: [],
      columns: [
        {key: 0, label: `科目名称`, visible: true},
        {key: 1, label: `科目编码`, visible: true},
        {key: 2, label: `科目类别`, visible: true},
        {key: 3, label: `父级ID`, visible: true},
        {key: 4, label: `备注`, visible: true},
      ],
      // 表单校验
      rules: {
        title: [
          {required: true, message: "科目名称不能为空", trigger: "blur"}
        ],
        type: [
          {required: true, message: "科目类别不能为空", trigger: "change"}
        ],
        subjectNo: [
          {required: true, message: "编号不能为空", trigger: "blur"}]
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

      //添加产品分类
      openType: false,
      options: [{
        value: '收入',
        label: '收入'
      }, {
        value: '支出',
        label: '支出'
      }, {
        value: '其他',
        label: '其他'
      }],
      current_title: '',
      formType: {
        type: '',
        subjectNo: '',
        remark: ''
      }
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('subject-columns') === 'null'
      || !localStorage.getItem('subject-columns')) {
      //设置localStorage
      localStorage.setItem("subject-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('subject-columns'));
    }

    // 获取科目分类列表
    listSubject().then(response => {
      this.titleOptions = [];
      const data = {id: 0, title: '科目根信息', children: []};
      data.children = this.handleTree(response.data, "id", "parentId");
      this.titleOptions.push(data);
    });
  }
  ,

  computed: {
    //利用computed做中间层
    formId() {
      return this.form.parentId
    }
  }
  ,
  watch: {
    //展示与隐藏
    columns: {
      handler: (newVal) => {
        localStorage.setItem("subject-columns", JSON.stringify(newVal))
      },
      deep:
        true,
    }
    ,
    formId: {
      //handler不该用箭头函数 会拿不到this
      handler: function (val) {
        if (val !== 0 && val !== null && val !== undefined) {
          //应该先getId 填充this.form.type数据
          getSubject(val).then(response => {
            this.form.type = response.data.type;
            this.form.subjectNo = response.data.subjectNo
          })
          //val是id 然后再拿id去查找该元素的子元素个数 用来拼接
          listSubject({id: val}).then(response => {
            //查询该id下的子元素数组
            const filters = response.data.filter(item => {
              return item.parentId === val;
            })
            this.form.subjectNo += `00${filters.length + 1}`
          });
        }
      }
    }
  }
  ,
  methods: {
    //添加科目分类
    handleAddType() {
      this.openType = true;
    }
    ,
    // 级联选择器
    handleChange() {

    }
    ,

    //点击某个树的节点
    handleNodeClick(data) {
    }
    ,
    /** 查询科目列表 */
    getList() {
      this.loading = true;
      listSubject(this.queryParams).then(response => {
        //children:[]
        this.subjectList = this.handleTree(response.data, "id", "parentId").sort((a, b) => a.orderNum - b.orderNum); //转成树
        this.loading = false;
      });
    }
    ,
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
    }
    ,
    /** 查询科目下拉树结构 */
    getTreeselect() {
      listSubject().then(response => {
        this.subjectOptions = [];
        const data = {id: 0, title: '科目根信息', children: []};
        data.children = this.handleTree(response.data, "id", "parentId");
        this.subjectOptions.push(data);
      });
    }
    ,
    // 取消按钮
    cancel() {
      this.open = false;
      this.openType = false;
      this.reset();
    }
    ,
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
    }
    ,
    /** 搜索按钮操作 */
    handleQuery() {
      this.getList();
    }
    ,
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    }
    ,
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
    }
    ,
    /** 展开/折叠操作 */
    toggleExpandAll() {
      this.refreshTable = false;
      this.isExpandAll = !this.isExpandAll;
      this.$nextTick(() => {
        this.refreshTable = true;
      });
    }
    ,
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
    }
    ,
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          //如果添加类别
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
    }
    ,
    //提交添加分类
    submitFormType() {
      //如果添加类别
      this.formType.title = this.formType.type;
      addSubject(this.formType).then(response => {
        this.$modal.msgSuccess("修改成功");
        this.openType = false;
        this.getList();
      })
    }
    ,
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
}
;
</script>
