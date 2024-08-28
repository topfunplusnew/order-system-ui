<!--运费申请 根据字段判断海运陆运-->
<script>
import {addOrderFreight} from "@/api/system/orderFreight";
import SearchOption from "@/components/SearchOption.vue";
import {listCompany} from "@/api/system/company";
import {listBankAccount} from "@/api/system/bankAccount";
import {reset} from "chalk";
import {getCars} from "@/api/system/cars";

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
        otherAcountsName: null,
        otherBankNo: null,
        otherBankName: null,
        payDate: null,
        comments: null,
        content: null,
      }
    }
  },
  created() {
    this.reset();
    getCars(this.orderInfo.driverId).then(res => {
      setTimeout(() => {
        //自动填充司机信息
        this.form.otherAcountsName = res.data.acountsName;
        this.form.otherBankNo = res.data.bankNo;
        this.form.otherBankName = res.data.bankName;
      }, 50)
    })
  },
  methods: {
    listBankAccount,
    listCompany,
    //提交运费信息
    onSubmit() {
      Object.assign(this.form, this.orderInfo)
      //发送请求 添加运费信息
      addOrderFreight(this.form).then(res => {
        this.$message.success('运费信息添加成功~')
        setTimeout(() => {
          this.$router.push('/order/orderFreight')
        })
      })
      this.reset()
    },
    handleCommitBack(val) {
      this.form.otherAcountsName = val.acountsName;
      this.form.otherBankName = val.bankName;
      this.form.otherBankNo = val.bankNo
    },
    handleChange(val) {
      this.queryAcountsName = val;
    },
    reset() {
      this.form = this.$refreshParams(this.form)
    }
  }
}
</script>

<template>
  <div>
    <el-form ref="form" :model="form" label-width="80px">
      <el-form-item label="对方户名">
        <el-row>
          <el-col :span="10">
            <el-input v-model="form.otherAcountsName"></el-input>
          </el-col>
          <el-col :span="4">
            <!--搜索银行卡信息-->
            <SearchOption :limit-info="{companyType:'司机',acountsName:this.orderInfo.otherAcountsName}"
                          :get-data="listBankAccount"
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
      <el-form-item label="对方账号">
        <el-input v-model="form.otherBankNo"></el-input>
      </el-form-item>
      <el-form-item label="对方开户行">
        <el-input v-model="form.otherBankName"></el-input>
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
