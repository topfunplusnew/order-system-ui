<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="加油卡卡号" prop="oilCardNo">
        <el-input
          v-model="queryParams.oilCardNo"
          placeholder="请输入加油卡卡号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="充值时间" prop="rechargeDate">
        <el-date-picker
          v-model="queryParams.rechargeDate"
          type="date"
          placeholder="选择充值时间" value-format="timestamp">
        </el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:oilrecharge:add']"
        >新增加油卡充值信息
        </el-button>
      </el-col>
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
              v-hasPermi="['system:inventory:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="oilRechargeList" @selection-change="handleSelectionChange"
              v-horizontal-scroll="'always'" id="printBox">
      <el-table-column label="id" align="center" prop="id"/>
      <!--      <el-table-column label="出差编号UUID" align="center" prop="bTripId"/>-->
      <el-table-column label="加油卡卡号" align="center" prop="oilCardNo"/>
      <el-table-column label="充值类型" align="center" prop="rechargeType"/>
      <el-table-column label="充值金额" align="center" prop="rechargeMoney"/>
      <el-table-column label="充值时间" align="center" prop="rechargeDate"/>
      <el-table-column label="银行开户名" align="center" prop="acountsName"/>
      <el-table-column label="银行账号" align="center" prop="bankNo"/>
      <el-table-column label="充值人员姓名" align="center" prop="rechargeName"/>
      <el-table-column label="充值附件" align="center" prop="attachment"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right"
                       width="150px">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="warning"
            @click="addPaymentApply(scope.row)"
          >申请付款
          </el-button>
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:oilrecharge:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:oilrecharge:remove']"
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

    <!-- 添加或修改加油卡充值信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <!--        <el-form-item label="出差编号UUID" prop="bTripId">-->
        <!--          <el-input v-model="form.bTripId" placeholder="请输入出差编号UUID"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="加油卡卡号" prop="oilCardNo">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.oilCardNo" placeholder="请输入加油卡卡号"/>
            </el-col>
            <el-col :span="4">
              <SearchOption :get-data="listOilCard" @commitBack="handleCommitBackOilCard" query-info="oilCardNo"
                            :query-name="queryOilCard" query-label="油卡账号查询"
                            @update:queryName="handleCommitBackQueryOilCard" :limit-info="{oilType:'主卡'}">
                <template #table-columns>
                  <el-table-column label="加油卡卡号" align="center" prop="oilCardNo"/>
                  <el-table-column label="当前金额" align="center" prop="moneyAmount"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="充值金额" prop="rechargeMoney">
          <el-input v-model="form.rechargeMoney" placeholder="请输入充值金额"/>
        </el-form-item>
        <el-form-item label="银行开户名" prop="acountsName">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.acountsName" placeholder="请输入银行开户名"/>
            </el-col>
            <el-col :span="4">
              <SearchOption :get-data="listBankAccount" @commitBack="handleCommitBackBank" query-info="acountsName"
                            :query-name="queryBank" query-label="户名查询"
                            @update:queryName="handleCommitBackQueryBank" :limit-info="{}">
                <template #table-columns>
                  <el-table-column label="账户类型" align="center" prop="acountsType"/>
                  <el-table-column label="开户名称(户名)" align="center" prop="acountsName"/>
                  <el-table-column label="账号(银行账号)" align="center" prop="bankNo"/>
                  <el-table-column label="开户行" align="center" prop="bankName"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="银行账号" prop="bankNo">
          <el-input v-model="form.bankNo" placeholder="请输入银行账号"/>
        </el-form-item>
        <el-form-item label="充值人员姓名" prop="rechargeName">
          <el-input v-model="form.rechargeName" placeholder="请输入充值人员姓名"/>
        </el-form-item>
        <el-form-item label="充值附件" prop="attachment">
          <!--          <el-input v-model="form.attachment" placeholder="请输入充值附件"/>-->
          <file-upload @input="handleUpload"/>
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


    <!--    加油卡付款申请-->
    <el-dialog title="加油卡付款申请" :visible.sync="paymentApplyVisible" width="500px" append-to-body>
      <ApplyPayment :table-name="TableName.OIL_RECHARGE" :t-i-d="tid" :need-money="needMoney"
                    :need-info="{...needInfo,otherAcountsName:needInfo.acountsName}"
                    @changeOpen="paymentApplyVisible = false"/>
    </el-dialog>
  </div>
</template>

