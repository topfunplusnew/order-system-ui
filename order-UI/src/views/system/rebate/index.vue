<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="返利开始日期" prop="rebateStartTime">
        <el-date-picker
          v-model="queryParams.rebateStartTime"
          type="date"
          placeholder="选择开始时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="返利结束日期" prop="rebateEndTime">
        <el-date-picker
          v-model="queryParams.rebateEndTime"
          type="date"
          placeholder="选择开始时间">
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
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <!--        <el-form-item label="订单编号" prop="ordersNo">-->
        <!--          <el-input v-model="form.ordersNo" placeholder="请输入订单编号"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="日期" prop="rebateDate">
          <el-input v-model="form.rebateDate" placeholder="请输入日期"/>
        </el-form-item>
        <el-form-item label="金额" prop="rebate">
          <el-input v-model="form.rebate" placeholder="请输入金额"/>
        </el-form-item>
        <el-form-item label="收款户名" prop="inAcountsName">
          <el-input v-model="form.inAcountsName" placeholder="请输入收款户名"/>
        </el-form-item>
        <el-form-item label="收款账号" prop="inBankNo">
          <el-input v-model="form.inBankNo" placeholder="请输入收款账号"/>
        </el-form-item>
        <el-form-item label="供应商" prop="supplier">
          <el-input v-model="form.supplier" placeholder="请输入供应商"/>
        </el-form-item>
        <!--        <el-form-item label="供应商ID" prop="supplierID">-->
        <!--          <el-input v-model="form.supplierID" placeholder="请输入供应商ID"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="付款户名" prop="outAcountsName">
          <el-input v-model="form.outAcountsName" placeholder="请输入付款户名"/>
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
  </div>
</template>

<script>
import {listRebate, getRebate, delRebate, addRebate, updateRebate} from "@/api/system/Rebate";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import ApplyPayment from "@/components/ApplyPayment.vue";
import {TableName} from "@/api/tool/enums";

export default {
  name: "Rebate",
  computed: {
    TableName() {
      return TableName
    }
  },
  components: {ApplyPayment},
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
      // 表单校验
      rules: {},
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
      needMoney: 0
    };
  },
  created() {
    this.getList();
  },
  methods: {
    addPaymentApply(row) {
      this.tid = row.id;
      this.paymentApplyVisible = true;
      this.needMoney = row.rebate;
      this.needInfo = row;
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
