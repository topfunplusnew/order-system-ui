<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="返利开始日期" prop="rebateStartTime">
        <el-date-picker
          v-model="queryParams.rebateStartTime"
          type="date"
          placeholder="选择开始时间" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="返利结束日期" prop="rebateEndTime">
        <el-date-picker
          v-model="queryParams.rebateEndTime"
          type="date"
          placeholder="选择开始时间" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="供应商" prop="supplier">
        <el-input
          v-model="queryParams.supplier"
          placeholder="请输入供应商"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <!-- 刷新按钮-->
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:rebate:add']"
        >新增供应商返利信息
        </el-button>
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
              v-hasPermi="['system:rebate:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="RebateList"
              @selection-change="handleSelectionChange" id="printBox">
      <el-table-column label="日期" align="center" prop="rebateDate" v-if="columns[0].visible"/>
      <el-table-column label="金额" align="center" prop="rebate" v-if="columns[1].visible"/>
      <el-table-column label="类型" align="center" prop="rebateType" v-if="columns[2].visible"/>
      <el-table-column label="收款户名" align="center" prop="inAcountsName" v-if="columns[3].visible"/>
      <el-table-column label="收款账号" align="center" prop="inBankNo" v-if="columns[4].visible"/>
      <el-table-column label="供应商" align="center" prop="supplier" v-if="columns[5].visible"/>
      <el-table-column label="付款户名" align="center" prop="outAcountsName" v-if="columns[6].visible"/>
      <el-table-column label="付款款账号" align="center" prop="outBankNo" v-if="columns[7].visible"/>
      <el-table-column label="返利原因" align="center" prop="rebateReason" v-if="columns[8].visible"/>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[9].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="warning"
            @click="addPaymentApply(scope.row)"
          >付款返利
          </el-button>
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:rebate:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:rebate:remove']"
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

    <!-- 添加或修改返利回扣对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="50%" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <!--        多选 且树表 展示多个订单 每个订单里面有多个订单详情-->
        <el-row>
          <el-col :span="12">
            <el-form-item label="订单编号" prop="ordersNo">
              <el-button @click="orderDialogVisible = true">
                {{ form.ordersNo === null || form.ordersNo === '' ? '选择订单编号' : '已选择:' + form.ordersNo }}
              </el-button>
            </el-form-item>
            <el-form-item label="日期" prop="rebateDate">
              <el-date-picker
                v-model="form.rebateDate"
                type="date"
                placeholder="日期"
                value-format="yyyy-MM-dd">
              </el-date-picker>
            </el-form-item>
            <el-form-item label="类型" prop="rebateType">
              <el-select v-model="form.rebateType" placeholder="请选择">
                <el-option
                  v-for="item in rebateTypes"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="金额" prop="rebate">
              <el-input v-model="form.rebate" placeholder="请输入金额"/>
            </el-form-item>
            <el-form-item label="收款户名" prop="inAcountsName">
              <el-row>
                <el-col :span="20">
                  <el-input v-model="form.inAcountsName" placeholder="请输入收款户名"/>
                </el-col>
                <el-col :span="4">
                  <SearchOption :limit-info="{}" :get-data="listBankAccount" @commitBack="handleCommitBackBankAcount"
                                @update:queryName="handleUpdateQueryBankAcount" :query-name="queryBankAcount"
                                query-label="户名查找" query-info="acountsName">
                    <template #table-columns>
                      <el-table-column label="账户类型" align="center" prop="acountsType"/>
                      <el-table-column label="开户名称(户名)" align="center" prop="acountsName"/>
                      <el-table-column label="账号(银行账号)" align="center" prop="bankNo"/>
                      <el-table-column label="开户行" align="center" prop="bankName"/>
                      <el-table-column label="公司名称" align="center" prop="companyName"/>
                    </template>
                  </SearchOption>
                </el-col>
              </el-row>
            </el-form-item>
            <el-form-item label="收款账号" prop="inBankNo">
              <el-input v-model="form.inBankNo" placeholder="请输入收款账号"/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <!--        供应商直接选择 不要自己填-->
            <el-form-item label="请选择供应商" prop="supplier">
              <el-row>
                <el-col :span="20">
                  <el-input disabled v-model="form.supplier" placeholder="请选择供应商"/>
                </el-col>
                <el-col :span="4">
                  <SearchOption :limit-info="{companyType:'供应商'}" :get-data="listCompany"
                                @commitBack="handleCommitBackCompanyGive" @update:queryName="handleQueryCompanyGive"
                                :query-name="queryCompanyGive" query-info="companyName" query-label="供应商查找">
                    <template #table-columns>
                      <el-table-column label="供应商" align="center" prop="companyName"/>
                      <el-table-column label="地址" align="center" prop="address"/>
                    </template>
                  </SearchOption>
                </el-col>
              </el-row>
            </el-form-item>
            <!--        <el-form-item label="供应商ID" prop="supplierID">-->
            <!--          <el-input v-model="form.supplierID" placeholder="请输入供应商ID"/>-->
            <!--        </el-form-item>-->
            <el-form-item label="付款户名" prop="outAcountsName">
              <el-row>
                <el-col :span="20">
                  <el-input v-model="form.outAcountsName" placeholder="请输入付款户名"/>
                </el-col>
                <el-col :span="4">
                  <SearchOption :limit-info="{acountsType:'己方公司'}" :get-data="listBankAccount"
                                @commitBack="handleCommitBackBankAcountSelf"
                                @update:queryName="handleUpdateQueryBankAcountSelf"
                                :query-name="bankAcountSelf"
                                query-label="户名查找" query-info="acountsName">
                    <template #table-columns>
                      <el-table-column label="账户类型" align="center" prop="acountsType"/>
                      <el-table-column label="开户名称(户名)" align="center" prop="acountsName"/>
                      <el-table-column label="账号(银行账号)" align="center" prop="bankNo"/>
                      <el-table-column label="开户行" align="center" prop="bankName"/>
                      <el-table-column label="公司名称" align="center" prop="companyName"/>
                    </template>
                  </SearchOption>
                </el-col>
              </el-row>
            </el-form-item>
            <el-form-item label="付款款账号" prop="outBankNo">
              <el-input v-model="form.outBankNo" placeholder="请输入付款款账号"/>
            </el-form-item>
            <el-form-item label="返利原因" prop="rebateReason">
              <el-input v-model="form.rebateReason" placeholder="请输入返利原因"/>
            </el-form-item>
            <el-form-item label="备注" prop="comments">
              <el-input v-model="form.comments" placeholder="请输入备注"/>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>


    <!--    加油卡付款申请-->
    <el-dialog title="返利付款申请" :visible.sync="paymentApplyVisible" width="500px" append-to-body>
      <ApplyPayment :table-name="TableName.REBATE" :t-i-d="tid" :need-money="needMoney"
                    :need-info="{...needInfo,otherAcountsName:needInfo.acountsName}"
                    @changeOpen="paymentApplyVisible = false"/>
    </el-dialog>


    <!--    选择订单详情-->
    <el-dialog
      title="订单选择"
      :visible.sync="orderDialogVisible"
      width="50%">
      <el-row>
        <el-col :span="12">
          <el-row>
            <el-col :span="7">
              <span style="font-weight: bolder;line-height: 40px">请选择订单信息</span>
            </el-col>
            <el-col :span="17">
              <el-select v-model="valueOrder" placeholder="请选择订单">
                <el-option
                  v-for="item in orderList"
                  :key="item.ordersNo"
                  :label="item.ordersNo"
                  :value="item.id">
                </el-option>
              </el-select>
            </el-col>
          </el-row>
        </el-col>
        <el-col :span="12">
          <el-row>
            <el-col :span="7">
              <span style="font-weight: bolder;line-height: 40px">请选择货物详情信息</span>
            </el-col>
            <el-col :span="17">
              <el-select :disabled="valueOrder === ''"
                         :placeholder="valueOrder ===''?'请先选择订单信息':'请选择货物详情信息'"
                         v-model="valueOrderDetail">
                <el-option
                  v-for="item in orderDetailList"
                  :key="item.ordersNo"
                  :label="item.ordersNo"
                  :value="item.ordersNo">
                </el-option>
              </el-select>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <hr/>
      <!--      展示-->
      <el-row>
        <el-row>
          <OrderInfos :orderInfo="orderInfo"/>
        </el-row>
        <el-row>
          <el-row>
            <span style="font-weight: bolder">货物详情列表</span>
          </el-row>
          <el-row>
            <el-table border :data="orderDetailList" id="printBox" max-height="700">
              <el-table-column label="订单编号" align="center" prop="ordersNo" fixed="left"/>
              <el-table-column label="订单日期" align="center" prop="orderDate" fixed="left"/>
              <el-table-column label="客户" align="center" prop="customer"/>
              <el-table-column label="供应商" align="center" prop="supplier"/>
              <el-table-column label="级别名称" align="center" prop="levelName"/>
              <el-table-column label="计量单位" align="center" prop="countingUnit"/>
              <el-table-column label="厚度" align="center" prop="height"/>
              <el-table-column label="长度" align="center" prop="length"/>
              <el-table-column label="宽度" align="center" prop="width"/>
              <el-table-column label="出厂片数" align="center" prop="pieces"/>
              <el-table-column label="每包片数" align="center" prop="piecesPerPack"/>
              <el-table-column label="包数" align="center" prop="packs"/>
              <el-table-column label="出厂单价" align="center" prop="price"/>
              <el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory">
                <template slot-scope="scope">
                  <el-tag
                    disable-transitions>{{ scope.row.isIncludeTaxFactory === 0 ? "否" : "是" }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="杂费" align="center" prop="sundryCost"/>
              <el-table-column label="出厂货款" align="center" prop="paymentFactory"/>
              <el-table-column label="卸货价" align="center" prop="paymentUnload"/>
              <el-table-column label="销售是否含税" align="center" prop="isIncludeTaxSale">
                <template slot-scope="scope">
                  <el-tag
                    disable-transitions>{{ scope.row.isIncludeTaxSale === 0 ? "否" : "是" }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="总货款" align="center" prop="payments"/>
              <el-table-column label="误差" align="center" prop="erro"/>
              <el-table-column label="吨位" align="center" prop="tonnage"/>
              <el-table-column label="陆运费单价" align="center" prop="landFreightPrice"/>
              <el-table-column label="陆运费" align="center" prop="landFreight"/>
              <el-table-column label="海运费" align="center" prop="seaFreight"/>
              <el-table-column label="总运费" align="center" prop="freight"/>
              <el-table-column label="其他费用" align="center" prop="otherCost"/>
              <el-table-column label="利润" align="center" prop="profit"/>
              <el-table-column label="不含税利润" align="center" prop="profitNoTax"/>
              <el-table-column label="实际片数" align="center" prop="actualPieces"/>
              <el-table-column label="总货款杂费" align="center" prop="paymentsWithSundry"/>
              <el-table-column label="加费" align="center" prop="additionalFees"/>
              <el-table-column label="仓库名称" align="center" prop="storeHouseName"/>
              <el-table-column label="物流利润" align="center" prop="logisticsProfit"/>
              <el-table-column label="客户佣金" align="center" prop="customerCommission"/>
            </el-table>
          </el-row>
        </el-row>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
import {listRebate, getRebate, delRebate, addRebate, updateRebate} from "@/api/system/Rebate";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import ApplyPayment from "@/components/ApplyPayment.vue";
import {TableName} from "@/api/tool/enums";
import {getGoodsOrder, listGoodsOrder} from "@/api/system/goodsOrder";
import OrderInfos from "@/components/OrderInfos.vue";
import OrderDetailInfo from "@/components/OrderDetailInfo.vue";
import {listBankAccount} from "@/api/system/bankAccount";
import {listCompany} from "@/api/system/company";
import SearchOption from "@/components/SearchOption.vue";

export default {
  name: "Rebate",
  computed: {
    TableName() {
      return TableName
    }
  },
  components: {SearchOption, OrderDetailInfo, OrderInfos, ApplyPayment},
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
      // 返利回扣表格数据
      RebateList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        rebateEndTime: null,
        rebateStartTime: null,
        pageNum: 1,
        pageSize: 10,
        ordersNo: null,
        rebateDate: null,
        rebate: null,
        rebateType: null,
        inAcountsName: null,
        inBankNo: null,
        supplier: null,
        supplierID: null,
        outAcountsName: null,
        outBankNo: null,
        rebateReason: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      rebateTypes: [{
        value: '返利',
        label: '返利'
      }, {
        value: '降价',
        label: '降价'
      }, {
        value: '售后质量赔偿',
        label: '售后质量赔偿'
      }],
      // 表单校验
      rules: {
        ordersNo: [
          {required: true, message: "订单号不能为空", trigger: "blur"}],
        rebateDate: [
          {required: true, message: "返利日期不能为空", trigger: "blur"}],
        rebate: [
          {required: true, message: "返利金额不能为空", trigger: "blur"}],
        rebateType: [
          {required: true, message: "返利类型不能为空", trigger: "change"}],
        inAcountsName: [
          {required: true, message: "收款户名不能为空", trigger: "blur"}],
        inBankNo: [
          {required: true, message: "收款账号不能为空", trigger: "blur"}],
        supplier: [
          {required: true, message: "供应商不能为空", trigger: "blur"}],
        outAcountsName: [
          {required: true, message: "付款户名不能为空", trigger: "blur"}],
        outBankNo: [
          {required: true, message: "付款账号不能为空", trigger: "blur"}],
        rebateReason: [
          {required: true, message: "请输入返利原因!", trigger: "blur"}
        ]
      },
      columns: [
        {key: 0, label: `日期`, visible: true},
        {key: 1, label: `金额`, visible: true},
        {key: 2, label: `类型`, visible: true},
        {key: 3, label: `收款户名`, visible: true},
        {key: 4, label: `收款账号`, visible: true},
        {key: 5, label: `供应商`, visible: true},
        {key: 6, label: `付款户名`, visible: true},
        {key: 7, label: `付款款账号`, visible: true},
        {key: 8, label: `返利原因`, visible: true},
        {key: 9, label: `备注`, visible: true},
      ],
      needInfo: '',
      paymentApplyVisible: false,
      tid: '',
      needMoney: 0,

      //订单列表 级联
      orderList: [],
      //订单详情列表 级联
      orderDetailList: [],
      //选择的订单个体orderId
      valueOrder: '',
      //订单详情orderDetail编号
      valueOrderDetail: '',
      orderDialogVisible: false,
      //订单个人信息和订单详情信息
      orderInfo: {},
      queryBankAcount: '',

      //搜索供应商
      queryCompanyGive: '',
      bankAcountSelf: ''
    };
  },
  created() {
    this.getList();
    //获取订单列表 级联选择
    listGoodsOrder().then(res => {
      this.orderList = res.rows;
      //保存到session 后续可以少发一次请求
      sessionStorage.setItem('orderList', JSON.stringify(res.rows))
    })
    if (localStorage.getItem('rebate-columns') === 'null'
      || !localStorage.getItem('rebate-columns')) {
      //设置localStorage
      localStorage.setItem("rebate-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('rebate-columns'));
    }
  },
  watch: {
    //监听选择的一级
    valueOrder(newVal) {
      //获取订单详情信息
      getGoodsOrder(newVal).then(res => {
        this.orderDetailList = res.data.orderDetailList
      })
      //保存订单信息
      this.orderInfo = this.orderList.filter(item => item.id === newVal)[0]
      //重置
      this.orderList = JSON.parse(sessionStorage.getItem('orderList'))
    },
    //货物编号 自动填充
    valueOrderDetail(newVal) {
      console.log('选择的货物详情', newVal)
      this.form.orderDetailID = newVal;
      this.form.ordersNo = newVal;
      this.orderDialogVisible = false;
    },
    columns: {
      handler: (newVal) => {
        localStorage.setItem("rebate-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  methods: {
    listCompany,
    listBankAccount,
    addPaymentApply(row) {
      this.tid = row.id;
      this.paymentApplyVisible = true;
      this.needMoney = row.rebate;
      this.needInfo = row;
    },
    handleCommitBackBankAcount(val) {
      this.form.inAcountsName = val.acountsName
      this.form.inBankNo = val.bankNo
    },
    handleUpdateQueryBankAcount(val) {
      this.queryBankAcount = val;
    },
    handleCommitBackCompanyGive(val) {
      this.form.supplier = val.companyName
      this.form.supplierID = val.id;
    },
    handleQueryCompanyGive(val) {
      this.queryCompanyGive = val;
    },
    handleCommitBackBankAcountSelf(val) {
      this.form.outAcountsName = val.acountsName;
      this.form.outBankNo = val.bankNo;
    },
    handleUpdateQueryBankAcountSelf(val) {
      this.bankAcountSelf = val;
    },
    /** 查询返利回扣列表 */
    getList() {
      this.loading = true;
      listRebate(this.queryParams).then(response => {
        this.RebateList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
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
        rebateDate: null,
        rebate: null,
        rebateType: null,
        inAcountsName: null,
        inBankNo: null,
        supplier: null,
        supplierID: null,
        outAcountsName: null,
        outBankNo: null,
        rebateReason: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
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
      this.title = "添加返利回扣";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getRebate(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改返利回扣";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateRebate(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addRebate(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除返利回扣编号为"' + ids + '"的数据项？').then(function () {
        return delRebate(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/Rebate/export', {
        ...this.queryParams
      }, `Rebate_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
