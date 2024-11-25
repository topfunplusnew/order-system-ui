<!--供应商科目明细表-->

<script>
  import { listConfig } from '@/api/system/config'
  import {
    getSupplierSubjectDetailSomeDay,
    getSupplierSubjectDetailSummary
  } from '@/api/system/statement'
  import { getSubjectLevel } from '@/api/system/subject'
  import { TableName } from '@/api/tool/enums'
  import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue'
  import INVENTORY from '@/components/NeedToShow/INVENTORY.vue'
  import INVOICE_IN from '@/components/NeedToShow/INVOICE_IN.vue'
  import INVOICE_ORTHER from '@/components/NeedToShow/INVOICE_ORTHER.vue'
  import INVOICE_OUT from '@/components/NeedToShow/INVOICE_OUT.vue'
  import OFFSETTING from '@/components/NeedToShow/OFFSETTING.vue'
  import ORDER_DETAIL from '@/components/NeedToShow/ORDER_DETAIL.vue'
  import PAYMENT from '@/components/NeedToShow/PAYMENT.vue'
  import REBATE from '@/components/NeedToShow/REBATE.vue'
  import { getFunction } from '@/utils/order/mapper'
  import TotalTag from '@/views/system/Statement/components/TotalTag.vue'
  import { ReportType } from '../../../../api/tool/enums'
  import { fix } from '../../../../api/tool/format'

  export default {
    name: 'SupplierDetail',
    components: { TotalTag },
    props: {
      // 需要查看的那一行供应商的信息
      detail: {
        type: Object,
        default: () => {}
      }
    },
    data() {
      return {
        loading: false,
        // 弹窗
        dialogVisible: false,
        tableData: [],

        // 查询对应信息的弹窗
        infoVisible: false,

        // 对应渲染的组件和信息
        Components: null,
        needToShowInfo: null,

        // 五个字段 tags
        tags: null
      }
    },
    computed: {
      supplierId() {
        return this.detail.companyId
      }
    },

    methods: {
      handleCheck() {
        // 清除一下状态
        this.tableData = []
        // 打开时间选择框
        this.$datePicker().then((res) => {
          // 组装查询条件 分别为开始时间 结束时间 供应商id
          const query = {
            companyId: this.supplierId,
            beginTime: res.beginTime,
            endTime: res.endTime
          }
          const key = { configKey: 'order.customerDetailSummary.subjectNo' }
          // 查询科目 填充
          listConfig(key).then((res) => {
            // 科目编码
            const configValue = res.rows[0]?.configValue
            // 根据configValue去拿取科目名称
            getSubjectLevel(configValue).then((res) => {
              // 校验科目
              if (!res.data) {
                this.$message.warning('科目不存在')
              }
              // 拿到科目名称
              const subjectName = res.data.title
              // 查询明细账之前 要先查询上年结转的余额本币填充
              const body = {
                beginTime: query.beginTime,
                companyId: query.companyId
              }
              getSupplierSubjectDetailSomeDay(body).then((res) => {
                // 校验
                if (!res.data) {
                  this.$message.warning('上年结转数据不存在')
                  return
                }
                // 拿到上年的数据
                const lastYearDetail = res.data
                // 把上年结转的数据放在最前面 并且摘要为上年结转
                this.tableData.push({
                  ...lastYearDetail,
                  summary: '上年结转',
                  moneyAmountLocal: lastYearDetail.moneyAmount,
                  subjectNo: configValue,
                  subjectName: subjectName
                })
                // 查询供应商明细账
                getSupplierSubjectDetailSummary(query).then((res) => {
                  try {
                    // 上年结转的余额
                    let lastMoney = Number(lastYearDetail.moneyAmount)
                    // 累计金额
                    let nowMoney = Number(0)
                    // 拿到汇总账
                    const append = res.data.map((item) => {
                      // 金额累计计算
                      nowMoney = lastMoney + Number(item.moneyAmount)
                      // 更新
                      lastMoney = nowMoney
                      // 如果有了摘要 不做处理
                      if (item.summary) {
                        return {
                          ...item,
                          moneyAmountLocal: fix(nowMoney),
                          subjectNo: configValue,
                          subjectName: subjectName
                        }
                      } else {
                        return {
                          ...item,
                          // 如果没有摘要 就加上对应的摘要
                          summary: ReportType.SUPPLIER[item.tableName],
                          moneyAmountLocal: fix(nowMoney),
                          subjectNo: configValue,
                          subjectName: subjectName
                        }
                      }
                    })
                    // 添加到上年结转数据的后面
                    this.tableData = this.tableData.concat(append)
                    // 打开弹窗
                    this.dialogVisible = true
                  } catch (err) {
                    this.$message.error(err)
                    return
                  }
                })
              })
            })
          })
        })
      },
      // 查询对应的信息 通过拿表名和id  对应两个字段为tableName payNo
      handleSearch(row) {
        // 拿到表名和id
        const { tableName, payNo } = row
        // 根据tableName动态获取某个JS模块
        getFunction(tableName)(payNo).then((res) => {
          // 填充数据
          this.needToShowInfo = res.data
          // 根据对应表名渲染对应的展示组件
          this.Components = this.getComponents(tableName)
          if (this.Components !== null) {
            // 打开弹窗
            this.infoVisible = true
          } else {
            this.$message.warning('组件渲染有误')
          }
        })
      },
      // 根据对应的表名渲染对应的组件
      getComponents(tableName) {
        const components = {
          [TableName.GOODS_ORDER]: GOODS_ORDER,
          [TableName.PAYMENT]: PAYMENT,
          [TableName.INVOICE_IN]: INVOICE_IN,
          [TableName.INVOICE_OUT]: INVOICE_OUT,
          [TableName.INVOICE_OTHER]: INVOICE_ORTHER,
          [TableName.OFFSETTING]: OFFSETTING,
          [TableName.REBATE]: REBATE,
          [TableName.INVENTORY]: INVENTORY,
          [TableName.ORDER_DETAIL]: ORDER_DETAIL
        }
        // 默认返回 null，如果没有匹配的 tableName
        return components[tableName] || null
      }
    }
  }
