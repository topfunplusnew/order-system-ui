<!--向外借钱-->
<template>
  <div class="app-container">
    <el-form :model="timesQuery" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="开始时间" prop="beginTime">
        <el-date-picker
          v-model="timesQuery.beginTime"
          type="date"
          placeholder="请选择开始时间"
          value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="结束时间" prop="endTime">
        <el-date-picker
          v-model="timesQuery.endTime"
          type="date"
          placeholder="请选择结束时间" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="对象类型" prop="objectType">
        <el-select v-model="timesQuery.objectType" placeholder="请选择对象类型">
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQueryTime">搜索</el-button>
        <!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button size="mini" @click="handleAdd">新增资金借出</el-button>
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
              v-hasPermi="['system:company:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="lendMoneyList" @selection-change="handleSelectionChange"
              v-horizontal-scroll="'always'" id="printBox">
      <!--      <el-table-column label="id" align="center" prop="id"/>-->
      <!--      <el-table-column label="借出款编号" align="center" prop="futuresNO" v-if="columns[0].visible"/>-->
      <el-table-column label="期货保证金公司" align="center" prop="futuresMarginCompany" v-if="columns[1].visible"/>
      <el-table-column label="对象类型" align="center" prop="targetType"
                       v-if="columns[2].visible"/>
      <el-table-column label="对象" align="center" prop="target" v-if="columns[3].visible"/>
      <el-table-column label="保证金金额" align="center" prop="moneyAmount" v-if="columns[4].visible"/>
      <el-table-column label="对方账户" align="center" prop="targetAcountsName" v-if="columns[5].visible">

      </el-table-column>
      <el-table-column label="对方账号" align="center" prop="targetBankNo" v-if="columns[6].visible"/>
      <el-table-column label="对方开户行" align="center" prop="targetBankName" v-if="columns[7].visible"/>
      <el-table-column label="我方支付账户" align="center" prop="selfAcountsName" v-if="columns[8].visible"/>
      <el-table-column label="我方账号" align="center" prop="selfBankNo" v-if="columns[9].visible"/>
      <el-table-column label="我方开户行" align="center" prop="selfBankName" v-if="columns[10].visible"/>
      <el-table-column label="支付期货保证金时间" align="center" prop="futuresDate" v-if="columns[11].visible"/>
      <el-table-column label="事由" align="center" prop="reason" v-if="columns[12].visible"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="230px" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="warning"
            @click="applyForPayment(scope.row)"
            v-hasPermi="['system:lendmoney:remove']"
          >申请付款
          </el-button>
          <el-button
            size="mini"
            type="success"
            @click="handleGetBackMoney(scope.row)"
            v-hasPermi="['system:lendmoney:remove']"
          >收回资金
          </el-button>
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:lendmoney:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:lendmoney:remove']"
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

    <!-- 添加或修改向外部借出款信息对话框 -->
    <el-dialog title="新增资金借出信息" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <!--        <el-form-item label="借出款编号" prop="futuresNO">-->
        <!--          <el-input v-model="form.futuresNO" placeholder="请输入借出款编号"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="期货保证金公司" prop="futuresMarginCompany">
          <el-input v-model="form.futuresMarginCompany" placeholder="请输入期货保证金公司"/>
        </el-form-item>
        <el-form-item label="对象" prop="target">
          <el-input v-model="form.target" placeholder="请输入对象(员工姓名、公司名称)"/>
        </el-form-item>
        <el-form-item label="对象类型" prop="targetType">
          <!--          <el-input v-model="form.target" placeholder="请输入对象(员工姓名、公司名称)"/>-->
          <!--          下拉框 员工 客户 供应商 其他-->
          <el-select v-model="form.targetType" placeholder="请选择对象类型">
            <el-option
              v-for="dict in dict.type.order_target_type"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="保证金金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入保证金金额"/>
        </el-form-item>
        <el-form-item label="对方账户" prop="targetAcountsName">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.targetAcountsName" placeholder="请输入对方账户"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listBankAccount" icon="el-icon-search" @commitBack="handleCommitBack"
                            :limit-info="{}" query-label="户名查找" query-info="acountsName" :query-name="queryBank"
                            @update:queryName="handleUpdateQueryName">
                <template #table-columns>
                  <el-table-column label="公司名称" align="center" prop="acountsName"/>
                  <el-table-column label="开户行" align="center" prop="bankName"/>
                  <el-table-column label="开户名" align="center" prop="acountsName"/>
                  <el-table-column label="账号" align="center" prop="bankNo"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="对方账号" prop="targetBankNo">
          <el-input v-model="form.targetBankNo" placeholder="请输入对方账号"/>
        </el-form-item>
        <el-form-item label="对方开户行" prop="targetBankName">
          <el-input v-model="form.targetBankName" placeholder="请输入对方开户行"/>
        </el-form-item>
        <el-form-item label="我方支付账户" prop="selfAcountsName">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.selfAcountsName" placeholder="请输入我方支付账户"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listBankAccount" icon="el-icon-search" @commitBack="handleCommitBackSelf"
                            :limit-info="{acountsType:'己方公司'}" query-label="户名查找" query-info="acountsName"
                            :query-name="queryBank"
                            @update:queryName="handleUpdateQueryName">
                <template #table-columns>
                  <el-table-column label="账户类型" align="center" prop="acountsType"/>
                  <el-table-column label="开户行" align="center" prop="bankName"/>
                  <el-table-column label="开户名" align="center" prop="acountsName"/>
                  <el-table-column label="账号" align="center" prop="bankNo"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="我方账号" prop="selfBankNo">
          <el-input v-model="form.selfBankNo" placeholder="请输入我方账号"/>
        </el-form-item>
        <el-form-item label="我方开户行" prop="selfBankName">
          <el-input v-model="form.selfBankName" placeholder="请输入我方开户行"/>
        </el-form-item>
        <!--        时间选择-->
        <el-form-item label="支付期货保证金时间" prop="futuresDate">
          <!--          <el-input v-model="form.futuresDate" placeholder="请输入支付期货保证金时间"/>-->
          <el-date-picker
            v-model="form.futuresDate"
            type="date"
            placeholder="请选择支付期货保证金时间"
            value-format="yyyy-MM-dd">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="事由" prop="reason">
          <el-input v-model="form.reason" placeholder="请输入事由"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>


    <!--    回收弹窗-->
    <el-dialog title="收回资金操作" :visible.sync="giveRecoverMoneyShow">
      <div id="back-money-info">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>历史收回记录</span>
            <el-button style="float: right; padding: 3px 0" @click="handleRefreshNeedGetBackMoneyList">
              刷新
            </el-button>
          </div>
          <el-table
            :data="needGetBackMoneyList"
            style="width: 100%" border v-loading="needMoneyLoading">
            <!--            <el-table-column-->
            <!--              prop="id"-->
            <!--              label="ID"-->
            <!--              width="60">-->
            <!--            </el-table-column>-->
            <!--            <el-table-column-->
            <!--              prop="futuresNO"-->
            <!--              label="借出款编号"-->
            <!--              width="130">-->
            <!--            </el-table-column>-->
            <el-table-column
              prop="moneyAmount"
              label="收回金额">
            </el-table-column>
            <el-table-column
              prop="bankNo"
              label="收回账号">
            </el-table-column>
            <el-table-column
              prop="acountsName"
              label="收回账户">
            </el-table-column>
            <el-table-column
              prop="recoverDate"
              label="还款日期">
            </el-table-column>
            <el-table-column
              prop="bankNo"
              label="还款账号">
            </el-table-column>
            <el-table-column
              prop="comments"
              label="备注">
            </el-table-column>
          </el-table>
        </el-card>
        <br/>
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <h4 style="font-weight: bolder">借出款编号:{{ currentUUID }}
              <el-button type="primary" @click="innerVisible = true">收款</el-button>
            </h4>
          </div>
          <!--内层-->
          <el-dialog
            width="30%"
            title="继续收款"
            :visible.sync="innerVisible"
            append-to-body>
            <!-- 还款表单-->
            <el-form :model="currentRecoverMoneyInfo" class="demo-form-inline">
              <el-form-item label="收回账号" prop="bankNo">
                <span>{{ currentRecoverMoneyInfo.selfBankNo }}</span>
              </el-form-item>
              <el-form-item label="收回账户" prop="acountsName">
                <el-input v-model="currentAccountsName" placeholder="请输入收回账户"/>
                <!--{{ currentAccountsName }}-->
              </el-form-item>
              <el-form-item label="收回金额" prop="moneyAmount">
                <el-input v-model="currentRecoverMoneyInfo.moneyAmount" placeholder="请输入收回金额"/>
              </el-form-item>
              <el-form-item label="收回日期" prop="payDate">
                <el-date-picker
                  v-model="currentRecoverMoneyInfo.recoverDate"
                  type="date"
                  placeholder="请选择收回日期" value-format="yyyy-MM-dd">
                </el-date-picker>
              </el-form-item>
              <el-form-item label="备注信息" prop="comments">
                <el-input v-model="currentRecoverMoneyInfo.comments" placeholder="请输入备注信息"/>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="RecoverMoney">收款</el-button>
              </el-form-item>
            </el-form>
          </el-dialog>
        </el-card>
      </div>
    </el-dialog>

    <!--    付款申请-->
    <el-dialog
      title="提示"
      :visible.sync="applyDialogVisible"
      width="65%">
      <ApplyPayment :table-name="TableName.LEND_MONEY" :t-i-d="tid" :need-money="needMoney"
                    :need-info="{}"
                    @changeOpen="applyDialogVisible = false"/>
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

