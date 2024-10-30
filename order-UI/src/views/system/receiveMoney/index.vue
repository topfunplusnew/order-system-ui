<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="100px">
      <el-form-item label="开始日期" prop="fundsDate">
        <el-date-picker
          v-model="queryParams.startTime"
          type="date"
          placeholder="请选择日期" value-format="yyyy-MM-dd" class="w-85px">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="结束日期" prop="fundsDate">
        <el-date-picker
          v-model="queryParams.endTime"
          type="date"
          placeholder="请选择日期" value-format="yyyy-MM-dd" class="w-85px">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="己方户名" prop="selfAcountsName">
        <el-input
          v-model="queryParams.selfAcountsName"
          placeholder="请输入己方户名"
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
          v-hasPermi="['system:receivemoney:add']"
        >新增收款信息
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
              v-hasPermi="['system:receivemoney:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="receiveMoneyList"
              @selection-change="handleSelectionChange" id="printBox" size="mini"
              :cell-style="()=>{return {padding:'2px'}}">
      <el-table-column label="日期" align="center" prop="fundsDate" v-if="columns[0].visible" width="140"
                       show-overflow-tooltip/>
      <el-table-column label="支付类型" align="center" prop="receiveType" v-if="columns[1].visible" width="165"
                       show-overflow-tooltip/>
      <el-table-column label="金额" align="center" prop="moneyAmount" v-if="columns[2].visible" width="165"
                       show-overflow-tooltip/>
      <el-table-column label="己方户名" align="center" prop="selfAcountsName" v-if="columns[3].visible" width="165"
                       show-overflow-tooltip/>
      <el-table-column label="己方账号" align="center" prop="selfBankNo" v-if="columns[4].visible" width="165"
                       show-overflow-tooltip/>
      <el-table-column label="己方开户行" align="center" prop="selfBankName" v-if="columns[5].visible" width="165"
                       show-overflow-tooltip/>
      <el-table-column label="对方户名" align="center" prop="otherAcountsName" v-if="columns[6].visible" width="165"
                       show-overflow-tooltip/>
      <el-table-column label="对方账号" align="center" prop="otherBankNo" v-if="columns[7].visible" width="165"
                       show-overflow-tooltip/>
      <el-table-column label="对方开户行" align="center" prop="otherBankName" v-if="columns[8].visible" width="165"
                       show-overflow-tooltip/>
      <el-table-column label="对方公司" align="center" prop="companyName" v-if="columns[9].visible" width="165"
                       show-overflow-tooltip/>
      <el-table-column label="对方公司类型" align="center" prop="companyType" v-if="columns[10].visible" width="165">
        <template slot-scope="scope">
          <span v-if="scope.row.companyType===1">客户</span>
          <span v-else-if="scope.row.companyType===2">供应商</span>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="comments" width="165"/>
      <el-table-column label="银行卡流水编号" align="center" prop="transactionHistory" width="165"/>
      <el-table-column label="银行卡流水附件" align="center" prop="transactionHistoryAttachment" width="165"
                       fixed="right">
        <template slot-scope="scope">
          <!-- 这是封装的一个通用组件 可以直接传入url 组件效果为一个按钮 点击后可以查看附件-->
          <CheckFiles :path="scope.row.transactionHistoryAttachment"/>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="150">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:receivemoney:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:receivemoney:remove']"
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

    <!-- 添加或修改收款信息对话框 -->
    <el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="700px"
               append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="150px">
        <el-form-item label="日期" prop="fundsDate">
          <el-date-picker
            v-model="form.fundsDate"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="请选择日期">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="支付类型" prop="payType">
          <el-row :gutter="5">
            <!--            一级分类-->
            <el-col :span="8">
              <el-select v-model="currentSort.levelOne" placeholder="请选择一级支付类型" @change="handleSelectOneLevel">
                <el-option
                  v-for="item in OneLevelOption"
                  :key="item.id"
                  :label="item.title"
                  :value="item.title">
                </el-option>
              </el-select>
            </el-col>
            <!--            二级分类-->
            <el-col :span="8">
              <el-select v-model="currentSort.levelTwo" placeholder="请选择二级支付类型" @change="handleSelectTwoLevel">
                <el-option
                  v-for="item in TwoLevelOption"
                  :key="item.id"
                  :label="item.title"
                  :value="item.title">
                </el-option>
              </el-select>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入金额"/>
        </el-form-item>
        <el-form-item label="己方户名" prop="selfAcountsName">
          <el-row>
            <el-col :span="10">
              <el-input v-model="form.selfAcountsName" placeholder="请输入己方户名"/>
            </el-col>
            <!--   自定义组件查找-->
            <el-col :span="3">
              <SearchOption :get-data="listBankAccount" title="银行卡信息" icon="el-icon-search"
                            @commitBack="handleCallBack" :limit-info="{acountsType:'己方公司'}"
                            @update:queryName="handleCommitBackBank" :query-name="bankQuery" query-info="acountsName"
                            query-label="户名查询">
                <template #table-columns>
                  <el-table-column label="账户类型" align="center" prop="acountsType"/>
                  <el-table-column label="开户名称(户名)" align="center" prop="acountsName"/>
                  <el-table-column label="账号(银行账号)" align="center" prop="bankNo"/>
                  <el-table-column label="开户行" align="center" prop="bankName"/>
                  <el-table-column label="公司名称" align="center" prop="companyName"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="己方账号" prop="selfBankNo">
          <el-input v-model="form.selfBankNo" placeholder="请输入己方账号"/>
        </el-form-item>
        <el-form-item label="己方开户行" prop="selfBankName">
          <el-input v-model="form.selfBankName" placeholder="请输入己方开户行"/>
        </el-form-item>


        <!--          todo-->
        <el-form-item label="对方公司" prop="companyName">
          <el-row>
            <el-col :span="14">
              <el-input v-model="form.companyName" placeholder="请输入对方公司"/>
            </el-col>
            <el-col :span="4">
              <SearchOption :limit-info="{}" :get-data="listCompany" query-info="companyName"
                            query-label="公司名称" :query-name="companyName"
                            @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
                <template #table-columns>
                  <el-table-column label="供应商" align="center" prop="relationName"/>
                  <el-table-column label="老板姓名" align="center" prop="leader"/>
                  <el-table-column label="老板电话" align="center" prop="leaderTel"/>
                  <el-table-column label="区域" align="center" prop="region"/>
                  <el-table-column label="公司名称" align="center" prop="companyName"/>
                  <el-table-column label="销售经理" align="center" prop="salesManager"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="对方账号" prop="otherBankNo">
          <el-col :span="10">
            <el-input v-model="form.otherBankNo" placeholder="请输入对方账号"/>
          </el-col>
          <el-col :span="3">
            <SearchOption :get-data="listBankAccount" title="客户银行卡信息" icon="el-icon-search"
                          query-label="户名查找" query-info="acountsName" :query-name="queryCustomerBank"
                          @update:queryName="handleUpdateQueryNameCustomer"
                          @commitBack="handleCallBackCompany" :limit-info="{acountsType:'客户'}">
              <template #table-columns>
                <el-table-column label="账户类型" align="center" prop="acountsType"/>
                <el-table-column label="开户名称(户名)" align="center" prop="acountsName"/>
                <el-table-column label="账号(银行账号)" align="center" prop="bankNo"/>
                <el-table-column label="开户行" align="center" prop="bankName"/>
              </template>
            </SearchOption>
          </el-col>
        </el-form-item>
        <el-form-item label="对方开户行" prop="selfBankName">
          <el-input v-model="form.otherBankName" placeholder="请输入己方开户行"/>
        </el-form-item>
        <el-form-item label="对方开户名" prop="selfBankName">
          <el-input v-model="form.otherAcountsName" placeholder="请输入己方开户行"/>
        </el-form-item>
        <el-form-item label="银行卡流水编号" prop="transactionHistory">
          <el-input v-model="form.transactionHistory" placeholder="请输入银行卡流水编号"/>
        </el-form-item>
        <el-form-item label="银行卡流水编号附件" prop="transactionHistoryAttachment">
          <!--          todo 附件上传-->
          <file-upload @input="handleCommitUpload"/>
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
import {
  listReceiveMoney,
  getReceiveMoney,
  delReceiveMoney,
  addReceiveMoney,
  updateReceiveMoney
} from "@/api/system/receiveMoney";
import SearchOption from "@/components/SearchOption.vue";
import {listBankAccount} from "@/api/system/bankAccount";
import {listSubject} from "@/api/system/subject";
import {excludeParams} from "@/api/tool/exclude";
import {addReason} from "@/api/system/user";
import {TableName} from "@/api/tool/enums";
import {mixin_printHTML} from "../../dashboard/mixins/print";
import CheckFiles from "../../../components/CheckFiles.vue";

