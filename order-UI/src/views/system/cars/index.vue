<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="车牌" prop="carNo">
        <el-input
          v-model="queryParams.carNo"
          placeholder="请输入车牌"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="户名" prop="acountsName">
        <el-input
          v-model="queryParams.acountsName"
          placeholder="请输入户名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">

      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:cars:add']"
        >添加车辆信息
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

    <el-table border v-loading="loading" :data="carsList" @selection-change="handleSelectionChange" id="printBox"
              height="450px" v-horizontal-scroll="'always'" size="mini" :cell-style="()=>{return {padding:'.5px'}}">
      <el-table-column label="车牌/柜号" align="center" prop="carNo" v-if="columns[0].visible" width="220"/>
      <el-table-column label="司机姓名/海运公司" align="center" prop="driver" v-if="columns[1].visible" width="220"/>
      <el-table-column label="司机电话" align="center" prop="tel" v-if="columns[2].visible" width="200"/>
      <el-table-column label="户名" align="center" prop="acountsName" v-if="columns[3].visible" width="200"/>
      <el-table-column label="银行账号" align="center" prop="bankNo" v-if="columns[4].visible" width="200"/>
      <el-table-column label="开户行" align="center" prop="bankName" v-if="columns[5].visible" width="200"/>
      <el-table-column label="运输类型" align="center" prop="carType" v-if="columns[6].visible" width="200"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="180">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="success"
            @click="checkBankInfo(scope.row)"
          >查看银行卡
          </el-button>
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
    <el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px"
               append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
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
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.bankName" placeholder="请输入开户行"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :limit-info="{acountsType:'司机'}" :get-data="listBankAccount" icon="el-icon-search"
                            @commitBack="handleCommitBack" query-info="acountsName" query-label="户名查找"
                            @update:queryName="handleCommitQueryName"
                            :query-name="queryCars">
                <template #table-columns>
                  <el-table-column label="账号类型" align="center" prop="acountsType"/>
                  <el-table-column label="开户行" align="center" prop="bankName"/>
                  <el-table-column label="开户名" align="center" prop="acountsName"/>
                  <el-table-column label="账号" align="center" prop="bankNo"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="开户名" prop="acountsName">
          <el-input v-model="form.acountsName" placeholder="请输入开户名"/>
        </el-form-item>
        <el-form-item label="账号" prop="bankNo">
          <el-input v-model="form.bankNo" placeholder="请输入账号"/>
        </el-form-item>
        <el-form-item label="账号类型" prop="acountsType">
          <el-radio v-model="form.acountsType" label="1">收款</el-radio>
          <el-radio v-model="form.acountsType" label="2">付款</el-radio>
        </el-form-item>

        <el-form-item label="运输类型" prop="carType">
          <el-radio v-model="form.carType" label="陆运">陆运</el-radio>
          <el-radio v-model="form.carType" label="海运">海运</el-radio>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!--    查看银行卡组件-->
    <keep-alive>
      <DialogListShow :title="'司机银行卡信息'" :get-data="listBankAccount" :query-object="queryObject"
                      :visible.sync="driverBankAccout">
        <template #column>
          <el-table-column label="账号类型" align="center" prop="acountsType"/>
          <el-table-column label="开户行" align="center" prop="bankName"/>
          <el-table-column label="开户名" align="center" prop="acountsName"/>
          <el-table-column label="账号" align="center" prop="bankNo"/>
        </template>
      </DialogListShow>
    </keep-alive>

  </div>
</template>

<script>
import {listCars, getCars, delCars, addCars, updateCars} from "@/api/system/cars";
import {addFleet, updateFleet} from "@/api/system/fleet";
import {listCompany} from "@/api/system/company";
import {excludeParams} from "@/api/tool/exclude";
import SearchOption from "../../../components/SearchOption.vue";
import {listBankAccount} from "../../../api/system/bankAccount";
import DialogListShow from "../../../components/DialogListShow.vue";

export default {
  name: "Cars",
  components: {DialogListShow, SearchOption},
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      carsList: [],
      title: "",
      open: false,
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
      form: {},
      rules: {
        carNo: [
          {required: true, message: "车牌号不能为空", trigger: "blur"}
        ],
        driver: [
          {required: true, message: "司机姓名不能为空", trigger: "blur"}
        ],
        tel: [
          {required: true, message: "司机电话不能为空", trigger: "blur"}

        ],
        bankName: [
          {required: true, message: "开户行不能为空", trigger: "blur"}

        ],
        carsName: [
          {required: true, message: "车辆名称不能为空", trigger: "blur"}

        ],
        bankNo: [
          {required: true, message: "银行卡号不能为空", trigger: "blur"}

        ],
        acountsName: [
          {
            required: true, message: "开户名不能为空", trigger: "blur"

          }],
        acountsType: [
          {required: true, message: "账号类型不能为空", trigger: "blur"}
        ],
        carType: [
          {required: true, message: "运输类型不能为空", trigger: "blur"}
        ]
      }
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
      columns: [
        {key: 0, label: `车牌`, visible: true},
        {key: 1, label: `司机姓名`, visible: true},
        {key: 2, label: `司机电话`, visible: true},
        {key: 3, label: `户名`, visible: true},
        {key: 4, label: `银行账号`, visible: true},
        {key: 5, label: `开户行`, visible: true},
        {key: 6, label: `运输类型`, visible: true}

      ],
      companyList: [],
      queryCars: '',

      // 查询对象
      queryObject: {},
      driverBankAccout: false,
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('car-columns') === 'null'
      || !localStorage.getItem('car-columns')) {
      localStorage.setItem("car-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('car-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("car-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },

  methods: {
    listBankAccount,
    handleCommitBack(val) {
      this.form.bankName = val.bankName
      this.form.bankNo = val.bankNo
      this.form.acountsName = val.acountsName
    },
    handleCommitQueryName(val) {
      this.queryCars = val;
    },
    // 查看银行卡信息
    checkBankInfo(row) {
      this.queryObject = {
        companyId: row.id,
        acountsType: '司机'
      };
      // 查询该银行卡
      this.driverBankAccout = true;
    },
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
            this.form = excludeParams(this.form, this.$exclude)
            updateCars(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addCars(this.form).then(response => {
              this.form = excludeParams(this.form, this.$exclude)
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
