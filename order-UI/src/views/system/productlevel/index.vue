<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
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
      <el-col :span="4">
        <el-tree :data="dict.type.order_product_categories" :props="defaultProps"
                 @node-click="handleNodeClick">
           <span class="custom-tree-node" slot-scope="{ node, data }">
             <span><i class="el-icon-document-remove"></i>
               {{ data.value }} {{ data.label }}
             </span>
           </span>
        </el-tree>
      </el-col>
      <el-col :span="20">
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
                  @selection-change="handleSelectionChange" id="printBox">
          <el-table-column label="id" align="center" prop="id"/>
          <el-table-column label="级别编码" align="center" prop="levelNo"/>
          <el-table-column label="级别名称" align="center" prop="levelName"/>
          <el-table-column label="分类编号" align="center" prop="categoryNo"/>
          <el-table-column label="分类名称" align="center" prop="categoryName"/>
          <el-table-column label="厚度" align="center" prop="height"/>
          <el-table-column label="长度" align="center" prop="length"/>
          <el-table-column label="宽度" align="center" prop="width"/>
          <el-table-column label="吨位" align="center" prop="tonnage"/>
          <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
            <template slot-scope="scope">
              <el-button
                size="mini"
                type="primary"
                @click="handleUpdate(scope.row)"
                v-hasPermi="['system:productLevel:edit']"
              >修改
              </el-button>
              <el-button
                size="mini"
                type="danger"
                @click="handleDelete(scope.row)"
                v-hasPermi="['system:productLevel:remove']"
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
            <el-select v-model="tempCategoryInfo.categoryName" placeholder="请选择分类名称">
              <el-option
                v-for="item in dict.type.order_product_categories"
                :key="item.value"
                :label="item.label"
                :value="item.label">
              </el-option>
            </el-select>
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
            prop="categoryNo"
            label="分类编码"
          >
          </el-table-column>
          <el-table-column
            fixed
            prop="categoryName"
            label="分类名称"
          >
          </el-table-column>
          <el-table-column
            label="操作"
            width="100">
            <template slot-scope="scope">
              <el-button @click="handleClickCategoryList(scope.row)" type="primary" size="small">编辑</el-button>
              <!--              字典中管理-->
              <!--              <el-button type="text" size="small" @click="handleDeleteCategoryList(scope.row)">删除</el-button>-->
            </template>
          </el-table-column>
        </el-table>
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
      width="40%">
      <!--      添加产品级别的表单-->
      <el-form :model="addCategoryModel" ref="queryForm" size="small" label-width="68px">
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
import {addData} from "@/api/system/dict/data";

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
      rules: {},
      test: [],
      columns: [
        {key: 0, label: `客户`, visible: true},
        {key: 1, label: `老板姓名`, visible: true},
        {key: 2, label: `公司名称`, visible: true},
        {key: 3, label: `老板电话`, visible: true},
        {key: 4, label: `电话`, visible: true},
        {key: 5, label: `地址`, visible: true},
        {key: 6, label: `区域`, visible: true},
        {key: 7, label: `销售经理`, visible: true},
        {key: 8, label: `备注`, visible: true},
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
      dictObj: {}
    };
  },
  created() {
    this.getList();
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
        this.addCategoryOpen = false
      }).catch(err => {
        this.$message.error("添加失败，请重试:" + err.msg)
      })
    },
    //获取产品分类
    getCategoryList() {

    },
    //点击分类
    handleNodeClick(data) {
      console.log(data);
      this.productLevelList = this.productLevelList.filter(item => {
        return item.categoryName === data.label
      })
    },
    //点击编辑
    handleClickCategoryList(row) {
      console.log(row)
      this.tempCategoryInfo.levelNo = row.categoryNo;
      this.tempCategoryInfo.categoryName = row.categoryName
    },
    //删除 由字典管理
    handleDeleteCategoryList(row) {
      console.log(row)
    },
    //点击添加级别信息
    submitAddLevel() {
      const obj = JSON.parse(JSON.stringify(this.dictObj))
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
        }).catch(err => {
        this.$message.error("添加失败，请重试:" + err.msg)
      })
    },
    //初始化字典对象中的信息
    onDictReady(dict) {
      this.dictObj = dict.label.order_product_categories
    },
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
        //去重
        const needList = [...this.categoryList]
        this.categoryList = this.uniqueObjects(needList);

        //弹窗中的分类信息
        this.tempCategoryList = response.rows.map(item => {
          return {
            categoryNo: item.categoryNo,
            categoryName: item.categoryName
          }
        })
      });
    },
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