import {listCompany} from "../../../api/system/company";
import {mixin_receive_money_fill} from "./receiveMoneyFill";

export default {
  name: "ReceiveMoney",
  components: {CheckFiles, SearchOption},
  mixins: [mixin_printHTML, mixin_receive_money_fill],
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
      // 收款信息表格数据
      receiveMoneyList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        receiveNO: null,
        fundsDate: null,
        receiveType: null,
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
      rules: {
        fundsDate: [
          {required: true, message: "日期不能为空", trigger: "blur"}],
        moneyAmount:
          [{required: true, message: "金额不能为空", trigger: "blur"}],
        selfAcountsName: [
          {required: true, message: "己方户名不能为空", trigger: "change"}],
        selfBankNo: [
          {required: true, message: "己方账号不能为空", trigger: "blur"}],
        selfBankName: [
          {required: true, message: "己方开户行不能为空", trigger: "blur"}],
        otherAcountsName: [
          {required: true, message: "对方户名不能为空", trigger: "blur"}],
        otherBankNo: [
          {required: true, message: "对方账号不能为空", trigger: "blur"}],
        otherBankName: [
          {required: true, message: "对方开户行不能为空", trigger: "blur"}],
      },
      columns: [
        {key: 0, label: `日期`, visible: true},
        {key: 1, label: `支付类型`, visible: true},
        {key: 2, label: `金额`, visible: true},
        {key: 3, label: `乙方户名`, visible: true},
        {key: 4, label: `己方账号`, visible: true},
        {key: 5, label: `己方开户行`, visible: true},
        {key: 6, label: `对方户名`, visible: true},
        {key: 7, label: `对方账号`, visible: true},
        {key: 8, label: `对方开户行`, visible: true},
        {key: 9, label: `对方公司`, visible: true},
        {key: 10, label: `对方公司类型`, visible: true},
      ],
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

      //银行卡查询
      bankQuery: ''
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('receivemoney-columns') === 'null'
      || !localStorage.getItem('receivemoney-columns')) {
      //设置localStorage
      localStorage.setItem("receivemoney-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('receivemoney-columns'));
    }
    listSubject().then(res => {
      this.subjectTree = this.handleTree(res.data, "id", "parentId");
      this.OneLevelOption = this.subjectTree;
    })
  },
  computed: {
    fullLevel() {
      return this.currentSort.levelOne + '-' + this.currentSort.levelTwo;
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("receivemoney-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  methods: {
    listCompany,
    listBankAccount,
    //点击一级分类后的回调
    handleSelectOneLevel(value) {
      this.currentSort.levelOne = value;
      for (var i = 0; i < this.OneLevelOption.length; i++) {
        //每个一级分类
        var oneSubject = this.OneLevelOption[i]
        //判断：所有一级分类id和点击一级分类id是否一样
        if (value === oneSubject.title) {  //===即比较值 还要比较类型
          //从一级分类中获取所有的二级分类
          this.TwoLevelOption = oneSubject.children
          //把二级分类Id值清空
          this.currentSort.levelTwo = ''
        }
      }
    },
    //点击二级
    handleSelectTwoLevel(value) {
      this.currentSort.levelTwo = value;
    },

    //银行卡附件上传
    handleCommitUpload(val) {
      this.form.transactionHistoryAttachment = val;
    },
    /** 查询收款信息列表 */
    getList() {
      this.loading = true;
      listReceiveMoney(this.queryParams).then(response => {
        this.receiveMoneyList = response.rows;
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
        receiveNO: null,
        fundsDate: null,
        receiveType: null,
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
      this.title = "添加收款信息";
    },
    /** 修改按钮操作 */
    /*  handleUpdate(row) {
        this.reset();
        const id = row.id || this.ids
        getReceiveMoney(id).then(response => {
          this.form = response.data;
          //修改类型
          this.currentSort.levelOne = this.form.receiveType.split('-')[0]
          this.currentSort.levelTwo = this.form.receiveType.split('-')[1]
          this.open = true;
          this.title = "修改收款信息";
        });
      },*/
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.$prompt('请输入编辑原因', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(({value}) => {
        addReason({reason: value, tableName: TableName.RECEIVE_MONEY, tid: row.id, modifyTime: this.modifyTime})
          .then(res => {
            this.$message.success('提交成功')
            this.reset();
            const id = row.id || this.ids
            getReceiveMoney(id).then(response => {
              this.form = response.data;
              this.open = true;
              this.title = "修改收款信息";
            });
          })
      }).catch(() => {
        this.$message({
          type: 'warning',
          message: '请先输入编辑原因!'
        });
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
            //支付类型
            this.form.receiveType = this.fullLevel;
            this.form = excludeParams(this.form, this.$exclude)
            updateReceiveMoney(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.$close();//结束加载
              this.open = false;
              this.getList();
            })
          } else {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            this.form.receiveType = this.fullLevel;
            this.form = excludeParams(this.form, this.$exclude)
            // form.tableName form.tID
            addReceiveMoney(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.$close();//结束加载
              this.open = false;
              this.getList();
            })
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除收款信息编号为"' + ids + '"的数据项？').then(function () {
        return delReceiveMoney(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/receiveMoney/export', {
        ...this.queryParams
      }, `receiveMoney_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
<style scoped>
.w-85px {
  width: 85px;
}
</style>
