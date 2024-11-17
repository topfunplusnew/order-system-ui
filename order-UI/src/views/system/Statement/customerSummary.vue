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
          type="datetime"
          placeholder="请选择开始时间"
          value-format="yyyy-MM-dd HH:mm:ss">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="结束时间" prop="endTime">
        <el-date-picker
          v-model="queryParams.endTime"
          type="datetime"
          placeholder="请选择结束时间" value-format="yyyy-MM-dd HH:mm:ss">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="客户名称" prop="customer">
        <el-input v-model="queryParams.customer" placeholder="请输入客户名称"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>
    <hr color="#e6e6e6"/>
    <el-row style="font-weight: bold;font-size: 20px;margin: 0 30px">
      客户科目余额汇总表
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
      <el-table-column show-overflow-tooltip label="科目编码" align="center" prop="index"
                       width="140"/>
      <el-table-column show-overflow-tooltip label="科目名称" align="center" prop="companyName"
                       width="140"/>
      <el-table-column show-overflow-tooltip label="客户编号" align="center" prop="previousDayCarryover"
                       width="140"/>
      <el-table-column show-overflow-tooltip label="客户名称" align="center" prop="dailyOrderPayments"
                       width="140"/>
      <el-table-column show-overflow-tooltip label="期初方向" align="center" prop="dailyInvoiceAmount"
                       width="140"/>
      <el-table-column show-overflow-tooltip label="期初余额" align="center" prop="dailyReceiveMoney"
                       width="140"/>
      <el-table-column show-overflow-tooltip label="借方(客户提货)" align="center" prop="dailyReceiveMoney"
                       width="140"/>
      <el-table-column show-overflow-tooltip label="贷方(收客户款)" align="center" prop="dailyReceiveMoney"
                       width="140"/>
      <el-table-column show-overflow-tooltip label="平账余额" align="center" prop="dailyReceiveMoney"
                       width="140"/>
      <el-table-column show-overflow-tooltip label="期末方向" align="center" prop="dailyReceiveMoney"
                       width="140"/>
      <el-table-column show-overflow-tooltip label="期末余额" align="center" prop="dailyReceiveMoney"
                       width="140"/>
      <el-table-column show-overflow-tooltip label="业务经理" align="center" prop="dailyReceiveMoney"
                       width="140"/>
      <!--      操作列-->
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
        <template slot-scope="scope">
          <CustomerDetail :detail="scope.row"/>
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
  </div>
</template>

<script>
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {parseTime} from "../../../utils/ruoyi";
import CustomerDetail from "@/views/system/Statement/components/CustomerDetail.vue";

export default {
  name: "customerSummary",
  components: {CustomerDetail},
  dicts: ['order_target_type'],
  mixins: [mixin_printHTML],
  data() {
    return {
      // 遮罩层
      loading: false,
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
        endTime: parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
      },
      // 表单校验
      columns: [],
      dialogVisible: false
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询向外部借出款信息列表 */
    getList() {
      // todo
      // this.loading = true;
      // getCustomerSubjectSummary(this.queryParams).then(response => {
      //   this.tableData = response.rows;
      //   this.total = response.total;
      //   this.loading = false;
      // });
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
      }, `客户科目余额汇总表_${parseTime(new Date().getTime())}.xlsx`)
    },
    // 导出
    handleExport() {
      this.$datePicker().then(res => {
        console.log(res)
      })
    }
  }
};
</script>
