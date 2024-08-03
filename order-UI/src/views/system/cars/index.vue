<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="车牌" prop="carNo">
        <el-input
          v-model="queryParams.carNo"
          placeholder="请输入车牌"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <!--      <el-form-item label="司机" prop="driver">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.driver"-->
      <!--          placeholder="请输入司机"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="司机电话" prop="tel">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.tel"-->
      <!--          placeholder="请输入司机电话"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="开户行" prop="bankName">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.bankName"-->
      <!--          placeholder="请输入开户行"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <el-form-item label="户名" prop="acountsName">
        <el-input
          v-model="queryParams.acountsName"
          placeholder="请输入户名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <!--      <el-form-item label="账号" prop="bankNo">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.bankNo"-->
      <!--          placeholder="请输入账号"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="添加时间" prop="addtime">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.addtime"-->
      <!--          placeholder="请输入添加时间"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="操作人员ID" prop="userId">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.userId"-->
      <!--          placeholder="请输入操作人员ID"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="操作人员姓名" prop="UserName">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.UserName"-->
      <!--          placeholder="请输入操作人员姓名"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="删除标记" prop="delFlag">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.delFlag"-->
      <!--          placeholder="请输入删除标记"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <el-form-item>
        <el-button type="primary" size="mini" @click="handleQuery">搜索</el-button>
        <!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
      </el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">

      <!-- 刷新按钮-->
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">

        <el-button
          type="danger"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:cars:add']"
        >添加车辆信息
        </el-button>
      </el-col>
      <!--      <el-col :span="1.5">-->
      <!--        <el-button-->
      <!--          type="danger"-->
      <!--          plain-->
      <!--          icon="el-icon-delete"-->
      <!--          size="mini"-->
      <!--          :disabled="multiple"-->
      <!--          @click="handleDelete"-->
      <!--          v-hasPermi="['system:bankAccount:remove']"-->
      <!--        >批量删除-->
      <!--        </el-button>-->
      <!--      </el-col>-->
      <!--            <el-col :span="1.5">-->
      <!--              <el-button-->
      <!--                type="warning"-->
      <!--                plain-->
      <!--                icon="el-icon-download"-->
      <!--                size="mini"-->
      <!--                @click="handleExport"-->
      <!--                v-hasPermi="['system:bankAccount:export']"-->
      <!--              >导出-->
      <!--              </el-button>-->
      <!--            </el-col>-->
      <!--            <el-col :span="1.5">-->
      <!--              <el-button-->
      <!--                type="primary"-->
      <!--                plain-->
      <!--                icon="el-icon-printer"-->
      <!--                size="mini"-->
      <!--                @click="printHTML"-->
      <!--              >打印-->
      <!--              </el-button>-->
      <!--            </el-col>-->
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
              v-hasPermi="['system:bankAccount:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="carsList" @selection-change="handleSelectionChange" id="printBox"
              height="550px" v-horizontal-scroll="'always'">
      <!--            复选框-->
      <!--            首行-->
      <!--      <el-table-column type="selection" width="55" align="center" />-->
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="车牌" align="center" prop="carNo" v-if="columns[0].visible"/>
      <el-table-column label="司机姓名" align="center" prop="driver" v-if="columns[1].visible"/>
      <el-table-column label="司机电话" align="center" prop="tel" v-if="columns[2].visible"/>
      <el-table-column label="户名" align="center" prop="acountsName" v-if="columns[3].visible"/>
      <el-table-column label="银行账号" align="center" prop="bankNo" v-if="columns[4].visible"/>
      <el-table-column label="开户行" align="center" prop="bankName" v-if="columns[5].visible"/>

      <!--      <el-table-column label="账号类型" align="center" prop="acountsType" />-->
      <!--      <el-table-column label="运输类型(陆运，海运)" align="center" prop="carType" />-->
      <!--      <el-table-column label="添加时间" align="center" prop="addtime" />-->
      <!--      <el-table-column label="操作人员ID" align="center" prop="userId" />-->
      <!--      <el-table-column label="操作人员姓名" align="center" prop="UserName" />-->
      <!--      <el-table-column label="删除标记" align="center" prop="delFlag" />-->
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:cars:edit']"
          >编辑
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:cars:remove']"
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

    <!-- 添加或修改外部车辆信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="车牌" prop="carNo">
          <el-input v-model="form.carNo" placeholder="请输入车牌"/>
        </el-form-item>
        <el-form-item label="司机" prop="driver">
          <el-input v-model="form.driver" placeholder="请输入司机"/>
        </el-form-item>
        <el-form-item label="司机电话" prop="tel">
          <el-input v-model="form.tel" placeholder="请输入司机电话"/>
        </el-form-item>
        <el-form-item label="开户行" prop="bankName">
          <el-input v-model="form.bankName" placeholder="请输入开户行"/>
        </el-form-item>
        <el-form-item label="开户名" prop="acountsName">
          <el-input v-model="form.acountsName" placeholder="请输入开户名"/>
        </el-form-item>
        <el-form-item label="账号" prop="bankNo">
          <el-input v-model="form.bankNo" placeholder="请输入账号"/>
        </el-form-item>
        <!--        单选-->
        <el-form-item label="账号类型" prop="acountsType">
          <el-radio v-model="form.acountsType" label="1">收款</el-radio>
          <el-radio v-model="form.acountsType" label="2">付款</el-radio>
        </el-form-item>

        <el-form-item label="运输类型" prop="carType">
          <!--          <el-input v-model="form.bankNo" placeholder="请输入账号" />-->
          <el-radio v-model="form.carType" label="陆运">陆运</el-radio>
          <el-radio v-model="form.carType" label="海运">海运</el-radio>
        </el-form-item>
        <!--        <el-form-item label="添加时间" prop="addtime">-->
        <!--          <el-input v-model="form.addtime" placeholder="请输入添加时间" />-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="操作人员ID" prop="userId">-->
        <!--          <el-input v-model="form.userId" placeholder="请输入操作人员ID" />-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="操作人员姓名" prop="UserName">-->
        <!--          <el-input v-model="form.UserName" placeholder="请输入操作人员姓名" />-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="删除标记" prop="delFlag">-->
        <!--          <el-input v-model="form.delFlag" placeholder="请输入删除标记" />-->
        <!--        </el-form-item>-->
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {listCars, getCars, delCars, addCars, updateCars} from "@/api/system/cars";
import {addFleet, updateFleet} from "@/api/system/fleet";

