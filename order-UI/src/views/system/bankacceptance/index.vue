<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="操作日期" prop="issueDate">
        <el-date-picker
          v-model="queryParams.issueDate"
          type="date"
          placeholder="选择日期" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="票据号码" prop="billNo">
        <el-input
          v-model="queryParams.billNo"
          placeholder="请输入票据号码"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <!--  <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
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
          v-hasPermi="['system:bankAcceptance:add']"
        >添加商业票据
        </el-button>
      </el-col>
      <!--      <el-col :span="1.5">-->
      <!--        <el-button-->
      <!--          type="success"-->
      <!--          plain-->
      <!--          icon="el-icon-edit"-->
      <!--          size="mini"-->
      <!--          :disabled="single"-->
      <!--          @click="handleUpdate"-->
      <!--          v-hasPermi="['system:bankAcceptance:edit']"-->
      <!--        >修改-->
      <!--        </el-button>-->
      <!--      </el-col>-->
      <!--      <el-col :span="1.5">-->
      <!--        <el-button-->
      <!--          type="danger"-->
      <!--          plain-->
      <!--          icon="el-icon-delete"-->
      <!--          size="mini"-->
      <!--          :disabled="multiple"-->
      <!--          @click="handleDelete"-->
      <!--          v-hasPermi="['system:bankAcceptance:remove']"-->
      <!--        >删除-->
      <!--        </el-button>-->
      <!--      </el-col>-->
      <!--      <el-col :span="1.5">-->
      <!--        <el-button-->
      <!--          type="warning"-->
      <!--          plain-->
      <!--          icon="el-icon-download"-->
      <!--          size="mini"-->
      <!--          @click="handleExport"-->
      <!--          v-hasPermi="['system:bankAcceptance:export']"-->
      <!--        >导出-->
      <!--        </el-button>-->
      <!--      </el-col>-->
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

    <el-table border v-horizontal-scroll="'always'" v-loading="loading" :data="bankAcceptanceList"
              @selection-change="handleSelectionChange" show-summary :summary-method="getSummaries" height="480px">
      <!--  <el-table-column type="selection" width="55" align="center"/>-->
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="操作日期" align="center" prop="operateDate" v-if="columns[0].visible"/>
      <el-table-column label="票据号码" align="center" prop="billNo" v-if="columns[1].visible"/>
      <el-table-column label="出票日期" align="center" prop="issueDate" v-if="columns[2].visible"/>
      <el-table-column label="到期日期" align="center" prop="dueDate" v-if="columns[3].visible"/>
      <el-table-column label="我方承兑账户" align="center" prop="billAccount" v-if="columns[4].visible"/>
      <el-table-column label="票据日期" align="center" prop="billDate" v-if="columns[5].visible"/>
      <!--      <el-table-column label="分类" align="center" prop="billType" v-if="columns[6].visible"/>-->
      <el-table-column label="事由" align="center" prop="reason" v-if="columns[7].visible"/>
      <el-table-column label="票据金额" align="center" prop="billAmount" v-if="columns[8].visible"/>
      <el-table-column label="贴息点数" align="center" prop="inDiscountPoints" v-if="columns[9].visible"/>
      <el-table-column label="贴息金额" align="center" prop="inDiscountAmount" v-if="columns[10].visible"/>
      <el-table-column label="票据种类" align="center" prop="billCategory" v-if="columns[11].visible"/>
      <el-table-column label="来源" align="center" prop="origin" v-if="columns[12].visible"/>
      <el-table-column label="背书人" align="center" prop="endorser" v-if="columns[13].visible"/>
      <el-table-column label="被背书人" align="center" prop="endorsee" v-if="columns[14].visible"/>
      <el-table-column label="背书事由" align="center" prop="endorseReason" v-if="columns[15].visible"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150px" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:bankAcceptance:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:bankAcceptance:remove']"
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

    <!-- 添加或修改商业票据、银行承兑对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <!--        <el-form-item label="操作日期" prop="operateDate">-->
        <!--          <el-input v-model="form.operateDate" placeholder="请输入操作日期"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="票据号码" prop="billNo">
          <el-input v-model="form.billNo" placeholder="请输入票据号码"/>
        </el-form-item>
        <!--        单选-->
        <el-form-item label="收票事由" prop="reason">
          <!--          <el-input v-model="form.reason" placeholder="请输入收票事由"/>-->
          <el-radio v-model="form.reason" label="购买">购买</el-radio>
          <el-radio v-model="form.reason" label="客户付款">客户付款</el-radio>
        </el-form-item>
        <el-form-item label="贴息点数" prop="inDiscountPoints">
          <el-input v-model="form.inDiscountPoints" placeholder="请输入贴息点数"/>
        </el-form-item>
        <el-form-item label="贴息金额" prop="inDiscountAmount">
          <el-input v-model="form.inDiscountAmount" placeholder="请输入贴息金额"/>
        </el-form-item>

        <el-form-item label="我方承兑账户" prop="billAccount">
          <el-input v-model="form.billAccount" placeholder="请输入我方承兑账户"/>
        </el-form-item>
        <!--        原票据日期  日期选择-->
        <el-form-item label="我方收票日期" prop="billDate">
          <!--          <el-input v-model="form.billDate" placeholder="请输入我方收票日期"/>-->
          <el-date-picker
            v-model="form.billDate"
            type="date"
            placeholder="选择日期" format="yyyy 年 MM 月 dd 日" value-format="yyyy-MM-dd">
          </el-date-picker>
        </el-form-item>
        <!--        单选-->
        <el-form-item label="票据种类" prop="billCategory">
          <!--          <el-input v-model="form.billCategory" placeholder="请输入票据种类"/>-->
          <el-radio v-model="form.billCategory" label="电子">购买</el-radio>
          <el-radio v-model="form.billCategory" label="纸质">客户付款</el-radio>
        </el-form-item>
        <el-form-item label="票据金额" prop="billAmount">
          <el-input v-model="form.billAmount" placeholder="请输入票据金额"/>
        </el-form-item>
        <!--        时间选择器-->
        <el-form-item label="出票日期" prop="issueDate">
          <!--          <el-input v-model="form.issueDate" placeholder="请输入出票日期"/>-->
          <el-date-picker
            v-model="form.issueDate"
            type="date"
            placeholder="选择日期" format="yyyy 年 MM 月 dd 日" value-format="yyyy-MM-dd">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="到期日期" prop="dueDate">
          <!--          <el-input v-model="form.dueDate" placeholder="请输入到期日期"/>-->
          <el-date-picker
            v-model="form.dueDate"
            type="date"
            placeholder="选择日期" format="yyyy 年 MM 月 dd 日" value-format="yyyy-MM-dd">
          </el-date-picker>
        </el-form-item>
        <!--        单选-->
        <el-form-item label="背书事由" prop="endorseReason">
          <!--          <el-input v-model="form.endorseReason" placeholder="请输入背书事由"/>-->
          <el-radio v-model="form.endorseReason" label="出卖">出卖</el-radio>
          <el-radio v-model="form.endorseReason" label="付货款">付货款</el-radio>
        </el-form-item>
        <el-form-item label="来源" prop="origin">
          <el-input v-model="form.origin" placeholder="请输入来源"/>
        </el-form-item>
        <el-form-item label="背书人" prop="endorser">
          <el-input v-model="form.endorser" placeholder="请输入背书人"/>
        </el-form-item>
        <el-form-item label="被背书人" prop="endorsee">
          <el-input v-model="form.endorsee" placeholder="请输入被背书人"/>
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
  listBankAcceptance,
  getBankAcceptance,
  delBankAcceptance,
  addBankAcceptance,
  updateBankAcceptance
} from "@/api/system/bankAcceptance";
import {formatTime} from "@/api/tool/format";

