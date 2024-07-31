<template>
  <div class="app-container">
    <!--    搜索框-->
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
        <!-- <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
      </el-form-item>
    </el-form>

    <!--    按钮组-->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <!--      右侧工具栏-->
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

    <!--   数据表格-->
    <el-table v-loading="loading" :data="borrowedMoneyList" @selection-change="handleSelectionChange"
              v-horizontal-scroll="'always'" id="printBox">
      <el-table-column type="selection" width="55" align="center"/>
      <el-table-column label="id" align="center" prop="id"/>
      <!--      应该可以优化columns -->
      <el-table-column label="贷款编号" align="center" prop="loanNO" v-if="columns[0].visible"/>
      <el-table-column label="贷款来源" align="center" prop="origin" v-if="columns[1].visible"/>
      <el-table-column label="借入金额" align="center" prop="moneyAmount" v-if="columns[2].visible"/>
      <el-table-column label="贷款利率" align="center" prop="ratio" v-if="columns[3].visible"/>
      <el-table-column label="贷款发放日期" align="center" prop="loanDate" v-if="columns[4].visible"/>
      <el-table-column label="贷款年限" align="center" prop="loanDuring" v-if="columns[5].visible"/>
      <el-table-column label="抵押担保" align="center" prop="mortgageGuarantee" v-if="columns[6].visible"/>
      <el-table-column label="打入账户" align="center" prop="acountsName" v-if="columns[7].visible"/>
      <el-table-column label="打入账号" align="center" prop="bankNo" v-if="columns[8].visible"/>
      <el-table-column label="已还款标记" align="center" prop="isEnd" v-if="columns[9].visible"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <!--      <el-table-column label="添加时间" align="center" prop="addtime"/>-->
      <!--      <el-table-column label="操作人员ID" align="center" prop="userId"/>-->
      <!--      <el-table-column label="操作人员姓名" align="center" prop="UserName"/>-->
      <!--      <el-table-column label="删除标记" align="center" prop="delFlag"/>-->
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:borrowedMoney:edit']"
          >编辑
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:borrowedMoney:remove']"
          >删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!--    分页信息-->
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改从外部借款信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="贷款编号" prop="loanNO">
          <el-input v-model="form.loanNO" placeholder="请输入贷款编号" v-if="columns[0].visible"/>
        </el-form-item>
        <el-form-item label="贷款来源" prop="origin">
          <el-input v-model="form.origin" placeholder="请输入贷款来源" v-if="columns[0].visible"/>
        </el-form-item>
        <el-form-item label="借入金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入借入金额" v-if="columns[0].visible"/>
        </el-form-item>
        <el-form-item label="贷款利率" prop="ratio">
          <el-input v-model="form.ratio" placeholder="请输入贷款利率"/>
        </el-form-item>
        <el-form-item label="贷款发放日期" prop="loanDate">
          <el-input v-model="form.loanDate" placeholder="请输入贷款发放日期"/>
        </el-form-item>
        <el-form-item label="贷款年限" prop="loanDuring">
          <el-input v-model="form.loanDuring" placeholder="请输入贷款年限"/>
        </el-form-item>
        <el-form-item label="抵押担保" prop="mortgageGuarantee">
          <el-input v-model="form.mortgageGuarantee" placeholder="请输入抵押担保"/>
        </el-form-item>
        <el-form-item label="打入账户" prop="acountsName">
          <el-input v-model="form.acountsName" placeholder="请输入打入账户"/>
        </el-form-item>
        <el-form-item label="打入账号" prop="bankNo">
          <el-input v-model="form.bankNo" placeholder="请输入打入账号"/>
        </el-form-item>
        <el-form-item label="已还款标记(1是0否)" prop="isEnd">
          <el-input v-model="form.isEnd" placeholder="请输入已还款标记"/>
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
import {
  listBorrowedMoney,
  getBorrowedMoney,
  delBorrowedMoney,
  addBorrowedMoney,
  updateBorrowedMoney
} from "@/api/system/borrowedMoney";
import {mapGetters, mapState} from "vuex";

export default {
  name: "BorrowedMoney",
  data() {
    //loanNO校验方法
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
      // 从外部借款信息表格数据
      borrowedMoneyList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
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
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        loanNO: [
          {validator: validateloanNO, trigger: 'blur'}
        ],
      },
      columns: [
        {key: 0, label: `贷款编号`, visible: true},
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
      //搜索参数
      timesQuery: {
        beginTime: '',
        endTime: '',
      },
    };
  },
  created() {
    this.getList();
    this.$store.dispatch('borrowMoney/getTempBorrowedMoneyList')
  },
  computed: {
    ...mapGetters(['tempBorrowedMoneyList'])
  },
  methods: {
    //时间查询
    handleQueryTime() {
      //重置
      this.borrowedMoneyList = this.tempBorrowedMoneyList
      //筛选
      this.borrowedMoneyList = this.filterTime()
    },
    //筛选方法
    filterTime() {
      return this.borrowedMoneyList.filter(item => {
        //时间转换
        const time_search = new Date(item.loanDate).getTime()
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
    /** 查询从外部借款信息列表 */
    getList() {
      this.loading = true;
      listBorrowedMoney(this.queryParams).then(response => {
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
<style>
//隐藏原有滚动条
.el-table__body-wrapper::-webkit-scrollbar {
  /*width: 0;宽度为0隐藏*/
  width: 0px;
}

.el-table__body-wrapper::-webkit-scrollbar-thumb {
  border-radius: 2px;
  height: 50px;
  background: #eee;
}

.el-table__body-wrapper::-webkit-scrollbar-track {
  box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
  border-radius: 2px;
  background: rgba(0, 0, 0, 0.4);
}

.el-table--scrollable-y .el-table__body-wrapper {
  overflow: hidden !important;
}

.el-table--scrollable-x .el-table__body-wrapper {
  overflow: hidden !important;
}
</style>
