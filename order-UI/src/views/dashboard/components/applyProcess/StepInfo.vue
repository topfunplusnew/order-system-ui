<script>
import {getUserProfile} from "@/api/system/user";
import CheckApply from "@/views/dashboard/components/applyProcess/CheckApply.vue";
import {listAuditflow, updateAuditflow} from "@/api/system/auditflow";
import {updateAuditInfo} from "@/api/system/auditInfo";
import {TableName} from "@/api/tool/enums";
import {getOrderFreight} from "@/api/system/orderFreight";
import {getBorrowedMoney} from "@/api/system/borrowedMoney";
import NeedToShowInfo from "@/components/NeedToShowInfo.vue";
import {getOilRecharge} from "@/api/system/oilRecharge";

export default {
  name: "StepInfo",
  components: {NeedToShowInfo, CheckApply},
  data() {
    return {
      //当前登录用户
      loginUser: {},
      //审核页
      checkPaymentApplyDialogVisible: false,
      //当前审核页需要审核的付款信息
      currentCheckPaymentApply: {},
      //审核流程步骤信息
      checkApplyInfo: {},
      //需要的applyID 给父组件用来更新
      useApplyID: '',
      needToShowInfo: {},
      //表名
      tableNameToProp: ''
    }
  },
  props: {
    processInfo: {
      type: Array,
      required: true
    }
  },
  computed: {
    //当前审核进度
    currentStep() {
      //找到step最大的
      return Math.max.apply(null, this.processInfo.map(item => item.step));
    },
  },
  created() {
    //获取当前登录用户信息
    getUserProfile().then(res => {
      this.loginUser = res.data;
    })
  },
  methods: {
    findUserIdIndex(userId, arr) {
      if (userId === undefined || userId === null || userId === '') {
        return false
      }
      const splitArr = arr.split(',')
      return splitArr.includes(userId + '')
    },
    //按钮type绑定
    types(item) {
      return !this.findUserIdIndex(this.loginUser.userId, item.auditauthority) ? 'warning' : 'primary'
    },
    //按钮禁用
    isDisable(item) {
      //如果在审核中
      if (item.checkState === '审核中') {
        //todo 根据用户的userId来判断是否该用户需要审核
        // return !this.findUserIdIndex(this.loginUser.userId, item.auditauthority);
        return false
      } else if (item.checkState === '通过') {
        return true //如果该项审批流程通过，则禁用按钮
      } else {
        return true //未通过 则禁用按钮
      }
    },
    //标签
    isTag(item) {
      return item.checkState === '通过' ? 'success' : 'danger'
    },
    isChecked(item) {
      if (item.checkState === '通过') {
        return true;
      } else return item.checkState === '未通过';
    },

    //审核
    handleCheckState(item) {
      //根据tableName来决定给哪个发请求
      this.checkWithTableName(item.paymentApply.tableName, item.paymentApply.tID)

      //赋值 先拿到付款申请对象
      this.currentCheckPaymentApply = item.paymentApply
      //组装审核基本对象 传递给子组件审核页面
      this.checkApplyInfo = {
        id: item.id,
        applyID: item.applyID,
        flowname: item.flowname,
        stepnum: item.stepnum,
        step: item.step,
        auditauthority: item.auditauthority,
      }
      this.useApplyID = item.applyID
      //打开该审核流程步骤的审核页面
      this.checkPaymentApplyDialogVisible = true;
    },

    //修改审核状态 修改任意状态 关闭弹窗
    handleUpdateCheckState(val) {
      this.checkPaymentApplyDialogVisible = false //关闭
    },

    //根据表名查询
    checkWithTableName(tableName, tID) {
      //展示对应表信息
      this.tableNameToProp = tableName;
      switch (tableName) {
        //订单运费
        case TableName.ORDER_FREIGHT: {
          //发请求 获取订单运费信息
          getOrderFreight(tID).then(res => {
            this.needToShowInfo = res.data
          })
          break;
        }
        // 借钱
        case TableName.BORROWED_MONEY:
          getBorrowedMoney(tID).then(res => {
            this.needToShowInfo = res.data
          })
          break;
        case 'paymentApplyDetailItem':
          this.needToShowInfo = item.paymentApplyDetailItem
          break;

        // 油卡充值
        case TableName.OIL_RECHARGE:
          getOilRecharge(tID).then(res => {
            this.needToShowInfo = res.data
          })
          break;
        default:
          break;
      }
    }
  }
}
</script>

