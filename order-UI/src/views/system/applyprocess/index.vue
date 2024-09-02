<!--付款审核流程页面 需求:渲染需要付款的信息列表，付款信息中有多个审核流程 提供按钮筛选仅
当前账号需要审核的流程 审核的过程调用修改接口-->
<script>
import {getPaymentApply, listPaymentApply} from "@/api/system/paymentApply";
import {listAuditInfo, listAuditInfoGroup} from "@/api/system/auditInfo";
import StepInfo from "@/components/StepInfo.vue";
import {mapGetters} from "vuex";
import {findFileExtension} from "@/utils/trash/utils";

export default {
  name: "index",
  components: {StepInfo},
  data() {
    return {
      columns: [
        {key: 0, label: `日期`, visible: true},
        {key: 1, label: `支付类型`, visible: true},
        {key: 2, label: `金额`, visible: true},
        {key: 3, label: `对方账号`, visible: true},
        {key: 4, label: `对方公司`, visible: true},
        {key: 5, label: `付款原因`, visible: true},
        {key: 6, label: `附件`, visible: true},
        {key: 7, label: `申请人`, visible: true},
        {key: 8, label: `备注`, visible: true},
        {key: 9, label: `审核流程`, visible: true},
      ],
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
      total: 0,
      //付款审核
      addCheckApplyProcessVisible: false
    }
  },
  watch: {
    //监听刷新标记
    checked: {
      columns: {
        handler: (newVal) => {
          localStorage.setItem("applyprocess-columns", JSON.stringify(newVal))
        },
        deep: true,
      },
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
  created() {
    if (localStorage.getItem('applyprocess-columns') === 'null'
      || !localStorage.getItem('applyprocess-columns')) {
      //设置localStorage
      localStorage.setItem("applyprocess-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('applyprocess-columns'));
    }
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
  },
  methods: {
    refresh() {
      listPaymentApply({pageNum: this.pageNum, pageSize: this.pageSize}).then(res => {
        this.paymentList = res.rows;
        this.total = res.total;
      })
      //获取所有的审核流程
      listAuditInfo().then(res => {
        this.allAuditInfoList = res.rows;
      })
    },
    //附件
    isPic(url) {
      console.log(url)
      return this.$imgs.includes(findFileExtension(url))
    },
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
}
</script>

<template>
  <div class="app-container">
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button @click="refresh">刷新</el-button>
      </el-col>

      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" :columns="columns">
        <!--    打印    -->
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
              v-hasPermi="['system:applyprocess:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>
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
          width="150" v-if="columns[0].visible">
        </el-table-column>
        <el-table-column
          prop="payType"
          label="支付类型"
          width="120" v-if="columns[1].visible">
        </el-table-column>
        <el-table-column
          prop="moneyAmount"
          label="金额"
          width="120" v-if="columns[2].visible">
        </el-table-column>
        <el-table-column
          prop="otherBankNo"
          label="对方账号"
          width="300" v-if="columns[3].visible">
        </el-table-column>
        <el-table-column
          prop="companyName"
          label="对方公司"
          width="120" v-if="columns[4].visible">
        </el-table-column>
        <el-table-column
          prop="reason"
          label="付款原因"
          width="120" v-if="columns[5].visible">
        </el-table-column>
        <el-table-column
          prop="attachment"
          label="附件"
          width="120" v-if="columns[6].visible">
          <template #default="scope">
            <img v-if="isPic(scope.row.attachment)" :src="scope.row.attachment" alt=""
                 style="width: 100%;height: 100%">
            <a v-else :href="scope.row.attachment">文件不支持预览，请手动下载:{{ scope.row.attachment }}</a>
          </template>
        </el-table-column>
        <el-table-column
          prop="applyPerson"
          label="申请人"
          width="120" v-if="columns[7].visible">
        </el-table-column>
        <el-table-column
          prop="comments"
          label="备注"
          width="120" v-if="columns[8].visible">
        </el-table-column>
        <el-table-column
          fixed="right"
          label="操作"
          width="80">
          <template slot-scope="scope">
            <el-button @click="handleCheckInfo(scope.row)" type="primary" size="mini">查看</el-button>
          </template>
        </el-table-column>
        <el-table-column
          fixed="right"
          label="审核流程"
          width="200" v-if="columns[9].visible">
          <template slot-scope="scope">
            <el-button type="warning" @click="handleCheckApplyInfo(scope.row)" size="mini">查看审核流程信息</el-button>
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


    <!--      审核流程步骤图信息  -->
    <el-dialog :visible.sync="checkApplyInfoDialogVisible" title="审核流程多项信息" width="58%">
      <el-row v-for="(item,index) in auditInfoList" :key="index">
        <el-collapse v-model="activeNames" @change="handleChangeApplyItem">
          <el-collapse-item name="1">
            <template #title>
              <el-row>
                <span class="text-bolder">审核流程</span>
              </el-row>
            </template>
            <el-row>
              <el-col :span="24">
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
