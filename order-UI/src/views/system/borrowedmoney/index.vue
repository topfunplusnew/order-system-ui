<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="开始时间" prop="beginTime">
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
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
        <el-button type="danger" size="mini" @click="handleAdd">新增借入款信息</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" :columns="columns">
        <template v-slot:print>
          <el-col :span="1.5">
            <el-button
                plain
                icon="el-icon-printer"
                size="mini"
                @click="printHTML">
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
                v-hasPermi="['system:borrowedmoney:export']">
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="borrowedMoneyList" @selection-change="handleSelectionChange"
              v-horizontal-scroll="'always'" id="printBox" show-summary :summary-method="getSummaries" size="mini"
              :cell-style="()=>{return {padding:'.5px'}}">
      <el-table-column label="id" align="center" prop="id" v-if="columns[0].visible"/>
      <el-table-column label="贷款来源" align="center" prop="origin" v-if="columns[1].visible"/>
      <el-table-column label="借入金额" align="center" prop="moneyAmount" v-if="columns[2].visible"/>
      <el-table-column label="付息金额" align="center" prop="ratio" v-if="columns[3].visible"/>
      <el-table-column label="贷款发放日期" align="center" prop="loanDate" v-if="columns[4].visible"/>
      <el-table-column label="贷款年限" align="center" prop="loanDuring" v-if="columns[5].visible"/>
      <el-table-column label="抵押担保" align="center" prop="mortgageGuarantee" v-if="columns[6].visible"/>
      <el-table-column label="打入账户" align="center" prop="acountsName" v-if="columns[7].visible"/>
      <el-table-column label="打入账号" align="center" prop="bankNo" v-if="columns[8].visible"/>
      <!--      <el-table-column label="已还款标记" align="center" prop="isEnd" v-if="columns[9].visible"/>-->
      <el-table-column label="备注" align="center" prop="comments"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="160px" fixed="right">
        <template slot-scope="scope">
          <el-button
              size="mini"
              type="warning"
              @click="handleGiveBackMoney(scope.row)"
              v-if="scope.row.isEnd ==='否'">还款
          </el-button>
          <el-button
              size="mini"
              type="success"
              disabled
              v-if="scope.row.isEnd ==='是'">已还款
          </el-button>
          <el-button
              size="mini"
              type="primary"
              @click="handleUpdate(scope.row)"
              v-hasPermi="['system:borrowedmoney:edit']">编辑
          </el-button>
          <el-button
              size="mini"
              type="danger"
              @click="handleDelete(scope.row)"
              v-hasPermi="['system:borrowedmoney:remove']">删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination
        v-show="total>0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"/>

    <!-- 添加或修改从外部借款信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="60%" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="贷款来源" prop="origin">
              <el-input v-model="form.origin" placeholder="请输入贷款来源"/>
            </el-form-item>
            <el-form-item label="借入金额" prop="moneyAmount">
              <el-input v-model="form.moneyAmount" placeholder="请输入借入金额"/>
            </el-form-item>
            <el-form-item label="贷款利率" prop="ratio">
              <el-input v-model="form.ratio" placeholder="请输入贷款利率"/>
            </el-form-item>
            <el-form-item label="贷款发放日期" prop="loanDate">
              <el-date-picker
                  v-model="form.loanDate"
                  type="date"
                  placeholder="请选择贷款发放日期"
                  value-format="yyyy-MM-dd">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="贷款年限" prop="loanDuring">
              <el-input v-model="form.loanDuring" placeholder="请输入贷款年限"/>
            </el-form-item>
            <el-form-item label="抵押担保" prop="mortgageGuarantee">
              <el-input v-model="form.mortgageGuarantee" placeholder="请输入抵押担保"/>
            </el-form-item>
            <el-form-item label="打入账户" prop="acountsName">
              <el-row>
                <el-col :span="20">
                  <el-input v-model="form.acountsName" placeholder="请输入抵押担保"/>
                </el-col>
                <el-col :span="4">
                  <SearchOption :get-data="listBankAccount" icon="el-icon-search"
                                @commitBack="handleCommitBackBankAcountForm"
                                :limit-info="{acountsType:'己方公司'}" query-label="户名查找" query-info="acountsName"
                                :query-name="queryBank"
                                @update:queryName="handleUpdateQueryBankAcountForm">
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
            <el-form-item label="打入账号" prop="bankNo">
              <el-input v-model="form.bankNo" placeholder="请输入抵押担保"/>
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


    <!--    点击还款的弹框-->
    <el-dialog title="还款操作" :visible.sync="giveBackMoneyShow" width="30%">
      <el-row>
        <el-form ref="form" :model="moneyBackInfo" label-width="140px">
          <el-form-item label="还款金额" prop="moneyAmount">
            <el-input v-model="moneyBackInfo.moneyAmount" placeholder="请输入还款金额"/>
          </el-form-item>
          <el-form-item label="付息金额" prop="ratio">
            <el-input v-model="moneyBackInfo.ratio" placeholder="请输入付息金额"/>
          </el-form-item>
          <el-form-item label="支付日期" prop="payDate">
            <el-date-picker
                v-model="moneyBackInfo.payDate"
                type="date"
                placeholder="选择支付日期"
                value-format="yyyy-MM-dd">
            </el-date-picker>
          </el-form-item>
          <el-form-item label="银行户名" prop="acountsName">
            <el-row>
              <el-col :span="10">
                <el-input v-model="moneyBackInfo.acountsName" placeholder="请输入银行户名"/>
              </el-col>
              <el-col :span="3">
                <SearchOption :get-data="listBankAccount" icon="el-icon-search" @commitBack="handleCommitBackBankAcount"
                              :limit-info="{}" query-label="户名查找" query-info="acountsName"
                              :query-name="queryBank"
                              @update:queryName="handleUpdateQueryBankAcount">
                  <template #table-columns>
                    <el-table-column label="开户行" align="center" prop="bankName"/>
                    <el-table-column label="开户名" align="center" prop="acountsName"/>
                    <el-table-column label="账号" align="center" prop="bankNo"/>
                  </template>
                </SearchOption>
              </el-col>
            </el-row>
          </el-form-item>
          <el-form-item label="开户行" prop="bankNo">
            <el-input v-model="moneyBackInfo.bankNo" placeholder="请输入开户行"/>
          </el-form-item>
          <el-form-item label="备注" prop="comments">
            <el-input v-model="moneyBackInfo.comments" placeholder="请输入备注"/>
          </el-form-item>
        </el-form>
      </el-row>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitAddBorrowedMoney">确 定</el-button>
        <el-button @click="giveBackMoneyShow = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  listBorrowedMoney,
  getBorrowedMoney,
  delBorrowedMoney,
  addBorrowedMoney,
  updateBorrowedMoney, getBorrowedMoneyByUuid
} from "@/api/system/borrowedMoney";
import {mapGetters, mapState} from "vuex";
import {addRepayment} from "@/api/system/repayment";
import SearchOption from "@/components/SearchOption.vue";
import {listBankAccount} from "@/api/system/bankAccount";
import {listCompany} from "@/api/system/company";
import ApplyPayment from "@/components/ApplyPayment.vue";
import {TableName} from "@/api/tool/enums";
import {addDateRange, parseTime} from "@/utils/ruoyi";
import {excludeParams} from "@/api/tool/exclude";
import {mixin_printHTML} from "../../dashboard/mixins/print";

