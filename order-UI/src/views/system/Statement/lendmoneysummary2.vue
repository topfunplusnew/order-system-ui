<!--向外借钱-->
<template>
  <div class="app-container">
    <el-row style="background-color:#e6e6e6;">
      <el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
    </el-row>
    <hr color="#e6e6e6"/>
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
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
      期货保证金台账
    </el-row>
    <el-row :gutter="10" class="mb8">
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" :columns="columns">
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
        <!--        <template v-slot:export>-->
        <!--          <el-col :span="1.5">-->
        <!--            <el-button-->
        <!--              plain-->
        <!--              icon="el-icon-folder-opened"-->
        <!--              size="mini"-->
        <!--              @click="handleExport"-->
        <!--              v-hasPermi="['system:company:export']"-->
        <!--            >-->
        <!--            </el-button>-->
        <!--          </el-col>-->
        <!--        </template>-->
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="lendMoneyList"
              v-horizontal-scroll="'always'" id="printBox" size="mini" :cell-style="()=>{return {padding:'2px'}}">
      <el-table-column label="期货保证金公司" align="center" prop="futuresMarginCompany" v-if="columns[0].visible"
                       width="130">
        <template slot-scope="scope">
          <span v-if="scope.row.futuresMarginCompany !== ''&& scope.row.futuresMarginCompany !== null">{{
              scope.row.futuresMarginCompany
            }}</span>
          <span v-else>
            无期货保证金公司
          </span>
        </template>
      </el-table-column>
      <el-table-column label="对象类型" align="center" prop="targetType"
                       v-if="columns[1].visible" width="110"/>
      <el-table-column label="对象" align="center" prop="target" v-if="columns[2].visible" width="110"/>
      <el-table-column label="保证金金额" align="center" prop="moneyAmount" v-if="columns[3].visible" width="110"/>
      <el-table-column label="对方账户" align="center" prop="targetAcountsName" v-if="columns[4].visible" width="160">
      </el-table-column>
      <el-table-column label="对方账号" align="center" prop="targetBankNo" v-if="columns[5].visible" width="160"/>
      <el-table-column label="对方开户行" align="center" prop="targetBankName" v-if="columns[6].visible" width="160"/>
      <el-table-column label="我方支付账户" align="center" prop="selfAcountsName" v-if="columns[7].visible"
                       width="160"/>
      <el-table-column label="我方账号" align="center" prop="selfBankNo" v-if="columns[8].visible" width="160"/>
      <el-table-column label="我方开户行" align="center" prop="selfBankName" v-if="columns[9].visible" width="160"/>
      <el-table-column label="支付期货保证金时间" align="center" prop="futuresDate" v-if="columns[10].visible"
                       width="160"/>
      <el-table-column label="事由" align="center" prop="reason" v-if="columns[11].visible" width="160"/>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[12].visible" width="160"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="120" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="warning"
            @click="checkDetail(scope.row)">
            查看历史还款
          </el-button>
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

    <el-table
      v-if="tableData.length!==0"
      :data="tableData"
      size="mini"
      :cell-style="()=>{return {padding:'2px'}}"
      border
      style="width: 40%" :span-method="mergeCells">
      <el-table-column
        prop=""
        width="180">
        <template v-slot="scope">
          <span v-if="scope.$index === 0">期货保证金收回</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="recoverDate"
        label="时间"
        width="180">
      </el-table-column>
      <el-table-column
        prop="moneyAmount"
        label="收回金额"
        width="180">
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import SearchOption from "@/components/SearchOption.vue";
import ApplyPayment from "@/components/ApplyPayment.vue";
import {getLendMoneySummary2} from "@/api/system/statement";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {getRecoverMoneyNoPage, listRecoverMoney} from "../../../api/system/recoverMoney";
import {getRepaymentMoneyNoPage} from "../../../api/system/repayment";

export default {
  name: "LendMoney",
  components: {ApplyPayment, SearchOption},
  dicts: ['order_target_type'],
  mixins: [mixin_printHTML],
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 向外部借出款信息表格数据
      lendMoneyList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 50,
        futuresNO: null,
        futuresMarginCompany: null,
        targetType: null,
        target: null,
        moneyAmount: null,
        targetAcountsName: null,
        targetBankNo: null,
        targetBankName: null,
        selfAcountsName: null,
        selfBankNo: null,
        selfBankName: null,
        futuresDate: null,
        reason: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单校验
      columns: [
        {key: 0, label: `期货保证金公司`, visible: true},
        {key: 1, label: `对象类型`, visible: true},
        {key: 2, label: `对象`, visible: true},
        {key: 3, label: `保证金金额`, visible: true},
        {key: 4, label: `对方账户`, visible: true},
        {key: 5, label: `对方账号`, visible: true},
        {key: 6, label: `对方开户行`, visible: true},
        {key: 7, label: `我方支付账户`, visible: true},
        {key: 8, label: `我方账号`, visible: true},
        {key: 9, label: `我方开户行`, visible: true},
        {key: 10, label: `支付期货保证金时间`, visible: true},
        {key: 11, label: `事由`, visible: true},
        {key: 12, label: `备注`, visible: true},
      ],

      //搜索参数
      timesQuery: {
        beginTime: '',
        endTime: '',
        objectType: ''
      },

      // 详细的还款记录
      tableData: []
    };
  },
  created() {
    this.getList();
  },
  methods: {
    // 查看历史还款信息
    checkDetail(row) {
      console.log(row)
      // 查询
      listRecoverMoney({futuresNO: row.futuresNO})
        .then(res => {
          this.tableData = res.rows;
          if (res.rows.length === 0) {
            this.$message.error('暂无数据')
          } else {
            this.$message.success('查询成功')
          }
        })
    },
    mergeCells({row, column, rowIndex, columnIndex}) {
      if (columnIndex === 0) {
        // 合并第一列 "期货保证金收回"
        if (rowIndex === 0) {
          return {
            rowspan: this.tableData.length,
            colspan: 1
          };
        } else {
          return {
            rowspan: 0,
            colspan: 0
          };
        }
      }
    },
    /** 查询向外部借出款信息列表 */
    getList() {
      this.loading = true;
      getLendMoneySummary2(this.queryParams).then(response => {
        this.lendMoneyList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    }
    ,
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    }
    ,
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    }
    ,
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    }
    ,
    refresh() {
      this.getList()
    }
    ,
    /** 导出按钮操作 */
    handleExport() {
      alert('功能未开发')
      // this.download('system/lendMoney/export', {
      //   ...this.queryParams
      // }, `lendMoney_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
