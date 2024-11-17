<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="开户名称" prop="acountsName">
        <el-input
          v-model="queryParams.acountsName"
          placeholder="请输入开户名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="开户行" prop="acountsName">
        <el-input
          v-model="queryParams.bankName"
          placeholder="请输入开户行"
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
      <el-form-item label="显示名称" prop="displayName">
        <el-input
          v-model="queryParams.displayName"
          placeholder="请输入显示名称"
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
      <el-col :span="1.5">
        <el-select v-model="value" placeholder="余额排序" size="mini">
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-col>
    </el-row>

    <el-table border v-loading="loading" :data="bankAccountList"
              id="printBox" height="450px" v-horizontal-scroll="'always'" size="mini"
              :cell-style="()=>{return {padding:'.5px'}}">
      <el-table-column label="余额" align="center" prop="sumMoney" show-overflow-tooltip/>
      <el-table-column label="银行卡类型" align="center" prop="bankCardType" show-overflow-tooltip/>
      <el-table-column label="显示名称" align="center" prop="displayName" show-overflow-tooltip/>
      <el-table-column label="开户名称" align="center" prop="acountsName" show-overflow-tooltip/>
      <el-table-column label="银行账号" align="center" prop="bankNo" show-overflow-tooltip/>
      <el-table-column label="开户行" align="center" prop="bankName" show-overflow-tooltip/>
    </el-table>
  </div>
</template>

<script>
import {listCompany} from "@/api/system/company";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {listBankAccount, listBankAccountSelf} from "../../../api/system/bankAccount";
import orderGiven from "@/views/dashboard/components/goodsOrder/OrderGiven.vue";

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
        bankName: null,
        acountsName: null,
        bankNo: null,
        displayName: null,
      },
      // 表单参数
      form: {
        bankNo: '',
        bankName: '',
        acountsName: '',
        companyName: '',
        acountsType: ''
      },
      // 排序选择
      options: [{
        value: '1',
        label: '升序'
      }, {
        value: '2',
        label: '降序'
      }],
      value: ''
    };
  },
  watch: {
    // 监听value
    value: {
      handler(value) {
        if (value === '1') {
          this.bankAccountList.sort(function (a, b) {
            return a.sumMoney - b.sumMoney
          })
        } else {
          this.bankAccountList.sort(function (a, b) {
            return b.sumMoney - a.sumMoney
          })
        }
      }
    }
  },
  created() {
    this.getList();
  },
  methods: {
    listBankAccount,
    listCompany,
    getList() {
      this.loading = true;
      listBankAccountSelf().then(response => {
        this.bankAccountList = response.data;
        // 存储到本地
        localStorage.setItem("bankAccountList", JSON.stringify(this.bankAccountList))
        this.total = response.data.length;
        this.loading = false;
      });
    },
    // 银行卡筛选
    handleQuery() {
      // 每次重新刷新数组后筛选
      this.bankAccountList = JSON.parse(localStorage.getItem('bankAccountList'))
      // 如果queryParams都是空 那么就返回全部数据
      const values = Object.values(this.queryParams)
      // 对每一个参数进行判断
      if (values.every(item => {
        return item === null || item === ''
      })) {
        return this.bankAccountList
      }
      // 对银行卡列表进行筛选
      this.bankAccountList = this.bankAccountList.filter(item => {
        if (this.queryParams.bankName && item.bankName && item.bankName.indexOf(this.queryParams.bankName) !== -1) {
          return item;
        }
        if (this.queryParams.acountsName && item.acountsName && item.acountsName.indexOf(this.queryParams.acountsName) !== -1) {
          return item;
        }
        if (this.queryParams.bankNo && item.bankNo && item.bankNo.indexOf(this.queryParams.bankNo) !== -1) {
          return item;
        }
        if (this.queryParams.displayName && item.displayName && item.displayName.indexOf(this.queryParams.displayName) !== -1) {
          return item;
        }
      })
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
  }
}
;
</script>
