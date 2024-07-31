<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="社保缴纳基数" prop="basicSocialInsurance">
        <el-input
          v-model="queryParams.basicSocialInsurance"
          placeholder="请输入社保缴纳基数"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="公积金基数" prop="basicHousingFund">
        <el-input
          v-model="queryParams.basicHousingFund"
          placeholder="请输入公积金基数"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="部门" prop="depName">
        <el-input
          v-model="queryParams.depName"
          placeholder="请输入部门"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="姓名" prop="employeeName">
        <el-input
          v-model="queryParams.employeeName"
          placeholder="请输入姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="人员编号" prop="employeeID">
        <el-input
          v-model="queryParams.employeeID"
          placeholder="请输入人员编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="缴费时间" prop="insuranceDate">
        <el-input
          v-model="queryParams.insuranceDate"
          placeholder="请输入缴费时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="是否增员" prop="isRecruiting">
        <el-input
          v-model="queryParams.isRecruiting"
          placeholder="请输入是否增员"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="是否减员" prop="isDepletion">
        <el-input
          v-model="queryParams.isDepletion"
          placeholder="请输入是否减员"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="基本医疗保险-个人" prop="healthySecuritySelf">
        <el-input
          v-model="queryParams.healthySecuritySelf"
          placeholder="请输入基本医疗保险-个人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="基本医疗保险-公司" prop="healthySecurityCompany">
        <el-input
          v-model="queryParams.healthySecurityCompany"
          placeholder="请输入基本医疗保险-公司"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="工伤保险" prop="injuryInsurance">
        <el-input
          v-model="queryParams.injuryInsurance"
          placeholder="请输入工伤保险"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="失业保险-个人" prop="unemploymentSecuritySelf">
        <el-input
          v-model="queryParams.unemploymentSecuritySelf"
          placeholder="请输入失业保险-个人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="失业保险-公司" prop="unemploymentSecurityCompany">
        <el-input
          v-model="queryParams.unemploymentSecurityCompany"
          placeholder="请输入失业保险-公司"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="养老保险-个人" prop="retirementSecuritySelf">
        <el-input
          v-model="queryParams.retirementSecuritySelf"
          placeholder="请输入养老保险-个人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="养老保险-公司" prop="retirementSecurityCompany">
        <el-input
          v-model="queryParams.retirementSecurityCompany"
          placeholder="请输入养老保险-公司"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="大额医保-个人" prop="largeMedicalSecuritySelf">
        <el-input
          v-model="queryParams.largeMedicalSecuritySelf"
          placeholder="请输入大额医保-个人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="大额医保-公司" prop="largeMedicalSecurityCompany">
        <el-input
          v-model="queryParams.largeMedicalSecurityCompany"
          placeholder="请输入大额医保-公司"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="公积金-个人" prop="housingFundSelf">
        <el-input
          v-model="queryParams.housingFundSelf"
          placeholder="请输入公积金-个人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="公积金-公司" prop="housingFundCompany">
        <el-input
          v-model="queryParams.housingFundCompany"
          placeholder="请输入公积金-公司"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="个人缴费总额" prop="sumSelf">
        <el-input
          v-model="queryParams.sumSelf"
          placeholder="请输入个人缴费总额"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="公司缴费总额" prop="sumCompany">
        <el-input
          v-model="queryParams.sumCompany"
          placeholder="请输入公司缴费总额"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="备注" prop="comments">
        <el-input
          v-model="queryParams.comments"
          placeholder="请输入备注"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="添加时间" prop="addtime">
        <el-input
          v-model="queryParams.addtime"
          placeholder="请输入添加时间"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="操作人员ID" prop="userId">
        <el-input
          v-model="queryParams.userId"
          placeholder="请输入操作人员ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="操作人员姓名" prop="UserName">
        <el-input
          v-model="queryParams.UserName"
          placeholder="请输入操作人员姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="删除标记" prop="delFlag">
        <el-input
          v-model="queryParams.delFlag"
          placeholder="请输入删除标记"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
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
          v-hasPermi="['system:socialInsurance:add']"
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
          v-hasPermi="['system:socialInsurance:edit']"
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
          v-hasPermi="['system:socialInsurance:remove']"
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
          v-hasPermi="['system:socialInsurance:export']"
        >导出
        </el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="socialInsuranceList" @selection-change="handleSelectionChange"
              v-horizontal-scroll="'always'">
      <el-table-column type="selection" width="55" align="center"/>
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="社保缴纳基数" align="center" prop="basicSocialInsurance"/>
      <el-table-column label="公积金基数" align="center" prop="basicHousingFund"/>
      <el-table-column label="部门" align="center" prop="depName"/>
      <el-table-column label="姓名" align="center" prop="employeeName"/>
      <el-table-column label="人员编号" align="center" prop="employeeID"/>
      <el-table-column label="缴费时间" align="center" prop="insuranceDate"/>
      <el-table-column label="是否增员" align="center" prop="isRecruiting"/>
      <el-table-column label="是否减员" align="center" prop="isDepletion"/>
      <el-table-column label="基本医疗保险-个人" align="center" prop="healthySecuritySelf"/>
      <el-table-column label="基本医疗保险-公司" align="center" prop="healthySecurityCompany"/>
      <el-table-column label="工伤保险" align="center" prop="injuryInsurance"/>
      <el-table-column label="失业保险-个人" align="center" prop="unemploymentSecuritySelf"/>
      <el-table-column label="失业保险-公司" align="center" prop="unemploymentSecurityCompany"/>
      <el-table-column label="养老保险-个人" align="center" prop="retirementSecuritySelf"/>
      <el-table-column label="养老保险-公司" align="center" prop="retirementSecurityCompany"/>
      <el-table-column label="大额医保-个人" align="center" prop="largeMedicalSecuritySelf"/>
      <el-table-column label="大额医保-公司" align="center" prop="largeMedicalSecurityCompany"/>
      <el-table-column label="公积金-个人" align="center" prop="housingFundSelf"/>
      <el-table-column label="公积金-公司" align="center" prop="housingFundCompany"/>
      <el-table-column label="个人缴费总额" align="center" prop="sumSelf"/>
      <el-table-column label="公司缴费总额" align="center" prop="sumCompany"/>
      <el-table-column label="备注" align="center" prop="comments"/>
      <!--      <el-table-column label="添加时间" align="center" prop="addtime"/>-->
      <!--      <el-table-column label="操作人员ID" align="center" prop="userId"/>-->
      <!--      <el-table-column label="操作人员姓名" align="center" prop="UserName"/>-->
      <!--      <el-table-column label="删除标记" align="center" prop="delFlag"/>-->
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:socialInsurance:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:socialInsurance:remove']"
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

    <!-- 添加或修改社保基金对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="社保缴纳基数" prop="basicSocialInsurance">
          <el-input v-model="form.basicSocialInsurance" placeholder="请输入社保缴纳基数"/>
        </el-form-item>
        <el-form-item label="公积金基数" prop="basicHousingFund">
          <el-input v-model="form.basicHousingFund" placeholder="请输入公积金基数"/>
        </el-form-item>
        <el-form-item label="部门" prop="depName">
          <el-input v-model="form.depName" placeholder="请输入部门"/>
        </el-form-item>
        <el-form-item label="姓名" prop="employeeName">
          <el-input v-model="form.employeeName" placeholder="请输入姓名"/>
        </el-form-item>
        <el-form-item label="人员编号" prop="employeeID">
          <el-input v-model="form.employeeID" placeholder="请输入人员编号"/>
        </el-form-item>
        <el-form-item label="缴费时间" prop="insuranceDate">
          <el-input v-model="form.insuranceDate" placeholder="请输入缴费时间"/>
        </el-form-item>
        <el-form-item label="是否增员" prop="isRecruiting">
          <el-input v-model="form.isRecruiting" placeholder="请输入是否增员"/>
        </el-form-item>
        <el-form-item label="是否减员" prop="isDepletion">
          <el-input v-model="form.isDepletion" placeholder="请输入是否减员"/>
        </el-form-item>
        <el-form-item label="基本医疗保险-个人" prop="healthySecuritySelf">
          <el-input v-model="form.healthySecuritySelf" placeholder="请输入基本医疗保险-个人"/>
        </el-form-item>
        <el-form-item label="基本医疗保险-公司" prop="healthySecurityCompany">
          <el-input v-model="form.healthySecurityCompany" placeholder="请输入基本医疗保险-公司"/>
        </el-form-item>
        <el-form-item label="工伤保险" prop="injuryInsurance">
          <el-input v-model="form.injuryInsurance" placeholder="请输入工伤保险"/>
        </el-form-item>
        <el-form-item label="失业保险-个人" prop="unemploymentSecuritySelf">
          <el-input v-model="form.unemploymentSecuritySelf" placeholder="请输入失业保险-个人"/>
        </el-form-item>
        <el-form-item label="失业保险-公司" prop="unemploymentSecurityCompany">
          <el-input v-model="form.unemploymentSecurityCompany" placeholder="请输入失业保险-公司"/>
        </el-form-item>
        <el-form-item label="养老保险-个人" prop="retirementSecuritySelf">
          <el-input v-model="form.retirementSecuritySelf" placeholder="请输入养老保险-个人"/>
        </el-form-item>
        <el-form-item label="养老保险-公司" prop="retirementSecurityCompany">
          <el-input v-model="form.retirementSecurityCompany" placeholder="请输入养老保险-公司"/>
        </el-form-item>
        <el-form-item label="大额医保-个人" prop="largeMedicalSecuritySelf">
          <el-input v-model="form.largeMedicalSecuritySelf" placeholder="请输入大额医保-个人"/>
        </el-form-item>
        <el-form-item label="大额医保-公司" prop="largeMedicalSecurityCompany">
          <el-input v-model="form.largeMedicalSecurityCompany" placeholder="请输入大额医保-公司"/>
        </el-form-item>
        <el-form-item label="公积金-个人" prop="housingFundSelf">
          <el-input v-model="form.housingFundSelf" placeholder="请输入公积金-个人"/>
        </el-form-item>
        <el-form-item label="公积金-公司" prop="housingFundCompany">
          <el-input v-model="form.housingFundCompany" placeholder="请输入公积金-公司"/>
        </el-form-item>
        <el-form-item label="个人缴费总额" prop="sumSelf">
          <el-input v-model="form.sumSelf" placeholder="请输入个人缴费总额"/>
        </el-form-item>
        <el-form-item label="公司缴费总额" prop="sumCompany">
          <el-input v-model="form.sumCompany" placeholder="请输入公司缴费总额"/>
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
import {
  listSocialInsurance,
  getSocialInsurance,
  delSocialInsurance,
  addSocialInsurance,
  updateSocialInsurance
} from "@/api/system/socialInsurance";