<template>
  <div>
    <el-row>
      <el-col :span="4">
        <span style="font-weight: bolder; font-size: 16px;line-height: 100px">
          审核进度:
        </span>
      </el-col>
      <el-col :span="18">
        <el-steps :active="currentStep" finish-status="success" style="margin-top: 20px">
          <!--      循环-->
          <el-step v-for="(item,index) in processInfo" :status="item.checkState==='通过'?'success':'error'"
                   :key="index">
            <template #title>
          <span style="font-weight: bolder">
            {{ item.flowname }}
          </span>
            </template>
            <template #description>
          <span style="font-weight: bolder">
            审核意见:{{ item.auditcomment === null ? '无' : item.auditcomment }}
          </span>
            </template>
          </el-step>
        </el-steps>
      </el-col>
    </el-row>
    <br/>
    <br/>
    <el-row>
      <el-col :span="4">
        <span style="font-weight: bolder; font-size: 16px;line-height: 100px">
          审核明细:
        </span>
      </el-col>
      <el-col :span="18">
        <el-timeline>
          <el-timeline-item v-for="(item,index) in processInfo" :key="index" :timestamp="item.auditdate"
                            placement="top">
            <el-card :class="{'shadow':isDisable(item)}">
              <el-row>
                <el-col :span="18">
                  <h2>{{ item.flowname }}</h2>
                  <p>
                    <span class="tx-bolder">审核结果:</span>
                    <el-tag :type="isTag(item)">{{ item.checkState }}</el-tag>
                  </p>
                  <p>
                    <span class="tx-bolder">审核意见:</span>
                    <span v-if="isChecked(item)">{{ item.auditcomment }}</span>
                    <span v-else> <el-tag type="warning">待审核</el-tag></span>
                  </p>
                </el-col>
                <el-col :span="4">
                  <!--  判断当前审核过程是否为登录用户的userId-->
                  <el-tooltip class="item" effect="dark"
                              :content="!isDisable?'您不用审核该项':'审核'"
                              placement="top-start">
                    <el-button :type="types(item)"
                               :disabled="isDisable(item)" @click="handleCheckState(item)">审核

                    </el-button>
                  </el-tooltip>
                </el-col>
              </el-row>
            </el-card>
          </el-timeline-item>
        </el-timeline>

        <!-- 审核页面 checkPaymentApplyDialogVisible-->
        <el-dialog :close-on-click-modal="false"
                   title="流程审核"
                   :visible.sync="checkPaymentApplyDialogVisible"
                   width="65%"
                   append-to-body>
          <!--   需要展示的对应的表信息-->
          <NeedToShowInfo :need-to-show-info="needToShowInfo" :table-name-to-prop="tableNameToProp"/>
          <hr/>
          <CheckApply :payment-apply-info="currentCheckPaymentApply"
                      :check-apply-info="checkApplyInfo"
                      @update:isCheckState="handleUpdateCheckState"/>
          <span slot="footer" class="dialog-footer">
                <el-button @click="checkPaymentApplyDialogVisible = false">取 消</el-button>
                <el-button type="primary" @click="checkPaymentApplyDialogVisible = false">确 定</el-button>
          </span>
        </el-dialog>
      </el-col>
    </el-row>
  </div>
</template>

<style scoped lang="scss">
.tx-bolder {
  font-weight: bolder;
}

/*卡片遮罩*/
.shadow {
  opacity: 30%;
}
</style>
