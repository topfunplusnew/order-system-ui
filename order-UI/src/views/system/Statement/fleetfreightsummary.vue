<script>
  import { getFleetFreightSummary } from '../../../api/system/statement'
  import { parseTime } from '../../../utils/ruoyi'
  import { mixin_printHTML } from '../../dashboard/mixins/print'

  export default {
    name: 'Fleetfreightsummary',
    mixins: [mixin_printHTML],
    data() {
      return {
        queryParams: {
          beginTime: parseTime(
            new Date(new Date().getTime() - 30 * 24 * 60 * 60 * 1000),
            '{y}-{m}-{d} {h}:{i}:{s}'
          ),
          endTime: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
          pageNum: 1,
          pageSize: 50
        },
        loading: '',
        // 筛选栏目
        columns: [
          { key: 0, label: `车队`, visible: true },
          { key: 1, label: `上日欠运费`, visible: true },
          { key: 2, label: `当日应付运费`, visible: true },
          { key: 3, label: `本日付款金额`, visible: true },
          { key: 4, label: `本日欠款余额`, visible: true },
          { key: 5, label: `上月结转欠款全额`, visible: true },
          { key: 6, label: `本月付款金额合计`, visible: true },
          { key: 7, label: `本月累计应付运费`, visible: true },
          { key: 8, label: `本月欠款金额`, visible: true },
          { key: 9, label: `上年结转欠款金额`, visible: true },
          { key: 10, label: `本年付款金额合计`, visible: true },
          { key: 11, label: `本年累计应付运费`, visible: true },
          { key: 12, label: `本年欠款金额`, visible: true }
        ],
        total: 0,
        statementList: [],
        dialogVisible: false
      }
    },
    created() {
      this.getList()
    },
    methods: {
      getList() {
        this.loading = true
        getFleetFreightSummary(this.queryParams).then((res) => {
          this.statementList = res.rows
          this.total = res.total
          this.loading = false
        })
      },
      // 时间查询
      handleQuery() {
        this.getList()
      },
      refresh() {
        this.reset()
        this.handleQuery()
      },
      reset() {
        this.queryParams.beginTime = parseTime(
          new Date(new Date().getTime() - 30 * 24 * 60 * 60 * 1000),
          '{y}-{m}-{d} {h}:{i}:{s}'
        )
        this.queryParams.endTime = parseTime(
          new Date(),
          '{y}-{m}-{d} {h}:{i}:{s}'
        )
        this.queryParams.pageNum = 1
        this.queryParams.pageSize = 50
        this.handleQuery()
      },
      handleSubmitTime() {
        this.download(
          'statistics/export/FleetFreightSummary',
          {
            beginTime: this.queryParams.beginTime,
            endTime: this.queryParams.endTime
          },
          `车队运费报表${parseTime(new Date().getTime())}.xlsx`
        )
        this.dialogVisible = false
      },
      handleExport() {
        this.dialogVisible = true
      }
    }
  }
</script>

