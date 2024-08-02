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
        <!--  <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
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
          v-hasPermi="['system:payment:add']"
        >新增
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['system:payment:edit']"
        >修改
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:payment:remove']"
        >删除
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:payment:export']"
        >导出
        </el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="paymentList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center"/>
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="付款编号" align="center" prop="payNO"/>
      <el-table-column label="日期" align="center" prop="fundsDate"/>
      <el-table-column label="支付类型" align="center" prop="payType"/>
      <el-table-column label="对应的表名" align="center" prop="tableName"/>
      <el-table-column label="对应的表主键" align="center" prop="tID"/>
      <el-table-column label="金额" align="center" prop="moneyAmount"/>
      <el-table-column label="己方户名" align="center" prop="selfAcountsName"/>
      <el-table-column label="己方账号" align="center" prop="selfBankNo"/>
      <el-table-column label="己方开户行" align="center" prop="selfBankName"/>
      <el-table-column label="己方账号ID" align="center" prop="selfBankID"/>
      <el-table-column label="对方户名" align="center" prop="otherAcountsName"/>
      <el-table-column label="对方账号" align="center" prop="otherBankNo"/>
      <el-table-column label="对方开户行" align="center" prop="otherBankName"/>
      <el-table-column label="支付状态" align="center" prop="paymentState"/>
      <el-table-column label="对方公司" align="center" prop="companyName"/>
      <el-table-column label="对方公司ID" align="center" prop="companyId"/>
      <el-table-column label="对方公司类型" align="center" prop="companyType"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <el-table-column label="添加时间" align="center" prop="addtime"/>
      <el-table-column label="操作人员ID" align="center" prop="userId"/>
      <el-table-column label="操作人员姓名" align="center" prop="UserName"/>
      <el-table-column label="删除标记" align="center" prop="delFlag"/>
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

    <!-- 添加或修改付款信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="付款编号" prop="payNO">
          <el-input v-model="form.payNO" placeholder="请输入付款编号"/>
        </el-form-item>
        <el-form-item label="日期" prop="fundsDate">
          <el-input v-model="form.fundsDate" placeholder="请输入日期"/>
        </el-form-item>
        <el-form-item label="对应的表名" prop="tableName">
          <el-input v-model="form.tableName" placeholder="请输入对应的表名"/>
        </el-form-item>
        <el-form-item label="对应的表主键" prop="tID">
          <el-input v-model="form.tID" placeholder="请输入对应的表主键"/>
        </el-form-item>
        <el-form-item label="金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入金额"/>
        </el-form-item>
        <el-form-item label="己方户名" prop="selfAcountsName">
          <el-input v-model="form.selfAcountsName" placeholder="请输入己方户名"/>
        </el-form-item>
        <el-form-item label="己方账号" prop="selfBankNo">
          <el-input v-model="form.selfBankNo" placeholder="请输入己方账号"/>
        </el-form-item>
        <el-form-item label="己方开户行" prop="selfBankName">
          <el-input v-model="form.selfBankName" placeholder="请输入己方开户行"/>
        </el-form-item>
        <el-form-item label="己方账号ID" prop="selfBankID">
          <el-input v-model="form.selfBankID" placeholder="请输入己方账号ID"/>
        </el-form-item>
        <el-form-item label="对方户名" prop="otherAcountsName">
          <el-input v-model="form.otherAcountsName" placeholder="请输入对方户名"/>
        </el-form-item>
        <el-form-item label="对方账号" prop="otherBankNo">
          <el-input v-model="form.otherBankNo" placeholder="请输入对方账号"/>
        </el-form-item>
        <el-form-item label="对方开户行" prop="otherBankName">
          <el-input v-model="form.otherBankName" placeholder="请输入对方开户行"/>
        </el-form-item>
        <el-form-item label="支付状态" prop="paymentState">
          <el-input v-model="form.paymentState" placeholder="请输入支付状态"/>
        </el-form-item>
        <el-form-item label="对方公司" prop="companyName">
          <el-input v-model="form.companyName" placeholder="请输入对方公司"/>
        </el-form-item>
        <el-form-item label="对方公司ID" prop="companyId">
          <el-input v-model="form.companyId" placeholder="请输入对方公司ID"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注"/>
        </el-form-item>
        <el-form-item label="添加时间" prop="addtime">
          <el-input v-model="form.addtime" placeholder="请输入添加时间"/>
        </el-form-item>
        <el-form-item label="操作人员ID" prop="userId">
          <el-input v-model="form.userId" placeholder="请输入操作人员ID"/>
        </el-form-item>
        <el-form-item label="操作人员姓名" prop="UserName">
          <el-input v-model="form.UserName" placeholder="请输入操作人员姓名"/>
        </el-form-item>
        <el-form-item label="删除标记" prop="delFlag">
          <el-input v-model="form.delFlag" placeholder="请输入删除标记"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {listPayment, getPayment, delPayment, addPayment, updatePayment} from "@/api/system/payment";

export default {
  name: "Payment",
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
      // 付款信息表格数据
      paymentList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
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
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      //顶部筛选框
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
  methods: {
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
