<!--付款审核流程页面 需求:渲染需要付款的信息列表，付款信息中有多个审核流程 提供按钮筛选仅
当前账号需要审核的流程 审核的过程调用修改接口-->
<script>
import {getPaymentApply, listPaymentApply} from "@/api/system/paymentApply";
import {listAuditInfo, listAuditInfoGroup} from "@/api/system/auditInfo";
import StepInfo from "@/components/StepInfo.vue";
import {mapGetters} from "vuex";

export default {
  name: "index",
  components: {StepInfo},
  data() {
    return {
      //查看付款信息的
      checkInfoDialogVisible: false,
      //查看审核流程
      checkApplyInfoDialogVisible: false,
      //筛选项
      options: [{
        value: '1',
        label: '所有审核信息'
      }, {
        value: '2',
        label: '仅我需要审核'
      }],
      //筛选限制值
      select: '',
      //折叠面板默认打开
      activeNames: '1',
      //付款信息列表
      paymentList: [],
      //查看付款信息的描述表
      checkPaymentInfo: {},


      auditInfoList: [],
      auditItemList: [],

      //所有的审核流程列表 后期需要筛选这里面的审核流程
      allAuditInfoList: [],

      //分页信息
      pageNum: 1,
      pageSize: 10,
      total: 0
    }
  },
  watch: {
    //选择 仅仅我看还是所有的审核信息全部展示
    select: {
      handler(val) {
        console.log(val)
        //如果val是1 所有审核信息
        if (Number(val) === 1) {
          console.log('所有审核信息全部展示')
          //调用接口获取所有的审核流程列表
          listAuditInfo().then(res => {
            this.allAuditInfoList = res.rows;
          })
        }
        //如果val是2 仅我需要审核
        if (Number(val) === 2) {
          console.log('仅仅我需要展示')
        }
      }
    },
    //监听刷新标记
    checked: {
      handler(val) {
        if (val !== '') {
          setTimeout(() => {
            this.refreshApplyCheckInfo(val)
            this.$store.dispatch('apply/clearChecked')
          }, 500)
        }
      },
    }
  },
  methods: {
    //重新刷新审核树
    refreshApplyCheckInfo(applyID) {
      this.$wait()
      //获取所有的审核流程
      listAuditInfoGroup({applyID: applyID}).then(res => {
        this.auditInfoList = res.rows;
        this.$close()
      }).catch(err => {
        this.$close()
      })
    },
    //分页获取列表
    getPaymentList() {
      this.$wait()
      listPaymentApply({pageNum: this.pageNum, pageSize: this.pageSize}).then(res => {
        this.paymentList = res.rows;
        this.$close()
      }).catch(err => {
        this.$close()
      })
    },
    //查看某一个行的信息
    handleCheckInfo(row) {
      this.checkInfoDialogVisible = true;
      //获取该行付款信息的详细信息 赋值到弹出框的描述表中
      getPaymentApply(row.id).then(res => {
        this.checkPaymentInfo = res.data
      })
    },

    //查看某一行的审核流程信息
    handleCheckApplyInfo(row) {
      this.checkApplyInfoDialogVisible = true
      listAuditInfoGroup({applyID: row.id}).then(res => {
        this.auditInfoList = res.rows
      })
    },

    //折叠面板打开某一个的回调
    handleChangeApplyItem(e) {
      console.log(e)
    },
  },
  created() {
    //获取付款信息
    listPaymentApply({pageNum: this.pageNum, pageSize: this.pageSize}).then(res => {
      this.paymentList = res.rows;
      this.total = res.total;
    })
    //获取所有的审核流程
    listAuditInfo().then(res => {
      this.allAuditInfoList = res.rows;
    })
  },
  computed: {
    ...mapGetters(['checked'])
  }
}
</script>

<template>
  <div class="app-container">
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
          width="80">
          <template slot-scope="scope">
            <el-button @click="handleCheckInfo(scope.row)" type="primary" size="small">查看</el-button>
          </template>
        </el-table-column>
        <!-- 审核流程：只有上一个人审核后，才会有下一个审核信息-->
        <!--  step代表审核步骤进行到了哪里 -->
        <el-table-column
          fixed="right"
          label="审核流程"
          width="200">
          <template slot-scope="scope">
            <el-button type="warning" @click="handleCheckApplyInfo(scope.row)">查看审核流程信息</el-button>
          </template>
        </el-table-column>
      </el-table>
      <!--      分页-->
      <pagination
        v-show="total>0"
        :total="total"
        :page.sync="pageNum"
        :limit.sync="pageSize"
        @pagination="getPaymentList"
      />
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


    <el-dialog :visible.sync="checkApplyInfoDialogVisible" title="审核流程多项信息" width="80%">
      <!--      筛选条件-->
      <!--    筛选仅仅是我需要考虑的审核流程-->
      <!--      <el-row>-->
      <!--        <el-col :span="2">-->
      <!--          <span class="text-bolder">审核信息筛选</span>-->
      <!--        </el-col>-->
      <!--        <el-col :span="5">-->
      <!--          <el-select v-model="select" placeholder="请选择">-->
      <!--            <el-option-->
      <!--              v-for="item in options"-->
      <!--              :key="item.value"-->
      <!--              :label="item.label"-->
      <!--              :value="item.value">-->
      <!--            </el-option>-->
      <!--          </el-select>-->
      <!--        </el-col>-->
      <!--      </el-row>-->
      <br/>
      <!--      审核流程步骤图信息  -->
      <el-row v-for="(item,index) in auditInfoList" :key="index">
        <el-collapse v-model="activeNames" @change="handleChangeApplyItem">
          <el-collapse-item name="1">
            <template #title>
              <el-row>
                <!-- todo  只保留了一组审核信息-->
                <!--  <span class="text-bolder">审核流程{{ index + 1 }}</span>-->
                <span class="text-bolder">审核流程</span>
              </el-row>
            </template>
            <el-row>
              <el-col :span="24">
                <!--  @getPaymentApplyCheckList需要重新刷新-->
                <StepInfo :processInfo="item.auditInfos"/>
              </el-col>
            </el-row>
          </el-collapse-item>
        </el-collapse>

      </el-row>


      <span slot="footer" class="dialog-footer">
        <el-button @click="checkApplyInfoDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="checkApplyInfoDialogVisible = false">确 定</el-button>
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
