<!--付款审核流程页面 需求:渲染需要付款的信息列表，付款信息中有多个审核流程 提供按钮筛选仅
当前账号需要审核的流程 审核的过程调用修改接口-->
<script>
import {getPaymentApply, listPaymentApply} from "@/api/system/paymentApply";

export default {
  name: "index",
  data() {
    return {
      //查看付款信息的
      checkInfoDialogVisible: false,

      options: [{
        value: '所有审核信息',
        label: '所有审核信息'
      }, {
        value: '仅我需要审核',
        label: '仅我需要审核'
      }],
      //筛选限制值
      select: '',
      //付款信息列表
      paymentList: [],
      //查看付款信息的描述表
      checkPaymentInfo: {}
    }
  },
  methods: {
    //查看某一个行的信息
    handleCheckInfo(row) {
      console.log(row)
      this.checkInfoDialogVisible = true;
      //获取该行付款信息的详细信息 赋值到弹出框的描述表中
      getPaymentApply(row.id).then(res => {
        this.checkPaymentInfo = res.data
      })
    },
  },
  created() {
    //获取付款信息
    listPaymentApply().then(res => {
      this.paymentList = res.rows;
    })
  }
}
</script>

<template>
  <div class="app-container">
    <!--    筛选仅仅是我需要考虑的审核流程-->
    <el-row>
      <el-col :span="2">
        <span class="text-bolder">审核信息筛选</span>
      </el-col>
      <el-col :span="5">
        <el-select v-model="select" placeholder="请选择">
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-col>
    </el-row>
    <br/>
    <!--    放置付款信息列表-->
    <el-row>
      <el-table
        :data="paymentList"
        border
        style="width: 100%">
        <el-table-column
          fixed
          prop="fundsDate"
          label="日期"
          width="150">
        </el-table-column>
        <el-table-column
          prop="payType"
          label="支付类型"
          width="120">
        </el-table-column>
        <el-table-column
          prop="moneyAmount"
          label="金额"
          width="120">
        </el-table-column>
        <el-table-column
          prop="otherBankNo"
          label="对方账号"
          width="300">
        </el-table-column>
        <el-table-column
          prop="companyName"
          label="对方公司"
          width="120">
        </el-table-column>
        <el-table-column
          prop="reason"
          label="付款原因"
          width="120">
        </el-table-column>
        <el-table-column
          prop="attachment"
          label="附件"
          width="120">
        </el-table-column>
        <el-table-column
          prop="applyPerson"
          label="申请人"
          width="120">
        </el-table-column>
        <el-table-column
          prop="comments"
          label="备注"
          width="120">
        </el-table-column>
        <el-table-column
          fixed="right"
          label="操作"
          width="200">
          <template slot-scope="scope">
            <el-button @click="handleCheckInfo(scope.row)" type="primary" size="small">查看</el-button>
            <el-button type="warning" size="small">审核付款信息</el-button>
          </template>
        </el-table-column>
        <!-- 审核流程：只有上一个人审核后，才会有下一个审核信息-->
        <!--  step代表审核步骤进行到了哪里 -->
        <el-table-column
          fixed="right"
          label="审核流程"
          width="400">
          <template slot-scope="scope">
            <el-steps :active="1" finish-status="success" simple style="margin-top: 20px">
              <!--  渲染的时候:先获取每个订单的审核流程列表 然后绑定到title上-->
              <!--  获取审核列表最晚的step赋值给active-->
              <el-step title="步骤 1"></el-step>
              <el-step title="步骤 2"></el-step>
              <el-step title="步骤 3"></el-step>
            </el-steps>
          </template>
        </el-table-column>
      </el-table>
    </el-row>


    <!--    查看付款信息的详细信息-->
    <el-dialog
      title="付款信息详细"
      :visible.sync="checkInfoDialogVisible"
      width="50%">
      <el-descriptions title="付款信息明细">
        <el-descriptions-item label="申请人">{{ checkPaymentInfo.applyPerson }}</el-descriptions-item>
        <el-descriptions-item label="申请金额">{{ checkPaymentInfo.moneyAmount }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ checkPaymentInfo.comments }}</el-descriptions-item>
        <el-descriptions-item label="公司类型">
          {{ checkPaymentInfo.companyType }}
        </el-descriptions-item>
        <el-descriptions-item label="公司名称">
          {{ checkPaymentInfo.companyName }}
        </el-descriptions-item>
        <el-descriptions-item label="时间">
          {{ checkPaymentInfo.fundsDate }}
        </el-descriptions-item>
        <el-descriptions-item label="对方账户名称">
          {{ checkPaymentInfo.otherAcountsName }}
        </el-descriptions-item>
        <el-descriptions-item label="对方银行卡号">
          {{ checkPaymentInfo.otherBankNo }}
        </el-descriptions-item>
        <el-descriptions-item label="对方开户行">
          {{ checkPaymentInfo.otherBankName }}
        </el-descriptions-item>
        <el-descriptions-item label="申请原因">
          {{ checkPaymentInfo.reason }}
        </el-descriptions-item>
      </el-descriptions>
      <span slot="footer" class="dialog-footer">
    <el-button @click="checkInfoDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="checkInfoDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">
.text-bolder {
  font-weight: bolder;
  line-height: 35px;
}
</style>
