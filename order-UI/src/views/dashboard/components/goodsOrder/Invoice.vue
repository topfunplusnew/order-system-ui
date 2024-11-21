<!--    开发票-->

<template>
  <div>
    <el-row>
      <el-form :model="invoiceInfo" label-width="110px"
               :rules="CheckRules.updateOrderItemVisibleTitleRules">
        <el-form-item label="开票日期" prop="invoiceDate">
          <el-date-picker
            v-model="invoiceInfo.invoiceDate"
            type="datetime"
            placeholder="选择日期"
            value-format="yyyy-MM-dd HH:mm:ss">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="我方开票实体" prop="invoiceObject">
          <el-input v-model="invoiceInfo.invoiceObject" placeholder="请输入我方开票实体"/>
        </el-form-item>
        <el-form-item label="开票金额" prop="invoiceAmount">
          <el-input v-model="invoiceInfo.invoiceAmount" placeholder="请输入开票金额"/>
        </el-form-item>
        <el-form-item label="公司名称" prop="companyName">
          <el-row>
            <el-col :span="10">
              <el-input v-model="invoiceInfo.companyName" placeholder="请输入对方公司名称"/>
            </el-col>
            <el-col :span="2">
              <SearchOption
                :limit-info="invoiceInfo.domain === 1? {companyType:'客户'}:{companyType:'供应商'}"
                :get-data="listCompany" query-info="companyName"
                query-label="公司名称" :query-name="queryCompanyName"
                @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
                <template #table-columns>
                  <el-table-column :label="invoiceInfo.domain === 1? '客户':'供应商'"
                                   align="center"
                                   prop="relationName"/>
                  <el-table-column label="老板姓名" align="center" prop="leader"/>
                  <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                  <el-table-column label="区域" align="center" prop="region"/>
                  <el-table-column label="公司名称" align="center" prop="companyName"/>
                  <el-table-column label="销售经理" align="center" prop="salesManager"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="票据单位名称" prop="invoiceCompanyName">
          <el-input v-model="invoiceInfo.invoiceCompanyName" placeholder="请输入票据单位名称"/>
        </el-form-item>
        <el-form-item label="票点" prop="ticketPoint">
          <el-input v-model="invoiceInfo.ticketPoint" placeholder="请输入票点"/>
        </el-form-item>
        <el-form-item label="票点金额" prop="ticketPointAmount">
          <el-input v-model="invoiceInfo.ticketPointAmount" placeholder="请输入票点金额"
                    disabled/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="invoiceInfo.comments" placeholder="请输入备注"/>
        </el-form-item>
      </el-form>
    </el-row>
  </div>
</template>
<script>
import SearchOption from "@/components/SearchOption.vue"
import {addInvoiceIn} from "@/api/system/invoiceIn";
import {checkOrderAllinvoice} from "@/api/system/goodsOrder";
import {addInvoiceOut} from "@/api/system/invoiceOut";
import {excludeParams} from "@/api/tool/exclude";
import {listCompany} from "@/api/system/company";
import {fix} from "@/api/tool/format";

