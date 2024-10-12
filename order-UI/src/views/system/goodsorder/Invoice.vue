<!--    开发票-->

<template>
  <el-dialog :close-on-click-modal="false" :show-close="false"
             :title="updateOrderItemVisibleTitle"
             :visible.sync="invoiceupdateOrderItemVisibleVisible"
             width="500px">
    <el-row>
      <el-form :model="updateOrderItemVisibleTitleInfo" label-width="110px"
               :rules="CheckRules.updateOrderItemVisibleTitleRules">
        <el-form-item label="开票日期" prop="invoiceDate">
          <el-date-picker
            v-model="updateOrderItemVisibleTitleInfo.invoiceDate"
            type="date"
            placeholder="选择日期"
            value-format="yyyy-MM-dd">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="我方开票实体" prop="invoiceObject">
          <el-input v-model="updateOrderItemVisibleTitleInfo.invoiceObject" placeholder="请输入我方开票实体"/>
        </el-form-item>
        <el-form-item label="开票金额" prop="invoiceAmount">
          <el-input v-model="updateOrderItemVisibleTitleInfo.invoiceAmount" placeholder="请输入开票金额"/>
        </el-form-item>
        <el-form-item label="公司名称" prop="companyName">
          <el-row>
            <el-col :span="10">
              <el-input v-model="updateOrderItemVisibleTitleInfo.companyName" placeholder="请输入对方公司名称"/>
            </el-col>
            <el-col :span="2">
              <SearchOption
                :limit-info="updateOrderItemVisibleTitleInfo.domain === 1? {companyType:'客户'}:{companyType:'供应商'}"
                :get-data="listCompany" query-info="companyName"
                query-label="公司名称" :query-name="queryCompanyName"
                @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
                <template #table-columns>
                  <el-table-column :label="updateOrderItemVisibleTitleInfo.domain === 1? '客户':'供应商'"
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
          <el-input v-model="updateOrderItemVisibleTitleInfo.invoiceCompanyName" placeholder="请输入票据单位名称"/>
        </el-form-item>
        <el-form-item label="票点" prop="ticketPoint">
          <el-input v-model="updateOrderItemVisibleTitleInfo.ticketPoint" placeholder="请输入票点"/>
        </el-form-item>
        <el-form-item label="票点金额" prop="ticketPointAmount">
          <el-input v-model="updateOrderItemVisibleTitleInfo.ticketPointAmount" placeholder="请输入票点金额"
                    disabled/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="updateOrderItemVisibleTitleInfo.comments" placeholder="请输入备注"/>
        </el-form-item>
      </el-form>
    </el-row>
    <span slot="footer" class="dialog-footer">
        <el-button @click="close">取 消</el-button>
        <el-button type="primary" @click="submitupdateOrderItemVisibleTitle">确 定</el-button>
      </span>
  </el-dialog>
</template>
<script>
import SearchOption from "@/components/SearchOption.vue"

export default {
  name: 'Invoice',
  components: {SearchOption},
  props: {
    CheckRules: {},
    handleCommitBackCompany: {},
    handleUpdateCompanyName: {},
    invoiceupdateOrderItemVisibleVisible: {},
    listCompany: {},
    queryCompanyName: {},
    submitupdateOrderItemVisibleTitle: {},
    updateOrderItemVisibleTitle: {},
    updateOrderItemVisibleTitleInfo: {},
    maxInvent: {}
  },
  methods: {
    close() {
      this.$emit('close')
    },

  },
  watch: {


    // 监听开票金额不能超过总货款
    'updateOrderItemVisibleTitleInfo.ticketPointAmount': {
      handler(val) {
        if (this.updateOrderItemVisibleTitleInfo.ticketPointAmount > this.maxInvent) {
          this.$modal.msgError('客户开票金额不能超过订单总货款')
          this.$emit('resetAmount')
        }
      }
    }
  }
}
</script>