<template>
  <div>
    <div class="app-container">
      <!--    刷新行-->
      <el-row style="background-color: #e6e6e6">
        <el-button type="primary" icon="el-icon-refresh" @click="refresh">
          刷新
        </el-button>
      </el-row>
      <hr color="#e6e6e6" />
      <!--    时间范围搜索行-->
      <el-row>
        <el-form
          ref="queryForm"
          :model="queryParams"
          size="mini"
          :inline="true"
          label-width="100px"
        >
          <el-form-item label="时间" prop="companyName">
            <el-date-picker
              v-model="queryParams.beginTime"
              type="datetime"
              size="mini"
              value-format="yyyy-MM-dd HH:mm:ss"
              placeholder="选择日期"
            ></el-date-picker>
          </el-form-item>
          <el-form-item>
            <el-date-picker
              v-model="queryParams.endTime"
              type="datetime"
              size="mini"
              value-format="yyyy-MM-dd HH:mm:ss"
              placeholder="选择日期"
            ></el-date-picker>
          </el-form-item>
          <el-form-item>
            <el-button
              type="primary"
              icon="el-icon-search"
              size="mini"
              @click="handleQuery"
            >
              搜索
            </el-button>
          </el-form-item>
        </el-form>
      </el-row>
      <hr color="#e6e6e6" />
      <el-row>
        <el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">
          车队运费报表
        </el-row>
        <el-row>
          <right-toolbar :columns="columns">
            <template #print>
              <el-col :span="1.5">
                <el-button
                  plain
                  icon="el-icon-printer"
                  size="mini"
                  @click="printHTML"
                ></el-button>
              </el-col>
            </template>
            <template #export>
              <el-col :span="1.5">
                <el-button
                  v-hasPermi="['system:supplier:export']"
                  plain
                  icon="el-icon-folder-opened"
                  size="mini"
                  @click="handleExport"
                ></el-button>
              </el-col>
            </template>
          </right-toolbar>

          <!--          报表主体-->
          <el-table
            id="printBox"
            v-loading="loading"
            v-horizontal-scroll="'always'"
            border
            :data="statementList"
            height="450px"
            size="mini"
            :cell-style="
              () => {
                return { padding: '2px' }
              }
            "
          >
            <!-- 司机信息 -->
            <el-table-column
              v-if="columns[0].visible"
              label="司机信息"
              align="center"
            >
              <el-table-column
                label="车队"
                align="center"
                prop="fleet"
                width="200"
              />
            </el-table-column>

            <!-- 运费日报 -->
            <el-table-column label="运费日报" align="center">
              <el-table-column
                v-if="columns[1].visible"
                label="上日欠运费"
                align="center"
                prop="previousDebtAmountToday"
                width="200"
              />
              <el-table-column
                v-if="columns[2].visible"
                label="当日应付运费"
                align="center"
                prop="unpaidAmountToday"
                width="200"
              />
              <el-table-column
                v-if="columns[3].visible"
                label="本日付款金额"
                align="center"
                prop="paidAmountToday"
                width="200"
              />
              <el-table-column
                v-if="columns[4].visible"
                label="本日欠款余额"
                align="center"
                prop="debtAmountToday"
                width="200"
              />
            </el-table-column>

            <!-- 运费月报 -->
            <el-table-column label="运费月报" align="center">
              <el-table-column
                v-if="columns[5].visible"
                label="上月结转欠款全额"
                align="center"
                prop="previousDebtAmountThisMonth"
                width="200"
              />
              <el-table-column
                v-if="columns[6].visible"
                label="本月付款金额合计"
                align="center"
                prop="paidAmountThisMonth"
                width="200"
              />
              <el-table-column
                v-if="columns[7].visible"
                label="本月累计应付运费"
                align="center"
                prop="unpaidAmountThisMonth"
                width="200"
              />
              <el-table-column
                v-if="columns[8].visible"
                label="本月欠款金额"
                align="center"
                prop="debtAmountThisMonth"
                width="200"
              />
            </el-table-column>

            <!-- 运费年报 -->
            <el-table-column label="运费年报" align="center">
              <el-table-column
                v-if="columns[9].visible"
                label="上年结转欠款金额"
                align="center"
                prop="previousDebtAmountThisYear"
                width="200"
              />
              <el-table-column
                v-if="columns[10].visible"
                label="本年付款金额合计"
                align="center"
                prop="paidAmountThisYear"
                width="200"
              />
              <el-table-column
                v-if="columns[11].visible"
                label="本年累计应付运费"
                align="center"
                prop="unpaidAmountThisYear"
                width="200"
              />
              <el-table-column
                v-if="columns[12].visible"
                label="本年欠款金额"
                align="center"
                prop="debtAmountThisYear"
                width="200"
              />
            </el-table-column>
          </el-table>

          <!--          分页-->
          <pagination
            v-show="total > 0"
            :total="total"
            :page.sync="queryParams.pageNum"
            :limit.sync="queryParams.pageSize"
            @pagination="getList"
          />
        </el-row>
      </el-row>
    </div>
    <el-dialog
      :close-on-click-modal="false"
      :show-close="false"
      title="请选择导出时间段"
      :visible.sync="dialogVisible"
      width="30%"
    >
      <el-form
        ref="queryForm"
        :model="queryParams"
        size="mini"
        label-width="68px"
      >
        <el-form-item label="开始时间" prop="beginTime">
          <el-date-picker
            v-model="queryParams.beginTime"
            type="datetime"
            placeholder="选择时间"
            value-format="yyyy-MM-dd HH:mm:ss"
            size="mini"
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
          <el-date-picker
            v-model="queryParams.endTime"
            type="datetime"
            placeholder="选择时间"
            value-format="yyyy-MM-dd HH:mm:ss"
            size="mini"
          ></el-date-picker>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="handleSubmitTime">导 出</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss"></style>
