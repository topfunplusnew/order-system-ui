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
      <el-form-item label="车牌号" prop="carNo">
        <el-input
          v-model="queryParams.carNo"
          placeholder="请输入车牌号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>
    <hr color="#e6e6e6"/>
    <el-row style="font-weight: bold;font-size: 20px;margin: 0 30px">
      运费科目汇总账
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

    <el-table border v-loading="loading" :data="lendMoneyList"
              v-horizontal-scroll="'always'" id="printBox" size="mini" :cell-style="()=>{return {padding:'2px'}}">
      <el-table-column label="序号" align="center" prop="index" v-if="columns[0].visible" width="160"/>
      <el-table-column label="初期方向" align="center" prop="" v-if="columns[1].visible" width="160"/>
      <el-table-column label="初期余额" align="center" prop="" v-if="columns[2].visible" width="160"/>
      <el-table-column label="车牌号" align="center" prop="CarNo" v-if="columns[3].visible"
                       width="110">
      </el-table-column>
      <el-table-column label="应付运费" align="center" prop="willPaid"
                       v-if="columns[4].visible" width="110"/>
      <el-table-column label="已付运费" align="center" prop="paid" v-if="columns[5].visible" width="110"/>
      <el-table-column label="司机姓名" align="center" prop="driverName" v-if="columns[6].visible" width="110"/>
      <el-table-column label="期末方向（贷方表示欠司机运费）" align="center" prop="" v-if="columns[7].visible"
                       width="160"/>
      <el-table-column label="期末方向" align="center" prop="" v-if="columns[8].visible" width="160"/>
      <el-table-column label="期末余额" align="center" prop="" v-if="columns[9].visible" width="160"/>
      <el-table-column label="操作" align="center" prop="driverName" width="150">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="success"
            @click="handleCheckCarNoFreight(scope.row)"
          >查询该车牌详情
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
    <el-dialog
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
import {listLendMoney, getLendMoney, delLendMoney, addLendMoney, updateLendMoney} from "@/api/system/lendMoney";
import {mapGetters} from "vuex";
import {addRecoverMoney, getRecoverMoneyByUuid} from "@/api/system/recoverMoney";
import {addReceiveMoney} from "@/api/system/receiveMoney";
import SearchOption from "@/components/SearchOption.vue";
import {listBankAccount} from "@/api/system/bankAccount";
import {listCompany} from "@/api/system/company";
import ApplyPayment from "@/components/ApplyPayment.vue";
import {TableName} from "@/api/tool/enums";
import {excludeParams} from "@/api/tool/exclude";
import {getLendMoneySummary, getLendMoneySummary2} from "@/api/system/statement";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {getOrderFreightDetailSummary} from "../../../api/system/statement";
import {parseTime} from "../../../utils/ruoyi";

export default {
  name: "LendMoney",
  dicts: ['order_target_type'],
  mixins: [mixin_printHTML],
  data() {
    return {
      // 遮罩层
      loading: true,
      total: 0,
      lendMoneyList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 50,
        beginTime: '',
        endTime: parseTime(new Date()),
        carNo: '',
        isSea: false
      },
      // 表单校验
      columns: [
        {key: 0, label: `序号`, visible: true},
        {key: 1, label: `初期方向`, visible: true},
        {key: 2, label: `初期余额`, visible: true},
        {key: 3, label: `车牌号`, visible: true},
        {key: 4, label: `应付运费`, visible: true},
        {key: 5, label: `已付运费`, visible: true},
        {key: 6, label: `司机姓名`, visible: true},
        {key: 7, label: `期末方向(贷方表示欠司机运费)`, visible: true},
        {key: 8, label: `期末方向`, visible: true},
        {key: 9, label: `期末余额`, visible: true},
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
      getOrderFreightDetailSummary(this.queryParams).then(response => {
        this.lendMoneyList = response.rows;
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
      this.download('statistics/export/orderfreightDetailsummary', {
        ...this.queryParams
      }, `orderfreightDetailsummary${new Date().getTime()}.xlsx`)
      this.dialogVisible = false
    },
    /** 导出按钮操作 */
    handleExport() {
      this.dialogVisible = true;
    }
  }
};
</script>
