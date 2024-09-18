<!-- todo 运费报表-->
<script>
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {getOrderFreight} from "@/api/system/statement";
import {parseTime} from "@/utils/ruoyi";

export default {
  name: "orderfreight",
  mixins: [mixin_printHTML],
  data() {
    return {
      queryParams: {
        beginTime: parseTime(new Date(new Date().getTime() - 30 * 24 * 60 * 60 * 1000)),
        endTime: parseTime(new Date()),
        pageNum: 1,
        pageSize: 10
      },
      loading: '',
      columns: [
        {key: 0, label: `供应商`, visible: true},
        {key: 1, label: `地址`, visible: true},
        {key: 2, label: `联系人`, visible: true},
        {key: 3, label: `银行卡账号`, visible: true},
        {key: 4, label: `开户名`, visible: true},
        {key: 5, label: `开户行`, visible: true},
        {key: 6, label: `电话`, visible: true},
        {key: 7, label: `备注`, visible: true},
      ],
      statementList: []
    }
  },
  methods: {
    // 时间查询
    handleQuery() {
      getOrderFreight(this.queryParams).then(res => {
        this.statementList = res.rows;
      })
    },
    refresh() {
      this.handleQuery();
    },
    handleExport() {
      this.download('statistics/export/orderfreightsummary', {
        beginTime: this.queryParams.beginTime,
        endTime: this.queryParams.endTime
      }, `company_${new Date().getTime()}.xlsx`)

    }
  },
  created() {
    getOrderFreight(this.queryParams).then(res => {
      this.statementList = res.rows;
    })
  },
}
</script>

<template>
  <div>
    <div class="app-container">
      <!--    刷新行-->
      <el-row style="background-color:#e6e6e6;">
        <el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
      </el-row>
      <hr color="#e6e6e6"/>
      <!--    时间范围搜索行-->
      <el-row>
        <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" label-width="100px">
          <el-form-item label="时间" prop="companyName">
            <el-date-picker
              v-model="queryParams.beginTime"
              type="date"
              size="mini"
              value-format="yyyy-MM-dd"
              placeholder="选择日期">
            </el-date-picker>
          </el-form-item>
          <el-form-item>
            <el-date-picker
              v-model="queryParams.endTime"
              type="date"
              size="mini"
              value-format="yyyy-MM-dd"
              placeholder="选择日期">
            </el-date-picker>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          </el-form-item>
        </el-form>
      </el-row>
      <hr color="#e6e6e6"/>
      <el-row>
        <el-row style="font-weight: bold;font-size: 20px;margin: 0 30px">
          运费报表
        </el-row>
        <el-row>
          <right-toolbar :columns="columns">
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
            <template v-slot:export>
              <el-col :span="1.5">
                <el-button
                  plain
                  icon="el-icon-folder-opened"
                  size="mini"
                  @click="handleExport"
                  v-hasPermi="['system:supplier:export']"
                >
                </el-button>
              </el-col>
            </template>
          </right-toolbar>
          <el-table border v-loading="loading" :data="statementList"
                    height="450px" v-horizontal-scroll="'always'" size="mini" :cell-style="()=>{return {padding:'2px'}}"
                    id="printBox">
            <el-table-column label="车牌号" align="center" prop="carNo" v-if="columns[1].visible" width="200"
            />
            <el-table-column label="司机姓名" align="driverName" prop="driverName" v-if="columns[2].visible"
                             width="200"/>
            <el-table-column label="司机银行账号" align="center" prop="otherBankNo" v-if="columns[3].visible"
                             width="200"/>
            <el-table-column label="日支付总额" align="center" prop="dailyPaidAmount" v-if="columns[3].visible"
                             width="200"/>
            <el-table-column label="日未支付总额" align="center" prop="dailyUnpaidAmount" v-if="columns[4].visible"
                             width="200"/>
            <el-table-column label="日应付总额" align="center" prop="dailyTotalAmount" v-if="columns[5].visible"
                             width="200"/>
            <el-table-column label="月支付总额" align="center" prop="monthlyPaidAmount" v-if="columns[6].visible"
                             width="200"/>
            <el-table-column label="月未支付总额" align="center" prop="monthlyUnpaidAmount" v-if="columns[7].visible"
                             width="200"/>
            <el-table-column label="月应付总额" align="center" prop="monthlyTotalAmount" v-if="columns[7].visible"
                             width="200"/>
            <el-table-column label="年支付总额" align="center" prop="monthlyUnpaidAmount" v-if="columns[7].visible"
                             width="200"/>
            <el-table-column label="年未支付总额" align="center" prop="yearlyUnpaidAmount" v-if="columns[7].visible"
                             width="200"/>
            <el-table-column label="年应付总额" align="center" prop="yearlyTotalAmount" v-if="columns[7].visible"
                             width="200"/>
            <el-table-column label="上一天未支付总额" align="center" prop="previousDayUnpaidAmount"
                             v-if="columns[7].visible" width="200"/>
            <el-table-column label="上一个月未支付总额" align="center" prop="previousMonthUnpaidAmount"
                             v-if="columns[7].visible" width="200"/>
            <el-table-column label="上一年未支付总额" align="center" prop="previousYearUnpaidAmount"
                             v-if="columns[7].visible" width="200"/>
          </el-table>
        </el-row>
      </el-row>
    </div>
  </div>
</template>

<style scoped lang="scss">

</style>