export default {
  name: "BankAcceptance",
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
      // 商业票据、银行承兑表格数据
      bankAcceptanceList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        operateDate: null,
        billNo: null,
        issueDate: null,
        dueDate: null,
        billAccount: null,
        billDate: null,
        billType: null,
        reason: null,
        billAmount: null,
        inDiscountPoints: null,
        inDiscountAmount: null,
        billCategory: null,
        origin: null,
        endorser: null,
        endorsee: null,
        endorseReason: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      columns: [
        {key: 0, label: `操作日期`, visible: true},
        {key: 1, label: `票据号码`, visible: true},
        {key: 2, label: `出票日期`, visible: true},
        {key: 3, label: `到期日期`, visible: true},
        {key: 4, label: `我方承兑账户`, visible: true},
        {key: 5, label: `票据日期`, visible: true},
        {key: 6, label: `分类`, visible: true},
        {key: 7, label: `事由`, visible: true},
        {key: 8, label: `票据金额`, visible: true},
        {key: 9, label: `贴息点数`, visible: true},
        {key: 10, label: `贴息金额`, visible: true},
        {key: 11, label: `票据种类`, visible: true},
        {key: 12, label: `来源`, visible: true},
        {key: 13, label: `背书人`, visible: true},
        {key: 14, label: `被背书人`, visible: true},
        {key: 15, label: `背书事由`, visible: true},
      ],
      // 表单参数
      form: {},
      // 表单校验
      rules: {}
    };
  },
  created() {
    this.getList();
  },
  methods: {
    //自定义列统计总函数
    getSummaries(param) {
      const {columns, data} = param;
      console.log(param)
      const sums = [];
      columns.forEach((column, index) => {
        if (index === 0) {
          sums[index] = '总价';
          return;
        }
        const values = data.map(item => {
          return Number(item[column.property])
        });

        if (!values.every(value => isNaN(value))) {
          //对指定列进行计算
          // if(index)
          //排除打入账户
          if (index !== 9 && index !== 1 && index !== 16) {
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
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    /** 查询商业票据、银行承兑列表 */
    getList() {
      this.loading = true;
      listBankAcceptance(this.queryParams).then(response => {
        this.bankAcceptanceList = response.rows;
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
        operateDate: null,
        billNo: null,
        issueDate: null,
        dueDate: null,
        billAccount: null,
        billDate: null,
        billType: null,
        reason: null,
        billAmount: null,
        inDiscountPoints: null,
        inDiscountAmount: null,
        billCategory: null,
        origin: null,
        endorser: null,
        endorsee: null,
        endorseReason: null,
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
      // this.queryParams.issueDate = ''
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
      this.title = "添加商业票据、银行承兑";
      this.form.billDate = formatTime(new Date())
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getBankAcceptance(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改商业票据、银行承兑";
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
            updateBankAcceptance(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            addBankAcceptance(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除商业票据、银行承兑编号为"' + ids + '"的数据项？').then(function () {
        return delBankAcceptance(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/bankAcceptance/export', {
        ...this.queryParams
      }, `bankAcceptance_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
<!--<style>-->
////隐藏原有滚动条
//.el-table__body-wrapper::-webkit-scrollbar {
//  /*width: 0;宽度为0隐藏*/
//  width: 0px;
//}
//
//.el-table__body-wrapper::-webkit-scrollbar-thumb {
//  border-radius: 2px;
//  height: 50px;
//  background: #eee;
//}
//
//.el-table__body-wrapper::-webkit-scrollbar-track {
//  box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
//  border-radius: 2px;
//  background: rgba(0, 0, 0, 0.4);
//}
//
//.el-table--scrollable-y .el-table__body-wrapper {
//  overflow: hidden !important;
//}
//
//.el-table--scrollable-x .el-table__body-wrapper {
//  overflow: hidden !important;
//}
<!--</style>-->
