<!--运费申请 根据字段判断海运陆运-->
<script>
import {addOrderFreight} from "@/api/system/orderFreight";
import SearchOption from "@/components/SearchOption.vue";
import {listCompany} from "@/api/system/company";
import {listBankAccount} from "@/api/system/bankAccount";

export default {
  name: "FreeApply",
  components: {SearchOption},
  props: {
    orderInfo: {}
  },
  data() {
    return {
      queryAcountsName: '',
      form: {
        selfAcountsName: null,
        selfBankNo: null,
        selfBankName: null,
        payDate: null,
        comments: null,
        content: null,
      }
    }
  },
  methods: {
    listBankAccount,
    listCompany,
    //提交运费信息
    onSubmit() {
      Object.assign(this.form, this.orderInfo)
      //发送请求 添加运费信息
      addOrderFreight(this.form).then(res => {
        console.log(res)
        this.$message.success('运费信息添加成功~')
      })
    },
    handleCommitBack(val) {
      this.form.selfAcountsName = val.acountsName;
      this.form.selfBankName = val.bankName;
      this.form.selfBankNo = val.bankNo
    },
    handleChange(val) {
      this.queryAcountsName = val;
    }
  }
}
</script>

<template>
  <div>
    <el-form ref="form" :model="form" label-width="80px">
      <el-form-item label="己方户名">
        <el-row>
          <el-col :span="10">
            <el-input v-model="form.selfAcountsName"></el-input>
          </el-col>
          <el-col :span="4">
            <SearchOption :limit-info="{companyType:'己方公司'}" :get-data="listBankAccount"
                          query-label="户名搜索" query-info="acountsName" :query-name="queryAcountsName"
                          @commitBack="handleCommitBack" @update:queryName="handleChange">
              <template #table-columns>
                <el-table-column label="开户行" align="center" prop="bankName"/>
                <el-table-column label="开户名" align="center" prop="acountsName"/>
                <el-table-column label="账号" align="center" prop="bankNo"/>
                <el-table-column label="余额" align="center" prop="surplusMoney"/>
              </template>
            </SearchOption>
          </el-col>
        </el-row>
      </el-form-item>
      <el-form-item label="己方账号">
        <el-input v-model="form.selfBankNo"></el-input>
      </el-form-item>
      <el-form-item label="己方开户行">
        <el-input v-model="form.selfBankName"></el-input>
      </el-form-item>
      <el-form-item label="支付日期">
        <el-date-picker
          v-model="form.payDate"
          type="date"
          placeholder="选择日期" value-format="timestamp">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="备注信息">
        <el-input v-model="form.content"></el-input>
      </el-form-item>
      <el-form-item label="附加备注">
        <el-input v-model="form.comments"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit">添加运费信息</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<style scoped lang="scss">

</style>