export default {
  name: "BorrowedMoney",
  components: {ApplyPayment, SearchOption},
  mixins: [mixin_printHTML],
  data() {
    //todo rule校验
    var validateloanNO = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请输入loanNO'));
      } else {
        if (this.form.loanNO !== '') {
          this.$refs.form.validateField('check loanNO');
        }
        callback();
      }
    };
    return {
      //测试数据
      formInline: {
        user: '',
        region: ''
      },
      //ruoyi
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      borrowedMoneyList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        loanNO: null,
        origin: null,
        moneyAmount: null,
        ratio: null,
        loanDate: null,
        loanDuring: null,
        mortgageGuarantee: null,
        acountsName: null,
        bankNo: null,
        isEnd: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      form: {},
      rules: {
        loanNO: [
          {validator: validateloanNO, trigger: 'blur'}
        ],
        origin: [
          {required: true, message: '贷款来源不能为空', trigger: 'blur'}],
        moneyAmount: [
          {required: true, message: '借入金额不能为空', trigger: 'blur'}],
        ratio: [
          {required: true, message: '贷款利率不能为空', trigger: 'blur'}],
        loanDate: [
          {required: true, message: '贷款发放日期不能为空', trigger: 'blur'}],
        loanDuring: [
          {required: true, message: '贷款期限不能为空', trigger: 'blur'}],
        mortgageGuarantee: [
          {required: true, message: '抵押担保不能为空', trigger: 'blur'}],
        acountsName: [
          {required: true, message: '打入账户不能为空', trigger: 'blur'}],
        bankNo: [
          {required: true, message: '打入账号不能为空', trigger: 'blur'}],
      },
      dateRange: [],
      //
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
      timesQuery: {
        beginTime: '',
        endTime: '',
      },
      //还款弹窗
      giveBackMoneyShow: false,
      //还款记录列表
      needGiveBackMoneyList: [],
      needMoneyLoading: false,
      //还款内层
      innerVisible: false,
      //当前选中的UUID和银行卡号
      currentUUID: '',
      currentBankNo: '',
      currentGiveBackMoneyInfo: {},
      //是否偿还利息
      isNeedRatio: false,
      //点击银行卡 查询银行卡
      queryBank: '',
      //付款分类信息
      subjectTree: [],
      //分类信息
      currentSort: {
        levelOne: '',
        levelTwo: ''
      },
      //一级分类列表
      OneLevelOption: [],
      //二级分类
      TwoLevelOption: [],
      //tid
      tID: '',
      moneyBackInfo: {
        bankNo: '',
        acountsName: ''
      },
      // 是否只偿还利息
      isRatioOnly: '否',
      tempMoney: '',
      queryBankAcount: '',
      loanNO: '',
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('borrowedmoney-columns') === 'null'
        || !localStorage.getItem('borrowedmoney-columns')) {
      //设置localStorage
      localStorage.setItem("borrowedmoney-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('borrowedmoney-columns'));
    }
    this.$store.dispatch('money/getTempBorrowedMoneyList')
  },
  computed: {
    TableName() {
      return TableName
    },
    fullLevel() {
      return this.currentSort.levelOne + '-' + this.currentSort.levelTwo;
    },
    ...mapGetters(['tempBorrowedMoneyList'])
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("borrowedmoney-columns", JSON.stringify(newVal))
      },
      deep: true,
    },
    isRatioOnly: {
      handler(val) {
        if (val === '是') {
          this.moneyBackInfo.moneyAmount = ''
        } else {
          this.moneyBackInfo.moneyAmount = this.tempMoney
        }
      }
    }
  },
  methods: {
    listCompany,
    listBankAccount,
    //处理还款的事件函数  这里应该先填写还款信息 然后在还款信息页面申请付款
    handleGiveBackMoney(row) {
      this.giveBackMoneyShow = true;
      // 补充关键字段
      this.moneyBackInfo.loanNO = row.loanNO
    },
    // 添加还款信息
    submitAddBorrowedMoney() {
      addRepayment(this.moneyBackInfo).then(res => {
        this.$message.success('添加成功')
        this.reset()
        this.giveBackMoneyShow = false
      })
    },
    // 还款的自动填充
    handleCommitBackBankAcount(val) {
      this.moneyBackInfo.acountsName = val.acountsName
      this.moneyBackInfo.bankNo = val.bankNo
    },
    handleUpdateQueryBankAcount(val) {
      this.queryBankAcount = val;
    },
    // 添加借入款的自动填充
    handleUpdateQueryBankAcountForm(val) {
      this.queryBankAcount = val;
    },
    handleCommitBackBankAcountForm(val) {
      this.form.bankNo = val.bankNo;
      this.form.acountsName = val.acountsName
    },
    getSummaries(param) {
      const {columns, data} = param;
      const sums = [];
      columns.forEach((column, index) => {
        if (index === 0) {
          sums[index] = '统计';
          return;
        }
        const values = data.map(item => {
          return Number(item[column.property])
        });
        const includes = [2]
        if (!values.every(value => isNaN(value))) {
          if (includes.includes(index)) {
            sums[index] = values.reduce((prev, curr) => {
              const value = Number(curr);
              if (!isNaN(value)) {
                return prev + curr;
              } else {
                return prev;
              }
            }, 0);
            sums[index] += ' ';
          }
        } else {
          sums[index] = '';
        }
      });
      return sums;
    },
    /** 查询从外部借款信息列表 */
    getList() {
      this.loading = true;
      listBorrowedMoney(addDateRange(this.queryParams, this.dateRange)).then(response => {
        this.borrowedMoneyList = response.rows;
        this.borrowedMoneyList.forEach(item => {
          item.isEnd = item.isEnd ? '是' : '否'
        })
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
        loanNO: null,
        origin: null,
        moneyAmount: null,
        ratio: null,
        loanDate: null,
        loanDuring: null,
        mortgageGuarantee: null,
        acountsName: null,
        bankNo: null,
        isEnd: null,
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
      this.title = "添加从外部借款信息";
    },
    /** 点击修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getBorrowedMoney(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改从外部借款信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            //转换
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            this.form = excludeParams(this.form, this.$exclude)
            updateBorrowedMoney(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            //转换
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            this.form.isEnd = 0;
            this.form = excludeParams(this.form, this.$exclude)
            addBorrowedMoney(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除从外部借款信息编号为"' + ids + '"的数据项？').then(function () {
        return delBorrowedMoney(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/borrowedMoney/export', {
        ...this.queryParams
      }, `borrowedMoney_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>

