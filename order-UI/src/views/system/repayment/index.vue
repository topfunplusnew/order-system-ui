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
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQueryTime">搜索</el-button>
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

    <el-table border v-loading="loading" :data="repaymentList" @selection-change="handleSelectionChange" id="printBox"
              v-horizontal-scroll="'always'">
      <!--      <el-table-column type="selection" width="55" align="center"/>-->
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="贷款编号" align="center" prop="loanNO" v-if="columns[0].visible"/>
      <el-table-column label="还款编号" align="center" prop="payNO" v-if="columns[1].visible"/>
      <el-table-column label="还款金额" align="center" prop="moneyAmount" v-if="columns[2].visible"/>
      <el-table-column label="付息" align="center" prop="ratio" v-if="columns[3].visible"/>
      <el-table-column label="还款日期" align="center" prop="payDate" v-if="columns[4].visible"/>
      <el-table-column label="还款账户" align="center" prop="acountsName" v-if="columns[5].visible"/>
      <el-table-column label="还款账号" align="center" prop="bankNo" v-if="columns[6].visible"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <!--      <el-table-column label="添加时间" align="center" prop="addtime"/>-->
      <!--      <el-table-column label="操作人员ID" align="center" prop="userId"/>-->
      <!--      <el-table-column label="操作人员姓名" align="center" prop="UserName"/>-->
      <!--      <el-table-column label="删除标记" align="center" prop="delFlag"/>-->
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:repayment:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:repayment:remove']"
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

    <!-- 添加或修改贷款还款信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="贷款编号" prop="loanNO">
          <el-input v-model="form.loanNO" placeholder="请输入贷款编号"/>
        </el-form-item>
        <el-form-item label="还款编号" prop="payNO">
          <el-input v-model="form.payNO" placeholder="请输入还款编号"/>
        </el-form-item>
        <el-form-item label="还" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入还"/>
        </el-form-item>
        <el-form-item label="付息" prop="ratio">
          <el-input v-model="form.ratio" placeholder="请输入付息"/>
        </el-form-item>
        <el-form-item label="还款日期" prop="payDate">
          <el-input v-model="form.payDate" placeholder="请输入还款日期"/>
        </el-form-item>
        <el-form-item label="还款账户" prop="acountsName">
          <el-input v-model="form.acountsName" placeholder="请输入还款账户"/>
        </el-form-item>
        <el-form-item label="还款账号" prop="bankNo">
          <el-input v-model="form.bankNo" placeholder="请输入还款账号"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注"/>
        </el-form-item>
        <!--        <el-form-item label="添加时间" prop="addtime">-->
        <!--          <el-input v-model="form.addtime" placeholder="请输入添加时间"/>-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="操作人员ID" prop="userId">-->
        <!--          <el-input v-model="form.userId" placeholder="请输入操作人员ID"/>-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="操作人员姓名" prop="UserName">-->
        <!--          <el-input v-model="form.UserName" placeholder="请输入操作人员姓名"/>-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="删除标记" prop="delFlag">-->
        <!--          <el-input v-model="form.delFlag" placeholder="请输入删除标记"/>-->
        <!--        </el-form-item>-->
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {listRepayment, getRepayment, delRepayment, addRepayment, updateRepayment} from "@/api/system/repayment";
import {mapGetters} from "vuex";

export default {
  name: "Repayment",
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
      // 贷款还款信息表格数据
      repaymentList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        loanNO: null,
        payNO: null,
        moneyAmount: null,
        ratio: null,
        payDate: null,
        acountsName: null,
        bankNo: null,
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
        {key: 0, label: `贷款编号`, visible: true},
        {key: 1, label: `还款编号`, visible: true},
        {key: 2, label: `还款金额`, visible: true},
        {key: 3, label: `付息`, visible: true},
        {key: 4, label: `还款日期`, visible: true},
        {key: 5, label: `还款账户`, visible: true},
        {key: 6, label: `还款账号`, visible: true},
      ],
      timesQuery: {
        beginTime: '',
        endTime: '',
        objectType: ''
      },
      options: [
        {
          label: 'test',
          value: 'test'
        }
      ]
    };
  },
  created() {
    this.getList();
    this.$store.dispatch('money/getRepaymentList')
  },
  computed: {
    ...mapGetters(['tempRepaymentList'])
  },
  methods: {
    //时间查询
    handleQueryTime() {
      //重置
      this.repaymentList = this.tempRepaymentList
      console.log(this.tempRepaymentList)
      //筛选
      this.repaymentList = this.filterTime()
    },
    //筛选方法
    filterTime() {
      return this.repaymentList.filter(item => {
        //时间转换
        const time_search = new Date(item.payDate).getTime()
        const time_start = new Date(this.timesQuery.beginTime).getTime()
        const date = new Date(this.timesQuery.endTime)
        date.setDate(date.getDate() + 1)
        const time_end = date.getTime()
        return time_search >= time_start && time_search <= time_end
      })
    },
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    /** 查询贷款还款信息列表 */
    getList() {
      this.loading = true;
      listRepayment(this.queryParams).then(response => {
        this.repaymentList = response.rows;
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
        payNO: null,
        moneyAmount: null,
        ratio: null,
        payDate: null,
        acountsName: null,
        bankNo: null,
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
      this.title = "添加贷款还款信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getRepayment(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改贷款还款信息";
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
            updateRepayment(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            addRepayment(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除贷款还款信息编号为"' + ids + '"的数据项？').then(function () {
        return delRepayment(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/repayment/export', {
        ...this.queryParams
      }, `repayment_${new Date().getTime()}.xlsx`)
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