export default {
  name: "Cars",
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
      // 外部车辆信息表格数据
      carsList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        carNo: null,
        driver: null,
        tel: null,
        bankName: null,
        carsName: null,
        bankNo: null,
        carsType: null,
        carType: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {}
      ,
      options: [
        {
          value: '收款',
          label: '收款'
        }, {
          value: '付款',
          label: '付款'
        }
      ],
      //隐藏列信息
      columns: [
        {key: 0, label: `车牌`, visible: true},
        {key: 1, label: `司机姓名`, visible: true},
        {key: 2, label: `司机电话`, visible: true},
        {key: 3, label: `户名`, visible: true},
        {key: 4, label: `银行账号`, visible: true},
        {key: 5, label: `开户行`, visible: true}

      ],
      companyList: []
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
    /** 查询外部车辆信息列表 */
    getList() {
      this.loading = true;
      listCars(this.queryParams).then(response => {
        this.carsList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    //打印
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
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
        carNo: null,
        driver: null,
        tel: null,
        bankName: null,
        acountsName: null,
        bankNo: null,
        acountsType: null,
        carType: null,
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
      this.title = "添加外部车辆信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getCars(id).then(response => {
        this.form = response.data;
        this.form.acountsType += ''
        this.open = true;
        this.title = "修改外部车辆信息";
      });
    },
    /** 提交按钮 */
    // /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            updateCars(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addCars(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除外部车辆信息编号为"' + ids + '"的数据项？').then(function () {
        return delCars(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/cars/export', {
        ...this.queryParams
      }, `cars_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
