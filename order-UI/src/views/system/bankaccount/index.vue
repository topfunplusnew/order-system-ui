<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="类型" prop="acountsType">
        <el-select v-model="queryParams.acountsType" placeholder="请选择">
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="户名" prop="acountsName">
        <el-input
          v-model="queryParams.acountsName"
          placeholder="请输入户名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="银行账号" prop="bankNo">
        <el-input
          v-model="queryParams.bankNo"
          placeholder="请输入银行账号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
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
          v-hasPermi="['system:bankAccount:add']"
        >新增银行卡信息
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
      <!--      <el-col :span="1.5">-->
      <!--        <el-button-->
      <!--          type="primary"-->
      <!--          plain-->
      <!--          icon="el-icon-printer"-->
      <!--          size="mini"-->
      <!--          @click="printHTML"-->
      <!--        >打印-->
      <!--        </el-button>-->
      <!--      </el-col>-->

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

    <!-- 打印内容 -->
    <el-table border v-loading="loading" :data="bankAccountList" @selection-change="handleSelectionChange" id="printBox"
              height="300px" v-horizontal-scroll="'always'">
      <!--      <el-table-column type="selection" width="55" align="center"/>-->
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="账户类型" align="center" prop="acountsType" v-if="columns[0].visible"/>
      <el-table-column label="开户名称(户名)" align="center" prop="acountsName" v-if="columns[1].visible"/>
      <el-table-column label="账号(银行账号)" align="center" prop="bankNo" v-if="columns[2].visible"/>
      <el-table-column label="开户行" align="center" prop="bankName" v-if="columns[3].visible"/>
      <el-table-column label="公司名称" align="center" prop="companyName" v-if="columns[4].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:bankAccount:edit']"
          >编辑
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:bankAccount:remove']"
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

    <!-- 添加或修改银行账号对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="账号类型" prop="acountsType">
          <el-select v-model="form.acountsType" placeholder="请选择账号类型">
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="户名" prop="acountsName">
          <el-input v-model="form.acountsName" placeholder="请输入户名"/>
        </el-form-item>
        <el-form-item label="公司名称" prop="companyName" v-if="isNeed">
          <el-input v-model="form.bankNo" placeholder="请输入公司名称"/>
        </el-form-item>
        <el-form-item label="银行账号" prop="bankNo">
          <el-input v-model="form.bankNo" placeholder="请输入银行账号"/>
        </el-form-item>
        <el-form-item label="开户行" prop="bankName">
          <el-input v-model="form.bankName" placeholder="请输入开户行"/>
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
  listBankAccount,
  getBankAccount,
  delBankAccount,
  addBankAccount,
  updateBankAccount
} from "@/api/system/bankAccount";
import {listCompany} from "@/api/system/company";

export default {
  name: "BankAccount",
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
      // 银行账号表格数据
      bankAccountList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        companyName: null,
        companyId: null,
        bankName: null,
        acountsName: null,
        bankNo: null,
        acountsType: null,
        amount: null,
        comments: null,
        delFlag: null
      },
      //查询供应商
      queryParamsCompany: {
        pageNum: 1,
        pageSize: 10,
        companyName: null,
        relationName: null,
        relationTel: null,
        address: null,
        bankName: null,
        acountsName: null,
        bankNo: null,
        surplusMoney: null,
        companyType: null,
        salesman: null,
        leader: null,
        leaderTel: null,
        salesManager: null,
        province: null,
        city: null,
        county: null,
        comments: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      options: [
        {
          value: '己方公司',
          label: '己方公司'
        }, {
          value: '其它',
          label: '其它'
        }
      ],
      //隐藏列信息
      columns: [
        {key: 0, label: `账户类型`, visible: true},
        {key: 1, label: `开户名称`, visible: true},
        {key: 2, label: `账号(银行卡号)`, visible: true},
        {key: 3, label: `开户行`, visible: true},
        {key: 4, label: `公司名称`, visible: true}
      ],
      companyList: []
    };
  },
  created() {
    this.getList();
    this.getCompanyInfo()
    //如果是空
    if (localStorage.getItem('bankaccount-columns') === 'null'
      || !localStorage.getItem('bankaccount-columns')) {
      //设置localStorage
      localStorage.setItem("bankaccount-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('bankaccount-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("bankaccount-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  computed: {
    //是否是己方公司
    isNeed() {
      return this.form.acountsType !== '己方公司' && this.form.acountsType !== '司机'
    }
  },
  methods: {
    //打印
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    //查询客户 供应商信息
    getCompanyInfo() {
      listCompany(this.queryParamsCompany).then(res => {
        this.companyList = res.data.rows;
      })
    },
    /** 查询银行账号列表 */
    getList() {
      this.loading = true;
      listBankAccount(this.queryParams).then(response => {
        const accountsTypeToSelect = ['己方公司', '其它'];
        this.bankAccountList = response.rows.filter(item => {
          // return item.acountsType === '己方公司' || item.acountsType === '其它'
          return accountsTypeToSelect.includes(item.acountsType)
        })
        // this.total = response.total;
        this.total = this.bankAccountList.length;
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
        companyName: null,
        companyId: null,
        bankName: null,
        acountsName: null,
        bankNo: null,
        acountsType: null,
        amount: null,
        comments: null,
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
      this.title = "新增银行卡信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getBankAccount(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改银行卡信息";
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
            updateBankAccount(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            addBankAccount(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除银行账号编号为"' + ids + '"的数据项？').then(function () {
        return delBankAccount(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/bankAccount/export', {
        ...this.queryParams
      }, `bankAccount_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
