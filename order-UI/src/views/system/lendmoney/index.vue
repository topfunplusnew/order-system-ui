<!--向外借钱-->
<template>
  <div class="app-container">
    <el-form :model="timesQuery" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="开始时间" prop="beginTime">
        <el-date-picker
          v-model="timesQuery.beginTime"
          type="date"
          placeholder="请选择开始时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="结束时间" prop="endTime">
        <el-date-picker
          v-model="timesQuery.endTime"
          type="date"
          placeholder="请选择结束时间">
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
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="借出款编号" align="center" prop="futuresNO" v-if="columns[0].visible"/>
      <el-table-column label="期货保证金公司" align="center" prop="futuresMarginCompany" v-if="columns[1].visible"/>
      <el-table-column label="对象类型(员工、客户、供应商、其他)" align="center" prop="targetType"
                       v-if="columns[2].visible"/>
      <el-table-column label="对象(员工姓名、公司名称)" align="center" prop="target" v-if="columns[3].visible"/>
      <el-table-column label="保证金金额" align="center" prop="moneyAmount" v-if="columns[4].visible"/>
      <el-table-column label="对方账户" align="center" prop="targetAcountsName" v-if="columns[5].visible"/>
      <el-table-column label="对方账号" align="center" prop="targetBankNo" v-if="columns[6].visible"/>
      <el-table-column label="对方开户行" align="center" prop="targetBankName" v-if="columns[7].visible"/>
      <el-table-column label="我方支付账户" align="center" prop="selfAcountsName" v-if="columns[8].visible"/>
      <el-table-column label="我方账号" align="center" prop="selfBankNo" v-if="columns[9].visible"/>
      <el-table-column label="我方开户行" align="center" prop="selfBankName" v-if="columns[10].visible"/>
      <el-table-column label="支付期货保证金时间" align="center" prop="futuresDate" v-if="columns[11].visible"/>
      <el-table-column label="事由" align="center" prop="reason" v-if="columns[12].visible"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150px" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:lendMoney:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:lendMoney:remove']"
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
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="借出款编号" prop="futuresNO">
          <el-input v-model="form.futuresNO" placeholder="请输入借出款编号"/>
        </el-form-item>
        <el-form-item label="期货保证金公司" prop="futuresMarginCompany">
          <el-input v-model="form.futuresMarginCompany" placeholder="请输入期货保证金公司"/>
        </el-form-item>
        <el-form-item label="对象(员工姓名、公司名称)" prop="target">
          <el-input v-model="form.target" placeholder="请输入对象(员工姓名、公司名称)"/>
        </el-form-item>
        <el-form-item label="保证金金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入保证金金额"/>
        </el-form-item>
        <el-form-item label="对方账户" prop="targetAcountsName">
          <el-input v-model="form.targetAcountsName" placeholder="请输入对方账户"/>
        </el-form-item>
        <el-form-item label="对方账号" prop="targetBankNo">
          <el-input v-model="form.targetBankNo" placeholder="请输入对方账号"/>
        </el-form-item>
        <el-form-item label="对方开户行" prop="targetBankName">
          <el-input v-model="form.targetBankName" placeholder="请输入对方开户行"/>
        </el-form-item>
        <el-form-item label="我方支付账户" prop="selfAcountsName">
          <el-input v-model="form.selfAcountsName" placeholder="请输入我方支付账户"/>
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
  </div>
</template>

<script>
import {listLendMoney, getLendMoney, delLendMoney, addLendMoney, updateLendMoney} from "@/api/system/lendMoney";
import {mapGetters} from "vuex";

export default {
  name: "LendMoney",
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
      ]
    };
  },
  created() {
    this.getList();
    //查向外借钱
    this.$store.dispatch('money/getTempLendMoneyList')
  },
  computed: {
    ...mapGetters(['tempLendMoneyList'])
  },
  methods: {
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
<!--<style>-->
<!--//隐藏原有滚动条-->
<!--.el-table__body-wrapper::-webkit-scrollbar {-->
<!--  /*width: 0;宽度为0隐藏*/-->
<!--  width: 0px;-->
<!--}-->

<!--.el-table__body-wrapper::-webkit-scrollbar-thumb {-->
<!--  border-radius: 2px;-->
<!--  height: 50px;-->
<!--  background: #eee;-->
<!--}-->

<!--.el-table__body-wrapper::-webkit-scrollbar-track {-->
<!--  box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);-->
<!--  border-radius: 2px;-->
<!--  background: rgba(0, 0, 0, 0.4);-->
<!--}-->

<!--.el-table&#45;&#45;scrollable-y .el-table__body-wrapper {-->
<!--  overflow: hidden !important;-->
<!--}-->

<!--.el-table&#45;&#45;scrollable-x .el-table__body-wrapper {-->
<!--  overflow: hidden !important;-->
<!--}-->
<!--</style>-->
