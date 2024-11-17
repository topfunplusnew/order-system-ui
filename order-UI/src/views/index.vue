<template>
  <div>
    <el-row style="margin: 35px 0">
      <el-col :xs="24" :sm="12" :md="11" :lg="11" :offset="xs ? 0 : 1">
        <el-row>
          <el-col :span="6">
            <span style="font-weight: bold; font-size: 24px; color: #156fb2">
              今日发货列表
            </span>
          </el-col>
          <el-col :span="6">
            <el-date-picker
              v-model="queryParams.beginTime"
              type="datetime"
              size="mini"
              value-format="yyyy-MM-dd HH:mm:ss"
              placeholder="开始日期"
            ></el-date-picker>
          </el-col>
          <el-col :span="6">
            <el-date-picker
              v-model="queryParams.endTime"
              type="datetime"
              size="mini"
              value-format="yyyy-MM-dd HH:mm:ss"
              placeholder="结束日期"
            ></el-date-picker>
          </el-col>
          <el-col :span="2">
            <el-button type="primary" size="mini" @click="handleSearch">搜索</el-button>
          </el-col>
        </el-row>
      </el-col>
      <el-col :xs="24" :sm="12" :md="12" :lg="12">
        <el-row>
          <el-col :span="6">
            <span style="font-weight: bold; font-size: 24px; color: #156fb2">
              利润
            </span>
          </el-col>
          <el-col :span="6">
            <el-date-picker
              v-model="queryParams.beginTime"
              type="datetime"
              size="mini"
              value-format="yyyy-MM-dd HH:mm:ss"
              placeholder="开始日期"
            ></el-date-picker>
          </el-col>
          <el-col :span="6">
            <el-date-picker
              v-model="queryParams.endTime"
              type="datetime"
              size="mini"
              value-format="yyyy-MM-dd HH:mm:ss"
              placeholder="结束日期"
            ></el-date-picker>
          </el-col>
          <el-col :span="2">
            <el-button type="primary" size="mini">搜索</el-button>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-row :gutter="50">
      <el-col :xs="24" :sm="12" :md="11" :lg="11" :offset="xs ? 0 : 1">
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
          <!--        导出-->
          <template v-slot:export>
            <el-col :span="1.5">
              <el-button
                plain
                icon="el-icon-folder-opened"
                size="mini"
                @click="handleExport"
                v-hasPermi="['system:bankaccount:export']"
              >
              </el-button>
            </el-col>
          </template>
        </right-toolbar>
        <!--        发货列表-->
        <el-table
          id="printBox"
          size="mini"
          :data="tableData"
          max-height="500"
          show-summary
          border
          style="width: 100%"
          :loading="loading"
          :header-cell-style="{ background: '#f0f0f0', color: '#333' }"
          :cell-style="()=>{return {padding:'2px'}}"
        >
          <el-table-column
            prop="orderDate"
            label="日期"
            show-overflow-tooltip
            v-if="columns[0].visible"
          ></el-table-column>
          <el-table-column
            prop="companyName"
            label="客户"
            show-overflow-tooltip
            v-if="columns[1].visible"
          ></el-table-column>
          <el-table-column
            prop="salesman"
            label="业务员"
            show-overflow-tooltip
            v-if="columns[2].visible"
          ></el-table-column>
          <el-table-column
            prop="profit"
            label="含税利润"
            show-overflow-tooltip
            v-if="columns[3].visible"
          ></el-table-column>
          <el-table-column
            prop="profitNoTax"
            label="不含税利润"
            width="110"
            show-overflow-tooltip
            v-if="columns[4].visible"
          ></el-table-column>
          <el-table-column
            prop="payments"
            label="总货款"
            show-overflow-tooltip
            v-if="columns[5].visible"
          ></el-table-column>
          <el-table-column
            prop="paymentFactory"
            label="出厂货款"
            show-overflow-tooltip
            v-if="columns[6].visible"
          ></el-table-column>
          <el-table-column
            prop="tonnage"
            label="吨位"
            show-overflow-tooltip
            v-if="columns[7].visible"
          ></el-table-column>
          <el-table-column
            prop="clerk"
            label="内勤"
            show-overflow-tooltip
            v-if="columns[8].visible"
          ></el-table-column>
          <el-table-column
            prop="landCarNo"
            label="陆运车牌"
            show-overflow-tooltip
          >
            <template #default="scope">
              <span v-if="scope.row.landCarNo !== null">{{ scope.row.landCarNo }}</span>
              <span v-else>无</span>
            </template>
            <template v-if="columns[9].visible"></template>
          </el-table-column>
          <el-table-column
            prop="seaCarNo"
            label="柜号"
            show-overflow-tooltip
          >
            <template #default="scope">
              <span v-if="scope.row.seaCarNo !== null">{{ scope.row.seaCarNo }}</span>
              <span v-else>无</span>
            </template>
            <template v-if="columns[10].visible"></template>
          </el-table-column>
          <el-table-column
            prop="fleet"
            label="车队"
            show-overflow-tooltip
            v-if="columns[11].visible"
          ></el-table-column>
          <el-table-column
            prop="freight"
            label="运费"
            show-overflow-tooltip
            v-if="columns[12].visible"
          ></el-table-column>
        </el-table>
        <pagination
          v-show="total>0"
          :total="total"
          :page.sync="queryParams.pageNum"
          :limit.sync="queryParams.pageSize"
          @pagination="getList"
        />
        <!--        分页-->
      </el-col>

      <!--      右侧利润-->
      <el-col :xs="24" :sm="12" :md="12" :lg="12">
        <el-table
          height="130"
          :empty-text="' '"
        >
          <el-table-column
            prop="date"
            label="￥0"
            align="center"
          >
            <el-table-column
              prop="date"
              label="利润总额"
            >
              <el-table-column
                prop="date"
                label="费用合计"
              ></el-table-column>
            </el-table-column>
            <el-table-column
              label="￥0"
            >
              <el-table-column
                label="￥0"
              ></el-table-column>
            </el-table-column>
          </el-table-column>
        </el-table>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import {mixin_printHTML} from "./dashboard/mixins/print";
