<template>
  <div class="app-container">
    <el-form :model="queryPayment" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="120px">
      <el-form-item label="开始时间" prop="beginTime">
        <el-date-picker
          v-model="queryParams.beginTime"
          type="date"
          value-format="yyyy-MM-dd" class="w-85px">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="结束时间" prop="endTime">
        <el-date-picker
          v-model="queryParams.endTime"
          type="date"
          value-format="yyyy-MM-dd" class="w-85px">
        </el-date-picker>
      </el-form-item>
      <!--      客户还是供应商-->
      <el-form-item label="对象类型" prop="companyType">
        <el-select v-model="queryParams.companyType" placeholder="请选择对象类型" class="w-85px">
          <el-option
            v-for="item in options_companyType"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="支付类型" prop="payType">
        <el-select v-model="queryParams.payType" placeholder="请选择支付类型" class="w-85px">
          <el-option
            v-for="item in options_payType"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="日常费用类目" prop="selfAcountsName">
        <el-input
          v-model="queryParams.selfAcountsName"
          placeholder="请输入己方户名"
          clearable
          @keyup.enter.native="handleQuery" class="w-85px"
        />
      </el-form-item>
      <el-form-item label="供应商/客户/车牌" prop="selfBankNo">
        <el-input
          v-model="queryParams.selfBankNo"
          placeholder="请输入己方账号"
          clearable
          @keyup.enter.native="handleQuery" class="w-85px"
        />
      </el-form-item>
      <el-form-item label="户名" prop="selfBankName">
        <el-input
          v-model="queryParams.selfBankName"
          placeholder="请输入己方开户行"
          clearable
          @keyup.enter.native="handleQuery" class="w-85px"
        />
      </el-form-item>
      <el-form-item label="对方银行卡号" prop="selfBankID">
        <el-input
          v-model="queryParams.selfBankID"
          placeholder="请输入己方账号ID"
          clearable
          @keyup.enter.native="handleQuery" class="w-85px"
        />
      </el-form-item>
      <el-form-item label="对方户名" prop="otherAcountsName">
        <el-input
          v-model="queryParams.otherAcountsName"
          placeholder="请输入对方户名"
          clearable
          @keyup.enter.native="handleQuery" class="w-85px"
        />
      </el-form-item>
      <el-form-item label="备注" prop="otherBankNo">
        <el-input
          v-model="queryParams.otherBankNo"
          placeholder="请输入对方账号"
          clearable
          @keyup.enter.native="handleQuery" class="w-85px"
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
              v-hasPermi="['system:bankaccount:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="paymentList" @selection-change="handleSelectionChange" id="printBox"
              v-horizontal-scroll="'always'">
      <el-table-column label="id" align="center" prop="id" v-if="columns[0].visible"/>
      <el-table-column label="日期" align="center" prop="fundsDate" v-if="columns[2].visible"/>
      <el-table-column label="支付类型" align="center" prop="payType" v-if="columns[3].visible"/>
      <el-table-column label="金额" align="center" prop="moneyAmount" v-if="columns[6].visible"/>
      <el-table-column label="己方户名" align="center" prop="selfAcountsName" v-if="columns[7].visible"/>
      <el-table-column label="己方账号" align="center" prop="selfBankNo" v-if="columns[8].visible"/>
      <el-table-column label="己方开户行" align="center" prop="selfBankName" v-if="columns[9].visible"/>
      <el-table-column label="对方户名" align="center" prop="otherAcountsName" v-if="columns[11].visible"/>
      <el-table-column label="对方账号" align="center" prop="otherBankNo" v-if="columns[12].visible"/>
      <el-table-column label="对方开户行" align="center" prop="otherBankName" v-if="columns[13].visible"/>
      <el-table-column label="支付状态" align="center" prop="paymentState" v-if="columns[14].visible"/>
      <el-table-column label="对方公司" align="center" prop="companyName" v-if="columns[15].visible"/>
      <el-table-column label="对方公司类型" align="center" prop="companyType" v-if="columns[17].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="100px">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:payment:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:payment:remove']"
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
  </div>
</template>

