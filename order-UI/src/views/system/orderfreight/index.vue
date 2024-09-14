<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="申请开始日期" prop="applyDate">
        <el-date-picker
          v-model="dateRange"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <!--      <el-col :span="1.5">-->
      <!--        <el-button-->
      <!--          type="primary"-->
      <!--          plain-->
      <!--          icon="el-icon-plus"-->
      <!--          size="mini"-->
      <!--          @click="handleAdd"-->
      <!--          v-hasPermi="['system:orderfreight:add']"-->
      <!--        >新增订单运费申请-->
      <!--        </el-button>-->
      <!--      </el-col>-->
      <!-- 刷新按钮-->
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
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
        <template v-slot:export>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport"
              v-hasPermi="['system:orderfreight:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table v-horizontal-scroll="'always'" border v-loading="loading" :data="orderFreightList"
              @selection-change="handleSelectionChange" id="printBox" max-height="600px">
      <el-table-column label="订单编号" align="center" prop="ordersNo" v-if="columns[0].visible"/>
      <el-table-column label="运费类型" align="center" prop="freightType" v-if="columns[1].visible"/>
      <el-table-column label="金额" align="center" prop="moneyAmount" v-if="columns[2].visible"/>
      <el-table-column label="己方户名" align="center" prop="selfAcountsName" v-if="columns[3].visible"/>
      <el-table-column label="己方账号" align="center" prop="selfBankNo" v-if="columns[4].visible"/>
      <el-table-column label="己方开户行" align="center" prop="selfBankName" v-if="columns[5].visible"/>
      <el-table-column label="对方户名" align="center" prop="otherAcountsName" v-if="columns[6].visible"/>
      <el-table-column label="对方账号" align="center" prop="otherBankNo" v-if="columns[7].visible"/>
      <el-table-column label="对方开户行" align="center" prop="otherBankName" v-if="columns[8].visible"/>
      <el-table-column label="备注" align="center" prop="content" v-if="columns[9].visible"/>
      <el-table-column label="支付状态" align="center" prop="paymentState" v-if="columns[10].visible">
        <template slot-scope="scope">
          <el-tag :type="scope.row.paymentState === '未支付' ? 'danger' : 'success'">
            {{ scope.row.paymentState }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="司机姓名" align="center" prop="driverName" v-if="columns[11].visible"/>
      <!--      <el-table-column label="司机ID" align="center" prop="driverId"/>-->
      <el-table-column label="车牌号" align="center" prop="CarNo" v-if="columns[12].visible"/>
      <el-table-column label="车队" align="center" prop="fleet" v-if="columns[13].visible"/>
      <!--      <el-table-column label="申请人员ID" align="center" prop="applyUserId"/>-->
      <el-table-column label="申请人员姓名" align="center" prop="applyUserName" v-if="columns[14].visible"/>
      <el-table-column label="申请日期" align="center" prop="applyDate" v-if="columns[15].visible"/>
      <el-table-column label="是否可编辑" align="center" prop="isedit" v-if="columns[16].visible">
        <template slot-scope="scope">
          <el-tag :type="scope.row.isedit === 0 ? 'danger' : 'success'" disable-transitions
                  v-if="scope.row.isedit === 0">不可编辑
          </el-tag>
          <el-tag :type="scope.row.isedit === 1 ? 'success' : 'danger'" disable-transitions
                  v-if="scope.row.isedit === 1">可编辑
          </el-tag>
        </template>
      </el-table-column>
      <!--      <el-table-column label="付款人员ID" align="center" prop="payUserId"/>-->
      <el-table-column label="付款人员姓名" align="center" prop="payUserName" v-if="columns[17].visible"/>
      <el-table-column label="付款日期" align="center" prop="payDate" v-if="columns[18].visible"/>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[19].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="250">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="warning"
            @click="applyForLand(scope.row)"
            v-if="scope.row.freightType=== '陆运'"
          >申请陆运费
          </el-button>
          <!--          只有海运费不为零才能申请海运费-->
          <el-button
            size="mini"
            type="primary"
            @click="applyForSea(scope.row)"
            v-if="scope.row.freightType=== '海运'"
          >申请海运费
          </el-button>
          <el-button
            size="mini"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:orderfreight:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:orderfreight:remove']"
          >删除
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
    <!--    created第一次传递的props，然后监听后来props的变化-->
    <el-dialog title="运费付款申请" :visible.sync="open" width="500px"
               append-to-body :before-close="beforeCloseApply">
      <ApplyPayment :tableName="TableName.ORDER_FREIGHT" :t-i-d="tID"
                    :need-info="{...applyInfo,isExit:true}" :need-money="freight"/>
    </el-dialog>
  </div>
</template>

<script>
import {
  listOrderFreight,
  getOrderFreight,
  delOrderFreight,
  addOrderFreight,
  updateOrderFreight
} from "@/api/system/orderFreight";
import SearchOption from "@/components/SearchOption.vue";
import {listBankAccount} from "@/api/system/bankAccount";
import ApplyPayment from "@/components/ApplyPayment.vue";
import {TableName} from "@/api/tool/enums";
import {addDateRange} from "@/utils/ruoyi";

export default {
  name: "OrderFreight",
  computed: {
    TableName() {
      return TableName
    }
  },
  components: {ApplyPayment, SearchOption},
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
      dateRange: [],
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 订单运费表格数据
      orderFreightList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        ordersNo: null,
        freightType: null,
        moneyAmount: null,
        selfAcountsName: null,
        selfBankNo: null,
        selfBankName: null,
        otherAcountsName: null,
        otherBankNo: null,
        otherBankName: null,
        content: null,
        paymentState: null,
        driverName: null,
        driverId: null,
        CarNo: null,
        fleet: null,
        applyUserId: null,
        applyUserName: null,
        applyDate: null,
        isedit: null,
        payUserId: null,
        payUserName: null,
        payDate: null,
        cancelFlag: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      columns: [
        {key: 0, label: `订单编号`, visible: true},
        {key: 1, label: `运费类型`, visible: true},
        {key: 2, label: `金额`, visible: true},
        {key: 3, label: `乙方户名`, visible: true},
        {key: 4, label: `乙方账号`, visible: true},
        {key: 5, label: `乙方开户行`, visible: true},
        {key: 6, label: `对方户名`, visible: true},
        {key: 7, label: `对方账号`, visible: true},
        {key: 8, label: `对方开户行`, visible: true},
        {key: 9, label: `备注`, visible: true},
        {key: 10, label: `支付状态`, visible: true},
        {key: 11, label: `司机姓名`, visible: true},
        {key: 12, label: `车牌号`, visible: true},
        {key: 13, label: `车队`, visible: true},
        {key: 14, label: `申请人姓名`, visible: true},
        {key: 15, label: `申请日期`, visible: true},
        {key: 16, label: `是否可编辑`, visible: true},
        {key: 17, label: `付款人姓名`, visible: true},
        {key: 18, label: `付款日期`, visible: true},
        {key: 19, label: `备注`, visible: true},
      ],


      tID: null,
      freight: null,
      applyInfo: null,
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('orderfreight-columns') === 'null'
      || !localStorage.getItem('orderfreight-columns')) {
      //设置localStorage
      localStorage.setItem("orderfreight-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('orderfreight-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("orderfreight-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  methods: {
    listBankAccount,
    //己方公司点击确定的回调
    handleCommitSelfBackBank(val) {
      this.form.selfAcountsName = val.acountsName;
      this.form.selfBankNo = val.bankNo;
      this.form.selfBankName = val.bankName
    },
    handleCommitOtherBackBank(val) {
      this.form.otherAcountsName = val.acountsName;
      this.form.otherBankNo = val.bankNo;
      this.form.otherBankName = val.bankName
    },
    //关闭之前的回调 关闭之前就给状态赋空 done()
    beforeCloseApply(done) {
      this.applyInfo = {};
      this.tID = null;
      this.freight = null;
      done();
    },
    //添加海运费或者陆运费
    applyForLand(row) {
      console.log(row)
      this.applyInfo = row;
      this.tID = row.id
      this.freight = Number(row.moneyAmount);
      this.open = true;
    },
    applyForSea(row) {
      console.log(row)
      this.applyInfo = row;
      this.tID = row.id
      this.freight = Number(row.moneyAmount);
      this.open = true;
    },
    /** 查询订单运费列表 */
    getList() {
      this.loading = true;
      //applyDateStartTime
      listOrderFreight(addDateRange(this.queryParams, this.dateRange, 'orderfreight'))
        .then(response => {
          this.orderFreightList = response.rows;
          this.total = response.total;
          this.loading = false;
        });
    },
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        id: null,
        ordersNo: null,
        freightType: null,
        moneyAmount: null,
        selfAcountsName: null,
        selfBankNo: null,
        selfBankName: null,
        otherAcountsName: null,
        otherBankNo: null,
        otherBankName: null,
        content: null,
        paymentState: null,
        driverName: null,
        driverId: null,
        CarNo: null,
        fleet: null,
        applyUserId: null,
        applyUserName: null,
        applyDate: null,
        isedit: null,
        payUserId: null,
        payUserName: null,
        payDate: null,
        cancelFlag: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加订单运费申请";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getOrderFreight(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改订单运费";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateOrderFreight(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addOrderFreight(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除订单运费编号为"' + ids + '"的数据项？').then(function () {
        return delOrderFreight(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/orderFreight/export', {
        ...this.queryParams
      }, `orderFreight_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
