<template>
  <div class="app-container">
    <!-- 筛选框 -->
    <el-form
      v-show="showSearch"
      ref="queryForm"
      :model="queryParams"
      size="mini"
      :inline="true"
      label-width="68px"
    >
      <el-form-item label="账户类型">
        <el-select v-model="queryParams.bankCardType" placeholder="账户类型" size="mini" clearable>
          <el-option
            v-for="item in typeOption"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          ></el-option>
        </el-select>
      </el-form-item>
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
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">
          搜索
        </el-button>
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
            :value="item.value"
          ></el-option>
        </el-select>
      </el-col>
    </el-row>

    <el-table
      id="printBox"
      v-loading="loading"
      v-horizontal-scroll="'always'"
      border
      :data="bankAccountList"
      height="450px"
      size="mini"
      :cell-style="
        () => {
          return { padding: '.5px' }
        }
      "
    >
      <el-table-column label="余额" align="center" prop="sumMoney" show-overflow-tooltip />
      <el-table-column
        label="银行卡类型"
        align="center"
        prop="bankCardType"
        show-overflow-tooltip
      />
      <el-table-column label="显示名称" align="center" prop="displayName" show-overflow-tooltip />
      <el-table-column label="开户名称" align="center" prop="acountsName" show-overflow-tooltip />
      <el-table-column label="银行账号" align="center" prop="bankNo" show-overflow-tooltip />
      <el-table-column label="开户行" align="center" prop="bankName" show-overflow-tooltip />
    </el-table>
  </div>
</template>

<script>
  import { listCompany } from '@/api/system/company'
  import { mixin_printHTML } from '@/views/dashboard/mixins/print'
  import { listBankAccount, listBankAccountSelf } from '../../../api/system/bankAccount'

  export default {
    name: 'BankAccount',
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
        title: '',
        open: false,
        queryParams: {
          bankName: null,
          acountsName: null,
          bankNo: null,
          displayName: null
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
        options: [
          {
            value: '1',
            label: '升序'
          },
          {
            value: '2',
            label: '降序'
          }
        ],
        // 银行卡账户类型的筛选
        typeOption: [
          {
            value: '现金户',
            label: '现金户'
          },
          {
            value: '承兑',
            label: '承兑'
          }
        ],
        // 升序和降序的值
        value: '',
        // 银行账户类型
        type: ''
      }
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
      // 监听type
      // type: {
      //   handler(value) {
      //     this.bankAccountList = JSON.parse(
      //       localStorage.getItem('bankAccountList')
      //     )

      //     // 根据账户类型进行筛选
      //     if (value === '现金户') {
      //       this.bankAccountList = this.bankAccountList.filter(
      //         (item) => item.bankCardType === '现金户'
      //       )
      //     } else if (value === '承兑') {
      //       this.bankAccountList = this.bankAccountList.filter(
      //         (item) => item.bankCardType === '承兑'
      //       )
      //     }
      //   }
      // }
    },
    created() {
      this.getList()
    },
    methods: {
      listBankAccount,
      listCompany,
      getList() {
        this.loading = true
        listBankAccountSelf().then((response) => {
          this.bankAccountList = response.data
          // 存储到本地
          localStorage.setItem('bankAccountList', JSON.stringify(this.bankAccountList))
          this.total = response.data.length
          this.loading = false
        })
      },
      // 银行卡筛选
      handleQuery() {
        // 每次重新刷新数组后筛选
        this.bankAccountList = JSON.parse(localStorage.getItem('bankAccountList'))
        // 如果queryParams都是空 那么就返回全部数据
        const values = Object.values(this.queryParams)

        // 对每一个参数进行判断
        if (
          values.every((item) => {
            return item === null || item === ''
          })
        ) {
          return this.bankAccountList
        }
        // 对银行卡列表进行筛选
        this.bankAccountList = this.bankAccountList.filter((item) => this.handleFilter(item))
      },
      // 筛选函数
      handleFilter(item) {
        // 如果每一个属性都满足 即为true
        let flag = true
        // item要满足queryParams中的每一个参数 但是也可以满足某一个参数
        Object.keys(this.queryParams).forEach((key) => {
          console.log(key, item[key], this.queryParams[key])

          // 两边都存在这个属性
          if (item[key] && this.queryParams[key]) {
            // 存在 且不相等
            if (item[key] !== this.queryParams[key]) {
              flag = false
            }
          }
        })
        return flag
      },
      /** 重置按钮操作 */
      resetQuery() {
        this.resetForm('queryForm')
        this.handleQuery()
      }
    }
  }
</script>
