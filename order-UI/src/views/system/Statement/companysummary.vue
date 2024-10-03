<!--向外借钱-->
<template>
  <div class="app-container">
    <el-row style="background-color:#e6e6e6;">
      <el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
    </el-row>
    <hr color="#e6e6e6"/>
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" label-width="68px">
      <el-form-item label="开始时间" prop="beginTime">
        <el-date-picker
          v-model="queryParams.beginTime"
          type="date"
          placeholder="请选择开始时间"
          value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="结束时间" prop="endTime">
        <el-date-picker
          v-model="queryParams.endTime"
          type="date"
          placeholder="请选择结束时间" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>
    <hr color="#e6e6e6"/>
    <el-row style="font-weight: bold;font-size: 20px;margin: 0 30px">
      客户报表
    </el-row>
    <el-row :gutter="10" class="mb8">
      <right-toolbar @queryTable="getList" :columns="columns">
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
              v-hasPermi="['system:company:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="tableData"
              v-horizontal-scroll="'always'" id="printBox" size="mini" :cell-style="()=>{return {padding:'2px'}}">
      <el-table-column show-overflow-tooltip label="序号" align="center" prop="index" v-if="columns[0].visible"
                       width="140"/>
      <el-table-column show-overflow-tooltip label="客户名称" align="center" prop="companyName"
                       v-if="columns[1].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="上日欠款结转" align="center" prop="previousDayCarryover"
                       v-if="columns[2].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="本日发货金额" align="center" prop="dailyOrderPayments"
                       v-if="columns[3].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="本日票点金额" align="center" prop="dailyInvoiceAmount"
                       v-if="columns[4].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="本日回款金额" align="center" prop="dailyReceiveMoney"
                       v-if="columns[5].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="本日欠款金额" align="center" prop="amountOwedToday"
                       v-if="columns[6].visible" width="140">
        <template slot-scope="scope">
          {{
            Number(scope.row.previousDayCarryover) + Number(scope.row.dailyOrderPayments) + Number(scope.row.dailyInvoiceAmount) - Number(scope.row.dailyReceiveMoney)
          }}
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="本日客户利润" align="center" prop="dailyProfit"
                       v-if="columns[7].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="上月欠款金额结转" align="center" prop="previousMonthCarryover"
                       v-if="columns[8].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="本月发货金额合计" align="center" prop="monthlyOrderPayments"
                       v-if="columns[9].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="本月购入票点" align="center" prop="monthlyInvoiceAmount"
                       v-if="columns[10].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="本月回款金额" align="center" prop="monthlyReceiveMoney"
                       v-if="columns[11].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="本月欠款" align="center" prop="amountOwedThisMonth"
                       v-if="columns[12].visible" width="140">
        <template slot-scope="scope">
          {{
            Number(scope.row.previousMonthCarryover) + Number(scope.row.monthlyReceiveMoney) + Number(scope.row.monthlyInvoiceAmount) - Number(scope.row.monthlyOrderPayments)
          }}
        </template>
      </el-table-column>
      <el-table-column show-overflow-tooltip label="本月客户利润" align="center" prop="monthlyProfit"
                       v-if="columns[13].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="上年结转" align="center" prop="previousYearCarryover"
                       v-if="columns[14].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="本年发货金额" align="center" prop="yearlyOrderPayments"
                       v-if="columns[15].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="本年票点" align="center" prop="yearlyInvoiceAmount"
                       v-if="columns[16].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="本年回款金额" align="center" prop="yearlyReceiveMoney"
                       v-if="columns[17].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="本年利润" align="center" prop="yearlyProfit"
                       v-if="columns[18].visible" width="140"/>
      <el-table-column show-overflow-tooltip label="欠款" align="center" prop="arrearsThisYear"
                       v-if="columns[19].visible" width="140">
        <template slot-scope="scope">
          {{
            Number(scope.row.previousYearCarryover) + Number(scope.row.yearlyReceiveMoney) + Number(scope.row.yearlyInvoiceAmount) - Number(scope.row.yearlyOrderPayments)
          }}
        </template>
      </el-table-column>

    </el-table>


    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
    <el-dialog :show-close="false"
               title="请选择导出时间段"
               :visible.sync="dialogVisible"
               width="30%">
      <el-form :model="queryParams" ref="queryForm" size="mini" label-width="68px">
        <el-form-item label="开始时间" prop="beginTime">
          <el-date-picker
            v-model="queryParams.beginTime"
            type="date"
            placeholder="选择时间"
            value-format="yyyy-MM-dd"
            size="mini">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
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

<script>
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {getCompanySummary, getOrderFreightDetailSummary} from "../../../api/system/statement";
import {parseTime} from "../../../utils/ruoyi";

export default {
  name: "companysummary",
  dicts: ['order_target_type'],
  mixins: [mixin_printHTML],
  data() {
    return {
      // 遮罩层
      loading: true,
      total: 0,
      tableData: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 50,
        beginTime: '',
        endTime: parseTime(new Date(), '{y}-{m}-{d}'),
      },
      // 表单校验
      columns: [
        {key: 0, label: '序号', visible: true},
        {key: 1, label: '客户名称', visible: true},
        {key: 2, label: '上日欠款结转', visible: true},
        {key: 3, label: '本日发货金额', visible: true},
        {key: 4, label: '本日票点金额', visible: true},
        {key: 5, label: '本日回款金额', visible: true},
        {key: 6, label: '本日欠款金额', visible: true},
        {key: 7, label: '本日客户利润', visible: true},
        {key: 8, label: '上月欠款金额结转', visible: true},
        {key: 9, label: '本月发货金额合计', visible: true},
        {key: 10, label: '本月购入票点', visible: true},
        {key: 11, label: '本月回款金额', visible: true},
        {key: 12, label: '本月欠款', visible: true},
        {key: 13, label: '本月客户利润', visible: true},
        {key: 14, label: '上年结转', visible: true},
        {key: 15, label: '本年发货金额', visible: true},
        {key: 16, label: '本年票点', visible: true},
        {key: 17, label: '本年回款金额', visible: true},
        {key: 18, label: '本年利润', visible: true},
        {key: 19, label: '欠款', visible: true},
      ],
      dialogVisible: false
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询向外部借出款信息列表 */
    getList() {
      this.loading = true;
      getCompanySummary(this.queryParams).then(response => {
        console.log(response)
        this.tableData = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    handleCheckCarNoFreight(row) {
      console.log(row)
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    refresh() {
      this.getList()
    },
    handleSubmitTime() {
      this.download('statistics/export/companysummary', {
        ...this.queryParams
      }, `客户报表_${parseTime(new Date().getTime())}.xlsx`)
      this.dialogVisible = false
    },
    /** 导出按钮操作 */
    handleExport() {
      this.dialogVisible = true;
    }
  }
};
</script>
