<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="类型" prop="acountsType">
        <el-select v-model="queryParams.acountsType" placeholder="请选择">
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="户名" prop="acountsName">
        <el-input
          v-model="queryParams.acountsName"
          placeholder="请输入户名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="银行账号" prop="bankNo">
        <el-input
          v-model="queryParams.bankNo"
          placeholder="请输入银行账号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:bankaccount:add']">新增银行卡信息
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          size="mini"
          @click="handleTransformBank"
        >内部转账
        </el-button>
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
              v-hasPermi="['system:bankaccount:export']">
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <!-- 打印内容 -->
    <el-table border v-loading="loading" :data="bankAccountList" @selection-change="handleSelectionChange"
              id="printBox" height="450px" v-horizontal-scroll="'always'" size="mini"
              :cell-style="()=>{return {padding:'.5px'}}">
      <el-table-column label="绑定状态" align="center" width="200">
        <template slot-scope="scope">
          <span v-if="scope.row.companyId === 0" style="color:#138fe1">
            己方公司银行卡
          </span>
          <span v-else-if="scope.row.companyId === -1" style="color:#ff5722">
            该卡未被绑定
          </span>
          <span v-else>
            已绑定
          </span>
        </template>
      </el-table-column>
      <el-table-column label="账户类型" align="center" prop="acountsType" v-if="columns[0].visible" width="200"/>
      <el-table-column label="开户名称" align="center" prop="acountsName" v-if="columns[1].visible" width="200"/>
      <el-table-column label="银行账号" align="center" prop="bankNo" v-if="columns[2].visible" width="200"/>
      <el-table-column label="开户行" align="center" prop="bankName" v-if="columns[3].visible" width="200"/>
      <el-table-column label="公司名称" align="center" prop="companyName" v-if="columns[4].visible" width="200"/>
      <el-table-column label="余额" align="center" prop="amount" v-if="columns[5].visible" width="200"/>
      <el-table-column label="银行卡操作" align="center" class-name="small-padding fixed-width" width="200"
                       fixed="right">
        <template slot-scope="scope">
          <el-row>
            <el-button
              size="mini"
              type="text"
              @click="checkBankChangeFlow(scope.row)">变动流水
            </el-button>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="行操作" align="center" class-name="small-padding fixed-width" fixed="right">
        <template slot-scope="scope">
          <el-row>
            <el-button
              size="mini"
              type="primary"
              @click="handleUpdate(scope.row)"
              v-hasPermi="['system:bankaccount:edit']">编辑
            </el-button>
            <el-button
              size="mini"
              type="danger"
              @click="handleDelete(scope.row)"
              v-hasPermi="['system:bankaccount:remove']">删除
            </el-button>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"/>

    <!-- 添加或修改银行账号对话框 -->
    <el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="500px"
               append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="账号类型" prop="acountsType">
          <el-select v-model="form.acountsType" placeholder="请选择账号类型">
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="户名" prop="acountsName">
          <!--          如果是司机 那么就选择-->
          <el-row v-if="form.acountsType ==='司机'">
            <el-col :span="20">
              <el-input v-model="form.acountsName" placeholder="请输入户名"/>
            </el-col>
            <el-col :span="4">
              <el-tooltip content="选择已经添加过的账户" placement="top">
                <SearchOption :limit-info="{}"
                              :get-data="listCars" query-info="carNo"
                              query-label="车牌查找" :query-name="queryBankAccount"
                              @update:queryName="handleUpdateBankAccount" @commitBack="handleCommitBackBankAccount">
                  <template #table-columns>
                    <el-table-column label="司机" align="center"
                                     prop="driver"/>
                    <el-table-column label="车牌号" align="center" prop="carNo"/>
                    <el-table-column label="司机电话" align="center" prop="tel"/>
                    <el-table-column label="开户名" align="center" prop="acountsName"/>
                    <el-table-column label="账号" align="center" prop="bankNo"/>
                    <el-table-column label="开户行" align="center" prop="bankName"/>
                    <el-table-column label="运输方式" align="center" prop="carType"/>
                  </template>
                </SearchOption>
              </el-tooltip>
            </el-col>
          </el-row>
          <el-row v-else>
            <el-input v-model="form.acountsName" placeholder="请输入户名"/>
          </el-row>
        </el-form-item>
        <el-form-item label="公司名称" prop="companyName" v-if="isNeed">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.companyName" placeholder="请输入公司名称"/>
            </el-col>
            <!-- 供应商信息搜索-->
            <el-col :span="2" v-if="form.acountsType === '供应商'">
              <SearchOption :limit-info="{companyType:'供应商'}" :get-data="listCompany"
                            @commitBack="handleCommitBackCompanyGive" @update:queryName="handleQueryCompanyGive">
                <template #table-columns>
                  <el-table-column label="供应商" align="center" prop="companyName"/>
                  <el-table-column label="地址" align="center" prop="address"/>
                </template>
              </SearchOption>
            </el-col>
            <!-- 客户信息搜索-->
            <el-col :span="2" v-if="form.acountsType === '客户'">
              <SearchOption :limit-info="{companyType:'客户'}" :get-data="listCompany"
                            @commitBack="handleCommitBackCompany" @update:queryName="handleQueryCompany">
                <template #table-columns>
                  <el-table-column label="客户" align="center" prop="relationName"/>
                  <el-table-column label="老板姓名" align="center" prop="leader"/>
                  <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                  <el-table-column label="公司名称" align="center" prop="companyName"/>
                  <el-table-column label="销售经理" align="center" prop="salesManager"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="银行账号" prop="bankNo">
          <el-input v-model="form.bankNo" placeholder="请输入银行账号"/>
        </el-form-item>
        <el-form-item label="开户行" prop="bankName">
          <el-input v-model="form.bankName" placeholder="请输入开户行"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>


    <!-- 调整银行卡对话框 -->
    <el-dialog :close-on-click-modal="false" :show-close="false" title="调整银行卡信息" :visible.sync="Adjustment"
               width="500px" append-to-body>
      <el-form ref="form" :model="adjustmentInfo" :rules="rules" label-width="80px">
        <el-form-item label="变动类型" prop="changeType">
          <el-radio v-model="adjustmentInfo.changeType" label="收入">收入</el-radio>
          <el-radio v-model="adjustmentInfo.changeType" label="支出">支出</el-radio>
        </el-form-item>
        <el-form-item label="金额" prop="moneyAmount">
          <el-input v-model="adjustmentInfo.moneyAmount" placeholder="请输入金额"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="adjustmentInfo.comments" placeholder="请输入备注"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitAdjustmentInfo">确 定</el-button>
        <el-button @click="Adjustment = false">取 消</el-button>
      </div>
    </el-dialog>


    <!--    银行卡之间转账-->
    <el-dialog :close-on-click-modal="false" :show-close="false" title="银行卡转账"
               :visible.sync="transformDialogVisible" width="500px" append-to-body>
      <el-row>
        <el-form :model="transformInfo" label-width="100px">
          <el-form-item label="转账银行卡" prop="fromBankNo">
            <el-input v-model="transformInfo.fromBankNo" placeholder="请输入转账银行卡"/>
          </el-form-item>
          <el-form-item label="目标银行卡" prop="toBankNo">
            <el-input v-model="transformInfo.toBankNo" placeholder="请输入目标银行卡"/>
          </el-form-item>
          <el-form-item label="转账金额" prop="money">
            <el-input v-model="transformInfo.money" placeholder="请输入转账金额"/>
          </el-form-item>
        </el-form>
      </el-row>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitTransformBank">确 定</el-button>
        <el-button @click="transformDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>


    <!--    银行卡流水-->
    <el-dialog :close-on-click-modal="false" :show-close="false" title="银行卡流水"
               :visible.sync="bankChangeDialogVisible" width="55%" append-to-body>
      <el-row>
        <div>
          <el-form :model="bankAcountQuery" label-width="80px">
            <el-col :span="4">
              <el-form-item label="日期" prop="operateDate">
                <el-date-picker
                  v-model="bankAcountQuery.operateDate"
                  type="date"
                  value-format="yyyy-MM-dd"
                  placeholder="日期"
                  style="width: 140px"
                />
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item>
                <el-button type="primary" @click="getBankAcountChangeList" size="mini">
                  搜索
                </el-button>
              </el-form-item>
            </el-col>
          </el-form>
        </div>
        <el-table
          :data="bankChangeList"
          style="width: 100%">
          <el-table-column
            prop="selfBankNo"
            label="己方账号"
            width="180">
          </el-table-column>
          <el-table-column
            prop="operateDate"
            label="日期"
            width="180">
          </el-table-column>
          <el-table-column
            prop="changeType"
            label="变动类型">
          </el-table-column>
          <el-table-column
            prop="moneyAmount"
            label="金额">
          </el-table-column>
        </el-table>
        <pagination
          v-show="bankAcountTotal>0"
          :total="bankAcountTotal"
          :page.sync="bankAcountQuery.bankAcountTotalPageNum"
          :limit.sync="bankAcountQuery.bankAcountTotalPageSize"
          @pagination="getBankAcountChangeList"/>
      </el-row>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitBankChange">确 定</el-button>
        <el-button @click="bankChangeDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  getBankAccount,
  delBankAccount,
  addBankAccount,
  updateBankAccount, transfer
} from "@/api/system/bankAccount";
import {listCompany} from "@/api/system/company";
import SearchOption from "@/components/SearchOption.vue";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {addBankAccountChange, listBankAccountChange} from "@/api/system/bankAccountChange";
import {addReason} from "@/api/system/user";
import {TableName} from "@/api/tool/enums";
import {parseTime} from "@/utils/ruoyi";
import {listBankAccount} from "../../../api/system/bankAccount";
import {listCars} from "../../../api/system/cars";
import {excludeParams} from "../../../api/tool/exclude";