</script>

<template>
  <div>
    <!--    供应商明细表的按钮-->
    <el-button type="primary" size="mini" @click="handleCheck">查看明细</el-button>

    <!--    供应商明细表的弹窗-->
    <el-dialog title="提示" :visible.sync="dialogVisible" width="900px" fullscreen append-to-body>
      <!--      供应商明细表五个字段的显示组件 跟现在的供应商明细表在一个查询框下
                含税货款、不含税货款、公户收款、私户收款、票点收入
                这五个数据-->
      <!--      供应商无-->
      <!--      <TotalTag :tags="tags"/>-->
      <br />
      <br />
      <!--      供应商的结转数据-->
      <el-card class="box-card">
        <el-table
          id="printBox"
          v-loading="loading"
          v-horizontal-scroll="'always'"
          border
          :data="tableData"
          max-height="600px"
          size="mini"
          :cell-style="
            () => {
              return { padding: '2px' }
            }
          "
        >
          <el-table-column
            show-overflow-tooltip
            label="时间"
            align="center"
            prop="operateDate"
            width="140"
          />
          <!--      操作列-->
          <el-table-column
            label="凭证号"
            align="center"
            class-name="small-padding fixed-width"
            width="140"
            prop="payNo"
          >
            <template slot-scope="scope">
              <el-button
                v-if="scope.row.payNo"
                type="text"
                size="mini"
                @click="handleSearch(scope.row)"
              >
                点击查询对应信息
              </el-button>
            </template>
          </el-table-column>
          <el-table-column
            show-overflow-tooltip
            label="科目编码"
            align="center"
            prop="subjectNo"
            width="140"
          />
          <el-table-column
            show-overflow-tooltip
            label="科目名称"
            align="center"
            prop="subjectName"
            width="140"
          />
          <el-table-column
            show-overflow-tooltip
            label="供应商编号"
            align="center"
            prop="companyId"
            width="140"
          />
          <el-table-column
            show-overflow-tooltip
            label="供应商名称"
            align="center"
            prop="companyName"
            width="140"
          />
          <el-table-column
            show-overflow-tooltip
            label="供应商银行户名（对方真实收付款名称）"
            align="center"
            prop="otherAccountsName"
            width="140"
          />
          <el-table-column
            show-overflow-tooltip
            label="供应商银行卡号"
            align="center"
            prop="otherBankNo"
            width="140"
          />

          <el-table-column
            show-overflow-tooltip
            label="摘要"
            align="center"
            prop="summary"
            width="140"
          />

          <!--        这两列应该是根据moneyAmount字段的正负进行判断-->
          <el-table-column
            show-overflow-tooltip
            label="借方发生额(付供应商货款)"
            align="center"
            width="140"
          >
            <template slot-scope="scope">
              {{ scope.row.moneyAmount > 0 ? scope.row.moneyAmount : '-' }}
            </template>
          </el-table-column>
          <el-table-column
            show-overflow-tooltip
            label="贷方(在供应商那里提货)"
            align="center"
            width="140"
          >
            <template slot-scope="scope">
              {{ scope.row.moneyAmount > 0 ? '-' : Math.abs(scope.row.moneyAmount) }}
            </template>
          </el-table-column>

          <!--        方向根据余额本币的正负进行判断 这个要先查询上年结转的余额本币 进行填充-->
          <el-table-column show-overflow-tooltip label="方向" align="center" width="140">
            <template slot-scope="scope">
              {{ scope.row.moneyAmountLocal > 0 ? '借方' : '贷方' }}
            </template>
          </el-table-column>

          <el-table-column
            show-overflow-tooltip
            label="余额本币"
            align="center"
            prop="moneyAmountLocal"
            width="140"
          />
          <el-table-column
            show-overflow-tooltip
            label="我方收款户名"
            align="center"
            prop="selfAccountsName"
            width="140"
          />
          <el-table-column
            show-overflow-tooltip
            label="我方银行账号"
            align="center"
            prop="selfBankNo"
            width="140"
          />
          <el-table-column
            show-overflow-tooltip
            label="我方开户行地址"
            align="center"
            prop="selfBankName"
            width="140"
          />
        </el-table>
      </el-card>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
      </span>
    </el-dialog>

    <!--    对应信息的弹窗-->
    <el-dialog title="信息" :visible.sync="infoVisible" width="900px" append-to-body>
      <component :is="Components" :need-to-show-info="needToShowInfo" />
    </el-dialog>
  </div>
</template>

<style scoped lang="scss"></style>
