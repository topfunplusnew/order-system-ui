<!-- 运费报表-->
<script>
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {getBankAcountChange} from "@/api/system/statement";
import {parseTime} from "@/utils/ruoyi";

export default {
  name: "bankAcountChangeSummary",
  mixins: [mixin_printHTML],
  data() {
    return {
      queryParams: {
        endTime: parseTime(new Date(), '{y}-{m}-{d}'),
        pageNum: 1,
        pageSize: 50
      },
      loading: '',
      columns: [
        {key: 0, label: '日期', visible: true,},
        {key: 1, label: '户名', visible: true,},
        {key: 2, label: '银行账号', visible: true,},
        {key: 3, label: '上日余额', visible: true,},
        {key: 4, label: '本日收款', visible: true,},
        {key: 5, label: '本日付款', visible: true,},
        {key: 6, label: '本日余额', visible: true,},
      ],
      statementList: [],
      dialogVisible: false
    }
  },
  methods: {
    getSummaries(param) {
      const {columns, data} = param;
      const sums = [];
      columns.forEach((column, index) => {
        if (index === 0) {
          sums[index] = '总价';
          return;
        }
        const values = data.map(item => Number(item[column.property]));
        const includes = [0, 3, 4, 5, 6]
        if (includes.includes(index)) {
          sums[index] = values.reduce((prev, curr) => {
            const value = Number(curr);
            if (!isNaN(value)) {
              return prev + curr;
            } else {
              return prev;
            }
          }, 0);
          if (index === 6) {
            sums[index] = sums[3] + sums[4] - sums[5]
          }
        }
      });

      return sums;
    },
    // 时间查询
    handleQuery() {
      getBankAcountChange(this.queryParams).then(res => {
        this.statementList = res.rows;
      })
    },
    refresh() {
      this.handleQuery();
    },
    handleSubmitTime() {
      this.download('statistics/export/orderfreightsummary', {
        endTime: this.queryParams.endTime
      }, `bankAcountChange${new Date().getTime()}.xlsx`)
      this.dialogVisible = false
    },
    handleExport() {
      this.dialogVisible = true;
    }
  },
  created() {
    getBankAcountChange(this.queryParams).then(res => {
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
          资金日报表
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
          <el-table border v-loading="loading" :data="statementList" show-summary :summary-method="getSummaries"
                    v-horizontal-scroll="'always'" size="mini" :cell-style="()=>{return {padding:'2px'}}"
                    id="printBox" fit>
            <el-table-column label="日期" align="center" prop="time" v-if="columns[0].visible" width="200"
            />
            <el-table-column label="户名" align="driverName" prop="acountsName" v-if="columns[1].visible"
                             width="200"/>
            <el-table-column label="银行账号" align="center" prop="bankNo" v-if="columns[2].visible"
                             width="200"/>
            <el-table-column label="上日余额" align="center" prop="previousDayBalance" v-if="columns[3].visible"
                             width="200"/>
            <el-table-column label="本日收款" align="center" prop="dailyReceipts" v-if="columns[4].visible"
                             width="200"/>
            <el-table-column label="本日付款" align="center" prop="dailyPayments" v-if="columns[5].visible"
                             width="200"/>
            <el-table-column label="本日余额" align="center" v-if="columns[6].visible">
              <template slot-scope="scope">
                {{ scope.row.previousDayBalance + scope.row.dailyReceipts - scope.row.dailyPayments }}
              </template>
            </el-table-column>
          </el-table>
        </el-row>
      </el-row>
    </div>
    <el-dialog
        title="请选择导出时间"
        :visible.sync="dialogVisible"
        width="400px">
      <el-form :model="queryParams" ref="queryForm" size="mini" label-width="68px">
        <el-form-item label="导出时间" prop="endTime">
          <el-date-picker
              v-model="queryParams.endTime"
              type="date"
              placeholder="选择时间"
              value-format="yyyy-MM-dd"
              size="mini">
          </el-date-picker>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="handleSubmitTime">导 出</el-button>
  </span>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">

</style>
