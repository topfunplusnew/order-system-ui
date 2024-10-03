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
      贷款管理台账
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
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="lendMoneyList"
              v-horizontal-scroll="'always'" id="printBox" size="mini" :cell-style="()=>{return {padding:'2px'}}">
      <el-table-column label="id" align="center" prop="id" v-if="columns[0].visible"/>
      <el-table-column label="贷款来源" align="center" prop="origin" v-if="columns[1].visible"/>
      <el-table-column label="借入金额" align="center" prop="moneyAmount" v-if="columns[2].visible"/>
      <el-table-column label="贷款利率" align="center" prop="ratio" v-if="columns[3].visible"/>
      <el-table-column label="贷款发放日期" align="center" prop="loanDate" v-if="columns[4].visible"/>
      <el-table-column label="贷款年限" align="center" prop="loanDuring" v-if="columns[5].visible"/>
      <el-table-column label="抵押担保" align="center" prop="mortgageGuarantee" v-if="columns[6].visible"/>
      <el-table-column label="打入账户" align="center" prop="acountsName" v-if="columns[7].visible"/>
      <el-table-column label="打入账号" align="center" prop="bankNo" v-if="columns[8].visible"/>
      <el-table-column label="备注" align="center" prop="comments"/>
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
          <span v-if="scope.$index === 0">贷款还款</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="payDate"
        label="时间"
        width="180">
      </el-table-column>
      <el-table-column
        prop="moneyAmount"
        label="还款金额"
        width="180">
      </el-table-column>
    </el-table>

    <el-dialog :close-on-click-modal="false" :show-close="false"
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
import SearchOption from "@/components/SearchOption.vue";
import ApplyPayment from "@/components/ApplyPayment.vue";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {getBorrowedMoneySummary} from "../../../api/system/statement";
import {getRepaymentMoneyNoPage} from "../../../api/system/repayment";
import {parseTime} from "../../../utils/ruoyi";

export default {
  name: "borrowedMoneySummary",
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
        {key: 0, label: `id`, visible: true},
        {key: 1, label: `贷款来源`, visible: true},
        {key: 2, label: `借入金额`, visible: true},
        {key: 3, label: `贷款利率`, visible: true},
        {key: 4, label: `贷款发放日期`, visible: true},
        {key: 5, label: `贷款年限`, visible: true},
        {key: 6, label: `抵押担保`, visible: true},
        {key: 7, label: `打入账户`, visible: true},
        {key: 8, label: `打入账号`, visible: true},
        {key: 9, label: `已还款标记`, visible: true},
      ],
      //搜索参数
      timesQuery: {
        beginTime: '',
        endTime: '',
        objectType: ''
      },

      // 详细的还款记录
      tableData: [],
      dialogVisible: false
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
      getRepaymentMoneyNoPage({loanNO: row.loanNO})
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
      getBorrowedMoneySummary(this.queryParams).then(response => {
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
    handleSubmitTime() {
      this.download('statistics/export/borrowedMoney', {
        ...this.queryParams
      }, `贷款_${parseTime(new Date().getTime())}.xlsx`)
      this.dialogVisible = false
    },
    /** 导出按钮操作 */
    handleExport() {
      this.dialogVisible = true;

    }
  }
};
</script>
