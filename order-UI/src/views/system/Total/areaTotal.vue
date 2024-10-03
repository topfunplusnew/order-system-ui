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
      区域统计
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

    <el-table border v-loading="loading" :data="totalList"
              v-horizontal-scroll="'always'" id="printBox" size="mini" :cell-style="()=>{return {padding:'2px'}}">
      <el-table-column label="日期" align="center" prop="time" v-if="columns[0].visible" show-overflow-tooltip/>
      <el-table-column label="区域" align="center" prop="region" v-if="columns[1].visible" show-overflow-tooltip/>
      <el-table-column label="发货车数" align="center" prop="uniqueOrderCount" v-if="columns[3].visible"
                       show-overflow-tooltip>
      </el-table-column>
      <el-table-column label="不含税利润" align="center" prop="totalProfit" v-if="columns[2].visible"
                       show-overflow-tooltip/>
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
        width="350px">
      <el-row>
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
      </el-row>
      <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="handleSubmitTime">导 出</el-button>
  </span>
    </el-dialog>
  </div>
</template>

<script>
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {parseTime} from "../../../utils/ruoyi";
import {getRegionalSummary} from "../../../api/system/total";

export default {
  name: "areaTotal",
  mixins: [mixin_printHTML],
  data() {
    return {
      // 遮罩层
      loading: true,
      total: 0,
      totalList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 50,
        beginTime: parseTime(this.getlastYearDate(), '{y}-{m}-{d}'),
        endTime: parseTime(new Date(), '{y}-{m}-{d}'),
      },
      // 表单校验
      columns: [
        {key: 0, label: "日期", visible: true},
        {key: 1, label: "区域", visible: true},
        {key: 2, label: "发货车数", visible: true},
        {key: 3, label: "不含税利润", visible: true},
      ],
      dialogVisible: false
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getlastYearDate() {
      const currentDate = new Date();
      const lastYearDate = new Date(currentDate);
      lastYearDate.setFullYear(currentDate.getFullYear() - 1);
      return lastYearDate;
    },
    /** 查询向外部借出款信息列表 */
    getList() {
      this.loading = true;
      getRegionalSummary(this.queryParams).then(response => {
        this.totalList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
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
      this.download('statistics/export/regionSummary', {
        startTime: this.queryParams.beginTime,
        endTime: this.queryParams.endTime
      }, `区域统计${new Date().getTime()}.xlsx`)
      this.dialogVisible = false


    },
    /** 导出按钮操作 */
    handleExport() {
      this.dialogVisible = true;
    }
  }
};
</script>