export default {
  name: 'Invoice',
  components: {SearchOption},
  props: {
    // 最大开票金额
    maxInvent: {}
  },
  watch: {
    // 监听开票金额不能超过总货款
    'invoiceInfo': {
      handler(val) {
        if (this.invoiceInfo.ticketPointAmount > this.maxInvent) {
          this.$modal.msgError('客户开票金额不能超过订单总货款')
          this.$emit('resetAmount')
        }
        // 填充票点金额
        this.invoiceInfo.ticketPointAmount =
          fix(Number(this.invoiceInfo.ticketPoint) * Number(this.invoiceInfo.invoiceAmount))
      },
      deep: true,
      immediate: true
    },
  },
  data() {
    return {
      // 自己维护这个变量
      invoiceInfo: {},
      // 开票信息校验
      CheckRules: {
        updateOrderItemVisibleTitleRules: {
          invoiceDate: [
            {required: true, message: '请选择开票日期', trigger: 'blur'}
          ],
          invoiceObject:
            [
              {required: true, message: '请输入开票实体', trigger: 'blur'}
            ],
          invoiceCompanyName:
            [
              {required: true, message: '请输入票据单位名称', trigger: 'blur'}
            ],
          invoiceAmount:
            [
              {required: true, message: '请输入开票金额', trigger: 'blur'},
              // 开票金额 可以是小数
              {pattern: /^-?[0-9]+(\.[0-9]+)?$/, message: '只能输入数字和小数', trigger: 'blur'}
            ],
          companyName:
            [
              {required: true, message: '请输入公司名称', trigger: 'blur'}],
          // 只能是数字
          ticketPoint:
            [
              {required: true, message: '请输入开票点', trigger: 'blur'},
              {pattern: /^-?[0-9]+(\.[0-9]+)?$/, message: '只能输入数字', trigger: 'blur'}
            ],
          ticketPointAmount:
            [
              {required: true, message: '请输入开票点金额', trigger: 'blur'},
              {pattern: /^-?[0-9]+(\.[0-9]+)?$/, message: '只能输入数字', trigger: 'blur'}],
        }
      },
      queryCompanyName: '',
    }
  },
  created() {
    // 更新状态
    this.resetOpenTitleInfo()
    this.resetAmount()
  },
  methods: {
    listCompany,
    // 开票信息弹窗的搜索信息自动填充
    handleUpdateCompanyName(val) {
      this.queryCompanyName = val;
    },
    // 开票信息弹窗的信息自动填充
    handleCommitBackCompany(val) {
      this.invoiceInfo.companyName = val.companyName;
      this.invoiceInfo.companyID = val.id;
      this.invoiceInfo.companyType = val.companyType;
    },
    // 客户或者供应商开票功能
    handleProcess() {
      //排除不必要的字段
      this.invoiceInfo = excludeParams(this.invoiceInfo, this.$exclude)
      // 拿到开票个数
      const invoiceNumber = {
        customerInvoiceNumber: this.invoiceInfo.customerInvoiceNumber,
        supplierInvoiceNumber: this.invoiceInfo.supplierInvoiceNumber
      }
      // 金额
      let total_out = 0
      let total_in = 0
      //这里要判断一下 如果是客户开票 就添加发票卖出信息 如果是供应商开票 则添加发票买入信息
      if (this.invoiceInfo.domain === 1) {
        // 这里要判断一下 客户开票的开票金额大于总货款 todo
        checkOrderAllinvoice(this.invoiceInfo.isOrderTax).then(res => {
          total_out = res.hasOwnProperty('data') ? res.data.total_out : 0
          // 开票金额 + 查出的  < 总货款
          if (Number(this.invoiceInfo.invoiceAmount) + total_out < this.maxInvent) {
            //客户开票 添加发票卖出信息
            addInvoiceOut(this.invoiceInfo)
              .then(res => {
                this.$message.success('客户开票成功~')
                this.invoiceupdateOrderItemVisibleVisible = false;
                this.resetOpenTitleInfo();
                this.getList();
                // this.updateGoodsOrderAfterOpen(invoiceNumber, this.invoiceInfo.domain)
              })
          } else {
            this.$message.error(`累计开票金额超过总货款`)
          }
        })
      } else {
        checkOrderAllinvoice(this.invoiceInfo.isOrderTax).then(res => {
          total_in = res.hasOwnProperty('data') ? res.data.total_in : 0
          // 开票金额 + 查出的  < 出厂货款
          if (Number(this.invoiceInfo.invoiceAmount) + total_in < this.maxInvent) {
            // 供应商开票
            addInvoiceIn(this.invoiceInfo)
              .then(res => {
                this.$message.success('供应商开票成功~')
                this.invoiceupdateOrderItemVisibleVisible = false;
                this.resetOpenTitleInfo();
                this.getList();
                // this.updateGoodsOrderAfterOpen(invoiceNumber, this.invoiceInfo.domain)
              })
          } else {
            this.$message.error(`累计开票金额超过出厂货款`)
          }
        })
      }
    },
    // 重置输入的票点与金额
    resetAmount() {
      this.invoiceInfo.invoiceAmount = 0
      this.invoiceInfo.ticketPoint = 0
      this.invoiceInfo.ticketPointAmount = 0;
    },
    // 开票信息重置
    resetOpenTitleInfo() {
      this.invoiceInfo = {
        id: null,
        invoiceDate: null,
        invoiceObject: '',
        invoiceAmount: '',
        companyType: '',
        companyName: '',
        companyID: '',
        invoiceCompanyName: '',
        ticketPoint: null,
        ticketPointAmount: null,
        isOrderTax: 0,
        comments: '',
      }
    },
  },

}
</script>