export default {
  name: "BankAccount",
  components: {SearchOption},
  mixins: [mixin_printHTML],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      bankAccountList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        companyName: null,
        companyId: null,
        bankName: null,
        acountsName: null,
        bankNo: null,
        acountsType: null,
        amount: null,
        comments: null,
        delFlag: null
      },
      //查询供应商
      queryParamsCompany: {
        pageNum: 1,
        pageSize: 10,
        companyName: null,
        relationName: null,
        relationTel: null,
        address: null,
        bankName: null,
        acountsName: null,
        bankNo: null,
        surplusMoney: null,
        companyType: null,
        salesman: null,
        leader: null,
        leaderTel: null,
        salesManager: null,
        province: null,
        city: null,
        county: null,
        comments: null,
      },
      // 表单参数
      form: {
        bankNo: '',
        bankName: '',
        acountsName: '',
        companyName: '',
        acountsType: ''
      },
      // 表单校验
      rules: {
        bankNo: [
          {required: true, message: "银行账号不能为空", trigger: "blur"}
        ],
        bankName: [
          {required: true, message: "开户行不能为空", trigger: "blur"}
        ],
        acountsName: [
          {required: true, message: "账户名称不能为空", trigger: "blur"}
        ],
        acountsType: [
          {required: true, message: "账户类型不能为空", trigger: "blur"}
        ],
        companyName: [
          {required: true, message: "公司名称不能为空", trigger: "blur"}
        ],
        companyType: [
          {required: true, message: "公司类型不能为空", trigger: "blur"}
        ],
      },
      options: [
        {
          value: '己方公司',
          label: '己方公司'
        }, {
          value: '客户',
          label: '客户'
        }, {
          value: '供应商',
          label: '供应商'
        }, {
          value: '司机',
          label: '司机'
        }, {
          value: '其它',
          label: '其它'
        }
      ],
      //隐藏列信息
      columns: [
        {key: 0, label: `账户类型`, visible: true},
        {key: 1, label: `开户名称`, visible: true},
        {key: 2, label: `账号(银行卡号)`, visible: true},
        {key: 3, label: `开户行`, visible: true},
        {key: 4, label: `公司名称`, visible: true},
        {key: 5, label: `余额`, visible: true}
      ],
      companyList: [],
      //调整银行卡
      Adjustment: false,
      adjustmentInfo: {},
      AdjustInfo: {},
      //银行卡之间转账
      transformDialogVisible: false,
      transformInfo: {
        fromBankNo: null,
        toBankNo: null,
        money: null
      },
      //银行卡流水
      bankChangeDialogVisible: false,
      bankChangeList: [],
      currentBankNo: '',
      bankAcountQuery: {
        bankAcountTotalPageNum: 10,
        bankAcountTotalPageSize: 1,
        operateDate: null,
      },
      bankAcountTotal: 0,
      //供应商搜索组件
      queryCompanyGive: '',
      queryCompany: '',
      // 银行卡搜索组件
      queryBankAccount: '',
    };
  },
  created() {
    this.getList();
    this.getCompanyInfo()
    if (localStorage.getItem('bankaccount-columns') === 'null'
      || !localStorage.getItem('bankaccount-columns')) {
      localStorage.setItem("bankaccount-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('bankaccount-columns'));
    }
  },
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("bankaccount-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  computed: {
    //是否是己方公司
    isNeed() {
      return this.form.acountsType !== '己方公司' && this.form.acountsType !== '司机'
    }
  },
  methods: {
    listCars,
    listBankAccount,
    listCompany,
    //1.银行卡之间转账
    handleTransformBank() {
      this.transformDialogVisible = true
    },
    submitTransformBank() {
      transfer(this.transformInfo).then(res => {
        this.$message.success('转账成功~')
        this.transformDialogVisible = false
      })
    },
    //2.查询客户 供应商信息
    getCompanyInfo() {
      listCompany(this.queryParamsCompany).then(res => {
        this.companyList = res.rows;
      })
    },

    //3. todo 银行卡变动流水
    checkBankChangeFlow(row) {
      this.currentBankNo = row.bankNo;
      // 查询该银行账号的变动流水
      listBankAccountChange({selfBankNo: row.bankNo}).then(res => {
        this.bankChangeList = res.rows;
        this.bankAcountTotal = res.total;
      })
      this.bankChangeDialogVisible = true;
    },
    // 分页的请求
    getBankAcountChangeList() {
      listBankAccountChange({
        selfBankNo: this.currentBankNo,
        pageNum: this.bankAcountQuery.bankAcountTotalPageNum,
        pageSize: this.bankAcountQuery.bankAcountTotalPageSize,
        ...this.bankAcountQuery
      }).then(res => {
        this.bankChangeList = res.rows;
        this.bankAcountTotal = res.total;
      })
    },
    submitBankChange() {
      this.bankChangeDialogVisible = false
    },

    //搜索供应商信息的回调
    handleCommitBackCompanyGive(val) {
      this.form.companyName = val.companyName;
      this.form.companyId = val.id;
    },
    handleCommitBackCompany(val) {
      this.form.companyName = val.companyName;
      this.form.companyId = val.id;
    },
    handleQueryCompanyGive(value) {
      this.queryCompanyGive = value;
    },
    handleQueryCompany(value) {
      this.queryCompany = value;
    },
    // 搜索银行卡信息
    handleCommitBackBankAccount(val) {
      this.form.acountsName = val.acountsName;
      this.form.companyId = val.id;
      this.form.companyType = '司机';
      // 司机信息公司默认给的是司机
      this.form.companyName = '司机'
    },
    handleUpdateBankAccount(val) {
      this.queryBankAccount = val;
    },
    //调整银行卡
    submitAdjustmentInfo() {
      const {bankNo} = this.AdjustInfo;
      addBankAccountChange({selfBankNo: bankNo, payNO: '手动调整', ...this.adjustmentInfo}).then(res => {
        this.$message.success('调整成功~')
        this.Adjustment = false;
        this.getList()
      })
    },
    /** 查询银行账号列表 */
    getList() {
      this.loading = true;
      listBankAccount(this.queryParams).then(response => {
        this.bankAccountList = response.rows;
        console.log(response)
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
        companyName: null,
        companyId: null,
        bankName: null,
        acountsName: null,
        bankNo: null,
        acountsType: null,
        amount: null,
        comments: null,
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
      this.title = "新增银行卡信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getBankAccount(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改银行卡信息";
      });
    },

    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            this.form = excludeParams(this.form, this.$exclude)
            updateBankAccount(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form = excludeParams(this.form, this.$exclude)
            // 如果是其他类型，那么就设置companyId为-1
            if (this.form.acountsType === '己方公司') {
              this.form.companyId = 0
            } else {
              this.form.companyId = -1
            }
            addBankAccount(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除银行账号编号为"' + ids + '"的数据项？').then(function () {
        return delBankAccount(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/bankAccount/export', {
        ...this.queryParams
      }, `bankAccount_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
