<!--审核弹窗-->
<script>
import {updateAuditInfo} from "@/api/system/auditInfo";

export default {
  props: {
    //付款信息
    paymentApplyInfo: {},
    //审核步骤信息
    checkApplyInfo: {},
    //是否通过
    isCheckState: {
      type: Boolean
    }
  },
  computed: {
    checkState: {
      get() {
        return this.isCheckState
      },
      set(val) {
        this.$emit('update:isCheckState', val)
      }
    }
  },
  data() {
    return {
      //审核意见
      auditcommentYES: '',
      auditcommentNO: ''
    };
  },
  methods: {

    //审核通过
    handleCheckSuccess() {
      //调用接口 修改审核状态
      updateAuditInfo({checkState: '通过', auditcomment: this.auditcommentYES, ...this.checkApplyInfo})
        .then(res => {
          this.$message.success('操作完毕~')
          //修改刷新标记vuex
          this.$store.dispatch('apply/setChecked', this.checkApplyInfo.applyID)
          this.auditcommentYES = ''
        })
      //关闭弹窗
      this.checkState = true
    },
    //审核不通过
    handleCheckError() {
      //调用接口 修改审核状态
      updateAuditInfo({checkState: '未通过', auditcomment: this.auditcommentNO, ...this.checkApplyInfo})
        .then(res => {
          this.$message.success('操作完毕~')
          //修改刷新标记vuex
          this.$store.dispatch('apply/setChecked', this.checkApplyInfo.applyID)
          this.auditcommentNO = ''
        })
      //关闭弹窗
      this.checkState = false
    }
  },
  created() {
  },
};
</script>

<template>
  <div>
    <!--    付款信息展示-->
    <el-row>
      <el-descriptions title="付款信息明细">
        <el-descriptions-item label="申请人">{{ paymentApplyInfo.applyPerson }}</el-descriptions-item>
        <el-descriptions-item label="申请金额">{{ paymentApplyInfo.moneyAmount }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ paymentApplyInfo.comments }}</el-descriptions-item>
        <el-descriptions-item label="公司类型">
          {{ paymentApplyInfo.companyType }}
        </el-descriptions-item>
        <el-descriptions-item label="公司名称">
          {{ paymentApplyInfo.companyName }}
        </el-descriptions-item>
        <el-descriptions-item label="时间">
          {{ paymentApplyInfo.fundsDate }}
        </el-descriptions-item>
        <el-descriptions-item label="对方账户名称">
          {{ paymentApplyInfo.otherAcountsName }}
        </el-descriptions-item>
        <el-descriptions-item label="对方银行卡号">
          {{ paymentApplyInfo.otherBankNo }}
        </el-descriptions-item>
        <el-descriptions-item label="对方开户行">
          {{ paymentApplyInfo.otherBankName }}
        </el-descriptions-item>
        <el-descriptions-item label="申请原因">
          {{ paymentApplyInfo.reason }}
        </el-descriptions-item>
        <el-descriptions-item label="附件">
          {{ paymentApplyInfo.attachment }}
        </el-descriptions-item>
      </el-descriptions>
    </el-row>
    <br/>
    <hr/>
    <el-row>
      <el-col :span="4">
        <span style="font-weight: bolder;line-height: 35px">操作</span>
      </el-col>
      <el-col :span="20">
        <el-row>
          <!--          审核通过-->
          <el-col :span="12">
            <el-row :gutter="4">
              <el-col :span="12">
                <el-input placeholder="请输入审核意见" type="text" v-model="auditcommentYES"></el-input>
              </el-col>
              <el-col :span="12">
                <el-button type="success" @click="handleCheckSuccess">审核通过</el-button>
              </el-col>
            </el-row>
          </el-col>
          <!--          审核不通过-->
          <el-col :span="12">
            <el-row :gutter="4">
              <el-col :span="12">
                <el-input placeholder="请输入不通过原因" type="text" v-model="auditcommentNO"></el-input>
              </el-col>
              <el-col :span="12">
                <el-button type="danger" @click="handleCheckError">审核不通过</el-button>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<style scoped lang="scss">

</style>