import {getDeliveryList} from "../api/system/statement";
import {parseTime} from "@/utils/ruoyi";

export default {
  name: "Index",
  mixins: [mixin_printHTML],
  data() {
    return {
      loading: false,
      queryParams: {
        startTime: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
        endTime: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
        pageNum: 1,
        pageSize: 10
      },
      tableData: [],
      total: 0,
      columns: [
        {key: 0, label: `日期`, visible: true},
        {key: 1, label: `客户`, visible: true},
        {key: 2, label: `业务员`, visible: true},
        {key: 3, label: `含税利润`, visible: true},
        {key: 4, label: `不含税利润`, visible: true},
        {key: 5, label: `总货款`, visible: true},
        {key: 6, label: `出厂货款`, visible: true},
        {key: 7, label: `吨位`, visible: true},
        {key: 8, label: `内勤`, visible: true},
        {key: 9, label: `陆运车牌`, visible: true},
        {key: 10, label: `柜号`, visible: true},
        {key: 11, label: `车队`, visible: true},
        {key: 12, label: `运费`, visible: true}
      ]
    };

  },
  computed: {
    xs() {
      return this.$store.state.viewport === 'xs';
    }
  },
  created() {
    this.getList();
  },
  methods: {
    handleSearch() {
      this.getList();
    },
    getList() {
      this.loading = true
      getDeliveryList(this.queryParams).then(res => {
        this.tableData = res.rows;
        this.total = res.total;
        this.reset()
        this.loading = false
      })
    },
    reset() {
      this.queryParams = {
        startTime: '',
        endTime: '',
        pageNum: 1,
        pageSize: 10
      };
    },
    handleExport() {
      this.download('statistics/export/todayOrderList', {
        startTime: this.queryParams.beginTime,
        endTime: this.queryParams.endTime
      }, `todayOrderList${new Date().getTime()}.xlsx`)
    },
  }
};
</script>

<style scoped lang="scss">
@import "~element-ui/lib/theme-chalk/index.css";

.button-search {
  line-height: 60px;
}

.el-row {
  margin-bottom: 20px;
}

.el-col {
  border-radius: 4px;
}

.el-date-editor.el-input, .el-date-editor.el-input__inner {
  width: 120px;
}

.el-button--mini {
  padding: 6px 12px;
}

.el-table th {
  font-weight: bold;
}

.el-table td, .el-table th {
  padding: 8px;
}

.el-table .cell {
  font-size: 14px;
}

.el-table thead {
  font-weight: bold;
}

// Media Queries for responsiveness
@media (max-width: 768px) {
  .el-row {
    margin: 20px 0;
  }

  .el-col {
    margin-bottom: 10px;
  }

  .el-date-editor.el-input, .el-date-editor.el-input__inner {
    width: 100%;
  }

  .el-button--mini {
    width: 100%;
    margin-top: 10px;
  }

  .el-table {
    overflow-x: auto;
  }
}
</style>