export default {
  name: "LendMoney",
  components: {ApplyPayment, SearchOption},
  dicts: ['order_target_type'],
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
        pageSize: 10,
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
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      columns: [
        {key: 0, label: `借出款编号`, visible: true},
        {key: 1, label: `期货保证金公司`, visible: true},
        {key: 2, label: `对象类型`, visible: true},
        {key: 3, label: `对象`, visible: true},
        {key: 4, label: `保证金金额`, visible: true},
        {key: 5, label: `对方账户`, visible: true},
        {key: 6, label: `对方账号`, visible: true},
        {key: 7, label: `对方开户行`, visible: true},
        {key: 8, label: `我方开户行`, visible: true},
        {key: 9, label: `我方支付账户`, visible: true},
        {key: 10, label: `我方账号`, visible: true},
        {key: 11, label: `我方开户行`, visible: true},
        {key: 12, label: `支付期货保证金时间`, visible: true},
      ],
      //搜索参数
      timesQuery: {
        beginTime: '',
        endTime: '',
        objectType: ''
      },
      //员工、客户、供应商、其他
      options: [
        {
          label: '员工',
          value: '员工'
        }, {
          label: '客户',
          value: '客户'
        }, {
          label: '供应商',
          value: '供应商'
        }, {
          label: '其他',
          value: '其他'
        }
      ],
      //uuid
      currentUUID: '',
      //收回资金弹窗
      giveRecoverMoneyShow: false,
      //历史收回资金列表
      needGetBackMoneyList: [],
      //加载
      needMoneyLoading: false,
      //收款表单
      currentRecoverMoneyInfo: {},
      innerVisible: false,
      //默认填充的账户和账号
      currentBankNo: '',
      currentBankName: '',
      currentAccountsName: '',
      currentCompanyName: '',
      //对方公司或者客户名称
      currentTargetAcountsName: '',


      //
      queryBank: '',

      applyDialogVisible: false,
      tid: '',
      needMoney: 0
    };
  },
  created() {
    this.getList();
    //查向外借钱
    this.$store.dispatch('money/getTempLendMoneyList')
  },
  computed: {
    TableName() {
      return TableName
    },
    ...mapGetters(['tempLendMoneyList'])
  },
  methods: {
    listCompany,
    listBankAccount,
    // 付款申请
    applyForPayment(row) {
      this.applyDialogVisible = true;
      this.tid = row.id;
      this.needMoney = row.moneyAmount
    },
    //点击收回资金按钮
    handleGetBackMoney(row) {
      console.log(row)
      this.giveRecoverMoneyShow = true;
      this.needMoneyLoading = true
      this.currentUUID = row.futuresNO
      //不需要填的字段自动填充
      this.currentBankNo = row.selfBankNo
      this.currentBankName = row.selfBankName;
      this.currentAccountsName = row.selfAcountsName
      this.currentTargetAcountsName = row.targetAcountsName
      this.currentRecoverMoneyInfo.selfBankNo = row.selfBankNo
      setTimeout(() => {
        getRecoverMoneyByUuid(this.currentUUID).then(res => {
          this.needGetBackMoneyList = res.data
          this.needMoneyLoading = false
        })
      }, 200)
    },
    //刷新
    handleRefreshNeedGetBackMoneyList() {
      this.handleGetBackMoney({futuresNO: this.currentUUID})
    },
    //收回资金
    RecoverMoney() {
      //添加信息
      addRecoverMoney({
        ...this.currentRecoverMoneyInfo, futuresNO: this.currentUUID
        , bankNo: this.currentBankNo, acountsName: this.currentAccountsName
      })
        .then(res => {
          this.$modal.msgSuccess("修改成功");
          this.giveRecoverMoneyShow = false
          this.innerVisible = false
        }).catch(err => {
        this.$modal.msgError("修改失败:" + err.msg);
      })

      //同步修改到收款信息里
      //fundsDate
      const fundsDate = this.currentRecoverMoneyInfo.recoverDate;
      //todo 支付类型 未知功能
      const receiveType = '收回借出款';
      const tableName = 'recoverMoney'; //操作表
      const tID = 'id'; //对应表的主键
      const moneyAmount = this.currentRecoverMoneyInfo.moneyAmount;//操作金额
      const selfAcountsName = this.currentRecoverMoneyInfo.selfAcountsName;//收回账户
      const selfBankNo = this.currentRecoverMoneyInfo.selfBankNo;//收回账号
      const selfBankName = this.currentBankName;
      const companyName = this.currentTargetAcountsName
      //todo companyId 魔法值 需要查询公司的id 以及类型 如客户或者供应商
      const companyId = '999';
      const companyType = '1';
      const comments = '备注:资金收回';
      //构造
      const item = {
        fundsDate,
        receiveType,
        tableName,
        tID,
        moneyAmount,
        selfAcountsName,
        selfBankNo,
        selfBankName,
        companyName,
        companyId,
        companyType,
        comments
      }
      this.addToReceiveMoney(item)
    },
    //同步修改到收款信息方法
    addToReceiveMoney(item) {
      addReceiveMoney(item).then(res => {
        console.log(res)
      })
    },
    handleQueryTime() {
      //重置
      this.lendMoneyList = this.tempLendMoneyList
      //筛选事件
      this.lendMoneyList = this.filterTime()
    },
    //筛选方法
    filterTime() {
      return this.lendMoneyList.filter(item => {
        //时间转换
        const time_search = new Date(item.futuresDate).getTime()
        const time_start = new Date(this.timesQuery.beginTime).getTime()
        const date = new Date(this.timesQuery.endTime)
        date.setDate(date.getDate() + 1)
        const time_end = date.getTime()
        //如果当前的客户类型给空
        if (this.timesQuery.beginTime !== '' && this.timesQuery.endTime !== '') {
          if (this.timesQuery.objectType !== '') {
            return time_search >= time_start && time_search <=
              time_end && item.targetType === this.timesQuery.objectType
          } else {
            return time_search >= time_start && time_search <= time_end
          }
        } else {
          return item.targetType === this.timesQuery.objectType
        }
      })
    },


    //
    handleCommitBack(val) {
      this.form.targetBankNo = val.bankNo;
      this.form.targetBankName = val.bankName;
      this.form.targetAcountsName = val.acountsName;
    },
    //
    handleUpdateQueryName(val) {
      this.queryCompany = val;
    },
    //
    handleCommitBackSelf(val) {
      this.form.selfBankNo = val.bankNo;
      this.form.selfBankName = val.bankName;
      this.form.selfAcountsName = val.acountsName;
    },

    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    /** 查询向外部借出款信息列表 */
    getList() {
      this.loading = true;
      listLendMoney(this.queryParams).then(response => {
        this.lendMoneyList = response.rows;
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
      this.title = "添加向外部借出款信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getLendMoney(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改向外部借出款信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            this.form = excludeParams(this.form, this.$exclude)
            updateLendMoney(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            this.form = excludeParams(this.form, this.$exclude)
            addLendMoney(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除向外部借出款信息编号为"' + ids + '"的数据项？').then(function () {
        return delLendMoney(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/lendMoney/export', {
        ...this.queryParams
      }, `lendMoney_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
