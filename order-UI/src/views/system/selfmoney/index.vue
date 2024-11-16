<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
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
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
    </el-row>

    <!-- 打印内容 -->
    <el-table border v-loading="loading" :data="bankAccountList"
              id="printBox" height="450px" v-horizontal-scroll="'always'" size="mini"
              :cell-style="()=>{return {padding:'.5px'}}">
      <el-table-column label="账户类型" align="center" prop="acountsType" width="200" show-overflow-tooltip/>
      <el-table-column label="余额" align="center" prop="amount" width="200" show-overflow-tooltip/>
      <el-table-column label="公私户类型" align="center" prop="isPublicAccount" width="200" show-overflow-tooltip>
        <template slot-scope="scope">
          <span v-if="scope.row.isPublicAccount === 0" style="color:#138fe1">
            私户
          </span>
          <span v-else-if="scope.row.isPublicAccount === 1" style="color:#ff5722">
            公户
          </span>
          <span v-else>
            未区分
          </span>
        </template>
      </el-table-column>
      <el-table-column label="显示名称" align="center" prop="displayName" width="200" show-overflow-tooltip/>
      <el-table-column label="公司名称" align="center" prop="companyName" width="200" show-overflow-tooltip/>
      <el-table-column label="开户名称" align="center" prop="acountsName" width="200" show-overflow-tooltip/>
      <el-table-column label="银行账号" align="center" prop="bankNo" width="200" show-overflow-tooltip/>
      <el-table-column label="开户行" align="center" prop="bankName" width="200" show-overflow-tooltip/>
      <el-table-column label="银行卡操作" align="center" class-name="small-padding fixed-width" width="200"
                       fixed="right">
        <template slot-scope="scope">
          <el-row>
            <el-button
              size="mini"
              type="text"
              @click="checkBankChangeFlow(scope.row)">变动流水
            </el-button>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"/>


    <!--    银行卡流水-->
    <el-dialog :close-on-click-modal="false" :show-close="false" title="银行卡流水"
               :visible.sync="bankChangeDialogVisible" width="55%" append-to-body>
      <el-row>
        <div>
          <el-form :model="bankAcountQuery" label-width="80px">
            <el-col :span="4">
              <el-form-item label="日期" prop="operateDate">
                <el-date-picker
                  v-model="bankAcountQuery.operateDate"
                  type="date"
                  value-format="yyyy-MM-dd"
                  placeholder="日期"
                  style="width: 140px"
                />
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item>
                <el-button type="primary" @click="getBankAcountChangeList" size="mini">
                  搜索
                </el-button>
              </el-form-item>
            </el-col>
          </el-form>
        </div>
        <el-table
          :data="bankChangeList"
          style="width: 100%">
          <el-table-column
            prop="selfBankNo"
            label="己方账号"
            width="180">
          </el-table-column>
          <el-table-column
            prop="operateDate"
            label="日期"
            width="180">
          </el-table-column>
          <el-table-column
            prop="changeType"
            label="变动类型">
          </el-table-column>
          <el-table-column
            prop="moneyAmount"
            label="金额">
          </el-table-column>
        </el-table>
        <pagination
          v-show="bankAcountTotal>0"
          :total="bankAcountTotal"
          :page.sync="bankAcountQuery.bankAcountTotalPageNum"
          :limit.sync="bankAcountQuery.bankAcountTotalPageSize"
          @pagination="getBankAcountChangeList"/>
      </el-row>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitBankChange">确 定</el-button>
        <el-button @click="bankChangeDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {listCompany} from "@/api/system/company";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {listBankAccountChange} from "@/api/system/bankAccountChange";
import {listBankAccount} from "../../../api/system/bankAccount";

export default {
  name: "BankAccount",
  mixins: [mixin_printHTML],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      bankAccountList: [],
      title: "",
      open: false,
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
      // 表单参数
      form: {
        bankNo: '',
        bankName: '',
        acountsName: '',
        companyName: '',
        acountsType: ''
      },
      //银行卡流水
      bankChangeDialogVisible: false,
      bankChangeList: [],
      currentBankNo: '',
      bankAcountQuery: {
        bankAcountTotalPageNum: 10,
        bankAcountTotalPageSize: 1,
        operateDate: null,
      },
      bankAcountTotal: 0,
      // 用户搜索字段
      queryUser: '',
      //供应商搜索组件
      queryCompanyGive: '',
      queryCompany: '',
      // 银行卡搜索组件
      queryBankAccount: '',
    };
  },
  created() {
    this.getList();
  },
  methods: {
    listBankAccount,
    listCompany,
    //3.银行卡变动流水
    checkBankChangeFlow(row) {
      this.currentBankNo = row.bankNo;
      // 查询该银行账号的变动流水
      listBankAccountChange({selfBankNo: row.bankNo}).then(res => {
        this.bankChangeList = res.rows;
        this.bankAcountTotal = res.total;
      })
      this.bankChangeDialogVisible = true;
    }
    ,
    // 分页的请求
    getBankAcountChangeList() {
      listBankAccountChange({
        selfBankNo: this.currentBankNo,
        pageNum: this.bankAcountQuery.bankAcountTotalPageNum,
        pageSize: this.bankAcountQuery.bankAcountTotalPageSize,
        ...this.bankAcountQuery
      }).then(res => {
        this.bankChangeList = res.rows;
        this.bankAcountTotal = res.total;
      })
    }
    ,
    submitBankChange() {
      this.bankChangeDialogVisible = false
    },
    /** 查询银行账号列表 */
    getList() {
      this.loading = true;
      // 查询己方的
      const query = {
        ...this.queryParams,
        acountsType: '己方'
      }
      listBankAccount(query).then(response => {
        this.bankAccountList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    }
    ,
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    }
    ,
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
    }
    ,
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    }
    ,
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    }
    ,
  }
}
;
</script>