<script>
import {
  addOilRecharge,
  delOilRecharge,
  getOilRecharge,
  listOilRecharge,
  updateOilRecharge
} from "@/api/system/oilRecharge";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import ApplyPayment from "@/components/ApplyPayment.vue";
import {TableName} from "@/api/tool/enums";
import SearchOption from "@/components/SearchOption.vue";
import {listOilCard} from "@/api/system/oilCard";
import {listBankAccount} from "@/api/system/bankAccount";

export default {
  name: "OilRecharge",
  computed: {
    TableName() {
      return TableName
    }
  },
  components: {SearchOption, ApplyPayment},
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
      // 加油卡充值信息表格数据
      oilRechargeList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        bTripId: null,
        oilCardNo: null,
        rechargeType: null,
        rechargeMoney: null,
        rechargeDate: new Date().getTime(),
        acountsName: null,
        bankNo: null,
        rechargeName: null,
        attachment: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {
        rechargeDate: new Date().getTime()
      },
      // 表单校验
      rules: {},
      columns: [
        {key: 0, label: `id`, visible: true},
        {key: 1, label: `仓库名称`, visible: true},
        {key: 2, label: `入库日期`, visible: true},
        {key: 3, label: `库存量`, visible: true},
        {key: 4, label: `供应商`, visible: true},
        {key: 5, label: `级别编码`, visible: true},
        {key: 6, label: `级别名称`, visible: true},
        {key: 7, label: `计量单位`, visible: true},
        {key: 8, label: `厚度`, visible: true},
        {key: 9, label: `长度`, visible: true},
        {key: 10, label: `宽度`, visible: true},
        {key: 11, label: `出厂片数`, visible: true},
        {key: 12, label: `每包片数`, visible: true},
        {key: 13, label: `包数`, visible: true},
        {key: 14, label: `出厂单价`, visible: true},
        {key: 15, label: `出厂是否含税`, visible: true},
        {key: 16, label: `杂费`, visible: true},
        {key: 17, label: `出厂贷款`, visible: true},
        {key: 18, label: `卸货价`, visible: true},
        {key: 19, label: `销售是否含税`, visible: true},
        {key: 20, label: `总货款`, visible: true},
        {key: 21, label: `陆运车牌`, visible: true},
        {key: 22, label: `陆运司机姓名`, visible: true},
        {key: 23, label: `陆运司机电话`, visible: true},
        {key: 24, label: `误差`, visible: true},
        {key: 25, label: `吨位`, visible: true},
        {key: 26, label: `陆运费单价`, visible: true},
        {key: 27, label: `陆运费`, visible: true},
        {key: 28, label: `其他费用`, visible: true},
        {key: 29, label: `利润`, visible: true},
        {key: 30, label: `不含利润率`, visible: true},
        {key: 31, label: `实际片数`, visible: true},
        {key: 32, label: `总贷款杂费`, visible: true},
        {key: 33, label: `加费`, visible: true},
        {key: 34, label: `返利金额`, visible: true},
        {key: 35, label: `客户佣金`, visible: true},
        {key: 36, label: `备注`, visible: true},
      ],
      tid: '',
      paymentApplyVisible: false,
      needMoney: 0,
      needInfo: {},
      queryOilCard: '',
      queryBank: ''
    };
  },
  created() {
    this.getList();
    this.resetQuery();
  },
  methods: {
    listBankAccount,
    listOilCard,
    //主卡
    handleCommitBackOilCard(val) {
      this.form.oilCardNo = val.oilCardNo;
    },
    handleCommitBackQueryOilCard(val) {
      this.queryOilCard = val;
    },
    //银行卡
    handleCommitBackBank(val) {
      this.form.acountsName = val.acountsName;
      this.form.bankNo = val.bankNo;
    },
    handleCommitBackQueryBank(val) {
      this.queryBank = val
    },
    //加油卡付款申请
    addPaymentApply(row) {
      this.tid = row.id;
      this.needMoney = row.rechargeMoney;
      this.needInfo = row;
      this.paymentApplyVisible = true;
    },
    handleUpload(val) {
      this.form.attachment = val;
    },
    /** 查询加油卡充值信息列表 */
    getList() {
      this.loading = true;
      listOilRecharge(this.queryParams).then(response => {
        this.oilRechargeList = response.rows;
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
        bTripId: null,
        oilCardNo: null,
        rechargeType: null,
        rechargeMoney: null,
        rechargeDate: null,
        acountsName: null,
        bankNo: null,
        rechargeName: null,
        attachment: null,
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
      this.title = "添加加油卡充值信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getOilRecharge(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改加油卡充值信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateOilRecharge(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addOilRecharge(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除加油卡充值信息编号为"' + ids + '"的数据项？').then(function () {
        return delOilRecharge(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/oilRecharge/export', {
        ...this.queryParams
      }, `oilRecharge_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