<script>
import {listPayment, getPayment, delPayment, addPayment, updatePayment} from "@/api/system/payment";
import SearchOption from "@/components/SearchOption.vue";
import {listCompany} from "@/api/system/company";

export default {
  name: "Payment",
  components: {SearchOption},
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      paymentList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        payNO: null,
        fundsDate: null,
        payType: null,
        tableName: null,
        tID: null,
        moneyAmount: null,
        selfAcountsName: null,
        selfBankNo: null,
        selfBankName: null,
        selfBankID: null,
        otherAcountsName: null,
        otherBankNo: null,
        otherBankName: null,
        paymentState: null,
        companyName: null,
        companyId: null,
        companyType: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      form: {},
      rules: {},
      columns: [
        {key: 0, label: ` id`, visible: true},
        {key: 1, label: `付款编号`, visible: true},
        {key: 2, label: `日期`, visible: true},
        {key: 3, label: `支付类型`, visible: true},
        {key: 4, label: `对应的表名`, visible: true},
        {key: 5, label: `对应的表主键`, visible: true},
        {key: 6, label: `金额`, visible: true},
        {key: 7, label: `己方户名`, visible: true},
        {key: 8, label: `己方账号`, visible: true},
        {key: 9, label: `己方开户行`, visible: true},
        {key: 10, label: `己方账号ID`, visible: false},
        {key: 11, label: `对方户名`, visible: true},
        {key: 12, label: `对方账号`, visible: true},
        {key: 13, label: `对方开户行`, visible: true},
        {key: 14, label: `对方公司`, visible: true},
        {key: 15, label: `支付状态`, visible: true},
        {key: 16, label: `对方公司`, visible: true},
        {key: 17, label: `对方公司ID`, visible: false},
        {key: 18, label: `对方公司类型`, visible: true},
      ],
      queryPayment: {},
      options_companyType: [
        {
          value: '客户',
          label: '客户'
        }, {
          value: '供应商',
          label: '供应商'
        }, {
          value: '司机',
          label: '司机'
        }, {
          value: '个人',
          label: '个人'
        }, {
          value: '其他',
          label: '其他'
        },
      ],
      options_payType: [
        {
          value: '票点',
          label: '票点'
        }, {
          value: '工资和社保和公积金',
          label: '工资和社保和公积金'
        }, {
          value: '委托在加工出库',
          label: '委托在加工出库'
        }, {
          value: '(供应商暂存)平账',
          label: '(供应商暂存)平账'
        }, {
          value: '日常费用报销',
          label: '日常费用报销'
        }, {
          value: '销售玻璃贷款',
          label: '销售玻璃贷款'
        }, {
          value: '票点',
          label: '票点'
        }, {
          value: '承兑贴现',
          label: '承兑贴现'
        }, {
          value: '公司贷款',
          label: '公司贷款'
        }, {
          value: '内部往来转账收入',
          label: '内部往来转账收入'
        }, {
          value: '委托再加工入库',
          label: '委托再加工入库'
        }, {
          value: '(客户暂存)平账',
          label: '(客户暂存)平账'
        }, {
          value: '其他收入',
          label: '其他收入'
        }
      ]
    };
  },
  created() {
    this.getList();
  },
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("payment-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  methods: {
    listCompany,
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    /** 查询付款信息列表 */
    getList() {
      this.loading = true;
      listPayment(this.queryParams).then(response => {
        this.paymentList = response.rows;
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
        payNO: null,
        fundsDate: null,
        payType: null,
        tableName: null,
        tID: null,
        moneyAmount: null,
        selfAcountsName: null,
        selfBankNo: null,
        selfBankName: null,
        selfBankID: null,
        otherAcountsName: null,
        otherBankNo: null,
        otherBankName: null,
        paymentState: null,
        companyName: null,
        companyId: null,
        companyType: null,
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
      this.title = "添加付款信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getPayment(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改付款信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updatePayment(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addPayment(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除付款信息编号为"' + ids + '"的数据项？').then(function () {
        return delPayment(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/payment/export', {
        ...this.queryParams
      }, `payment_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
<style scoped>
.w-85px {
  width: 85px;
}
</style>
