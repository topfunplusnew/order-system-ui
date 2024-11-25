<!--订单列表+调整单列表 总货款是否含税 含税的商品金额 客户开始时间 结束时间 &ndash;&gt;客户收付款信息表(新页面)-->

<template>
  <div class="app-container">
    <el-row style="background-color: #e6e6e6">
      <el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
    </el-row>
    <hr color="#e6e6e6" />
    <el-form ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
      <el-form-item label="开始时间" prop="beginTime">
        <el-date-picker
          v-model="queryParams.beginTime"
          type="datetime"
          placeholder="请选择开始时间"
          value-format="yyyy-MM-dd HH:mm:ss"
          clearable
        />
      </el-form-item>
      <el-form-item label="结束时间" prop="endTime">
        <el-date-picker
          v-model="queryParams.endTime"
          type="datetime"
          placeholder="请选择结束时间"
          value-format="yyyy-MM-dd HH:mm:ss"
          clearable
        />
      </el-form-item>
      <el-form-item label="客户名称" prop="companyName">
        <el-input v-model="queryParams.companyName" placeholder="请输入客户名称" clearable />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">
          搜索
        </el-button>
      </el-form-item>
    </el-form>
    <hr color="#e6e6e6" />
    <el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">客户科目余额汇总表</el-row>
    <el-row :gutter="10" class="mb8">
      <right-toolbar :columns="columns" @queryTable="getList">
        <template #print>
          <el-col :span="1.5">
            <el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
          </el-col>
        </template>
        <template #export>
          <el-col :span="1.5">
            <el-button
              v-hasPermi="['system:company:export']"
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport"
            />
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <!--    todo 更换table对应的prop-->
    <el-table
      id="printBox"
      v-loading="loading"
      v-horizontal-scroll="'always'"
      border
      :data="tableData"
      size="mini"
      :cell-style="
        () => {
          return { padding: '2px' }
        }
      "
    >
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
        label="客户编号"
        align="center"
        prop="companyId"
        width="140"
      />
      <el-table-column
        show-overflow-tooltip
        label="客户名称"
        align="center"
        prop="companyName"
        width="140"
      />
      <el-table-column
        show-overflow-tooltip
        label="期初方向"
        align="center"
        prop="beginningBalance"
        width="140"
      >
        <template slot-scope="scope">
          {{
            Number(scope.row.beginningBalance) !== 0
              ? Number(scope.row.beginningBalance) > 0
                ? '借方'
                : '贷方'
              : '平'
          }}
        </template>
      </el-table-column>
      <el-table-column
        show-overflow-tooltip
        label="期初余额"
        align="center"
        prop="beginningBalance"
        width="140"
      />
      <el-table-column
        show-overflow-tooltip
        label="借方(客户提货)"
        align="center"
        prop="positiveSum"
        width="140"
      />
      <el-table-column
        show-overflow-tooltip
        label="贷方(收客户款)"
        align="center"
        prop="negativeSum"
        width="140"
      >
        <template slot-scope="scope">
          {{ Math.abs(scope.row.negativeSum) }}
        </template>
      </el-table-column>
      <el-table-column
        show-overflow-tooltip
        label="平账金额"
        align="center"
        prop="balanceaccountsAmount"
        width="140"
      />
      <el-table-column
        show-overflow-tooltip
        label="期末方向"
        align="center"
        prop="endingBalance"
        width="140"
      >
        <template slot-scope="scope">
          {{
            Number(scope.row.endingBalance) !== 0
              ? Number(scope.row.endingBalance) > 0
                ? '借方'
                : '贷方'
              : '平'
          }}
        </template>
      </el-table-column>
      <el-table-column
        show-overflow-tooltip
        label="期末余额"
        align="center"
        prop="endingBalance"
        width="140"
      />
      <el-table-column
        show-overflow-tooltip
        label="业务经理"
        align="center"
        prop="dailyReceiveMoney"
        width="140"
      />
      <!--      操作列-->
      <el-table-column
        label="操作"
        align="center"
        class-name="small-padding fixed-width"
        fixed="right"
      >
        <template slot-scope="scope">
          <CustomerDetail :detail="scope.row" />
        </template>
      </el-table-column>
    </el-table>
    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
  </div>
</template>

<script>
  import { listConfig } from '@/api/system/config'
  import { getCustomerSubjectSummary } from '@/api/system/statement'
  import { getSubjectLevel } from '@/api/system/subject'
  import { getTimeOffset } from '@/utils/order'
  import { mixin_printHTML } from '@/views/dashboard/mixins/print'
  import CustomerDetail from '@/views/system/Statement/components/CustomerDetail.vue'
  import { parseTime } from '../../../utils/ruoyi'

  export default {
    name: 'CustomerSummary',
    components: { CustomerDetail },
    dicts: ['order_target_type'],
    mixins: [mixin_printHTML],
    data() {
      return {
        // 遮罩层
        loading: false,
        total: 0,
        tableData: [],
        // 弹出层标题
        title: '',
        // 是否显示弹出层
        open: false,
        // 查询参数
        queryParams: {
          pageNum: 1,
          pageSize: 50,
          // 日期往前推迟一年 工具函数
          beginTime: getTimeOffset('{y}-{m}-{d} {h}:{i}:{s}', 1),
          endTime: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
          companyName: null
        },
        // 表单校验
        columns: [],
        dialogVisible: false
      }
    },
    created() {
      this.getList()
    },
    methods: {
      /** 查询向外部借出款信息列表 */
      getList() {
        // 获取客户科目余额汇总表数据 填充到表格中
        this.loading = true
        // 获取参数设置中的编码 然后根据编码去换取科目名称 填充到tableData中
        // 根据config_key order.customerDetailSummary.subjectNo 拿到键值
        const key = { configKey: 'order.customerDetailSummary.subjectNo' }
        listConfig(key).then((res) => {
          const configValue = res.rows[0]?.configValue
          // 根据configValue去拿取科目名称
          getSubjectLevel(configValue).then((res) => {
            // 拿到科目名称
            const subjectName = res.data.title
            // 拿取客户科目余额汇总表数据 然后给tableData每一条数据赋值科目编码和名称
            getCustomerSubjectSummary(this.queryParams).then((response) => {
              // 组装tableData
              this.tableData = response?.rows.map((item) => {
                return {
                  ...item,
                  subjectNo: configValue,
                  subjectName: subjectName
                }
              })
              this.total = response.total
              this.loading = false
            })
          })
        })
      },
      /** 搜索按钮操作 */
      handleQuery() {
        this.queryParams.pageNum = 1
        this.getList()
      },
      refresh() {
        this.getList()
      },
      handleSubmitTime() {
        this.download(
          'statistics/export/companysummary',
          {
            ...this.queryParams
          },
          `客户科目余额汇总表_${parseTime(new Date().getTime())}.xlsx`
        )
      },
      // 导出
      handleExport() {
        this.$datePicker().then((res) => {
          // todo 2. 导出
          console.log(res)
        })
      }
    }
  }
</script>
