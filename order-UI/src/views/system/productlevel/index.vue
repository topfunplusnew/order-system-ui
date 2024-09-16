<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="分类名称" prop="categoryName">
        <el-input
          v-model="queryParams.categoryName"
          placeholder="请输入分类名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>
    <el-row>
      <el-col :span="5">
        <el-tree :data="dict.type.order_product_categories" :props="defaultProps"
                 @node-click="handleNodeClick">
           <span class="custom-tree-node" slot-scope="{ node, data }">
             <span><i class="el-icon-document-remove"></i>
               {{ data.value }} {{ data.label }}
             </span>
           </span>
        </el-tree>
      </el-col>
      <el-col :span="19">
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button
              type="primary"
              plain
              size="mini"
              @click="handleAddProductSort"
            >添加产品分类
            </el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button
              type="danger"
              plain
              size="mini"
              @click="handleAddProductLevel"
            >新增产品级别信息
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
                  v-hasPermi="['system:company:export']"
                >
                </el-button>
              </el-col>
            </template>
          </right-toolbar>
        </el-row>
        <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="productLevelList"
                  @selection-change="handleSelectionChange" id="printBox" size="mini">
          <el-table-column label="级别编码" align="center" prop="levelNo" v-if="columns[0].visible"/>
          <el-table-column label="级别名称" align="center" prop="levelName" v-if="columns[1].visible"/>
          <el-table-column label="分类编号" align="center" prop="categoryNo" v-if="columns[2].visible"/>
          <el-table-column label="分类名称" align="center" prop="categoryName" v-if="columns[3].visible"/>
          <el-table-column label="厚度" align="center" prop="height" v-if="columns[4].visible"/>
          <el-table-column label="长度" align="center" prop="length" v-if="columns[5].visible"/>
          <el-table-column label="宽度" align="center" prop="width" v-if="columns[6].visible"/>
          <el-table-column label="吨位" align="center" prop="tonnage" v-if="columns[7].visible"/>
          <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
            <template slot-scope="scope">
              <el-button
                size="mini"
                type="primary"
                @click="handleUpdate(scope.row)"
                v-hasPermi="['system:productlevel:edit']"
              >修改
              </el-button>
              <el-button
                size="mini"
                type="danger"
                @click="handleDelete(scope.row)"
                v-hasPermi="['system:productlevel:remove']"
              >删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-col>
    </el-row>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
    <!--    添加产品分类的弹窗-->
    <el-dialog
      title="添加产品分类"
      :visible.sync="addCategoryOpen"
      width="40%">
      <el-row>
        <el-col :span="12">
          <el-row>
            <span>级别编码</span>
          </el-row>
          <el-row>
            <el-input v-model="tempCategoryInfo.levelNo" placeholder="请输入级别编码"></el-input>
          </el-row>
        </el-col>
        <el-col :span="12">
          <el-row>
            <span>分类名称</span>
          </el-row>
          <el-row>
            <el-input v-model="tempCategoryInfo.categoryName" placeholder="请输入分类名称"></el-input>
          </el-row>
        </el-col>
      </el-row>
      <!--      提交-->
      <el-row>
        <el-button type="primary" @click="submitAddCategory">提交</el-button>
      </el-row>
      <br/>
      <el-row>
        <el-table
          :data="tempCategoryList"
          border
          style="width: 100%">
          <el-table-column
            fixed
            prop="dictValue"
            label="分类编码"
          >
          </el-table-column>
          <el-table-column
            fixed
            prop="dictLabel"
            label="分类名称"
          >
          </el-table-column>
          <el-table-column
            label="操作"
            width="200">
            <template slot-scope="scope">
              <el-row>
                <el-col :span="12">
                  <el-button @click="handleClickCategoryList(scope.row)" type="primary" size="mini">编辑</el-button>
                </el-col>
                <el-col :span="12">
                  <el-button @click="handleDeteleLevel(scope.row)" type="primary" size="mini">删除分类</el-button>
                </el-col>
              </el-row>
            </template>
          </el-table-column>
        </el-table>

        <!--        分页-->
        <pagination
          v-show="level_total>0"
          :total="level_total"
          :page.sync="level_pageNum"
          :limit.sync="level_pageSize"
          @pagination="getDictsData"
        />

      </el-row>
      <span slot="footer" class="dialog-footer">
      <el-button @click="addCategoryOpen = false">取 消</el-button>
      <el-button type="primary" @click="addCategoryOpen = false">确 定</el-button>
      </span>
    </el-dialog>


    <!--    添加产品级别的弹窗-->
    <el-dialog
      title="添加产品级别"
      :visible.sync="addProductLevelOpen"
      width="30%">
      <!--      添加产品级别的表单-->
      <el-form :model="addCategoryModel" ref="queryForm" size="small" label-width="120px" :rules="rules">
        <!--        分类 也是字典数据-->
        <el-form-item label="分类" prop="categoryName">
          <el-select v-model="addCategoryModel.categoryName" placeholder="请选择分类名称">
            <el-option
              v-for="item in dict.type.order_product_categories"
              :key="item.value"
              :label="item.label"
              :value="item.label">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="级别编码" prop="levelNo">
          <el-input v-model="addCategoryModel.levelNo" placeholder="请输入级别编码"></el-input>
        </el-form-item>
        <el-form-item label="级别名称" prop="levelName">
          <el-input v-model="addCategoryModel.levelName" placeholder="请输入级别名称"></el-input>
        </el-form-item>
        <el-form-item label="厚度" prop="height">
          <el-input v-model="addCategoryModel.height" placeholder="请输入厚度"></el-input>
        </el-form-item>
        <el-form-item label="长度" prop="length">
          <el-input v-model="addCategoryModel.length" placeholder="请输入长度"></el-input>
        </el-form-item>
        <el-form-item label="宽度" prop="width">
          <el-input v-model="addCategoryModel.width" placeholder="请输入宽度"></el-input>
        </el-form-item>
        <el-form-item label="吨位" prop="tonnage">
          <el-input v-model="addCategoryModel.tonnage" placeholder="请输入吨位"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
       <el-button type="primary" @click="submitAddLevel">保存</el-button>
       <el-button @click="addProductLevelOpen = false">取 消</el-button>
      </span>
    </el-dialog>


    <!-- 添加或修改收款信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="级别编码" prop="levelNo">
          <el-input v-model="form.levelNo" placeholder="请输入支付类型"/>
        </el-form-item>
        <el-form-item label="级别名称" prop="levelName">
          <el-input v-model="form.levelName" placeholder="请输入收款编号"/>
        </el-form-item>
        <el-form-item label="分类编号" prop="tableName">
          <el-input v-model="form.categoryNo" placeholder="请输入对应的表名"/>
        </el-form-item>
        <el-form-item label="分类名称" prop="categoryName">
          <el-select v-model="form.categoryName" placeholder="请选择分类名称">
            <el-option
              v-for="item in dict.type.order_product_categories"
              :key="item.value"
              :label="item.label"
              :value="item.label">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="厚度" prop="height">
          <el-input v-model="form.height" placeholder="请输入厚度"/>
        </el-form-item>
        <el-form-item label="宽度" prop="width">
          <el-input v-model="form.width" placeholder="请输入宽度"/>
        </el-form-item>
        <el-form-item label="长度" prop="length">
          <el-input v-model="form.length" placeholder="请输入长度"/>
        </el-form-item>
        <el-form-item label="吨位" prop="tonnage">
          <el-input v-model="form.tonnage" placeholder="请输入吨位"/>
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
  addProductLevel,
  delProductLevel,
  getProductLevel,
  listProductLevel,
  updateProductLevel
} from "@/api/system/productLevel";
import {addData, delData, getData, getDicts, listData} from "@/api/system/dict/data";

