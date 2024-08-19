<template>
  <div class="app-container">
    <!--    搜索框-->
    <el-form :model="timesQuery" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="开始时间" prop="beginTime">
        <el-date-picker
            v-model="timesQuery.beginTime"
            type="date"
            placeholder="请选择开始时间"
        value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="结束时间" prop="endTime">
        <el-date-picker
            v-model="timesQuery.endTime"
            type="date"
            placeholder="请选择结束时间"
        value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="对方公司" prop="companyName">
        <el-input
            v-model="timesQuery.companyName"
            placeholder="请输入对方公司"
            clearable
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleTimesQuery">搜索</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
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
            v-hasPermi="['system:balanceaccounts:add']"
        >新增平账信息
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
                v-hasPermi="['system:balanceaccounts:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="BalanceAccountsList" @selection-change="handleSelectionChange"
              id="printBox" v-horizontal-scroll="'always'">
      <el-table-column label="操作时间" align="center" prop="operateDate" v-if="columns[0].visible"/>
      <el-table-column label="金额" align="center" prop="moneyAmount" v-if="columns[1].visible"/>
      <el-table-column label="对方公司" align="center" prop="companyName" v-if="columns[2].visible"/>
      <el-table-column label="对方公司类型" align="center" prop="companyType">
        <template slot-scope="scope">
          {{ scope.row.companyType === 1 ? '客户' : '供应商' }}
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[4].visible"/>
      <el-table-column label="添加时间" align="center" prop="addtime" v-if="columns[5].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
              size="mini"
              type="primary"
              @click="handleUpdate(scope.row)"
              v-hasPermi="['system:balanceaccounts:edit']">编辑
          </el-button>
          <el-button
              size="mini"
              type="danger"
              @click="handleDelete(scope.row)"
              v-hasPermi="['system:balanceaccounts:remove']">删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination
        v-show="total>0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"/>

    <!-- 添加或修改平账信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="操作时间" prop="operateDate">
          <!--          <el-input v-model="form.operateDate" placeholder="请输入操作时间"/>-->
          <el-date-picker
              v-model="form.operateDate"
              type="date"
              placeholder="选择操作时间"
          value-format="yyyy-MM-dd">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入金额"/>
        </el-form-item>
        <el-form-item label="对方公司" prop="companyName">
          <el-row>
            <el-col :span="12">
              <el-input v-model="form.companyName" placeholder="请输入对方公司"/>
            </el-col>
            <el-col :span="6">
              <el-button icon="el-icon-search" @click="searchCompanyInfo"></el-button>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="对方公司类型" prop="companyType">
          <el-input v-model="form.companyType" type="text">供应商</el-input>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!--    点击公司查询的弹窗-->
    <el-dialog
        title="公司查询"
        :visible.sync="companyDialogVisible"
        width="40%">
      <el-row>
        <el-table
            :data="companyInfoList"
            border
            style="width: 100%">
          <el-table-column label="公司名称" align="center" prop="companyName"/>
          <el-table-column label="公司id" align="center" prop="id"/>
          <el-table-column
              fixed="right"
              label="操作"
              width="100">
            <template slot-scope="scope">
              <el-button @click="commitCompanyInfo(scope.row)" type="danger" size="small">确定</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-row>
      <span slot="footer" class="dialog-footer">
    <el-button @click="companyDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="companyDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>
  </div>
</template>

<script>
import {
  listBalanceAccounts,
  getBalanceAccounts,
  delBalanceAccounts,
  addBalanceAccounts,
  updateBalanceAccounts
} from "@/api/system/BalanceAccounts";
import company from "@/views/system/company/index.vue";
import {mapGetters} from "vuex";
import {listCompany} from "@/api/system/company";

export default {
  name: "BalanceAccounts",
  computed: {
    company() {
      return company
    },
    ...mapGetters(['tempbalanceaccountsList'])
  },
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
      // 平账信息表格数据
      BalanceAccountsList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        operateDate: null,
        moneyAmount: null,
        companyName: null,
        companyID: null,
        companyType: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 搜索参数
      timesQuery: {
        beginTime: '',
        endTime: '',
      },
      // 表单参数
      form: {},
      columns: [
        {key: 0, label: `操作时间`, visible: true},
        {key: 1, label: `金额`, visible: true},
        {key: 2, label: `对方公司`, visible: true},
        {key: 3, label: `对方公司ID`, visible: true},
        {key: 4, label: `备注`, visible: true},
        {key: 5, label: `添加时间`, visible: true},
        {key: 6, label: `操作人员ID`, visible: true},
      ],
      // 表单校验
      rules: {},
      //点击公司的弹窗
      companyDialogVisible: false,
      //公司信息
      companyInfoList: [],
    };
  },
  created() {
    this.getList();
    //获取平账信息
    this.$store.dispatch('balanceaccounts/getbalanceaccountsList')
    //控制隐藏列
    if (localStorage.getItem('balanceaccounts-columns') === 'null'
        || !localStorage.getItem('balanceaccounts-columns')) {
      localStorage.setItem("balanceaccounts-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('balanceaccounts-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("balanceaccounts-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  methods: {
    //搜索公司信息
    searchCompanyInfo() {
      this.companyDialogVisible = true;
      //获取公司信息 渲染到表格
      listCompany({companyType: '供应商'}).then(res => {
        console.log(res)
        this.companyInfoList = res.rows;
      })
    },
    //点击确认公司
    commitCompanyInfo(row) {
      this.form.companyName = row.companyName;
      this.form.companyID = row.id
      this.form.companyType = row.companyType;
      this.companyDialogVisible = false;
    },
    handleTimesQuery() {
      this.BalanceAccountsList = this.tempbalanceaccountsList;
      console.log(this.timesQuery)
      const begin = this.timesQuery.beginTime.getTime();
      const end = this.timesQuery.beginTime.getTime();
      this.BalanceAccountsList.filter(item => {
        if (this.timesQuery.companyName === '') {
          const date = new Date(item.operateDate).getTime();
          return date >= begin && date <= end;
        } else {
          const date = new Date(item.operateDate).getTime();
          return date >= begin && date <= end && item.companyName === this.timesQuery.companyName;
        }
      })
    },
    /*打印信息*/
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    /** 查询平账信息列表 */
    getList() {
      this.loading = true;
      listBalanceAccounts(this.queryParams).then(response => {
        this.BalanceAccountsList = response.rows;
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
        operateDate: null,
        moneyAmount: null,
        companyName: null,
        companyID: null,
        companyType: null,
        comments: null,
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
      this.title = "添加平账信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getBalanceAccounts(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改平账信息";
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
            this.form.companyType = this.form.companyType === '供应商' ? 2 : 1
            this.form.operateDate = this.form.operateDate.getTime()
            updateBalanceAccounts(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            this.form.companyType = this.form.companyType === '供应商' ? 2 : 1
            this.form.operateDate = this.form.operateDate.getTime()
            addBalanceAccounts(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除平账信息编号为"' + ids + '"的数据项？').then(function () {
        return delBalanceAccounts(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/BalanceAccounts/export', {
        ...this.queryParams
      }, `BalanceAccounts_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>