export default {
  name: "SocialInsurance",
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
      // 社保基金表格数据
      socialInsuranceList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        basicSocialInsurance: null,
        basicHousingFund: null,
        depName: null,
        employeeName: null,
        employeeID: null,
        insuranceDate: null,
        isRecruiting: null,
        isDepletion: null,
        healthySecuritySelf: null,
        healthySecurityCompany: null,
        injuryInsurance: null,
        unemploymentSecuritySelf: null,
        unemploymentSecurityCompany: null,
        retirementSecuritySelf: null,
        retirementSecurityCompany: null,
        largeMedicalSecuritySelf: null,
        largeMedicalSecurityCompany: null,
        housingFundSelf: null,
        housingFundCompany: null,
        sumSelf: null,
        sumCompany: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
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
    /** 查询社保基金列表 */
    getList() {
      this.loading = true;
      listSocialInsurance(this.queryParams).then(response => {
        this.socialInsuranceList = response.rows;
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
        basicSocialInsurance: null,
        basicHousingFund: null,
        depName: null,
        employeeName: null,
        employeeID: null,
        insuranceDate: null,
        isRecruiting: null,
        isDepletion: null,
        healthySecuritySelf: null,
        healthySecurityCompany: null,
        injuryInsurance: null,
        unemploymentSecuritySelf: null,
        unemploymentSecurityCompany: null,
        retirementSecuritySelf: null,
        retirementSecurityCompany: null,
        largeMedicalSecuritySelf: null,
        largeMedicalSecurityCompany: null,
        housingFundSelf: null,
        housingFundCompany: null,
        sumSelf: null,
        sumCompany: null,
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
      this.title = "添加社保基金";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getSocialInsurance(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改社保基金";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateSocialInsurance(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addSocialInsurance(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除社保基金编号为"' + ids + '"的数据项？').then(function () {
        return delSocialInsurance(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/socialInsurance/export', {
        ...this.queryParams
      }, `socialInsurance_${new Date().getTime()}.xlsx`)
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