export default {
  name: "ProductLevel",
  dicts: ['order_product_categories'],
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
      // 产品级别表格数据
      productLevelList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        levelNo: null,
        levelName: null,
        categoryNo: null,
        categoryName: null,
        height: null,
        length: null,
        width: null,
        tonnage: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        levelNo: [
          {required: true, message: "级别编码不能为空", trigger: "blur"}
        ],
        levelName: [
          {required: true, message: "级别名称不能为空", trigger: "blur"}
        ],
        categoryName: [
          {
            required: true, message: "分类名称不能为空", trigger: "blur"
          }],
        height: [
          {
            required: true, message: "厚度不能为空", trigger: "blur"
          }],
        length: [
          {
            required: true, message: "长度不能为空", trigger: "blur"
          }],
        width: [
          {
            required: true, message: "宽度不能为空", trigger: "blur"
          }],
        tonnage: [
          {
            required: true, message: "吨位不能为空", trigger: "blur"
          }],
      },
      test: [],
      columns: [
        {key: 0, label: `级别编码`, visible: true},
        {key: 1, label: `级别名称`, visible: true},
        {key: 2, label: `分类编号`, visible: true},
        {key: 3, label: `分类名称`, visible: true},
        {key: 4, label: `厚度`, visible: true},
        {key: 5, label: `长度`, visible: true},
        {key: 6, label: `宽度`, visible: true},
        {key: 7, label: `吨位`, visible: true},
      ],
      //产品分类信息
      categoryList: [],
      defaultProps: {
        children: 'children',
        label: 'label'
      },
      //弹窗中的 级别编码 分类名称
      tempCategoryInfo: {
        levelNo: '',
        categoryName: ''
      },
      //添加产品分类的弹窗
      addCategoryOpen: false,
      //添加产品级别的弹窗
      addProductLevelOpen: false,
      //弹窗中的分类列表 包含分类编码 分类名称
      tempCategoryList: [],

      //添加字典信息
      addDictInfo: {
        dictLabel: '',
        dictSort: '',
        dictType: 'order_product_categories',
        dictValue: '',
        listClass: 'default',
        status: '0' //区分分类的开启信息
      },

      //添加产品级别的表单参数
      addCategoryModel: {},
      //字典列表
      dictObj: {},

      //created 查询类型字典信息
      dictList: [],

      //分类
      level_total: 0,
      level_pageNum: 1,
      level_pageSize: 10
    };
  },
  created() {
    this.getList();
    //获取产品字典信息
    getDicts('order_product_categories').then(res => {
      this.dictList = res.data;
    })
    if (localStorage.getItem('productlevel-columns') === 'null'
      || !localStorage.getItem('productlevel-columns')) {
      //设置localStorage
      localStorage.setItem("productlevel-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('productlevel-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("productlevel-columns", JSON.stringify(newVal))
      },
      deep: true,
    },
    //监听产品级别变化 自动填充级别编码
    'addCategoryModel.categoryName': function (newVal) {
      //查询该级别名称对应的级别编码
      this.addCategoryModel.levelNo = this.dictList.find(item => item.dictLabel === newVal).dictValue
    }
  },
  methods: {
    //添加产品分类信息
    handleAddProductSort() {
      this.addCategoryOpen = true;
    },
    //添加产品级别信息
    handleAddProductLevel() {
      this.addProductLevelOpen = true;
    },
    //点击提交 这里添加产品分类 添加到字典中
    submitAddCategory() {
      //添加到字典中
      this.addDictInfo.dictLabel = this.tempCategoryInfo.categoryName;
      this.addDictInfo.dictValue = this.tempCategoryInfo.levelNo;
      addData(this.addDictInfo).then(res => {
        this.$message.success("添加成功~")
        location.reload()
        this.addCategoryOpen = false
      }).catch(err => {
        this.$message.error("添加失败，请重试:" + err.msg)
      })
      //重新抓取信息
      this.addCategoryOpen = false;
    },
    //点击分类
    handleNodeClick(data) {
      //发请求  获取数据
      listProductLevel({categoryNo: data.value})
        .then(res => {
          this.productLevelList = res.rows;
        })
    },
    //点击编辑
    handleClickCategoryList(row) {
      this.tempCategoryInfo.levelNo = row.dictValue
      this.tempCategoryInfo.categoryName = row.dictLabel
    },
    //删除分类 row.dictCode
    handleDeteleLevel(row) {
      this.$confirm('是否要删除该分类?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        delData(row.dictCode).then(res => {
          this.$message({
            type: 'success',
            message: '删除成功!'
          });
        })
        this.getList()
      })
    },
    //点击添加级别信息
    submitAddLevel() {
      const obj = JSON.parse(JSON.stringify(this.dictObj)) //Observer改JSON
      let categoryNo = null;
      for (let a in obj) {
        if (obj[a] === this.addCategoryModel.categoryName) {
          categoryNo = a;
        }
      }
      //添加级别信息
      addProductLevel({...this.addCategoryModel, categoryNo: categoryNo})
        .then(res => {
          this.$message.success("添加成功~")
          this.addProductLevelOpen = false
          this.getList()
        }).catch(err => {
        this.$message.error("添加失败，请重试:" + err.msg)
      })

      //刷新表格
      this.getList()
    },
    //初始化字典对象中的信息
    onDictReady(dict) {
      this.dictObj = dict.label.order_product_categories
    },
    //打印方法
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    //查询产品级别列表
    getList() {
      this.loading = true;
      listProductLevel(this.queryParams).then(response => {
        console.log('res', response)
        this.productLevelList = response.rows;
        this.total = response.total;
        this.loading = false;
        //渲染分类
        this.categoryList = response.rows.map(item => {
          return {
            label: item.categoryName,
            children: ''
          }
        })
        //去重 拿到字典里
        listData({dictType: 'order_product_categories'}).then(res => {
          this.tempCategoryList = res.rows;
          this.level_total = res.total;
        })
      });
    },
    //分页获取
    getDictsData() {
      listData({
        dictType: 'order_product_categories',
        pageNum: this.level_pageNum,
        pageSize: this.level_pageSize
      }).then(res => {
        this.tempCategoryList = res.rows;
        this.level_total = res.total;
      })
    },
    //去重方法
    uniqueObjects(arr) {
      const seen = new Set();
      return arr.filter(obj => {
        const obj_to = {...obj}
        const objStr = JSON.stringify(obj_to);
        if (seen.has(objStr)) {
          return false;
        }
        seen.add(objStr);
        return true;
      }).map(str => {
        return {...str}
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
        levelNo: null,
        levelName: null,
        categoryNo: null,
        categoryName: null,
        height: null,
        length: null,
        width: null,
        tonnage: null,
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
      this.title = "添加产品级别";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getProductLevel(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改产品级别";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            updateProductLevel(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            addProductLevel(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除产品级别编号为"' + ids + '"的数据项？').then(function () {
        return delProductLevel(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/productLevel/export', {
        ...this.queryParams
      }, `productLevel_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
